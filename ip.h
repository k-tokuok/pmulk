/*
	interpreter.
	$Id: mulk ip.h 1318 2024-12-01 Sun 14:28:50 kt $
*/

extern int ip_trap_code;
#define TRAP_NONE 0
#define TRAP_ERROR 1
#define TRAP_INTERRUPT 2 /* ctrl-c */
#define TRAP_QUIT 3 /* for WM_CLOSE, etc */

extern void ip_start(object arg,int fs_size);
extern void ip_mark_object(int full_gc_p);

#if INTR_CHECK_P
extern void ip_intr_check(void);
#endif
