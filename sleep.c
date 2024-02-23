/*
	sleep.
	$Id: mulk sleep.c 623 2020-12-30 Wed 21:59:53 kt $
*/
#include "std.h"
#include "xsleep.h"
#include "om.h"
#include "prim.h"

DEFPRIM(sleep)
{
	xsleep(self->xfloat.val);
	return PRIM_SUCCESS;
}
