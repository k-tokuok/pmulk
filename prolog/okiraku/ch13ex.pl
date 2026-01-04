%chapter 13. exercise.
%$Id: mulk/prolog ch13ex.pl 1502 2025-12-26 Fri 21:44:22 kt $

%1
position(X,[X|_],I,I).
position(X,[Y|Xs],I,N):-X\==Y, I1 is I+1, position(X,Xs,I1,N).
position(X,Xs,N):-position(X,Xs,1,N).

%2
count(X,[X|Xs],N):-count(X,Xs,N1), N is N1+1.
count(X,[Y|Xs],N):-X\==Y, count(X,Xs,N).
count(_,[],0).

%3
substitute(X,Y,[X|Xs],[Y|Ys]):-substitute(X,Y,Xs,Ys).
substitute(X,Y,[Z|Xs],[Z|Ys]):-X\==Z, substitute(X,Y,Xs,Ys).
substitute(_,_,[],[]).

%4
count_leaf([X|Xs],N):-count_leaf(X,A),count_leaf(Xs,B),N is A+B.
count_leaf(X,1):-X\==[], atomic(X).
count_leaf([],0).

%5
subst(X,Y,X,Y).
subst(X,Y,[L1|R1],[L2|R2]):-X\==[L1|R1],subst(X,Y,L1,L2),subst(X,Y,R1,R2).
subst(X,_,Z,Z):-X\==Z,atomic(Z).
