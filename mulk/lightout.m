lights out
$Id: mulk lightout.m 1629 2026-08-07 Fri 20:23:54 kt $
#ja ライツアウト

*[man]
**#en
.caption SYNOPSIS
	lightout
.caption DESCRIPTION
When you press a character key, the selected character and the marks ([ ]) surrounding it (above, below, to the left, and to the right) will be highlighted.
Remove all the marks.
.caption LIMITATION
This program runs only under a console with screen control capabilities.
.caption SEE ALSO
.summary sconsole
**#ja
.caption 書式
	lightout
.caption 説明
文字キーを押すと、選択した文字と、その上下左右の文字に付いているマーク([ ])が反転します。
全てのマークを消して下さい。
.caption 制限事項
画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary sconsole

*lightout game.@
	Mulk import: #("console" "random" "matrix");
	Object addSubclass: #Cmd.lightout instanceVars: "n n2 table vec flipped"
**Cmd.lightout >> init
	5 ->n;
	n * n ->n2;
	Matrix new init: n @ n ->table;

	Array new addLast: 0 @ 0, addLast: -1 @ 0, addLast: 1 @ 0, addLast: 0 @ -1,
		addLast: 0 @ 1 ->vec
**Cmd.lightout >> show: pos
	table at: pos ->:on?;
	Console gotoX: pos x * 4 Y: pos y + 1;
	Console put: (on? ifTrue: ['['] ifFalse: [' ']);
	Console put: (pos y * n + pos x asStringRadix: n2);
	Console put: (on? ifTrue: [']'] ifFalse: [' '])
**Cmd.lightout >> flip: ix
	ix % n @ (ix // n) ->:pos;
	vec do:
		[:v
		pos + v ->:p;
		table inside?: p, ifTrue:
			[table at: p put: (table at: p) not;
			self show: p]]
**Cmd.lightout >> flipChar: ch
	ch asNumericValue: n2 ifError: [self!] ->:ix;
	self flip: ix;
	flipped indexOf: ch ->ix, nil?
		ifTrue: [flipped + ch]
		ifFalse: [flipped copyUntil: ix, + (flipped copyFrom: ix + 1)]
		->flipped;
	Console gotoX: 0 Y: n + 1, put: flipped, put: ' '
**Cmd.lightout >> initLevel: level
	Console clear;
	"" ->flipped;
	Console put: "level " + level;
	table fill: false;
	Set new ->:set;
	level timesRepeat:
		[[Random until: n2 ->:key; set includes?: key] whileTrue;
		set add: key;
		self flip: key];
	n2 timesDo: [:i self show: i % n @ (i // n)]
**Cmd.lightout >> clear?
	table allSatisfy?: [:v v not]!
**Cmd.lightout >> round: level
	self initLevel: level;
	[self clear?] whileFalse:
		[self flipChar: Console fetch]
**Cmd.lightout >> main: args
	1 to: n2 - 10, do: [:level self round: level]
