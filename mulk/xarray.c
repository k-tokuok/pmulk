/*
	xc extensible array.
	$Id: mulk xarray.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include "xarray.h"

void xarray_reset(struct xarray *x)
{
	x->size=0;
}

void xarray_init(struct xarray *x)
{
	x->elt=NULL;
	x->alloc_size=0;
	xarray_reset(x);
}

static void extend(struct xarray *x,int size)
{
	int newsize;

	newsize=x->alloc_size;
	if(newsize==0) newsize=4;
	while(newsize<size) newsize*=2;

	x->elt=xrealloc(x->elt,newsize*sizeof(void*));
	x->alloc_size=newsize;
}

void xarray_add(struct xarray *x,void *d)
{
	if(x->size==x->alloc_size) extend(x,x->size+1);
	x->elt[x->size++]=d;
}

void xarray_free(struct xarray *x)
{
	xfree(x->elt);
}

void xarray_resize(struct xarray *x,int newsize)
{
	while(x->size<newsize) xarray_add(x,NULL);
	x->size=newsize;
}
