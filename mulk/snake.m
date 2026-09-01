snake game
$Id: mulk snake.m 1631 2026-08-11 Tue 22:08:53 kt $
#ja ヘビゲーム

*[man]
**#en
.caption SYNOPSIS
	snake
.caption DESCRIPTION
Control the snake (*) and keep eating the food (numbers).

The snake grows every time it eats food.
If the snake collides with a wall (#) or itself, it's game over.

Press the [a,4] keys to turn left, and the [d,6] keys to turn right.
.caption LIMITATION
This program runs only under a console with screen control capabilities.
.caption SEE ALSO
.summary sconsole
**#ja
.caption 書式
	snake
.caption 説明
ヘビ(*)を操作して餌(数字)を食べ続けて下さい。

餌を食べる度にヘビは成長していきます。
壁(#)もしくはヘビ自身に衝突するとゲームオーバーです。

ヘビは[a,4]キーで左折、[d,6]キーで右折します。
.caption 制限事項
画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary sconsole

*import.@
	Mulk import: #("point" "random")

*snake game.@
	Object addSubclass: #Cmd.snake instanceVars: "width height"
**Cmd.snake >> clear
	height timesDo:
		[:y
		Console gotoX: 0 Y: y;
		y = 0 | (y = (height - 1))
			ifTrue: [Out put: '#' times: width]
			ifFalse: [Out put: '#', putSpaces: width - 2, put: '#']]
**Cmd.snake >> randomPoint
	(Random until: width - 2, + 1) @ (Random until: height - 2, + 1)!
**Cmd.snake >> at: pos
	Console charX: pos x Y: pos y!
**Cmd.snake >> at: pos put: char
	Console gotoX: pos x Y: pos y, put: char
**Cmd.snake >> putFood
	[self randomPoint ->:p;
	self at: p, <> ' '] whileTrue;
	self at: p put: (Random until: 9, + '1' code) asChar
**Cmd.snake >> main: args
	Console width ->width;
	Console height - 1 ->height;
	self clear;
	5 timesRepeat: [self putFood];
	
	Array new addLast: 1 @ 0, addLast: 0 @ -1, addLast: -1 @ 0, addLast: 0 @ 1
		->:vector;
	1 ->:dir;
	width // 2 @ (height // 2) ->:head;
	Ring new ->:body;
	1 ->:bodyLength;
	
	[self at: head ->:ch, <> '#' and: [ch <> '*']] whileTrue:
		[ch digit? ifTrue:
			[bodyLength + ch asDecimalValue ->bodyLength;
			self putFood];
		self at: head put: '*';
		body addFirst: head;
		body size > bodyLength ifTrue:
			[self at: body last put: ' ';
			body removeLast];

		0.15 sleep;
		Console hit? ifTrue:
			[Console fetch ->ch;
			ch = 'a' | (ch = '4') ifTrue: [dir + 1 % 4 ->dir];
			ch = 'd' | (ch = '6') ifTrue: [dir + 3 % 4 ->dir]];
		head + (vector at: dir) ->head];
	Console gotoX: 0 Y: height;
	Out putLn: "GAMEOVER score: " + bodyLength
