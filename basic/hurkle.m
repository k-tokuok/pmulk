seek happy beast
$Id: mulk/basic hurkle.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	hurkle
.caption DESCRIPTION
A Hurkle is a happy beast and lives in another galaxy on a planet named Lirht that has three moons.
Hurkle are favorite pets of the Gwik, the dominant race of Lirht and... well, to find out more, read "The Hurkle is a Happy Beast," a story in the book A Way Home by Theodore Sturgeon.

In this program a shy hurkle is hiding on a 10 by 10 grid.
Home base is point 0,0 in the Southwest corner.
Your guess as to the gridpoint where the hurkle is hiding should be a pair of whole numbers, separated by a comma.
After each try, the computer will tell you the approximate direction to go look for the Hurkle.
You get five guesses to find him.
.caption ORIGIN
Basic computer games micro computer edition.
.
source from http://www.classicbasicgames.org/
.caption AUTHOR
Bob Albrecht, People's Computer Company.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.hurkle
**Cmd.hurkle >> main: args
	Basic new run: #Cmd.hurkle.source
	
*->Cmd.hurkle.source
10 PRINT TAB(33);"HURKLE"
20 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
30 PRINT:PRINT:PRINT
110 N=5
120 G=10
210 PRINT
220 PRINT "A HURKLE IS HIDING ON A";G;"BY";G;"GRID. HOMEBASE"
230 PRINT "ON THE GRID IS POINT 0,0 IN THE SOUTHWEST CORNER,"
235 PRINT "AND ANY POINT ON THE GRID IS DESIGNATED BY A"
240 PRINT "PAIR OF WHOLE NUMBERS SEPERATED BY A COMMA. THE FIRST"
245 PRINT "NUMBER IS THE HORIZONTAL POSITION AND THE SECOND NUMBER"
246 PRINT "IS THE VERTICAL POSITION. YOU MUST TRY TO"
250 PRINT "GUESS THE HURKLE'S GRIDPOINT. YOU GET";N;"TRIES."
260 PRINT "AFTER EACH TRY, I WILL TELL YOU THE APPROXIMATE"
270 PRINT "DIRECTION TO GO TO LOOK FOR THE HURKLE."
280 PRINT
285 A=INT(G*RND(1))
286 B=INT(G*RND(1))
310 FOR K=1 TO N
320 PRINT "GUESS #";K;
330 INPUT X,Y
340 IF ABS(X-A)+ABS(Y-B)=0 THEN 500
350 REM PRINT INFO
360 GOSUB 610
370 PRINT
380 NEXT K
410 PRINT
420 PRINT "SORRY, THAT'S";N;"GUESSES."
430 PRINT "THE HURKLE IS AT ";A;",";B
440 PRINT
450 PRINT "LET'S PLAY AGAIN, HURKLE IS HIDING."
460 PRINT
470 GOTO 285
500 REM
510 PRINT
520 PRINT "YOU FOUND HIM IN";K;"GUESSES!"
540 GOTO 440
610 PRINT "GO ";
620 IF Y=B THEN 670
630 IF Y<B THEN 660
640 PRINT "SOUTH";
650 GOTO 670
660 PRINT "NORTH";
670 IF X=A THEN 720
680 IF X<A THEN 710
690 PRINT "WEST";
700 GOTO 720
710 PRINT "EAST";
720 PRINT
730 RETURN
999 END
