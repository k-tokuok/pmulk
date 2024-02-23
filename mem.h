/*
	xc memory access.
	$Id: mulk mem.h 406 2020-04-19 Sun 11:29:54 kt $
*/

#define LC(p) (*(unsigned char*)(p))
#define SC(p,v) (*(unsigned char*)(p)=(unsigned char)(v))
