/*
	view for windows.
	$Id: mulk vieww.c 1366 2025-02-04 Tue 22:02:09 kt $
*/

#include "std.h"

#include <windows.h>
#include <windowsx.h>

#include "iqueue.h"
#include "xwchar.h"

#include "om.h"
#include "ip.h"

#include "view.h"
#include "vkey.h"
#include "csplit.h"

static HWND window;
static HBITMAP bitmap;
static int invalid_count;
static RECT invalid_rect;
static HDC bitmap_dc;
static HFONT font,jfont;

static int view_width,view_height;

static struct iqueue vevent_queue;
static int more_char_p;

static void vevent_queue_put(int val)
{
	iqueue_put(&vevent_queue,val);
}

static void key_queue_put(int ch)
{
	vevent_queue_put(VEVENT_CHAR|(ch<<VEVENT_OPR_OFF));
}

static void ptr_queue_put(int type,LPARAM lParam)
{
	vevent_queue_put(type
		|(coord(GET_X_LPARAM(lParam),GET_Y_LPARAM(lParam))<<VEVENT_OPR_OFF));
}

static LRESULT CALLBACK window_proc(HWND hWnd,UINT msg,WPARAM wParam,
	LPARAM lParam)
{
	HDC dc;
	PAINTSTRUCT ps;
	int ch;

	switch(msg) {
	case WM_CLOSE:
		ip_trap_code=TRAP_QUIT;
		key_queue_put(0); /* for exit process_event loop */
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	case WM_PAINT:
		dc=BeginPaint(hWnd,&ps);
		BitBlt(dc,ps.rcPaint.left,ps.rcPaint.top,ps.rcPaint.right,
			ps.rcPaint.bottom,bitmap_dc,ps.rcPaint.left,ps.rcPaint.top,SRCCOPY);
		EndPaint(hWnd,&ps);
		break;
	case WM_CHAR:
		ch=(int)wParam;
		if(more_char_p) more_char_p=FALSE;
		else if(IsDBCSLeadByte(ch)) more_char_p=TRUE;
		else {
			if(view_shift_mode==VIEW_GENERIC_SHIFT) {
				if(ch==' '&&(GetKeyState(VK_CONTROL)&0x8000)) ch=0;
				if(ch==3) ip_trap_code=TRAP_INTERRUPT;
			} else ch=-1;
		}
		if(ch!=-1) key_queue_put(ch);
		break;
	case WM_KEYDOWN:
		if(view_shift_mode!=VIEW_GENERIC_SHIFT) {
			ch=vkey_down((int)wParam);
			if(ch!=-1) {
				if(ch==3) ip_trap_code=TRAP_INTERRUPT;
				key_queue_put(ch);
			}
		}
		break;
	case WM_KEYUP:
		if(view_shift_mode!=VIEW_GENERIC_SHIFT) {
			ch=vkey_up((int)wParam);
			if(ch!=-1) key_queue_put(ch);
		}
		break;
	case WM_LBUTTONDOWN:
		SetCapture(hWnd);
		if(view_event_filter) ptr_queue_put(VEVENT_PTRDOWN,lParam);
		break;
	case WM_MOUSEMOVE:
		if(view_event_filter) {
			if(wParam&MK_LBUTTON) ptr_queue_put(VEVENT_PTRDRAG,lParam);
		}
		break;
	case WM_LBUTTONUP:
		ReleaseCapture();
		if(view_event_filter) ptr_queue_put(VEVENT_PTRUP,lParam);
		break;
	default:
		return DefWindowProc(hWnd,msg,wParam,lParam);
	}

	return 0;
}

static int adjusted_view_size(void)
{
	RECT rect;
	
	SetRect(&rect,0,0,view_width,view_height);
	AdjustWindowRect(&rect,WS_CAPTION|WS_SYSMENU|WS_MINIMIZEBOX,FALSE);
	return coord(rect.right-rect.left,rect.bottom-rect.top);
}

static void create_bitmap(void)
{
	HDC dc;
	dc=GetDC(window);
	bitmap=CreateCompatibleBitmap(dc,view_width,view_height);
	bitmap_dc=CreateCompatibleDC(dc);
	SelectObject(bitmap_dc,bitmap);
	ReleaseDC(window,dc);
	SetBkMode(bitmap_dc,TRANSPARENT);
}

