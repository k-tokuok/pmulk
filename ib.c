/*
	image builder.
	$Id: mulk ib.c 1191 2024-03-30 Sat 22:35:26 kt $
*/

#include "std.h"

#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "splay.h"
#include "heap.h"
#include "xgetopt.h"
#include "log.h"
#include "mem.h"
#include "xctype.h"

#include "om.h"
#include "omd.h"
#include "lex.h"
#include "inst.h"
#include "gc.h"
#include "ip.h"

/* option */

static int dump_object_table_p;
static int dump_method_p;
static int execute_p;
static char *base_fn;

static int charset_sjis_p;

static void option(int argc,char *argv[])
{
	int ch;

	dump_object_table_p=FALSE;
	dump_method_p=FALSE;
	execute_p=TRUE;
	base_fn="ib.wk";
	charset_sjis_p=FALSE;
		
	while((ch=xgetopt(argc,argv,"lL:omxb:"))!=EOF) switch(ch) {
	case 'l': log_open(NULL); break;
	case 'L': log_open(xoptarg); break;
	case 'o': dump_object_table_p=TRUE; break;
	case 'm': dump_method_p=TRUE; break;
	case 'x': execute_p=FALSE; break;
	case 'b': base_fn=xoptarg; break;
	default:
		fputs("\
-l to show log.\n\
-L FN to save log to FN.\n\
-o to dump object table.\n\
-m to dump method.\n\
-x to not execute.\n\
-b FN as base for ib, not ib.wk\n\
",stderr);
		exit(1);
	}
}

/* object construct and regist */

static void regist(object o)
{
	om_init_hash(o);
	xarray_add(&om_table,o);
}

static object fbarray_new(int type,int len)
{
	object o;

	o=om_alloc(sizeof(struct fbarray)+len-1);
	om_set_size(o,type);
	o->fbarray.size=len;
	regist(o);
	return o;
}

static object farray_new(int len)
{
	object o;
	o=om_alloc(sizeof(struct farray)+(len-1)*sizeof(object));
	om_set_size(o,SIZE_FARRAY);
	o->farray.size=len;
	om_init_array(o->farray.elt,len);
	regist(o);
	return o;
}

static object farray_new_xarray(struct xarray *x)
{
	object o;
	int i;
	
	if(x->size==0) return om_nil;
	
	o=farray_new(x->size);
	for(i=0;i<x->size;i++) o->farray.elt[i]=x->elt[i];
	return o;
}

static object float_new(double val)
{
	object o;
	o=om_alloc(sizeof(struct xfloat));
	om_set_size(o,SIZE_FLOAT);
	o->xfloat.val=val;
	regist(o);
	om_set_hash(o,om_number_hash(val));
	return o;
}

static object object_new0(int size)
{
	object o;

	o=om_alloc(sizeof(struct gobject)+(size-1)*sizeof(object));
	om_set_size(o,size);
	om_init_array(o->gobject.elt,size);
	regist(o);
	return o;	
}

static object object_new(object xclass)
{
	object o;
	int size;

	size=sint_val(xclass->xclass.size);
	xassert(size<SIZE_LAST);
	o=object_new0(size);
	o->gobject.xclass=xclass;
	return o;
}

/* symbol & string */

static struct splay symbol_splay;

static object symstr_new(int type,char *s)
{
	object o;
	int len;

	len=strlen(s);
	o=fbarray_new(type,len);
	memcpy(o->fbarray.elt,s,len);
	om_set_string_hash(o);
	return o;
}

static object symbol_new(char *s)
{
	object o;
	
	o=splay_find(&symbol_splay,s);
	if(o==NULL) {
		o=symstr_new(SIZE_SYMBOL,s);
		splay_add(&symbol_splay,heap_strdup(&heap_perm,s),o);
	}
	return o;
}

static int symbol_cmp(struct fbarray *p,struct fbarray *q)
{
	int i,d;
	
	if(p->size!=q->size) return p->size-q->size;
	for(i=0;i<p->size;i++) {
		if((d=p->elt[i]-q->elt[i])!=0) return d;
	}
	return 0;
}

