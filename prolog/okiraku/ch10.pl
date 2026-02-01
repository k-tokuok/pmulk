%chapter 10. 再帰定義とリスト操作 (1)
%$Id: mulk/prolog ch10.pl 1497 2025-12-20 Sat 09:23:52 kt $

retrieve(N,[Y|Ls],X):-N>1, N1 is N-1, retrieve(N1,Ls,X).
retrieve(1,[X,Ls],X).

insert_at(N,X,[Y|Ls],[Y|Zs]):-N>1, N1 is N-1,insert_at(N1,X,Ls,Zs).
insert_at(1,X,Ls,[X|Ls]).

remove_at(N,[X|Ls],[X|Zs]):-N>0, N1 is N-1, remove_at(N1,Ls,Zs).
remove_at(1,[X|Ls],Ls).
