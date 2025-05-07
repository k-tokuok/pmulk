/*
	windows dependent part.
	$Id: mulk osw.c 1413 2025-04-26 Sat 18:55:59 kt $
*/
#include "std.h"
#include <windows.h>

#include "om.h"
#include "os.h"
#include "ip.h"

static BOOL intr_handler(DWORD dwCtrlType)
{
	if(dwCtrlType==CTRL_C_EVENT) {
		ip_trap_code=TRAP_INTERRUPT;
		return TRUE;
	}
	return FALSE;
}

void os_intr_init(void)
{
	if(SetConsoleCtrlHandler((PHANDLER_ROUTINE)intr_handler,TRUE)==0) {
		xerror("SetConsoleCtrlHandler failed.");
	}
}

double os_floattime(void)
{
	SYSTEMTIME st;
	FILETIME ft;
	GetSystemTime(&st);
	SystemTimeToFileTime(&st,&ft);
	return (((uint64_t)ft.dwHighDateTime<<32)|ft.dwLowDateTime)/1.0e7
		-11644473600;
}

void os_sleep(double t)
{
	Sleep((int)(t*1000));
}

