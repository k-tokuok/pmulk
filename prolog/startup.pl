% startup.pl
% $Id: mulk/prolog startup.pl 1517 2026-01-11 Sun 16:38:13 kt $

:-($builtin($op,4,"b.op:")).

:-($op(:-,1,"fx",1200)).
:-$op(?-,1,"fx",1200).
:-$op(:-,2,"xfx",1200).
:-$op((,),2,"xfy",1000).
:-$op(is,2,"xfx",700).
:-$op(=,2,"xfx",700).
:-$op(\=,2,"xfx",700).
:-$op(==,2,"xfx",700).
:-$op(\==,2,"xfx",700).
:-$op(<,2,"xfx",700).
:-$op(>,2,"xfx",700).
:-$op(<=,2,"xfx",700).
:-$op(>=,2,"xfx",700).
:-$op(+,2,"yfx",500).
:-$op(-,2,"yfx",500).
:-$op(-,1,"fx",500).
:-$op(*,2,"yfx",400).
:-$op(/,2,"yfx",400).
:-$op(//,2,"yfx",400).
:-$op(mod,2,"yfx",400).

:-$builtin($stop,0,"b.stop:").

% control.
true.
%fail. -- never define.
:-$builtin(!,0,"b.cut:").

call(X):-X.

not(X):-X,!,fail.
not(_).

or(X,_):-X,!,true.
or(_,X):-X,!,true.

if(X,Y,Z):-X,!,Y.
if(_,_,Z):-Z.

repeat.
repeat:-repeat.

between(L,H,L):-L<=H.
between(L,H,V):-L<H, L1 is L+1, between(L1,H,V).

% meta-logical.
:-$builtin(atom,1,"b.atom:").
:-$builtin(var,1,"b.var:").
:-$builtin(integer,1,"b.integer:").
:-$builtin(number,1,"b.number:").
:-$builtin(compound,1,"b.compound:").

atomic(X):-or(atom(X),number(X)).

:-$builtin(==,2,"b.identical:").
X \== Y :- not(X==Y).

% list support.
member(X,[X|_]).
member(X,[_|Y]):-member(X,Y).

append([X|L1],L2,[X|L3]):-append(L1,L2,L3).
append([],L,L).

length([X|Xs],N):-length(Xs,N1), N is N1+1.
length([],0).

select(X,[X|Xs],Xs).
select(X,[Y|Ys],[Y|Zs]):-select(X,Ys,Zs).

nth(N,[Y|Ls],X):-N>0, N1 is N-1, nth(N1,Ls,X).
nth(0,[X|_],X).

delete([X|Xs],I,[X|Ys]):-I\==X,delete(Xs,I,Ys).
delete([I|Xs],I,Xs).

reverse(Xs,Ys):-reverse(Xs,[],Ys).
reverse([],Xs,Xs).
reverse([X|Xs],As,Ys):-reverse(Xs,[X|As],Ys).

% input/output.
:-$builtin(read,1,"b.read:").
:-$builtin(write,1,"b.write:").
:-$builtin(put,1,"b.put:").
nl:-put(10).
writeln(X):-write(X),nl.

printlist(L):-member(E,L),write(E),fail.
printlist(_).

print([CAR|CDR]):-!,printlist([CAR|CDR]).
print(E):-write(E).

println(L):-print(L),nl.

error(L):-println(L),$stop.

% compare.
X=X.
X\=Y:-not(X=Y).
:-$builtin(<,2,"b.lt:").
X>Y:-Y<X.
X<=Y:-not(X>Y).
X>=Y:-not(X<Y).

% arithmetic.
:-$builtin($add,3,"b.add:").
:-$builtin($negated,2,"b.negated:").
:-$builtin($multiply,3,"b.multiply:").
:-$builtin($divide,3,"b.divide:").
:-$builtin($div,3,"b.div:").
:-$builtin($mod,3,"b.mod:").
:-$builtin($clock,1,"b.clock:").
:-$builtin($sqrt,2,"b.sqrt:").
:-$builtin($log,2,"b.log:").
:-$builtin($sin,2,"b.sin:").
:-$builtin($random,2,"b.random:").

X is X :- number(X),!.
_ is Y :- var(Y), error("is/2: find var in RHS").
Y is -X :- !, X2 is X, $negated(X2,Y).
Z is X+Y :- !, X2 is X, Y2 is Y, $add(X2,Y2,Z).
Z is X-Y :- !, X2 is X, Y2 is -Y, $add(X2,Y2,Z).
Z is X*Y :- !, X2 is X, Y2 is Y, $multiply(X2,Y2,Z).
Z is X/Y :- !, X2 is X, Y2 is Y, $divide(X2,Y2,Z).
Z is X//Y :- !, X2 is X, Y2 is Y, $div(X2,Y2,Z).
Z is X mod Y :- !, X2 is X, Y2 is Y, $mod(X2,Y2,Z).
Y is clock :- !, $clock(Y).
Y is abs(X) :- !, X2 is X, if(X2>0,Y=X2,$minus(X2,Y)).
Z is min(X,Y) :- !, X2 is X, Y2 is Y, if(X2<Y2,Z=X,Z=Y).
Y is sqrt(X) :- !, X2 is X, $sqrt(X2,Y).
Y is log(X) :- !, X2 is X, $log(X2,Y).
3.14159265358979323846 is pi :- !.
Y is sin(X) :- !, X2 is X, $sin(X2,Y).
Y is cos(X) :- !, Y is sin(X+pi/2).
Y is random(X) :- !, X2 is X, $random(X2,Y).
Y is X :- error(["is/2: illegal expr ",X]).

% clause control.
:-$builtin(abolish,2,"b.abolish:").
:-$builtin(consult,1,"b.consult:").
:-$builtin(assert,1,"b.assert:").

% findall
:-$builtin($findall_push,0,"b.findallPush:").
:-$builtin($findall_add,1,"b.findallAdd:").
:-$builtin($findall_pop,1,"b.findallPop:").

findall(T,G,_):-$findall_push,G,$findall_add(T),fail.
findall(_,_,L):-$findall_pop(L).

% debug support.
:-$builtin($debugTerm,1,"b.debugTerm:").

%
measure(X):-
	ST is clock,
	X,
	!,
	T is clock-ST,
	write("time: "),writeln(T).
