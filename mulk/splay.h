/*
	xc splay tree.
	$Id: mulk splay.h 1433 2025-06-03 Tue 21:15:38 kt $
*/

struct splay {
	struct splay_node {
		void *key,*data;
		struct splay_node *left,*right;
	} *top;
	int (*cmp)(void *p,void *q);
};

extern void splay_init(struct splay *s,int (*cmp)(void *p,void *q));
extern void splay_add(struct splay *s,void *k,void *d);
extern void *splay_find(struct splay *s,void *k);
extern void splay_delete(struct splay *s,void *k);
extern void splay_free(struct splay *s);
extern void splay_foreach(struct splay *s,
	void (*func)(int depth,void *key,void *data));
