/*
	xc getopt.
	$Id: mulk xgetopt.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include "xgetopt.h"

int xoptind=0;
char *xoptarg;
static char *cur=NULL;

int xgetopt(int argc,char **argv,char *opt)
{
	char *p;
	if(cur==NULL||*cur=='\0') {
		xoptind++;
		if(xoptind==argc) return EOF;
		cur=argv[xoptind];
		if(*cur!='-') return EOF;
		cur++;
		if(*cur=='\0') return EOF;
	}

	if(*cur=='-') {
		xoptind++;
		return EOF;
	}

	for(p=opt;*p!=*cur;p++) {
		if(*p=='\0') {
			fprintf(stderr,"illegal option -- %c.\n",*cur);
			return '?';
		}
	}
	
	cur++;

	if(*(p+1)!=':');
	else if(*cur=='\0') {
		xoptind++;
		if(xoptind==argc) {
			fprintf(stderr,"option requires an argument -- %c.\n",*p);
			return '?';
		}
		xoptarg=argv[xoptind];
	} else {
		xoptarg=cur;
		cur=NULL;
	}
	return *p;
}
