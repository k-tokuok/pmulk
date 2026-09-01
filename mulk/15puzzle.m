15-puzzle
$Id: mulk 15puzzle.m 1628 2026-08-06 Thu 21:59:14 kt $
#ja 15パズル

*[man]
**#en
.caption SYNOPSIS
	15puzzle [N]
.caption DESCRIPTION
Slide the pieces on an NxN board into empty spaces to arrange them in ascending order.

If N is omitted, the board is 4x4.
  Operation:
        [w,8]
  [a,4]   +   [d,6]
        [s,5]
.caption LIMITATION
This program runs only under a console with screen control capabilities.
.caption SEE ALSO
.summary sconsole

**#ja
.caption 書式
	15puzzle [N]
.caption 説明
NxNのボード上の駒を空きを利用してスライドし、駒を昇順に並べます。

Nを省略した場合は4x4のボードとなります。

  操作:
        [w,8]
  [a,4]   +   [d,6]
        [s,5]
.caption 制限事項
画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary sconsole

*override.@
	Mulk import: "matrix"

*15puzzle.@
	Mulk import: #("console" "random");
	Object addSubclass: #Cmd.15puzzle instanceVars:
		"n table vector cursor space"
**Cmd.15puzzle >> tableAt: pos put: piece
	table at: pos put: piece;
	Console gotoX: pos x * 4 Y: pos y;
	piece = space 
		ifTrue: [Out putSpaces: 4]
		ifFalse: [Out put: '[', put: piece width: 2, put: ']']
**Cmd.15puzzle >> move: dir
	cursor + (vector at: dir) ->:ncursor;
	table inside?: ncursor, ifFalse: [self!];
	self tableAt: cursor put: (table at: ncursor);
	self tableAt: ncursor put: space;
	ncursor ->cursor
**Cmd.15puzzle >> legalPiece: pos
	pos x + (n * pos y) + 1!
**Cmd.15puzzle >> clear?
	table keys allSatisfy?: [:p table at: p, = (self legalPiece: p)]!
**Cmd.15puzzle >> main: args
	args empty? ifTrue: [4] ifFalse: [args first asInteger] ->n;
	Console clear;
	Array new, addLast: 1 @ 0, addLast: -1 @ 0, addLast: 0 @ 1, addLast: 0 @ -1
		->vector;
	Matrix new init: n @ n ->table;
	n - 1 @ (n - 1) ->cursor;
	self legalPiece: cursor ->space;
	
	table keys do: [:p self tableAt: p put: (self legalPiece: p)];
	30 * n * n timesRepeat: [self move: (Random until: 4)];
	
	[self clear?] whileFalse: 
		[["d6a4s5w8" indexOf: Console fetch ->:dir, nil?] whileTrue;
		self move: dir // 2];
	Out putLn: "--clear"
