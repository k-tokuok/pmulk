discover the positions of the atoms
$Id: mulk/basic blackbox.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	blackbox
.caption DESCRIPTION
Black Box is a computerized version of the game that appeared in the August 1977 issue of Games and Puzzles.
The Black Box is an 8-by-8 square in which several atoms are hidden.
The object of the game is to discover the positions of the atoms by projecting rays at them from the sides of the box and noticing how these rays are deflected, reflected, or absorbed.
Rays enter the box across one of the four edges and travel horizontally or vertically.
The entry points are numbered from 1 to 32, counterclockwise, starting at the top of the left edge.

To play the game, you first specify how many atoms to place in the Black Box.
The you type in the point at which you send the ray into the box, and you type are told whether the ray was absorbed or where it emerged.
Type a zero to end the game and print the board.
The path of the ray is governed by the following rules:

1) Rays that strike an atom directly are absorbed.

2) Rays that come within one square of an atom in a diagonal direction (so that they would pass next to the atom if they continues) are deflected by 90 degrees.

3) Rays aimed between two atoms one square apart are reflected.

4) Rays otherwise travel in stright lines.

The game is pretty interesting with four or five atoms, but can get out of hand with too many more.
Occasionally, an atom can be masked by others.
This doesn't occur often, but sometimes the position is truly ambiguous (more often, there is only one place the atom can be).
For competitive play, score one point for reflections and absorptions, two for rays which emerge from the box, and five points for each atom guessed incorrectly.
.caption ORIGIN
More basic computer games.
.
source from https://www.roug.org/
.caption AUTHOR
Jeff Kenton.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.blackbox
**Cmd.blackbox >> main: args
	Basic new run: #Cmd.blackbox.source
	
*->Cmd.blackbox.source
50 DIM B(9,9)
100 PRINT TAB(25);"BLACKBOX"
110 PRINT TAB(20);"CREATIVE COMPUTING"
120 PRINT TAB(18);"MORRISTOWN, NEW JERSEY"
130 PRINT:PRINT:PRINT
140 DEF FNR(Z)=INT(8*RND(1)+1)
150 PRINT "NO. OF ATOMS";: INPUT N
160 FOR J=0 TO 9: FOR I=0 TO 9: B(I,J)=0: NEXT I,J
170 FOR I=1 TO N
180 X=FNR(1): Y=FNR(1): IF B(X,Y)<>0 THEN 180
190 B(X,Y)=1: NEXT I
200 S=0:C=0
210 PRINT "RAY";: INPUT R: IF R<1 THEN 480
220 ON (R-1)/8+1 GOTO 240,250,260,270
230 PRINT "ERROR": GOTO 210
240 X=0: Y=R: U=1: V=0: GOTO 280
250 X=R-8: Y=9: U=0: V=-1: GOTO 280
260 X=9: Y=25-R: U=-1: V=0: GOTO 280
270 X=33-R: Y=0: U=0: V=1
280 X1=X+U: Y1=Y+V
290 IF U=0 THEN X2=X1-1: X3=X1+1: Y2=Y1: Y3=Y1: GOTO 310
300 Y2=Y1-1: Y3=Y1+1: X2=X1: X3=X1
310 ON 8*B(X1,Y1)+B(X2,Y2)+2*B(X3,Y3)+1 GOTO 330,340,350,340
320 PRINT "ABSORBED":S=S+1: GOTO 210
330 X=X1: Y=Y1: GOTO 380
340 Z=1: GOTO 360
350 Z=-1
360 IF U=0 THEN U=Z: V=0: GOTO 380
370 U=0: V=Z
380 ON (X+15)/8 GOTO 420,400,430
390 STOP
400 ON (Y+15)/8 GOTO 440,280,450
410 STOP
420 Z=Y: GOTO 460
430 Z=25-Y: GOTO 460
440 Z=33-X: GOTO 460
450 Z=8+X
460 IF Z=R THEN PRINT "REFLECTED":S=S+1: GOTO 210
470 PRINT "TO";Z:S=S+2: GOTO 210
480 PRINT "NOW TELL ME, WHERE DO YOU THINK THE ATOMS ARE?"
490 PRINT "(IN ROW,COLUMN FORMAT PLEASE.)"
500 FOR Q=1 TO N
510 PRINT "ATOM # ";Q;
520 INPUT I,J
530 IF B(J,I)<>1 THEN S=S+5:GOTO 540
532 B(J,I)=2
535 C=C+1
540 NEXT Q
550 PRINT: FOR J=1 TO 8: FOR I=1 TO 8
560 IF B(I,J)=0 THEN PRINT " .";: GOTO 580
570 PRINT " *";
580 NEXT I: PRINT: NEXT J: PRINT
590 PRINT " YOU GUESSED ";C;" OUT OF ";N;" ATOMS CORRECTLY!!"
600 PRINT " YOUR SCORE FOR THIS ROUND WAS ";S;" POINTS."
610 INPUT " CARE TO TRY AGAIN";A$
620 IF LEFT$(A$,1)="Y" THEN PRINT:GOTO 150
