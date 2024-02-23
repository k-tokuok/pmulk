/*
	sleep in seconds for unix.
	$Id: mulk xsleepu.c 659 2021-02-04 Thu 22:46:34 kt $
*/
#include "std.h"

#include <time.h>

#include "xsleep.h"

#if INTR_CHECK_P
#include "intr.h"
#include "om.h"
#include "ip.h"
#endif

static void xsleep1(double t)
{
	struct timespec ts,rem;
	ts.tv_sec=t;
	ts.tv_nsec=(t-ts.tv_sec)*1000000000;
	nanosleep(&ts,&rem);
}

void xsleep(double t)
{
#if INTR_CHECK_P
#define POLLING 0.1
	while(t>POLLING) {
		intr_check();
		if(ip_trap_code!=TRAP_NONE) return;
		xsleep1(POLLING);
		t-=POLLING;
	}
	xsleep1(t);
#else
	xsleep1(t);
#endif
}
