/*
	terminal for windows.
	$Id: mulk termw.c 1091 2023-07-16 Sun 07:11:27 kt $
*/

#include "std.h"
#include "cqueue.h"
#include "term.h"
#include "ki.h"
#include "kidec.h"
#include "kidecw.h"
#include "om.h"
#include "ip.h"

#include <windows.h>

static int init_p=FALSE;

static HANDLE console_in;
static HANDLE console_out;
static DWORD saved_mode;
static struct cqueue cq;
static int more_char_p;

static struct kidec kidec;

static void init(void)
{
	console_in=GetStdHandle(STD_INPUT_HANDLE);
	console_out=GetStdHandle(STD_OUTPUT_HANDLE);
	if(!GetConsoleMode(console_in,&saved_mode)) {
		xerror("GetConsoleMode failed.");
	}
	kidec.press_check=kidecw_press_check;
	kidec.mode=KI_GENERIC;
	
	init_p=TRUE;
}

static void set_mode(DWORD mode)
{
	if(!SetConsoleMode(console_in,mode)) xerror("SetConsoleMode failed.");
}

static void buffer_size(int *w,int *h)
{
	CONSOLE_SCREEN_BUFFER_INFO i;
	GetConsoleScreenBufferInfo(console_out,&i);
	*w=i.srWindow.Right-i.srWindow.Left+1;
	*h=i.srWindow.Bottom-i.srWindow.Top+1;
}

static void buffer_base(int *x,int *y)
{
	CONSOLE_SCREEN_BUFFER_INFO i;
	GetConsoleScreenBufferInfo(console_out,&i);
	*x=i.srWindow.Left; *y=i.srWindow.Top;
}

int term_start(void)
{
	int w,h;
	if(!init_p) init();
	set_mode(ENABLE_PROCESSED_INPUT);
	cqueue_reset(&cq);
	more_char_p=FALSE;
	buffer_size(&w,&h);
	return coord(w,h);
}

void term_finish(void)
{
	set_mode(saved_mode);
}

static void fetch(void)
{
	INPUT_RECORD input;
	DWORD nread;
	int ch;

	ReadConsoleInput(console_in,&input,1,&nread);
	if(input.EventType!=KEY_EVENT) return;
	
	if(input.Event.KeyEvent.bKeyDown) {
		ch=(unsigned char)(input.Event.KeyEvent.uChar.AsciiChar);
		if(more_char_p) more_char_p=FALSE;
		else if(IsDBCSLeadByte(ch)) more_char_p=TRUE;
		else {
			if(kidec.mode==KI_GENERIC) {
				if(ch==0) ch=-1;
			} else {
				ch=kidec_down(&kidec,input.Event.KeyEvent.wVirtualKeyCode);
			}
		} 
	} else {
		if(kidec.mode==KI_GENERIC) ch=-1;
		else ch=kidec_up(&kidec,input.Event.KeyEvent.wVirtualKeyCode);
	}
	if(ch!=-1) cqueue_put(&cq,ch);
}

int term_hit_p(void)
{
	DWORD nevent;
	while(TRUE) {
		GetNumberOfConsoleInputEvents(console_in,&nevent);
		if(nevent==0) break;
		fetch();
	}

	return !cqueue_empty_p(&cq);
}

int term_get(void)
{
	if(term_hit_p()) return cqueue_get(&cq);
	while(TRUE) {
		fetch();
		if(ip_trap_code!=TRAP_NONE) return 3;
		if(!cqueue_empty_p(&cq)) break;
	}
	return cqueue_get(&cq);
}

void term_put(char *p,int size)
{
	DWORD nwrite;
	WriteConsole(console_out,p,size,&nwrite,NULL);
}

void term_goto_xy(int x,int y)
{
	COORD c;
	int bx,by;

	buffer_base(&bx,&by);
	c.X=bx+x; c.Y=by+y;
	SetConsoleCursorPosition(console_out,c);
}

void term_clear(void)
{
	int w,h,bx,by;
	COORD c;
	DWORD nwrite;
	
	buffer_base(&bx,&by);
	buffer_size(&w,&h);
	
	c.X=bx; c.Y=by;
	FillConsoleOutputCharacter(console_out,' ',w*h,c,&nwrite);
	term_goto_xy(0,0);
}

#include "prim.h"
DEFPRIM(term_load_keymap)
{
	char *fn;
	struct xbarray xba;
	if((fn=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	kidec_load_keymap(&kidec,fn,KI_WINDOWS);
	xbarray_free(&xba);
	return PRIM_SUCCESS;
}

DEFPRIM(term_set_shift_mode)
{
	if(!kidec_keymap_loaded_p(&kidec)) return PRIM_ERROR;
	GET_SINT_ARG(0,kidec.mode);
	return PRIM_SUCCESS;
}
