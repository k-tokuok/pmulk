time-speed-distance problem generaor
$Id: mulk/basic train.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	train
.caption DESCRIPTION
TRAIN is a program which uses the computer to generate problems with random initial conditions to teach about the time-speed-distance relationship.
You then input the answer and the computer verifies your response.
.caption ORIGIN
Basic computer games micro computer edition.
.
source from http://www.vintage-basic.net/
.caption AUTHOR
A student of Lexington High School.

Published by Walt Koetke, Lexington High School, Lexington, Mass.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.train
**Cmd.train >> main: args
	Basic new run: #Cmd.train.source
	
*->Cmd.train.source
1 PRINT TAB(33);"TRAIN"
2 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
3 PRINT: PRINT: PRINT
4 PRINT "TIME - SPEED DISTANCE EXERCISE": PRINT
10 C=INT(25*RND(1))+40
15 D=INT(15*RND(1))+5
20 T=INT(19*RND(1))+20
25 PRINT " A CAR TRAVELING";C;"MPH CAN MAKE A CERTAIN TRIP IN"
30 PRINT D;"HOURS LESS THAN A TRAIN TRAVELING AT";T;"MPH."
35 PRINT "HOW LONG DOES THE TRIP TAKE BY CAR";
40 INPUT A
45 V=D*T/(C-T)
50 E=INT(ABS((V-A)*100/A)+.5)
55 IF E>5 THEN 70
60 PRINT "GOOD! ANSWER WITHIN";E;"PERCENT."
65 GOTO 80
70 PRINT "SORRY.  YOU WERE OFF BY";E;"PERCENT."
80 PRINT "CORRECT ANSWER IS";V;"HOURS."
90 PRINT
95 PRINT "ANOTHER PROBLEM (YES OR NO)";
100 INPUT A$
105 PRINT
110 IF A$="YES" THEN 10
999 END
