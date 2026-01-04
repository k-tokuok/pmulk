%chapter 20. exercise.
%$Id: mulk/prolog ch20ex.pl 1507 2025-12-31 Wed 20:58:41 kt $

%1
permutation(N,Xs,[X|Ys]):-N>0, N1 is N-1, select(X,Xs,Zs),
	permutation(N1,Zs,Ys).
permutation(0,_,[]).

%2
combination(N,[X|Xs],[X|Ys]):-N>0, N1 is N-1, combination(N1,Xs,Ys).
combination(N,[_|Xs],Ys):-N>0, combination(N,Xs,Ys).
combination(0,_,[]).

%3
repeat_perm(N,Xs,[X|Ys]):-N>0, N1 is N-1, member(X,Xs), repeat_perm(N1,Xs,Ys).
repeat_perm(0,_,[]).

%4
repeat_comb(N,[X|Xs],[X|Ys]):-N>0, N1 is N-1, repeat_comb(N1,[X|Xs],Ys).
repeat_comb(N,[_|Xs],Ys):-N>0, repeat_comb(N,Xs,Ys).
repeat_comb(0,_,[]).
