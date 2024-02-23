/*
	keyboard input decoder.
	$Id: mulk kidec.h 842 2022-02-23 Wed 20:48:25 kt $
*/

#include "heap.h"

struct kidec {
	struct heap heap;
	int mode;
	int min;
	int max;
	struct keyinfo {
		int code;
		int normal;
		int shift;
		int ctrl;
		int left_p;
	} **keyinfo_table;
	int (*press_check)(int key);
	struct keyinfo *modifier;
	int modifier_used_p;
};

/* table code index */
#define KI_WINDOWS 0
#define KI_SDL 1
#define KI_ANDROID 2
#define KI_LAST 3

/* press_check arg */
#define KI_SHIFT 0
#define KI_CTRL 1
#define KI_CONVERT 2
#define KI_NONCONVERT 3

extern int kidec_keymap_loaded_p(struct kidec *kidec);
extern void kidec_load_keymap(struct kidec *kidec,char *keymap,int table_code);
extern int kidec_down(struct kidec *kidec,int code);
extern int kidec_up(struct kidec *kidec,int code);
