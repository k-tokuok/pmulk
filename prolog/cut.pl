% cut error case.
% $Id: mulk/prolog cut.pl 1466 2025-08-15 Fri 20:57:33 kt $

a(1).
a(2).

q1:-a(X),write(X),fail.
q2:-a(X),write(X),!,fail.

%2025-08-15 Fri 08:43:29 q2‚Ì!‚ªq3‚Ìalternative‚ğØ‚Á‚Ä‚µ‚Ü‚¤ƒoƒO‚ğC³B
q3:-q2.
q3:-write(alter).