static object string_new(char *s)
{
	return symstr_new(SIZE_STRING,s);
}

/* global */

static struct splay global_splay;

static void global_add(object key,object value)
{
	xassert(om_size(key)==SIZE_SYMBOL);
	splay_add(&global_splay,key,value);
}

static object global_find(char *name)
{
	object result,key;
	
	key=symbol_new(name);
	result=splay_find(&global_splay,key);
	if(result==NULL) {
		lex_error("global_find/%s undefined",name);
	}
	return result;
}

/* initial objects */

static void make_initial_objects(void)
{
	object Object,Nil;
	
	om_nil=object_new0(0);
	global_add(symbol_new("nil"),om_nil);

	Object=object_new0(SIZE_CLASS);
	Object->xclass.name=symbol_new("Object");
	Object->xclass.size=sint(0);
	global_add(Object->xclass.name,Object);

	Nil=object_new0(SIZE_CLASS);
	Nil->xclass.name=symbol_new("Nil");
	Nil->xclass.size=sint(0);
	Nil->xclass.superclass=Object;
	global_add(Nil->xclass.name,Nil);
	
	om_nil->gobject.xclass=Nil;

	om_Class=object_new0(SIZE_CLASS);
	om_Class->xclass.name=symbol_new("Class");
	om_Class->xclass.size=sint(SIZE_CLASS);
	om_Class->xclass.superclass=Object;
	om_Class->xclass.instance_vars=
		string_new("name size superclass features instanceVars methods");
	global_add(om_Class->xclass.name,om_Class);
	
	Object->xclass.xclass=om_Class;
	Nil->xclass.xclass=om_Class;
	om_Class->xclass.xclass=om_Class;	
}

/* parser */

static int next_token;
static char cur_str[MAX_STR_LEN];

static void parse_skip(void)
{
	next_token=lex();
}

static void parse_token(int tk)
{
	char buf[MAX_STR_LEN];
	if(next_token!=tk) lex_error("missing %s",lex_token_name(buf,tk));

	if(tk==tIDENTIFIER||tk==tBINARY_SELECTOR||tk==tSYMBOL||tk==tKEYWORD_SELECTOR
		||tk==tSPECIAL) {
		if(lex_str.size>=MAX_STR_LEN) {
			lex_error("too long %s",lex_token_name(buf,tk));
		}
		memcpy(cur_str,lex_str.elt,lex_str.size);
		cur_str[lex_str.size]='\0';
	}
	parse_skip();
}

static char *parse_token_str(int tk)
{
	parse_token(tk);
	return cur_str;
}

static object parse_token_symbol(int tk)
{
	return symbol_new(parse_token_str(tk));
}

static object parse_identifier_class(void)
{
	object result;
	result=global_find(parse_token_str(tIDENTIFIER));
	xassert(result->gobject.xclass==om_Class);
	return result;
}

static int parse_integer(void)
{
	int result;
	result=lex_ival;
	parse_token(tINTEGER);
	return result;
}

/* class command */

static void class_command(void)
{
	object result;
	struct xbarray ivs;
	int super_size;
	int ivs_count;
	
	result=object_new(om_Class);
	result->xclass.name=parse_token_symbol(tIDENTIFIER);
	result->xclass.superclass=parse_identifier_class();
	super_size=sint_val(result->xclass.superclass->xclass.size);
	
	if(next_token==tINTEGER) {
		xassert(super_size==0||super_size>=SIZE_LAST);
		result->xclass.size=sint(parse_integer());
	} else {
		ivs_count=0;
		if(next_token==':') {
			xbarray_init(&ivs);
			parse_skip();
			while(next_token==tIDENTIFIER) {
				if(ivs_count!=0) xbarray_add(&ivs,' ');
				xbarray_adds(&ivs,parse_token_str(tIDENTIFIER));
				ivs_count++;
			}
			xbarray_add(&ivs,'\0');
			result->xclass.instance_vars=string_new(ivs.elt);
			xbarray_free(&ivs);
			xassert(super_size<SIZE_LAST);
			xassert(super_size+ivs.size<SIZE_LAST);
		}
		result->xclass.size=sint(super_size+ivs_count);
	}
	parse_token(';');
		
	global_add(result->xclass.name,result);
}

