%chapter 23.
%$Id: mulk/prolog ch23.pl 1509 2026-01-02 Fri 07:40:29 kt $

count_bulls_sub([],[],C,C).
count_bulls_sub([X1|L1],[X2|L2],N,C):-
	if(X1=X2,N1 is N+1,N1=N),
	count_bulls_sub(L1,L2,N1,C).
	
count_bulls(Correct,Data,C):-count_bulls_sub(Correct,Data,0,C).

count_same_sub([],_,C,C).
count_same_sub([X|L],Data,N,C):-
	if(member(X,Data),N1 is N+1,N1=N),
	count_same_sub(L,Data,N1,C).
	
count_same_number(Correct,Data,C):-count_same_sub(Correct,Data,0,C).

check_numbers([]).
check_numbers([N|Rest]):-
	integer(N),
	0<=N, N<=9,
	not(member(N,Rest)),
	check_numbers(Rest).
	
input_numbers(Numbers):-
	repeat,
	read(Numbers),
	length(Numbers,4),
	check_numbers(Numbers),
	!.

selects([],_).
selects([X|Xs],Ys):-select(X,Ys,Ys1),selects(Xs,Ys1).

guess(Code):-
	selects([X1,X2,X3,X4],[0,1,2,3,4,5,6,7,8,9]),
	Code=[X1,X2,X3,X4].
	
check(Code):-
	query(OldCode,Bulls,Cows),
	count_bulls(OldCode, Code, Bulls1),
	count_same_number(OldCode, Code, N),
	Cows1 is N-Bulls1,
	or(Bulls \= Bulls1, Cows \= Cows1).
	
cleanup:-abolish(query,3).

ask(Correct,Code):-
	count_bulls(Correct, Code, Bulls),
	count_same_number(Correct, Code, N),
	Cows is N-Bulls,
	assert(query(Code,Bulls,Cows)),
	println([Code," bulls=",Bulls," cows=",Cows]),
	Bulls=4.
	
mastermind:-
	input_numbers(Correct),
	cleanup,
	guess(Code),
	not(check(Code)),
	ask(Correct,Code),
	writeln("Good!"),
	!.
