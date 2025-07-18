/*
	lexical analysis.
	$Id: mulk lex.h 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "xbarray.h"

/* token types -- -1..255 as single character */

#define tSTRING 256
#define tCHARACTER 257
#define tINTEGER 258
#define tIDENTIFIER 259
#define tBINARY_SELECTOR 260
#define tSYMBOL 261
#define tKEYWORD_SELECTOR 262
#define tSPECIAL 263
#define tFLOAT 264

#define tARROW 270 /* -> */
#define tARRAY_LITERAL 271 /* #( */
#define tBYTE_ARRAY_LITERAL 272 /* #[ */

extern struct xbarray lex_str;
extern int lex_ival;
extern double lex_fval;

extern void lex_start(FILE *fp);
extern void lex_error(char *fmt,...);
extern int lex(void);

extern char *lex_token_name(char *buf,int tk);
extern char *lex_current_string(char *buf,int tk);
