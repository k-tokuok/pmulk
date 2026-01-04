%chapter 24.
%$Id: mulk/prolog ch24.pl 1513 2026-01-03 Sat 20:59:52 kt $

neighbor(a,b). neighbor(a,f). neighbor(a,e).
neighbor(b,f). neighbor(b,c). neighbor(c,d).
neighbor(c,g). neighbor(e,f). neighbor(e,h).
neighbor(f,g). neighbor(f,i). neighbor(f,j).
neighbor(g,j). neighbor(h,i). neighbor(i,j).
neighbor(j,k).

next(X,Y):-neighbor(X,Y).
next(X,Y):-neighbor(Y,X).

depth_first_search(End,End,Path):-
	reverse([End|Path],Path1), writeln(Path1),!,fil.
depth_first_search(Node,End,Path):-
	not(member(Node,Path)),
	next(Node,Next),
	depth_first_search(Next,End,[Node|Path]).
	
depth_first_search(End,End,Path,Ans):-reverse([End|Path],Ans).
depth_first_search(Node,End,Path,Ans):-
	not(member(Node,Path)),
	next(Node,Next),
	depth_first_search(Next,End,[Node|Path],Ans).
