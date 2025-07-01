tab restore
$Id: mulk entab.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja タブの復元

*[man]
**#en
.caption SYNOPSIS
	entab [N]
.caption DESCRIPTION
White space contained in standard input is restored to N character unit tabs if possible, and output to standard output.

If N is omitted, it is considered that 4 is specified.
**#ja
.caption 書式
	entab [N]
.caption 説明
標準入力に含まれる空白を可能ならN文字単位のタブに復元して、標準出力へ出力する。

Nが省略された場合は4が指定されたものと見做す。

*entab tool.@
	Object addSubclass: #Cmd.entab

**Cmd.entab >> main: args
	4 ->:width;
	args empty? ifFalse: [args first asInteger ->width];

	0 ->:pos;
	[pos ->:npos;
	[In getWideChar ->:ch, = ' ' | (ch = '\t')] whileTrue:
		[ch = ' ' ifTrue: [1] ifFalse: [width - (npos % width)], + npos ->npos;
		npos % width = 0 ifTrue:
			[Out put: '\t';
			npos ->pos]];
	[pos <> npos] whileTrue:
		[Out put: ' ';
		pos + 1 ->pos];
	ch nil? ifTrue: [self!];
	Out put: ch;
	ch = '\n' ifTrue: [0] ifFalse: [pos + ch width] ->pos] loop
