/*
	coordinate pack to int.
	$Id: mulk coord.c 406 2020-04-19 Sun 11:29:54 kt $
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
