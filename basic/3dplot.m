curve graph that looks almost three-dimensional
$Id: mulk/basic 3dplot.m 1442 2025-06-12 Thu 10:05:28 kt $ 

*[man]
.caption SYNOPSIS
	3dplot
.caption DESCRIPTION
3-D PLOT will plot the family of curves of any function.
The function Z is plotted as "rising" out of the x-y plane with x and y inside circle of radius 30.
The resultant plot looks almost 3-dimensional.
.caption ORIGIN
Basic computer games micro computer edition.
.
source from http://www.vintage-basic.net/
.caption AUTHOR
Mark Bramhall, DEC.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.3dplot
**Cmd.3dplot >> main: args
	Basic new run: #Cmd.3dplot.source
	
*->Cmd.3dplot.source
1 PRINT TAB(30);"3D PLOT"
2 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
3 PRINT: PRINT: PRINT
5 DEF FNA(Z)=30*EXP(-Z*Z/100)
100 PRINT
110 FOR X=-30 TO 30 STEP 1.5
120 L=0
130 Y1=5*INT(SQR(900-X*X)/5)
140 FOR Y=Y1 TO -Y1 STEP -5
150 Z=INT(25+FNA(SQR(X*X+Y*Y))-.7*Y)
160 IF Z<=L THEN 190
170 L=Z
180 PRINT TAB(Z);"*";
190 NEXT Y
200 PRINT
210 NEXT X
300 END
