/*
	garbage collector.
	$Id: mulk gc.h 1433 2025-06-03 Tue 21:15:38 kt $
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
