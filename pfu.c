/*
	path and files for unix.
	$Id: mulk pfu.c 1091 2023-07-16 Sun 07:11:27 kt $
*/

#include "std.h"
#include <stdlib.h>
#include <string.h>
#include <utime.h>
#include <dirent.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "pf.h"

static int group_member_p(gid_t gid)
{
	int i,size;
	gid_t *gids;
	
	size=getgroups(0,NULL);
	if(size==-1) xerror("getgroups failed.");
	gids=xmalloc(size*sizeof(gid_t));
	if(getgroups(size,gids)==-1) xerror("getgroups failed.");
	for(i=0;i<size;i++) {
		if(gid==gids[i]) break;
	}
	xfree(gids);
	return i!=size;
}

int pf_stat(char *fn,struct pf_stat *pf_statbuf)
{
	int result,type;
	int rbit,wbit;
	struct stat statbuf;

	if(stat(fn,&statbuf)!=0) {
		if(errno==ENOENT) return PF_NONE;
		else return PF_ERROR;
	}

	result=0;
	type=statbuf.st_mode&S_IFMT;
	if(type==S_IFREG) result=PF_FILE;
	else if(type==S_IFDIR) result=PF_DIR;
	else result=PF_OTHER;

	if(statbuf.st_uid==getuid()) {
		rbit=S_IRUSR;
		wbit=S_IWUSR;
	} else if(group_member_p(statbuf.st_gid)) {
		rbit=S_IRGRP;
		wbit=S_IWGRP;
	} else {
		rbit=S_IROTH;
		wbit=S_IWOTH;
	}

	if(statbuf.st_mode&rbit) result|=PF_READABLE;
	if(statbuf.st_mode&wbit) result|=PF_WRITABLE;

	if(pf_statbuf!=NULL) {
		pf_statbuf->mtime=statbuf.st_mtime;
		pf_statbuf->size=statbuf.st_size;
	}
	return result;	
}

static int check(char *fn,int mode)
{
	return (pf_stat(fn,NULL)&mode)==mode;
}

void pf_exepath(char *argv0,struct xbarray *path)
{
	char *paths,*p,*q;

	if(strchr(argv0,'/')!=NULL) {
		xbarray_reset(path);
		xbarray_adds(path,argv0);
		xbarray_add(path,'\0');
		return;
	}
	
	paths=getenv("PATH");
	p=paths;
	while((q=strchr(p,':'))!=NULL) {
		xbarray_reset(path);
		memcpy(xbarray_reserve(path,q-p),p,q-p);
		xbarray_add(path,'/');
		xbarray_adds(path,argv0);
		xbarray_add(path,'\0');
		if(check(path->elt,PF_READABLEFILE)) return;
		p=q+1;
	}
	xbarray_reset(path);
	xbarray_adds(path,p);
	xbarray_add(path,'/');
	xbarray_adds(path,argv0);
	xbarray_add(path,'\0');
	if(!check(path->elt,PF_READABLEFILE)) xerror("pf_exepath: not find");
	return;
}

int pf_utime(char *fn,uint64_t mtime)
{
	struct stat statbuf;
	struct utimbuf utimbuf;

	if(stat(fn,&statbuf)!=0) return FALSE;
	utimbuf.actime=statbuf.st_atime;
	utimbuf.modtime=mtime;

	if(utime(fn,&utimbuf)==-1) return FALSE;
	return TRUE;
}

char *pf_getcwd(void)
{
	return getcwd(NULL,0);
}

int pf_readdir(char *path,struct xbarray *dirs)
{
	char *fn;
	DIR *d;
	struct dirent *de;

	if((d=opendir(path))==NULL) return FALSE;
	while((de=readdir(d))!=NULL) {
		fn=de->d_name;
		if(strcmp(fn,".")==0||strcmp(fn,"..")==0) continue;
		xbarray_adds(dirs,fn);
		xbarray_add(dirs,'\n');
	}
	closedir(d);
	return TRUE;
}

int pf_mkdir(char *path)
{
	return mkdir(path,0777)==0;
}

int pf_remove(char *fn)
{
	return remove(fn)==0;
}

int pf_chdir(char *dir)
{
	return chdir(dir)==0;
}
