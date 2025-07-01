/*
	int queue.
	$Id: mulk iqueue.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include "iqueue.h"

void iqueue_reset(struct iqueue *q)
{
	q->inpos=0;
	q->outpos=0;
}

void iqueue_put(struct iqueue *q,int val)
{
	int next;
	next=(q->inpos+1)%IQUEUE_BUF;
	if(next==q->outpos) xerror("iqueue full.");
	q->buf[q->inpos]=val;
	q->inpos=next;
}

int iqueue_get(struct iqueue *q)
{
	int result;
	result=q->buf[q->outpos];
	q->outpos=(q->outpos+1)%IQUEUE_BUF;
	return result;
}

int iqueue_empty_p(struct iqueue *q)
{
	return q->inpos==q->outpos;
}

	
	
