/*
	xc extensible byte array.
	$Id: mulk xbarray.h 406 2020-04-19 Sun 11:29:54 kt $
*/

#ifndef INCLUDE_XBARRAY_H
#define INCLUDE_XBARRAY_H

struct xbarray {
	char *elt;
	int size;
	int alloc_size;
};

extern void xbarray_reset(struct xbarray *x);
extern void xbarray_init(struct xbarray *x);
extern void xbarray_free(struct xbarray *x);
extern char *xbarray_reserve(struct xbarray *x,int size);
extern void xbarray_add(struct xbarray *x,int ch);
extern void xbarray_adds(struct xbarray *x,char *s);
extern void xbarray_addf(struct xbarray *x,char *fmt,...);

extern char *xbarray_fgets(struct xbarray *x,FILE *fp);

#endif
