%chapter 06. fact
%$Id: mulk/prolog ch06.pl 1497 2025-12-20 Sat 09:23:52 kt $
fact(X,S):-X>0,X1 is X-1,fact(X1,S1),S is X*S1.
fact(0,1).
