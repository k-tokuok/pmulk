%chapter 30.
%$Id: mulk/prolog ch30.pl 1524 2026-01-15 Thu 20:36:24 kt $

% 置換処理
substitute(X, Y, [], []).
substitute(X, Y, [X | Z], [Y | Z1]) :- substitute(X, Y, Z, Z1).
substitute(X, Y, [X1 | Z], [X1 | Z1]) :- X \== X1, substitute(X, Y, Z, Z1).

% 積木の移動
move_block(Block, Place, [[Block, _] | Rest], [[Block, Place] | Rest]).
move_block(Block, Place, [X | Rest], [X | Rest1]) :-
    move_block(Block, Place, Rest, Rest1).
    
% 積木と場所の定義
block(red). block(blue). block(green).
place(x). place(y). place(z).

% 移動する場所を求める
move_to(Place) :- block(Place).
move_to(Place) :- place(Place).

% 同一局面のチェック
check_state(_, []).
check_state(State1, [State2 | History]) :-
    State1 \== State2, check_state(State1, History).

% 手順の表示
print_answer([]) :- !.
print_answer([State | Rest]) :-
    print_answer(Rest), writeln(State).
    
% 反復深化による探索
dfs(Limit, Depth, [State | History]) :-
    Limit == Depth,
    State == [[red, blue], [blue, green], [green, z]], !,
    print_answer([State | History]).

dfs(Limit, Depth, [State | History]) :-
    Limit > Depth,
    block(B),
    not(member([_, B], State)),
    move_to(P),
    B \== P,
    not(member([_, P], State)),
    move_block(B, P, State, NewState),
    check_state(NewState, History),
    Depth1 is Depth + 1,
    dfs(Limit, Depth1, [NewState, State | History]).

% 上限値を増やして探索を行う
ids :-
    between(1, 8, N),
    write(N), nl,
    dfs(N, 0, [[[red,blue],[blue,green],[green,x]]]).
