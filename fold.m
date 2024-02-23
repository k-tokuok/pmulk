line wrapping
$Id: mulk fold.m 418 2020-05-06 Wed 12:43:55 kt $
#ja 行の折り返し

*[man]
**#en
.caption SYNOPSIS
	fold [N]
.caption DESCRIPTION
Wrap the input in N columns and output.

If N is omitted, it is assumed that screen width - 1 is specified.
**#ja
.caption 書式
	fold [N]
.caption 説明
入力をNカラムで折り返して出力する。

Nが省略された場合は画面幅-1が指定されたものと見做す。

*fold tool.@
	Mulk import: "console";
	Object addSubclass: #Cmd.fold
**Cmd.fold >> main: args
	args empty?
		ifTrue: [Console width - 1]
		ifFalse: [args first asInteger] ->:col;

	0 ->:pos;
	[In getWideChar ->:ch, notNil?] whileTrue:
		[ch = '\n'
			ifTrue:
				[0 ->pos;
				Out putLn]
			ifFalse:
				[pos + ch width ->pos, > col ifTrue:
					[Out putLn;
					ch width ->pos];
				Out put: ch]]