/* singleton command */

static void singleton_command(void)
{
	object xclass,name,o;
	
	xclass=parse_identifier_class();
	name=parse_token_symbol(tIDENTIFIER);
	parse_token(';');
	
	o=object_new(xclass);
	global_add(name,o);
}

/* feature command */

static void feature_command(void)
{
	struct xarray list;
	object xclass,cl;
	char buf[MAX_STR_LEN];
	
	xclass=parse_identifier_class();
	
	xarray_init(&list);
	while(next_token==tIDENTIFIER) {
		cl=parse_identifier_class();
		if(sint_val(cl->xclass.size)!=0) {
			lex_error("size of feature %s must be 0",om_describe(buf,cl));
		}
		xarray_add(&list,cl);
	}
	parse_token(';');

	xclass->xclass.features=farray_new_xarray(&list);
	xarray_free(&list);
}

/* regist builtin command */

/** chars */

static object char_table;

static object char_new(int ch)
{
	object result;
	int attr;
	
	result=object_new(om_Char);
	result->xchar.code=sint(ch);

	attr=0;
	if(ch<128) { /* for 7bit ascii area only */
		if(isprint(ch)) attr|=1;
		if(isspace(ch)) attr|=2;
		if(isdigit(ch)) attr|=4;
		if(islower(ch)) attr|=8;
		if(isupper(ch)) attr|=16;
	}
	
	if(utf8_mblead_p(ch)) attr|=32;
	if(utf8_mbtrail_p(ch)) attr|=64;
	attr|=utf8_trail_size(ch)<<8;

	result->xchar.attr=sint(attr);
	om_set_hash(result,ch+1);
	return result;
}

/**/

static object ib_GlobalVar;

static void regist_builtin_command(void)
{
	int ch;
	
	parse_token(';');
	
	om_nil=global_find("nil");
	om_true=global_find("true");
	om_false=global_find("false");
	
	om_Class=global_find("Class");
	om_ShortInteger=global_find("ShortInteger");
	xassert(sint_val(om_ShortInteger->xclass.size)==SIZE_SINT);
	om_LongPositiveInteger=global_find("LongPositiveInteger");
	xassert(sint_val(om_LongPositiveInteger->xclass.size)==SIZE_LPINT);
	om_Float=global_find("Float");
	xassert(sint_val(om_Float->xclass.size)==SIZE_FLOAT);
	om_FixedByteArray=global_find("FixedByteArray");
	xassert(sint_val(om_FixedByteArray->xclass.size)==SIZE_FBARRAY);
	om_String=global_find("String");
	xassert(sint_val(om_String->xclass.size)==SIZE_STRING);
	om_Symbol=global_find("Symbol");
	xassert(sint_val(om_Symbol->xclass.size)==SIZE_SYMBOL);
	om_FixedArray=global_find("FixedArray");
	xassert(sint_val(om_FixedArray->xclass.size)==SIZE_FARRAY);
	om_Method=global_find("Method");
	om_Process=global_find("Process");
	om_Context=global_find("Context");
	om_Block=global_find("Block");
	om_Char=global_find("Char");
	
	om_Mulk=global_find("Mulk");
	om_boot=symbol_new("boot:");
	om_doesNotUnderstand=symbol_new("doesNotUnderstand:");
	om_primitiveFailed=symbol_new("primitiveFailed:");
	om_error=symbol_new("error:");
	om_trap_cp_sp=symbol_new("trap:cp:sp:");
	om_equal=symbol_new("=");
	om_plus=symbol_new("+");
	om_lt=symbol_new("<");
	om_inc=symbol_new("_inc");
	om_at=symbol_new("at:");
	om_value=symbol_new("value:");
	om_at_put=symbol_new("at:put:");
	om_byteAt=symbol_new("byteAt:");

	/* ib internal */
	char_table=farray_new(256);
	for(ch=0;ch<=0xff;ch++) char_table->farray.elt[ch]=char_new(ch);

	ib_GlobalVar=global_find("GlobalVar");
}

/* method command */

