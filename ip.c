/*
	interpreter.
	$Id: mulk ip.c 1318 2024-12-01 Sun 14:28:50 kt $
*/

#include "std.h"
#include <string.h>
#include "mem.h"

#include "om.h"
#include "ip.h"
#include "gc.h"
#include "inst.h"
#include "prim.h"

#define STACK_GAP 300

static object cur_process;
static object cur_method;
static object cur_context; /* nil to frame on stack */
static object cur_stack;

static int ip;
static int sp;
static int sp_used; /* after last gc */
static int sp_max;
static int fp;
#if U64_P
static uint32_t cycle;
#else
static uint64_t cycle;
#endif

/* error */

int ip_trap_code;
static char *error_message;

static void error_mark(char *msg)
{
	/* note: execution continues, you'd better to return ip_main immediately */
	ip_trap_code=TRAP_ERROR;
	error_message=msg;
}

/* process */

static object process_new(int stack_size)
{
	object process;
	
	process=gc_object_new(om_Process,0);

	process->process.stack=gc_object_new(om_FixedArray,stack_size);
	process->process.sp=sint(0);

	return process;
}

static void process_sync(void)
{
	cur_process->process.context=cur_context;
	gc_refer(cur_process,cur_context);
	cur_process->process.method=cur_method;
	gc_refer(cur_process,cur_method);
	cur_process->process.ip=sint(ip);
	gc_regist_refnew(cur_stack);
	cur_process->process.sp=sint(sp);
	cur_process->process.sp_used=sint(sp_used);
	cur_process->process.sp_max=sint(sp_max);
	cur_process->process.fp=sint(fp);
	
}

#ifdef IP_PROFILE
#include <stdlib.h>

#include "heap.h"
#include "splay.h"
#include "xbarray.h"
#include "csplit.h"

struct profile {
	char *name;
	int64_t cycle_count;
	int64_t call_count;
};

static struct heap profile_heap;
static struct splay profile_splay;
static struct profile *cur_profile;
static struct xbarray str;
static char *profile_fn;

static void profile_init(void)
{
	if((profile_fn=getenv("MULKPROFILE"))==NULL) return;
	
	heap_init(&profile_heap);
	splay_init(&profile_splay,(int(*)(void*,void*))strcmp);
}

static void str_add_symbol(object o)
{
#ifndef NDEBUG
	int size;
	size=om_size(o);
	xassert(size==SIZE_SYMBOL);
#endif
	memcpy(xbarray_reserve(&str,o->fbarray.size),o->fbarray.elt,
		o->fbarray.size);
}

static struct profile *profile_get_name(char *name)
{
	struct profile *result;
	if((result=splay_find(&profile_splay,name))==NULL) {
		result=heap_alloc(&profile_heap,sizeof(struct profile));
		result->name=heap_strdup(&profile_heap,name);
		result->cycle_count=0;
		result->call_count=0;
		splay_add(&profile_splay,result->name,result);
	}
	return result;
}

static struct profile *profile_get(object method)
{
	xbarray_reset(&str);
	str_add_symbol(method->method.belong_class->xclass.name);
	xbarray_adds(&str," >> ");
	str_add_symbol(method->method.selector);
	xbarray_add(&str,'\0');

	return profile_get_name(str.elt);
}

static FILE *profile_fp;

static void profile_dump_func(int depth,void *key,void *data)
{
	struct profile *p;
	p=data;
	fprintf(profile_fp,"%"PRId64",%"PRId64",%s\n",
		p->cycle_count,p->call_count,p->name);
}

static void profile_finish(void)
{
	char *p,*cols[3];
	struct profile *pf;
	
	if(profile_fn==NULL) return;

	if((profile_fp=fopen(profile_fn,"r"))!=NULL) {
		while((p=xbarray_fgets(&str,profile_fp))!=NULL) {
			csplit(p,cols,3);
			pf=profile_get_name(cols[2]);
			pf->cycle_count+=atoll(cols[0]);
			pf->call_count+=atoll(cols[1]);
		}
		fclose(profile_fp);
	}
	
	if((profile_fp=fopen(profile_fn,"w"))==NULL) {
		xerror("open %s failed.",profile_fn);
	}
	splay_foreach(&profile_splay,profile_dump_func);
	fclose(profile_fp);
}
#endif

/* switch method */

static void switch_method(object m)
{
	cur_method=m;
#ifdef IP_PROFILE
	if(profile_fn!=NULL) cur_profile=profile_get(m);
#endif
}

/* stack */

#define STACK(pos) (cur_stack->farray.elt[pos])

