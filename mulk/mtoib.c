/*
	mtoib -- .m to .ib form.
	$Id: mulk mtoib.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include <string.h>
#include "xbarray.h"

static struct xbarray str;
static FILE *dfp;

static char *next;
static int ol_level;

static void fetch(void)
{
	char *p;
	next=xbarray_fgets(&str,stdin);
	if(next==NULL) ol_level=-1;
	else {
		for(p=next;*p=='*';p++);
		ol_level=(int)(p-next);
	}	
}

static void write_block(FILE *fp)
{
	fetch();
	while(ol_level==0) {
		fprintf(fp,"%s\n",next);
		fetch();
	}
}

static void skip_block(void)
{
	fetch();
	while(ol_level==0) fetch();
}

static int try_def(void)
{
	if(next[strlen(next)-1]!='#') return FALSE;
	write_block(dfp);
	return TRUE;
}

static int try_method(void)
{
	char *p;

	p=strchr(next,' ');
	if(p==NULL) return FALSE;
	if(strncmp(p," >> ",4)!=0) return FALSE;

	printf("method [\n");
	printf("%s\n",next+ol_level);
	write_block(stdout);
	printf("]\n");
	return TRUE;	
}

static int try_annex(void)
{
	int level;
	if(next[ol_level]!='[') return FALSE;
	level=ol_level;
	fetch();
	while(ol_level==0||ol_level>level) fetch();
	return TRUE;
}

int main(int argc,char *argv[])
{
	if(argc!=2) xerror("missing deffile.");
	if((dfp=fopen(argv[1],"w"))==NULL) xerror("open %s failed.",argv[1]);

	printf("regist_builtin;\n");

	skip_block();

	while(ol_level!=-1) {
		if(try_def());
		else if(try_method());
		else if(try_annex());
		else skip_block();
	}
	return 0;
}
