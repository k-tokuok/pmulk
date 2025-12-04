% list proto.
% $Id: mulk/prolog list.pl 1469 2025-08-22 Fri 21:53:42 kt $

reverse(L,R):-$reverse(L,[],R).
$reverse([],R,R).
$reverse([X|L],Y,R):-$reverse(L,[X|Y],R).

%slow reverse
reverse2([],[]).
reverse2([X|Rest],Ans):-reverse2(Rest,L),append(L,[X],Ans).

length(L,N):-$length(L,N),!.

$length([],0).
$length([_V|L],N):-$length(L,N1), N is N1+1.

permutation([],[]).
permutation(L,[X|L2]):-$del(X,L,L1),permutation(L1,L2).

$del(X,[X|L],L).
$del(X,[Y|L],[Y|L1]):-$del(X,L,L1).

