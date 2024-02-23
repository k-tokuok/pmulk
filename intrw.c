/*
	interrupt for windows.
	$Id: mulk intrw.c 636 2021-01-09 Sat 22:11:47 kt $
*/
#include "std.h"
#include <windows.h>

#include "intr.h"
#include "om.h"
#include "ip.h"

static BOOL intr_handler(DWORD dwCtrlType)
{
	if(dwCtrlType==CTRL_C_EVENT) {
		ip_trap_code=TRAP_INTERRUPT;
		return TRUE;
	}
	return FALSE;
}

void intr_init(void)
{
	if(SetConsoleCtrlHandler((PHANDLER_ROUTINE)intr_handler,TRUE)==0) {
		xerror("SetConsoleCtrlHandler failed.");
	}
}
