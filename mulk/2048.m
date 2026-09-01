2048
$Id: mulk 2048.m 1628 2026-08-06 Thu 21:59:14 kt $
#ja
*[man]
**#en
.caption SYNOPSIS
	2048 [-h]
.caption DESCRIPTION
Combine numbers to reach 2048.

Use the arrow keys to move tiles up, down, left, and right. When you bring tiles with the same number together, they merge into a single tile.

  Controls:
        [w,8]
  [a,4]   +   [d,6]
        [s,5]
.caption ORIGIN 
Original by Gabriele Cirulli.

Based on 1024 by Veewo Studio and conceptually similar to Threes by Asher Vollmer.
.caption OPTION
	h -- hard mode.
.caption LIMITATION
This program runs only under a console with screen control capabilities.
.caption SEE ALSO
.summary sconsole
**#ja
.caption 書式
	2048 [-h]
.caption 説明
数値を合成して2048を目指して下さい。

方向キーでタイルを上下左右へ移動し、同じ番号のタイルをくっつけると一つに合成されます。

  操作:
        [w,8]
  [a,4]   +   [d,6]
        [s,5]
.caption 出典
Original by Gabriele Cirulli.

Based on 1024 by Veewo Studio and conceptually similar to Threes by Asher Vollmer.
.caption オプション
	h -- ハードモード
.caption 制限事項
画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary sconsole

*2048 game.@
	Mulk import: #("console" "matrix" "random" "pi" "optparse");
	Object addSubclass: #Cmd.2048 instanceVars: "n table score hiscore hard?"
**Cmd.2048 >> addPiece
	table keys selectAsArray: [:s table at: s, nil?] ->:cadets;
	cadets empty? ifTrue: [false!];
	table at: (Random select: cadets)
		put: (#(2 4 8) at: (Random until: (hard? ifTrue: [3] ifFalse: [2])));
	true!
**Cmd.2048 >> showTable
	Console gotoX: 0 Y: 0;
	table keysAndValuesDo:
		[:pos :piece
		piece nil?
			ifTrue: [Out putSpaces: 7]
			ifFalse: [Out put: '[', put: piece width: 5, put: ']'];
		pos x = (n - 1) ifTrue: [Out putLn]];
	Out putLn: "score: " + score + " hiscore: " + hiscore
**Cmd.2048 >> move: tile from: f to: t
	table at: t put: tile;
	table at: f put: nil
**Cmd.2048 >> shiftLine: t vector: v
	t + v ->:f;
	n - 1 timesRepeat:
		[table at: f ->:fp, notNil? ifTrue:
			[table at: t ->:tp, nil?
				ifTrue: [self move: fp from: f to: t]
				ifFalse:
					[fp = tp
						ifTrue:
							[fp * 2 ->fp;
							score + fp ->score;
							table at: t put: fp;
							table at: f put: nil;
							t + v ->t]
						ifFalse:
							[t + v ->t;
							t <> f ifTrue: [self move: fp from: f to: t]]]];
		f + v ->f]
**Cmd.2048 >> shiftBase: b vector: v
	v y negated @ v x ->:nv;
	n timesRepeat:
		[self shiftLine: b vector: v;
		b + nv ->b]
**Cmd.2048 >> turn
	self showTable;
	"a4s5d6w8" indexOf: Console fetch ->:code, nil? ifTrue: [self!];
	code // 2 ->code;
	code = 0 ifTrue: [self shiftBase: 0 @ 0 vector: 1 @ 0!];
	code = 1 ifTrue: [self shiftBase: 0 @ (n - 1) vector: 0 @ -1!];
	code = 2 ifTrue: [self shiftBase: n - 1 @ (n - 1) vector: -1 @ 0!];
	code = 3 ifTrue: [self shiftBase: n - 1 @ 0 vector: 0 @ 1!]
**Cmd.2048 >> main: args
	OptionParser new init: "h" ->:op, parse: args ->args;
	op at: 'h' ->hard?;

	"2048.mpi" asWorkFile ->:saveFile, readableFile?
		ifTrue: [saveFile readObject]
		ifFalse: [Dictionary new at: true put: 0, at: false put: 0]
		->:saveData, at: hard? ->hiscore;
	Console clear;
	4 ->n;
	Matrix new init: n @ n ->table;
	0 ->score;
	self addPiece;
	self addPiece;
	[self turn;
	self addPiece] whileTrue;
	self showTable;
	Out putLn: "game over.";
	hiscore < score ifTrue:
		[Out putLn: "update hiscore.";
		saveData at: hard? put: score;
		saveFile writeObject: saveData]
