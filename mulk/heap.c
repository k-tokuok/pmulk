/*
	xc heap.
	$Id: mulk heap.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <string.h>
#include <stddef.h>

#include "heap.h"

struct heap heap_perm={NULL,NULL};

void heap_init(struct heap *h)
{
	h->block=NULL;
	h->tail=NULL;
}

static int gap_to_align(int offset,int align)
{
	if(offset%align==0) return 0;
	else return align-offset%align;
}

#define BLOCK_TOP offsetof(struct heap_block,buf[0])

static void *independent_alloc(struct heap *h,int size,int align)
{
	int gap;
	struct heap_block *n;

	gap=gap_to_align(BLOCK_TOP,align);
	n=xmalloc(BLOCK_TOP+gap+size);
	if(h->block==NULL) h->block=n;
	else {
		n->next=h->block->next;
		h->block->next=n;
	}
	return n->buf+gap;
}

void *heap_alloc_align(struct heap *h,int size,int align)
{
	int topgap,used,gap;
	struct heap_block *n;
		
	if(size==0) return NULL;

	topgap=gap_to_align(BLOCK_TOP,align);
	if(topgap+size>HEAP_BLOCK_SIZE) return independent_alloc(h,size,align);

	if(h->tail!=NULL) {
		used=(int)(h->tail-h->block->buf);
		gap=gap_to_align(BLOCK_TOP+used,align);
		if(used+gap+size<=HEAP_BLOCK_SIZE) {
			h->tail+=gap+size;
			return h->tail-size;
		} else if(used<HEAP_BLOCK_SIZE/2) {
			return independent_alloc(h,size,align);
		}
	}

	n=xmalloc(sizeof(struct heap_block));
	n->next=h->block;
	h->block=n;
	h->tail=n->buf+topgap+size;
	return h->tail-size;	
}

#ifdef __sparc__
/* sparc32 require 8 byte alignment for access int64_t */
#define ALIGN 8
#endif

#ifndef ALIGN
/* usually secures alignment at ptr size */
#define ALIGN (sizeof(void*))
#endif

void *heap_alloc(struct heap *h,int size)
{
	return heap_alloc_align(h,size,ALIGN);
}

void heap_free(struct heap *h)
{
	struct heap_block *b,*n;
	
	b=h->block;
	while(b!=NULL) {
		n=b->next;
		xfree(b);
		b=n;
	}
}

char *heap_strdup(struct heap *h,char *s)
{
	return strcpy(heap_alloc_align(h,strlen(s)+1,1),s);
}
