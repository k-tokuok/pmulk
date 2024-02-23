expand form feed
$Id: mulk deff.m 932 2022-09-18 Sun 17:45:15 kt $
#ja 改頁文字の展開

*[man]
**#en
.caption SYNOPSIS
	deff [N]
.caption DESCRIPTION
If there is a form feed character at the beginning of the input line, a line feed character is inserted so that the next line is at the beginning of the form.

The line itself including the form feed character is not output.

The argument specifies the number of lines per page.
If omitted, it is assumed that the current number of console lines is specified.
**#ja
.caption 書式
	deff [n]
.caption 説明
入力の行頭に改頁文字があった場合、次の行が頁先頭になるように改行文字を挿入して出力する。

改頁文字を含む行自体は出力しない。

引数は頁当りの行数を指定する。
省略された時は現在のコンソールの行数が指定されたものと見做す。

*deff tool.@
	Mulk import: "console";
	Object addSubclass: #Cmd.deff
**Cmd.deff >> main: args
	args empty? ifTrue: [Console height] ifFalse: [args first asInteger]
		->:height;

	0 ->:y;
	In contentLinesDo:
		[:ln
		ln head?: '\f',
			ifTrue:
				[[y % height <> 0] whileTrue:
					[Out putLn;
					y + 1 ->y]]
			ifFalse:
				[Out putLn: ln;
				y + 1 ->y]]
