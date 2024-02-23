/*
	xc log.
	$Id: mulk log.c 661 2021-02-06 Sat 23:03:11 kt $
*/

#include "std.h"
#include "log.h"

static FILE *fp=NULL;

void log_open(char *fn)
{
	if(fn==NULL) fp=stdout;
	else {
		if((fp=fopen(fn,"w"))==NULL) xerror("open %s failed.",fn);
	}
}

int log_p(void)
{
	return fp!=NULL;
}

void log_c(int ch)
{
	if(log_p()) fputc(ch,fp);
}

void log_ln(void)
{
	log_c('\n');
}

void log_f(char *fmt,...)
{
	va_list va;
	if(log_p()) {
		va_start(va,fmt);
		vfprintf(fp,fmt,va);
		va_end(va);
	}
}

void log_close(void)
{
	if(log_p()) {
		if(fp!=stdout) fclose(fp);
		fp=NULL;
	}
}
