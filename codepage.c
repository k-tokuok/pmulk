/*
	variable codepage for windows.
	$Id: mulk codepage.c 1191 2024-03-30 Sat 22:35:26 kt $
*/

#include "std.h"
#include <windows.h>
#include "codepage.h"
#include "om.h"
#include "prim.h"

int codepage=CP_UTF8;

DEFPRIM(codepage)
{
	GET_SINT_ARG(0,codepage);
	return PRIM_SUCCESS;
}
