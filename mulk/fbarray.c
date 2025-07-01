/*
	FixedByteArray class.
	$Id: mulk fbarray.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include <string.h>

#include "mem.h"

#include "om.h"
#include "prim.h"

DEFPRIM(fbarray_bytesHash)
{
	*result=sint(om_bytes_hash(self->fbarray.elt,self->fbarray.size,
		args[0]==om_true));
	return PRIM_SUCCESS;	
}

static int fbarray_p(object fba)
{
	int fsize;
	fsize=om_size(fba);
	return fsize==SIZE_FBARRAY||fsize==SIZE_STRING||fsize==SIZE_SYMBOL;
}

DEFPRIM(fbarray_copy)
{
	int tp,fp,s;
	object from;

	from=args[1];
	if(!fbarray_p(from)) return PRIM_ERROR;
	GET_SINT_ARG(0,tp);
	GET_SINT_ARG(2,fp);
	GET_SINT_ARG(3,s);

	if(s<0) return PRIM_ERROR;
	if(!(0<=tp&&tp+s<=self->fbarray.size)) return PRIM_ERROR;
	if(!(0<=fp&&fp+s<=from->fbarray.size)) return PRIM_ERROR;

	memmove(self->fbarray.elt+tp,from->fbarray.elt+fp,s);
	return PRIM_SUCCESS;
}

DEFPRIM(fbarray_unmatchIndex)
{
	int sp,fp,sz,i;
	object fba;

	fba=args[1];
	if(!fbarray_p(fba)) return PRIM_ERROR;
	GET_SINT_ARG(0,sp);
	GET_SINT_ARG(2,fp);
	GET_SINT_ARG(3,sz);

	if(sz<0) return PRIM_ERROR;
	if(!(0<=sp&&sp+sz<=self->fbarray.size)) return PRIM_ERROR;
	if(!(0<=fp&&fp+sz<=fba->fbarray.size)) return PRIM_ERROR;
	for(i=0;i<sz;i++) {
		if(LC(self->fbarray.elt+sp+i)!=LC(fba->fbarray.elt+fp+i)) break;
	}
	if(i==sz) *result=om_nil;
	else *result=sint(sp+i);
	return PRIM_SUCCESS;
}

DEFPRIM(fbarray_index)
{
	int b,st,en,upper,i;
	
	GET_SINT_ARG(0,b);
	GET_SINT_ARG(1,st);
	GET_SINT_ARG(2,en);

	upper=self->fbarray.size-1;
	if(st==en||upper<0);
	else if(st<en) {
		en--;
		if(st<0) st=0;
		if(en>upper) en=upper;
		for(i=st;i<=en;i++) if(LC(self->fbarray.elt+i)==b) {
			*result=sint(i);
			return PRIM_SUCCESS;
		}
	} else {
		en++;
		if(en<0) en=0;
		if(st>upper) st=upper;
		for(i=st;i>=en;i--) if(LC(self->fbarray.elt+i)==b) {
			*result=sint(i);
			return PRIM_SUCCESS;
		}
	}
	*result=om_nil;
	return PRIM_SUCCESS;
}

DEFPRIM(fbarray_index2)
{
	object fba;
	int sz,st,en,upper,i;

	fba=args[0];
	if(!fbarray_p(fba)) return PRIM_ERROR;
	GET_SINT_ARG(1,sz);
	GET_SINT_ARG(2,st);
	GET_SINT_ARG(3,en);

	if(!(1<=sz&&sz<=fba->fbarray.size)) return PRIM_ERROR;
	upper=self->fbarray.size-sz;

	if(st==en||upper<0);
	else if(st<en) {
		en--;
		if(st<0) st=0;
		if(en>upper) en=upper;
		for(i=st;i<=en;i++) {
			if(memcmp(self->fbarray.elt+i,fba->fbarray.elt,sz)==0) {
				*result=sint(i);
				return PRIM_SUCCESS;
			}
		}
	} else {
		en++;
		if(en<0) en=0;
		if(st>upper) st=upper;
		for(i=st;i>=en;i--) {
			if(memcmp(self->fbarray.elt+i,fba->fbarray.elt,sz)==0) {
				*result=sint(i);
				return PRIM_SUCCESS;
			}
		}
	}
	*result=om_nil;
	return PRIM_SUCCESS;
}
