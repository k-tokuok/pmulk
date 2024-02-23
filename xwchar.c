/*
	xc widechar.
	$Id: mulk xwchar.c 850 2022-03-05 Sat 11:10:45 kt $
*/

#include "std.h"
#include "xwchar.h"
#include "mem.h"

#if U64_P
int xwchar_to_mbytes(uint32_t wc,char *buf)
#else
int xwchar_to_mbytes(uint64_t wc,char *buf)
#endif
{
	int len,i;
	len=1;
#if U64_P
	while(wc>=(1<<(len*8))) len++;	
#else
	while(wc>=(UINT64_C(1)<<(len*8))) len++;
#endif
	for(i=0;i<len;i++) SC(buf+i,(wc>>((len-1-i)*8))&0xff);
	return len;
}
