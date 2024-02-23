/*
	primitive support.
	$Id: mulk prim.h 1091 2023-07-16 Sun 07:11:27 kt $
*/

#define PRIM_SUCCESS 0
#define PRIM_ERROR 1
#define PRIM_ARG_ERROR 2

#include "xbarray.h"
#define DEFPRIM(name) int prim_##name(object self,object *args,object *result)

#define GET_SINT_ARG(i,num) \
{ \
	object o; \
	o=args[i]; \
	if(!sint_p(o)) return PRIM_ARG_ERROR; \
	num=sint_val(o); \
}

extern char *p_string_val(object,struct xbarray *x);
extern object p_string_xbarray(struct xbarray *x);
extern int p_byte_p(int byte);
extern int p_farray_to_array(object fa,int *size,object **array);

#if U64_P
extern object p_lpint(u64_t *u64);
extern object p_uint32(uint32_t val);
extern int p_uint32_val(object o,uint32_t *valp);
#else
extern object p_lpint(uint64_t val);
extern object p_uint64(uint64_t val);
extern int p_uint64_val(object o,uint64_t *valp);
#endif

extern object p_uintptr(uintptr_t val);
extern int p_uintptr_val(object o,uintptr_t *valp);
extern object p_float(double val);
extern int p_float_val(object o,double *valp);
