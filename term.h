/*
	Terminal class.
	$Id: mulk term.h 636 2021-01-09 Sat 22:11:47 kt $
*/

#include "coord.h"
extern int term_start(void); /*return screen size coord*/
extern void term_finish(void);

extern int term_get(void);
extern void term_put(char *p,int size);
extern int term_hit_p(void);
extern void term_goto_xy(int x,int y);
extern void term_clear(void);
