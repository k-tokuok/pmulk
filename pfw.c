/*
	path and files for windows/WIDECHAR API.
	$Id: mulk pfw.c 1327 2024-12-08 Sun 11:38:07 kt $
*/

#include "std.h"
#include "pf.h"
#include "mem.h"
#include "om.h"
#include "ip.h" /* codepage */

#include <windows.h>

#define WCSIZE sizeof(wchar_t)

static WCHAR *to_mfn(char *pfn,struct xbarray *xba)
{
	struct xbarray wk;
	int len;

	xbarray_init(&wk);
	xbarray_adds(&wk,pfn);
	if(pfn[0]=='/') {
		wk.elt[0]=pfn[1];
		wk.elt[1]=':';
		if(pfn[2]=='\0') xbarray_add(&wk,'/');
	}
	xbarray_add(&wk,'\0');
	
	len=MultiByteToWideChar(codepage,0,wk.elt,-1,NULL,0);
	if(len==0) xerror("MultiByteToWideChar failed");
	xbarray_init(xba);
	xbarray_reserve(xba,len*WCSIZE);
	MultiByteToWideChar(codepage,0,wk.elt,-1,(wchar_t*)xba->elt,len);
	xbarray_free(&wk);
	return (WCHAR*)xba->elt;
}

static char *to_mbytes(WCHAR *wstr,struct xbarray *xba)
{
	int len;
	len=WideCharToMultiByte(codepage,0,wstr,-1,NULL,0,NULL,NULL);
	xbarray_reset(xba);
	xbarray_reserve(xba,len);
	WideCharToMultiByte(codepage,0,wstr,-1,xba->elt,len,NULL,NULL);
	return xba->elt;
}

static char *to_pfn(WCHAR *mfn,struct xbarray *xba)
{
	struct xbarray wk;
	char *p;
	int ch;
	
	xbarray_init(&wk);
	to_mbytes(mfn,&wk);
	if(wk.elt[1]!=':') xerror("to_pfn missing drive name");
	
	xbarray_init(xba);
	xbarray_add(xba,'/');
	xbarray_add(xba,wk.elt[0]);
	if(wk.elt[3]!='\0') {
		p=wk.elt+2;
		while((ch=LC(p++))!='\0') {
			if(ch=='\\') ch='/';
			xbarray_add(xba,ch);
			if(codepage!=CP_UTF8) {
				/* may be double byte char */
				if(IsDBCSLeadByte(ch)) xbarray_add(xba,LC(p++));
			}
		}
		xbarray_add(xba,'\0');
	}
	xbarray_free(&wk);
	return xba->elt;
}
	
FILE *pf_open(char *pfn,char *mode)
{
	struct xbarray xba;
	FILE *fp;
	wchar_t wmode[10];
	int i,ch;
	
	for(i=0;(ch=LC(mode+i))!='\0';i++) wmode[i]=ch;
	wmode[i]='\0';
	
	fp=_wfopen(to_mfn(pfn,&xba),wmode);
	xbarray_free(&xba);
	return fp;
}

static int xstat(WCHAR *fn,struct pf_stat *statbuf) 
{
	int en,result;
	WIN32_FILE_ATTRIBUTE_DATA attr;
	
	if(!GetFileAttributesExW(fn,GetFileExInfoStandard,&attr)) {
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

int pf_stat(char *pfn,struct pf_stat *statbuf)
{
	struct xbarray xba;
	int result;
	
	result=xstat(to_mfn(pfn,&xba),statbuf);
	xbarray_free(&xba);
	return result;
}

static int check(WCHAR *fn,int mode)
{
	return (xstat(fn,NULL)&mode)==mode;
}

void pf_exepath(char *argv0,struct xbarray *path)
{
	wchar_t mfn[MAX_STR_LEN];
	int st;
	st=GetModuleFileNameW(NULL,mfn,MAX_STR_LEN);
	if(st>=MAX_STR_LEN) st=0;
	if(st==0) xerror("GetModuleFileName failed.");
	to_pfn(mfn,path);
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
	hFile=CreateFileW(to_mfn(pfn,&xba),GENERIC_WRITE,0,NULL,OPEN_EXISTING,
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
	len=GetCurrentDirectoryW(0,NULL);
	xbarray_init(&mba);
	GetCurrentDirectoryW(len+1,(wchar_t*)xbarray_reserve(&mba,(len+1)*WCSIZE));
	result=xstrdup(to_pfn((wchar_t*)mba.elt,&pba));
	xbarray_free(&mba);
	xbarray_free(&pba);
	return result;
}

int pf_readdir(char *pfn,struct xbarray *dirs)
{
	struct xbarray xba;
	char *fn;
	WIN32_FIND_DATAW data;
	HANDLE h;
	DWORD err;
	int result;
	
	to_mfn(pfn,&xba);
	xba.size-=WCSIZE;
	*(wchar_t*)(xbarray_reserve(&xba,WCSIZE))='\\';
	*(wchar_t*)(xbarray_reserve(&xba,WCSIZE))='*';
	*(wchar_t*)(xbarray_reserve(&xba,WCSIZE))='\0';

	if((h=FindFirstFileW((wchar_t*)xba.elt,&data))==INVALID_HANDLE_VALUE) {
		xbarray_free(&xba);
		return FALSE;
	}

	result=TRUE;
	while(TRUE) {
		fn=to_mbytes(data.cFileName,&xba);
		if(!(strcmp(fn,".")==0||strcmp(fn,"..")==0)) {
			xbarray_adds(dirs,fn);
			xbarray_add(dirs,'\n');
		}
		if(FindNextFileW(h,&data)==0) {
			err=GetLastError();
			if(err!=ERROR_NO_MORE_FILES) result=FALSE;
			break;
		}
	}
	xbarray_free(&xba);
	FindClose(h);
	return result;
}

int pf_mkdir(char *pfn)
{
	struct xbarray xba;
	int st;
	st=CreateDirectoryW(to_mfn(pfn,&xba),NULL);
	xbarray_free(&xba);
	return st;
}

int pf_remove(char *pfn)
{
	struct xbarray xba;
	wchar_t *mfn;
	int st;
	mfn=to_mfn(pfn,&xba);
	if(check(mfn,PF_DIR)) st=RemoveDirectoryW(mfn);
	else st=DeleteFileW(mfn);
	xbarray_free(&xba);
	return st;
}

int pf_chdir(char *pfn)
{
	struct xbarray xba;
	int st;
	st=SetCurrentDirectoryW(to_mfn(pfn,&xba));
	xbarray_free(&xba);
	return st;
}
