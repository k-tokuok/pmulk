/*
	view for X.
	$Id: mulk viewx.c 1347 2025-01-09 Thu 22:11:51 kt $
*/
#include "std.h"

#include <signal.h>
#include <locale.h>
#include <string.h>

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>

#if XFT_P
#include <X11/Xft/Xft.h>
#endif

#include "mem.h"
#include "iqueue.h"
#include "view.h"
#include "xwchar.h"

#include "om.h"
#include "ip.h"

static Display *display;
static Window window;
static XSizeHints *hints;
static Atom wm_protocols,wm_delete_window;

#define XIM_P TRUE
#if XIM_P
static XIM xim;
static XIC xic;
#endif

static int view_width;
static int view_height;
static GC gc;
static Pixmap pixmap;

static int update_count;
static int update_left,update_top,update_right,update_bottom;

static XFontSet fontset;

#if XFT_P
static XftFont *xftfont;
static Colormap colormap;
static XftDraw *draw;
#endif

static int font_ascent;

static struct iqueue queue;
static int left_mod_p,right_mod_p,space_mod_p,type_space_p;

static void put_queue(int val)
{
	iqueue_put(&queue,val);
}

static void put_queue_key(int ch)
{
	put_queue(VEVENT_CHAR|(ch<<VEVENT_OPR_OFF));
}

static void put_queue_ptr(int type,XEvent *event)
{
	put_queue(type
		|(coord(event->xbutton.x,event->xbutton.y)<<VEVENT_OPR_OFF));
}

static int mod_key_p(KeySym key)
{
	if(key==XK_Muhenkan) return TRUE;
	if(key==XK_Henkan) return TRUE;
	if(view_shift_mode==VIEW_SPACE_SHIFT&&key==XK_space) return TRUE;
	return FALSE;
}

static KeySym left_keys[]={
	XK_1, XK_2, XK_3, XK_4, XK_5,
	XK_q, XK_w, XK_e, XK_r, XK_t,
	XK_a, XK_s, XK_d, XK_f, XK_g,
	XK_z, XK_x, XK_c, XK_v, XK_b
};

static int left_key_p(KeySym key)
{
	int i;
	for(i=0;i<sizeof(left_keys)/sizeof(KeySym);i++) {
		if(left_keys[i]==key) return TRUE;
	}
	return FALSE;
}

void process_event(int wait_p)
{
	int n,i,autorepeat_p;
	XEvent event,event2;
	KeySym key;
	char ch;
	
	n=XPending(display);
	if(wait_p&&n==0) n=1;
	for(i=0;i<n;i++) {
		XNextEvent(display,&event);
#if XIM_P
		if(XFilterEvent(&event,None)) continue;
#endif
		if(event.type==DestroyNotify) break;
		switch(event.type) {
		case Expose:
			XCopyArea(display,pixmap,window,gc,
				event.xexpose.x,event.xexpose.y,
				event.xexpose.width,event.xexpose.height,
				event.xexpose.x,event.xexpose.y);
			break;
		case ClientMessage:
			if(event.xclient.message_type==wm_protocols
				&&event.xclient.data.l[0]==wm_delete_window) {
				/* close button */
				ip_trap_code=TRAP_QUIT;
				put_queue_key(0);
			}
			break;
		case KeyPress:
			key=XLookupKeysym(&event.xkey,0);
			if(mod_key_p(key)) {
				if(key==XK_Muhenkan) left_mod_p=TRUE;
				if(key==XK_Henkan) right_mod_p=TRUE;
				if(key==XK_space) {
					space_mod_p=TRUE;
					type_space_p=TRUE;
				}
			} else {
				if(view_shift_mode==VIEW_CROSS_SHIFT) {
					if(key==XK_space) {
						if(left_mod_p||right_mod_p) {
							event.xkey.state|=ControlMask;
						}
					} else {
						if(left_mod_p) {
							if(left_key_p(key)) event.xkey.state|=ControlMask;
							else event.xkey.state|=ShiftMask;
						}
						if(right_mod_p) {
							if(left_key_p(key)) event.xkey.state|=ShiftMask;
							else event.xkey.state|=ControlMask;
						}
					}
				} else {
					if(left_mod_p||right_mod_p) event.xkey.state|=ControlMask;
					if(space_mod_p) {
						type_space_p=FALSE;
						event.xkey.state=ShiftMask;
					}
				}

#if XIM_P
				{
					char buf[MAX_STR_LEN];
					Status st;
					int i,len;
					len=Xutf8LookupString(xic,&event.xkey,buf,sizeof(buf)-1,
						&key,&st);
					if(st==XLookupChars) {
						for(i=0;i<len;i++) put_queue_key(LC(&buf[i]));
						break;
					}
				}
#endif
				XLookupString(&event.xkey,&ch,1,&key,NULL);
				if(ch!=0||key==XK_space||key==XK_at) {
					if(ch==3) raise(SIGINT);
					put_queue_key(ch);
				}
			}
			break;
		case KeyRelease:	
			key=XLookupKeysym(&event.xkey,0);
			
			if(mod_key_p(key)) {
				autorepeat_p=FALSE;
				if(XEventsQueued(display,QueuedAfterReading)) {
					XPeekEvent(display,&event2);
					autorepeat_p=event2.type==KeyPress
						&&event2.xkey.time==event.xkey.time
						&&event2.xkey.keycode==event.xkey.keycode;
					if(autorepeat_p) XNextEvent(display,&event2);
				}

				if(!autorepeat_p) {
					if(key==XK_Muhenkan) left_mod_p=FALSE;
					if(key==XK_Henkan) right_mod_p=FALSE;
					if(key==XK_space) {
						space_mod_p=FALSE;
						if(type_space_p) {
							if(left_mod_p||right_mod_p) put_queue_key(0);
							else put_queue_key(' ');
						}
					}
				}
			}
			break;
		case ButtonPress:
			if(view_event_filter&&event.xbutton.button==1) {
				put_queue_ptr(VEVENT_PTRDOWN,&event);
			}
			break;
		case MotionNotify:
			if(view_event_filter) put_queue_ptr(VEVENT_PTRDRAG,&event);
			break;
		case ButtonRelease:
			if(view_event_filter&&event.xbutton.button==1) {
				put_queue_ptr(VEVENT_PTRUP,&event);
			}
			break;
		default: 
			break;
		}
	}
}

