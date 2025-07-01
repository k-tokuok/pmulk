/*
	Terminal class.
	$Id: mulk term.h 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "coord.h"
extern int term_start(void); /*return screen size coord*/
extern void term_finish(void);

extern int term_get(void);
extern void term_put(char *p,int size);
extern int term_hit_p(void);
extern void term_goto_xy(int x,int y);
extern void term_clear(void);
