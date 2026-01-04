%chapter 22.
%$Id: mulk/prolog ch22.pl 1508 2026-01-01 Thu 21:32:38 kt $

make_correct_sub(4,_,X,X):-!.
make_correct_sub(Num,List,Correct,X):-
	Index is random(10-Num),
	nth(Index,List,Item),
	delete(List,Item,Rest),
	Num1 is Num+1,
	make_correct_sub(Num1,Rest,[Item|Correct],X).
	
make_correct(X):-make_correct_sub(0,[0,1,2,3,4,5,6,7,8,9],[],X).

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

play(11,Correct):-println(["Game Over, Correct is ",Correct]),!.
play(N,Correct):-
	N>0,
	input_numbers(Numbers),
	count_bulls(Numbers,Correct,Bulls),
	count_same_number(Numbers,Correct,Sames),
	Cows is Sames-Bulls,
	println([N,": Bulls is ",Bulls,", Cows is ",Cows]),
	N1 is N+1,
	if(Bulls = 4,println("Good!"),play(N1,Correct)).
	
mastermind:-make_correct(Correct),play(1,Correct).
