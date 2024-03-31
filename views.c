/*
	view for sdl.
	$Id: mulk views.c 1197 2024-03-31 Sun 21:48:00 kt $
*/

#include "std.h"

#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>

#include "iqueue.h"
#include "xwchar.h"
#include "viewp.h"
#include "intr.h"
#include "ki.h"
#include "kidec.h"
#include "csplit.h"
#include "om.h"
#include "ip.h"

static int init_p=FALSE;
static SDL_Window *window;
static SDL_Renderer *renderer;
static int update_count;

static TTF_Font *font;

static struct iqueue queue;
static int vevent_filter;
static struct kidec kidec;

static void put_queue(int val)
{
	iqueue_put(&queue,val);
}

static void put_queue_key(int ch)
{
	put_queue(VEVENT_CHAR|(ch<<VEVENT_OPR_OFF));
}

static void put_queue_ptr(int type,int x,int y)
{
	put_queue(type|(coord(x,y)<<VEVENT_OPR_OFF));
}

void process_event(int wait_p)
{
	SDL_Event event;
	int ch;
	
	while(TRUE) {
		if(wait_p) SDL_WaitEvent(&event);
		else if(SDL_PollEvent(&event)==0) break;
		switch(event.type) {
		case SDL_QUIT:
			ip_trap_code=TRAP_QUIT;
			put_queue_key(0);
			break;
		case SDL_KEYDOWN:
			ch=kidec_down(&kidec,event.key.keysym.scancode);
			if(ch!=-1) {
				put_queue_key(ch);
				if(ch==3) ip_trap_code=TRAP_INTERRUPT;
			}
			break;
		case SDL_KEYUP:
			ch=kidec_up(&kidec,event.key.keysym.scancode);
			if(ch!=-1) put_queue_key(ch);
			break;
		case SDL_MOUSEBUTTONDOWN:
			if(vevent_filter&&event.button.button==SDL_BUTTON_LEFT) {
				put_queue_ptr(VEVENT_PTRDOWN,event.button.x,event.button.y);
			}
			break;
		case SDL_MOUSEMOTION:
			if(vevent_filter&&(event.motion.state&SDL_BUTTON_LMASK)) {
				put_queue_ptr(VEVENT_PTRDRAG,event.motion.x,event.motion.y);
			}
			break;
		case SDL_MOUSEBUTTONUP:
			if(vevent_filter&&event.button.button==SDL_BUTTON_LEFT) {
				put_queue_ptr(VEVENT_PTRUP,event.button.x,event.button.y);
			}
			break;
		default:
			break;
		}
		wait_p=FALSE;
	}
}

void intr_check(void)
{
	if(window!=NULL) process_event(FALSE);
}

/* api */

static void quit_all(void)
{
	TTF_Quit();
	SDL_Quit();
}

static int press_check(int key)
{
	const Uint8 *keystates;
	keystates=SDL_GetKeyboardState(NULL);
	switch(key) {
	case KI_SHIFT: 
		return keystates[SDL_SCANCODE_LSHIFT]||keystates[SDL_SCANCODE_RSHIFT];
	case KI_CTRL:
		return keystates[SDL_SCANCODE_RCTRL]||keystates[SDL_SCANCODE_LCTRL];
	case KI_CONVERT: return keystates[SDL_SCANCODE_INTERNATIONAL4];
	case KI_NONCONVERT: return keystates[SDL_SCANCODE_INTERNATIONAL5];
	default: return 0;
	}
}

void view_open(int width,int height)
{
	if(!init_p) {
		SDL_Init(SDL_INIT_VIDEO);
		TTF_Init();
		atexit(quit_all);
		kidec.mode=KI_CROSS_SHIFT;
		kidec.press_check=press_check;
		init_p=TRUE;
	}
	
	window=SDL_CreateWindow("mulkView",
		SDL_WINDOWPOS_UNDEFINED,SDL_WINDOWPOS_UNDEFINED,width,height,0);
	renderer=SDL_CreateRenderer(window,-1,SDL_RENDERER_SOFTWARE);
	update_count=0;
	iqueue_reset(&queue);
	vevent_filter=0;
}

