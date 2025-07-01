/*
	xc extensible array.
	$Id: mulk xarray.h 1433 2025-06-03 Tue 21:15:38 kt $
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
