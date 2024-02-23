/*
	interrupt for unix.
	$Id: mulk intru.c 636 2021-01-09 Sat 22:11:47 kt $
*/
#include "std.h"
#include <string.h>
#include <signal.h>

#include "intr.h"
#include "om.h"
#include "ip.h"

static void intr_handler(int signo)
{
	ip_trap_code=TRAP_INTERRUPT;
}

void intr_init(void)
{
	struct sigaction sa;
	memset(&sa,0,sizeof(sa));
	sa.sa_handler=intr_handler;
	if(sigaction(SIGINT,&sa,NULL)==-1) xerror("sigaction failed.");
}
