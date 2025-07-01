/*
	view keyboard extention.
	$Id: mulk vkey.h 1433 2025-06-03 Tue 21:15:38 kt $
*/
#define VKEY_WINDOWS 0
#define VKEY_SDL 1
#define VKEY_ANDROID 2
#define VKEY_LAST 3

extern void vkey_load_keymap(char *fn,int codeix);
extern int vkey_down(int code);
extern int vkey_up(int code);

/* press_check -- archtecture dependent */
#define VKEY_SHIFT 0
#define VKEY_CTRL 1
#define VKEY_CONVERT 2
#define VKEY_NONCONVERT 3

extern int vkey_press_check(int vkey_code);
