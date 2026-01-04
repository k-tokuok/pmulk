%chapter 11. exercise.
%$Id: mulk/prolog ch11ex.pl 1502 2025-12-26 Fri 21:44:22 kt $

%1.
copylist([X|Xs],[X|Ys]):-copylist(Xs,Ys).
copylist([],[]).

%2.
sumlist([X|Xs],A):-sumlist(Xs,A1),A is A1+X.
sumlist([],0).

%3
maxlist([X|Xs],A):-maxlist(Xs,A),X<A.
maxlist([X|Xs],X):-maxlist(Xs,A),X>=A.
maxlist([X],X).

%4
minlist([X|Xs],A):-minlist(Xs,A),X>=A.
minlist([X|Xs],X):-minlist(Xs,A),X<A.
minlist([X],X).
