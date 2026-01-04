%chapter 18. exercise.
%$Id: mulk/prolog ch18ex.pl 1506 2025-12-30 Tue 21:11:19 kt $

%1
combination_number(N,N,1):-!.
combination_number(_,0,1):-!.
combination_number(N,R,C):-
	R>0, R1 is R-1, combination_number(N,R1,C1),C is C1*(N-R+1)//R.
	
%2
pascal_sub([X,Y|Xs],[Z|Ys]):-Z is X+Y,pascal_sub([Y|Xs],Ys).
pascal_sub([1],[1]).

pascal(N,Xs):-N>0,pascal_sub([0|Xs],Ys),writeln(Ys),N1 is N-1,pascal(N1,Ys).
pascal(0,_).

pascal(N):-writeln([1]),pascal(N,[1]).