static struct heap heap;
static object belong_class;
static struct xarray local_vars;
static struct xarray instance_vars;
static struct xarray literal;
static struct xbarray bytecode;

/** local var */

static int local_var_find(char *name)
{
	int i;
	for(i=0;i<local_vars.size;i++) {
		if(strcmp(local_vars.elt[i],name)==0) return i;
	}
	return -1;
}

static void local_var_new(char *name)
{
	if(local_var_find(name)!=-1) lex_error("redefine local var %s",name);
	xarray_add(&local_vars,heap_strdup(&heap,name));
}

/** instance var */

static int fbarray_spacepos(struct fbarray *fba,int st)
{
	while(st<fba->size) {
		if(fba->elt[st]==' ') return st;
		st++;
	}
	return -1;
}

static void instance_vars_setup(object cl)
{
	char buf[MAX_STR_LEN];
	struct fbarray *ivs;
	int st,sp;
	
	if(cl->xclass.superclass!=om_nil) {
		instance_vars_setup(cl->xclass.superclass);
	}
	if(cl->xclass.instance_vars==om_nil) return;
	ivs=&cl->xclass.instance_vars->fbarray;

	st=0;
	while((sp=fbarray_spacepos(ivs,st))!=-1) {
		xassert(sp-st<MAX_STR_LEN-1);
		memcpy(buf,ivs->elt+st,sp-st);
		buf[sp-st]='\0';
		xarray_add(&instance_vars,heap_strdup(&heap,buf));
		st=sp+1;
	}
	memcpy(buf,ivs->elt+st,ivs->size-st);
	buf[ivs->size-st]='\0';
	xarray_add(&instance_vars,heap_strdup(&heap,buf));
}

static int instance_var_find(char *name)
{
	int i;
	for(i=0;i<instance_vars.size;i++) {
		if(strcmp(name,instance_vars.elt[i])==0) return i;
	}
	return -1;
}

/** literal */

static int literal_new(object o)
{
	int no;
	for(no=0;no<literal.size;no++) if(literal.elt[no]==o) break;
	if(no==literal.size) xarray_add(&literal,o);
	return no;
}

/** cg */

static void gen_byte(int b)
{
	xassert(0<=b&&b<256);
	xbarray_add(&bytecode,b);
}

static void geni(int hi,int lo)
{
	xassert(hi==BASIC_INST||hi==SEND_INST||hi==SEND_SUPER_INST||hi==BLOCK_INST);
	xassert(lo<16);

	gen_byte(hi<<4|lo);
}

static void gen0(int opcode)
{
	xassert(opcode==DROP_INST||opcode==END_INST||opcode==RETURN_INST
		||opcode==DUP_INST);
	geni(BASIC_INST,opcode);
}

static void gen1(int opcode,int opr1)
{
	xassert(opcode==PUSH_INSTANCE_VAR_INST||opcode==PUSH_CONTEXT_VAR_INST
		||opcode==PUSH_TEMP_VAR_INST||opcode==PUSH_LITERAL_INST
		||opcode==SET_INSTANCE_VAR_INST||opcode==SET_CONTEXT_VAR_INST
		||opcode==SET_TEMP_VAR_INST||opcode==BRANCH_BACKWARD_INST);
	geni(BASIC_INST,opcode);
	gen_byte(opr1);
}

static void gen2(int opcode,int opr1,int opr2)
{
	xassert(opcode==BLOCK_INST||opcode==SEND_INST||opcode==SEND_SUPER_INST);
	geni(opcode,opr1);
	gen_byte(opr2);
}

static void gen_push_literal(object o)
{
	gen1(PUSH_LITERAL_INST,literal_new(o));
}

static void gen_send(int super_p,int narg,object selector)
{
	int opcode;
	
	if(super_p) opcode=SEND_SUPER_INST;
	else opcode=SEND_INST;

	gen2(opcode,narg,literal_new(selector));
}

/**/

static char *prim_name_table[]={
#define DEFPRIM(n) #n,
#include "ibprim.wk"
#undef DEFPRIM
	NULL
};

