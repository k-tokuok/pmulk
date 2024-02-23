/*
	path and files for windows.
	$Id: mulk pfw.c 1132 2023-11-11 Sat 16:46:01 kt $
*/

#include "std.h"
#include "pf.h"
#include "mem.h"

#include <windows.h>

static char *to_mfn(char *pfn,struct xbarray *xba)
{
	xbarray_init(xba);
	xbarray_adds(xba,pfn);
	if(pfn[0]=='/') {
		xba->elt[0]=pfn[1];
		xba->elt[1]=':';
		if(pfn[2]=='\0') xbarray_add(xba,'/');
	}
	xbarray_add(xba,'\0');
	return xba->elt;
}

static char *to_pfn(char *mfn,struct xbarray *xba)
{
	char *p;
	int ch;
	if(mfn[1]!=':') xerror("to_pfn missing drive name.");
	xbarray_init(xba);
	xbarray_add(xba,'/');
	xbarray_add(xba,mfn[0]);
	if(mfn[3]!='\0') {
		p=mfn+2;
		while((ch=LC(p++))!='\0') {
			if(ch=='\\') ch='/';
			xbarray_add(xba,ch);
			if(IsDBCSLeadByte(ch)) xbarray_add(xba,LC(p++));
		}
	}
	xbarray_add(xba,'\0');
	return xba->elt;
}
	
FILE *pf_open(char *pfn,char *mode)
{
	struct xbarray xba;
	FILE *fp;
	fp=fopen(to_mfn(pfn,&xba),mode);
	xbarray_free(&xba);
	return fp;
}

int pf_stat(char *pfn,struct pf_stat *statbuf)
{
	struct xbarray xba;
	WIN32_FILE_ATTRIBUTE_DATA attr;
	int en,st,result;
	
	st=GetFileAttributesEx(to_mfn(pfn,&xba),GetFileExInfoStandard,&attr);
	xbarray_free(&xba);
	if(!st) {
		en=GetLastError();
		if(en==ERROR_FILE_NOT_FOUND||en==ERROR_PATH_NOT_FOUND
			||en==ERROR_INVALID_NAME) return PF_NONE;
		else return PF_ERROR;
	}
	result=PF_READABLE;
	if(attr.dwFileAttributes&FILE_ATTRIBUTE_DIRECTORY) result|=PF_DIR;
	else result|=PF_FILE;
	if((attr.dwFileAttributes&FILE_ATTRIBUTE_READONLY)==0) result|=PF_WRITABLE;
	if(statbuf!=NULL) {
		statbuf->size=((uint64_t)attr.nFileSizeHigh<<32)|attr.nFileSizeLow;
		statbuf->mtime=(((uint64_t)attr.ftLastWriteTime.dwHighDateTime<<32)
			|attr.ftLastWriteTime.dwLowDateTime)/10000000-11644473600;
	}
	return result;
}

static int check(char *fn,int mode)
{
	return (pf_stat(fn,NULL)&mode)==mode;
}

void pf_exepath(char *argv0,struct xbarray *path)
{
#if PGMPTR_P
	to_pfn(_pgmptr,path);
#else
	char mfn[MAX_STR_LEN];
	int st;
	st=GetModuleFileName(NULL,mfn,MAX_STR_LEN);
	if(st>=MAX_STR_LEN) st=0;
	if(st==0) xerror("GetModuleFileName failed.");
	to_pfn(mfn,path);
#endif
}

#ifdef __DMC__
static int64_t mki64(int hi,int lo)
{
	union {
		struct {
			int lo,hi;
		} i32;
		int64_t i64;
	} u;
	u.i32.hi=hi;
	u.i32.lo=lo;
	return u.i64;
}
#endif

int pf_utime(char *pfn,uint64_t mtime)
{
	HANDLE hFile;
	FILETIME ft;
	struct xbarray xba;
	
#ifdef __DMC__
	mtime=mtime*mki64(0,0x989680)+mki64(0x19db1de,0xd53e8000);
#else
	mtime=mtime*10000000+116444736000000000;
#endif
	ft.dwLowDateTime=mtime&0xffffffff;
	ft.dwHighDateTime=mtime>>32;
	hFile=CreateFile(to_mfn(pfn,&xba),GENERIC_WRITE,0,NULL,OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,NULL);
	xbarray_free(&xba);
	if(hFile==INVALID_HANDLE_VALUE) return FALSE;
	if(!SetFileTime(hFile,NULL,NULL,&ft)) return FALSE;
	CloseHandle(hFile);
	return TRUE;
}

char *pf_getcwd(void)
{
	int len;
	struct xbarray mba,pba;
	char *result;
	len=GetCurrentDirectory(0,NULL);
	xbarray_init(&mba);
	GetCurrentDirectory(len+1,xbarray_reserve(&mba,len+1));
	to_pfn(mba.elt,&pba);
	result=xstrdup(to_pfn(mba.elt,&pba));
	xbarray_free(&mba);
	xbarray_free(&pba);
	return result;
}

int pf_readdir(char *pfn,struct xbarray *dirs)
{
	struct xbarray xba;
	char *fn;
	WIN32_FIND_DATA data;
	HANDLE h;
	DWORD err;

	to_mfn(pfn,&xba);
	xba.size--;
	xbarray_adds(&xba,"\\*");
	xbarray_add(&xba,'\0');
	if((h=FindFirstFile(xba.elt,&data))==INVALID_HANDLE_VALUE) return FALSE;
	xbarray_free(&xba);
	
	while(TRUE) {
		fn=data.cFileName;
		if(!(strcmp(fn,".")==0||strcmp(fn,"..")==0)) {
			xbarray_adds(dirs,fn);
			xbarray_add(dirs,'\n');
		}
		if(FindNextFile(h,&data)==0) {
			err=GetLastError();
			if(err==ERROR_NO_MORE_FILES) break;
			else {
				FindClose(h);
				return FALSE;
			}
		}
	}
	FindClose(h);
	return TRUE;
}

int pf_mkdir(char *pfn)
{
	struct xbarray xba;
	int st;
	st=CreateDirectory(to_mfn(pfn,&xba),NULL);
	xbarray_free(&xba);
	return st;
}

int pf_remove(char *pfn)
{
	struct xbarray xba;
	char *mfn;
	int st;
	mfn=to_mfn(pfn,&xba);
	if(check(pfn,PF_DIR)) st=RemoveDirectory(mfn);
	else st=DeleteFile(mfn);
	xbarray_free(&xba);
	return st;
}

int pf_chdir(char *pfn)
{
	struct xbarray xba;
	int st;
	st=SetCurrentDirectory(to_mfn(pfn,&xba));
	xbarray_free(&xba);
	return st;
}
