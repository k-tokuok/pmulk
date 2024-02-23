/*
	View.p class.
	$Id: mulk viewp.h 1010 2023-02-01 Wed 22:44:35 kt $
*/

#include "view.h"
extern int view_update_interval;

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
extern int view_set_shift_mode(int mode);
extern void view_set_event_filter(int mode);
extern int view_get_event(void);
extern int view_event_empty_p(void);
