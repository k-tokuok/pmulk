% benchmark test.
% $Id: mulk/prolog bench.pl 1467 2025-08-17 Sun 20:59:55 kt $

repeat(_).
repeat(N):-N>1,N1 is N-1,repeat(N1).

reverse([],[]).
reverse([X|Rest],Ans):-reverse(Rest,L),append(L,[X],Ans).

data([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]).

dobench(N):-data(L),repeat(N),reverse(L,_),fail.
dobench(N).

dummy(_,_).

dodummy(N):-data(L),repeat(N),dummy(L,_),fail.
dodummy(_).

bench(N):-
	T0 is clock,
	dobench(N),
	T1 is clock,
	dodummy(N),
	T2 is clock,
	LIPS is 496*N/(T1-T0-(T2-T1)),
	writeln(LIPS).	
