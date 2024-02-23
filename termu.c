/*
	terminal for unix.
	$Id: mulk termu.c 850 2022-03-05 Sat 11:10:45 kt $
*/

#include "std.h"

#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#include <termcap.h>
#include <termios.h>

#include "term.h"
#include "cqueue.h"

static int init_p=FALSE;

static struct termios line_attr,char_attr;
static char *cl,*cm;
static struct cqueue cq;

static void init(void)
{
	char *term,*p,buf[MAX_STR_LEN];
	init_p=TRUE;
	term=getenv("TERM");
	if(term==NULL||tgetent(NULL,term)!=1) xerror("tgetent failed.");
	p=buf;
	if((cl=(char*)tgetstr("cl",&p))==NULL) xerror("tgetstr(cl) failed.");
	cl=xstrdup(cl);
	p=buf;
	if((cm=(char*)tgetstr("cm",&p))==NULL) xerror("tgetstr(cm) failed.");
	cm=xstrdup(cm);
	
	if(tcgetattr(1,&line_attr)<0) xerror("tcgetattr failed.");
	char_attr=line_attr;
	char_attr.c_iflag=0;
	char_attr.c_oflag=0;
	char_attr.c_lflag=ISIG;
	char_attr.c_cc[VINTR]=3;
	char_attr.c_cc[VQUIT]=-1;
	char_attr.c_cc[VSUSP]=-1;
#ifdef VSTATUS
	char_attr.c_cc[VSTATUS]=-1;
#endif
	char_attr.c_cc[VMIN]=1;
}

int term_start(void)
{
	if(!init_p) init();
	tcsetattr(1,TCSADRAIN,&char_attr);
	cqueue_reset(&cq);
	return coord(tgetnum("co"),tgetnum("li"));
}

void term_finish(void)
{
	tcsetattr(1,TCSADRAIN,&line_attr);
}

int term_get(void)
{
	int n;
	unsigned char ch;

	if(!cqueue_empty_p(&cq)) return cqueue_get(&cq);
	n=read(0,&ch,1);
	if(n==0) return EOF;
	else if(n==-1) return 3;
	if(ch==0x7f) ch=8; /* replace del to bs */
	return ch;
}

void term_put(char *p,int size)
{
	int n;
	n=write(1,p,size);
	if(n!=size) xerror("write failed.");
}

static int term_putc(
#ifdef __illumos__
char 
#else
int
#endif
ch)
{
	char buf[1];
	buf[0]=ch;
	term_put(buf,1);
	return ch;
}

int term_hit_p(void)
{
    unsigned char c;
    int fdflags,n;

	if(!cqueue_empty_p(&cq)) return TRUE;

    fdflags=fcntl(0,F_GETFL,0);
    fcntl(0,F_SETFL,(fdflags|O_NONBLOCK));
	n=read(0,&c,1);
    fcntl(0,F_SETFL,fdflags);
    if(n==1) {
		cqueue_put(&cq,c);
        return TRUE;
    }
    return FALSE;
}

void term_goto_xy(int x,int y)
{
	tputs(tgoto(cm,x,y),1,term_putc);
}

void term_clear(void)
{
	tputs(cl,1,term_putc);
}