static int parse_primitive(void)
{
	char *name;
	int i;
	
	name=parse_token_str(tSPECIAL);
	for(i=0;prim_name_table[i]!=NULL;i++) {
		if(strcmp(name,prim_name_table[i])==0) return i;
	}
	lex_error("%s is not primitive",name);
	return 0;
}

static int global_var_p(object o)
{
	object cl;

	cl=om_class(o);
	while(cl!=om_nil) {
		if(cl==ib_GlobalVar) return TRUE;
		cl=cl->xclass.superclass;
	}
	return FALSE;
}

static object parse_literal(void)
{
	char buf[MAX_STR_LEN];
	struct xarray al;
	object result;
	
	if(next_token==tIDENTIFIER) {
		result=global_find(parse_token_str(tIDENTIFIER));
		if(global_var_p(result)) {
			lex_error("%s is global var",cur_str);
		}
	} else if(next_token==tINTEGER) {
		result=sint(parse_integer());
	} else if(next_token==tFLOAT) {
		result=float_new(lex_fval);
		parse_skip();
	} else if(next_token==tSYMBOL) {
		result=symbol_new(parse_token_str(tSYMBOL));
	} else if(next_token==tCHARACTER) {
		result=char_table->farray.elt[lex_ival];
		parse_skip();
	} else if(next_token==tSTRING) {
		result=fbarray_new(SIZE_STRING,lex_str.size);
		memcpy(result->fbarray.elt,lex_str.elt,lex_str.size);
		om_set_string_hash(result);
		parse_skip();
	} else if(next_token==tBINARY_SELECTOR) {
		if(strcmp(parse_token_str(tBINARY_SELECTOR),"-")!=0) {
			lex_error("require -");
		}
		result=sint(-parse_integer());
	} else if(next_token==tARRAY_LITERAL) {
		parse_skip();
		xarray_init(&al);
		while(next_token!=')') xarray_add(&al,parse_literal());
		parse_skip();
		result=farray_new_xarray(&al);
		xarray_free(&al);
	} else {
		result=NULL;
		lex_error("illegal token %s",lex_token_name(buf,next_token));
	}
	return result;
}

static void parse_expression(void);
static int parse_statement(void);

static int parse_factor(void)
{
	int no,argpos,block_start,block_len,i;
	char *name;
	object o;
	
	if(next_token==tIDENTIFIER) {
		name=parse_token_str(tIDENTIFIER);
		if(strcmp(name,"super")==0) {
			gen1(PUSH_TEMP_VAR_INST,0);
			return TRUE;
		} else if((no=local_var_find(name))!=-1) {
			gen1(PUSH_CONTEXT_VAR_INST,no);
		} else if((no=instance_var_find(name))!=-1) {
			gen1(PUSH_INSTANCE_VAR_INST,no);
		} else {
			o=global_find(name);
			gen_push_literal(o);
			if(global_var_p(o)) gen_send(FALSE,0,symbol_new("get"));
		}
	} else if(next_token=='(') {
		parse_skip();
		parse_expression();
		parse_token(')');
	} else if(next_token=='[') {
		parse_skip();
		argpos=local_vars.size;
		while(next_token==':') {
			parse_skip();
			local_var_new(parse_token_str(tIDENTIFIER));
		}
		gen2(BLOCK_INST,local_vars.size-argpos,0);
		block_start=bytecode.size;
		for(i=0;i<local_vars.size-argpos;i++) {
			gen1(PUSH_TEMP_VAR_INST,i+1);
			gen1(SET_CONTEXT_VAR_INST,argpos+i);
		}
		if(parse_statement()) gen0(RETURN_INST);
		else gen0(END_INST);
		block_len=bytecode.size-block_start;
		xassert(block_len<256);
		bytecode.elt[block_start-1]=block_len;
		parse_token(']');
	} else gen_push_literal(parse_literal());
	return FALSE;
}

static void parse_unary_message(int super_p)
{
	gen_send(super_p,0,parse_token_symbol(tIDENTIFIER));
}

static int parse_unary_expression(void)
{
	int super_p;
	super_p=parse_factor();
	while(next_token==tIDENTIFIER) {
		parse_unary_message(super_p);
		super_p=FALSE;
	}
	return super_p;
}

