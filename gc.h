/*
	garbage collector.
	$Id: mulk gc.h 406 2020-04-19 Sun 11:29:54 kt $
*/

extern object gc_object_new(object xclass,int ext);
extern void gc_refer(object from,object to);
extern void gc_regist_refnew(object o);
extern int gc_mark(object o);
extern void gc_full(void);
extern void gc_chance(void);
extern void gc_init(void);
extern void gc_finish(void);
extern object gc_string(char *s);
