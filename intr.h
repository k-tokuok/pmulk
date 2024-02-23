/*
	interrupt.
	$Id: mulk intr.h 636 2021-01-09 Sat 22:11:47 kt $
*/
extern void intr_init(void);
#if INTR_CHECK_P
extern void intr_check(void);
#endif
