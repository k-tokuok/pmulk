/*
	coordinate pack to int.
	$Id: mulk coord.c 1433 2025-06-03 Tue 21:15:38 kt $
*/

#include "std.h"
#include "coord.h"

int coord(int x,int y)
{
	if(x<0) x=0;
	if(x>COORD_MAX) x=COORD_MAX;
	if(y<0) y=0;
	if(y>COORD_MAX) y=COORD_MAX;
	return (x<<14)|y;
}
