%chapter 27.
%$Id: mulk/prolog ch27.pl 1519 2026-01-12 Mon 18:19:22 kt $

move([F,G,W,C],[NF,G,W,C]):-if(F==left,NF=right,NF=left).
move([F,F,W,C],[NF,NF,W,C]):-if(F==left,NF=right,NF=left).
move([F,G,F,C],[NF,G,NF,C]):-if(F==left,NF=right,NF=left).
move([F,G,W,F],[NF,G,W,NF]):-if(F==left,NF=right,NF=left).

safe_cabbage(F,G,C):-F==C.
safe_cabbage(F,G,C):-G\==C.

safe_goat(F,G,W):-F==G.
safe_goat(F,G,W):-G\==W.

safe([F,G,W,C]):-safe_cabbage(F,G,C),safe_goat(F,G,W).

print_answer([]):-!.
print_answer([State|Rest]):-
	print_answer(Rest),writeln(State).
	
depth_first_search([State|History]):-
	State==[right,right,right,right],!,print_answer([State|History]).
depth_first_search([State|History]):-
	move(State,NewState),
	safe(NewState),
	not(member(NewState,History)),
	depth_first_search([NewState,State|History]).
