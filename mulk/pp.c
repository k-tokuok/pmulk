/*
	preprocessor.
	$Id: mulk pp.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <string.h>
#include <ctype.h>

#include "mem.h"
#include "heap.h"
#include "splay.h"
#include "xbarray.h"

static struct splay symbols;
static struct xbarray line,symbol;

static char *lexptr;

static int cmd_p(char *kw)
{
	int len;
	len=strlen(kw);
	if(line.size<len) return FALSE;
	lexptr=line.elt+len;
	return strncmp(line.elt,kw,len)==0;
}

#define CMD_NONE 0
#define CMD_IF 1
#define CMD_ELSEIF 2
#define CMD_ELSE 3
#define CMD_SET 4
#define CMD_END 5

static int get_line(void)
{
	char *s;
	s=xbarray_fgets(&line,stdin);
	if(s==NULL) return EOF;
	if(cmd_p(".if")) return CMD_IF;
	else if(cmd_p(".elseif")) return CMD_ELSEIF;
	else if(cmd_p(".else")) return CMD_ELSE;
	else if(cmd_p(".end")) return CMD_END;
	else if(cmd_p(".set")) return CMD_SET;
	else return CMD_NONE;
}

#define SYMBOL 6

/* return '\0', '~', '|' or SYMBOL */

static int skip_lines(void)
{
	int st;
	while(TRUE) {
		st=get_line();
		if(st==CMD_IF) while(skip_lines()!=CMD_END);
		else if(st==CMD_SET||st==CMD_NONE);
		else break;
	}
	return st;
}

static void set(char *name)
{
	name=heap_strdup(&heap_perm,name);
	if(splay_find(&symbols,name)!=NULL) xerror("duplicate set %s.",name);
	splay_add(&symbols,name,name);
}

static int lex(void)
{
	int ch;
	while(isspace(LC(lexptr))) lexptr++;
	ch=LC(lexptr++);
	if(ch=='\0'||ch=='~'||ch=='|') return ch;

	if(isalpha(ch)) {
		xbarray_reset(&symbol);
		xbarray_add(&symbol,ch);
		while(TRUE) {
			ch=LC(lexptr);
			if(!isalnum(ch)) break;
			xbarray_add(&symbol,ch);
			lexptr++;
		}
		xbarray_add(&symbol,'\0');
		return SYMBOL;
	}
	xerror("illegal char %c.",ch);
	return 0; /*NOTREACHED*/
}

static int satisfy_p(void)
{
	int not_p,tk;
	while(TRUE) {
		not_p=FALSE;
		tk=lex();
		if(tk=='~') {
			not_p=TRUE;
			tk=lex();
		}
		if(tk!=SYMBOL) xerror("require symbol.");
		if((splay_find(&symbols,symbol.elt)==NULL)==not_p) return TRUE;
		if((tk=lex())!='|') break;
	}
	return FALSE;
}

static int process_lines(void)
{
	int st,skip_p;
	while(TRUE) {
		st=get_line();
		if(st==CMD_IF) {
			skip_p=FALSE;
			if(satisfy_p()) {
				st=process_lines();
				skip_p=TRUE;
			} else st=skip_lines();
			
			while(!skip_p&&st==CMD_ELSEIF) {
				if(satisfy_p()) {
					st=process_lines();
					skip_p=TRUE;
				} else st=skip_lines();
			}
			
			if(!skip_p&&st==CMD_ELSE) st=process_lines();
			
			while(st!=CMD_END) st=skip_lines();
		} else if(st==CMD_SET) {
			if(lex()!=SYMBOL) xerror("require symbol.");
			set(symbol.elt);
		} else if(st==CMD_NONE) printf("%s\n",line.elt);
		else break;
	}
	return st;
}
	
int main(int argc,char *argv[])
{
	int i;
	splay_init(&symbols,(int(*)(void*,void*))strcmp);
	xbarray_init(&line);
	xbarray_init(&symbol);
	for(i=1;i<argc;i++) set(argv[i]);
	if(process_lines()!=EOF) xerror("illegal syntax.");
	return 0;
}
