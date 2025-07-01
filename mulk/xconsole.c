/*
	xconsole for posix.
	$Id: mulk xconsole.c 1433 2025-06-03 Tue 21:15:38 kt $
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
