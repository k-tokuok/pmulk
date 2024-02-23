tee pipe
$Id: mulk tee.m 417 2020-05-05 Tue 22:35:23 kt $
#ja Tパイプ

*[man]
**#en
.caption SYNOPSIS
	tee [-a] FILE
.caption DESCRIPTION
Output the contents of standard input to the file FILE and standard output.
.caption OPTION
	a -- Append to FILE.
**#ja
.caption 書式
	tee [-a] FILE
.caption 説明
標準入力の内容をファイルFILEと標準出力へ出力する。
.caption オプション
	a -- FILEへ追記する。

*tee tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.tee
**Cmd.tee >> main: args
	OptionParser new init: "a" ->:op, parse: args ->args;
	op at: 'a' ->:append?;
	args first asFile
		perform: (append? ifTrue: [#openAppend] ifFalse: [#openWrite])
		->:writer;
	[In getChar ->:ch, notNil?] whileTrue:
		[Out put: ch;
		writer put: ch];
	writer close
