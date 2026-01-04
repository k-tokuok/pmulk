%chapter 15.
%$Id: mulk/prolog ch15.pl 1504 2025-12-28 Sun 21:47:47 kt $
echo:-repeat,read(X),echo_sub(X),!.
echo_sub(end_of_file):-!.
echo_sub(X):-write(X),nl,fail.

yes_or_no(X):-repeat, read(X), or(X=yes, X=no),!.

my_between(L,H,L):-L<=H.
my_between(L,H,V):-L<H, L1 is L+1, my_between(L1,H,V).

change(N,fizzbuzz):-0 is N mod 15,!.
change(N,fizz):-0 is N mod 3,!.
change(N,buzz):-0 is N mod 5,!.
change(N,N).

fizzbuzz:-my_between(1,100,N),change(N,S),write(S),write(" "),fail.

fact(X,S):-fact(X,1,S).
fact(X,Y,S):-X>0, Y1 is Y*X, X1 is X-1,fact(X1,Y1,S).
fact(0,S,S).

fibo(N,F):-N>1,
	N1 is N-1,fibo(N1,F1),
	N2 is N-2,fibo(N2,F2),
	F is F1+F2.
fibo(0,0).
fibo(1,1).

fibo1(N,F):-fibo1(N,0,1,F).
fibo1(N,A1,A2,F):-N>0, N1 is N-1, A3 is A1+A2,fibo1(N1,A2,A3,F).
fibo1(0,A1,_,A1).

my_reverse(Xs,Ys):-my_reverse(Xs,[],Ys).
my_reverse([],Xs,Xs).
my_reverse([X|Xs],As,Ys):-my_reverse(Xs,[X|As],Ys).
