/*
	xc memory access.
	$Id: mulk mem.h 1433 2025-06-03 Tue 21:15:38 kt $
*/

#define LC(p) (*(unsigned char*)(p))
#define SC(p,v) (*(unsigned char*)(p)=(unsigned char)(v))
