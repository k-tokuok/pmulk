cut out part of the input
$Id: mulk cut.m 932 2022-09-18 Sun 17:45:15 kt $
#ja 入力の一部を切り出す

*[man]
**#en
.caption SYNOPSIS
	cut FROM [TO]
.caption DESCRIPTION
Outputs standard input from FROM line to TO line to standard output.
If TO is omitted, output to the end of the file.
**#ja
.caption 書式
	cut FROM [TO]
.caption 説明
標準入力のFROM行からTO行までを標準出力へ出力する。
TOが省略された場合はファイル末まで出力する。

*cut tool.@
	Object addSubclass: #Cmd.cut
**Cmd.cut >> main: args
	args first asInteger ->:st;
	args size = 2 ifTrue: [args at: 1, asInteger] ifFalse: [0xfffffff] ->:en;

	1 ->:lno;
	In contentLinesDo:
		[:ln
		st <= lno & (lno <= en), ifTrue: [Out putLn: ln];
		lno > en ifTrue: [self!];
		lno + 1 ->lno]
