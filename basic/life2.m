life for two
$Id: mulk/basic life2.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
LIFE2 is based on Conway's game of Life.

There are two players; the game is played on a 5x5 board and each player has a symbol to represent his own pices of 'life'.
Live cells belonging to player 1 are represented by '*' and  live cells belonging to player 2 are represented by the symbol '#'

The # and * are regarded as the same except when deciding whether to generate a live cell.
An empty cell having two '#' and one '*' are neighbors will generate a '#', i.e. the live cell generated belongs to the player who has the majority of the 3 live cells surrounding the empty cell where life is to be generated.

On the first move each player positions 3 pieces of life on the board by thping in the co-ordinates of the pieces.
In the event of the same cell belong chosen by both players that cell is left empty.

The board is then adjusted to the next generation and printed out.

On each subsequent turn each player places one piece on the board, the object being to annihilate his opponent's pieces.
The board is adjusted for the next generation and printed out after both players have entered their new piece.

The game continues until one player has no more live pieces.
The computer will then print out the board and declare the winner.
.caption ORIGIN
Basic computer games micro computer edition.
.
source from http://www.classicbasicgames.org/
.caption AUTHOR
Brian Wybill, Bradford University, Yorkshire, England.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.life2
**Cmd.life2 >> main: args
	Basic new breakFor run: #Cmd.life2.source
	
*->Cmd.life2.source
2 PRINT TAB(33);"LIFE2"
4 PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
6 PRINT: PRINT: PRINT
7 DIM N(6,6),K(18),A(16),X(2),Y(2)
8 DATA 3,102,103,120,130,121,112,111,12
9 DATA 21,30,1020,1030,1011,1021,1003,1002,1012
10 FOR M=1 TO 18: READ K(M): NEXT M
13 DATA -1,0,1,0,0,-1,0,1,-1,-1,1,-1,-1,1,1,1
14 FOR O1= 1 TO 16: READ A(O1): NEXT O1
20 GOTO 500
50 FOR J=1 TO 5
51 FOR K=1 TO 5
55 IF N(J,K)>99 THEN GOSUB 200
60 NEXT K
65 NEXT J
90 K=0: M2=0: M3=0
99 FOR J=0 TO 6: PRINT
100 FOR K=0 TO 6
101 IF J<>0 THEN IF J<>6 THEN 105
102 IF K=6 THEN PRINT 0;: GOTO 125
103 PRINT K;: GOTO 120
105 IF K<>0 THEN IF K<>6 THEN 110
106 IF J=6 THEN PRINT 0: GOTO 126
107 PRINT J;: GOTO 120
110 GOSUB 300
120 NEXT K
125 NEXT J
126 RETURN
200 B=1: IF N(J,K)>999 THEN B=10
220 FOR O1= 1 TO 15 STEP 2
230 N(J+A(O1),K+A(O1+1))=N(J+A(O1),K+A(O1+1))+B
231 NEXT O1
239 RETURN
300 IF N(J,K)<3 THEN 399
305 FOR O1=1 TO 18
310 IF N(J,K)=K(O1) THEN 350
315 NEXT O1
320 GOTO 399
350 IF O1>9 THEN 360
351 N(J,K)=100: M2=M2+1: PRINT " * ";
355 RETURN
360 N(J,K)=1000: M3=M3+1: PRINT " # ";
365 RETURN
399 N(J,K)=0: PRINT "   ";: RETURN
500 PRINT TAB(10);"U.B. LIFE GAME"
505 M2=0: M3=0
510 FOR J=1 TO 5
511 FOR K=1 TO 5
515 N(J,K)=0
516 NEXT K
517 NEXT J
519 FOR B=1 TO 2: P1=3: IF B=2 THEN P1=30
520 PRINT:PRINT "PLAYER";B;" - 3 LIVE PIECES."
535 FOR K1=1 TO 3: GOSUB 700
540 N(X(B),Y(B))=P1: NEXT K1
542 NEXT B
559 GOSUB 90
560 PRINT: GOSUB 50
570 IF M2=0 THEN IF M3=0 THEN 574
571 IF M3=0 THEN B=1: GOTO 575
572 IF M2=0 THEN B=2: GOTO 575
573 GOTO 580
574 PRINT: PRINT "A DRAW":GOTO 800
575 PRINT: PRINT "PLAYER";B;"IS THE WINNER":STOP
580 FOR B=1 TO 2: PRINT: PRINT: PRINT "PLAYER";B;: GOSUB 700
581 IF B=99 THEN 560
582 NEXT B
586 N(X(1),Y(1))=100: N(X(2),Y(2))=1000
596 GOTO 560
700 PRINT "X,Y":PRINT"XXXXXX";CHR$(13);"$$$$$$";CHR$(13);"&&&&&&";
701 PRINT CHR$(13);: INPUT Y(B),X(B)
705 IF X(B)<=5 THEN IF X(B)>0 THEN 708
706 GOTO 750
708 IF Y(B)<=5 THEN IF Y(B)>0 THEN 715
710 GOTO 750
715 IF N(X(B),Y(B))<>0 THEN 750
720 IF B=1 THEN RETURN
725 IF X(1)=X(2) THEN IF Y(1)=Y(2) THEN 740
730 RETURN
740 PRINT "SAME COORD.  SET TO 0"
741 N(X(B)+1,Y(B)+1)=0: B=99: RETURN
750 PRINT "ILLEGAL COORDS. RETYPE": GOTO 700
999 END
