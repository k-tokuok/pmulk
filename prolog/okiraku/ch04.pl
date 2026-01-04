%chapter 04. â∆ånê}
%$Id: mulk/prolog ch04.pl 1497 2025-12-20 Sat 09:23:52 kt $

male(taro).
male(ichiro).
male(jiro).
male(saburo).

female(hanako).
female(tomoko).
female(sachiko).
female(youko).

father_of(taro, ichiro).
father_of(taro, jiro).
father_of(taro, tomoko).
father_of(ichiro, saburo).
father_of(ichiro, youko).

mother_of(hanako, ichiro).
mother_of(hanako, jiro).
mother_of(hanako, tomoko).
mother_of(sachiko, saburo).
mother_of(sachiko, youko).

parents_of(X, Y) :- father_of(X ,Y).
parents_of(X, Y) :- mother_of(X, Y).

son_of(X, Y) :- parents_of(Y, X), male(X).
daughter_of(X, Y) :- parents_of(Y, X), female(X).
grandfather_of(X, Y) :- parents_of(Z, Y), father_of(X, Z).