static void expose()
{
	XExposeEvent ev;
	if(update_count==0) return;
	ev.type=Expose;
	ev.serial=0;
	ev.send_event=TRUE;
	ev.display=display;
	ev.window=window;
	ev.x=update_left;
	ev.y=update_top;
	ev.width=update_right-update_left+1;
	ev.height=update_bottom-update_top+1;
	ev.count=0;

	XSendEvent(display,window,True,ExposureMask,(XEvent*)&ev);
	process_event(FALSE);
	update_count=0;
}

static void update(int l,int t,int w,int h)
{
	int r,b;
	r=l+w-1;
	b=t+h-1;
	if(update_count==0) {
		update_left=l;
		update_top=t;
		update_right=r;
		update_bottom=b;
	} else {
		if(update_left>l) update_left=l;
		if(update_top>t) update_top=t;
		if(update_right<r) update_right=r;
		if(update_bottom<b) update_bottom=b;
	}
	update_count++;
	if(update_count>view_update_interval) expose();
}

/* intr */

void ip_intr_check(void)
{
	if(display!=NULL) process_event(FALSE);
}

/* viewp */

static void set_hint(void)
{
	hints->min_width=hints->max_width=view_width;
	hints->min_height=hints->max_height=view_height;
	XSetWMNormalHints(display,window,hints);
}

static void create_pixmap(void)
{
	pixmap=XCreatePixmap(display,window,view_width,view_height,
		DefaultDepth(display,0));
#if XFT_P
	draw=XftDrawCreate(display,pixmap,DefaultVisual(display,0),colormap);
#endif
}

void view_init(void)
{
	if(setlocale(LC_ALL,"")==NULL) xerror("setlocale failed.");
	if(!XSupportsLocale()) xerror("XSupportsLocale failed.");
	XSetLocaleModifiers("");
	if((display=XOpenDisplay(NULL))==NULL) xerror("XOpenDisplay failed.");
}

void view_open(int width,int height)
{
	view_width=width;
	view_height=height;
	
	window=XCreateSimpleWindow(display,DefaultRootWindow(display),
		50,50,view_width,view_height,2,
		BlackPixel(display,0),WhitePixel(display,0));
	XSetStandardProperties(display,window,"mulkView","mulkView",None,
		NULL,0,NULL);
	
#if XIM_P
	xim=XOpenIM(display,0,0,0);
	if(xim==NULL) xerror("XOpenIM failed");
	xic=XCreateIC(xim,XNInputStyle,XIMPreeditNothing|XIMStatusNothing,
		XNClientWindow,window,XNFocusWindow,window,NULL);
	XSetICFocus(xic);
#endif

	hints=XAllocSizeHints();
	hints->flags=PMinSize|PMaxSize;
	set_hint();
	
	wm_protocols=XInternAtom(display,"WM_PROTOCOLS",False);
	wm_delete_window=XInternAtom(display,"WM_DELETE_WINDOW",False);
	XSetWMProtocols(display,window,&wm_delete_window,1);
	
	fontset=NULL;
	
	gc=XCreateGC(display,window,0,NULL);
#if XFT_P
	colormap=DefaultColormap(display,0);
	xftfont=NULL;
#endif
	create_pixmap();
	update_count=0;
	
	XSelectInput(display,window,ExposureMask|KeyPressMask|KeyReleaseMask
		|ButtonPressMask|Button1MotionMask|ButtonReleaseMask);
	
	iqueue_reset(&queue);
	view_event_filter=0;
	view_shift_mode=VIEW_CROSS_SHIFT;
	XMapRaised(display,window);
}

