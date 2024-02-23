/*
    character queue.
	$Id: mulk cqueue.c 406 2020-04-19 Sun 11:29:54 kt $
*/

#include "std.h"
#include "cqueue.h"
#include "mem.h"

void cqueue_reset(struct cqueue *q)
{
	q->inpos=0;
	q->outpos=0;
}

void cqueue_put(struct cqueue *q,int ch)
{
	int next;
	next=(q->inpos+1)%CQUEUE_BUF;
	if(next==q->outpos) cqueue_get(q); /* if overflow, drop next */
	q->buf[q->inpos]=ch;
	q->inpos=next;
}

int cqueue_get(struct cqueue *q)
{
	int ch;
	ch=LC(q->buf+q->outpos);
	q->outpos=(q->outpos+1)%CQUEUE_BUF;
	return ch;
}

int cqueue_empty_p(struct cqueue *q)
{
	return q->inpos==q->outpos;
}
