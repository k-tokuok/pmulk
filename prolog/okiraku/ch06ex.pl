%chapter 06. exercise.
%$Id: mulk/prolog ch06ex.pl 1502 2025-12-26 Fri 21:44:22 kt $

%1.
sum(N,A):-N>0, N1 is N - 1, sum(N1,A1), A is A1+N.
sum(0,0).

sum1(N,A):-A is N*(N+1)//2.

%2.
square_sum(N,A):-N>0,N1 is N-1, square_sum(N1,A1), A is A1+N*N.
square_sum(0,0).

square_sum1(N,A):-A is N*(N+1)*(2*N+1)//6.

%3.
cubic_sum(N,A):-N>0, N1 is N-1, cubic_sum(N1,A1), A is A1+N*N*N.
cubic_sum(0,0).

cubic_sum1(N,A):-A is N*N*(N+1)*(N+1)//4.

%4.
pow(X,N,A):-N>0, N1 is N-1, pow(X,N1,A1), A is A1*X.
pow(_,0,1).

pow1(X,N,A):-N>0, 0 is N mod 2, N1 is N//2, pow1(X,N1,A1),A is A1*A1.
pow1(X,N,A):-N>0, 1 is N mod 2, N1 is N//2, pow1(X,N1,A1),A is A1*A1*X.
pow1(_,0,1).

%5. fizzbuzz.
change(N,fizzbuzz):-0 is N mod 3, 0 is N mod 5,!.
change(N,fizz):-0 is N mod 3,!.
change(N,buzz):-0 is N mod 5,!.
change(N,N).

fizzbuzz(N):-N<=100, change(N,S), write(S), write(" "), N1 is N + 1, fizzbuzz(N1).
fizzbuzz(100):-nl.
