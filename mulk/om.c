/*
	object memory.
	$Id: mulk om.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <ctype.h>

#include "mem.h"
#include "heap.h"

#include "om.h"

#if !MACRO_OM_P_P
int om_p(object o)
{
	return (((intptr_t)o)&1)==0;
}
#endif

/* short integer access */

#if !MACRO_SINT_P_P
int sint_p(object o)
{
	return (((intptr_t)o)&1)==1;
}
#endif

#if !MACRO_SINT_VAL_P
int sint_val(object o)
{
	xassert(sint_p(o));
	return ((intptr_t)o)>>1;
}
#endif

int sint_range_p(int i)
{
	return SINT_MIN<=i&&i<=SINT_MAX;
}

#if !MACRO_SINT_P
object sint(int i)
{
	xassert(sint_range_p(i));
	return (object)(((uintptr_t)i<<1)|1);
}
#endif

/* header access */
/** hash */

int om_hash(object o)
{
	int result;
	if(om_p(o)) result=o->header;
	else result=sint_val(o);
	result&=HEADER_HASH_MASK;
	return result;
}

void om_set_hash(object o,int val)
{
	xassert(om_p(o));
	xassert(0<=val&&val<=HEADER_HASH_MASK);
	o->header=(o->header&~HEADER_HASH_MASK)|val;
}

static int hash_count;

void om_init_hash(object o)
{
	om_set_hash(o,hash_count++);
	if(hash_count>HEADER_HASH_MASK) hash_count=0;
}

int om_bytes_hash(char *p,int size,int case_insensitive_p)
{
	int i,hval,ch;;
	hval=0;
	for(i=0;i<size;i++) {
		ch=LC(p+i);
		if(case_insensitive_p) ch=tolower(ch);
		hval=hval*137+ch;
	}
	return hval&HEADER_HASH_MASK;
}

void om_set_string_hash(object o)
{
	xassert(om_size(o)==SIZE_STRING||om_size(o)==SIZE_SYMBOL);
	om_set_hash(o,om_bytes_hash(o->fbarray.elt,o->fbarray.size,FALSE));
}

int om_number_hash(double d)
{
	int i;
	if(SINT_MIN<=d&&d<=SINT_MAX) {
		i=(int)d;
		if(i==d) return i&HEADER_HASH_MASK;
	}
	return om_bytes_hash((char*)&d,sizeof(double),FALSE);
}

/** size */

#if !MACRO_OM_SIZE_P
int om_size(object o)
{
	if(sint_p(o)) return SIZE_SINT;
	return HEADER_SIZE(o);
}
#endif

void om_set_size(object o,int size)
{
	xassert(om_p(o));
	xassert(0<=size&&size<256);
	o->header=(o->header&~HEADER_SIZE_MASK)|(size<<HEADER_SIZE_POS);
}

/* allocation */

int om_used_memory;
int om_max_used_memory;

static struct heap heap;
#define LINK0_SIZE (5*sizeof(intptr_t))
static object link0;
#define LINK1_SIZE (LINK0_SIZE*2)
static object link1;

object om_alloc(int size)
{
	object result;
	if(size<=LINK0_SIZE) {
		size=LINK0_SIZE;
		if(link0==NULL) result=heap_alloc(&heap,size);
		else {
			result=link0;
			link0=result->next;
		}
	} else if(size<=LINK1_SIZE) {
		size=LINK1_SIZE;
		if(link1==NULL) result=heap_alloc(&heap,size);
		else {
			result=link1;
			link1=result->next;
		}
	} else result=xmalloc(size);

	om_used_memory+=size;
	if(om_used_memory>om_max_used_memory) om_max_used_memory=om_used_memory;
	return result;
}

static int om_byte_size(object o)
{
	int size,result;
	size=HEADER_SIZE(o);
	switch(size) {
	case SIZE_FBARRAY:
	case SIZE_STRING:
	case SIZE_SYMBOL:
		return sizeof(struct fbarray)+o->fbarray.size-1;
	case SIZE_FARRAY:
		return sizeof(struct farray)+(o->farray.size-1)*sizeof(object);
	case SIZE_LPINT:
		return sizeof(struct lpint);
	case SIZE_FLOAT:
		return sizeof(struct xfloat);
	default:
		result=sizeof(struct gobject)+(size-1)*sizeof(object);
		if(o->gobject.xclass==om_Method) {
			result+=METHOD_BYTECODE_SIZE(o);
		}
		return result;
	}
}

void om_free(object o)
{
	int size;
	size=om_byte_size(o);
	if(size<=LINK0_SIZE) {
		size=LINK0_SIZE;
		o->next=link0;
		link0=o;
	} else if(size<=LINK1_SIZE) {
		size=LINK1_SIZE;
		o->next=link1;
		link1=o;
	} else xfree(o);
	om_used_memory-=size;
}

/* table */

struct xarray om_table;
int om_max_object_count;

object om_nil;
object om_true;
object om_false;

object om_Class;
object om_ShortInteger;
object om_LongPositiveInteger;
object om_Float;
object om_FixedByteArray;
object om_String;
object om_Symbol;
object om_FixedArray;
object om_Method;
object om_Process;
object om_Context;
object om_Block;
object om_Char;

object om_Mulk;
object om_boot;
object om_doesNotUnderstand;
object om_primitiveFailed;
object om_error;
object om_trap_sp;
object om_equal;
object om_plus;
object om_lt;
object om_inc;
object om_at;
object om_value;
object om_at_put;
object om_byteAt;
object om_breaksp;

/**/

void om_init_array(object *table,int size)
{
	int i;
	for(i=0;i<size;i++) table[i]=om_nil;
}

object om_class(object o)
{
	object result;

	switch(om_size(o)) {
	case SIZE_SINT: result=om_ShortInteger; break;
	case SIZE_FBARRAY: result=om_FixedByteArray; break;
	case SIZE_STRING: result=om_String; break;
	case SIZE_SYMBOL: result=om_Symbol; break;
	case SIZE_FARRAY: result=om_FixedArray; break;
	case SIZE_LPINT: result=om_LongPositiveInteger; break;
	case SIZE_FLOAT: result=om_Float; break;
	default: result=o->gobject.xclass; break;
	}

	xassert(result!=NULL);
	return result;
}

object om_boolean(int b)
{
	if(b) return om_true;
	else return om_false;
}

void om_init(void)
{
	xarray_init(&om_table);
	hash_count=0;
	om_used_memory=0;
	om_max_used_memory=0;
	om_max_object_count=0;
	
	heap_init(&heap);
	link0=NULL;
	link1=NULL;
}

void om_finish(void)
{
	int i;
	for(i=0;i<om_table.size;i++) om_free(om_table.elt[i]);
	xarray_free(&om_table);
	heap_free(&heap);
}

