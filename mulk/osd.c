/*
	dos dependent part.
	$Id: mulk osd.c 1533 2026-02-01 Sun 15:27:04 kt $
*/
#include "std.h"

#include <time.h>
#include <string.h>
#include <conio.h>
#include <dos.h>

#if DOS_BIOSKBD_P
#include <bios.h>
#endif

#ifdef __WATCOMC__
#include <i86.h>
#endif

#include "om.h"
#include "os.h"
#include "ip.h"
#include "term.h"
#include "cqueue.h"

static struct cqueue cq;

void os_intr_init(void)
{
	cqueue_reset(&cq);
}

#define CTRL_C 0x03
#define CTRL_BACKSLASH 0x1c

static int fetch(void)
{
	int ch;
#if DOS_BIOSKBD_P
	ch=_bios_keybrd(_KEYBRD_READ)&0xff;
	if(ch==0) return -1;
#else
	ch=getch();
#endif
	if(ch==CTRL_C||ch==CTRL_BACKSLASH) {
		cqueue_reset(&cq);
		ip_trap_code=TRAP_INTERRUPT;
	}
	return ch;
}

void ip_intr_check(void)
{
	int ch;
	while(TRUE) {
#if DOS_BIOSKBD_P
		if(_bios_keybrd(_KEYBRD_READY)==0) break;
#else
		if(!kbhit()) break;
#endif
		ch=fetch();
		if(ch!=-1) cqueue_put(&cq,ch);
	}
}

double os_floattime(void)
{
	struct dostime_t dt;
	_dos_gettime(&dt);
	return (double)time(NULL)+dt.hsecond/100.0;
}

void os_sleep(double t)
{
	delay((int)(t*1000));
}

/* term */
int term_start(void)
{
	return coord(80,25);
}

void term_finish(void)
{
}

int term_get(void)
{
	int ch;
	if(!cqueue_empty_p(&cq)) return cqueue_get(&cq);
	else {
		while((ch=fetch())==-1);
		return ch;
	}
}

void term_put(char *p,int size)
{
	fwrite(p,size,1,stdout);
}

int term_hit_p(void)
{
	ip_intr_check();
	return !cqueue_empty_p(&cq);
}

static void xputs(char *s)
{
	term_put(s,strlen(s));
}

void term_goto_xy(int x,int y)
{
	char buf[MAX_STR_LEN];
	xsprintf(buf,"\x1b[%d;%dH",y+1,x+1);
	xputs(buf);
}

void term_clear(void)
{
	xputs("\x1b[2J\x1b[H");
}

