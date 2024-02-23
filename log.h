/*
	xc log.
	$Id: mulk log.h 406 2020-04-19 Sun 11:29:54 kt $
*/

extern void log_open(char *fn);
extern int log_p(void);
extern void log_c(int ch);
extern void log_ln(void);
extern void log_f(char *fmt,...);
extern void log_close(void);
