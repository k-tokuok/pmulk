output first part of input
$Id: mulk head.m 417 2020-05-05 Tue 22:35:23 kt $
#ja 入力の先頭の部分を出力

*[man]
**#en
.caption SYNOPSIS
	head [N]
.caption DESCRIPTION
Output the first N lines of standard input to standard output.

If N is omitted, it is assumed that 10 is specified.
**#ja
.caption 書式
	head [N]
.caption 説明
標準入力の先頭N行を標準出力へ出力する。

Nが省略された場合は10が指定されたものと見做す。

*head tool.@
	Object addSubclass: #Cmd.head
**Cmd.head >> main: args
	args empty? ifTrue: [10] ifFalse: [args first asInteger] ->:n;
	n timesRepeat:
		[In getLn ->:s, nil?
			ifTrue: [self!]
			ifFalse: [Out putLn: s]]
