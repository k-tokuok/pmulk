/*
	xmain.c -- i/f between java and mulk interpreter.
	$Id: mulk/android xmain.c 1448 2025-07-03 Thu 14:21:56 kt $
*/

#include "std.h"

#include <stdlib.h>
#include <jni.h>
#include <setjmp.h>
#include <signal.h>
#include <string.h>

#include "om.h"
#include "ir.h"
#include "gc.h"
#include "ip.h"
#include "xconsole.h"

static JNIEnv *env;
static jobject obj;
static jmethodID putChar_id;

/* xconsole.h */

void xputc(int ch)
{
	(*env)->CallVoidMethod(env,obj,putChar_id,ch);
}

void xputs(char *s)
{
	while(*s!='\0') xputc(*s++);
}

static jmp_buf exit_env;

void xexit(void)
{
	longjmp(exit_env,1);
}

/* android primitives */

#include "prim.h"

#define MAX_ARGS 20

DEFPRIM(android_getMethodId)
{
	object sig;
	char *cfn,csig[MAX_STR_LEN],*p;
	jmethodID id;
	int i,ch;
	struct xbarray xba;
	
	sig=args[1];
	if(om_class(sig)!=om_String) return PRIM_ERROR;
	if(sig->fbarray.size>MAX_ARGS+1) return PRIM_ERROR;
	if((cfn=p_string_val(args[0],&xba))==NULL) return PRIM_ERROR;
	
	p=csig;
	*p++='(';
	for(i=1;i<sig->fbarray.size;i++) {
		ch=sig->fbarray.elt[i];
		if(ch=='S') ch='B';
		if(ch=='B') *p++='[';
		if(ch=='A') {
			ch='I';
			*p++='[';
		}
		*p++=ch;
	}
	*p++=')';
	ch=sig->fbarray.elt[0];
	if(ch=='S') ch='B';
	if(ch=='B') *p++='[';
	if(ch=='A') {
		ch='I';
		*p++='[';
	}
	*p++=ch;
	*p++='\0';

	id=(*env)->GetMethodID(env,(*env)->GetObjectClass(env,obj),cfn,csig);
	xbarray_free(&xba);
	
	*result=p_uint64((uint64_t)id);

	return PRIM_SUCCESS;
}

DEFPRIM(android_callMethod)
{
	uint64_t id,lvalue;
	object sig,margs,mo,cl;
	jvalue jargs[MAX_ARGS],jv;
	jbyteArray jb;
	jintArray ji;
	int i,j,ch,sz,value;
	jint *jip;
	
	if(!p_uint64_val(args[0],&id)) return PRIM_ERROR;
	sig=args[1];
	if(om_class(sig)!=om_String) return PRIM_ERROR;
	margs=args[2];
	if(om_class(margs)!=om_FixedArray) return PRIM_ERROR;
	if(sig->fbarray.size-1!=margs->farray.size) return PRIM_ERROR;

	for(i=0;i<margs->farray.size;i++) {
		ch=sig->fbarray.elt[i+1];
		mo=margs->farray.elt[i];
		if(ch=='I') {
			if(!sint_p(mo)) return PRIM_ERROR;
			jargs[i].i=sint_val(mo);
        } else if(ch=='J') {
            if(!p_uint64_val(mo,(uint64_t*)&jargs[i].j)) return PRIM_ERROR;
        } else if(ch=='D') {
			if(!p_float_val(mo,&jargs[i].d)) return PRIM_ERROR;
		} else if(ch=='B'||ch=='S') {
			if(mo==om_nil) jargs[i].l=NULL;
			else {
				cl=om_class(mo);
				if(!(cl==om_String||cl==om_FixedByteArray)) return PRIM_ERROR;
				jv.l=(*env)->NewByteArray(env,mo->fbarray.size);
				(*env)->SetByteArrayRegion(env,jv.l,0,mo->fbarray.size,
					(jbyte*)(mo->fbarray.elt));
				jargs[i]=jv;
			}
		} else if(ch=='A') {
			if(mo==om_nil) jargs[i].l=NULL;
			else {
				cl=om_class(mo);
				if(!(cl==om_FixedArray)) return PRIM_ERROR;
				jv.l=(*env)->NewIntArray(env,mo->farray.size);
				jip=(*env)->GetIntArrayElements(env,jv.l,NULL);
				for(j=0;j<mo->farray.size;j++) {
					if(!p_uint64_val(mo->farray.elt[j],&lvalue)) {
						return PRIM_ERROR;
					}
					jip[j]=(int)lvalue;
				}
				(*env)->ReleaseIntArrayElements(env,jv.l,jip,0);
				jargs[i]=jv;
			}
		}
	}

	ch=sig->fbarray.elt[0];
	if(ch=='V') (*env)->CallVoidMethodA(env,obj,(jmethodID)id,jargs);
	else if(ch=='I') {
        jv.i = (*env)->CallIntMethodA(env, obj, (jmethodID) id, jargs);
        *result = sint(jv.i);
    } else if(ch=='J') {
        jv.j=(*env)->CallLongMethodA(env,obj,(jmethodID)id,jargs);
        *result=p_uint64(jv.j);
	} else if(ch=='D') {
		jv.d=(*env)->CallDoubleMethodA(env,obj,(jmethodID)id,jargs);
		*result=p_float(jv.d);
	} else if(ch=='S'||ch=='B') {
		jb=(jbyteArray)(*env)->CallObjectMethodA(env,obj,(jmethodID)id,jargs);
		if(jb==NULL) mo=om_nil;
		else {
			sz=(*env)->GetArrayLength(env,jb);
			if(ch=='S') {
				mo=gc_object_new(om_String,sz);
				(*env)->GetByteArrayRegion(env,jb,0,sz,
					(jbyte*)(mo->fbarray.elt));
				om_set_string_hash(mo);
			} else {
				mo=gc_object_new(om_FixedByteArray,sz);
				(*env)->GetByteArrayRegion(env,jb,0,sz,
					(jbyte*)(mo->fbarray.elt));
			}
			(*env)->DeleteLocalRef(env,jb);
		}
		*result=mo;
	} else if(ch=='A') {
		ji=(jintArray)(*env)->CallObjectMethodA(env,obj,(jmethodID)id,jargs);
		if(ji==NULL) mo=om_nil;
		else {
			sz=(*env)->GetArrayLength(env,ji);
			mo=gc_object_new(om_FixedArray,sz);
			jip=(*env)->GetIntArrayElements(env,ji,NULL);
			for(i=0;i<sz;i++) {
				mo->farray.elt[i]=p_uint64(jip[i]);
			}
			(*env)->ReleaseIntArrayElements(env,ji,jip,JNI_ABORT);
			(*env)->DeleteLocalRef(env,ji);
		}
		*result=mo;
	}
			
	for(i=0;i<margs->farray.size;i++) {
		ch=sig->fbarray.elt[i+1];
		if(ch=='B'||ch=='S'||ch=='A') {
			jv=jargs[i];
			if(ch=='B') {
				mo=margs->farray.elt[i];
				(*env)->GetByteArrayRegion(env,jv.l,0,mo->fbarray.size,
					(jbyte*)(mo->fbarray.elt));
			}
			(*env)->DeleteLocalRef(env,jv.l);
		}
	}

	return PRIM_SUCCESS;
}