static void delete_bitmap(void)
{
	DeleteDC(bitmap_dc);
	DeleteObject(bitmap);
}

/* api */
/** frame */
#define CLASSNAME "mulkView"

void view_init(void)
{
	WNDCLASSEX wc;
	wc.cbSize=sizeof(wc);
	wc.style=0;
	wc.lpfnWndProc=window_proc;
	wc.cbClsExtra=0;
	wc.cbWndExtra=0;
	wc.hInstance=GetModuleHandle(NULL);
	wc.hIcon=NULL;
	wc.hCursor=LoadCursor(NULL,IDC_ARROW);
	wc.hbrBackground=GetStockObject(WHITE_BRUSH);
	wc.lpszMenuName=NULL;
	wc.lpszClassName=CLASSNAME;
	wc.hIconSm=NULL;
	if(RegisterClassEx(&wc)==0) xerror("RegisterClass failed.");
	view_shift_mode=VIEW_GENERIC_SHIFT;
}

void view_open(int width,int height)
{
	int sz;
	
	view_width=width;
	view_height=height;

	sz=adjusted_view_size();
	window=CreateWindow(CLASSNAME,CLASSNAME,
		WS_CAPTION|WS_SYSMENU|WS_MINIMIZEBOX,CW_USEDEFAULT,CW_USEDEFAULT,
		COORD_X(sz),COORD_Y(sz),NULL,NULL,GetModuleHandle(NULL),NULL);
		
	create_bitmap();
	
	invalid_count=0;
	iqueue_reset(&vevent_queue);
	
	view_shift_mode=VIEW_GENERIC_SHIFT;
	more_char_p=FALSE;
	view_event_filter=0;
	font=NULL;
	jfont=NULL;
	
	ShowWindow(window,SW_SHOW);
}

