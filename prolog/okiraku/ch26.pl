%chapter 26.
%$Id: mulk/prolog ch26.pl 1517 2026-01-11 Sun 16:38:13 kt $

neighbor(a,b). neighbor(a,f). neighbor(a,e).
neighbor(b,f). neighbor(b,c). neighbor(c,d).
neighbor(c,g). neighbor(e,f). neighbor(e,h).
neighbor(f,g). neighbor(f,i). neighbor(f,j).
neighbor(g,j). neighbor(h,i). neighbor(i,j).
neighbor(j,k).

next(X,Y):-neighbor(X,Y).
next(X,Y):-neighbor(Y,X).

enqueue(Item,[Qh,[Item|Qt]],[Qh,Qt]).
dequeue(Item,[[Item|Qh],Qt],[Qh,Qt]).
empty([X,Y]):-X==Y.

add_path(_,_,[],Q,Q).
add_path(Goal,Path,[Goal|Rest],Q,Qe):-
	reverse([Goal|Path],NewPath),writeln(NewPath),!,
	add_path(Goal,Path,Rest,Q,Qe).
add_path(Goal,Path,[Next|Rest],Q,Qe):-
	if(member(Next,Path),Qn=Q,enqueue([Next|Path],Q,Qn)),
	add_path(Goal,Path,Rest,Qn,Qe).
	
breadth_first_search(Goal,Q):-
	not(empty(Q)),
	dequeue([Node|Path],Q,Q1),
	findall(Next,next(Node,Next),NextList),
	add_path(Goal,[Node|Path],NextList,Q1,Q2),
	breadth_first_search(Goal,Q2).
	
keiro(Start,Goal):-
	enqueue([Start],[Q,Q],Qn),breadth_first_search(Goal,Qn).
	
