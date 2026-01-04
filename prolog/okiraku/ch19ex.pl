%chapter 19. exercise.
%$Id: mulk/prolog ch19ex.pl 1507 2025-12-31 Wed 20:58:41 kt $

%1
insert_item(X,[Y|Ys],[X,Y|Ys]):-X<=Y,!.
insert_item(X,[Y|Ys],[Y|Zs]):-insert_item(X,Ys,Zs).
insert_item(X,[],[X]).

%2
insert_sort([X|Xs],Ys):-insert_sort(Xs,Zs),insert_item(X,Zs,Ys).
insert_sort([],[]).

%3
merge_list([X|Xs],[Y|Ys],[X|Zs]):-X<=Y,!,merge_list(Xs,[Y|Ys],Zs).
merge_list([X|Xs],[Y|Ys],[Y|Zs]):-merge_list([X|Xs],Ys,Zs).
merge_list([],Ys,Ys).
merge_list(Xs,[],Xs).

%4
drop([_|Xs],N,Ys):-N>0, N1 is N-1, drop(Xs,N1,Ys).
drop(Xs,0,Xs).

merge_sort(N,Xs,Ys):-
	N>1,
	M1 is N//2,
	merge_sort(M1,Xs,Zs1),
	M2 is N-M1,
	drop(Xs,M1,Xs1),
	merge_sort(M2,Xs1,Zs2),
	merge_list(Zs1,Zs2,Ys).
merge_sort(1,[X|_],[X]).
merge_sort(_,[],[]).

merge_sort(Xs,Ys):-length(Xs,N),merge_sort(N,Xs,Ys).
