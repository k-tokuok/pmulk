/*
	garbage collector.
	$Id: mulk gc.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <string.h>

#include "log.h"

#include "om.h"
#include "ip.h"
#include "gc.h"

#ifdef GC_LOG
#include "omd.h"
#endif

/* header */

#define NEW0 0
#define NEW1 1
#define NEW2 2
#define OLD 3

static int generation(object o)
{
	return (o->header&HEADER_GENERATION_MASK)>>HEADER_GENERATION_POS;
}

static void set_generation(object o,int g)
{
	xassert(NEW0<=g&&g<=OLD);
	o->header=(o->header&~HEADER_GENERATION_MASK)|(g<<HEADER_GENERATION_POS);
}

static int alive_p(object o)
{
	return o->header&HEADER_ALIVE_BIT;
}

static void set_alive(object o,int ap)
{
	if(ap) o->header|=HEADER_ALIVE_BIT;
	else o->header&=~HEADER_ALIVE_BIT;
}

static int refnew_p(object o)
{
	return o->header&HEADER_REFNEW_BIT;
}

static void set_refnew(object o,int rp)
{
	if(rp) o->header|=HEADER_REFNEW_BIT;
	else o->header&=~HEADER_REFNEW_BIT;
}

/* object construct and regist */

object gc_object_new(object xclass,int ext)
{
	int size;
	object o;
	
	xassert(xclass->gobject.xclass==om_Class);
	xassert(ext>=0);
	
	size=sint_val(xclass->xclass.size);
	switch(size) {
	case SIZE_SINT:
		xassert(FALSE);
	case SIZE_FBARRAY:
	case SIZE_STRING:
	case SIZE_SYMBOL:
		o=om_alloc(sizeof(struct fbarray)+(ext-1));
		o->fbarray.size=ext;
		memset(o->fbarray.elt,0,ext);
		break;
	case SIZE_FARRAY:
		o=om_alloc(sizeof(struct farray)+(ext-1)*sizeof(object));
		o->farray.size=ext;
		om_init_array(o->farray.elt,ext);
		break;
	case SIZE_LPINT:
		o=om_alloc(sizeof(struct lpint));
		break;
	case SIZE_FLOAT:
		o=om_alloc(sizeof(struct xfloat));
		break;
	default:
		size+=ext&0xff;
		xassert(size<SIZE_LAST);
		xassert(xclass==om_Method||(ext>>8)==0)
		o=om_alloc(sizeof(struct gobject)+(size-1)*sizeof(object)+(ext>>8));
		o->gobject.xclass=xclass;
		om_init_array(o->gobject.elt,size);
		break;
	}

	om_init_hash(o);
	om_set_size(o,size);
	set_generation(o,NEW0);
	set_alive(o,FALSE);
	set_refnew(o,FALSE);

	xarray_add(&om_table,o);
	if(om_max_object_count<om_table.size) om_max_object_count=om_table.size;
	return o;
}

/* refnew stack */

static struct xarray refnew_table;

static void add_refnew(object o)
{
#ifdef GC_LOG
	if(log_p()) {
		char buf[MAX_STR_LEN];
		log_f("add_refnew %s\n",om_describe(buf,o));
	}
#endif
	xassert(generation(o)==OLD);
	xassert(refnew_p(o));
	xarray_add(&refnew_table,o);
}

void gc_refer(object from,object to)
{
	xassert(om_p(from));
	if(!om_p(to)) return;

	if(generation(from)==OLD&&generation(to)!=OLD) {
		if(!refnew_p(from)) {
			set_refnew(from,TRUE);
			add_refnew(from);
		}
	}
}

void gc_regist_refnew(object o)
{
	if(generation(o)==OLD&&!refnew_p(o)) {
		set_refnew(o,TRUE);
		add_refnew(o);
	}
}

/* gc */

static int new_top;
static int full_gc_p;
static int last_old_space_size;
static int last_new_space_size;

static struct xarray mark_stack;

int gc_mark(object o)
{
	int rn_p,g;
	
	if(!om_p(o)) return FALSE;

	rn_p=FALSE;
	if(full_gc_p) {
		if(!alive_p(o)) {
#ifdef GC_LOG
			if(log_p()) {
				char buf[MAX_STR_LEN];
				log_f("mark %p %s\n",o,om_describe(buf,o));
			}
#endif
			set_alive(o,TRUE);
			xarray_add(&mark_stack,o);
		}
	} else {
		g=generation(o);
		if(g!=OLD) {
			if(!alive_p(o)) {
#ifdef GC_LOG
				if(log_p()) {
					char buf[MAX_STR_LEN];
					log_f("mark %p %s\n",o,om_describe(buf,o));
				}
#endif
				set_alive(o,TRUE);
				xarray_add(&mark_stack,o);
			}
			if(g!=NEW2) rn_p=TRUE;
		}
	}
	return rn_p;
}

