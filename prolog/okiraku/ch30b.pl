%chapter 30. 7 puzzle.
% $Id: mulk/prolog ch30b.pl 1524 2026-01-15 Thu 20:36:24 kt $%

% 隣接リスト
neighbor(0, [1, 4]).
neighbor(1, [0, 2, 5]).
neighbor(2, [1, 3, 6]).
neighbor(3, [2, 7]).
neighbor(4, [0, 5]).
neighbor(5, [1, 4, 6]).
neighbor(6, [2, 5, 7]).
neighbor(7, [3, 6]).

% 駒の移動
move_piece(_, [], []).
move_piece(Piece, [0 | Rest], [Piece | Rest1]) :- move_piece(Piece, Rest, Rest1), !.
move_piece(Piece, [Piece | Rest], [0 | Rest1]) :- move_piece(Piece, Rest, Rest1), !.
move_piece(Piece, [X | Rest], [X | Rest1]) :- move_piece(Piece, Rest, Rest1).

% 反復深化
dfs(Limit, Limit, State, _, MoveList) :-
    State == [1, 2, 3, 4, 5, 6, 7, 0],
    !,
    reverse(MoveList, [_ | Result]), write(Result), nl.
dfs(Limit, Depth, State, Space, [PrevPiece | MoveList]) :-
    Limit > Depth,
    neighbor(Space, Xs),
    member(Pos, Xs),
    nth(Pos, State, Piece),
    PrevPiece \== Piece,
    move_piece(Piece, State, NewState),
    Depth1 is Depth + 1,
    dfs(Limit, Depth1, NewState, Pos, [Piece, PrevPiece | MoveList]).

ids :-
    State = [0,7,2,1,4,3,6,5],
    between(1, 36, N), write(N), nl, dfs(N, 0, State, 0, [0]).
    
%
% 下限値枝刈り法
%

% 移動距離
distance(1, [0, 1, 2, 3, 1, 2, 3, 4]).
distance(2, [1, 0, 1, 2, 2, 1, 2, 3]).
distance(3, [2, 1, 0, 1, 3, 2, 1, 2]).
distance(4, [3, 2, 1, 0, 4, 3, 2, 1]).
distance(5, [1, 2, 3, 4, 0, 1, 2, 3]).
distance(6, [2, 1, 2, 3, 1, 0, 1, 2]).
distance(7, [3, 2, 1, 2, 2, 1, 0, 1]).

% 距離の計算
calc_distance(_, [], MD, MD).
calc_distance(N, [0 | Rest], MD, Z) :-
    N1 is N + 1,
    calc_distance(N1, Rest, MD, Z).
calc_distance(N, [Piece | Rest], MD, Z) :-
    distance(Piece, List),
    nth(N, List, D),
    MD1 is MD + D,
    N1 is N + 1,
    calc_distance(N1, Rest, MD1, Z).

% 反復深化＋下限値枝刈り法
dfs_low(Limit, Limit, State, _, MoveList, _) :-
    State == [1, 2, 3, 4, 5, 6, 7, 0],
    !,
    reverse(MoveList, [_ | Result]), write(Result), nl.
dfs_low(Limit, Depth, State, Space, [PrevPiece | MoveList], Low) :-
	D2 is Depth + Low,
    Limit >= D2,
    neighbor(Space, Xs),
    member(Pos, Xs),
    nth(Pos, State, Piece),
    PrevPiece \== Piece,
    move_piece(Piece, State, NewState),
    Depth1 is Depth + 1,
    % 下限値を更新
    distance(Piece, List),
    nth(Pos, List, N1),
    nth(Space, List, N2),
    NewLow is Low - N1 + N2,
    dfs_low(Limit, Depth1, NewState, Pos, [Piece, PrevPiece | MoveList], NewLow).

ids_low :-
    State = [0,7,2,1,4,3,6,5],
    calc_distance(0, State, 0, Low),
    between(Low, 36, N), write(N), nl, dfs_low(N, 0, State, 0, [0], Low).    
