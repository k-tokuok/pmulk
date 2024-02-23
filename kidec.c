/*
	keyboard input decoder.
	$Id: mulk kidec.c 906 2022-08-14 Sun 20:39:37 kt $
*/

#include "std.h"

#include <stdlib.h>
#include <string.h>

#include "xbarray.h"
#include "xarray.h"
#include "csplit.h"
#include "ki.h"
#include "kidec.h"
#include "pf.h"

int kidec_keymap_loaded_p(struct kidec *kidec)
{
	return kidec->min!=0||kidec->max!=0;
}

#define MAX_ARG (KI_LAST+4)

void kidec_load_keymap(struct kidec *kidec,char *keymapfn,int codeix)
{
	struct xbarray buf;
	struct xarray table;
	int first_p,min,max,keycode,sz,i;
	FILE *fp;
	struct keyinfo *ki;
	char *ln,*cols[MAX_ARG];
	
	if(kidec_keymap_loaded_p(kidec)) heap_free(&kidec->heap);
	xbarray_init(&buf);
	xarray_init(&table);
	heap_init(&kidec->heap);
	first_p=TRUE;
	min=0;
	max=0;
#if PF_OPEN_P
	fp=pf_open(keymapfn,"r");
#else
	fp=fopen(keymapfn,"r");
#endif
	if(fp==NULL) xerror("kidec_init: open %s failed.",keymapfn);
	while((ln=xbarray_fgets(&buf,fp))!=NULL) {
		if(*ln==';') continue;
		csplit(ln,cols,MAX_ARG);
		keycode=atoi(cols[codeix]);
		if(keycode==-1) continue;
		
		if(first_p) {
			min=keycode;
			max=keycode;
			first_p=FALSE;
		} else {
			if(min>keycode) min=keycode;
			if(max<keycode) max=keycode;
		}
		ki=heap_alloc(&kidec->heap,sizeof(struct keyinfo));
		ki->code=keycode;
		ki->normal=atoi(cols[KI_LAST]);
		ki->shift=atoi(cols[KI_LAST+1]);
		ki->ctrl=atoi(cols[KI_LAST+2]);
		ki->left_p=atoi(cols[KI_LAST+3]);
		xarray_add(&table,ki);
	}
	fclose(fp);
	xbarray_free(&buf);
	sz=(max-min+1)*sizeof(struct keyinfo);
	kidec->keyinfo_table=heap_alloc(&kidec->heap,sz);
	memset(kidec->keyinfo_table,0,sz);
	for(i=0;i<table.size;i++) {
		ki=table.elt[i];
		kidec->keyinfo_table[ki->code-min]=ki;
	}
	xarray_free(&table);
	kidec->min=min;
	kidec->max=max;
	kidec->modifier=NULL;
}

static struct keyinfo *lookup_keyinfo(struct kidec *kidec,int code)
{
	struct keyinfo *result;
	result=NULL;
	if(kidec->min<=code&&code<=kidec->max) {
		result=kidec->keyinfo_table[code-kidec->min];
	}
	return result;
}

#define SELECT_NORMAL 0
#define SELECT_SHIFT 1
#define SELECT_CTRL 2

int kidec_down(struct kidec *kidec,int code)
{
	int select;
	struct keyinfo *ki;
	
	ki=lookup_keyinfo(kidec,code);
	if(ki==NULL) return -1;
	select=SELECT_NORMAL;
	if(kidec->press_check(KI_SHIFT)) select=SELECT_SHIFT;
	else if(kidec->press_check(KI_CTRL)) select=SELECT_CTRL;
	else {
		if(kidec->mode==KI_CROSS_SHIFT) {
			if(kidec->press_check(KI_NONCONVERT)) {
				if(ki->left_p) select=SELECT_CTRL;
				else select=SELECT_SHIFT;
			} else if(kidec->press_check(KI_CONVERT)) {
				if(ki->left_p) select=SELECT_SHIFT;
				else select=SELECT_CTRL;
			}
		} else {
			if(ki->normal==' ') {
				kidec->modifier=ki;
				kidec->modifier_used_p=FALSE;
				return -1;
			} else {
				if(kidec->modifier!=NULL) {
					select=SELECT_SHIFT;
					kidec->modifier_used_p=TRUE;
				} else if(kidec->press_check(KI_NONCONVERT)
						||kidec->press_check(KI_CONVERT)) select=SELECT_CTRL;
			}
		}
	}
	if(select==SELECT_NORMAL) return ki->normal;
	else if(select==SELECT_SHIFT) return ki->shift;
	else return ki->ctrl;
}

int kidec_up(struct kidec *kidec,int code)
{
	struct keyinfo *ki;
	
	ki=lookup_keyinfo(kidec,code);
	if(ki==NULL) return -1;
	if(kidec->modifier==ki) {
		kidec->modifier=NULL;
		if(kidec->modifier_used_p) return -1;
		if(kidec->press_check(KI_CTRL)||kidec->press_check(KI_CONVERT)
				||kidec->press_check(KI_NONCONVERT)) return 0;
		else return ' ';
	}
	return -1;
}
