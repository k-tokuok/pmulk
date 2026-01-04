%chapter 14. exercise.
%$Id: mulk/prolog ch14ex.pl 1502 2025-12-26 Fri 21:44:22 kt $

%1
change(N,fizzbuzz):-0 is N mod 15,!.
change(N,fizz):-0 is N mod 3,!.
change(N,buzz):-0 is N mod 5,!.
change(N,N).

fizzbuzz(N):-N<=100,change(N,S),write(S),write(" "),N1 is N+1,fizzbuzz(N1).
fizzbuzz(N):-N>100,nl.

%2
remove_dup([X|Xs],Ys):-remove_dup(Xs,Ys),member(X,Ys),!.
remove_dup([X|Xs],[X|Ys]):-remove_dup(Xs,Ys).
remove_dup([],[]).

%3
set_union([X|Xs],Ys,Zs):-member(X,Ys),!,set_union(Xs,Ys,Zs).
set_union([X|Xs],Ys,[X|Zs]):-set_union(Xs,Ys,Zs).
set_union([],Ys,Ys).

%4
set_intersect([X|Xs],Ys,[X|Zs]):-member(X,Ys),!,set_intersect(Xs,Ys,Zs).
set_intersect([_|Xs],Ys,Zs):-set_intersect(Xs,Ys,Zs).
set_intersect([],_,[]).

%5
set_difference([X|Xs],Ys,Zs):-member(X,Ys),!,set_difference(Xs,Ys,Zs).
set_difference([X|Xs],Ys,[X|Zs]):-set_difference(Xs,Ys,Zs).
set_difference([],_,[]).
