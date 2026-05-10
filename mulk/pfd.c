/*
	path and files for dos.
	$Id: mulk pfd.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include "pf.h"
#include "mem.h"

#include <string.h>
#include <ctype.h>
#include <direct.h>
#include <dos.h>
#include <utime.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

static char *xstrcpy(char *dst,char *src)
{
	if(strlen(src)>=MAX_STR_LEN) xerror("xstrcpy buffer overflow.");
	return strcpy(dst,src);
}

char *to_mfn(char *posix,char *ms)
{
	xstrcpy(ms,posix);
	if(posix[0]=='/') {
		ms[0]=posix[1];
		ms[1]=':';
		if(posix[2]=='\0') {
			ms[2]='/';
			ms[3]='\0';
		}
	}
	return ms;
}

char *to_pfn(char *ms,char *posix)
{
	char *p;
	int ch;
	if(ms[1]!=':') xerror("to_pfn missing drive name.");
	xstrcpy(posix,ms);
	posix[0]='/';
	posix[1]=ms[0];
	if(ms[3]=='\0') posix[2]='\0';
	for(p=posix+2;(ch=LC(p))!='\0';p++) {
		if(ch=='\\') *p='/';
	};
	return posix;
}

int pf_lock(FILE *fp,int lock_p)
{
	return TRUE;
}

FILE *pf_open(char *fn,char *mode)
{
	char msfn[MAX_STR_LEN];
	return fopen(to_mfn(fn,msfn),mode);
}

int pf_stat(char *fn,struct pf_stat *pf_statbuf)
{
	int result,type;
	struct stat statbuf;
	char msfn[MAX_STR_LEN];
	
	if(stat(to_mfn(fn,msfn),&statbuf)!=0) {
		if(errno==ENOENT) return PF_NONE;
		else return PF_ERROR;
	}

	result=0;
	type=statbuf.st_mode&S_IFMT;
	if(type==S_IFREG) result=PF_FILE;
	else if(type==S_IFDIR) result=PF_DIR;
	else result=PF_OTHER;

	if(statbuf.st_mode&S_IRUSR) result|=PF_READABLE;
	if(statbuf.st_mode&S_IWUSR) result|=PF_WRITABLE;

	if(pf_statbuf!=NULL) {
		pf_statbuf->mtime=statbuf.st_mtime;
		pf_statbuf->size=statbuf.st_size;
	}
	return result;	
}

void pf_exepath(char *argv0,struct xbarray *path)
{
	char pfn[MAX_STR_LEN];
	if(argv0[1]==':') {
		to_pfn(argv0,pfn);
		xbarray_adds(path,pfn);
	} else xbarray_adds(path,argv0);
	xbarray_add(path,'\0');
}

int pf_utime(char *fn,uint64_t mtime)
{
	struct stat statbuf;
	struct utimbuf utimbuf;
	char msfn[MAX_STR_LEN];

	to_mfn(fn,msfn);
	if(stat(msfn,&statbuf)!=0) return FALSE;
	utimbuf.actime=statbuf.st_atime;
	utimbuf.modtime=mtime;

	if(utime(msfn,&utimbuf)==-1) return FALSE;
	return TRUE;
}

char *pf_getcwd(void)
{
	char mfn[MAX_STR_LEN],pfn[MAX_STR_LEN];
	if(getcwd(mfn,MAX_STR_LEN)==NULL) xerror("getcwd failed.");
	return xstrdup(to_pfn(mfn,pfn));
}

int pf_readdir(char *path,struct xbarray *dirs)
{
	char *fn;
	struct find_t find;
	unsigned int rc;
	char buf[MAX_STR_LEN],msfn[MAX_STR_LEN],*p;
	int ch;

	xsprintf(buf,"%s\\*.*",to_mfn(path,msfn));
	for(p=buf;(ch=*p)!='\0';p++) {
		if(ch=='/') *p='\\';
	}
	rc=_dos_findfirst(buf,_A_NORMAL|_A_SUBDIR,&find);
	while(rc==0) {
		fn=find.name;
		if(!(strcmp(fn,".")==0||strcmp(fn,"..")==0)) {
			for(p=fn;(ch=*p)!=0;p++) xbarray_add(dirs,tolower(ch));
			xbarray_add(dirs,'\n');
		}
		rc=_dos_findnext(&find);
	}
	return TRUE;
}

int pf_mkdir(char *path)
{
	char msfn[MAX_STR_LEN];
	int st;
	to_mfn(path,msfn);
#ifdef __WATCOMC__
	st=mkdir(msfn);
#endif
#ifdef __DJGPP__
	st=mkdir(msfn,0777);
#endif
	return st==0;
}

int pf_remove(char *fn)
{
	char msfn[MAX_STR_LEN];
	to_mfn(fn,msfn);
#ifdef __WATCOMC__
	if(pf_stat(fn,NULL)&PF_DIR) return rmdir(msfn)==0;
#endif
	return remove(msfn)==0;
}

int pf_chdir(char *dir)
{
	unsigned int drive,total;
	char msfn[MAX_STR_LEN];
	
	to_mfn(dir,msfn);
	drive=tolower(dir[1])-'a'+1;
	_dos_setdrive(drive,&total);
	if(!(1<=drive&&drive<=total)) return FALSE;
	return chdir(msfn+2)==0;
}
