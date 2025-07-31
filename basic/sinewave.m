draw sine wave
$Id: mulk/basic sinewave.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	sinewave
.caption DESCRIPTION
Draw sine wave with word not usual X.
.caption ORIGIN
Basic computer games micro computer edition.
.
source from http://www.classicbasicgames.org/
.caption AUTHOR
David Ahl, Creative Computing.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.sinewave
**Cmd.sinewave >> main: args
	Basic new run: #Cmd.sinewave.source
	
*->Cmd.sinewave.source
10 PRINT TAB(30);"SINE WAVE"
20 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
30 PRINT: PRINT: PRINT: PRINT: PRINT
40 REMARKABLE PROGRAM BY DAVID AHL
50 B=0
100 REM  START LONG LOOP
110 FOR T=0 TO 40 STEP .25
120 A=INT(26+25*SIN(T))
130 PRINT TAB(A);
140 IF B=1 THEN 180
150 PRINT "CREATIVE"
160 B=1
170 GOTO 200
180 PRINT "COMPUTING"
190 B=0
200 NEXT T
999 END
