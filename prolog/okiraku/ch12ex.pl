%chapter 12. exercise.
%$Id: mulk/prolog ch12ex.pl 1502 2025-12-26 Fri 21:44:22 kt $

%1
product_sub(X,[Y|_],[X,Y]).
product_sub(X,[_|Ys],Zs):-product_sub(X,Ys,Zs).

product([X|_],Ys,Zs):-product_sub(X,Ys,Zs).
product([_|Xs],Ys,Zs):-product(Xs,Ys,Zs).

%2
power_set([X|Xs],[X|Ys]):-power_set(Xs,Ys).
power_set([_|Xs],Ys):-power_set(Xs,Ys).
power_set([],[]).

%3
my_prefix([X|Xs],[X|Ys]):-my_prefix(Xs,Ys).
my_prefix([],_).

%4
suffix(Xs,[_|Ys]):-suffix(Xs,Ys).
suffix(Xs,Xs).
