%chapter 13.
%$Id: mulk/prolog ch13.pl 1502 2025-12-26 Fri 21:44:22 kt $

my_flatten([X|Xs],Ys):-my_flatten(X,Ys1),my_flatten(Xs,Ys2),append(Ys1,Ys2,Ys).
my_flatten(X,[X]):-atomic(X),X\==[].
my_flatten([],[]).