static void parse_binary_message(int super_p)
{
	object selector;
	selector=parse_token_symbol(tBINARY_SELECTOR);
	parse_unary_expression();
	gen_send(super_p,1,selector);
}

static int parse_binary_expression(void)
{
	int super_p;
	super_p=parse_unary_expression();
	while(next_token==tBINARY_SELECTOR) {
		parse_binary_message(super_p);
		super_p=FALSE;
	}
	return super_p;
}

static void parse_keyword_message(int super_p)
{
	int narg;
	struct xbarray keyword;

	narg=0;
	xbarray_init(&keyword);
	while(next_token==tKEYWORD_SELECTOR) {
		xbarray_adds(&keyword,parse_token_str(tKEYWORD_SELECTOR));
		parse_binary_expression();
		narg++;
	}
	xbarray_add(&keyword,'\0');
	gen_send(super_p,narg,symbol_new(keyword.elt));
	xbarray_free(&keyword);
}

static void parse_keyword_expression(void)
{
	int super_p;
	super_p=parse_binary_expression();
	if(next_token==tKEYWORD_SELECTOR) {
		parse_keyword_message(super_p);
		super_p=FALSE;
	}
	if(super_p) lex_error("super does not receives any message");
}

static void parse_expression(void)
{
	char *name;
	int no;
	object o;
	
	parse_keyword_expression();
	while(TRUE) {
		if(next_token==tARROW) {
			parse_skip();
			if(next_token==':') {
				parse_skip();
				gen0(DUP_INST);
				gen1(SET_CONTEXT_VAR_INST,local_vars.size);
				local_var_new(parse_token_str(tIDENTIFIER));
			} else {
				name=parse_token_str(tIDENTIFIER);
				if((no=local_var_find(name))!=-1) {
					if(no==0) lex_error("can't assign to self");
					gen0(DUP_INST);
					gen1(SET_CONTEXT_VAR_INST,no);
				} else if((no=instance_var_find(name))!=-1) {
					gen0(DUP_INST);
					gen1(SET_INSTANCE_VAR_INST,no);
				} else {
					o=global_find(name);
					if(!global_var_p(o)) {
						lex_error("%s is not var",name);
					}
					gen_push_literal(o);
					gen_send(FALSE,1,symbol_new("setTo:"));
				}
			}
		} else if(next_token==',') {
			parse_skip();
			if(!(next_token==tKEYWORD_SELECTOR||next_token==tBINARY_SELECTOR
				||next_token==tIDENTIFIER)) {
				lex_error("missing selector");
			}
			while(TRUE) {
				if(next_token==tKEYWORD_SELECTOR) parse_keyword_message(FALSE);
				else if(next_token==tBINARY_SELECTOR) {
					parse_binary_message(FALSE);
				} else if(next_token==tIDENTIFIER) parse_unary_message(FALSE);
				else break;
			}
		} else break;
	}
}

static int parse_statement(void)
{
	parse_expression();
	while(next_token==';') {
		parse_skip();
		gen0(DROP_INST);
		parse_expression();
	}

	if(next_token=='!') {
		parse_skip();
		return TRUE;
	} else if(next_token==tSPECIAL) {
		if(strcmp(parse_token_str(tSPECIAL),"again")==0) {
			gen0(DROP_INST);
			gen1(BRANCH_BACKWARD_INST,bytecode.size+2);
			return TRUE;
		} else lex_error("require $again");
	}
	return FALSE;
}

/* dump method */

static char *inst_table[]={
	NULL,
	"send",
	"send-super",
	"block"
};

static char *basic_inst_table[]={
	"push-instance-var",
	"push-context-var",
	"push-temp-var",
	"push-literal",
	"set-instance-var",
	"set-context-var",
	"set-temp-var",
	"branch-backward",
	"drop",
	"end",
	"return"
};

