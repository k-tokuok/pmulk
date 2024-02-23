/*
	sleep in seconds for windows.
	$Id: mulk xsleepw.c 837 2022-02-19 Sat 21:47:16 kt $
*/

#include "std.h"
#include "xsleep.h"
#include <windows.h>

#include "om.h"
#include "ip.h"

#if INTR_CHECK_P
#include "intr.h"
#endif

#define POLLING 100

void xsleep(double t)
{
	int it;
	it=(int)(t*1000);
	while(it>POLLING) {
#if INTR_CHECK_P
		intr_check();
#endif
		if(ip_trap_code!=TRAP_NONE) return;
		Sleep(POLLING);
		it-=POLLING;
	}
	Sleep(it);
}
