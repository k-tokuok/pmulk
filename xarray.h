/*
	xc extensible array.
	$Id: mulk xarray.h 406 2020-04-19 Sun 11:29:54 kt $
*/

struct xarray {
	void **elt;
	int size;
	int alloc_size;
};

extern void xarray_reset(struct xarray *x);
extern void xarray_init(struct xarray *x);
extern void xarray_add(struct xarray *x,void *d);
extern void xarray_free(struct xarray *x);
extern void xarray_resize(struct xarray *x,int newsize);
