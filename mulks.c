/*
	mulk for standalone.
	$Id: mulk mulks.c 1243 2024-05-26 Sun 11:40:56 kt $
*/

#include "std.h"

#if WINDOWS_P
#include <io.h>
#include <fcntl.h>
#endif

#ifdef __BORLANDC__
#define _setmode setmode
#include <float.h>
#endif

#include "pf.h"

#include "om.h"
#include "gc.h"
#include "ir.h"
#include "ip.h"

#include "mulks.wk"

int main(int argc,char *argv[])
{
	object boot_args,main_args;
	struct xbarray exepath;
	int i;
	
	setbuf(stdout,NULL);
#if WINDOWS_P
	_setmode(_fileno(stdin),_O_BINARY);
	_setmode(_fileno(stdout),_O_BINARY);
#endif

#ifdef __BORLANDC__
	_control87(MCW_EM, MCW_EM);
	_control87(_control87(0,0),0x1FFF);
#endif

	om_init();
	ir(image);
	gc_init();

	boot_args=gc_object_new(om_FixedArray,3);

	main_args=gc_object_new(om_FixedArray,argc-1);
	for(i=1;i<argc;i++) main_args->farray.elt[i-1]=gc_string(argv[i]);
	boot_args->farray.elt[1]=main_args;

	
	pf_exepath(argv[0],&exepath);
	boot_args->farray.elt[2]=gc_string(exepath.elt);
	xbarray_free(&exepath);

	ip_start(boot_args,DEFAULT_STACK_SIZE*K);
	return 0;
}
