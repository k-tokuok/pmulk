% startup.pl
% $Id: mulk/prolog startup.pl 1470 2025-08-29 Fri 23:04:09 kt $

:-($builtin($op,4,"b.op:")).

:-($op(:-,1,"fx",1200)).
:-$op(?-,1,"fx",1200).
:-$op(:-,2,"xfx",1200).
:-$op((,),2,"xfy",1000).
:-$op(is,2,"xfx",700).
:-$op(=,2,"xfx",700).
:-$op(<>,2,"xfx",700).
:-$op(<,2,"xfx",700).
:-$op(>,2,"xfx",700).
:-$op(<=,2,"xfx",700).
:-$op(>=,2,"xfx",700).
:-$op(+,2,"yfx",500).
:-$op(-,2,"yfx",500).
:-$op(-,1,"fx",500).
:-$op(*,2,"yfx",400).
:-$op(/,2,"yfx",400).

% control.
true.
%fail. -- never define.
:-$builtin(!,0,"b.cut:").

call(X):-X.

not(X):-X,!,fail.
not(_).

% meta-logical.
:-$builtin(var,1,"b.var:").
:-$builtin(number,1,"b.number:").

% compare.
X=X.
X<>Y:-not(X=Y).
:-$builtin(<,2,"b.lt:").
X>Y:-Y<X.
X<=Y:-not(X>Y).
X>=Y:-not(X<Y).

% arithmetic.
:-$builtin($add,3,"b.add:").
:-$builtin($minus,2,"b.minus:").
:-$builtin($multiply,3,"b.multiply:").
:-$builtin($divide,3,"b.divide:").
:-$builtin($clock,1,"b.clock:").

X is X :- number(X),!.
Y is -X :- !, X2 is X, $minus(X2,Y).
Z is X+Y :- !, X2 is X, Y2 is Y, $add(X2,Y2,Z).
Z is X-Y :- !, X2 is X, Y2 is -Y, $add(X2,Y2,Z).
Z is X*Y :- !, X2 is X, Y2 is Y, $multiply(X2,Y2,Z).
Z is X/Y :- !, X2 is X, Y2 is Y, $divide(X2,Y2,Z).
Z is clock :- !, $clock(Z).
Z is X :- fail.

% input/output.
:-$builtin(write,1,"b.write:").
:-$builtin(put,1,"b.put:").
nl:-put(10).
writeln(X):-write(X),nl.

% clause control.
:-$builtin(abolish,2,"b.abolish:").
:-$builtin(consult,1,"b.consult:").

% debug support.
:-$builtin($debugTerm,1,"b.debugTerm:").

%
member(X,[X|_]).
member(X,[_|Y]):-member(X,Y).

append([X|L1],L2,[X|L3]):-append(L1,L2,L3).
append([],L,L).

%
measure(X):-
	ST is clock,
	X,
	!,
	T is clock-ST,
	write("time: "),writeln(T).
	
