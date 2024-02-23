/*
	primitive table for mulk.
	$Id: mulk mulkprim.c 406 2020-04-19 Sun 11:29:54 kt $
*/

#include "std.h"
#include "om.h"

#define DEFPRIM(name) extern int prim_##name(object self,object *args,\
	object *result);
#include "mulkprim.wk"
#undef DEFPRIM

int (*prim_table[])(object self,object *args,object *result)={
#define DEFPRIM(name) prim_##name,
#include "mulkprim.wk"
#undef DEFPRIM
	NULL
};

