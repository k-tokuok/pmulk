/*
	View (primitive implemented/View.p)
	$Id: mulk view.c 1320 2024-12-01 Sun 17:22:18 kt $
*/

#include "std.h"

#include "om.h"
#include "xwchar.h"

#include "view.h"

int view_update_interval;
int view_shift_mode;
int view_event_filter;

#include "prim.h"

DEFPRIM(view_open)
{
	int width,height;
	GET_SINT_ARG(0,width);
	GET_SINT_ARG(1,height);
	view_open(width,height);
	return PRIM_SUCCESS;
}

DEFPRIM(view_set_font)
{
	char *font;
	struct xbarray xba;
	if((font=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	*result=sint(view_set_font(font));
	xbarray_free(&xba);
	return PRIM_SUCCESS;
}

DEFPRIM(view_close)
{
	view_close();
	return PRIM_SUCCESS;
}

DEFPRIM(view_fill_rectangle)
{
	int x,y,width,height,color;
	GET_SINT_ARG(0,x);
	GET_SINT_ARG(1,y);
	GET_SINT_ARG(2,width);
	GET_SINT_ARG(3,height);
	GET_SINT_ARG(4,color);
	view_fill_rectangle(x,y,width,height,color);
	return PRIM_SUCCESS;
}

DEFPRIM(view_draw_char)
{
	int x,y,color;
	uint64_t wc;

	GET_SINT_ARG(0,x);
	GET_SINT_ARG(1,y);
	if(!p_uint64_val(args[2],&wc)) return PRIM_ERROR;
	if(wc>XWCHAR_MAX_VAL) return PRIM_ERROR;
	GET_SINT_ARG(3,color);
	view_draw_char(x,y,wc,color);
	return PRIM_SUCCESS;
}

DEFPRIM(view_draw_line)
{
	int x0,y0,x1,y1,color;
	GET_SINT_ARG(0,x0);
	GET_SINT_ARG(1,y0);
	GET_SINT_ARG(2,x1);
	GET_SINT_ARG(3,y1);
	GET_SINT_ARG(4,color);
	view_draw_line(x0,y0,x1,y1,color);
	return PRIM_SUCCESS;
}

DEFPRIM(view_put_true_color_image)
{
	int x,y,w,h;
	object rgb;
	
	GET_SINT_ARG(0,x);
	GET_SINT_ARG(1,y);
	rgb=args[2];
	if(om_class(rgb)!=om_FixedByteArray) return PRIM_ERROR;
	GET_SINT_ARG(3,w);
	GET_SINT_ARG(4,h);
	view_put_true_color_image(x,y,rgb->fbarray.elt,w,h);
	return PRIM_SUCCESS;
}

DEFPRIM(view_draw_polygon)
{
	object pts;
	int points[VIEW_MAX_POLYGON_POINT*2],n,color,i;

	pts=args[0];
	if(om_class(pts)!=om_FixedArray) return PRIM_ERROR;
	n=pts->farray.size;
	if(!(6<=n&&n<VIEW_MAX_POLYGON_POINT*2)) return PRIM_ERROR;
	for(i=0;i<n;i++) {
		if(!sint_p(pts->farray.elt[i])) return PRIM_ERROR;
		points[i]=sint_val(pts->farray.elt[i]);
	}
	GET_SINT_ARG(1,color);
	view_draw_polygon(points,n/2,color);
	return PRIM_SUCCESS;
}

DEFPRIM(view_put_monochrome_image)
{
	int x,y,w,h,color,bkcolor;
	object bits;
	
	GET_SINT_ARG(0,x);
	GET_SINT_ARG(1,y);
	bits=args[2];
	if(om_class(bits)!=om_FixedByteArray) return PRIM_ERROR;
	GET_SINT_ARG(3,w);
	GET_SINT_ARG(4,h);
	GET_SINT_ARG(5,color);
	GET_SINT_ARG(6,bkcolor);
	view_put_monochrome_image(x,y,bits->fbarray.elt,w,h,color,bkcolor);
	return PRIM_SUCCESS;
}

DEFPRIM(view_get_event)
{
	*result=sint(view_get_event());
	return PRIM_SUCCESS;
}

DEFPRIM(view_event_empty_p)
{
	*result=om_boolean(view_event_empty_p());
	return PRIM_SUCCESS;
}

DEFPROPERTY(view)
{
	struct xbarray xba;
	char *fn;
	int v,w,h;
	
	switch(key) {
	case 200:
		*result=sint(view_update_interval);
		if(sint_p(value)) view_update_interval=sint_val(value);
		break;
	case 201:
		*result=sint(view_event_filter);
		if(sint_p(value)) view_event_filter=sint_val(value);
		break;
	case 202:
		if((fn=p_string_val(value,&xba))==NULL) return PRIM_ERROR;
		view_load_keymap(fn);
		xbarray_free(&xba);
		break;
	case 203:
		*result=sint(view_shift_mode);
		if(sint_p(value)) view_shift_mode=sint_val(value);
		break;
	case 204:
		if(sint_p(value)) {
			v=sint_val(value);
			view_move(COORD_X(v),COORD_Y(v));
		} 
		break;
	case 205:
		if(sint_p(value)) {
			v=sint_val(value);
			view_resize(COORD_X(v),COORD_Y(v));
		}
		break;
	case 206:
		view_get_screen_size(&w,&h);
		*result=sint(coord(w,h));
		break;
	default:
		return PRIM_ANOTHER_PROPERTY;
	}
	return PRIM_SUCCESS;
}
