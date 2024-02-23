/*
	xc character type.
	$Id: mulk xctype.c 406 2020-04-19 Sun 11:29:54 kt $
*/

#include "xctype.h"

int sjis_trail_size(int ch)
{
	if((0x81<=ch&&ch<=0x9f)||(0xe0<=ch&&ch<=0xfc)) return 1;
	else return 0;
}

int sjis_mblead_p(int ch)
{
	return sjis_trail_size(ch)!=0;
}

int sjis_mbtrail_p(int ch)
{
	return (0x40<=ch&&ch<=0x7e)||(0x80<=ch&&ch<=0xfc);
}

int utf8_trail_size(int ch)
{
	if((ch&0xe0)==0xc0) return 1;
	else if((ch&0xf0)==0xe0) return 2;
	else if((ch&0xf8)==0xf0) return 3;
	else if((ch&0xfc)==0xf8) return 4;
	else if((ch&0xfe)==0xfc) return 5;
	else return 0;
}

int utf8_mblead_p(int ch)
{
	return utf8_trail_size(ch)!=0;
}

int utf8_mbtrail_p(int ch)
{
	return 0x80<=ch&&ch<=0xbf;
}