static void push(object o)
{
	if(sp==cur_stack->farray.size-STACK_GAP) error_mark("stack overflow.");
	else if(sp>=cur_stack->farray.size) xerror("out of spare space in stack");
	
	STACK(sp++)=o;
	if(sp>sp_used) {
		sp_used=sp;
		if(sp_used>sp_max) sp_max=sp_used;
	}
	/* fs is always refnew -- see ip_mark_object */
}

/* execution context */

static void save(void)
{
	if(ip==-1) return;

/*
	{
		char cn[MAX_STR_LEN],mn[MAX_STR_LEN];
		om_describe(cn,cur_method->method.belong_class->xclass.name);
		om_describe(mn,cur_method->method.selector);
		printf("save %s %s\n",cn,mn);
	}
*/
	if(cur_context!=om_nil) push(cur_context);
	else push(cur_method);
	push(sint(fp));
	push(sint(ip));
}

static void restore(void)
{
	if(sp<=1) {
		ip=-1;
		return;
	}
	ip=sint_val(STACK(--sp));
	fp=sint_val(STACK(--sp));
	cur_context=STACK(--sp);
/*
	{
		char cn[MAX_STR_LEN],mn[MAX_STR_LEN];
		om_describe(cn,cur_method->method.belong_class->xclass.name);
		om_describe(mn,cur_method->method.selector);
		printf("restore %s %s\n",cn,mn);
	}
*/
	if(cur_context->gobject.xclass==om_Context) {
		switch_method(cur_context->context.method);
	} else {
		switch_method(cur_context);
		cur_context=om_nil;
	}
}

/* search method */

static object find_method_class(object cl,object sel)
{
	object methods,m;
	int i;
	
	methods=cl->xclass.methods;
	if(methods==om_nil) return NULL;
	xassert(om_class(methods)==om_FixedArray);
	for(i=0;i<methods->farray.size;i++) {
		m=methods->farray.elt[i];
		if(m==om_nil) return NULL;
		xassert(om_class(m)==om_Method);
		if(m->method.selector==sel) return m;
	}
	return NULL;
}

static object find_method_feature(object cl,object sel)
{
	object fs,f,m;
	int i;
	
	fs=cl->xclass.features;
	if(fs==om_nil) return NULL;
	xassert(om_size(fs)==SIZE_FARRAY);
	for(i=0;i<fs->farray.size;i++) {
		f=fs->farray.elt[i];
		xassert(om_class(f)==om_Class);
		if((m=find_method_class(f,sel))!=NULL) return m;
		if((m=find_method_feature(f,sel))!=NULL) return m;
	}
	return NULL;
}

static object find_method_main(object cl,object sel)
{
	object m;

	while(cl!=om_nil) {
		xassert(om_class(cl)==om_Class);
		if((m=find_method_class(cl,sel))!=NULL) return m;
		if((m=find_method_feature(cl,sel))!=NULL) return m;
		cl=cl->xclass.superclass;
	}
	return NULL;
}

static struct cache {
	object class,selector,method;
} *cache;

#define CACHE_N 3
static int cache_size;
static int cache_entry;
#if U64_P
static uint32_t cache_call;
static uint32_t cache_hit;
#else
static uint64_t cache_call;
static uint64_t cache_hit;
#endif
static int cache_invalidate;

static void cache_alloc(void)
{
	cache=xmalloc(sizeof(struct cache)*cache_size);
	memset(cache,0,sizeof(struct cache)*cache_size);
	cache_entry=0;
}

static void cache_init(void)
{
	cache_size=1024;
	cache_alloc();
	cache_call=0;
	cache_hit=0;
	cache_invalidate=0;
}

static void cache_reset(object sel)
{
	int i;
	struct cache *c;
	for(i=0;i<cache_size;i++) {
		c=&cache[i];
		if(c->class!=NULL&&(sel==om_nil||c->selector==sel)) {
			cache_entry--;
			c->class=NULL;
		}
	}
}

/* o must be object */
#define HASH(o) (o->header&HEADER_HASH_MASK)

static object find_method(object cl,object sel)
{
	int hval0,hval,i;
	struct cache *c;
	object m;
	
	cache_call++;
	hval=hval0=(HASH(cl)^(HASH(sel)<<1))%cache_size;

	for(i=0;i<CACHE_N;i++) {
		c=&cache[hval];
		if(c->class==NULL) break;
		if(c->class==cl&&c->selector==sel) {
			cache_hit++;
			return c->method;
		}
		hval=(hval+1)%cache_size;
	}

	if(i==CACHE_N) {
		cache_invalidate++;
		for(i=0;i<CACHE_N;i++) {
			cache[(hval0+i)%cache_size].class=NULL;
			cache_entry--;
		}
		hval=hval0;
	}

	c=&cache[hval];
	m=find_method_main(cl,sel);
	c->class=cl;
	c->selector=sel;
	c->method=m;
	cache_entry++;

