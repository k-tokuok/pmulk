/*
	interpreter.
	$Id: mulk ip.h 1242 2024-05-26 Sun 09:33:41 kt $
*/

extern int ip_trap_code;
#define TRAP_NONE 0
#define TRAP_ERROR 1
#define TRAP_INTERRUPT 2 /* ctrl-c */
#define TRAP_QUIT 3 /* for WM_CLOSE, etc */

extern void ip_start(object arg,int fs_size);
extern void ip_mark_object(int full_gc_p);
