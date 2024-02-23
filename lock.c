/*
	lock.
	$Id: mulk lock.c 406 2020-04-19 Sun 11:29:54 kt $
*/

#include "std.h"

#if WINDOWS_P
#include <windows.h>
#include <io.h>
#endif

#if UNIX_P
#include <unistd.h>
#endif

#include "om.h"
#include "prim.h"

DEFPRIM(lock)
{
	int lock_p;
	FILE *fp;
	
	lock_p=args[0]==om_true;
	if(!p_uintptr_val(args[1],(uintptr_t*)&fp)) return PRIM_ERROR;

#if WINDOWS_P
	{
		HANDLE h;
		OVERLAPPED ov;
		int st;
		h=(HANDLE)_get_osfhandle(_fileno(fp));
		memset(&ov,0,sizeof(ov));
		if(lock_p) st=LockFileEx(h,LOCKFILE_EXCLUSIVE_LOCK,0,1,0,&ov);
		else st=UnlockFileEx(h,0,1,0,&ov);
		if(!st) return PRIM_ERROR;
	}
#endif

#if UNIX_P
	if(lockf(fileno(fp),lock_p?F_LOCK:F_ULOCK,1)==-1) return PRIM_ERROR;
#endif

	return PRIM_SUCCESS;
}
