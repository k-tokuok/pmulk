self destruct mechanism countdown
$Id: mulk/basic countdwn.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	countdwn
.caption DESCRIPTION
This program Countdown is based on the program Guess in which the computer chooses a random number and then gives you clues whether you are too high or too low until you finally get the number.
In Countdown, the program adds a little interest to this gussing game by giving you a certain number of tries to get the mystery number between zero and nine before your schoolbuilding explodes.
.caption ORIGIN
More basic computer games.
.
source from https://www.roug.org/
.caption AUTHOR
Mark Chambers.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.countdwn
**Cmd.countdwn >> main: args
	Basic new run: #Cmd.countdwn.source
	
*->Cmd.countdwn.source
1 PRINT TAB(24);"COUNT DOWN"
2 PRINT TAB(20);"CREATIVE COMPUTING"
3 PRINT TAB(18);"MORRISTOWN, NEW JERSEY"
4 PRINT:PRINT:PRINT
5 A=INT(RND(1)*10)
6 T=0
7 N=0
15 PRINT "YOU HAVE ACTIVATED THE SELF-DESTRUCT MECHANISM ";
20 PRINT "IN THIS SCHOOL."
25 PRINT "IF YOU WISH, YOU MAY STOP THE MECHANISM."
27 PRINT "TO DO SO, JUST TYPE IN THE CORRECT NUMBER,"
35 PRINT "WHICH WILL STOP THE COUNT-DOWN."
37 PRINT "PLEASE HURRY!! THERE IS NO TIME TO WASTE!!!!!!!"
44 PRINT "WHAT'LL IT BE";:INPUT X:PRINT
45 IF T=4 THEN 98
47 GOTO 200
50 REM
75 PRINT "YOUR NUMBER DOES NOT COMPUTE!!"
80 PRINT "PLEASE TRY AGAIN!!!!":T=T+1
81 IF T=2 THEN 96
82 IF T=3 THEN 105
83 GOTO 44
85 PRINT "CORRECT!!!!":LET N=5
90 PRINT "THE COUNTDOUN HAS STOPPED."
92 PRINT "YOU HAVED SAVED THE SCHOOL!"
93 PRINT "(HAVE YOU SEEN YOUR SHRINK LATELY ?)"
94 LET T=10
95 GOTO 1000
96 PRINT "TIME GROWS SHORT, PLEASE HURRY!!!!!!!!"
97 GOTO 44
98 PRINT:PRINT:PRINT:PRINT
99 PRINT TAB(32);"TOO LATE"
100 PRINT:PRINT:PRINT:PRINT TAB(32);"\ **** /"
101 PRINT TAB(31);"-- BOOM --"
102 PRINT TAB(32);"/ **** \"
103 PRINT:PRINT:PRINT
104 GOTO 1000
105 PRINT "HURRY, THE COUNT-DOWN IS APPROACHING ZERO!!!!!!!!!"
110 GOTO 44
200 IF X<A THEN PRINT "TOO SMALL!!!!!":GOTO 50
210 IF X>A THEN PRINT "TOO BIG!!!!!":GOTO 50
225 IF X=A THEN 85
1000 END