	if(cache_entry>(cache_size*8/10)) {
		cache_size*=2;
		xfree(cache);
		cache_alloc();
	}
		
	return m;
}

/* instructions */

static int fetch(void)
{
	return LC(cur_method->method.u.bytecode+ip++);
}

static object temp_var(int no)
{
	return STACK(fp+no);
}

static object cur_self(void)
{
	if(cur_context==om_nil) return temp_var(0);
	else return cur_context->context.vars[0];
}

static void i_push_instance_var(int no)
{
	object self;
	self=cur_self();
#ifndef NDEBUG
	{
		int size;
		size=HEADER_SIZE(self);
		xassert(size<SIZE_LAST);
		xassert(0<=no&&no<size);
	}
#endif
	push(self->gobject.elt[no]);
}

static void i_push_context_var(int no)
{
	xassert(cur_context!=om_nil);
	xassert(0<=no&&no<om_size(cur_context)-SIZE_CONTEXT);
	push(cur_context->context.vars[no]);
}

static void i_push_temp_var(int no)
{
	push(temp_var(no));
}

static object literal(int no)
{
	return cur_method->method.u.literal[no];
}

static void i_push_literal(int no)
{
	push(literal(no));
}

static void i_set_instance_var(int no)
{
	object self,o;

	self=cur_self();
#ifndef NDEBUG
	{
		int size;
		size=HEADER_SIZE(self);
		xassert(size<SIZE_LAST);
		xassert(0<=no&&no<size);
	}
#endif
	o=STACK(--sp);
	self->gobject.elt[no]=o;
	gc_refer(self,o);
}

static void i_set_context_var(int no)
{
	object val;
	
	xassert(cur_context!=om_nil);
	xassert(0<=no&&no<om_size(cur_context)-SIZE_CONTEXT);
	val=STACK(--sp);
	cur_context->context.vars[no]=val;
	gc_refer(cur_context,val);
}

static void i_set_temp_var(int no)
{
	STACK(fp+no)=STACK(--sp);
}

static void i_exit(void)
{
	object retval;
	retval=STACK(--sp);
	sp=fp;
	restore();
	push(retval);
}

static void i_return(void)
{
	object retval;
	int retsp;

	if(cur_context==om_nil) {
		i_exit();
		return;
	}
	
	retval=STACK(--sp);
	retsp=sint_val(cur_context->context.sp);
	
	if(retsp>sp||STACK(retsp-1)!=cur_context) {
		error_mark("i_return/illegal context.");
		return;
	}
	sp=retsp;
	--sp; /* context mark */
	restore();
	push(retval);
}

static int perform(object self,object sel,int narg,object *args,
	object *result);

static void send_error(object rec,object err,object sel,int narg,object *args)
{
	object fa;
	int i;
		
	fa=gc_object_new(om_FixedArray,narg+1);
	fa->farray.elt[0]=sel;
	for(i=0;i<narg;i++) fa->farray.elt[i+1]=args[i];
	perform(rec,err,1,&fa,NULL);
}

extern int (*prim_table[])(object self,object *args,object *result);
static int prim_last_error;

static object perform_method(object rec,object m,int narg,object *args)
{
	object result;
	int prim,ets,i,cs,st;
	
#ifdef IP_PROFILE
	if(profile_fn!=NULL) profile_get(m)->call_count++;
#endif
	prim=(sint_val(m->method.attr)&METHOD_PRIM_MASK)>>METHOD_PRIM_POS;
	if(prim!=METHOD_MAX_PRIM) {
		result=rec;
#ifdef IP_PROFILE
		/* every primitive counts as one cycle */
		if(profile_fn!=NULL) profile_get(m)->cycle_count++;
#endif
		if((st=(*prim_table[prim])(rec,args,&result))==PRIM_SUCCESS) {
			return result;
		}
		prim_last_error=st;
		if(METHOD_BYTECODE_SIZE(m)==0) {
			send_error(rec,om_primitiveFailed,m->method.selector,narg,args);
			return NULL;
		}
	}

	save();
	switch_method(m);
	cs=METHOD_CONTEXT_SIZE(m);
	if(cs==0) {
		fp=sp;
		push(rec);
		for(i=0;i<narg;i++) push(args[i]);
		ets=METHOD_EXT_TEMP_SIZE(m);
		for(i=0;i<ets;i++) push(om_nil);
		cur_context=om_nil;
	} else {
		cur_context=gc_object_new(om_Context,cs);
		push(cur_context); /* marker */
		cur_context->context.method=m;
		cur_context->context.sp=sint(sp);
		cur_context->context.vars[0]=rec;
		for(i=0;i<narg;i++) cur_context->context.vars[i+1]=args[i];
		fp=sp;
	}
	ip=METHOD_BYTECODE_START(m);
	return NULL;
}

