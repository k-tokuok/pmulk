/*
	xconsole for posix.
	$Id: mulk xconsole.c 628 2021-01-03 Sun 23:02:03 kt $
*/

#include "std.h"
#include "mem.h"

void xputc(int ch)
{
	fputc(ch,stdout);
}

void xputs(char *s)
{
	char *p;
	for(p=s;*p!='\0';p++) xputc(LC(*p));
}

void xexit(void)
{
	exit(0);
}
