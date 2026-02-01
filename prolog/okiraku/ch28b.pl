%chapter 28. 隣接リスト版
%$Id: mulk/prolog ch28b.pl 1521 2026-01-13 Tue 06:01:14 kt $

neighbor(a,[b,c,d]).
neighbor(b,[a,c,e]).
neighbor(c,[a,b,d,e,f]).
neighbor(d,[a,c,f]).
neighbor(e,[b,c,f]).
neighbor(f,[c,d,e]).

color(red).
color(blue).
color(yellow).
color(green).

check(C,[],Alist).
check(C,[Region|Rest],Alist):-
	not(member([Region,C],Alist)),
	check(C,Rest,Alist).
	
color_map1([],Alist):-writeln(Alist),!.
color_map1([Region|Rest],Alist):-
	neighbor(Region,Neighbors),
	color(C),
	check(C,Neighbors,Alist),
	color_map1(Rest,[[Region,C]|Alist]).
	
