/*
	xconsole -- basic console IO for terminal less system.
	$Id: mulk xconsole.h 1085 2023-06-30 Fri 20:53:36 kt $
*/

extern void xputc(int ch);
extern void xputs(char *s);
extern void xexit(void) GCC_NORETURN;
