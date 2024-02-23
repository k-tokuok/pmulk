/*
	int queue.
	$Id: mulk iqueue.h 406 2020-04-19 Sun 11:29:54 kt $
*/

#define IQUEUE_BUF 255

struct iqueue {
	int buf[IQUEUE_BUF];
	int inpos;
	int outpos;
};

extern void iqueue_reset(struct iqueue *q);
extern void iqueue_put(struct iqueue *q,int val);
extern int iqueue_get(struct iqueue *q);
extern int iqueue_empty_p(struct iqueue *q);
