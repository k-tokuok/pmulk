%chapter 12.
%$Id: mulk/prolog ch12.pl 1499 2025-12-21 Sun 21:11:23 kt $

my_member(X,[X|Ls]).
my_member(X,[Y|Ls]):-my_member(X,Ls).

my_select(X,[X|Xs],Xs).
my_select(X,[Y|Ys],[Y|Zs]):-my_select(X,Ys,Zs).

selects([],Ys).
selects([X|Xs],Ys):-my_select(X,Ys,Ys1),selects(Xs,Ys1).
