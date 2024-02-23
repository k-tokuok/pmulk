/*
	addxc -- archive updater for djgpp.
	$Id: mulk addxc.c 406 2020-04-19 Sun 11:29:54 kt $
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
