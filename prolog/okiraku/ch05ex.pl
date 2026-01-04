%chapter 05. exercise.
%$Id: mulk/prolog ch05ex.pl 1502 2025-12-26 Fri 21:44:22 kt $
add1(X,A):-A is X+1.
sub1(X,A):-A is X-1.
cubic(X,A):-A is X*X*X.
half(X,A):-A is X/2.
medium(X,Y,A):-A is (X+Y)/2.
square_medium(X,Y,A):-A is (X*X+Y*Y)/2.
is_zero(0).
is_positive(X):-X>0.
is_negative(X):-X<0.
sign(X,-1):-is_negative(X),!.
sign(X,1):-is_positive(X),!.
sign(X,0).
is_even(X):-0 is X mod 2.
is_odd(X):-1 is X mod 2.
