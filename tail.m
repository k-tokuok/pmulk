output the last part of input
$Id: mulk tail.m 932 2022-09-18 Sun 17:45:15 kt $
#ja 入力の末尾を出力
*[man]
**#en
.caption SYNOPSIS
	tail [N]
.caption DESCRIPTION
Print the last N lines of standard input to standard output.

If N is omitted, it is considered that 10 is specified.
**#ja
.caption 書式
	tail [N]
.caption 説明
標準入力の末尾N行を標準出力へ出力する。

Nが省略された場合は10が指定されたものと見做す。

*tail tool.@
	Object addSubclass: #Cmd.tail
**Cmd.tail >> main: args
	args empty? ifTrue: [10] ifFalse: [args first asInteger] ->:n;
	Array new size: n ->:ar;

	0 ->:lines;

	In contentLinesDo:
		[:s
		ar at: lines % n put: s;
		lines + 1 ->lines];

	lines < n ifTrue:
		[lines ->n;
		0 ->lines];

	n timesRepeat:
		[Out putLn: (ar at: lines % n);
		lines + 1 ->lines]
