/*
	xc std.
	$Id: mulk std.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <stdlib.h>
#include <string.h>

#if XCONSOLE_P
#include "xconsole.h"
#endif

void xvsprintf(char *buf,char *fmt,va_list va)
{
	int len;
#if VSPRINTF_P
	len=vsprintf(buf,fmt,va);
#else
	len=vsnprintf(buf,MAX_STR_LEN,fmt,va);
#endif
	if(len+1>MAX_STR_LEN) xerror("xvsprintf buffer overflow.");
}

void xsprintf(char *buf,char *fmt,...)
{
	va_list va;
	va_start(va,fmt);
	xvsprintf(buf,fmt,va);
	va_end(va);
}

void xerror(char *fmt,...)
{
	va_list va;
	char buf[MAX_STR_LEN];

	va_start(va,fmt);
	xvsprintf(buf,fmt,va);
	va_end(va);
#if XCONSOLE_P
	xputc('!');
	xputs(buf);
	xputc('\n');
	xexit();
#else
	fprintf(stderr,"!%s\n",buf);
	exit(1);
#endif
}

void *xmalloc(int size)
{
	void *p;

	if(size==0) return NULL;
	if((p=malloc(size))==NULL) xerror("xmalloc failed.");
	return p;
}

void xfree(void *p)
{
	if(p!=NULL) free(p);
}

void *xrealloc(void *p,int size)
{
	if(p==NULL) p=xmalloc(size);
	else if(size==0) {
		xfree(p);
		p=NULL;
	} else {
		if((p=realloc(p,size))==NULL) xerror("xrealloc failed.");
	}
	return p;
}

char *xstrdup(char *s)
{
	int len;
	char *result;
	
	len=strlen(s);
	result=xmalloc(len+1);
	memcpy(result,s,len+1);
	return result;
}

#ifndef NDEBUG
void xassert_failed(char *fn,int line)
{
	xerror("assert failed at %s:%d.",fn,line);
}
#endif
