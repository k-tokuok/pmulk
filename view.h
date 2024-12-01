/*
	View (primitive implement)
	$Id: mulk view.h 1320 2024-12-01 Sun 17:22:18 kt $
*/

#include "coord.h"

/* view.c */
extern int view_update_interval;

extern int view_shift_mode;
#define VIEW_GENERIC_SHIFT (-1)
#define VIEW_CROSS_SHIFT 0
#define VIEW_SPACE_SHIFT 1

extern int view_event_filter;
#define VEVENT_CHAR 0 /* OPR=ASCII CODE */
#define VEVENT_PTRDOWN 1 /* OPR=COORD */
#define VEVENT_PTRDRAG 2
#define VEVENT_PTRUP 3

#define VEVENT_OPR_OFF 2 

#define VIEW_MAX_POLYGON_POINT 20

/* view*.c */
extern void view_open(int width,int height);
extern int view_set_font(char *font_name);
extern void view_move(int x,int y);
extern void view_resize(int width,int height);
extern void view_close(void);

extern void view_fill_rectangle(int x,int y,int width,int height,int color);
extern void view_draw_char(int x,int y,uint64_t wc,int color);
extern void view_draw_line(int x0,int y0,int x1,int y1,int color);
extern void view_put_true_color_image(int x,int y,char *rgb,int w,int h);
extern void view_draw_polygon(int *pts,int n,int color);
extern void view_put_monochrome_image(int x,int y,char *bits,int w,int h,
	int color,int bkcolor);
extern void view_load_keymap(char *fn);
extern int view_get_event(void);
extern int view_event_empty_p(void);
extern void view_get_screen_size(int *w,int *h);
