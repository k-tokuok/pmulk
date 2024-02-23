/*
    character queue.
	$Id: mulk cqueue.h 406 2020-04-19 Sun 11:29:54 kt $
*/

#define CQUEUE_BUF 80

struct cqueue {
	char buf[CQUEUE_BUF];
	int inpos;
	int outpos;
};

extern void cqueue_reset(struct cqueue *q);
extern void cqueue_put(struct cqueue *q,int ch);
extern int cqueue_get(struct cqueue *q);
extern int cqueue_empty_p(struct cqueue *q);
