/*
	image reader.
	$Id: mulk ir.c 949 2022-10-06 Thu 21:53:44 kt $
*/

#include "std.h"

#include <string.h>

#include "mem.h"
#include "heap.h"
#include "pf.h"

#include "om.h"
#include "ir.h"

static char *mem;

static int read_byte(void)
{
	return LC(mem++);
}

static void read_segment(int size,void *ptr)
{
	memcpy(ptr,mem,size);
	mem+=size;
}

static int read_int(void)
{
	int off,result,b;
	off=0;
	result=0;
	while((b=read_byte())&0x80) {
		result|=(b&0x7f)<<off;
		off+=7;
	}
	result|=b<<off;
	return result;
}

static object read_fbarray(void)
{
	object result;
	int size;
	
	size=read_int();
	result=om_alloc(sizeof(struct fbarray)+size-1);
	result->fbarray.size=size;
	read_segment(size,result->fbarray.elt);
	return result;
}

static object read_lpint(void)
{
	object result;

	result=om_alloc(sizeof(struct lpint));
	/* note: dependent on uint64_t binary format. */
	read_segment(sizeof(result->lpint.val),&result->lpint.val);
	return result;
}

static object read_float(void)
{
	object result;
	
	result=om_alloc(sizeof(struct xfloat));
	/* note: dependent on double binary format. */
	read_segment(sizeof(double),&result->xfloat.val);
	return result;
}

static void reserve_table(int last)
{
	if(om_table.size<last+1) xarray_resize(&om_table,last+1);
}

static int last_id;

struct reloc {
	struct reloc *next;
	object *optr;
};

static struct reloc *reloc_free_list;
static struct heap reloc_heap;

static struct reloc *reloc_alloc(void)
{
	struct reloc *result;
	if(reloc_free_list==NULL) {
		result=heap_alloc(&reloc_heap,sizeof(struct reloc));
	} else {
		result=reloc_free_list;
		reloc_free_list=result->next;
	}
	return result;
}

static void reloc_free(struct reloc *r)
{
	r->next=reloc_free_list;
	reloc_free_list=r;
}

static void read_ref(object *p)
{
	int w;
	struct reloc *r;
	
	w=read_int();
	if(w&1) *p=sint(w>>1);
	else {
		w>>=1;
		if(w<last_id) *p=om_table.elt[w];
		else {
			reserve_table(w);
			r=reloc_alloc();
			r->optr=p;
			r->next=om_table.elt[w];
			om_table.elt[w]=r;
		}
	}
}

static object read_farray(void)
{
	object result;
	int i,size;

	size=read_int();
	result=om_alloc(sizeof(struct farray)+(size-1)*sizeof(object));
	result->farray.size=size;
	for(i=0;i<size;i++) read_ref(&result->farray.elt[i]);
	return result;
}

static object read_gobject(int size)
{
	object result;
	int i;
	
	result=om_alloc(sizeof(struct gobject)+(size-1)*sizeof(object));
	read_ref(&result->gobject.xclass);
	for(i=0;i<size;i++) read_ref(&result->gobject.elt[i]);
	return result;
}

static object read_method(int size,int bsize)
{
	object result;
	int i;
	
	result=om_alloc(sizeof(struct gobject)+(size-1)*sizeof(object)+bsize);
	result->gobject.xclass=om_table.elt[11]; /*om_Method*/
	for(i=0;i<size;i++) read_ref(&result->gobject.elt[i]);
	if(bsize!=0) read_segment(bsize,&result->gobject.elt[size]);
	return result;
}

void ir(char *mem_arg)
{
	int size,hash;
	object o;
	struct reloc *r,*r2;

	mem=mem_arg;
	
	reloc_free_list=NULL;
	heap_init(&reloc_heap);
	last_id=0;

	while((size=read_byte())!=SIZE_SINT) {
		hash=read_int();
		switch(size) {
		case SIZE_FBARRAY:
		case SIZE_STRING:
		case SIZE_SYMBOL:
			o=read_fbarray();
			break;
		case SIZE_FARRAY:
			o=read_farray();
			break;
		case SIZE_LPINT:
			o=read_lpint();
			break;
		case SIZE_FLOAT:
			o=read_float();
			break;
		case SIZE_METHOD_IR:
			size=read_byte();
			o=read_method(size,read_int());
			break;
		default:
			o=read_gobject(size);
			break;
		}
		om_set_size(o,size);
		om_set_hash(o,hash);

		reserve_table(last_id);
		r=om_table.elt[last_id];
		while(r!=NULL) {
			*(r->optr)=o;
			r2=r->next;
			reloc_free(r);
			r=r2;
		}
		om_table.elt[last_id++]=o;
	}

	om_nil=om_table.elt[0];
	om_true=om_table.elt[1];
	om_false=om_table.elt[2];
	om_Class=om_table.elt[3];
	om_ShortInteger=om_table.elt[4];
	om_LongPositiveInteger=om_table.elt[5];
	om_Float=om_table.elt[6];
	om_FixedByteArray=om_table.elt[7];
	om_String=om_table.elt[8];
	om_Symbol=om_table.elt[9];
	om_FixedArray=om_table.elt[10];
	om_Method=om_table.elt[11];
	om_Process=om_table.elt[12];
	om_Context=om_table.elt[13];
	om_Block=om_table.elt[14];
	om_Char=om_table.elt[15];
	om_Mulk=om_table.elt[16];
	om_boot=om_table.elt[17];
	om_doesNotUnderstand=om_table.elt[18];
	om_primitiveFailed=om_table.elt[19];
	om_error=om_table.elt[20];
	om_trap_cp_sp=om_table.elt[21];
	om_equal=om_table.elt[22];
	om_plus=om_table.elt[23];
	om_lt=om_table.elt[24];
	om_inc=om_table.elt[25];
	om_at=om_table.elt[26];
	om_value=om_table.elt[27];
	om_at_put=om_table.elt[28];
	om_byteAt=om_table.elt[29];
	
	heap_free(&reloc_heap);
	xassert(om_table.size==last_id);		
}

void ir_file(char *fn)
{
	struct pf_stat stat;
	FILE *fp;
	int sz;
	char *chunk;

	if((pf_stat(fn,&stat)&PF_READABLEFILE)!=PF_READABLEFILE) {
		xerror("image %s not found.",fn);
	}
	sz=(int)stat.size;
	chunk=xmalloc(sz);

#if PF_OPEN_P
	fp=pf_open(fn,"rb");
#else
	fp=fopen(fn,"rb");
#endif
	if(fp==NULL) xerror("open %s failed.",fn);
	if(sz!=(int)fread(chunk,1,sz,fp)) xerror("fread failed.");
	fclose(fp);

	ir(chunk);
	xfree(chunk);
}
