/*
	comma split.
	$Id: mulk csplit.c 1433 2025-06-03 Tue 21:15:38 kt $
*/
#include "std.h"
#include "csplit.h"

#include <string.h>

int csplit(char *p,char **cols,int ncol)
{
	int i;
	char *q;
	i=0;
	while(i<ncol) {
		if((q=strchr(p,','))==NULL) {
			cols[i++]=p;
			break;
		}
		*q='\0';
		cols[i++]=p;
		p=q+1;
	}
	return i;
}
