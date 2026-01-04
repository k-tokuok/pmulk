%chapter 16.
%$Id: mulk/prolog ch16.pl 1505 2025-12-29 Mon 20:00:53 kt $

append_dl([Xs,Ys],[Ys,Zs],[Xs,Zs]).

take_integer(X,Y):-take_int_sub(X,[Y,[]]).
take_int_sub([X|Xs],[Ys,Zs]):-
	take_int_sub(X,[Ys,Ys1]),take_int_sub(Xs,[Ys1,Zs]),!.
take_int_sub(X,[[X|Xs],Xs]):-integer(X),!.
take_int_sub(X,[Ys,Ys]).
