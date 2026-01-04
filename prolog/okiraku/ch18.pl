%chapter 18.
%$Id: mulk/prolog ch18.pl 1506 2025-12-30 Tue 21:11:19 kt $

hanoi(N,From,To,Via):-
	N>1, N1 is N-1, 
	hanoi(N1,From,Via,To),println([From," to ",To]),hanoi(N1,Via,To,From).
hanoi(1,From,To,_):-println([From," to ",To]).
