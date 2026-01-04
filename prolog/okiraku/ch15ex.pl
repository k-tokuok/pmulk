%chapter 15. exercise.
%$Id: mulk/prolog ch15ex.pl 1504 2025-12-28 Sun 21:47:47 kt $

%1
sum(X,N,A):-X>0, X1 is X-1, N1 is N+X, sum(X1,N1,A).
sum(0,A,A).
sum(X,A):-sum(X,0,A).

%2
sumlist([X|Xs],N,A):-N1 is N+X, sumlist(Xs,N1,A).
sumlist([],A,A).
sumlist(Xs,A):-sumlist(Xs,0,A).

%3
maxlist([X|Xs],N,A):-X>N,!,maxlist(Xs,X,A).
maxlist([_|Xs],N,A):-maxlist(Xs,N,A).
maxlist([],A,A).
maxlist([X|Xs],A):-maxlist(Xs,X,A).

%4
minlist([X|Xs],N,A):-X<N,!,minlist(Xs,X,A).
minlist([_|Xs],N,A):-minlist(Xs,N,A).
minlist([],A,A).
minlist([X|Xs],A):-minlist(Xs,X,A).

%5
write_num(N):-N>=10,write(" "),write(N).
write_num(N):-N<10,write("  "),write(N).

nn_sub(M,N):-N<10,A is M*N,write_num(A),N1 is N+1,nn_sub(M,N1).
nn_sub(_,10):-nl.

nn(N):-N<10,nn_sub(N,1),N1 is N+1,nn(N1).
nn(10):-nl.

ninetynine:-nn(1).

%6
my_length([],A,A):-!.
my_length([_|Xs],A,N):-A1 is A+1,my_length(Xs,A1,N).
my_length(Xs,N):-my_length(Xs,0,N).
