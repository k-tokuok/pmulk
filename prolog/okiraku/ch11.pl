%chapter 11.
%$Id: mulk/prolog ch11.pl 1497 2025-12-20 Sat 09:23:52 kt $
my_length([X|Xs],N):-my_length(Xs,N1), N is N1+1.
my_length([],0).

my_append([X|Ls],Ys,[X|Zs]):-my_append(Ls,Ys,Zs).
my_append([],Xs,Xs).

my_reverse([X|Xs],Ys):-my_reverse(Xs,Zs),append(Zs,[X],Ys).
my_reverse([],[]).
