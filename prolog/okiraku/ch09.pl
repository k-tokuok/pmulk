%chapter 09. 基本的なリスト操作
%$Id: mulk/prolog ch09.pl 1497 2025-12-20 Sat 09:23:52 kt $

first([X|_],X).
rest([_|X],X).

add_to_list(X,Ls,[X|Ls]).
