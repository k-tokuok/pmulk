remove repeated lines
$Id: mulk uniq.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 反復している行を削除

*[man]
**#en
.caption SYNOPSIS
	uniq
.caption DESCRIPTION
Input from the standard input line by line, remove lines that repeat the same contents, and output.
**#ja
.caption 書式
	uniq
.caption 説明
標準入力から行毎に入力し、同じ内容が反復している行を削除して出力する。

*uniq tool.@
	Mulk at: #RepeatCounter in: "repeatc", addSubclass: #Cmd.uniq
**Cmd.uniq >> count: countArg line: lineArg
	Out putLn: lineArg