static int perform(object rec,object sel,int narg,object *args,object *resultp)
{
	object m,result;

	m=find_method(om_class(rec),sel);
	if(m==NULL||narg!=METHOD_ARGC(m)) return FALSE;	
	result=perform_method(rec,m,narg,args);
	if(resultp==NULL) {
		xassert(result==NULL);
	} else *resultp=result;
	return TRUE;
}

static void xsend(int super_p,object sel,int narg)
{
	object rec,cl,m,result,args[METHOD_MAX_ARG];
	int i;

	for(i=0;i<narg;i++) args[narg-1-i]=STACK(--sp);
	rec=STACK(--sp);
	if(super_p) {
		cl=cur_method->method.belong_class->xclass.superclass;
		if(cl==om_nil) {
			send_error(rec,om_doesNotUnderstand,sel,narg,args);
			return;
		}
	} else cl=om_class(rec);

	m=find_method(cl,sel);
	if(m==NULL) {
		send_error(rec,om_doesNotUnderstand,sel,narg,args);
		return;
	}
	result=perform_method(rec,m,narg,args);
	if(result!=NULL) {
		push(result);
	}
}

static void i_send(int super_p,int narg,int selpos)
{
	xsend(super_p,literal(selpos),narg);
}

static void i_block(int narg,int size)
{
	object block;

	xassert(cur_context!=om_nil);
	
	block=gc_object_new(om_Block,0);
	block->block.context=cur_context;
	block->block.narg=sint(narg);
	block->block.start=sint(ip);
	push(block);
	ip+=size;
}

static void i_branch(int off)
{
	ip+=off;
}

static void i_branch_cond(int cond,int off)
{
	object o;
	o=STACK(sp-1);
	if(!(o==om_true||o==om_false)) {
		error_mark("i_branch_cond/reciever is not Boolean.");
	}
	if(o==om_boolean(cond)) i_branch(off);
	else --sp;
}

static void i_send_equal(void)
{
	object self,arg;
	int selfsz;
	self=STACK(sp-2);
	arg=STACK(sp-1);
	selfsz=om_size(self);
	if((selfsz==SIZE_SINT&&sint_p(arg))
		||selfsz==SIZE_SYMBOL
		||self==om_true||self==om_false
		||(selfsz<SIZE_LAST&&self->gobject.xclass==om_Char)) {
		sp-=2;
		push(om_boolean(self==arg));
		return;
	}

	xsend(FALSE,om_equal,1);
}

static void i_send_plus(void)
{
	object self,arg;
	int ans;
	self=STACK(sp-2);
	arg=STACK(sp-1);
	if(sint_p(self)&&sint_p(arg)) {
		ans=sint_val(self)+sint_val(arg);
		if(sint_range_p(ans)) {
			sp-=2;
			push(sint(ans));
			return;
		}
	}
	xsend(FALSE,om_plus,1);
}

static void i_send_lt(void)
{
	object self,arg;
	self=STACK(sp-2);
	arg=STACK(sp-1);
	if(sint_p(self)&&sint_p(arg)) {
		sp-=2;
		push(om_boolean(sint_val(self)<sint_val(arg)));
		return;
	}
	xsend(FALSE,om_lt,1);
}

static void i_start_times_do(void)
{
	if(!sint_p(STACK(sp-1))) {
		error_mark("i_start_times_do/reciever is not ShortInteger");
		return;
	}
	push(sint(0));
}

static void i_times_do(int vn,int off)
{
	int end,cur;
	end=sint_val(STACK(sp-2));
	cur=sint_val(STACK(sp-1));
	if(cur<end) {
		if(vn!=0) {
			if(cur_context==om_nil) STACK(fp+vn)=sint(cur);
			else cur_context->context.vars[vn]=sint(cur);
		}
		STACK(sp-1)=sint(cur+1);
	} else {
		--sp;
		i_branch(off);
	}		
}

static void i_break(void)
{
	object args[1];
	save();
	args[0]=sint(sp);
	ip=-1;
	perform(cur_process,om_breaksp,1,args,NULL);	
}

static void i_send_inc(void)
{
	object self;
	int ans;
	
	self=STACK(sp-1);
	if(sint_p(self)) {
		ans=sint_val(self)+1;
		if(ans<=SINT_MAX) {
			STACK(sp-1)=sint(ans);
			return;
		}
	}
	xsend(FALSE,om_inc,0);
}

extern int prim_object_basicAt(object self,object *args,object *result);

static void i_send_at(void)
{
	object self,result;
	int selfsz;
	
	self=STACK(sp-2);
	selfsz=om_size(self);
	if(selfsz==SIZE_FBARRAY||selfsz==SIZE_FARRAY) {
		if(prim_object_basicAt(self,&STACK(sp-1),&result)==PRIM_SUCCESS) {
			sp-=2;
			push(result);
			return;
		}
	}
	xsend(FALSE,om_at,1);
}

