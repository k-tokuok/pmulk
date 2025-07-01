multi-column output
$Id: mulk multicol.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja マルチカラム出力

*[man]
**#en
.caption SYNOPSIS
	multicol [COLUMNWIDTH]
.caption DESCRIPTION
Read standard input line by line and output side by side.

The part exceeding the column width is not output.
If the column width is omitted, 12 is assumed to be specified.

**#ja
.caption 書式
	multicol [カラム幅]
.caption 説明
標準入力を行毎に読み込み、横に並べて出力する。

カラム幅を越える部分は出力しない。
カラム幅を省略した場合は12が指定されたものと見做す。

*multicol tool.@
	Mulk import: "console";
	Object addSubclass: #Cmd.multicol instanceVars: "width"
**Cmd.multicol >> putLine: l
	0 ->:pos;
	StringReader new init: l ->:r;
	[r getWideChar ->:ch, notNil?] whileTrue:
		[pos + ch width ->:npos, > width ifTrue: [pos!];
		Out put: ch;
		npos ->pos];
	pos!
**Cmd.multicol >> main: args
	args empty? ifTrue: [12] ifFalse: [args first asInteger] ->width;
	Console width // (width + 1) ->:ncol;

	0 ->:i;
	In contentLinesDo:
		[:l
		self putLine: l ->:pos;
		i + 1 ->i;
		i < ncol
			ifTrue: [Out putSpaces: width + 1 - pos]
			ifFalse:
				[Out putLn;
				0 ->i]];
	i <> 0 ifTrue: [Out putLn]
