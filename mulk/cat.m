concatenate files and output
$Id: mulk cat.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ファイルを連結し出力

*[man]
**#en
.caption SYNOPSIS
	cat [FILE...]
.caption DESCRIPTION
Output the contents of FILE to standard output in order

If the argument is omitted, the contents of the standard input are output to the standard output.

**#ja
.caption 書式
	cat [FILE...]
.caption 説明
FILEの内容を順に標準出力へ出力する。

引数を省略すると標準入力の内容を標準出力へ出力する。

*cat tool.@
	Object addSubclass: #Cmd.cat
**Cmd.cat >> main
	[In getChar ->:char, notNil?] whileTrue: [Out put: char]
**Cmd.cat >> main: args
	args empty?
		ifTrue: [self main]
		ifFalse:
			[args do:
				[:fn
				fn asFile pipe: [self main] to: Out]]
