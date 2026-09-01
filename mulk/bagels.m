number guessing game
$Id: mulk bagels.m 1630 2026-08-08 Sat 22:02:48 kt $

*[man]
.caption SYNOPSIS
	bagels
.caption DESCRIPTION
Computer is thinking a 3 digit number.
Try to guess computer's number and computer will give you clues as follows:

	Pico - one digit correct but in the wrong position.
	Fermi - one digit correct and in the right position.
	Bagels - no digits correct.
.caption ORIGIN
Adapted from "BASIC COMPUTER GAMES".

Original program by D. Resek and P. Rowe of the Lawrence Hall of Science, Barkeley, California.

*bagels game.@
	Mulk import: #("random" "prompt");
	Object addSubclass: #Cmd.bagels instanceVars: "n ans guess"
**Cmd.bagels >> makeAnswer
	Array new ->ans;
	n timesRepeat:
		[[Random until: 10 ->:r; ans includes?: r] whileTrue;
		ans addLast: r]
**Cmd.bagels >> makeGuess: s
	s size <> n ifTrue: [false!];
	Array new ->guess;
	n timesDo:
		[:i
		s at: i, asNumericValue: 10 ifError: [false!] ->:code;
		guess includes?: code, ifTrue: [false!];
		guess addLast: code];
	true!
**Cmd.bagels >> main: args
	3 ->n;
	self makeAnswer;
	1 to: 20, do:
		[:turn
		Out putLn: "Turn: " + turn;
		Prompt getString: "guess" satisfy: [:s self makeGuess: s];

		0 ->:pico ->:fermi;
		n timesDo:
			[:i
			ans indexOf: (guess at: i) ->:ix, notNil? ifTrue:
				[ix = i
					ifTrue: [fermi + 1 ->fermi]
					ifFalse: [pico + 1 ->pico]]];
		fermi = n ifTrue: [Out putLn: "You got it!"; self!];
		pico timesRepeat: [Out put: "Pico "];
		fermi timesRepeat: [Out put: "Fermi "];
		pico = 0 & (fermi = 0) ifTrue: [Out put: "Bagels"];
		Out putLn];

	Out put: "That's 20 guesses. My answer is ";
	n timesDo: [:j Out put: (ans at: j)];
	Out putLn
