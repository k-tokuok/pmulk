/*
	OS class. - libc/posix wrapper.
	$Id: mulk os.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

#include "pf.h"

#include "mem.h"
#include "om.h"
#include "gc.h"
#include "ip.h"
#include "os.h"
#include "prim.h"

#if UNDERSCORE_PUTENV_P
#define putenv _putenv
#endif

/* file stream */

static char *mode_table[]={
	"rb",
	"wb",
	"ab",
	"rb+"
};

DEFPRIM(os_fopen)
{
	char *fn;
	struct xbarray xba;
	int mode;
	FILE *fp;

	GET_SINT_ARG(1,mode);
	if(!(0<=mode&&mode<sizeof(mode_table)/sizeof(char*))) return PRIM_ERROR;
	if((fn=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
#if PF_OPEN_P
	fp=pf_open(fn,mode_table[mode]);
#else
	fp=fopen(fn,mode_table[mode]);
#endif
	xbarray_free(&xba);
	if(fp==NULL) return PRIM_ERROR;
	*result=p_uintptr((uintptr_t)fp);
	return PRIM_SUCCESS;
}

DEFPRIM(os_fgetc)
{
	int ch;
	FILE *fp;
	
	if(!p_uintptr_val(args[0],(uintptr_t*)&fp)) return PRIM_ERROR;
	ch=fgetc(fp);
	if(ch==EOF&&ferror(fp)) {
		clearerr(fp);
		return PRIM_ERROR;
	}
	*result=sint(ch);
	return PRIM_SUCCESS;	
}

DEFPRIM(os_fputc)
{
	int byte;
	FILE *fp;

	GET_SINT_ARG(0,byte);
	if(!p_byte_p(byte)) return PRIM_ERROR;
	if(!p_uintptr_val(args[1],(uintptr_t*)&fp)) return PRIM_ERROR;
	if(fputc(byte,fp)==EOF) return PRIM_ERROR;
	return PRIM_SUCCESS;
}

DEFPRIM(os_fgets)
{
	FILE *fp;
	struct xbarray xba;
	char *s;

	if(!p_uintptr_val(args[0],(uintptr_t*)&fp)) return PRIM_ERROR;	
	xbarray_init(&xba);
	s=xbarray_fgets(&xba,fp);
	if(s==NULL) *result=om_nil;
	else {
		xba.size--; /* remove last nul */
		*result=p_string_xbarray(&xba);
	}
	xbarray_free(&xba);
	return PRIM_SUCCESS;
}

DEFPRIM(os_fread)
{
	object ba;
	int from,size;
	FILE *fp;

	ba=args[0];
	if(om_class(ba)!=om_FixedByteArray) return PRIM_ERROR;
	GET_SINT_ARG(1,from);
	GET_SINT_ARG(2,size);
	if(!(0<=from&&from+size<=ba->fbarray.size)) return PRIM_ERROR;
	if(!p_uintptr_val(args[3],(uintptr_t*)&fp)) return PRIM_ERROR;

	size=fread(ba->fbarray.elt+from,1,size,fp);
	if(size==0&&ferror(fp)) {
		clearerr(fp);
		return PRIM_ERROR;
	}
	*result=sint(size);
	return PRIM_SUCCESS;
}

DEFPRIM(os_fwrite)
{
	object ba,xclass;
	int from,size;
	FILE *fp;

	ba=args[0];
	xclass=om_class(ba);
	if(!(xclass==om_FixedByteArray||xclass==om_Symbol||xclass==om_String)) {
		return PRIM_ERROR;
	}
	GET_SINT_ARG(1,from);
	GET_SINT_ARG(2,size);
	if(!(0<=from&&from+size<=ba->fbarray.size)) return PRIM_ERROR;
	if(!p_uintptr_val(args[3],(uintptr_t*)&fp)) return PRIM_ERROR;
	
	size=fwrite(ba->fbarray.elt+from,1,size,fp);
	if(size==0&&ferror(fp)) {
		clearerr(fp);
		return PRIM_ERROR;
	}
	*result=sint(size);
	return PRIM_SUCCESS;
}

DEFPRIM(os_fseek)
{
	FILE *fp;

	if(!p_uintptr_val(args[0],(uintptr_t*)&fp)) return PRIM_ERROR;

	if(args[1]==om_nil) {
		if(fseek(fp,0,SEEK_END)!=0) return PRIM_ERROR;
	} else {
#if U64_P
		uint32_t off;
		if(!p_uint32_val(args[1],&off)) return FALSE;
#else
		uint64_t off;
		if(!p_uint64_val(args[1],&off)) return FALSE;
#endif
#if FPOS_TYPE==FPOS_LONG
		if(off>LONG_MAX) return PRIM_ERROR;
		if(fseek(fp,(long)off,SEEK_SET)!=0) return PRIM_ERROR;
#endif
#if FPOS_TYPE==FPOS_OFFT
		if(off>INT64_MAX) return PRIM_ERROR;
		if(fseeko(fp,(off_t)off,SEEK_SET)!=0) return PRIM_ERROR;
#endif
#if FPOS_TYPE==FPOS_I64
		if(off>INT64_MAX) return PRIM_ERROR;
		if(_fseeki64(fp,(__int64)off,SEEK_SET)!=0) return PRIM_ERROR;
#endif
	}
	return PRIM_SUCCESS;
}

DEFPRIM(os_ftell)
{
#if FPOS_TYPE==FPOS_LONG
	long pos;
#endif
#if FPOS_TYPE==FPOS_OFFT
	off_t pos;
#endif
#if FPOS_TYPE==FPOS_I64
	__int64 pos;
#endif
	FILE *fp;

	if(!p_uintptr_val(args[0],(uintptr_t*)&fp)) return PRIM_ERROR;	
#if FPOS_TYPE==FPOS_LONG
	if((pos=ftell(fp))==-1) return PRIM_ERROR;
#endif
#if FPOS_TYPE==FPOS_OFFT
	if((pos=ftello(fp))==-1) return PRIM_ERROR;
#endif
#if FPOS_TYPE==FPOS_I64
	if((pos=_ftelli64(fp))==-1) return PRIM_ERROR;
#endif

#if U64_P
	*result=p_uint32((uint32_t)pos);
#else
	*result=p_uint64((uint64_t)pos);
#endif
	return PRIM_SUCCESS;
}

DEFPRIM(os_lock)
{
	int lock_p;
	FILE *fp;

	lock_p=args[0]==om_true;
	if(!p_uintptr_val(args[1],(uintptr_t*)&fp)) return PRIM_ERROR;
	if(!pf_lock(fp,lock_p)) return PRIM_ERROR;
	return PRIM_SUCCESS;
}

DEFPRIM(os_fclose)
{
	FILE *fp;

	if(!p_uintptr_val(args[0],(uintptr_t*)&fp)) return PRIM_ERROR;
	fclose(fp);
	return PRIM_SUCCESS;
}

/* file operations */

DEFPRIM(os_stat)
{
	char *fn;
	struct xbarray xba;
	struct pf_stat statbuf;
	int type;
	object so;
	
	if((fn=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	type=pf_stat(fn,&statbuf);
	xbarray_free(&xba);
	if(type==PF_ERROR) return PRIM_ERROR;

	if(type==PF_NONE) {
		*result=om_nil;
		return PRIM_SUCCESS;
	}

	so=gc_object_new(om_FixedArray,3);
	so->farray.elt[0]=sint(type);
#if U64_P
	so->farray.elt[1]=p_uint32(statbuf.size);
	so->farray.elt[2]=p_uint32(statbuf.mtime);
#else
	so->farray.elt[1]=p_uint64(statbuf.size);
	so->farray.elt[2]=p_uint64(statbuf.mtime);
#endif
	*result=so;
	return PRIM_SUCCESS;
}

DEFPRIM(os_utime)
{
	char *fn;
	struct xbarray xba;
#if U64_P
	uint32_t tv;
#else
	uint64_t tv;
#endif
	int st;
	
	if(!
#if U64_P
		p_uint32_val(args[1],&tv)
#else
		p_uint64_val(args[1],&tv)
#endif
	) return PRIM_ERROR;
	if((fn=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	st=pf_utime(fn,tv);
	xbarray_free(&xba);
	if(!st) return PRIM_ERROR;
	return PRIM_SUCCESS;
}

DEFPRIM(os_chdir)
{
	char *fn;
	struct xbarray xba;
	int st;
	if((fn=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	st=pf_chdir(fn);
	xbarray_free(&xba);
	if(!st) return PRIM_ERROR;
	return PRIM_SUCCESS;
}

DEFPRIM(os_readdir)
{
	char *path;
	struct xbarray dirs,xba;
	int st;
	if((path=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	xbarray_init(&dirs);
	st=pf_readdir(path,&dirs);
	xbarray_free(&xba);
	if(!st) return PRIM_ERROR;
	*result=p_string_xbarray(&dirs);
	xbarray_free(&dirs);
	return PRIM_SUCCESS;
}

DEFPRIM(os_remove)
{
	char *fn;
	struct xbarray xba;
	int st;
	if((fn=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	st=pf_remove(fn);
	xbarray_free(&xba);
	if(!st) return PRIM_ERROR;
	return PRIM_SUCCESS;
}

DEFPRIM(os_mkdir)
{
	char *path;
	struct xbarray xba;
	int st;
	if((path=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	st=pf_mkdir(path);
	xbarray_free(&xba);
	if(!st) return PRIM_ERROR;
	return PRIM_SUCCESS;
}

/* time */

DEFPRIM(os_floattime)
{
	*result=p_float(os_floattime());
	return PRIM_SUCCESS;
}

DEFPRIM(os_clock)
{
	*result=p_float((double)clock()/CLOCKS_PER_SEC);
	return PRIM_SUCCESS;
}

DEFPRIM(os_sleep)
{
	double t;
	if(!p_float_val(args[0],&t)) return PRIM_ERROR;

#if INTR_CHECK_P
#define POLLING 0.1
	while(t>POLLING) {
		ip_intr_check();
		if(ip_trap_code!=TRAP_NONE) return PRIM_ERROR;
		os_sleep(POLLING);
		t-=POLLING;
	}
#endif
	os_sleep(t);
	return PRIM_SUCCESS;
}

/* system */

DEFPRIM(os_system)
{
	char *s;
	struct xbarray xba;
	if((s=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	*result=sint(system(s));
	xbarray_free(&xba);
	return PRIM_SUCCESS;
}

/* environ */

DEFPRIM(os_getenv)
{
	char *s;
	struct xbarray xba;
	if((s=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	s=getenv(s);
	xbarray_free(&xba);
	if(s==NULL) *result=om_nil;
	else *result=gc_string(s);
	return PRIM_SUCCESS;
}

DEFPRIM(os_putenv)
{
	char *s;
	struct xbarray xba;
	if((s=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	s=xstrdup(s);
	xbarray_free(&xba);
	if(putenv(s)!=0) return PRIM_ERROR;
	return PRIM_SUCCESS;
}

/* general property */

/** timediff */
static int daysec(struct tm *tm)
{
	return (tm->tm_hour*60+tm->tm_min)*60+tm->tm_sec;
}

static int timediff(void)
{
	time_t now;
	struct tm ltm,gtm;
	int off;
	
	now=time(NULL);
	gtm=*gmtime(&now);
	ltm=*localtime(&now);

	if(gtm.tm_yday==ltm.tm_yday) off=0;
	else if(gtm.tm_year==ltm.tm_year+1||gtm.tm_yday==ltm.tm_yday+1) off=-1;
	else off=1;
	return daysec(&ltm)+off*24*60*60-daysec(&gtm);
}

DEFPROPERTY(os)
{
	switch(key) {
	case 100: *result=p_uintptr((uintptr_t)stdin); break;
	case 101: *result=p_uintptr((uintptr_t)stdout); break;
	case 102:
		{
			char *p;
			p=pf_getcwd();
			*result=gc_string(p);
			xfree(p);
		}
		break;
	case 103: *result=sint(timediff()); break;
	default: 
		return PRIM_ANOTHER_PROPERTY;
	}
	return PRIM_SUCCESS;
}
