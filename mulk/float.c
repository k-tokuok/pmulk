/*
	Float class.
	$Id: mulk float.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <string.h>
#include <limits.h>
#include <math.h>

#ifdef __BORLANDC__
#include <float.h>
#define isfinite _finite
#endif

#if INTER_ISFINITE_P
/* isfinite mulfunction in mingw gcc 11.2.0 for ia32 in cygwin */
#undef isfinite
static int isfinite(double x)
{
	union {
		double d;
		uint64_t i;
	} u;
	u.d=x;
	return ((u.i>>52)&0x7ff)!=0x7ff;
}
#endif

#include "om.h"
#include "prim.h"

#define GET_FLOAT_ARG(i,num) \
{ \
	object o; \
	o=args[i]; \
	if(om_size(o)!=SIZE_FLOAT) return PRIM_ARG_ERROR; \
	num=o->xfloat.val; \
}

DEFPRIM(float_equal)
{
	double y;
	GET_FLOAT_ARG(0,y);
	*result=om_boolean(self->xfloat.val==y);
	return PRIM_SUCCESS;
}

DEFPRIM(float_lt)
{
	double y;
	GET_FLOAT_ARG(0,y);
	*result=om_boolean(self->xfloat.val<y);
	return PRIM_SUCCESS;
}

DEFPRIM(float_add)
{
	double y;
	GET_FLOAT_ARG(0,y);
	y+=self->xfloat.val;
	if(!isfinite(y)) return PRIM_ERROR;
	*result=p_float(y);
	return PRIM_SUCCESS;
}

DEFPRIM(float_multiply)
{
	double y;
	GET_FLOAT_ARG(0,y);
	y*=self->xfloat.val;
	if(!isfinite(y)) return PRIM_ERROR;
	*result=p_float(y);
	return PRIM_SUCCESS;
}

DEFPRIM(float_divide)
{
	double y;
	GET_FLOAT_ARG(0,y);
	if(y==0) return PRIM_ERROR;
	y=self->xfloat.val/y;
	if(!isfinite(y)) return PRIM_ERROR;
	*result=p_float(y);
	return PRIM_SUCCESS;
}

DEFPRIM(float_asInteger)
{
	double x;
	x=self->xfloat.val;
	if(SINT_MIN<=x&&x<=SINT_MAX) {
		*result=sint((int)x);
		return PRIM_SUCCESS;
	}

	/*double has 53bit fraction (IEEE754)*/
	if(0<=x&&x<=9007199254740991.0) {
#if U64_P
		uint32_t hi,lo;
		u64_t u64;
		hi=(uint32_t)(x/4294967296.0);
		lo=(uint32_t)(x-hi*4294967296.0);
		u64_init(&u64,hi,lo);
		*result=p_lpint(&u64);
#else
		*result=p_lpint((uint64_t)x);
#endif
		return PRIM_SUCCESS;
	}
	return PRIM_ERROR;
}