static int mark_body(object o)
{
	int size,i,rn_p;

	rn_p=FALSE;
	size=HEADER_SIZE(o);
	switch(size) {
	case SIZE_FBARRAY: 
	case SIZE_STRING:
	case SIZE_SYMBOL:
	case SIZE_LPINT:
	case SIZE_FLOAT:
		break;
	case SIZE_FARRAY:
		for(i=0;i<o->farray.size;i++) {
			if(gc_mark(o->farray.elt[i])) rn_p=TRUE;
		}
		break;
	default:
		if(gc_mark(o->gobject.xclass)) rn_p=TRUE;
		for(i=0;i<size;i++) {
			if(gc_mark(o->gobject.elt[i])) rn_p=TRUE;
		}
		break;
	}
	return rn_p;
}

static void mark_recur(void)
{
	object o;
	
	while(mark_stack.size!=0) {
		o=mark_stack.elt[--mark_stack.size];
		xassert(alive_p(o));
		if(full_gc_p) mark_body(o);
		else {
			xassert(generation(o)!=OLD);
			if(mark_body(o)&&generation(o)==NEW2) set_refnew(o,TRUE);
		}
	}
}

#ifdef GC_LOG
static void sweep_log(int start)
{
	int i;
	object o;
	
	char buf[MAX_STR_LEN];
	log_f("***sweep\n");
	for(i=start;i<om_table.size;i++) {
		o=om_table.elt[i];
		if(alive_p(o)) log_f("alive ");
		else log_f("free ");
		log_f("%d %s\n",generation(o),om_describe(buf,o));
	}
}
#endif

void gc(void)
{
	int last,g,i,rn_p;
	object o;
	
	full_gc_p=FALSE;

#ifdef GC_LOG
	log_f("**gc\n***mark_roots\n");
#endif
	ip_mark_object(full_gc_p);

#ifdef GC_LOG
	log_f("***mark_refnew\n");
#endif
	last=0;
	for(i=0;i<refnew_table.size;i++) {
		o=refnew_table.elt[i];
		xassert(generation(o)==OLD);
		xassert(refnew_p(o));
		rn_p=mark_body(o);
		if(rn_p) refnew_table.elt[last++]=o;
		set_refnew(o,rn_p);
	}
	refnew_table.size=last;

#ifdef GC_LOG
	log_f("***mark_recur\n");
#endif
	mark_recur();

#ifdef GC_LOG
	sweep_log(new_top);
#endif

	last=new_top;
	for(i=new_top;i<om_table.size;i++) {
		o=om_table.elt[i];
		if(alive_p(o)) {
			set_alive(o,FALSE);
			g=generation(o)+1;
			set_generation(o,g);
			if(g==OLD) {
				if(last==new_top) {
					om_table.elt[new_top++]=o;
					last++;
				} else {
					om_table.elt[last++]=om_table.elt[new_top];
					om_table.elt[new_top++]=o;
				}
				if(refnew_p(o)) add_refnew(o);
			} else om_table.elt[last++]=o;
		} else {
			om_free(o);
		}
	}
	om_table.size=last;
	last_new_space_size=last-new_top;
#ifdef GC_LOG
	log_f("last_new_space_size=%d\n",last_new_space_size);
#endif
}

void gc_full(void)
{
	int last,i;
	object o;

	full_gc_p=TRUE;
#ifdef GC_LOG
	log_f("**gc_full\n***mark_roots\n");
#endif
	
	gc_mark(om_Mulk);
	ip_mark_object(full_gc_p);

#ifdef GC_LOG
	log_f("***mark_recur\n");
#endif
	mark_recur();

#ifdef GC_LOG
	sweep_log(0);
#endif

	last=0;
	for(i=0;i<om_table.size;i++) {
		o=om_table.elt[i];
		if(alive_p(o)) {
			set_alive(o,FALSE);
			set_refnew(o,FALSE);
			set_generation(o,OLD);
			om_table.elt[last++]=o;
		} else {
			om_free(o);
		}
	}
	om_table.size=last;
	new_top=last;
	last_old_space_size=last;
	last_new_space_size=0;
	refnew_table.size=0;
#ifdef GC_LOG
	log_f("last_old_space_size=%d\n",last_old_space_size);
#endif
}

void gc_chance(void)
{
	int old_space_size,new_space_size;
	old_space_size=new_top;
	new_space_size=om_table.size-new_top;
#ifdef GC_LOG
	log_f("**gc_chance %d %d\n",old_space_size,new_space_size);
#endif
	if(old_space_size-last_old_space_size>GC_OLD_AMOUNT) gc_full();
	else if(new_space_size-last_new_space_size>GC_NEW_AMOUNT) gc();
}

void gc_init(void)
{
	int i;
	object o;

	new_top=om_table.size;
	last_old_space_size=om_table.size;
	last_new_space_size=0;
		
	xarray_init(&refnew_table);
	xarray_init(&mark_stack);

	for(i=0;i<om_table.size;i++) {
		o=om_table.elt[i];
		set_generation(o,OLD);
		set_alive(o,FALSE);
		set_refnew(o,FALSE);
	}
}

void gc_finish(void)
{
	xarray_free(&refnew_table);
	xarray_free(&mark_stack);
}

object gc_string(char *s)
{
	int len;
	object result;
	len=strlen(s);
	result=gc_object_new(om_String,len);
	memcpy(result->fbarray.elt,s,len);
	om_set_string_hash(result);
	return result;
}
