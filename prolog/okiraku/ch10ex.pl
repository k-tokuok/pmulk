%chapter 10. exercise.
%$Id: mulk/prolog ch10ex.pl 1502 2025-12-26 Fri 21:44:22 kt $

%1.
make_list(N,X,[X|Ys]):-N>0, N1 is N-1, make_list(N1,X,Ys).
make_list(0,_,[]).

%2
iota(S,E,[S|Xs]):-S < E, S1 is S+1, iota(S1,E,Xs).
iota(S,S,[S]).

%3
take([X|Xs],N,[X|Ys]):-N>0, N1 is N-1, take(Xs,N1,Ys).
take(_,0,[]).

%4
drop([_|Xs],N,Ys):-N>0, N1 is N-1, drop(Xs,N1,Ys).
drop(Xs,0,Xs).

%5
my_last([X],X).
my_last([X|Xs],Y):-my_last(Xs,Y).
