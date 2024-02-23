cut out the column
$Id: mulk col.m 932 2022-09-18 Sun 17:45:15 kt $
#ja カラムの切り出し

*[man]
**#en
.caption SYNOPSIS
	col FROM [TO]
.caption DESCRIPTION
Outputs from the FROM column to the TO column of the input line.
If TO is omitted, output to the end of the line.
.caption LIMITATION
Input is limited to the ASCII character set.

**#ja
.caption 書式
	col FROM [TO]
.caption 説明
入力行のFROMカラム目からTOカラム目までを出力する。
TOが省略された場合は行末まで出力する。
.caption 制限事項
入力はASCII文字セットに限られる。

*col tool.@
	Object addSubclass: #Cmd.col
**Cmd.col >> main: args
	args first asInteger ->:st;
	args size = 2 ifTrue: [args at: 1, asInteger] ifFalse: [0xfffffff] ->:en;

	In contentLinesDo:
		[:ln
		ln size ->:len;
		Out putLn: (ln copyFrom: (st min: len) until: (en + 1 min: len))]
