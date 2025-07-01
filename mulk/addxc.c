/*
	addxc -- archive updater for djgpp.
	$Id: mulk addxc.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include <string.h>
#include <stdlib.h>

int main(int argc,char *argv[])
{
	int i;
	char buf[MAX_STR_LEN];

	for(i=1;i<argc;i++) {
		sprintf(buf,"ar -ru xc.a %s",argv[i]);
		printf("%s\n",buf);
		system(buf);
	}
	return 0;
}
