/*
	primlist.
	$Id: mulk primlist.c 406 2020-04-19 Sun 11:29:54 kt $
*/

#include "std.h"
#include <string.h>
#include "xbarray.h"

int main(int argc,char *argv[])
{
	int i;
	FILE *fp;
	struct xbarray buf;
	char *s;

	xbarray_init(&buf);
	for(i=1;i<argc;i++) {
		if((fp=fopen(argv[i],"r"))==NULL) xerror("open %s failed.",argv[i]);
		while((s=xbarray_fgets(&buf,fp))!=NULL) {
			if(strlen(s)>7&&strncmp(s,"DEFPRIM",7)==0) printf("%s\n",s);
		}
		fclose(fp);
	}
	return 0;
}