void view_move(int x,int y)
{
	SDL_SetWindowPosition(window,x,y);
}

static void close_font(void)
{
	if(font!=NULL) TTF_CloseFont(font);
	font=NULL;
}

int view_set_font(char *font_name)
{
	int sz,w,ncol;
	char *cols[2];
	
	close_font();
	
	ncol=csplit(font_name,cols,2);
	if(ncol==2) sz=atoi(cols[1]);
	else sz=16;
	if((font=TTF_OpenFont(cols[0],sz))==NULL) {
		xerror("TTF_OpenFont %s failed.",font_name);
	}
	TTF_SizeText(font,"x",&w,NULL);
	return coord(w,TTF_FontLineSkip(font));
}

void view_resize(int width,int height)
{
	SDL_SetWindowSize(window,width,height);
}

void view_close(void)
{
	close_font();
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	window=NULL;
}

static void set_draw_color(int color_code)
{
	SDL_SetRenderDrawColor(renderer,
		(color_code>>16)&0xff,(color_code>>8)&0xff,color_code&0xff,
		SDL_ALPHA_OPAQUE);
}

static void set_rect(SDL_Rect *rect,int x,int y,int w,int h)
{
	rect->x=x;
	rect->y=y;
	rect->w=w;
	rect->h=h;
}

static void present(void)
{
	if(update_count==0) return;
	SDL_RenderPresent(renderer);
	update_count=0;
}

static void update(void)
{
	update_count++;
	if(update_count>=view_update_interval) present();
}

void view_fill_rectangle(int x,int y,int width,int height,int color_code)
{
	SDL_Rect rect;

	set_draw_color(color_code);
	set_rect(&rect,x,y,width,height);
	SDL_RenderFillRect(renderer,&rect);
	update();
}

#if WINDOWS_P
#include <windows.h>
#include "codepage.h"

static int wchar_to_utf8(uint64_t wc,char *buf)
{
	char sjisbuf[XWCHAR_MAX_LEN];
	WCHAR utf16buf[2];
	int sjislen,utf16len,utf8len;
	
	if(codepage==CP_UTF8||wc<0x7f) return xwchar_to_mbytes(wc,buf);
	
	sjislen=xwchar_to_mbytes(wc,sjisbuf);
	utf16len=MultiByteToWideChar(codepage,0,sjisbuf,sjislen,utf16buf,
		sizeof(utf16buf));
	if(utf16len==0) xerror("MultiByteToWideChar failed.");
	utf8len=WideCharToMultiByte(CP_UTF8,0,utf16buf,utf16len,buf,XWCHAR_MAX_LEN,
		NULL,NULL);
	if(utf8len==0) xerror("WideCharToMultiByte failed.");
	return utf8len;
}
#endif

void set_color(SDL_Color *color,int color_code)
{
	color->r=(color_code>>16)&0xff;
	color->g=(color_code>>8)&0xff;
	color->b=color_code&0xff;
	color->a=SDL_ALPHA_OPAQUE;
}

void view_draw_char(int x,int y,uint64_t wc,int color_code)
{
	char buf[XWCHAR_MAX_LEN+1];
	int buflen;
	SDL_Color color;
	SDL_Surface *surface;
	SDL_Texture *texture;
	SDL_Rect src_rect,dest_rect;
	
#if WINDOWS_P
	buflen=wchar_to_utf8(wc,buf);
#else
	buflen=xwchar_to_mbytes(wc,buf);
#endif
	buf[buflen]='\0';
	set_color(&color,color_code);
	surface=TTF_RenderUTF8_Blended(font,buf,color);
	texture=SDL_CreateTextureFromSurface(renderer,surface);
	set_rect(&src_rect,0,0,surface->w,surface->h);
	set_rect(&dest_rect,x,y,surface->w,surface->h);
	SDL_RenderCopy(renderer,texture,&src_rect,&dest_rect);
	SDL_DestroyTexture(texture);
	SDL_FreeSurface(surface);
	update();
}

void view_draw_line(int x0,int y0,int x1,int y1,int color_code)
{
	set_draw_color(color_code);
	SDL_RenderDrawLine(renderer,x0,y0,x1,y1);
	update();
}

