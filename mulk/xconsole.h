/*
	xconsole -- basic console IO for terminal less system.
	$Id: mulk xconsole.h 1433 2025-06-03 Tue 21:15:38 kt $
*/

extern void xputc(int ch);
extern void xputs(char *s);
extern void xexit(void) GCC_NORETURN;
