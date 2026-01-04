%chapter 25.
%$Id: mulk/prolog ch25.pl 1514 2026-01-04 Sun 17:31:43 kt $

neighbor(a,b). neighbor(a,f). neighbor(a,e).
neighbor(b,f). neighbor(b,c). neighbor(c,d).
neighbor(c,g). neighbor(e,f). neighbor(e,h).
neighbor(f,g). neighbor(f,i). neighbor(f,j).
neighbor(g,j). neighbor(h,i). neighbor(i,j).
neighbor(j,k).

next(X,Y):-neighbor(X,Y).
next(X,Y):-neighbor(Y,X).

extend_one_path(N,Goal,[Goal|Node]):-
	reverse([Goal|Node],Path),writeln(Path),!,fail.
extend_one_path(N,Goal,[Node|Rest]):-
	next(Node,Next),
	not(member(Next,Rest)),
	assert(path(N,[Next,Node|Rest])),
	fail.
	
extend_path(N,Goal):-path(N,Path), N1 is N+1,extend_one_path(N1,Goal,Path).

breadth_first_search(N,Goal):-
	not(extend_path(N,Goal)),
	N1 is N+1,
	path(N1,Path),
	!,
	breadth_first_search(N1,Goal).
	
keiro(Start,Goal):-
	abolish(path,2),
	assert(path(1,[Start])),
	breadth_first_search(1,Goal).
	
%backtrackable.
extend_one_path(N,Goal,[Goal|Node],Ans):-reverse([Goal|Node],Ans).
extend_one_path(N,Goal,[Node|Rest],Ans):-
	next(Node,Next),
	not(member(Next,Rest)),
	assert(path(N,[Next,Node|Rest])),
	fail.
	
extend_path(N,Goal,Ans):-
	path(N,Path), N1 is N+1, extend_one_path(N1,Goal,Path,Ans).
	
breadth_first_search(N,Goal,Ans):-extend_path(N,Goal,Ans).
breadth_first_search(N,Goal,Ans):-
	N1 is N+1,path(N1,Path),!,breadth_first_search(N1,Goal,Ans).
	
keiro(Start,End,Ans):-
	abolish(path,2),
	assert(path(1,[Start])),
	breadth_first_search(1,End,Ans).