void view_put_true_color_image(int x,int y,char *rgb,int w,int h)
{
	SDL_Texture *texture;
	SDL_Rect rect,dest_rect;
	texture=SDL_CreateTexture(renderer,SDL_PIXELFORMAT_RGB24,
		SDL_TEXTUREACCESS_STATIC,w,h);
	set_rect(&rect,0,0,w,h);
	SDL_UpdateTexture(texture,&rect,rgb,w*3);
	set_rect(&dest_rect,x,y,w,h);
	SDL_RenderCopy(renderer,texture,&rect,&dest_rect);
	SDL_DestroyTexture(texture);
	update();
}

void view_draw_polygon(int *pts,int n,int color_code)
{
	int xs[VIEW_MAX_POLYGON_POINT];
	int i,i2,i2n,j,k,t,y,y0,y1,top,bottom;
	double dx,dy,slope[VIEW_MAX_POLYGON_POINT];
	
	set_draw_color(color_code);
	
	top=bottom=pts[1];
	for(i=1;i<n;i++) {
		y=pts[i*2+1];
		if(top>y) top=y;
		if(bottom<y) bottom=y;
	}
	
	for(i=0;i<n;i++) {
		i2=i*2;
		i2n=((i+1)%n)*2;
		dx=pts[i2n]-pts[i2];
		dy=pts[i2n+1]-pts[i2+1];
		if(dy==0) slope[i]=1;
		else if(dx==0) slope[i]=0;
		else slope[i]=dx/dy;
	}
	for(y=top;y<=bottom;y++) {
		k=0;
		for(i=0;i<n;i++) {
			y0=pts[i*2+1];
			y1=pts[((i+1)%n)*2+1];
			if((y0<=y&&y<y1)||(y1<=y&&y<y0)) {
				xs[k++]=(int)(pts[i*2]+slope[i]*(y-y0));
			}
		}
		for(i=0;i<k-1;i++) {
			for(j=i;j<k;j++) {
				if(xs[i]>xs[j]) {
					t=xs[i];
					xs[i]=xs[j];
					xs[j]=t;
				}
			}
		}
		for(i=0;i<k;i+=2) SDL_RenderDrawLine(renderer,xs[i],y,xs[i+1],y);
	}
	update();
}

void view_put_monochrome_image(int x,int y,char *bits,int w,int h,int fg_code,
	int bg_code)
{
	SDL_Surface *surface;
	SDL_Palette *palette;
	SDL_Color colors[2];
	SDL_Texture *texture;
	SDL_Rect src_rect,dest_rect;
	
	surface=SDL_CreateRGBSurfaceWithFormatFrom(bits,w,h,1,(w+15)/16*2,
		SDL_PIXELFORMAT_INDEX1LSB);
	palette=SDL_AllocPalette(2);
	set_color(&colors[1],fg_code);
	set_color(&colors[0],bg_code);
	SDL_SetPaletteColors(palette,colors,0,2);
	SDL_SetSurfacePalette(surface,palette);
	texture=SDL_CreateTextureFromSurface(renderer,surface);
	SDL_FreePalette(palette);
	SDL_FreeSurface(surface);
	set_rect(&src_rect,0,0,w,h);
	set_rect(&dest_rect,x,y,w,h);
	SDL_RenderCopy(renderer,texture,&src_rect,&dest_rect);
	SDL_DestroyTexture(texture);
	update();
}

void view_load_keymap(char *fn)
{
	kidec_load_keymap(&kidec,fn,KI_SDL);
}

int view_set_shift_mode(int mode)
{
	if(!kidec_keymap_loaded_p(&kidec)) return FALSE;
	kidec.mode=mode;
	return TRUE;
}

void view_set_event_filter(int mode)
{
	vevent_filter=mode;
}

int view_get_event(void)
{
	present();
	while(iqueue_empty_p(&queue)) process_event(TRUE);
	return iqueue_get(&queue);
}

int view_event_empty_p(void)
{
	present();
	process_event(FALSE);
	return iqueue_empty_p(&queue);
}
