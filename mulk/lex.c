/*
	lex.
	$Id: mulk lex.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"

#include <ctype.h>
#include <string.h>

#include "mem.h"

#include "lex.h"

struct xbarray lex_str;
int lex_ival;
double lex_fval;

static FILE *infp;
static int line;
static int column;

static int next_ch;

void lex_error(char *fmt,...)
{
	char buf[MAX_STR_LEN];
	va_list va;

	va_start(va,fmt);
	xvsprintf(buf,fmt,va);
	va_end(va);
	xerror("%s at %d:%d.",buf,line,column);
}

static int skip(void)
{
	int result;

	result=next_ch;
	if(result=='\n') {
		line++;
		column=0;
	} else column++;

	next_ch=fgetc(infp);
	if(!(isspace(next_ch)||isgraph(next_ch)||next_ch==EOF)) {
		lex_error("illegal char %x",next_ch);
	}
	return result;
}

static void add(int ch)
{
	xbarray_add(&lex_str,ch);
}

static int get(void)
{
	int ch;
	ch=skip();
	add(ch);
	return ch;
}

void lex_start(FILE *fp)
{
	infp=fp;
	line=1;
	column=0;

	xbarray_init(&lex_str);
	skip();
}

static int digit_val(int ch,int radix)
{
	int result;
	
	if(isdigit(ch)) result=ch-'0';
	else if(isalpha(ch)) result=tolower(ch)-'a'+10;
	else result=-1;

	if(!(0<=result&&result<radix)) lex_error("illegal digit %c",ch);
	return result;
}

static void get_quoted(void)
{
	int quote,val;

	quote=skip();
	while(next_ch!=quote) {
		if(next_ch=='\n'||next_ch==EOF) lex_error("quote not closed");
		if(next_ch=='\\') {
			skip();
			switch(next_ch) {
			case 'a': skip(); add('\a'); break;
			case 'b': skip(); add('\b'); break;
			case 'c':
				skip();
				val=toupper(skip());
				if(!(0x40<=val&&val<=0x5f)) lex_error("illegal ctrl char");
				add(val&0x1f);
				break;
			case 'e': skip(); add(0x1b); break;
			case 'f': skip(); add('\f'); break;
			case 'n': skip(); add('\n'); break;
			case 'r': skip(); add('\r'); break;
			case 't': skip(); add('\t'); break;
			case 'v': skip(); add('\v'); break;
			case 'x':
				skip();
				val=digit_val(skip(),16)*16;
				val+=digit_val(skip(),16);
				add(val);
				break;
			default:
				get();
				break;
			}
		} else {
			get();
		}
	}
	skip();
}

static int identifier_lead_char_p(void)
{
	return isalpha(next_ch)||next_ch=='_';
}

static int identifier_trail_char_p(void)
{
	return identifier_lead_char_p()||isdigit(next_ch)||next_ch=='?'
		||next_ch=='.';
}

static int binary_selector_char_p(void)
{
	return next_ch=='%'||next_ch=='&'||next_ch=='*'||next_ch=='+'||next_ch=='/'
		||next_ch=='<'||next_ch=='='||next_ch=='>'||next_ch=='@'||next_ch=='\\'
		||next_ch=='^'||next_ch=='|'||next_ch=='~'||next_ch=='-';
}

static int symbol_char_p(void)
{
	return identifier_trail_char_p()||binary_selector_char_p()||next_ch==':';
}

int lex(void)
{
	int radix;
	double factor;
	while(isspace(next_ch)) skip();

	if(next_ch=='{') {
		while(next_ch!='}') skip();
		skip();
		return lex();
	}

	if(next_ch==EOF||next_ch=='!'||next_ch=='('||next_ch==')'||next_ch==','
		||next_ch==':'||next_ch==';'||next_ch=='['||next_ch==']') return skip();

	xbarray_reset(&lex_str);
	
	if(next_ch=='"') {
		get_quoted();
		return tSTRING;
	}
		
	if(next_ch=='\'') {
		get_quoted();
		if(lex_str.size!=1) lex_error("illegal character literal");
		lex_ival=LC(lex_str.elt);
		return tCHARACTER;
	}

	if(isdigit(next_ch)) {
		lex_ival=0;
		while(isdigit(next_ch)) lex_ival=lex_ival*10+digit_val(skip(),10);
		if(next_ch=='x') {
			skip();
			radix=lex_ival;
			lex_ival=0;
			if(radix==0) radix=16;
			while(isalnum(next_ch)) {
				lex_ival=lex_ival*radix+digit_val(skip(),radix);
			}
		} else if(next_ch=='.') {
			skip();
			lex_fval=lex_ival;
			factor=0.1;
			while(isdigit(next_ch)) {
				lex_fval+=factor*digit_val(skip(),10);
				factor/=10;
			}
			return tFLOAT;
		}
					
		return tINTEGER;
	}

	if(identifier_lead_char_p()) {
		while(identifier_trail_char_p()) get();
		if(next_ch==':') {
			get();
			return tKEYWORD_SELECTOR;
		} else return tIDENTIFIER;
	}
			
	if(binary_selector_char_p()) {
		if(get()=='-') {
			if(next_ch=='>') {
				skip();
				return tARROW;
			} else if(next_ch=='-') {
				while(next_ch!='\n') skip();
				return lex();
			} 
		}
		while(binary_selector_char_p()) get();
		return tBINARY_SELECTOR;
	}				
		
	if(next_ch=='#') {
		skip();
		if(next_ch=='(') {
			skip();
			return tARRAY_LITERAL;
		}
		if(next_ch=='[') {
			skip();
			return tBYTE_ARRAY_LITERAL;
		}
		while(symbol_char_p()) get();
		return tSYMBOL;
	}

	if(next_ch=='$') {
		skip();
		while(identifier_trail_char_p()) get();
		return tSPECIAL;
	}

	lex_error("illegal char '%c'",next_ch);
	return 0;
}

char *lex_token_name(char *buf,int tk)
{
	char *name;

	switch(tk) {
	case tSTRING: name="string"; break;
	case tCHARACTER: name="character"; break;
	case tINTEGER: name="integer"; break;
	case tIDENTIFIER: name="identifier"; break;
	case tBINARY_SELECTOR: name="binary selector"; break;
	case tSYMBOL: name="symbol"; break;
	case tKEYWORD_SELECTOR: name="keyword selector"; break;
	case tSPECIAL: name="special"; break;
	case tARROW: name="->"; break;
	case tARRAY_LITERAL: name="#("; break;
	case tBYTE_ARRAY_LITERAL: name="#["; break;
	case EOF: name="eof"; break;
	default: name=NULL; break;
	}

	if(name!=NULL) strcpy(buf,name);
	else xsprintf(buf,"%c",tk);

	return buf;
}
