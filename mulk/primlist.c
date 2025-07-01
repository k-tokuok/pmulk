/*
	primlist.
	$Id: mulk primlist.c 1433 2025-06-03 Tue 21:15:38 kt $
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
			if(strlen(s)>5&&strncmp(s,"DEFPR",5)==0) printf("%s\n",s);
		}
		fclose(fp);
	}
	return 0;
}
