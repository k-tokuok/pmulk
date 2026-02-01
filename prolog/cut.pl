% cut error case.
% $Id: mulk/prolog cut.pl 1494 2025-12-14 Sun 21:53:06 kt $

a(1).
a(2).

q1:-a(X),write(X),fail.
q2:-a(X),write(X),!,fail.

%2025-08-15 Fri 08:43:29
%q2の!がq3のalternativeを切ってしまうバグを修正。
q3:-q2.
q3:-write(alter).

%2025-12-14 Sun 10:44:21
%第2clause以降にある!が上手く切れないバグ(processFail)を修正
c(X):-fail.
c(1):-!.
c(2).
