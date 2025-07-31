intercept an enemy icbm
$Id: mulk/basic icbm.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	icbm
.caption DESCRIPTION
Your radar station picks up an enemy ICBM heading your way, telling you its coordinates (in miles north and miles east of your location).
You launch a surface-to-air missle (SAM) to intercept it.

Your only control over the SAM is that you can aim it in any direction, both at launch, and in mid-air.
Using the coordinates of the ICBM as a guide, you input the direction (measured CCW from North) in which you want the SAM to travel.

At the next radar scan on minute later, you are given the new coordinates of the ICBM, the coordinates of your SAM, and the distance between the two.
You can now make corrections in the course of your SAM by entering a new direction.

You have no control over the altitude of your SAM, as it is assumed that it will seek the same altitude as the ICBM.

As the two missles draw closer, you make adjustments in the direction of the SAM so as to intercept as the ICBM.
It's not easy to hit, because the ICBM is programmed to make evasive maneuvers, by taking random deviations from the straight line course to your location.
Also, its speed is not known, although it does not vary after randomly selected at the start of the run.

You can destroy the ICBM by coming within 5 miles of it, at which time your SAM's heat-seeking sensors will come into action and direct it to its target.
If you overshoot the ICBM it's possible to turn the SAM around and chase the ICBM back towards your location.
But be careful; you may get both missles in your lap.
.caption ORIGIN
More basic computer games.
.
source from https://www.roug.org/
.caption AUTHOR
Chris Falco.

The write up is by Paul Calter.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.icbm
**Cmd.icbm >> main: args
	Basic new run: #Cmd.icbm.source
	
*->Cmd.icbm.source
10 PRINT TAB(26);"ICBM"
20 PRINT TAB(20);"CREATIVE COMPUTING"
30 PRINT TAB(18);"MORRISTOWN, NEW JERSEY"
40 PRINT:PRINT:PRINT
110 X1=0:Y1=0
120 X=INT(RND(1)*800)+200:Y=INT(RND(1)*800)+200
130 S=INT(RND(1)*20+50):S1=INT(RND(1)*20+50)
170 PRINT "-------MISSILE-----         ";
175 PRINT "--------SAM--------         ------"
180 PRINT "MILES","MILES","MILES","MILES","HEADING"
190 PRINT "NORTH","EAST","NORTH","EAST","?"
200 PRINT "----------------------------------";
205 PRINT "---------------------------"
210 FOR N=1 TO 50
220 PRINT Y,X,Y1,X1,
230 IF X=0 THEN 550
240 INPUT T1
250 T1=T1/57.296
260 H=INT(RND(1)*200+1)
270 IF H>4 THEN 290
280 ON H GOTO 470,490,510,530
290 X1=INT(X1+S1*SIN(T1)):Y1=INT(Y1+S1*COS(T1))
310 IF SQR(X^2+Y^2)>S THEN 350
320 X=0:Y=0
340 GOTO 430
350 B=SQR(X^2+Y^2)/1000
360 T=ATN(Y/X)
370 X=INT(X-S*COS(T)+RND(1)*20+R)
380 Y=INT(Y-S*SIN(T)+RND(1)*20+R)
390 D=SQR((X-X1)^2+(Y-Y1)^2)
400 IF D<=5 THEN 440
410 D=INT(D)
420 PRINT "ICBM & SAM NOW"; D; "MILES APART"
430 NEXT N
440 PRINT "CONGRATULATIONS!  YOUR SAM CAME WITHIN";D;"MILES OF"
450 PRINT "THE ICBM AND DESTROYED IT!"
460 GOTO 560
470 PRINT "TOO BAD.  YOUR SAM FELL TO THE GROUND!"
480 GOTO 560
490 PRINT "YOUR SAM EXPLODED IN MIDAIR!"
500 GOTO 560
510 PRINT "GOOD LUCK-THE ICBM EXPLODED HARMLESSLY IN MIDAIR!"
520 GOTO 560
530 PRINT "GOOD LUCK-THE ICBM TURNED OUT TO BE A FRIENDLY AIRCRAFT!"
540 GOTO 560
550 PRINT "TOO BAD!"
555 PRINT "THE ICBM JUST HIT YOUR LOCATION!!"
560 PRINT "DO YOU WANT TO PLAY MORE? (Y OR N)";
570 INPUT A$
580 IF A$="Y" THEN 130
590 END
