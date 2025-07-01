/*
	coordinate pack to int.
	$Id: mulk coord.h 1433 2025-06-03 Tue 21:15:38 kt $
*/

#define COORD_MAX 0x3fff
extern int coord(int x,int y);

#define COORD_X(c) (((c)>>14)&COORD_MAX)
#define COORD_Y(c) ((c)&COORD_MAX)
