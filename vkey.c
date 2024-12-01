/*
	view keyboard extention.
	$Id: mulk vkey.c 1313 2024-11-24 Sun 13:29:11 kt $
*/

#include "std.h"

#include <stdlib.h>
#include <string.h>

#include "heap.h"
#include "xbarray.h"
#include "xarray.h"
#include "csplit.h"
#include "pf.h"
#include "view.h"

#include "vkey.h"

static struct heap heap;

static int keyinfo_min,keyinfo_max;

struct keyinfo {
	int code;
	int normal;
	int shift;
	int ctrl;
	int left_p;
};
static struct keyinfo **keyinfo_table;
static struct keyinfo *modifier;
static int modifier_used_p;

#define MAX_ARG (VKEY_LAST+4)

void vkey_load_keymap(char *fn,int codeix)
{
	struct xbarray buf;
	int first_p,code,sz,i;
	struct xarray table;
	FILE *fp;
	char *ln,*cols[MAX_ARG];
	struct keyinfo *ki;
	
	if(keyinfo_min!=0||keyinfo_max!=0) heap_free(&heap);
	heap_init(&heap);		
	xbarray_init(&buf);
	xarray_init(&table);
	first_p=TRUE;
	keyinfo_min=keyinfo_max=0;
#if PF_OPEN_P
	fp=pf_open(fn,"r");
#else
	fp=fopen(fn,"r");
#endif
	if(fp==NULL) xerror("vkey_load_keymap: open %s failed",fn);
	while((ln=xbarray_fgets(&buf,fp))!=NULL) {
		if(*ln==';') continue;
		csplit(ln,cols,MAX_ARG);
		code=atoi(cols[codeix]);
		if(code==-1) continue;
		
		if(first_p) {
			keyinfo_min=keyinfo_max=code;
			first_p=FALSE;
		} else {
			if(keyinfo_min>code) keyinfo_min=code;
			if(keyinfo_max<code) keyinfo_max=code;
		}
		ki=heap_alloc(&heap,sizeof(struct keyinfo));
		ki->code=code;
		ki->normal=atoi(cols[VKEY_LAST]);
		ki->shift=atoi(cols[VKEY_LAST+1]);
		ki->ctrl=atoi(cols[VKEY_LAST+2]);
		ki->left_p=atoi(cols[VKEY_LAST+3]);
		xarray_add(&table,ki);
	}
	fclose(fp);
	xbarray_free(&buf);
	sz=(keyinfo_max-keyinfo_min+1)*sizeof(struct keyinfo);
	keyinfo_table=heap_alloc(&heap,sz);
	memset(keyinfo_table,0,sz);
	for(i=0;i<table.size;i++) {
		ki=table.elt[i];
		keyinfo_table[ki->code-keyinfo_min]=ki;
	}
	xarray_free(&table);
}

static struct keyinfo *lookup_keyinfo(int code)
{
	struct keyinfo *result;
	result=NULL;
	if(keyinfo_min<=code&&code<=keyinfo_max) {
		result=keyinfo_table[code-keyinfo_min];
	}
	return result;
}

#define SELECT_NORMAL 0
#define SELECT_SHIFT 1
#define SELECT_CTRL 2

int vkey_down(int code)
{
	struct keyinfo *ki;
	int select;
	
	ki=lookup_keyinfo(code);
	if(ki==NULL) return -1;
	select=SELECT_NORMAL;
	if(vkey_press_check(VKEY_SHIFT)) select=SELECT_SHIFT;
	else if(vkey_press_check(VKEY_CTRL)) select=SELECT_CTRL;
	else {
		if(view_shift_mode==VIEW_CROSS_SHIFT) {
			if(vkey_press_check(VKEY_NONCONVERT)) {
				if(ki->left_p) select=SELECT_CTRL;
				else select=SELECT_SHIFT;
			} else if(vkey_press_check(VKEY_CONVERT)) {
				if(ki->left_p) select=SELECT_SHIFT;
				else select=SELECT_CTRL;
			}
		} else {
			if(ki->normal==' ') {
				modifier=ki;
				modifier_used_p=FALSE;
				return -1;
			} else {
				if(modifier!=NULL) {
					select=SELECT_SHIFT;
					modifier_used_p=TRUE;
				} else if(vkey_press_check(VKEY_NONCONVERT)
					||vkey_press_check(VKEY_CONVERT)) select=SELECT_CTRL;
			}
		}
	}
	if(select==SELECT_NORMAL) return ki->normal;
	else if(select==SELECT_SHIFT) return ki->shift;
	else return ki->ctrl;
}

int vkey_up(int code)
{
	struct keyinfo *ki;
	
	ki=lookup_keyinfo(code);
	if(ki==NULL) return -1;
	if(modifier==ki) {
		modifier=NULL;
		if(modifier_used_p) return -1;
		if(vkey_press_check(VKEY_CTRL)||vkey_press_check(VKEY_CONVERT)
			||vkey_press_check(VKEY_NONCONVERT)) return ki->ctrl;
		else return ki->normal;
	}
	return -1;
}
