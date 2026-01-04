%chapter 19.
%$Id: mulk/prolog ch19.pl 1507 2025-12-31 Wed 20:58:41 kt $

quicksort([X|Xs],Ys):-
	partition(Xs,X,L,B),
	quicksort(L,Ls),
	quicksort(B,Bs),
	append(Ls,[X|Bs],Ys).
quicksort([],[]).

partition([X|Xs],Y,[X|Ls],Bs):-X<=Y,partition(Xs,Y,Ls,Bs).
partition([X|Xs],Y,Ls,[X|Bs]):-X>Y,partition(Xs,Y,Ls,Bs).
partition([],_,[],[]).

quicksort1(Xs,Ys):-quick_sub(Xs,[Ys,[]]).
quick_sub([X|Xs],[Ys,Zs]):-
	partition(Xs,X,L,B),
	quick_sub(L,[Ys,[X|Ys1]]),
	quick_sub(B,[Ys1,Zs]).
quick_sub([],[Xs,Xs]).
