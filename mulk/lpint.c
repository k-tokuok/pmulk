/*
	LongPositiveInteger class.
	$Id: mulk lpint.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include "om.h"
#include "prim.h"

#define GET_LPINT_ARG(i,num) \
{ \
	object o; \
	o=args[i]; \
	if(om_size(o)!=SIZE_LPINT) return PRIM_ARG_ERROR; \
	num=o->lpint.val; \
}

DEFPRIM(lpint_equal)
{
	uint64_t y;
	GET_LPINT_ARG(0,y);
	*result=om_boolean(self->lpint.val==y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_lt)
{
	uint64_t y;
	GET_LPINT_ARG(0,y);
	*result=om_boolean(self->lpint.val<y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_add)
{
	uint64_t x,y;
	x=self->lpint.val;
	GET_LPINT_ARG(0,y);
	if(x>UINT64_MAX-y) return PRIM_ERROR;
	*result=p_lpint(x+y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_subtract)
{
	uint64_t x,y;
	x=self->lpint.val;
	GET_LPINT_ARG(0,y);
	if(x<y) return PRIM_ERROR;
	*result=p_lpint(x-y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_multiply)
{
	uint64_t x,y;
	x=self->lpint.val;
	GET_LPINT_ARG(0,y);
	if(y!=0&&x>UINT64_MAX/y) return PRIM_ERROR;
	*result=p_lpint(x*y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_divide)
{
	uint64_t y;
	GET_LPINT_ARG(0,y);
	if(y==0) return PRIM_ERROR;
	*result=p_lpint(self->lpint.val/y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_modulo)
{
	uint64_t y;
	GET_LPINT_ARG(0,y);
	if(y==0) return PRIM_ERROR;
	*result=p_lpint(self->lpint.val%y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_and)
{
	uint64_t y;
	GET_LPINT_ARG(0,y);
	*result=p_lpint(self->lpint.val&y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_or)
{
	uint64_t y;
	GET_LPINT_ARG(0,y);
	*result=p_lpint(self->lpint.val|y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_xor)
{
	uint64_t y;
	GET_LPINT_ARG(0,y);
	*result=p_lpint(self->lpint.val^y);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_shift)
{
	uint64_t x;
	int y;
	x=self->lpint.val;
	GET_SINT_ARG(0,y);
	if(y<=-LPINT_BITS||y>=LPINT_BITS) return PRIM_ERROR;
	if(x!=0) {
		if(y>0) {
			if(x>(UINT64_MAX>>y)) return PRIM_ERROR;
			x<<=y;
		} else x>>=-y;
	}
	*result=p_lpint(x);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_asFloat)
{
	*result=p_float((double)self->lpint.val);
	return PRIM_SUCCESS;
}

DEFPRIM(lpint_asShortIntegerWith)
{
	uint64_t val;
	val=self->lpint.val;
	if(args[0]==om_true) {
		if(val>-SINT_MIN) return PRIM_ERROR;
		*result=sint(-(int)val);
	} else {
		if(val>SINT_MAX) return PRIM_ERROR;
		*result=sint(val);
	}
	return PRIM_SUCCESS;
}
