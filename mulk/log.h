/*
	xc log.
	$Id: mulk log.h 1433 2025-06-03 Tue 21:15:38 kt $
*/

extern void log_open(char *fn);
extern int log_p(void);
extern void log_c(int ch);
extern void log_ln(void);
extern void log_f(char *fmt,...);
extern void log_close(void);