static void method_dump(object method)
{
	char *p,*pstart,*pend,buf[MAX_STR_LEN];
	int b,hi,lo,prim;
	int i,bsize,lsize;

	log_f("=%p\n",method);
	prim=METHOD_PRIM(method);
	if(prim!=METHOD_MAX_PRIM) {
		log_f("prim_code=%d\n",METHOD_PRIM(method));
	}
	log_f("ext_temp_size=%d\n",METHOD_EXT_TEMP_SIZE(method));
	log_f("context_size=%d\n",METHOD_CONTEXT_SIZE(method));
	bsize=METHOD_BYTECODE_SIZE(method);
	if(bsize!=0) {
		log_f("***bytecodes\n");
		pstart=method->method.u.bytecode+METHOD_BYTECODE_START(method);
		pend=pstart+bsize;
		p=pstart;
		while(p<pend) {
			log_f("%d ",p-pstart);
			b=LC(p); p++;
			hi=b>>4; lo=b&0xf;
			if(hi==BASIC_INST) {
				log_f("%s",basic_inst_table[lo]);
				if(lo<=BRANCH_BACKWARD_INST) {
					log_f(" %d",LC(p)); p++;
				}
			} else {
				log_f("%s %d,%d",inst_table[hi],lo,LC(p)); p++;
			}
			log_ln();
		}
	}
	lsize=om_size(method)-SIZE_METHOD;
	if(lsize!=0) {
		log_f("***literals\n");
		for(i=0;i<lsize;i++) {
			log_f("%d %s\n",i,om_describe(buf,method->method.u.literal[i]));
		}
	}
}

static void method_add(object method)
{
	int pos,i;
	object ml,nml,m;
	char buf[MAX_STR_LEN];
	
	ml=belong_class->xclass.methods;
	if(ml==om_nil) ml=farray_new(4);
	for(pos=0;pos<ml->farray.size;pos++) {
		m=ml->farray.elt[pos];
		if(m->method.selector==method->method.selector) {
			lex_error("%s redefined",om_describe(buf,method));
		}
		if(ml->farray.elt[pos]==om_nil) break;
	}
	if(pos==ml->farray.size) {
		nml=farray_new(pos*2);
		for(i=0;i<pos;i++) nml->farray.elt[i]=ml->farray.elt[i];
		ml=nml;
	}
	ml->farray.elt[pos]=method;
	belong_class->xclass.methods=ml;
}

static void method_command(void)
{
	object selector,method;
	struct xbarray keyword;
	char buf[MAX_STR_LEN];
	int statement_exist_p,prim,i,narg,size;
	
	heap_init(&heap);
	xarray_init(&local_vars);
	xarray_init(&instance_vars);
	xarray_init(&literal);
	xbarray_init(&bytecode);

	parse_token('[');
	belong_class=parse_identifier_class();
	instance_vars_setup(belong_class);
	if(strcmp(parse_token_str(tBINARY_SELECTOR),">>")!=0) {
		lex_error("missing >>");
	}

	local_var_new("self");

	/* signature */
	if(next_token==tIDENTIFIER) selector=parse_token_symbol(tIDENTIFIER);
	else if(next_token==tBINARY_SELECTOR) {
		selector=parse_token_symbol(tBINARY_SELECTOR);
		local_var_new(parse_token_str(tIDENTIFIER));
	} else if(next_token==tKEYWORD_SELECTOR) {
		xbarray_init(&keyword);
		while(next_token==tKEYWORD_SELECTOR) {
			xbarray_adds(&keyword,parse_token_str(tKEYWORD_SELECTOR));
			local_var_new(parse_token_str(tIDENTIFIER));
		}
		xbarray_add(&keyword,'\0');
		selector=symbol_new(keyword.elt);
	} else {
		selector=NULL;
		lex_error("illegal selector");
	}

	narg=local_vars.size-1;
	
	if(dump_method_p) {
		log_f("**method %s >> ",om_describe(buf,belong_class));
		log_f("%s\n",om_describe(buf,selector));
	}

	statement_exist_p=TRUE;
	prim=METHOD_MAX_PRIM;
	
	if(next_token==tSPECIAL) {
		prim=parse_primitive();
		if(next_token==']') statement_exist_p=FALSE;
	}

	if(statement_exist_p) {
		for(i=0;i<local_vars.size;i++) {
			gen1(PUSH_TEMP_VAR_INST,i);
			gen1(SET_CONTEXT_VAR_INST,i);
		}
		if(!parse_statement()) {
			gen0(DROP_INST);
			gen1(PUSH_CONTEXT_VAR_INST,0);
		}
		gen0(RETURN_INST);
	}
						
	parse_token(']');
	
	size=SIZE_METHOD+literal.size;
	method=om_alloc(sizeof(struct gobject)+(size-1)*sizeof(object)
		+bytecode.size);
	om_set_size(method,size);
	om_init_array(method->gobject.elt,size);
	regist(method);
	method->gobject.xclass=om_Method;
	
	method->method.belong_class=belong_class;
	method->method.selector=selector;
	method->method.attr=sint(narg|(prim<<METHOD_PRIM_POS)
		|(local_vars.size<<METHOD_CONTEXT_SIZE_POS));
	method->method.bytecode_size=sint(bytecode.size);
	memcpy(method->method.u.literal,literal.elt,literal.size*sizeof(object));
	memcpy(method->method.u.bytecode+METHOD_BYTECODE_START(method),
		bytecode.elt,bytecode.size);

	heap_free(&heap);
	xarray_free(&local_vars);
	xarray_free(&instance_vars);
	xarray_free(&literal);
	xbarray_free(&bytecode);

	if(dump_method_p) method_dump(method);
	
	method_add(method);
}

