/*
	dynamic library.
	$Id: mulk dl.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

/* note: handle and symbol must be uintptr_t compatible */

#if UNIX_P
#include <dlfcn.h>
#define DLOPEN(n) ((uintptr_t)dlopen(n,RTLD_LAZY))
#define DLSYM(h,n) ((uintptr_t)dlsym((void*)h,n))
#endif

#if WINDOWS_P
#include <windows.h>
#define DLOPEN(n) ((uintptr_t)LoadLibrary(n))
#define DLSYM(h,n) ((uintptr_t)GetProcAddress((HMODULE)h,n))
#endif

#include "mem.h"
#include "om.h"
#include "prim.h"

DEFPRIM(dl_open)
{
	char *n;
	struct xbarray xba;
	uintptr_t h;

	if((n=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	h=DLOPEN(n);
	xbarray_free(&xba);
	if(h==0) return PRIM_ERROR;
	*result=p_uintptr(h);
	return PRIM_SUCCESS;
}

DEFPRIM(dl_sym)
{
	uintptr_t h,sym;
	struct xbarray xba;
	char *n;

	if(!p_uintptr_val(args[0],&h)) return PRIM_ERROR;
	if((n=p_string_val(args[1],&xba))==NULL) return PRIM_ERROR;
	sym=DLSYM(h,n);
	xbarray_free(&xba);
	if(sym==0) return PRIM_ERROR;	
	*result=p_uintptr(sym);
	return PRIM_SUCCESS;
}

#define MAX_ARGS 14

DEFPRIM(dl_call)
{
	uintptr_t func;
	int type,i,cargc,cret_p;
	object fargs; /* FixedArray */
	uintptr_t cargs[MAX_ARGS],cret;
	double cretd;

	if(!p_uintptr_val(args[0],&func)) return PRIM_ERROR;
	GET_SINT_ARG(1,type);
	fargs=args[2];

	cargc=type%100;
	cret_p=TRUE;
	cret=0;
	cretd=0;
	if(cargc==20) { /* double f(double) */
		cargc=0;
		cret_p=FALSE;
	} else if(cargc==21) { /* intptr f(uintptr,uintptr,double) */ 
		cargc=2;
	} else if(cargc==22) { /* double f(uintptr,uintptr) */
		cargc=2;
		cret_p=FALSE;
	}

	for(i=0;i<cargc;i++) {
		if(!p_uintptr_val(fargs->farray.elt[i],&cargs[i])) return PRIM_ERROR;
	}

#define A(i) (cargs[i])
#define U uintptr_t
	switch(type) {
	case 0: cret=(*((U (*)(void))func))(); break;
	case 1: cret=(*((U (*)(U))func))(A(0)); break;
	case 2: cret=(*((U (*)(U,U))func))(A(0),A(1)); break;
	case 3: cret=(*((U (*)(U,U,U))func))(A(0),A(1),A(2)); break;
	case 4: cret=(*((U (*)(U,U,U,U))func))(A(0),A(1),A(2),A(3)); break;
	case 5: 
		cret=(*((U (*)(U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4)); 
		break;
	case 6: 
		cret=(*((U (*)(U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5)); 
		break;
	case 7: 
		cret=(*((U (*)(U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6)); 
		break;
	case 8: 
		cret=(*((U (*)(U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7)); 
		break;
	case 9: 
		cret=(*((U (*)(U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8)); 
		break;
	case 10: 
		cret=(*((U (*)(U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9)); 
		break;
	case 11:
		cret=(*((U (*)(U,U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9),A(10));
		break;
	case 12:
		cret=(*((U (*)(U,U,U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9),A(10),A(11));
		break;
	case 13:
		cret=(*((U (*)(U,U,U,U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9),A(10),A(11),
			A(12));
		break;
	case 14:
		cret=(*((U (*)(U,U,U,U,U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9),A(10),A(11),
			A(12),A(13));
		break;
	case 20:
		{
			double farg;
			if(!p_float_val(fargs->farray.elt[0],&farg)) return PRIM_ERROR;
			cretd=(*((double (*)(double))func))(farg);
		}
		break;
	case 21:
		{
			double farg;
			if(!p_float_val(fargs->farray.elt[2],&farg)) return PRIM_ERROR;
			cret=(*((uintptr_t (*)(uintptr_t,uintptr_t,double))func))
				(A(0),A(1),farg);
		}
		break;
	case 22:
		{
			cretd=(*((double (*)(uintptr_t,uintptr_t))func))(A(0),A(1));
		}
		break;
#if WINDOWS_P
	case 100: cret=(*((U (__stdcall *)(void))func))(); break;
	case 101: cret=(*((U (__stdcall *)(U))func))(A(0)); break;
	case 102: cret=(*((U (__stdcall *)(U,U))func))(A(0),A(1)); break;
	case 103: cret=(*((U (__stdcall *)(U,U,U))func))(A(0),A(1),A(2)); break;
	case 104: 
		cret=(*((U (__stdcall *)(U,U,U,U))func))(A(0),A(1),A(2),A(3)); break;
	case 105: 
		cret=(*((U (__stdcall *)(U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4)); 
		break;
	case 106: 
		cret=(*((U (__stdcall *)(U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5)); 
		break;
	case 107: 
		cret=(*((U (__stdcall *)(U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6)); 
		break;
	case 108: 
		cret=(*((U (__stdcall *)(U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7)); 
		break;
	case 109: 
		cret=(*((U (__stdcall *)(U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8)); 
		break;
	case 110: 
		cret=(*((U (__stdcall *)(U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9)); 
		break;
	case 111:
		cret=(*((U (__stdcall *)(U,U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9),A(10));
		break;
	case 112:
		cret=(*((U (__stdcall *)(U,U,U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9),A(10),A(11));
		break;
	case 113:
		cret=(*((U (__stdcall *)(U,U,U,U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9),A(10),A(11),
			A(12));
		break;
	case 114:
		cret=(*((U (__stdcall *)(U,U,U,U,U,U,U,U,U,U,U,U,U,U))func))
			(A(0),A(1),A(2),A(3),A(4),A(5),A(6),A(7),A(8),A(9),A(10),A(11),
			A(12),A(13));
		break;
#undef U
#endif
	default:
		return PRIM_ERROR;
	}

	if(cret_p) *result=p_uintptr(cret);
	else *result=p_float(cretd);
	return PRIM_SUCCESS;
}

/* utility */

DEFPRIM(dl_load_byte)
{
	uintptr_t addr;
	if(!p_uintptr_val(args[0],&addr)) return PRIM_ERROR;
	*result=sint(LC(addr));
	return PRIM_SUCCESS;
}

DEFPRIM(dl_store_byte)
{
	uintptr_t addr;
	int byte;
	
	if(!p_uintptr_val(args[0],&addr)) return PRIM_ERROR;
	GET_SINT_ARG(1,byte);
	if(!p_byte_p(byte)) return PRIM_ERROR;
	SC(addr,byte);
	return PRIM_SUCCESS;
}
			
/* FixedByteArray >> address */
DEFPRIM(dl_address)
{
	*result=p_uintptr((uintptr_t)self->fbarray.elt);
	return PRIM_SUCCESS;
}