static void process_event(int wait_p)
{
	MSG msg;
	
	if(wait_p) {
		GetMessage(&msg,NULL,0,0);
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	} else {
		while(PeekMessage(&msg,NULL,0,0,PM_REMOVE)) {
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}		
}

static void delete_font(void)
{
	if(font!=NULL) DeleteObject(font);
	if(jfont!=NULL) {
		DeleteObject(jfont);
		jfont=NULL;
	}
}

int view_set_font(char *font_name)
{
	char *cols[6];
	int ncol,fw,fh,jfh;
	HFONT old_font;
	TEXTMETRIC tm;

	delete_font();
	
	ncol=csplit(font_name,cols,6);

	if(ncol>=2) fh=atoi(cols[1]);
	else fh=16;
	
	font=CreateFont(fh,0,0,0,FW_DONTCARE,FALSE,FALSE,FALSE,
		DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,
		FIXED_PITCH|FF_DONTCARE,cols[0]);
	if(font==NULL) xerror("CreateFont %s failed.",cols[0]);

	old_font=SelectObject(bitmap_dc,font);
	GetTextMetrics(bitmap_dc,&tm);
	fw=tm.tmAveCharWidth;
	SelectObject(bitmap_dc,old_font);
	
	if(ncol>=3) {
		if(ncol>=4) jfh=atoi(cols[3]);
		else jfh=fh;
		jfont=CreateFont(jfh,0,0,0,FW_DONTCARE,FALSE,FALSE,FALSE,
			DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,
			DEFAULT_QUALITY,FIXED_PITCH|FF_DONTCARE,cols[2]);
		if(jfont==NULL) xerror("CreateFont %s failed.",cols[2]);
	}
	return coord(fw,fh);
}

void view_close(void)
{
	DestroyWindow(window);
	PostMessage(window,WM_DESTROY,0,0);
	window=NULL;
	
	delete_font();
	delete_bitmap();
}

void view_finish(void)
{
	if(UnregisterClass(CLASSNAME,GetModuleHandle(NULL))==0) {
		xerror("UnregisterClass failed.");
	}
}

/** drawing */

static void update(void)
{
	if(invalid_count==0) return;
	InvalidateRect(window,&invalid_rect,FALSE);
	UpdateWindow(window);
	process_event(FALSE);
	invalid_count=0;
}

static void invalid(int left,int top,int right,int bottom)
{
	if(invalid_count==0) {
		invalid_rect.left=left;
		invalid_rect.top=top;
		invalid_rect.right=right;
		invalid_rect.bottom=bottom;
	} else {
		if(invalid_rect.left>left) invalid_rect.left=left;
		if(invalid_rect.top>top) invalid_rect.top=top;
		if(invalid_rect.right<right) invalid_rect.right=right;
		if(invalid_rect.bottom<bottom) invalid_rect.bottom=bottom;
	}
	invalid_count++;
	if(invalid_count>=view_update_interval) update();
}

static COLORREF wcolor(int color)
{
	return RGB((color>>16)&0xff,(color>>8)&0xff,color&0xff);
}

void view_fill_rectangle(int x,int y,int width,int height,int color)
{
	RECT rect;
	HBRUSH brush;

	brush=CreateSolidBrush(wcolor(color));
	
	rect.left=x;
	rect.top=y;
	rect.right=x+width;
	rect.bottom=y+height;

	FillRect(bitmap_dc,&rect,brush);
	DeleteObject(brush);

	invalid(x,y,x+width,y+height);
}

#define CHAR_GAP 2
#define WCHAR_MAX_LEN 2

void view_draw_char(int x,int y,uint64_t wc,int color)
{
	wchar_t buf[WCHAR_MAX_LEN];
	char mbytes[XWCHAR_MAX_LEN];
	int buflen;
	HFONT old_font;
	SIZE size;
	
	if(wc<0x7f) {
		buf[0]=(wchar_t)wc;
		buflen=1;
	} else {
		buflen=xwchar_to_mbytes(wc,mbytes);
		buflen=MultiByteToWideChar(codepage,0,mbytes,buflen,buf,
			WCHAR_MAX_LEN);
		if(buflen==0) xerror("MultiByteToWideChar failed");
	}
	SetTextColor(bitmap_dc,wcolor(color));
	if(wc>=0x80&&jfont!=NULL) {
		old_font=SelectObject(bitmap_dc,jfont);
		TextOutW(bitmap_dc,x,y,buf,buflen);
	} else {
		old_font=SelectObject(bitmap_dc,font);
		TextOutW(bitmap_dc,x,y,buf,buflen);
	}
	GetTextExtentPoint32W(bitmap_dc,buf,buflen,&size);
	SelectObject(bitmap_dc,old_font);
	invalid(x-CHAR_GAP,y-CHAR_GAP,x+size.cx+CHAR_GAP*2,y+size.cy+CHAR_GAP*2);
}

static void swap(int *x,int *y)
{
	int temp;
	temp=*x;
	*x=*y;
	*y=temp;
}

void view_draw_line(int x0,int y0,int x1,int y1,int color)
{
	HPEN old_pen,pen;
	
	pen=CreatePen(PS_SOLID,0,wcolor(color));
	old_pen=SelectObject(bitmap_dc,pen);
	MoveToEx(bitmap_dc,x0,y0,NULL);
	LineTo(bitmap_dc,x1,y1);
	SelectObject(bitmap_dc,old_pen);
	DeleteObject(pen);

	if(x0>x1) swap(&x0,&x1);
	if(y0>y1) swap(&y0,&y1);
	invalid(x0,y0,x1,y1);
}

void view_put_true_color_image(int x0,int y0,char *rgb,int w,int h)
{
	BITMAPINFO bi;
	char *bits,*p,*q;
	int slice_len,x,y;
	
	bi.bmiHeader.biSize=sizeof(BITMAPINFOHEADER);
	bi.bmiHeader.biWidth=w;
	bi.bmiHeader.biHeight=h;
	bi.bmiHeader.biPlanes=1;
	bi.bmiHeader.biBitCount=24;
	bi.bmiHeader.biCompression=BI_RGB;
	bi.bmiHeader.biSizeImage=0;
	bi.bmiHeader.biXPelsPerMeter=0;
	bi.bmiHeader.biYPelsPerMeter=0;
	bi.bmiHeader.biClrUsed=0;
	bi.bmiHeader.biClrImportant=0;

	slice_len=w*3;
	if(slice_len%4!=0) slice_len+=(4-slice_len%4);
	bits=xmalloc(slice_len*h);
	
	for(y=0;y<h;y++) {
		for(x=0;x<w;x++) {
			p=rgb+(y*w+x)*3;
			q=bits+(h-1-y)*slice_len+x*3;
			q[0]=p[2];
			q[1]=p[1];
			q[2]=p[0];
		}		
	}
	
	StretchDIBits(bitmap_dc,x0,y0,w,h,0,0,w,h,bits,&bi,DIB_RGB_COLORS,SRCCOPY);
	xfree(bits);

	invalid(x0,y0,x0+w,y0+h);
}

void view_draw_polygon(int *pts,int n,int color)
{
	POINT points[VIEW_MAX_POLYGON_POINT];
	HPEN old_pen;
	HBRUSH brush,old_brush;
	int left,right,top,bottom,x,y,i;

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

	old_pen=SelectObject(bitmap_dc,GetStockObject(NULL_PEN));
	brush=CreateSolidBrush(wcolor(color));
	old_brush=SelectObject(bitmap_dc,brush);
	Polygon(bitmap_dc,points,n);
	SelectObject(bitmap_dc,old_brush);
	DeleteObject(brush);
	SelectObject(bitmap_dc,old_pen);
	invalid(left,top,right,bottom);	
}

void view_put_monochrome_image(int x,int y,char *bits,int w,int h,
	int color,int bkcolor)
{
	HBITMAP b,old_b;
	HDC dc;
	
	b=CreateBitmap(w,h,1,1,bits);
	dc=CreateCompatibleDC(bitmap_dc);
	old_b=SelectObject(dc,b);
	SetTextColor(bitmap_dc,wcolor(bkcolor));
	SetBkColor(bitmap_dc,wcolor(color));
	BitBlt(bitmap_dc,x,y,w,h,dc,0,0,SRCCOPY);
	SelectObject(dc,old_b);
	DeleteObject(b);
	DeleteObject(dc);
	invalid(x,y,x+w,y+h);
}

/** view event */
void view_load_keymap(char *fn)
{
	vkey_load_keymap(fn,VKEY_WINDOWS);
}

int view_get_event(void)
{
	update();
	while(iqueue_empty_p(&vevent_queue)) process_event(TRUE);
	return iqueue_get(&vevent_queue);
}

int view_event_empty_p(void)
{
	update();
	process_event(FALSE);
	return iqueue_empty_p(&vevent_queue);
}

/* intr */
void ip_intr_check(void)
{
	if(window!=NULL) process_event(FALSE);
}

/* vkey */
static int press_p(int code) {
	return GetKeyState(code)&0x8000;
}

#ifdef __DMC__
#define VK_NONCONVERT 0x1d
#define VK_CONVERT 0x1c
#endif

int vkey_press_check(int key)
{
	switch(key) {
	case VKEY_SHIFT: return press_p(VK_LSHIFT)||press_p(VK_RSHIFT);
	case VKEY_CTRL: return press_p(VK_LCONTROL)||press_p(VK_RCONTROL);
	case VKEY_CONVERT: return press_p(VK_CONVERT);
	case VKEY_NONCONVERT: return press_p(VK_NONCONVERT);
	default: return 0;
	}
}

int view_get_position(void)
{
	RECT rect;
	GetWindowRect(window,&rect);
	return coord(rect.left,rect.top);
}

void view_set_position(int coord)
{
	RECT rect;
	GetWindowRect(window,&rect);
	MoveWindow(window,COORD_X(coord),COORD_Y(coord),
		rect.right-rect.left,rect.bottom-rect.top,FALSE);
}

void view_set_size(int coord)
{
	RECT rect;
	int sz;
	
	view_width=COORD_X(coord);
	view_height=COORD_Y(coord);
	
	delete_bitmap();
	create_bitmap();
	
	GetWindowRect(window,&rect);
	sz=adjusted_view_size();
	MoveWindow(window,rect.left,rect.top,COORD_X(sz),COORD_Y(sz),FALSE);
}

int view_get_screen_size(void)
{
	return coord(GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN));
}

int view_get_frame_size(void)
{
	RECT rect;
	GetWindowRect(window,&rect);
	return coord(rect.right-rect.left,rect.bottom-rect.top);
}
