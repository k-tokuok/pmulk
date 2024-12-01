/*
	object memory.
	$Id: mulk om.h 1299 2024-11-10 Sun 15:32:06 kt $
*/

typedef union om *object;

union om {
#define HEADER int header
	HEADER;
#define HEADER_HASH_MASK 0x000fffff
#define HEADER_SIZE_MASK 0x0ff00000
#define HEADER_SIZE_POS 20
#define HEADER_SIZE(o) ((o->header&HEADER_SIZE_MASK)>>HEADER_SIZE_POS)
#define HEADER_GENERATION_MASK 0x30000000
#define HEADER_GENERATION_POS 28
#define HEADER_ALIVE_BIT 0x40000000
#define HEADER_REFNEW_BIT 0x80000000

#define SIZE_SINT 255 /* not om */

#define SIZE_FBARRAY 254
#define SIZE_STRING 253
#define SIZE_SYMBOL 252
	struct fbarray {
		HEADER;
		int size;
		char elt[1];
	} fbarray;

#define SIZE_FARRAY 251
	struct farray {
		HEADER;
		int size;
		object elt[1];
	} farray;

#define SIZE_LPINT 250
	struct lpint {
		HEADER;
#if U64_P
		u64_t val;
#else
		uint64_t val;
#endif
	} lpint;
	
#define SIZE_FLOAT 249
	struct xfloat {
		HEADER;
		double val;
	} xfloat;

#define SIZE_METHOD_IR 248
#define SIZE_LAST 248 /* see base.m Class >> special? */

	struct gobject { /* general object */
#define OHEADER \
		HEADER; \
		object xclass
		OHEADER;
		object elt[1];
	} gobject;

#define SIZE_CLASS 6
	struct xclass {
		OHEADER;
		object name;
		object size;
		object superclass;
		object features;
		object instance_vars;
		object methods;
	} xclass;

#define SIZE_METHOD 4
	struct method {
		OHEADER;
		object belong_class;
		object selector;
#define METHOD_MAX_ARG 15
#define METHOD_ARGC_MASK 0xf
#define METHOD_ARGC(m) (sint_val(m->method.attr)&METHOD_ARGC_MASK)
#define METHOD_EXT_TEMP_SIZE_MASK 0xff0
#define METHOD_EXT_TEMP_SIZE_POS 4
#define METHOD_EXT_TEMP_SIZE(m) \
((sint_val(m->method.attr)&METHOD_EXT_TEMP_SIZE_MASK)>>METHOD_EXT_TEMP_SIZE_POS)
#define METHOD_CONTEXT_SIZE_MASK 0xff000
#define METHOD_CONTEXT_SIZE_POS 12
#define METHOD_CONTEXT_SIZE(m) \
((sint_val(m->method.attr)&METHOD_CONTEXT_SIZE_MASK)>>METHOD_CONTEXT_SIZE_POS)
#define METHOD_MAX_PRIM 0x3ff
#define METHOD_PRIM_POS 20
#define METHOD_PRIM_MASK (METHOD_MAX_PRIM<<METHOD_PRIM_POS)
#define METHOD_PRIM(m) \
((sint_val(m->method.attr)&METHOD_PRIM_MASK)>>METHOD_PRIM_POS)
#define METHOD_BYTECODE_START(m) ((HEADER_SIZE(m)-SIZE_METHOD)*sizeof(object))
		object attr;
#define METHOD_BYTECODE_SIZE(m) sint_val(m->method.bytecode_size)
		object bytecode_size;
		union {
			object literal[1];
			char bytecode[1];
		} u;
	} method;

	/* executing */
	struct process {
		OHEADER;
		object context;
		object method;
		object ip;

		object stack;
		object sp;
		object sp_used;
		object sp_max;
		object fp;
		
		object exception_handlers;
		object interrupt_block;
	} process;
	
#define SIZE_CONTEXT 2
	struct context {
		OHEADER;
		object method;
		object sp;
		object vars[1];
	} context;

	struct block {
		OHEADER;
		object context;
		object narg;
		object start;
	} block;

	struct xchar {
		OHEADER;
		object code;
/*attr:
	0x000001 -- isprint
	0x000002 -- isspace
	0x000004 -- isdigit
	0x000008 -- islower
	0x000010 -- isupper
	0x000020 -- mblead_p
	0x000040 -- mbtrail_p
	0x00ff00 -- trailSize
*/		
		object attr;
	} xchar;
	
	object next;
};

#include "xarray.h"

#if MACRO_OM_P_P
#define om_p(o) ((((intptr_t)o)&1)==0)
#else
extern int om_p(object o);
#endif

#define SINT_ABSBITS 30
#define SINT_MAX 0x3fffffff
#define SINT_MIN (-SINT_MAX-1)

#define LPINT_BITS 64

#if MACRO_SINT_P_P
#define sint_p(o) ((((intptr_t)o)&1)==1)
#else
extern int sint_p(object o);
#endif

#if MACRO_SINT_VAL_P
#define sint_val(o) ((int)(((intptr_t)o)>>1))
#else
extern int sint_val(object o);
#endif

extern int sint_range_p(int i);

#if MACRO_SINT_P
#define sint(i) ((object)((((uintptr_t)(i))<<1)|1))
#else
extern object sint(int i);
#endif

extern int om_hash(object o);
extern void om_set_hash(object o,int val);
extern void om_init_hash(object o);
extern int om_bytes_hash(char *p,int size,int case_insensitive_p);
extern void om_set_string_hash(object o);
extern int om_number_hash(double d);

#if MACRO_OM_SIZE_P
#define om_size(x) (sint_p(x)?SIZE_SINT:HEADER_SIZE(x))
#else
extern int om_size(object o);
#endif

extern void om_set_size(object o,int size);

extern object om_alloc(int size);
extern void om_free(object o);
extern int om_used_memory;
extern int om_max_used_memory;

extern struct xarray om_table;
extern int om_max_object_count;

extern object om_nil;
extern object om_true;
extern object om_false;

extern object om_Class;
extern object om_ShortInteger;
extern object om_LongPositiveInteger;
extern object om_Float;
extern object om_FixedByteArray;
extern object om_String;
extern object om_Symbol;
extern object om_FixedArray;
extern object om_Method;
extern object om_Process;
extern object om_Context;
extern object om_Block;
extern object om_Char;

extern object om_Mulk;
extern object om_boot;
extern object om_doesNotUnderstand;
extern object om_primitiveFailed;
extern object om_error;
extern object om_trap_sp;
extern object om_equal;
extern object om_plus;
extern object om_lt;
extern object om_inc;
extern object om_at;
extern object om_value;
extern object om_at_put;
extern object om_byteAt;
extern object om_breaksp;

/* utility */
extern void om_init_array(object *table,int size);
extern object om_class(object o);
extern object om_boolean(int b);

extern void om_init(void);
extern void om_finish(void);

