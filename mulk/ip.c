/*
	interpreter.
	$Id: mulk ip.c 1511 2026-01-03 Sat 09:48:19 kt $
*/

#include "std.h"
#include <string.h>
#include <setjmp.h>
#include "mem.h"

#include "om.h"
#include "os.h"
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

static void error(char *msg);

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
	if(sp==cur_stack->farray.size-STACK_GAP) {
		STACK(sp++)=o;
		error("stack overflow.");
	} else if(sp>=cur_stack->farray.size) xerror("out of spare space in stack");

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
	hval=hval0=(HASH(cl)^(HASH(sel)<<1))&(cache_size-1);

	for(i=0;i<CACHE_N;i++) {
		c=&cache[hval];
		if(c->class==NULL) break;
		if(c->class==cl&&c->selector==sel) {
			cache_hit++;
			return c->method;
		}
		hval=(hval+1)&(cache_size-1);
	}

	if(i==CACHE_N) {
		cache_invalidate++;
		for(i=0;i<CACHE_N;i++) {
			cache[(hval0+i)&(cache_size-1)].class=NULL;
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

static int i_return(void)
{
	object retval;
	int retsp;

	if(cur_context==om_nil) {
		i_exit();
		return FALSE;
	}

	retval=STACK(--sp);
	retsp=sint_val(cur_context->context.sp);

	if(retsp>sp||STACK(retsp-1)!=cur_context) {
		error("i_return/illegal context.");
	}
	sp=retsp;
	--sp; /* context mark */
	if(sp==0) return TRUE; /* note: Mulk.class >> boot: must has block */
	restore();
	push(retval);
	return FALSE;
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
		error("i_branch_cond/reciever is not Boolean.");
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
		error("i_start_times_do/reciever is not ShortInteger");
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

static jmp_buf restart_env;

static void error(char *msg)
{
	object arg;
	arg=gc_string(msg);
	perform(cur_process,om_error,1,&arg,NULL);
	longjmp(restart_env,1);
}

int ip_trap_code;

static int poll(void)
{
	object args[2];
	static int poll_count=IP_POLLING_INTERVAL;

	if(poll_count--==0) {
		poll_count=IP_POLLING_INTERVAL;
		gc_chance();
#if INTR_CHECK_P
		ip_intr_check();
#endif
	}

	if(ip_trap_code!=TRAP_NONE) {
		ip--; /* for fetched inst */
		save();
		args[0]=sint(ip_trap_code);
		args[1]=sint(sp);
		ip=-1;
		ip_trap_code=TRAP_NONE;
		perform(cur_process,om_trap_sp,2,args,NULL);
		return FALSE;
	}

	return TRUE;
}

static void ip_main(void)
{
#if IP_VER==IP_VER1
	int op,lo,opr;
	object common_literal[7];

	common_literal[0]=sint(0);
	common_literal[1]=sint(1);
	common_literal[2]=sint(2);
	common_literal[3]=sint(-1);
	common_literal[4]=om_nil;
	common_literal[5]=om_true;
	common_literal[6]=om_false;

	setjmp(restart_env);

	while(TRUE) {
#ifdef IP_PROFILE
		if(profile_fn!=NULL) cur_profile->cycle_count++;
#endif
		cycle++;

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
			case BRANCH_BACKWARD_INST: 
				if(poll()) i_branch(-fetch());
				break;
			case DROP_INST: --sp; break;
			case EXIT_INST: 
				if(poll()) i_exit();
				break;
			case RETURN_INST: 
				if(poll()) {
					if(i_return()) return;
				}
				break;
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
			case BRANCH_FALSE_FORWARD_INST: 
				i_branch_cond(FALSE,fetch()); 
				break;
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
#endif

#if IP_VER==IP_VER2
	int opr;

	setjmp(restart_env);
	while(TRUE) {
#ifdef IP_PROFILE
		if(profile_fn!=NULL) cur_profile->cycle_count++;
#endif
		cycle++;
		switch(fetch()) {
		/* basic inst */
		case 0x00: i_push_instance_var(fetch()); break;
		case 0x01: i_push_context_var(fetch()); break;
		case 0x02: i_push_temp_var(fetch()); break;
		case 0x03: i_push_literal(fetch()); break;
		case 0x04: i_set_instance_var(fetch()); break;
		case 0x05: i_set_context_var(fetch()); break;
		case 0x06: i_set_temp_var(fetch()); break;
		case 0x07: /* branch bacward */
			if(poll()) i_branch(-fetch());
			break;
		case 0x08: /* drop */
			--sp; 
			break; 
		case 0x09: /* exit */
			if(poll()) i_exit();
			break;
		case 0x0a: /* return */
			if(poll()) {
				if(i_return()) return;
			}
			break;
		case 0x0b: /* dup */
			push(STACK(sp-1)); 
			break;

		/* send */
		case 0x10: i_send(FALSE,0,fetch()); break;
		case 0x11: i_send(FALSE,1,fetch()); break;
		case 0x12: i_send(FALSE,2,fetch()); break;
		case 0x13: i_send(FALSE,3,fetch()); break;
		case 0x14: i_send(FALSE,4,fetch()); break;
		case 0x15: i_send(FALSE,5,fetch()); break;
		case 0x16: i_send(FALSE,6,fetch()); break;
		case 0x17: i_send(FALSE,7,fetch()); break;
		case 0x18: i_send(FALSE,8,fetch()); break;
		case 0x19: i_send(FALSE,9,fetch()); break;
		case 0x1a: i_send(FALSE,10,fetch()); break;
		case 0x1b: i_send(FALSE,11,fetch()); break;
		case 0x1c: i_send(FALSE,12,fetch()); break;
		case 0x1d: i_send(FALSE,13,fetch()); break;
		case 0x1e: i_send(FALSE,14,fetch()); break;
		case 0x1f: i_send(FALSE,15,fetch()); break;

		/* super send */
		case 0x20: i_send(TRUE,0,fetch()); break;
		case 0x21: i_send(TRUE,1,fetch()); break;
		case 0x22: i_send(TRUE,2,fetch()); break;
		case 0x23: i_send(TRUE,3,fetch()); break;
		case 0x24: i_send(TRUE,4,fetch()); break;
		case 0x25: i_send(TRUE,5,fetch()); break;
		case 0x26: i_send(TRUE,6,fetch()); break;
		case 0x27: i_send(TRUE,7,fetch()); break;
		case 0x28: i_send(TRUE,8,fetch()); break;
		case 0x29: i_send(TRUE,9,fetch()); break;
		case 0x2a: i_send(TRUE,10,fetch()); break;
		case 0x2b: i_send(TRUE,11,fetch()); break;
		case 0x2c: i_send(TRUE,12,fetch()); break;
		case 0x2d: i_send(TRUE,13,fetch()); break;
		case 0x2e: i_send(TRUE,14,fetch()); break;
		case 0x2f: i_send(TRUE,15,fetch()); break;

		/* block */
		case 0x30: i_block(0,fetch()); break;
		case 0x31: i_block(1,fetch()); break;
		case 0x32: i_block(2,fetch()); break;
		case 0x33: i_block(3,fetch()); break;
		case 0x34: i_block(4,fetch()); break;
		case 0x35: i_block(5,fetch()); break;
		case 0x36: i_block(6,fetch()); break;
		case 0x37: i_block(7,fetch()); break;
		case 0x38: i_block(8,fetch()); break;
		case 0x39: i_block(9,fetch()); break;
		case 0x3a: i_block(10,fetch()); break;
		case 0x3b: i_block(11,fetch()); break;
		case 0x3c: i_block(12,fetch()); break;
		case 0x3d: i_block(13,fetch()); break;
		case 0x3e: i_block(14,fetch()); break;
		case 0x3f: i_block(15,fetch()); break;

		/* extend */
		case 0x40: i_branch(fetch()); break;
		case 0x41: i_branch_cond(TRUE,fetch()); break;
		case 0x42: i_branch_cond(FALSE,fetch()); break;
		case 0x43: i_start_times_do(); break;
		case 0x44:
			opr=fetch();
			i_times_do(opr,fetch());
			break;
		case 0x45: i_break(); break;

		/* push instance var short */
		case 0x50: i_push_instance_var(0); break;
		case 0x51: i_push_instance_var(1); break;
		case 0x52: i_push_instance_var(2); break;
		case 0x53: i_push_instance_var(3); break;
		case 0x54: i_push_instance_var(4); break;
		case 0x55: i_push_instance_var(5); break;
		case 0x56: i_push_instance_var(6); break;
		case 0x57: i_push_instance_var(7); break;
		case 0x58: i_push_instance_var(8); break;
		case 0x59: i_push_instance_var(9); break;
		case 0x5a: i_push_instance_var(10); break;
		case 0x5b: i_push_instance_var(11); break;
		case 0x5c: i_push_instance_var(12); break;
		case 0x5d: i_push_instance_var(13); break;
		case 0x5e: i_push_instance_var(14); break;
		case 0x5f: i_push_instance_var(15); break;

		/* push context var short */
		case 0x60: i_push_context_var(0); break;
		case 0x61: i_push_context_var(1); break;
		case 0x62: i_push_context_var(2); break;
		case 0x63: i_push_context_var(3); break;
		case 0x64: i_push_context_var(4); break;
		case 0x65: i_push_context_var(5); break;
		case 0x66: i_push_context_var(6); break;
		case 0x67: i_push_context_var(7); break;
		case 0x68: i_push_context_var(8); break;
		case 0x69: i_push_context_var(9); break;
		case 0x6a: i_push_context_var(10); break;
		case 0x6b: i_push_context_var(11); break;
		case 0x6c: i_push_context_var(12); break;
		case 0x6d: i_push_context_var(13); break;
		case 0x6e: i_push_context_var(14); break;
		case 0x6f: i_push_context_var(15); break;

		/* push temp var short */
		case 0x70: i_push_temp_var(0); break;
		case 0x71: i_push_temp_var(1); break;
		case 0x72: i_push_temp_var(2); break;
		case 0x73: i_push_temp_var(3); break;
		case 0x74: i_push_temp_var(4); break;
		case 0x75: i_push_temp_var(5); break;
		case 0x76: i_push_temp_var(6); break;
		case 0x77: i_push_temp_var(7); break;
		case 0x78: i_push_temp_var(8); break;
		case 0x79: i_push_temp_var(9); break;
		case 0x7a: i_push_temp_var(10); break;
		case 0x7b: i_push_temp_var(11); break;
		case 0x7c: i_push_temp_var(12); break;
		case 0x7d: i_push_temp_var(13); break;
		case 0x7e: i_push_temp_var(14); break;
		case 0x7f: i_push_temp_var(15); break;

		/* push literal short */
		case 0x80: i_push_literal(0); break;
		case 0x81: i_push_literal(1); break;
		case 0x82: i_push_literal(2); break;
		case 0x83: i_push_literal(3); break;
		case 0x84: i_push_literal(4); break;
		case 0x85: i_push_literal(5); break;
		case 0x86: i_push_literal(6); break;
		case 0x87: i_push_literal(7); break;
		case 0x88: i_push_literal(8); break;
		case 0x89: i_push_literal(9); break;
		case 0x8a: i_push_literal(10); break;
		case 0x8b: i_push_literal(11); break;
		case 0x8c: i_push_literal(12); break;
		case 0x8d: i_push_literal(13); break;
		case 0x8e: i_push_literal(14); break;
		case 0x8f: i_push_literal(15); break;

		/* set instance var short */
		case 0x90: i_set_instance_var(0); break;
		case 0x91: i_set_instance_var(1); break;
		case 0x92: i_set_instance_var(2); break;
		case 0x93: i_set_instance_var(3); break;
		case 0x94: i_set_instance_var(4); break;
		case 0x95: i_set_instance_var(5); break;
		case 0x96: i_set_instance_var(6); break;
		case 0x97: i_set_instance_var(7); break;
		case 0x98: i_set_instance_var(8); break;
		case 0x99: i_set_instance_var(9); break;
		case 0x9a: i_set_instance_var(10); break;
		case 0x9b: i_set_instance_var(11); break;
		case 0x9c: i_set_instance_var(12); break;
		case 0x9d: i_set_instance_var(13); break;
		case 0x9e: i_set_instance_var(14); break;
		case 0x9f: i_set_instance_var(15); break;

		/* set context var short */
		case 0xa0: i_set_context_var(0); break;
		case 0xa1: i_set_context_var(1); break;
		case 0xa2: i_set_context_var(2); break;
		case 0xa3: i_set_context_var(3); break;
		case 0xa4: i_set_context_var(4); break;
		case 0xa5: i_set_context_var(5); break;
		case 0xa6: i_set_context_var(6); break;
		case 0xa7: i_set_context_var(7); break;
		case 0xa8: i_set_context_var(8); break;
		case 0xa9: i_set_context_var(9); break;
		case 0xaa: i_set_context_var(10); break;
		case 0xab: i_set_context_var(11); break;
		case 0xac: i_set_context_var(12); break;
		case 0xad: i_set_context_var(13); break;
		case 0xae: i_set_context_var(14); break;
		case 0xaf: i_set_context_var(15); break;

		/* set temp var short */
		case 0xb0: i_set_temp_var(0); break;
		case 0xb1: i_set_temp_var(1); break;
		case 0xb2: i_set_temp_var(2); break;
		case 0xb3: i_set_temp_var(3); break;
		case 0xb4: i_set_temp_var(4); break;
		case 0xb5: i_set_temp_var(5); break;
		case 0xb6: i_set_temp_var(6); break;
		case 0xb7: i_set_temp_var(7); break;
		case 0xb8: i_set_temp_var(8); break;
		case 0xb9: i_set_temp_var(9); break;
		case 0xba: i_set_temp_var(10); break;
		case 0xbb: i_set_temp_var(11); break;
		case 0xbc: i_set_temp_var(12); break;
		case 0xbd: i_set_temp_var(13); break;
		case 0xbe: i_set_temp_var(14); break;
		case 0xbf: i_set_temp_var(15); break;

		/* set 0 short */
		case 0xc0: i_send(FALSE,0,0); break;
		case 0xc1: i_send(FALSE,0,1); break;
		case 0xc2: i_send(FALSE,0,2); break;
		case 0xc3: i_send(FALSE,0,3); break;
		case 0xc4: i_send(FALSE,0,4); break;
		case 0xc5: i_send(FALSE,0,5); break;
		case 0xc6: i_send(FALSE,0,6); break;
		case 0xc7: i_send(FALSE,0,7); break;
		case 0xc8: i_send(FALSE,0,8); break;
		case 0xc9: i_send(FALSE,0,9); break;
		case 0xca: i_send(FALSE,0,10); break;
		case 0xcb: i_send(FALSE,0,11); break;
		case 0xcc: i_send(FALSE,0,12); break;
		case 0xcd: i_send(FALSE,0,13); break;
		case 0xce: i_send(FALSE,0,14); break;
		case 0xcf: i_send(FALSE,0,15); break;

		/* set 1 short */
		case 0xd0: i_send(FALSE,1,0); break;
		case 0xd1: i_send(FALSE,1,1); break;
		case 0xd2: i_send(FALSE,1,2); break;
		case 0xd3: i_send(FALSE,1,3); break;
		case 0xd4: i_send(FALSE,1,4); break;
		case 0xd5: i_send(FALSE,1,5); break;
		case 0xd6: i_send(FALSE,1,6); break;
		case 0xd7: i_send(FALSE,1,7); break;
		case 0xd8: i_send(FALSE,1,8); break;
		case 0xd9: i_send(FALSE,1,9); break;
		case 0xda: i_send(FALSE,1,10); break;
		case 0xdb: i_send(FALSE,1,11); break;
		case 0xdc: i_send(FALSE,1,12); break;
		case 0xdd: i_send(FALSE,1,13); break;
		case 0xde: i_send(FALSE,1,14); break;
		case 0xdf: i_send(FALSE,1,15); break;

		/* send common */
		case 0xe0: i_send_equal(); break;
		case 0xe1: i_send_plus(); break;
		case 0xe2: i_send_lt(); break;
		case 0xe3: STACK(sp-1)=om_boolean(STACK(sp-1)==om_nil); break;
		case 0xe4: STACK(sp-1)=om_boolean(STACK(sp-1)!=om_nil); break;
		case 0xe5: i_send_inc(); break;
		case 0xe6: i_send_at(); break;
		case 0xe7: i_send_value1(); break;
		case 0xe8: i_send_at_put(); break;
		case 0xe9: i_send_byteAt(); break;

		/* push common */
		case 0xf0: push(sint(0)); break;
		case 0xf1: push(sint(1)); break;
		case 0xf2: push(sint(2)); break;
		case 0xf3: push(sint(-1)); break;
		case 0xf4: push(om_nil); break;
		case 0xf5: push(om_true); break;
		case 0xf6: push(om_false); break;

		/**/
		default: xassert(FALSE);
		}
	}
#endif

#if IP_VER==IP_VER3
	int opr;
	
	static void *inst_table[]={
		&&I00, &&I01, &&I02, &&I03, &&I04, &&I05, &&I06, &&I07,
		&&I08, &&I09, &&I0a, &&I0b, &&Ixx, &&Ixx, &&Ixx, &&Ixx,
		&&I10, &&I11, &&I12, &&I13, &&I14, &&I15, &&I16, &&I17,
		&&I18, &&I19, &&I1a, &&I1b, &&I1c, &&I1d, &&I1e, &&I1f,
		&&I20, &&I21, &&I22, &&I23, &&I24, &&I25, &&I26, &&I27,
		&&I28, &&I29, &&I2a, &&I2b, &&I2c, &&I2d, &&I2e, &&I2f,
		&&I30, &&I31, &&I32, &&I33, &&I34, &&I35, &&I36, &&I37,
		&&I38, &&I39, &&I3a, &&I3b, &&I3c, &&I3d, &&I3e, &&I3f,
		&&I40, &&I41, &&I42, &&I43, &&I44, &&I45, &&Ixx, &&Ixx,
		&&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx,
		&&I50, &&I51, &&I52, &&I53, &&I54, &&I55, &&I56, &&I57,
		&&I58, &&I59, &&I5a, &&I5b, &&I5c, &&I5d, &&I5e, &&I5f,
		&&I60, &&I61, &&I62, &&I63, &&I64, &&I65, &&I66, &&I67,
		&&I68, &&I69, &&I6a, &&I6b, &&I6c, &&I6d, &&I6e, &&I6f,
		&&I70, &&I71, &&I72, &&I73, &&I74, &&I75, &&I76, &&I77,
		&&I78, &&I79, &&I7a, &&I7b, &&I7c, &&I7d, &&I7e, &&I7f,
		&&I80, &&I81, &&I82, &&I83, &&I84, &&I85, &&I86, &&I87,
		&&I88, &&I89, &&I8a, &&I8b, &&I8c, &&I8d, &&I8e, &&I8f,
		&&I90, &&I91, &&I92, &&I93, &&I94, &&I95, &&I96, &&I97,
		&&I98, &&I99, &&I9a, &&I9b, &&I9c, &&I9d, &&I9e, &&I9f,
		&&Ia0, &&Ia1, &&Ia2, &&Ia3, &&Ia4, &&Ia5, &&Ia6, &&Ia7,
		&&Ia8, &&Ia9, &&Iaa, &&Iab, &&Iac, &&Iad, &&Iae, &&Iaf,
		&&Ib0, &&Ib1, &&Ib2, &&Ib3, &&Ib4, &&Ib5, &&Ib6, &&Ib7,
		&&Ib8, &&Ib9, &&Iba, &&Ibb, &&Ibc, &&Ibd, &&Ibe, &&Ibf,
		&&Ic0, &&Ic1, &&Ic2, &&Ic3, &&Ic4, &&Ic5, &&Ic6, &&Ic7,
		&&Ic8, &&Ic9, &&Ica, &&Icb, &&Icc, &&Icd, &&Ice, &&Icf,
		&&Id0, &&Id1, &&Id2, &&Id3, &&Id4, &&Id5, &&Id6, &&Id7,
		&&Id8, &&Id9, &&Ida, &&Idb, &&Idc, &&Idd, &&Ide, &&Idf,
		&&Ie0, &&Ie1, &&Ie2, &&Ie3, &&Ie4, &&Ie5, &&Ie6, &&Ie7,
		&&Ie8, &&Ie9, &&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx,
		&&If0, &&If1, &&If2, &&If3, &&If4, &&If5, &&If6, &&Ixx,
		&&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx, &&Ixx 
	};
	
#define DISPATCH() { cycle++; goto *inst_table[fetch()]; }

	setjmp(restart_env);
	DISPATCH();
	
	/* basic inst */
	I00: i_push_instance_var(fetch()); DISPATCH();
	I01: i_push_context_var(fetch()); DISPATCH();
	I02: i_push_temp_var(fetch()); DISPATCH();
	I03: i_push_literal(fetch()); DISPATCH();
	I04: i_set_instance_var(fetch()); DISPATCH();
	I05: i_set_context_var(fetch()); DISPATCH();
	I06: i_set_temp_var(fetch()); DISPATCH();
	I07: /* branch bacward */
		if(poll()) i_branch(-fetch());
		DISPATCH();
	I08: /* drop */
		--sp; 
		DISPATCH(); 
	I09: /* exit */
		if(poll()) i_exit();
		DISPATCH();
	I0a: /* return */
		if(poll()) {
			if(i_return()) return;
		}
		DISPATCH();
	I0b: /* dup */
		push(STACK(sp-1)); 
		DISPATCH();
	
	/* send */
	I10: i_send(FALSE,0,fetch()); DISPATCH();
	I11: i_send(FALSE,1,fetch()); DISPATCH();
	I12: i_send(FALSE,2,fetch()); DISPATCH();
	I13: i_send(FALSE,3,fetch()); DISPATCH();
	I14: i_send(FALSE,4,fetch()); DISPATCH();
	I15: i_send(FALSE,5,fetch()); DISPATCH();
	I16: i_send(FALSE,6,fetch()); DISPATCH();
	I17: i_send(FALSE,7,fetch()); DISPATCH();
	I18: i_send(FALSE,8,fetch()); DISPATCH();
	I19: i_send(FALSE,9,fetch()); DISPATCH();
	I1a: i_send(FALSE,10,fetch()); DISPATCH();
	I1b: i_send(FALSE,11,fetch()); DISPATCH();
	I1c: i_send(FALSE,12,fetch()); DISPATCH();
	I1d: i_send(FALSE,13,fetch()); DISPATCH();
	I1e: i_send(FALSE,14,fetch()); DISPATCH();
	I1f: i_send(FALSE,15,fetch()); DISPATCH();
	
	/* super send */
	I20: i_send(TRUE,0,fetch()); DISPATCH();
	I21: i_send(TRUE,1,fetch()); DISPATCH();
	I22: i_send(TRUE,2,fetch()); DISPATCH();
	I23: i_send(TRUE,3,fetch()); DISPATCH();
	I24: i_send(TRUE,4,fetch()); DISPATCH();
	I25: i_send(TRUE,5,fetch()); DISPATCH();
	I26: i_send(TRUE,6,fetch()); DISPATCH();
	I27: i_send(TRUE,7,fetch()); DISPATCH();
	I28: i_send(TRUE,8,fetch()); DISPATCH();
	I29: i_send(TRUE,9,fetch()); DISPATCH();
	I2a: i_send(TRUE,10,fetch()); DISPATCH();
	I2b: i_send(TRUE,11,fetch()); DISPATCH();
	I2c: i_send(TRUE,12,fetch()); DISPATCH();
	I2d: i_send(TRUE,13,fetch()); DISPATCH();
	I2e: i_send(TRUE,14,fetch()); DISPATCH();
	I2f: i_send(TRUE,15,fetch()); DISPATCH();
	
	/* block */
	I30: i_block(0,fetch()); DISPATCH();
	I31: i_block(1,fetch()); DISPATCH();
	I32: i_block(2,fetch()); DISPATCH();
	I33: i_block(3,fetch()); DISPATCH();
	I34: i_block(4,fetch()); DISPATCH();
	I35: i_block(5,fetch()); DISPATCH();
	I36: i_block(6,fetch()); DISPATCH();
	I37: i_block(7,fetch()); DISPATCH();
	I38: i_block(8,fetch()); DISPATCH();
	I39: i_block(9,fetch()); DISPATCH();
	I3a: i_block(10,fetch()); DISPATCH();
	I3b: i_block(11,fetch()); DISPATCH();
	I3c: i_block(12,fetch()); DISPATCH();
	I3d: i_block(13,fetch()); DISPATCH();
	I3e: i_block(14,fetch()); DISPATCH();
	I3f: i_block(15,fetch()); DISPATCH();
	
	/* extend */
	I40: i_branch(fetch()); DISPATCH();
	I41: i_branch_cond(TRUE,fetch()); DISPATCH();
	I42: i_branch_cond(FALSE,fetch()); DISPATCH();
	I43: i_start_times_do(); DISPATCH();
	I44:
		opr=fetch();
		i_times_do(opr,fetch());
		DISPATCH();
	I45: i_break(); DISPATCH();
	
	/* push instance var short */
	I50: i_push_instance_var(0); DISPATCH();
	I51: i_push_instance_var(1); DISPATCH();
	I52: i_push_instance_var(2); DISPATCH();
	I53: i_push_instance_var(3); DISPATCH();
	I54: i_push_instance_var(4); DISPATCH();
	I55: i_push_instance_var(5); DISPATCH();
	I56: i_push_instance_var(6); DISPATCH();
	I57: i_push_instance_var(7); DISPATCH();
	I58: i_push_instance_var(8); DISPATCH();
	I59: i_push_instance_var(9); DISPATCH();
	I5a: i_push_instance_var(10); DISPATCH();
	I5b: i_push_instance_var(11); DISPATCH();
	I5c: i_push_instance_var(12); DISPATCH();
	I5d: i_push_instance_var(13); DISPATCH();
	I5e: i_push_instance_var(14); DISPATCH();
	I5f: i_push_instance_var(15); DISPATCH();
	
	/* push context var short */
	I60: i_push_context_var(0); DISPATCH();
	I61: i_push_context_var(1); DISPATCH();
	I62: i_push_context_var(2); DISPATCH();
	I63: i_push_context_var(3); DISPATCH();
	I64: i_push_context_var(4); DISPATCH();
	I65: i_push_context_var(5); DISPATCH();
	I66: i_push_context_var(6); DISPATCH();
	I67: i_push_context_var(7); DISPATCH();
	I68: i_push_context_var(8); DISPATCH();
	I69: i_push_context_var(9); DISPATCH();
	I6a: i_push_context_var(10); DISPATCH();
	I6b: i_push_context_var(11); DISPATCH();
	I6c: i_push_context_var(12); DISPATCH();
	I6d: i_push_context_var(13); DISPATCH();
	I6e: i_push_context_var(14); DISPATCH();
	I6f: i_push_context_var(15); DISPATCH();
	
	/* push temp var short */
	I70: i_push_temp_var(0); DISPATCH();
	I71: i_push_temp_var(1); DISPATCH();
	I72: i_push_temp_var(2); DISPATCH();
	I73: i_push_temp_var(3); DISPATCH();
	I74: i_push_temp_var(4); DISPATCH();
	I75: i_push_temp_var(5); DISPATCH();
	I76: i_push_temp_var(6); DISPATCH();
	I77: i_push_temp_var(7); DISPATCH();
	I78: i_push_temp_var(8); DISPATCH();
	I79: i_push_temp_var(9); DISPATCH();
	I7a: i_push_temp_var(10); DISPATCH();
	I7b: i_push_temp_var(11); DISPATCH();
	I7c: i_push_temp_var(12); DISPATCH();
	I7d: i_push_temp_var(13); DISPATCH();
	I7e: i_push_temp_var(14); DISPATCH();
	I7f: i_push_temp_var(15); DISPATCH();
	
	/* push literal short */
	I80: i_push_literal(0); DISPATCH();
	I81: i_push_literal(1); DISPATCH();
	I82: i_push_literal(2); DISPATCH();
	I83: i_push_literal(3); DISPATCH();
	I84: i_push_literal(4); DISPATCH();
	I85: i_push_literal(5); DISPATCH();
	I86: i_push_literal(6); DISPATCH();
	I87: i_push_literal(7); DISPATCH();
	I88: i_push_literal(8); DISPATCH();
	I89: i_push_literal(9); DISPATCH();
	I8a: i_push_literal(10); DISPATCH();
	I8b: i_push_literal(11); DISPATCH();
	I8c: i_push_literal(12); DISPATCH();
	I8d: i_push_literal(13); DISPATCH();
	I8e: i_push_literal(14); DISPATCH();
	I8f: i_push_literal(15); DISPATCH();
	
	/* set instance var short */
	I90: i_set_instance_var(0); DISPATCH();
	I91: i_set_instance_var(1); DISPATCH();
	I92: i_set_instance_var(2); DISPATCH();
	I93: i_set_instance_var(3); DISPATCH();
	I94: i_set_instance_var(4); DISPATCH();
	I95: i_set_instance_var(5); DISPATCH();
	I96: i_set_instance_var(6); DISPATCH();
	I97: i_set_instance_var(7); DISPATCH();
	I98: i_set_instance_var(8); DISPATCH();
	I99: i_set_instance_var(9); DISPATCH();
	I9a: i_set_instance_var(10); DISPATCH();
	I9b: i_set_instance_var(11); DISPATCH();
	I9c: i_set_instance_var(12); DISPATCH();
	I9d: i_set_instance_var(13); DISPATCH();
	I9e: i_set_instance_var(14); DISPATCH();
	I9f: i_set_instance_var(15); DISPATCH();
	
	/* set context var short */
	Ia0: i_set_context_var(0); DISPATCH();
	Ia1: i_set_context_var(1); DISPATCH();
	Ia2: i_set_context_var(2); DISPATCH();
	Ia3: i_set_context_var(3); DISPATCH();
	Ia4: i_set_context_var(4); DISPATCH();
	Ia5: i_set_context_var(5); DISPATCH();
	Ia6: i_set_context_var(6); DISPATCH();
	Ia7: i_set_context_var(7); DISPATCH();
	Ia8: i_set_context_var(8); DISPATCH();
	Ia9: i_set_context_var(9); DISPATCH();
	Iaa: i_set_context_var(10); DISPATCH();
	Iab: i_set_context_var(11); DISPATCH();
	Iac: i_set_context_var(12); DISPATCH();
	Iad: i_set_context_var(13); DISPATCH();
	Iae: i_set_context_var(14); DISPATCH();
	Iaf: i_set_context_var(15); DISPATCH();
	
	/* set temp var short */
	Ib0: i_set_temp_var(0); DISPATCH();
	Ib1: i_set_temp_var(1); DISPATCH();
	Ib2: i_set_temp_var(2); DISPATCH();
	Ib3: i_set_temp_var(3); DISPATCH();
	Ib4: i_set_temp_var(4); DISPATCH();
	Ib5: i_set_temp_var(5); DISPATCH();
	Ib6: i_set_temp_var(6); DISPATCH();
	Ib7: i_set_temp_var(7); DISPATCH();
	Ib8: i_set_temp_var(8); DISPATCH();
	Ib9: i_set_temp_var(9); DISPATCH();
	Iba: i_set_temp_var(10); DISPATCH();
	Ibb: i_set_temp_var(11); DISPATCH();
	Ibc: i_set_temp_var(12); DISPATCH();
	Ibd: i_set_temp_var(13); DISPATCH();
	Ibe: i_set_temp_var(14); DISPATCH();
	Ibf: i_set_temp_var(15); DISPATCH();
	
	/* set 0 short */
	Ic0: i_send(FALSE,0,0); DISPATCH();
	Ic1: i_send(FALSE,0,1); DISPATCH();
	Ic2: i_send(FALSE,0,2); DISPATCH();
	Ic3: i_send(FALSE,0,3); DISPATCH();
	Ic4: i_send(FALSE,0,4); DISPATCH();
	Ic5: i_send(FALSE,0,5); DISPATCH();
	Ic6: i_send(FALSE,0,6); DISPATCH();
	Ic7: i_send(FALSE,0,7); DISPATCH();
	Ic8: i_send(FALSE,0,8); DISPATCH();
	Ic9: i_send(FALSE,0,9); DISPATCH();
	Ica: i_send(FALSE,0,10); DISPATCH();
	Icb: i_send(FALSE,0,11); DISPATCH();
	Icc: i_send(FALSE,0,12); DISPATCH();
	Icd: i_send(FALSE,0,13); DISPATCH();
	Ice: i_send(FALSE,0,14); DISPATCH();
	Icf: i_send(FALSE,0,15); DISPATCH();
	
	/* set 1 short */
	Id0: i_send(FALSE,1,0); DISPATCH();
	Id1: i_send(FALSE,1,1); DISPATCH();
	Id2: i_send(FALSE,1,2); DISPATCH();
	Id3: i_send(FALSE,1,3); DISPATCH();
	Id4: i_send(FALSE,1,4); DISPATCH();
	Id5: i_send(FALSE,1,5); DISPATCH();
	Id6: i_send(FALSE,1,6); DISPATCH();
	Id7: i_send(FALSE,1,7); DISPATCH();
	Id8: i_send(FALSE,1,8); DISPATCH();
	Id9: i_send(FALSE,1,9); DISPATCH();
	Ida: i_send(FALSE,1,10); DISPATCH();
	Idb: i_send(FALSE,1,11); DISPATCH();
	Idc: i_send(FALSE,1,12); DISPATCH();
	Idd: i_send(FALSE,1,13); DISPATCH();
	Ide: i_send(FALSE,1,14); DISPATCH();
	Idf: i_send(FALSE,1,15); DISPATCH();
	
	/* send common */
	Ie0: i_send_equal(); DISPATCH();
	Ie1: i_send_plus(); DISPATCH();
	Ie2: i_send_lt(); DISPATCH();
	Ie3: STACK(sp-1)=om_boolean(STACK(sp-1)==om_nil); DISPATCH();
	Ie4: STACK(sp-1)=om_boolean(STACK(sp-1)!=om_nil); DISPATCH();
	Ie5: i_send_inc(); DISPATCH();
	Ie6: i_send_at(); DISPATCH();
	Ie7: i_send_value1(); DISPATCH();
	Ie8: i_send_at_put(); DISPATCH();
	Ie9: i_send_byteAt(); DISPATCH();
	
	/* push common */
	If0: push(sint(0)); DISPATCH();
	If1: push(sint(1)); DISPATCH();
	If2: push(sint(2)); DISPATCH();
	If3: push(sint(-1)); DISPATCH();
	If4: push(om_nil); DISPATCH();
	If5: push(om_true); DISPATCH();
	If6: push(om_false); DISPATCH();
		
	Ixx:;
#endif
}

static void switch_process(object process)
{
	cur_process=process;
	cur_stack=process->process.stack;
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

	os_intr_init();

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

char *vm_fn;
char *image_fn;

#if WINDOWS_P
int codepage;
#endif

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
	case 12:
		if(image_fn==NULL) *result=om_nil;
		else *result=gc_string(image_fn);
		break;
	case 13:
		if(vm_fn==NULL) *result=om_nil;
		else *result=gc_string(vm_fn);
		break;
#if WINDOWS_P
	case 14:
		if(sint_p(value)) codepage=sint_val(value);
		break;
#endif
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
