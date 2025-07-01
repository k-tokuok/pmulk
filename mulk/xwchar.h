/*
	xc widechar.
	$Id: mulk xwchar.h 1433 2025-06-03 Tue 21:15:38 kt $
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