extern int prim_block_value1(object self,object *args,object *result);

static void i_send_value1(void)
{
	object self,result,value;
	
	self=STACK(sp-2);
	if(om_class(self)==om_Block) {
		value=STACK(sp-1);
		sp-=2;
		if(prim_block_value1(self,&value,&result)==PRIM_SUCCESS) {
			return;
		}
		sp+=2;
	}
	xsend(FALSE,om_value,1);
}

extern int prim_object_basicAt_put(object self,object *args,object *result);

static void i_send_at_put(void)
{
	object self,result;
	int selfsz;
	
	self=STACK(sp-3);
	selfsz=om_size(self);
	result=self;
	if(selfsz==SIZE_FBARRAY||selfsz==SIZE_FARRAY) {
		if(prim_object_basicAt_put(self,&STACK(sp-2),&result)==PRIM_SUCCESS) {
			sp-=3;
			push(result);
			return;
		}
	}
	xsend(FALSE,om_at_put,2);
}

static void i_send_byteAt(void)
{
	object self,result;
	int selfsz;
	
	self=STACK(sp-2);
	selfsz=om_size(self);
	if(selfsz==SIZE_FBARRAY||selfsz==SIZE_STRING||selfsz==SIZE_SYMBOL
			||selfsz==SIZE_FARRAY) {
		if(prim_object_basicAt(self,&STACK(sp-1),&result)==PRIM_SUCCESS) {
			sp-=2;
			push(result);
			return;
		}
	}
	xsend(FALSE,om_byteAt,1);
}

static void trap(void)
{
	object args[2];
	if(ip_trap_code==TRAP_ERROR) {
		args[0]=gc_string(error_message);
		perform(cur_process,om_error,1,args,NULL);
	} else {
		save();
		args[0]=sint(ip_trap_code);
		args[1]=sint(sp);
		ip=-1;
		perform(cur_process,om_trap_sp,2,args,NULL);
	}
	ip_trap_code=TRAP_NONE;
}

static void ip_main(void)
{
	int op,lo,opr;
	object common_literal[7];

	common_literal[0]=sint(0);
	common_literal[1]=sint(1);
	common_literal[2]=sint(2);
	common_literal[3]=sint(-1);
	common_literal[4]=om_nil;
	common_literal[5]=om_true;
	common_literal[6]=om_false;
			
	while(ip!=-1) {
#ifdef IP_PROFILE
		if(profile_fn!=NULL) cur_profile->cycle_count++;
#endif
		cycle++;
		if(cycle%IP_POLLING_INTERVAL==0) {
			gc_chance();
#if INTR_CHECK_P
			ip_intr_check();
#endif
		}
		if(ip_trap_code!=TRAP_NONE) trap();

		op=fetch();
		lo=op&0xf;
		switch(op>>4) {
		case BASIC_INST:
			switch(lo) {
			case PUSH_INSTANCE_VAR_INST: i_push_instance_var(fetch()); break;
			case PUSH_CONTEXT_VAR_INST: i_push_context_var(fetch()); break;
			case PUSH_TEMP_VAR_INST: i_push_temp_var(fetch()); break;
			case PUSH_LITERAL_INST: i_push_literal(fetch()); break;
			case SET_INSTANCE_VAR_INST: i_set_instance_var(fetch()); break;
			case SET_CONTEXT_VAR_INST: i_set_context_var(fetch()); break;
			case SET_TEMP_VAR_INST: i_set_temp_var(fetch()); break;
			case DROP_INST: --sp; break;
			case EXIT_INST: i_exit(); break;
			case RETURN_INST: i_return(); break;
			case BRANCH_BACKWARD_INST: i_branch(-fetch()); break;
			case DUP_INST: push(STACK(sp-1)); break;
			default: xassert(FALSE);
			}
			break;
		case SEND_INST: i_send(FALSE,lo,fetch()); break;
		case SEND_SUPER_INST: i_send(TRUE,lo,fetch()); break;
		case BLOCK_INST: i_block(lo,fetch()); break;
		case EXT_INST:
			switch(lo) {
			case BRANCH_FORWARD_INST: i_branch(fetch()); break;
			case BRANCH_TRUE_FORWARD_INST: i_branch_cond(TRUE,fetch()); break;
			case BRANCH_FALSE_FORWARD_INST: i_branch_cond(FALSE,fetch()); break;
			case START_TIMES_DO_INST: i_start_times_do(); break;
			case TIMES_DO_INST:
				opr=fetch();
				i_times_do(opr,fetch());
				break;
			case BREAK_INST:
				i_break();
				break;
			default: xassert(FALSE);
			}
			break;
		case PUSH_INSTANCE_VAR_SHORT_INST: i_push_instance_var(lo); break;
		case PUSH_CONTEXT_VAR_SHORT_INST: i_push_context_var(lo); break;		
		case PUSH_TEMP_VAR_SHORT_INST: i_push_temp_var(lo); break;
		case PUSH_LITERAL_SHORT_INST: i_push_literal(lo); break;
		case SET_INSTANCE_VAR_SHORT_INST: i_set_instance_var(lo); break;
		case SET_CONTEXT_VAR_SHORT_INST: i_set_context_var(lo); break;
		case SET_TEMP_VAR_SHORT_INST: i_set_temp_var(lo); break;
		case SEND_0_SHORT_INST: i_send(FALSE,0,lo); break;
		case SEND_1_SHORT_INST: i_send(FALSE,1,lo); break;
		case SEND_COMMON_INST:
			switch(lo) {
			case 0: i_send_equal(); break;
			case 1: i_send_plus(); break;
			case 2: i_send_lt(); break;
			case 3: STACK(sp-1)=om_boolean(STACK(sp-1)==om_nil); break;
			case 4: STACK(sp-1)=om_boolean(STACK(sp-1)!=om_nil); break;
			case 5: i_send_inc(); break;
			case 6: i_send_at(); break;
			case 7: i_send_value1(); break;
			case 8: i_send_at_put(); break;
			case 9: i_send_byteAt(); break;
			default: xassert(FALSE);
			}
			break;
		case PUSH_COMMON_LITERAL_INST: push(common_literal[lo]); break;
		default: xassert(FALSE);
		}
	}
}