/**/

static void parse_command(void)
{
	char *cn;

	cn=parse_token_str(tIDENTIFIER);
	if(strcmp(cn,"class")==0) class_command();
	else if(strcmp(cn,"singleton")==0) singleton_command();
	else if(strcmp(cn,"feature")==0) feature_command();
	else if(strcmp(cn,"regist_builtin")==0) regist_builtin_command();
	else if(strcmp(cn,"method")==0) method_command();
	else lex_error("illegal command %s",cn);
}

static void load(char *fn)
{
	FILE *fp;

	log_f("*load %s\n",fn);
	if((fp=fopen(fn,"r"))==NULL) xerror("open %s failed.",fn);
	lex_start(fp);
	parse_skip();
	while(next_token!=EOF) parse_command();
	fclose(fp);
}

/**/

static struct xarray table;

static void global_sweep(int depth,void *key,void *data)
{
	xarray_add(&table,key);
	xarray_add(&table,data);
}

static void symbol_sweep(int depth,void *key,void *data)
{
	xarray_add(&table,data);
}

static object make_boot_args(int argc,char *argv[])
{
	object boot_args,main_args;
	int i;

	boot_args=farray_new(3);

	xarray_init(&table);
	splay_foreach(&global_splay,global_sweep);
	boot_args->farray.elt[0]=farray_new_xarray(&table);

	xarray_reset(&table);
	splay_foreach(&symbol_splay,symbol_sweep);
	boot_args->farray.elt[1]=farray_new_xarray(&table);
	xarray_free(&table);

	main_args=farray_new(argc);
	for(i=0;i<argc;i++) main_args->farray.elt[i]=string_new(argv[i]);
	boot_args->farray.elt[2]=main_args;
	
	return boot_args;
}

int main(int argc,char *argv[])
{
	int i;
	char buf[MAX_STR_LEN];
	object boot_args;

	setbuf(stdout,NULL);
	option(argc,argv);	

	om_init();
	splay_init(&symbol_splay,(int(*)(void*,void*))strcmp);
	splay_init(&global_splay,(int(*)(void*,void*))symbol_cmp);

	make_initial_objects();

	load(base_fn);

	if(execute_p) {
		/* arg is in old space -- make before gc_init */
		boot_args=make_boot_args(argc-xoptind,&argv[xoptind]);
		gc_init();
		
		ip_start(boot_args,DEFAULT_FRAME_STACK_SIZE*K,
			DEFAULT_CONTEXT_STACK_SIZE*K);

		gc_full();
	}

	if(dump_object_table_p) {
		log_f("*object table\n");
		for(i=0;i<om_table.size;i++) {
			log_f("%d:%s\n",i,om_describe(buf,om_table.elt[i]));
		}
	}

	log_f("om_used_memory=%d om_max_used_memory=%d\n",om_used_memory,
		om_max_used_memory);
	return 0;
}
