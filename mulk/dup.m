duplicated lines
$Id: mulk dup.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 重複のある行を出力

*[man]
**#en
.caption SYNOPSIS
	dup
.caption DESCRIPTION
Output one duplicate line each from the sorted standard input.
**#ja
.caption 書式
	dup
.caption 説明
ソートされた標準入力から重複のある行をそれぞれ1行ずつ出力する。

*dup tool.@
	Mulk at: #RepeatCounter in: "repeatc", addSubclass: #Cmd.dup
**Cmd.dup >> count: countArg line: lineArg
	countArg >= 2 ifTrue: [Out putLn: lineArg]
