multi-column output
$Id: mulk multicol.m 1559 2026-03-20 Fri 21:53:31 kt $
#ja マルチカラム出力

*[man]
**#en
.caption SYNOPSIS
	multicol [COLUMNWIDTH]
.caption DESCRIPTION
Read standard input line by line and output side by side.

The part exceeding the column width is not output.
If the COLUMNWIDTH is omitted, the width will be adjusted to show the entire content.

**#ja
.caption 書式
	multicol [カラム幅]
.caption 説明
標準入力を行毎に読み込み、横に並べて出力する。

カラム幅を越える部分は出力しない。
カラム幅を省略した場合は全体が表示されるよう調整される。

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
**Cmd.multicol >> countWidth: lines
	0 ->:result;
	lines do: 
		[:l
		StringReader new init: l ->:r;
		0 ->:w;
		[r getWideChar ->:ch, notNil?] whileTrue: [w + ch width ->w];
		result max: w ->result];
	result!
**Cmd.multicol >> main: args
	In contentLines asArray ->:lines;
	args empty? 
		ifTrue: [self countWidth: lines]
		ifFalse: [args first asInteger] ->width;
	Console width // (width + 1) ->:ncol;
	0 ->:i;
	lines do:
		[:l
		self putLine: l ->:pos;
		i + 1 ->i;
		i < ncol
			ifTrue: [Out putSpaces: width + 1 - pos]
			ifFalse:
				[Out putLn;
				0 ->i]];
	i <> 0 ifTrue: [Out putLn]