static void free_font(void)
{
	if(fontset!=NULL) {
		XFreeFontSet(display,fontset);
		fontset=NULL;
	}
#if XFT_P
	if(xftfont!=NULL) {
		XftFontClose(display,xftfont);
		xftfont=NULL;
	}
#endif
}

#if XFT_P
static int set_xftfont(char *name)
{
	XGlyphInfo glyph;
	if((xftfont=XftFontOpenName(display,0,name+1))==NULL) {
		xerror("XftFontOpenName failed.");
	}
	XftTextExtents8(display,xftfont,(FcChar8*)"a",1,&glyph);
	font_ascent=xftfont->ascent;
	return coord(glyph.xOff,xftfont->ascent+xftfont->descent+1);
}
#endif

static int set_fontset(char *name)
{
	char **missing,*def_return;
	int missing_count,i,n,fw,fh;
	XFontStruct **fslist,*fs;
	char **fnlist;
	
	fontset=XCreateFontSet(display,name,&missing,&missing_count,
		&def_return);
	if(fontset==NULL) xerror("XCreateFontSet failed.");

	n=XFontsOfFontSet(fontset,&fslist,&fnlist);
	fs=fslist[0];
	font_ascent=fs->ascent;
	fw=fs->max_bounds.width;
	fh=font_ascent+fs->descent;
	
	for(i=1;i<n;i++) {
		fs=fslist[i];
		if(font_ascent<fs->ascent) font_ascent=fs->ascent;
		if(fw>fs->max_bounds.width) fw=fs->max_bounds.width;
		if(fh<fs->ascent+fs->descent) fh=fs->ascent+fs->descent;
	}
	return coord(fw,fh+1);
}

int view_set_font(char *font_name)
{
	free_font();
#if XFT_P
	if(*font_name=='*') return set_xftfont(font_name);
#endif
	return set_fontset(font_name);
}

static void free_pixmap(void)
{
#if XFT_P
	XftDrawDestroy(draw);
#endif
	XFreePixmap(display,pixmap);
}

void view_close(void)
{
#if XIM_P
	XDestroyIC(xic);
	XCloseIM(xim);
#endif
	XDestroyWindow(display,window);
	XFree(hints);
	free_pixmap();
	free_font();
	XFreeGC(display,gc);
}

void view_finish(void)
{
	XCloseDisplay(display);
	display=NULL;
}

void view_fill_rectangle(int x,int y,int width,int height,int color)
{
	XSetForeground(display,gc,color);
	XFillRectangle(display,pixmap,gc,x,y,width,height);
	update(x,y,width,height);
}

void view_draw_char(int x,int y,uint64_t wc,int color)
{
	char buf[XWCHAR_MAX_LEN];
	int buflen;
	XRectangle extents;
	
	buflen=xwchar_to_mbytes(wc,buf);
#if XFT_P
	if(xftfont!=NULL) {
		XftColor ftc;
		XRenderColor rc;
		XGlyphInfo glyph;
		rc.red=((color>>16)&0xff)*0x101;
		rc.green=((color>>8)&0xff)*0x101;
		rc.blue=(color&0xff)*0x101;
		rc.alpha=0xffff;
		XftColorAllocValue(display,DefaultVisual(display,0),colormap,&rc,
			&ftc);
		XftDrawStringUtf8(draw,&ftc,xftfont,x,y+font_ascent,(FcChar8*)buf,
			buflen);
		XftTextExtentsUtf8(display,xftfont,(FcChar8*)buf,buflen,&glyph);
		XftColorFree(display,DefaultVisual(display,0),colormap,&ftc);
		update(x-glyph.x,y+font_ascent-glyph.y,glyph.width,glyph.height);
		return;
	}
#endif 
	XSetForeground(display,gc,color);
	XmbDrawString(display,pixmap,fontset,gc,x,y+font_ascent,buf,buflen);
	XmbTextExtents(fontset,buf,buflen,NULL,&extents);
	update(x+extents.x,y+font_ascent+extents.y,extents.width,extents.height);
}

