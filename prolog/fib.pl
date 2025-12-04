% fibonacci number sample.
% $Id: mulk/prolog fib.pl 1469 2025-08-22 Fri 21:53:42 kt $

fib(1,1).
fib(2,1).
fib(N,F) :- 
	N>1,
	N1 is N-1, fib(N1,F1),
	N2 is N1-1, fib(N2,F2),
	F is F1+F2.
	
fib2(N,F):-fib2a(N,[F|_]),!.

fib2a(1,[1]).
fib2a(2,[1,1]).
fib2a(X,[F,F1,F2|R]):-X1 is X-1, fib2a(X1,[F1,F2|R]), F is F1+F2.
