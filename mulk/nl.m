number lines
$Id: mulk nl.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 行番号の付加

*[man]
**#en
.caption SYNOPSIS
	nl [OPTION] [START]
.caption DESCRIPTION
Line numbers are added to the contents of standard input and output to standard output.

You can specify the line number of the first line with START.
If omitted, it starts from 1.
.caption OPTION
	w WIDTH -- Specifies the width of the line number. If omitted, it is set to 7.
**#ja
.caption 書式
	nl [OPTION] [START]
.caption 説明
標準入力の内容に行番号を付加し、標準出力へ出力する。

STARTで先頭行の行番号を指定出来る。
省略時は1から始まる。
.caption オプション
	w WIDTH -- 行番号の幅を指定する。省略時は7とする。
	
*nl tool.@
	Mulk import: #("optparse" "numlnwr");
    Object addSubclass: #Cmd.nl
**Cmd.nl >> main: args
	OptionParser new init: "w:" ->:op, parse: args ->args;
	NumberedLineWriter new init: 7 op: op ->:wr;
	args empty? ifTrue: [1] ifFalse: [args first asInteger] ->:no;
	In contentLinesDo:
		[:line
		wr put: no and: line;
		no + 1 ->no]
