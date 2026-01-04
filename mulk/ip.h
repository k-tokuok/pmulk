/*
	interpreter.
	$Id: mulk ip.h 1510 2026-01-02 Fri 21:21:13 kt $
*/

extern int ip_trap_code;
#define TRAP_NONE 0
#define TRAP_INTERRUPT 1 /* ctrl-c */
#define TRAP_QUIT 2 /* for WM_CLOSE, etc */

extern void ip_start(object arg,int fs_size);
extern void ip_mark_object(int full_gc_p);

#if INTR_CHECK_P
extern void ip_intr_check(void);
#endif

/* Kernel property */
extern char *vm_fn;
extern char *image_fn;

#if WINDOWS_P
extern int codepage;
#endif
