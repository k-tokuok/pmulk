/*
	xc character type.
	$Id: mulk xctype.c 1193 2024-03-31 Sun 07:18:03 kt $
*/

#include "xctype.h"

int utf8_trail_size(int ch)
{
	if((ch&0xe0)==0xc0) return 1;
	else if((ch&0xf0)==0xe0) return 2;
	else if((ch&0xf8)==0xf0) return 3;
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
