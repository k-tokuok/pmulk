/*
	mulk main routine.
	$Id: mulk mulk.c 1244 2024-05-27 Mon 22:03:35 kt $
*/

#include "std.h"

#include <stdlib.h>
#include <string.h>

#if WINDOWS_P
#include <io.h>
#include <fcntl.h>
#endif

#ifdef __BORLANDC__
#define _setmode setmode
#include <float.h>
#endif

#include "xgetopt.h"
#include "pf.h"

#include "om.h"
#include "gc.h"
#include "ir.h"
#include "ip.h"

static char *main_class;
static char *image_pn;
static int stack_size;

static void option(int argc,char *argv[])
{
	int ch;
	
	main_class=NULL;
	image_pn=NULL;
	stack_size=DEFAULT_STACK_SIZE;
	
	while((ch=xgetopt(argc,argv,"m:i:f:c:"))!=EOF) switch(ch) {
	case 'm': main_class=xoptarg; break;
	case 'i': image_pn=xoptarg; break;
	case 's': stack_size=atoi(xoptarg); break;
	default:
		fputs("\
-m CLASS as main class.\n\
-i FN as image file.\n\
-s KSIZE as stack size.\n\
",stderr);
		exit(1);
	}
}

static object make_boot_args(int argc,char *argv[])
{
	object boot_args,main_args;
	int i;
	
	boot_args=gc_object_new(om_FixedArray,3);
	if(main_class==NULL) boot_args->farray.elt[0]=om_nil;
	else boot_args->farray.elt[0]=gc_string(main_class);

	main_args=gc_object_new(om_FixedArray,argc);
	for(i=0;i<argc;i++) main_args->farray.elt[i]=gc_string(argv[i]);
	boot_args->farray.elt[1]=main_args;

	boot_args->farray.elt[2]=gc_string(image_pn);
	
	return boot_args;
}

int main(int argc,char *argv[])
{
	object boot_args;
	struct xbarray path;
	
	setbuf(stdout,NULL);
#if WINDOWS_P
	_setmode(_fileno(stdin),_O_BINARY);
	_setmode(_fileno(stdout),_O_BINARY);
#endif

#ifdef __BORLANDC__
	/* disable floating point exception */
	_control87(MCW_EM, MCW_EM);
	_control87(_control87(0,0),0x1FFF);
#endif

	option(argc,argv);
	xbarray_init(&path);
	if(image_pn==NULL) {
		pf_exepath(argv[0],&path);
#if UNIX_P
		/* remove last nul */
		path.size--; 
#else
		/* remove .exe */
		path.size=(int)(strrchr(path.elt,'.')-path.elt);
#endif
		xbarray_adds(&path,".mi");
		xbarray_add(&path,'\0');
		image_pn=path.elt;
	}

	om_init();
	ir_file(image_pn);
	gc_init();

	boot_args=make_boot_args(argc-xoptind,&argv[xoptind]);
	xbarray_free(&path);
	
	ip_start(boot_args,stack_size*K);

	om_finish();
	gc_finish();
	return 0;
}
