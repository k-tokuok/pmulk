/*
	interpreter.
	$Id: mulk ip.h 406 2020-04-19 Sun 11:29:54 kt $
*/

extern int ip_trap_code;
#define TRAP_NONE 0
#define TRAP_ERROR 1
#define TRAP_INTERRUPT 2 /* ctrl-c */
#define TRAP_QUIT 3 /* for WM_CLOSE, etc */

extern void ip_start(object arg,int fs_size,int cs_size);
extern void ip_mark_object(int full_gc_p);