static void switch_process(object process)
{
	cur_process=process;
	cur_stack=process->process.stack;
}

/* interrupt */

#if UNIX_P
#include <signal.h>

static void intr_handler(int signo)
{
	ip_trap_code=TRAP_INTERRUPT;
}
#endif

#if WINDOWS_P
#include <windows.h>

static BOOL intr_handler(DWORD dwCtrlType)
{
	if(dwCtrlType==CTRL_C_EVENT) {
		ip_trap_code=TRAP_INTERRUPT;
		return TRUE;
	}
	return FALSE;
}
#endif

static void intr_init(void)
{
#if UNIX_P
	struct sigaction sa;
	memset(&sa,0,sizeof(sa));
	sa.sa_handler=intr_handler;
	if(sigaction(SIGINT,&sa,NULL)==-1) xerror("sigaction failed.");
#endif

#if WINDOWS_P
	if(SetConsoleCtrlHandler((PHANDLER_ROUTINE)intr_handler,TRUE)==0) {
		xerror("SetConsoleCtrlHandler failed.");
	}
#endif
}

void ip_start(object arg,int fs_size)
{
	cache_init();
	
#ifdef IP_PROFILE
	profile_init();
#endif

	switch_process(process_new(fs_size));

	ip=-1; /* not in execution */
	sp=0;
	sp_used=0;
	sp_max=0;
	fp=0;
	ip_trap_code=TRAP_NONE;
	cycle=0;

	perform(om_Mulk,om_boot,1,&arg,NULL);

	intr_init();
	
	ip_main();

#ifdef IP_PROFILE
	profile_finish();
#endif
	xfree(cache);
}

/**/

void ip_mark_object(int full_gc_p)
{
	int i;
	
	if(sp_used>sp) {
		for(i=sp;i<sp_used;i++) cur_stack->farray.elt[i]=om_nil;
		sp_used=sp;
	}

	if(!full_gc_p) gc_regist_refnew(cur_stack);
	
	gc_mark(cur_process);
	gc_mark(cur_context);
	gc_mark(cur_method);
}

/* core primitives */

/** Object */

DEFPRIM(object_class)
{
	*result=om_class(self);
	return PRIM_SUCCESS;
}

DEFPRIM(object_equal)
{
	*result=om_boolean(self==args[0]);
	return PRIM_SUCCESS;
}

static int basic_size(object o)
{
	int size;
	size=om_size(o);
	switch(size) {
	case SIZE_SINT:
		size=sizeof(int);
		break;
	case SIZE_FBARRAY:
	case SIZE_STRING:
	case SIZE_SYMBOL:
		size=o->fbarray.size;
		break;
	case SIZE_FARRAY:
		size=o->farray.size;
		break;
	case SIZE_LPINT:
		size=sizeof(o->lpint.val);
		break;
	case SIZE_FLOAT:
		size=sizeof(double);
		break;
	default:
		break;
	}
	return size;
}

DEFPRIM(object_basicSize)
{
	*result=sint(basic_size(self));
	return PRIM_SUCCESS;
}

