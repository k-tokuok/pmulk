% fact sample.
% $Id: mulk/prolog fact.pl 1467 2025-08-17 Sun 20:59:55 kt $

fact(1,1).
fact(N,F):-N>1, N1 is N - 1, fact(N1,F1), F is N*F1.

%?-fact(N,N!).

