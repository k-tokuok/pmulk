/*
	primitive support.
	$Id: mulk prim.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <limits.h>
#include <string.h>

#include "mem.h"

#include "om.h"
#include "gc.h"
#include "prim.h"

char *p_string_val(object o,struct xbarray *x)
{
	if(om_class(o)!=om_String) return NULL;
	xbarray_init(x);
	memcpy(xbarray_reserve(x,o->fbarray.size),o->fbarray.elt,o->fbarray.size);
	xbarray_add(x,'\0');
	return x->elt;
}

object p_string_xbarray(struct xbarray *x)
{
	object result;
	result=gc_object_new(om_String,x->size);
	memcpy(result->fbarray.elt,x->elt,x->size);
	om_set_string_hash(result);
	return result;
}

int p_byte_p(int b)
{
	return 0<=b&&b<256;
}

int p_farray_to_array(object fa,int *size,object **array)
{
	if(fa==om_nil) {
		*size=0;
		*array=NULL;
	} else if(om_class(fa)==om_FixedArray) {
		*size=fa->farray.size;
		*array=fa->farray.elt;
	} else return FALSE;

	return TRUE;
}

#if U64_P
object p_lpint(u64_t *u64)
{
	object result;
	result=gc_object_new(om_LongPositiveInteger,0);
	result->lpint.val=*u64;
	om_set_hash(result,om_number_hash(u64_double(u64)));
	return result;
}
#else
object p_lpint(uint64_t val)
{
	object result;
	result=gc_object_new(om_LongPositiveInteger,0);
	result->lpint.val=val;
	om_set_hash(result,om_number_hash((double)val));
	return result;
}
#endif

#if U64_P
object p_uint32(uint32_t val)
{
	u64_t u64;
	if(val<=SINT_MAX) return sint((int)val);

	u64_init(&u64,0,val);
	return p_lpint(&u64);
}
#else
object p_uint64(uint64_t val)
{
	if(val<=SINT_MAX) return sint((int)val);
	return p_lpint(val);
}
#endif

#if U64_P
int p_uint32_val(object o,uint32_t *valp)
{
	int si;
	if(sint_p(o)) {
		si=sint_val(o);
		if(si<0) return FALSE;
		*valp=si;
	} else if(om_class(o)==om_LongPositiveInteger) {
		if(!u64_val(&o->lpint.val,valp)) return FALSE;
	} else return FALSE;
	return TRUE;
}
#else
int p_uint64_val(object o,uint64_t *valp)
{
	int si;
	if(sint_p(o)) {
		si=sint_val(o);
		if(si<0) return FALSE;
		*valp=si;
	} else if(om_class(o)==om_LongPositiveInteger) *valp=o->lpint.val;
	else return FALSE;
	return TRUE;
}
#endif

#if U64_P
object p_uintptr(uintptr_t val)
{
	return p_uint32(val);
}
#else
object p_uintptr(uintptr_t val)
{
	return p_uint64(val);
}
#endif

#if U64_P
int p_uintptr_val(object o,uintptr_t *valp)
{
	uint32_t u32;
	if(!p_uint32_val(o,&u32)) return FALSE;
	*valp=u32;
	return TRUE;
}
#else
int p_uintptr_val(object o,uintptr_t *valp)
{
	uint64_t u64;
	if(!p_uint64_val(o,&u64)) return FALSE;
	if(u64>(uint64_t)UINTPTR_MAX) return FALSE;
	*valp=(uintptr_t)u64;
	return TRUE;
}
#endif

object p_float(double val)
{
	object o;
	o=gc_object_new(om_Float,0);
	o->xfloat.val=val;
	om_set_hash(o,om_number_hash(val));
	return o;
}

int p_float_val(object o,double *valp)
{
	if(om_class(o)==om_Float) {
		*valp=o->xfloat.val;
		return TRUE;
	}
	return FALSE;
}
