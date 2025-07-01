/*
	unix dependent part.
	$Id: mulk osu.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include <string.h>
#include <signal.h>
#include <time.h>

#include "om.h"
#include "os.h"
#include "ip.h"

static void intr_handler(int signo)
{
	ip_trap_code=TRAP_INTERRUPT;
}

void os_intr_init(void)
{
	struct sigaction sa;
	memset(&sa,0,sizeof(sa));
	sa.sa_handler=intr_handler;
	if(sigaction(SIGINT,&sa,NULL)==-1) xerror("sigaction failed.");
}

double os_floattime(void)
{
	struct timespec ts;
	clock_gettime(CLOCK_REALTIME,&ts);
	return ts.tv_sec+(double)ts.tv_nsec*1.0e-9;
}

void os_sleep(double t)
{
	struct timespec ts,rem;
	ts.tv_sec=t;
	ts.tv_nsec=(t-ts.tv_sec)*1000000000;
	nanosleep(&ts,&rem);
}
