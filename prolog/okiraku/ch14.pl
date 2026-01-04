%chapter 14.
%$Id: mulk/prolog ch14.pl 1502 2025-12-26 Fri 21:44:22 kt $
ticket(Age,Money) :- Age < 13, Money is 500, !.
ticket(Age,Money) :- Money is 1000.

take_integer([X|Xs],Ys):-take_integer(X,Ys1),take_integer(Xs,Ys2),append(Ys1,Ys2,Ys),!.
take_integer(X,[X]):-integer(X),!.
take_integer(X,[]).

remove(X,[],[]).
remove(X,[X|Xs],Zs):-remove(X,Xs,Zs).
remove(X,[Y|Ys],[Y|Zs]):-X\=Y,remove(X,Ys,Zs).
