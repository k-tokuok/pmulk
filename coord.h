/*
	coordinate pack to int.
	$Id: mulk coord.h 644 2021-01-16 Sat 22:52:10 kt $
*/

#define COORD_MAX 0x3fff
extern int coord(int x,int y);

#define COORD_X(c) (((c)>>14)&COORD_MAX)
#define COORD_Y(c) ((c)&COORD_MAX)
