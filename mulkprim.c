/*
	primitive table for mulk.
	$Id: mulk mulkprim.c 1299 2024-11-10 Sun 15:32:06 kt $
*/

#include "std.h"
#include "om.h"

#define DEFPRIM(name) extern int prim_##name(object self,object *args,\
	object *result);
#define DEFPROPERTY(name)
#include "mulkprim.wk"
#undef DEFPRIM

int (*prim_table[])(object self,object *args,object *result)={
#define DEFPRIM(name) prim_##name,
#include "mulkprim.wk"
#undef DEFPRIM
	NULL
};
#undef DEFPROPERTY

#define DEFPRIM(name)
#define DEFPROPERTY(name) extern int property_##name(int key,object value,\
	object *result);
#include "mulkprim.wk"
#undef DEFPROPERTY

int (*property_table[])(int key,object value,object *result)={
#define DEFPROPERTY(name) property_##name,
#include "mulkprim.wk"
#undef DEFPROPERTY
	NULL
};
