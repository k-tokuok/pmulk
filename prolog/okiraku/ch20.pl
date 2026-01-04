%chapter 20.
%$Id: mulk/prolog ch20.pl 1509 2026-01-02 Fri 07:40:29 kt $

perm([],[]).
perm(Xs,[Z|Zs]):-select(Z,Xs,Ys),perm(Ys,Zs).

attack_sub(X,N,[Y|Ys]):-or(X is Y+N,X is Y-N).
attack_sub(X,N,[Y|Ys]):-N1 is N+1,attack_sub(X,N1,Ys).

attack(X,Xs):- attack_sub(X,1,Xs).

safe([Qt|Qr]):-not(attack(Qt,Qr)),safe(Qr).
safe([]).

queen(Q):-perm([1,2,3,4,5,6,7,8],Q),safe(Q).

%

queen_sub(L,SafeQs,Q):-
	select(X,L,RestQs),
	not(attack(X,SafeQs)),
	queen_sub(RestQs,[X|SafeQs],Q).
queen_sub([],Q,Q).

queen_f(Q):-queen_sub([1,2,3,4,5,6,7,8],[],Q).

queen_f_all:-queen_f(Q),writeln(Q),fail.
queen_f_all.
