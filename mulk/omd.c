/*
	object memory describe.
	$Id: mulk omd.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <string.h>

#include "log.h"
#include "xbarray.h"

#include "om.h"

static void add_fbarray_string(struct xbarray *x,object o)
{
#ifndef NDEBUG
	int size;
	size=om_size(o);
	xassert(size==SIZE_FBARRAY||size==SIZE_STRING||size==SIZE_SYMBOL);
#endif
	memcpy(xbarray_reserve(x,o->fbarray.size),o->fbarray.elt,o->fbarray.size);
}

char *om_describe(char *buf,object o)
{
	struct xbarray x;
	object xclass;

	xbarray_init(&x);

	xclass=om_class(o);
	if(xclass==om_ShortInteger) {
		xbarray_addf(&x,"%d",sint_val(o));
	} else if(xclass==om_LongPositiveInteger) {
		xbarray_addf(&x,"%llu",o->lpint.val);
	} else if(xclass==om_Float) {
		xbarray_addf(&x,"%g",o->xfloat.val);
	} else if(xclass==om_String) {
		xbarray_add(&x,'"');
		add_fbarray_string(&x,o);
		xbarray_add(&x,'"');
	} else if(xclass==om_Symbol) {
		xbarray_add(&x,'#');
		add_fbarray_string(&x,o);
	} else if(xclass==om_Class) {
		add_fbarray_string(&x,o->xclass.name);
	} else {
		xbarray_add(&x,'a');
		add_fbarray_string(&x,xclass->xclass.name);
		if(xclass==om_Method&&om_class(o->method.belong_class)==om_Class) {
			xbarray_add(&x,'(');
			add_fbarray_string(&x,o->method.belong_class->xclass.name);
			xbarray_adds(&x," >> ");
			add_fbarray_string(&x,o->method.selector);
			xbarray_add(&x,')');
		}
	}
	xbarray_add(&x,'\0');

	if(x.size<=MAX_STR_LEN) memcpy(buf,x.elt,x.size);
	else {
		memcpy(buf,x.elt,MAX_STR_LEN-4);
		strcpy(buf+MAX_STR_LEN-4,"...");
	}

	xbarray_free(&x);
	return buf;
}

void om_log_symbol(object o)
{
	struct xbarray x;
	xbarray_init(&x);
	add_fbarray_string(&x,o);
	xbarray_add(&x,'\0');
	log_f("%s",x.elt);
	xbarray_free(&x);
}
