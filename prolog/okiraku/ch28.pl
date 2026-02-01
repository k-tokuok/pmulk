%chapter 28.
%$Id: mulk/prolog ch28.pl 1521 2026-01-13 Tue 06:01:14 kt $

selects([],Ys).
selects([X|Xs],Ys):-select(X,Ys,Ys1),selects(Xs,Ys1).

make_next(Colors):-selects([A,B],Colors),assert(next(A,B)),fail.

color_map(A,B,C,D,E,F):-
	not(make_next([red,blue,yellow,green])),
	next(A,B), next(A,C), next(A,D),
	next(B,C), next(B,E),
	next(C,D), next(C,E), next(C,F),
	next(D,F),
	next(E,F).
	
