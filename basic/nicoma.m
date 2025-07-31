boomerang puzzle from Arithmetica of Nicomachus
$Id: mulk/basic nicoma.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	nicoma
.caption DESCRIPTION
One of the most ancient forms of arithmetical puzzle is sometimes referred to as a "boomerang".
At some time, everyone has been asked to "think of a number", and, after going through some process of private calculation, to state the result, after which the questioner promptly tells you the number you originally thought of.
There are humdreds of varieties of the puzzle.

The oldest recorded example appears to  be that giving in Arithmetica of Nicomachus, who died about the year 120.
.caption ORIGIN
Basic computer games micro computer edition.
.
source from http://www.classicbasicgames.org/
.caption AUTHOR
David Ahl, Creative Computing.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.nicoma
**Cmd.nicoma >> main: args
	Basic new run: #Cmd.nicoma.source

*->Cmd.nicoma.source
2 PRINT TAB(33);"NICOMA"
4 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
6 PRINT: PRINT: PRINT
10 PRINT "BOOMERANG PUZZLE FROM ARITHMETICA OF NICOMACHUS -- A.D. 90!"
20 PRINT
30 PRINT "PLEASE THINK OF A NUMBER BETWEEN 1 AND 100."
40 PRINT "YOUR NUMBER DIVIDED BY 3 HAS A REMAINDER OF";
45 INPUT A
50 PRINT "YOUR NUMBER DIVIDED BY 5 HAS A REMAINDER OF";
55 INPUT B
60 PRINT "YOUR NUMBER DIVIDED BY 7 HAS A REMAINDER OF";
65 INPUT C
70 PRINT
80 PRINT "LET ME THINK A MOMENT..."
85 PRINT
90 FOR I=1 TO 1500: NEXT I
100 D=70*A+21*B+15*C
110 IF D<=105 THEN 140
120 D=D-105
130 GOTO 110
140 PRINT "YOUR NUMBER WAS";D;", RIGHT";
160 INPUT A$
165 PRINT
170 IF A$="YES" THEN 220
180 IF A$="NO" THEN 240
190 PRINT "EH?  I DON'T UNDERSTAND '";A$;"'  TRY 'YES' OR 'NO'."
200 GOTO 160
220 PRINT "HOW ABOUT THAT!!"
230 GOTO 250
240 PRINT "I FEEL YOUR ARITHMETIC IS IN ERROR."
250 PRINT
260 PRINT "LET'S TRY ANOTHER."
270 GOTO 20
999 END
