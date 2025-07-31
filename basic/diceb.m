simulates rolling a pair of dice
$Id: mulk/basic diceb.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	diceb
.caption DESCRIPTION
Not exactly a game, this program simulates rolling a pair of dice a large number of times and prints out the frequence distribution.
.caption ORIGIN
Basic computer games micro computer edition.
.
source from http://www.classicbasicgames.org/
.caption AUTHOR
Daniel Freidus, Harrison, New York.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.diceb
**Cmd.diceb >> main: args
	Basic new run: #Cmd.diceb.source
	
*->Cmd.diceb.source
2 PRINT TAB(34);"DICE"
4 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
6 PRINT:PRINT:PRINT
10 DIM F(12)
20 REM  DANNY FREIDUS
30 PRINT "THIS PROGRAM SIMULATES THE ROLLING OF A"
40 PRINT "PAIR OF DICE."
50 PRINT "YOU ENTER THE NUMBER OF TIMES YOU WANT THE COMPUTER TO"
60 PRINT "'ROLL' THE DICE.  WATCH OUT, VERY LARGE NUMBERS TAKE"
70 PRINT "A LONG TIME.  IN PARTICULAR, NUMBERS OVER 5000."
80 FOR Q=1 TO 12
90 F(Q)=0
100 NEXT Q
110 PRINT:PRINT "HOW MANY ROLLS";
120 INPUT X
130 FOR S=1 TO X
140 A=INT(6*RND(1)+1)
150 B=INT(6*RND(1)+1)
160 R=A+B
170 F(R)=F(R)+1
180 NEXT S
185 PRINT
190 PRINT "TOTAL SPOTS","NUMBER OF TIMES"
200 FOR V=2 TO 12
210 PRINT V,F(V)
220 NEXT V
221 PRINT
222 PRINT:PRINT "TRY AGAIN";
223 INPUT Z$
224 IF Z$="YES" THEN 80
240 END
