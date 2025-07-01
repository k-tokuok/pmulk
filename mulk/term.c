/*
	Terminal class.
	$Id: mulk term.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include "term.h"
#include "xwchar.h"
#include "om.h"

#include "prim.h"

DEFPRIM(term_start)
{
	*result=sint(term_start());
	return PRIM_SUCCESS;
}

DEFPRIM(term_finish)
{
	term_finish();
	return PRIM_SUCCESS;
}

DEFPRIM(term_get)
{
	*result=sint(term_get());
	return PRIM_SUCCESS;
}

DEFPRIM(term_put)
{
#if U64_P
	uint32_t wc;
#else
	uint64_t wc;
#endif
	char buf[XWCHAR_MAX_LEN];
	int len;
	
#if U64_P
	if(!p_uint32_val(args[0],&wc)) return PRIM_ERROR;
#else
	if(!p_uint64_val(args[0],&wc)) return PRIM_ERROR;
#endif
	if(wc>XWCHAR_MAX_VAL) return PRIM_ERROR;
	len=xwchar_to_mbytes(wc,buf);
	term_put(buf,len);
	return PRIM_SUCCESS;
}

DEFPRIM(term_hit_p)
{
	*result=om_boolean(term_hit_p());
	return PRIM_SUCCESS;
}

DEFPRIM(term_goto_xy)
{
	int x,y;
	GET_SINT_ARG(0,x);
	GET_SINT_ARG(1,y);
	term_goto_xy(x,y);
	return PRIM_SUCCESS;
}

DEFPRIM(term_clear)
{
	term_clear();
	return PRIM_SUCCESS;
}