#undef DEFPRIM
#undef DEFPROPERTY

/* mulkprim.c */

#define DEFPRIM(name) extern int prim_##name(object self,object *args,\
	object *result);
#define DEFPROPERTY(name)
#include "mulkprim.wk"
#undef DEFPRIM

int (*prim_table[])(object self,object *args,object *result)={
#define DEFPRIM(name) prim_##name,
#include "mulkprim.wk"
#undef DEFPRIM
	NULL
};
#undef DEFPROPERTY

#define DEFPRIM(name)
#define DEFPROPERTY(name) extern int property_##name(int key,object value,\
	object *result);
#include "mulkprim.wk"
#undef DEFPROPERTY

int (*property_table[])(int key,object value,object *result)={
#define DEFPROPERTY(name) property_##name,
#include "mulkprim.wk"
#undef DEFPROPERTY
	NULL
};

/**/

static void xmain(char *ifn)
{
	object boot_args;

    image_fn=ifn;

	om_init();
	ir_file(ifn);
	gc_init();
	
	boot_args=gc_object_new(om_FixedArray,2);

	/* main_class */
	boot_args->farray.elt[0]=om_nil;

	/* main_args */
	boot_args->farray.elt[1]=gc_object_new(om_FixedArray,0);

	ip_start(boot_args,DEFAULT_STACK_SIZE*K);
	om_finish();
	gc_finish();
}

static void signal_handler(int no) {
    xexit();
}

JNIEXPORT void JNICALL
Java_com_github_k_1tokuok_mulk_Main_xmain(JNIEnv *e,jobject o,jstring jifn)
{
    jclass c;
    char *ifn;
    struct sigaction sa;
    int st;
    env=e;
    obj=o;

    c=(*env)->GetObjectClass(env,o);
    putChar_id=(*env)->GetMethodID(env,c,"putChar","(I)V");
    ifn=(char*)((*env)->GetStringUTFChars(env,jifn,NULL));
    if((st=setjmp(exit_env))==0) {
        memset(&sa,0,sizeof(sa));
        sa.sa_handler=signal_handler;
        if(sigaction(SIGSEGV,&sa,NULL)==-1) xerror("sigaction failed.");
        xmain(ifn);
    }
    if(st!=0) xputs("!fatal, ip stopped.\n");
    (*env)->ReleaseStringUTFChars(env,jifn,ifn);
}

JNIEXPORT void JNICALL
Java_com_github_k_1tokuok_mulk_Main_trap(JNIEnv *e, jobject o, jint code)
{
    ip_trap_code=code;
}