DEFPRIM(object_basicAt)
{
	int pos,value;

	GET_SINT_ARG(0,pos);
	if(!(0<=pos&&pos<basic_size(self))) return PRIM_ERROR;
	switch(om_size(self)) {
	case SIZE_SINT:
		value=sint_val(self);
		*result=sint(LC(((char*)&value)+pos));
		break;
	case SIZE_FBARRAY:
	case SIZE_STRING:
	case SIZE_SYMBOL:
		*result=sint(LC(self->fbarray.elt+pos));
		break;
	case SIZE_FARRAY:
		*result=self->farray.elt[pos];
		break;
	case SIZE_LPINT:
		*result=sint(LC(((char*)&self->lpint.val)+pos));
		break;
	case SIZE_FLOAT:
		*result=sint(LC(((char*)&self->xfloat.val)+pos));
		break;
	default:
		*result=self->gobject.elt[pos];
		break;
	}
	return PRIM_SUCCESS;
}

DEFPRIM(object_basicAt_put)
{
	int pos,ival,sizecode;
	
	GET_SINT_ARG(0,pos);
	if(!(0<=pos&&pos<basic_size(self))) return PRIM_ERROR;
	sizecode=om_size(self);
	ival=0;
	if(sizecode==SIZE_FBARRAY||sizecode==SIZE_STRING||sizecode==SIZE_SYMBOL
		||sizecode==SIZE_LPINT||sizecode==SIZE_FLOAT) {
		GET_SINT_ARG(1,ival);
		if(!p_byte_p(ival)) return PRIM_ERROR;
	}
			
	switch(sizecode) {
	case SIZE_SINT:
		return PRIM_ERROR;
	case SIZE_FBARRAY:
	case SIZE_STRING:
	case SIZE_SYMBOL:
		SC(self->fbarray.elt+pos,ival);
		break;
	case SIZE_FARRAY:
		self->farray.elt[pos]=args[1];
		gc_refer(self,args[1]);
		break;
	case SIZE_LPINT:
		SC(((char*)&self->lpint.val)+pos,ival);
		break;
	case SIZE_FLOAT:
		SC(((char*)&self->xfloat.val)+pos,ival);
		break;
	default:
		self->gobject.elt[pos]=args[1];
		gc_refer(self,args[1]);
		break;
	}
	return PRIM_SUCCESS;
}

DEFPRIM(object_hash)
{
	*result=sint(om_hash(self));
	return PRIM_SUCCESS;
}

DEFPRIM(object_sethash)
{
	int h;
	GET_SINT_ARG(0,h);
	if(!om_p(self)) return PRIM_ERROR;
	if(!(0<=h&&h<=HEADER_HASH_MASK)) return PRIM_ERROR;
	om_set_hash(self,h);
	return PRIM_SUCCESS;
}

DEFPRIM(object_perform_args)
{
	object *argv;
	int narg;

	if(om_class(args[0])!=om_Symbol) return PRIM_ERROR;
	if(!p_farray_to_array(args[1],&narg,&argv)) return PRIM_ERROR;
	if(!perform(self,args[0],narg,argv,result)) return PRIM_ERROR;
	return PRIM_SUCCESS;
}

DEFPRIM(object_performMethod_args)
{
	object *argv,m;
	int narg;

	m=args[0];
	if(!p_farray_to_array(args[1],&narg,&argv)) return PRIM_ERROR;
	if(narg!=METHOD_ARGC(m)) return PRIM_ERROR;
	*result=perform_method(self,m,narg,argv);
	return PRIM_SUCCESS;
}

DEFPRIM(object_primLastError)
{
	*result=sint(prim_last_error);
	return PRIM_SUCCESS;
}

/** Class */

DEFPRIM(class_basicNew)
{
	int ext,size;
	GET_SINT_ARG(0,ext);

	size=sint_val(self->xclass.size);
	switch(size) {
	case SIZE_SINT:
		return PRIM_ERROR;
	case SIZE_FBARRAY:
	case SIZE_STRING:
	case SIZE_SYMBOL:
	case SIZE_FARRAY:
		if(ext<0) return PRIM_ERROR;
		break;
	case SIZE_LPINT:
	case SIZE_FLOAT:
		if(ext!=0) return PRIM_ERROR;
		break;
	default:
		if(ext<0||size+(ext&0xff)>=SIZE_LAST) return PRIM_ERROR;
		if(self!=om_Method&&(ext>>8)!=0) return PRIM_ERROR;
		break;
	}
	*result=gc_object_new(self,ext);
	
	return PRIM_SUCCESS;
}

/** Method */

