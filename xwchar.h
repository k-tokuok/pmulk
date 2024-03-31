/*
	xc widechar.
	$Id: mulk xwchar.h 1188 2024-03-26 Tue 22:43:40 kt $
*/

#if U64_P
/* u64 supports 2 byte wide char */
#define XWCHAR_MAX_VAL 0xffff
#define XWCHAR_MAX_LEN 2
extern int xwchar_to_mbytes(uint32_t wc,char *buf);
#else
/* max size of composite utf-8 wide char */
#define XWCHAR_MAX_VAL UINT64_C(0xffffffff)
#define XWCHAR_MAX_LEN 4
extern int xwchar_to_mbytes(uint64_t wc,char *buf);
#endif
