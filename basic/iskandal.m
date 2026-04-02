iskandall's tofu shop
$Id: mulk/basic iskandal.m 1565 2026-03-27 Fri 22:05:44 kt $
#ja イスカンダルのトーフ屋

*[man]
**#en
.caption SYNOPSIS
	iskandal
.caption DESCRIPTION
You and the computer will run a tofu shop (though it doesn't have to be a tofu shop).
At the start, you both have 5,000 yen each.
You use that money to make tofu, sell it, and make a profit.
The first person to exceed 20,000 yen wins.
However, each piece of tofu sells for 25 yen, and the cost of production is 15 yen.
Sales of this tofu are heavily influenced by the weather.
Specifically, you can sell up to 500 pieces on a sunny day, 200 on a cloudy day, and 100 on a rainy day.
Therefore, players must check the weather forecast carefully to decide how many pieces to make for the next day.
.caption ORIGIN
ASCII Monthly, June 1978 Issue.
.caption AUTHOR
Nobuhide Tsuda

Copyright (C) 1978 N. Tsuda.
**#ja
.caption 書式
	iskandal
.caption 説明
マイコンとあなたがトーフ屋(べつにトーフ屋にはかぎらないが)をします。
始めは2人共5000円ずつもっていて、それでトーフをつくり、うって、お金をもうけ、早く20000円を越した方が勝ちとなります。
ただし、トーフは1個25円で原価は15円です。
そしてこのトーフの売り上げは天気に大きく影響されます。
つまり晴れると500個、くもりだと200個、雨が降ると100個まで、それぞれ売れます。
それでプレイヤーは、天気予報をよくみて次の日に何個つくるか決めるのです。
.caption 出典
月刊ASCII 1978年6月号
.caption 作者
津田伸秀

Copyright (C) 1978 by N. Tsuda.

*entry.@
	Mulk import: "basic";
	Object addSubclass: #Cmd.iskandal
**Cmd.iskandal >> main: args
	Basic new run: #Cmd.iskandal.source
	
*->Cmd.iskandal.source
10 X=5000
20 Y=5000
30 GOTO 400
100 PRINT
103 PRINT "***** WEATHER FORECAST *****"
110 GOSUB 900
120 P=A
125 GOSUB 900
130 IF P>A THEN R=A
140 IF P<=A THEN R=P
150 Q=ABS(A-P)
155 P=100-Q-R
160 PRINT "THE PROBABILITY OF  FINE IS ";P;"%"
170 PRINT "                   CLOUD IS ";Q;"%"
180 PRINT "                    RAIN IS ";R;"%"
190 PRINT X;"/15=";INT(X/15)
200 PRINT "HOW MANY DO YOU MAKE ?"
205 INPUT N
210 IF N*15<=X THEN GOTO 230
220 PRINT "SORRY, YOU MAKE ONLY ";X
225 GOTO 200
230 IF R<40 THEN GOTO 240
233 M=100
236 GOTO 290
240 IF Q>=40-R THEN GOTO 270
250 M=500
260 IF Y<7500 THEN M=INT(Y/15)
265 GOTO 290
270 IF Y<3000 THEN GOTO 260
280 M=200
290 PRINT "I MAKE ";M
295 GOSUB 800
300 PRINT "----- NEXT DAY -----"
305 GOSUB 800
310 GOSUB 900
320 IF A<=P THEN GOTO 500
330 IF A<=P+Q THEN GOTO 600
340 PRINT "IT IS RAIN."
350 GOSUB 800
355 IF N>=100 THEN T=100
360 IF N<100 THEN T=N
370 PRINT "YOU SOLD ";T
380 PRINT " I  SOLD  100"
390 X=X+T*25-N*15
395 Y=Y+2500-M*15
400 PRINT "NOW YOU HAVE ";X
410 PRINT " AND I  HAVE ";Y
420 IF X>=20000 THEN GOTO 450
430 IF Y<20000 THEN GOTO 100
440 PRINT "SORRY, I WIN."
445 END
450 IF Y>=20000 THEN GOTO 470
460 PRINT "GOOD, YOU WIN."
465 END
470 IF X>Y THEN GOTO 460
480 IF X<Y THEN GOTO 440
490 PRINT "THIS IS A DRAW GAME."
495 END
500 PRINT "IT IS FINE."
505 GOSUB 800
510 IF N>=500 THEN T=500
520 IF N<500 THEN T=N
530 PRINT "YOU SOLD ";T
540 PRINT " I  SOLD ";M
550 X=X+T*25-N*15
560 Y=Y+10*M
570 GOTO 400
600 PRINT "IT IS CLOUD."
610 IF N>=200 THEN T=200
620 IF N<200 THEN T=N
630 IF M>=200 THEN S=200
640 IF M<200 THEN S=M
650 PRINT "YOU SOLD ";T
660 PRINT " I  SOLD ";S
670 X=X+25*T-15*N
680 Y=Y+25*S-15*M
690 GOTO 400
800 FOR I=1 TO 50
810 A=A*1
820 NEXT I
830 RETURN
900 A=INT(RND(0)*32700)
910 A=A-INT(A/100)*100+1
920 RETURN
