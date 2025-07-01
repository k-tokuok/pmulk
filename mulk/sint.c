/*
	ShortInteger class.
	$Id: mulk sint.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include "om.h"
#include "prim.h"

DEFPRIM(sint_equal)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);
	*result=om_boolean(x==y);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_lt)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);
	*result=om_boolean(x<y);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_add)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);
	x+=y;
	if(!sint_range_p(x)) return PRIM_ERROR;
	*result=sint(x);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_multiply)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);

	if(x>0) {
		if(y>0) {
			if(x>SINT_MAX/y) return PRIM_ERROR;
		} else {
			if(y<SINT_MIN/x) return PRIM_ERROR;
		}
	} else {
		if(y>0) {
			if(x<SINT_MIN/y) return PRIM_ERROR;
		} else {
			if(x!=0&&y<SINT_MAX/x) return PRIM_ERROR;
		}
	}
	*result=sint(x*y);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_divide)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);
	if(y==0||(x==SINT_MIN&&y==-1)) return PRIM_ERROR;
	*result=sint(x/y);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_modulo)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);
	if(x<0||y<=0) return PRIM_ERROR;
	*result=sint(x%y);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_and)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);
	if(x<0||y<0) return PRIM_ERROR;
	*result=sint(x&y);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_or)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);
	if(x<0||y<0) return PRIM_ERROR;
	*result=sint(x|y);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_xor)
{
	int x,y;
	x=sint_val(self);
	GET_SINT_ARG(0,y);
	if(x<0||y<0) return PRIM_ERROR;
	*result=sint(x^y);
	return PRIM_SUCCESS;
}

DEFPRIM(sint_shift)
{
	int x,y;
	x=sint_val(self);
	if(x<0) return PRIM_ERROR;
	GET_SINT_ARG(0,y);
	if(y<=-SINT_ABSBITS||y>=SINT_ABSBITS) return PRIM_ERROR;
	if(x!=0) {
		if(y>0) {
			if(x>(SINT_MAX>>y)) return PRIM_ERROR;
			x<<=y;
		} else x>>=-y;
	}
	*result=sint(x);
	return PRIM_SUCCESS;
}		

DEFPRIM(sint_makeLongPositiveIntegerWithAbs)
{
	int x;
	x=sint_val(self);
	if(x<0) x=-x;
#if U64_P
	{
		u64_t u64;
		u64_init(&u64,0,x);
		*result=p_lpint(&u64);
	}
#else
	*result=p_lpint(x);
#endif
	return PRIM_SUCCESS;
}

DEFPRIM(sint_asFloat)
{
	*result=p_float(sint_val(self));
	return PRIM_SUCCESS;
}
