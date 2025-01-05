/*
	interpreter.
	$Id: mulk ip.h 1327 2024-12-08 Sun 11:38:07 kt $
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

/* Kernel property */
extern char *vm_fn;
extern char *image_fn;

#if WINDOWS_P
extern int codepage;
#endif
