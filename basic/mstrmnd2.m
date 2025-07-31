master mind 2
$Id: mulk/basic mstrmnd2.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	mstrmnd2
.caption DESCRIPTION
This is master mind of 6 colors 4 positions.

When you enter a color combination, the computer will give a hint peg:
	black -- color is correct but in the wrong position.
	white -- color and position is correct.
If you answer correctly in 10 trials, you win.
.lineBreak
The program offers the user two options, QUIT and BOARD, which may be entered at any time after the first move.
QUIT instructs the program that you are fed up with playing Mastermind for the time being and wish to terminate the session.
BOARD instructs the program to print out a summary of the moves prior to the time that the BOARD command was issued, including the guesses and key pegs awarded for each frame.
.caption ORIGIN
More basic computer games.
.
source from https://www.roug.org/
.caption AUTHOR
David G. Struble, University of Dayton.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.mstrmnd2
**Cmd.mstrmnd2 >> main: args
	Basic new breakFor implicitDeclareArray run: #Cmd.mstrmnd2.source
	
*->Cmd.mstrmnd2.source
10 PRINT TAB(24);"MASTERMIND"
20 PRINT TAB(20);"CREATIVE COMPUTING"
30 PRINT TAB(18);"MORRISTOWN, NEW JERSEY"
40 PRINT:PRINT:PRINT
100 PRINT "THE GAME OF MASTERMIND"
110 PRINT
130 PRINT "COLOR CODES:"
140 PRINT "               R=RED     O=ORANGE     Y=YELLOW"
150 PRINT "               G=GREEN   B=BLUE       P=PURPLE"
160 PRINT
170 DIM B$(10),Y(10),Z(10)
180 C(0)=4
190 FOR N=1 TO 4
200 C(N)=INT(6*RND(1)+1)
210 NEXT N
220 FOR N=1 TO 4
230 X=C(N)
240 GOSUB 730
250 C(N)=X
260 NEXT N
270 P$=""
273 FOR X1=1 TO 4
275 P$=P$+CHR$(C(X1))
277 NEXT X1
280 FOR P=1 TO 10
290 PRINT
300 PRINT "MOVE NUMBER";P;
310 INPUT G$
320 IF G$= "BOARD" THEN 910
330 IF G$="QUIT" THEN 440
340 B$(P)=G$
350 GOSUB 520
360 IF B=4 THEN 1010
370 GOSUB 600
380 PRINT B;" BLACK PEGS"
390 Y(P)=B
400 PRINT W;" WHITE PEGS"
410 Z(P)=W
420 NEXT P
430 PRINT "SORRY, YOU LOSE"
440 PRINT "THE CORRECT CODE WAS:";P$
450 PRINT "WANT TO PLAY AGAIN";
460 INPUT A$
480 IF A$="YES" THEN 190
490 PRINT
500 END
510 REM COMPUTE BLACK PEGS
520 FOR X1=1 TO 4
523 G(X1)=ASC(MID$(G$,X1,1))
525 NEXT X1
530 B=0
540 FOR K=1 TO 4
550 IF G(K) <> C(K) THEN 570
560 B=B+1
570 NEXT K
580 RETURN
590 REM COMPUTE WHITE PEGS
600 FOR X1=1 TO 4
603 R(X1)=ASC(MID$(P$,X1,1))
605 NEXT X1
610 W=0
620 FOR I=1 TO 4
630 FOR J=1 TO 4
640 IF G(I) <> R(J) THEN 680
650 W=W+1
660 R(J)=0
670 GOTO 690
680 NEXT J
690 NEXT I
700 W=W-B
710 RETURN
720 REM TRANSLATE COLOR CODES TO NUMERICS
730 IF X <> 1 THEN 760
740 X=89
750 RETURN
760 IF X <> 2 THEN 790
770 X=82
780 RETURN
790 IF X <> 3 THEN 820
800 X=80
810 RETURN
820 IF X <> 4 THEN 850
830 X=79
840 RETURN
850 IF X <> 5 THEN 880
860 X=71
870 RETURN
880 X=66
890 RETURN
900 REM PRINT BOARD SUMMARY
910 V=P-1
920 PRINT "GUESS","BLACKS","WHITES"
930 PRINT "-----","------","------"
960 FOR I=1 TO V
970 PRINT B$(I),Y(I),Z(I)
990 NEXT I
1000 GOTO 290
1010 PRINT "YOU WIN!!"
1020 GOTO 450
9999 END