DEFPRIM(method_bytecodeAt)
{
	int pos;
	GET_SINT_ARG(0,pos);
	if(!(0<=pos&&pos<METHOD_BYTECODE_SIZE(self))) return PRIM_ERROR;
	*result=sint(LC(self->method.u.bytecode+METHOD_BYTECODE_START(self)+pos));
	return PRIM_SUCCESS;
}

DEFPRIM(method_bytecodeAt_put)
{
	int pos,val;
	GET_SINT_ARG(0,pos);
	if(!(0<=pos&&pos<METHOD_BYTECODE_SIZE(self))) return PRIM_ERROR;
	GET_SINT_ARG(1,val);
	if(!p_byte_p(val)) return PRIM_ERROR;
	SC(self->method.u.bytecode+METHOD_BYTECODE_START(self)+pos,val);
	return PRIM_SUCCESS;
}

/** Block */

static int eval_block(object b,int narg,object *args)
{
	object cx;
	int i;
	
	if(sint_val(b->block.narg)!=narg) return PRIM_ERROR;
	cx=b->block.context;

	save();
	fp=sp;
	for(i=0;i<narg;i++) push(args[i]);
	switch_method(cx->context.method);
	cur_context=cx; 
	ip=sint_val(b->block.start);
	return PRIM_SUCCESS;
}

DEFPRIM(block_valueArgs)
{
	int narg;
	object *argv;
	*result=NULL;
	if(!p_farray_to_array(args[0],&narg,&argv)) return PRIM_ERROR;
	return eval_block(self,narg,argv);
}
	
DEFPRIM(block_value)
{
	*result=NULL;
	return eval_block(self,0,NULL);
}

DEFPRIM(block_value1)
{
	*result=NULL;
	return eval_block(self,1,args);
}

DEFPRIM(block_value2)
{
	*result=NULL;
	return eval_block(self,2,args);
}

/** Process */

DEFPRIM(process_resumesp)
{
	GET_SINT_ARG(0,sp);
	restore();
	*result=NULL;
	return PRIM_SUCCESS;
}

/*** subprocess switching */

DEFPRIM(process_basicStart)
{
	object parent;
	
	/* self must be process or it's subprocess */
	if(om_class(args[0])!=om_Symbol) return PRIM_ERROR;
	
	process_sync();
	parent=cur_process;
	switch_process(self);
	ip=-1;
	sp=0;
	sp_used=0;
	sp_max=0;
	fp=0;
	perform(self,args[0],1,&parent,NULL);
	*result=NULL;
	return PRIM_SUCCESS;
}

DEFPRIM(process_basicSwitch)
{
	process_sync();
	switch_process(self);
	cur_context=cur_process->process.context;
	cur_method=cur_process->process.method;
	ip=sint_val(cur_process->process.ip);
	sp=sint_val(cur_process->process.sp);
	sp_used=sint_val(cur_process->process.sp_used);
	sp_max=sint_val(cur_process->process.sp_max);
	fp=sint_val(cur_process->process.fp);
	return PRIM_SUCCESS;
}

/** Kernel */
DEFPRIM(kernel_currentProcess)
{
	process_sync();
	*result=cur_process;
	return PRIM_SUCCESS;
}

DEFPRIM(kernel_cacheReset)
{
	cache_reset(args[0]);
	return PRIM_SUCCESS;
}

DEFPROPERTY(kernel)
{
	switch(key) {
	case 0:
#if U64_P
		*result=p_uint32(cycle);
#else
		*result=p_uint64(cycle);
#endif
		break;
	case 1: *result=sint(om_used_memory); break;
	case 2: *result=sint(om_max_used_memory); break;
	case 3: *result=sint(om_table.size); break;
	case 4: *result=sint(om_max_object_count); break;
	case 5: *result=sint(cache_size); break;
	case 6: *result=sint(cache_entry); break;
	case 7:
#if U64_P
		*result=p_uint32(cache_call);
#else
		*result=p_uint64(cache_call);
#endif
		break;
	case 8:
#if U64_P
		*result=p_uint32(cache_hit);
#else
		*result=p_uint64(cache_hit);
#endif
		break;
	case 9: *result=sint(cache_invalidate); break;
	case 10: *result=sint(sizeof(void*)); break;
	case 11: 
		{
			int val=0x12345678;
			*result=om_boolean(LC(&val)==0x78);
		}
		break;
	default:
		return PRIM_ANOTHER_PROPERTY;
	}
	return PRIM_SUCCESS;
}

extern int (*property_table[])(int key,object value,object *result);
DEFPRIM(kernel_property)
{
	int key,(*func)(int key,object value,object *result),i,st;
	
	GET_SINT_ARG(0,key);
	for(i=0;(func=property_table[i])!=NULL;i++) {
		st=(*func)(key,args[1],result);
		if(st!=PRIM_ANOTHER_PROPERTY) return st;
	}
	return PRIM_ERROR;	
}
