%chapter 29.
%$Id: mulk/prolog ch29.pl 1523 2026-01-14 Wed 05:53:08 kt $

%積木を移動する
move_block(From, To, Via, State, [[From | Rest1], [To, Block | Rest2], [Via | Rest3]]) :-
    member([From, Block | Rest1], State),
    member([To | Rest2], State),
    member([Via | Rest3], State).
    
% 移動 : move(From, To, Via)
move(x, y, z). move(x, z, y).
move(y, x, z). move(y, z, x).
move(z, x, y). move(z, y, x).

% 状態の比較
equal_state(State1, State2) :-
    member([x | X1], State1), member([x | X2], State2), X1 == X2,
    member([y | Y1], State1), member([y | Y2], State2), Y1 == Y2,
    member([z | Z1], State1), member([z | Z2], State2), Z1 == Z2.
    
% 同一局面のチェック
check_state(_, []).
check_state(State1, [State2 | History]) :-
    not(equal_state(State1, State2)), check_state(State1, History).
    
% 移動手順を表示
print_answer([]) :- !.
print_answer([State | Rest]) :-
    print_answer(Rest),
    member([x | X], State), member([y | Y], State), member([z | Z], State),
    println([X, Y, Z]).
    
% 深さ優先探索
dfs([State | History]) :-
    equal_state([ [x], [y], [z, red, blue, green] ], State), !,
    print_answer([State | History]).
dfs([State | History]) :-
    move(From, To, Via),
    move_block(From, To, Via, State, NewState),
    check_state(NewState, History),
    dfs([NewState, State | History]).
    
