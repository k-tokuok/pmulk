/*
	xc std.
	$Id: mulk std.h 1073 2023-06-14 Wed 22:34:43 kt $
*/

#define TRUE 1
#define FALSE 0

#include "config.h"

#include <stdio.h>
#include <stdarg.h>

#if INCLUDE_INTTYPES_P
#include <inttypes.h>
#endif

#ifdef __DMC__
#undef UINT64_MAX
#define UINT64_MAX UINT64_C(18446744073709551615)
#endif

#ifdef BORLANDC_55
#define UINT64_C(x) (x ## ui64)
typedef unsigned __int64 uint64_t;
typedef unsigned int uintptr_t;
typedef int intptr_t;
#define UINTPTR_MAX 0xffffffff
#define UINT64_MAX 0xffffffffffffffff
#endif

#ifdef __DJGPP__
#include <stdint.h>
#endif

#if CM_P
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
typedef int intptr_t;
typedef unsigned int uintptr_t;
#endif

#if U64_P
#include "u64.h"
#endif

#define MAX_STR_LEN 256

extern void xvsprintf(char *buf,char *fmt,va_list va);
extern void xsprintf(char *buf,char *fmt,...);

extern void xerror(char *fmt,...) GCC_NORETURN;
extern void *xmalloc(int size);
extern void xfree(void *);
extern void *xrealloc(void *p,int size);
extern char *xstrdup(char *s);

/* use xassert to catch assert failure. */

#ifdef NDEBUG
#define xassert(cond) ;
#else
extern void xassert_failed(char *fn,int line);
#define xassert(cond) if(!(cond)) xassert_failed(__FILE__,__LINE__);
#endif