void view_draw_line(int x0,int y0,int x1,int y1,int color)
{
	int x,y,w,h;
	
	XSetForeground(display,gc,color);
	XDrawLine(display,pixmap,gc,x0,y0,x1,y1);

	if(x0>x1) {
		x=x1;
		w=x0-x1+1;
	} else {
		x=x0;
		w=x1-x0+1;
	}

	if(y0>y1) {
		y=y1;
		h=y0-y1+1;
	} else {
		y=y0;
		h=y1-y0+1;
	}
	
	update(x,y,w,h);
}

void view_put_true_color_image(int x,int y,char *rgb,int w,int h)
{
	Visual *visual;
	XImage *image;
	char *bgrx,*p,*q;
	int i;
	visual=DefaultVisual(display,0);
	if(visual->class!=TrueColor) xerror("display not support truecolor.");
	bgrx=xmalloc(w*h*4);
	p=rgb;
	q=bgrx;
	for(i=0;i<w*h;i++) {
		q[0]=p[2];
		q[1]=p[1];
		q[2]=p[0];
		q[3]=0;
		p+=3;
		q+=4;
	}
	
	image=XCreateImage(display,visual,24,ZPixmap,0,bgrx,w,h,32,0);
	XPutImage(display,pixmap,gc,image,0,0,x,y,w,h);
	XDestroyImage(image);
	update(x,y,w,h);
}

void view_draw_polygon(int *pts,int n,int color)
{
	XPoint points[VIEW_MAX_POLYGON_POINT];
	int left,right,top,bottom,i,x,y;
	
	left=right=top=bottom=0;
	for(i=0;i<n;i++) {
		x=pts[i*2];
		y=pts[i*2+1];
		if(i==0) {
			left=right=x;
			top=bottom=y;
		} else {
			if(left>x) left=x;
			if(right<x) right=x;
			if(top>y) top=y;
			if(bottom<y) bottom=y;
		}
		points[i].x=x;
		points[i].y=y;
	}		
	XSetForeground(display,gc,color);
	XFillPolygon(display,pixmap,gc,points,n,Complex,CoordModeOrigin);
	update(left,top,right-left+1,bottom-top+1);
}

void view_put_monochrome_image(int x,int y,char *bits,int w,int h,
	int color,int bkcolor)
{
	Visual *visual;
	XImage *image;
	int sz;
	char *xbits;
	
	sz=(w+15)/16*2*h;
	xbits=xmalloc(sz);
	memcpy(xbits,bits,sz);
	visual=DefaultVisual(display,0);
	image=XCreateImage(display,visual,1,XYBitmap,0,xbits,w,h,16,0);
	image->byte_order=MSBFirst;
	image->bitmap_bit_order=MSBFirst;
	XInitImage(image);
	XSetForeground(display,gc,color);
	XSetBackground(display,gc,bkcolor);
	XPutImage(display,pixmap,gc,image,0,0,x,y,w,h);
	XDestroyImage(image);
	update(x,y,w,h);
}

void view_load_keymap(char *fn)
{
	/* do nothing */
}

int view_get_event(void)
{
	expose();
	while(iqueue_empty_p(&queue)) process_event(TRUE);
	return iqueue_get(&queue);
}

int view_event_empty_p(void)
{
	expose();
	process_event(FALSE);
	return iqueue_empty_p(&queue);
}

int view_get_position(void)
{
	XWindowAttributes attr;
	Window w;
	int x,y;
	XGetWindowAttributes(display,window,&attr);
	XTranslateCoordinates(display,window,DefaultRootWindow(display),
		attr.x,attr.y,&x,&y,&w);
	return coord(x,y);
}

void view_set_position(int coord)
{
	XMoveWindow(display,window,COORD_X(coord),COORD_Y(coord));
}

void view_set_size(int coord)
{
	view_width=COORD_X(coord);
	view_height=COORD_Y(coord);
	
	XResizeWindow(display,window,view_width,view_height);
	set_hint();
	free_pixmap();
	create_pixmap();
}

int view_get_screen_size(void)
{
	int s;
	s=DefaultScreen(display);
	return coord(DisplayWidth(display,s),DisplayHeight(display,s));
}

int view_get_frame_size(void)
{
	Atom netFrameExtents,actualType;
	unsigned long *frameExtents;
	int actualFormat,result;
	unsigned long nItems,bytesAfter;
	
	netFrameExtents=XInternAtom(display,"_NET_FRAME_EXTENTS",True);
	XGetWindowProperty(display,window,netFrameExtents,0,4,False,
		AnyPropertyType,&actualType,&actualFormat,&nItems,&bytesAfter,
		(unsigned char**)&frameExtents);
	result=coord(view_width+frameExtents[0]+frameExtents[1],
		view_height+frameExtents[2]+frameExtents[3]);
	XFree(frameExtents);
	return result;
}
