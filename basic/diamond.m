draw diamond pattern
$Id: mulk/basic diamond.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS 
	diamond
.caption DESCRIPTION
Fills an 8-1/2x11 piece of paper with diamonds (plotted on a hard-copy terminal, of course).
.caption ORIGIN
Basic computer games micro computer edition.
.
source from http://www.classicbasicgames.org/
.caption AUTHOR
David Ahl, Creative Computing

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.diamond
**Cmd.diamond >> main: args
	Basic new breakFor run: #Cmd.diamond.source
	
*->Cmd.diamond.source
1 PRINT TAB(33);"DIAMOND"
2 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
3 PRINT:PRINT:PRINT
4 PRINT "FOR A PRETTY DIAMOND PATTERN,"
5 INPUT "TYPE IN AN ODD NUMBER BETWEEN 5 AND 21";R:PRINT
6 Q=INT(60/R):A$="CC"
8 FOR L=1 TO Q
10 X=1:Y=R:Z=2
20 FOR N=X TO Y STEP Z
25 PRINT TAB((R-N)/2);
28 FOR M=1 TO Q
29 C=1
30 FOR A=1 TO N
32 IF C>LEN(A$) THEN PRINT "!";:GOTO 50
34 PRINT MID$(A$,C,1);
36 C=C+1
50 NEXT A
53 IF M=Q THEN 60
55 PRINT TAB(R*M+(R-N)/2);
56 NEXT M
60 PRINT
70 NEXT N
83 IF X<>1 THEN 95
85 X=R-2:Y=1:Z=-2
90 GOTO 20
95 NEXT L
99 END
