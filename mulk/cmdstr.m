command string generation
$Id: mulk cmdstr.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja コマンド文字列の生成
*[man]
**#en
.caption DESCRIPTION
Generate a command string from a String Collection.

The string is a combination of elements separated by blanks, but if the second and subsequent elements contain blanks, enclose them in appropriate quotation marks.
**#ja
.caption 説明
String列からコマンド文字列を生成する。

要素を空白で区切って結合した文字列となるが、第2要素以降に空白を含む場合、適切な引用符で囲む。

*CmdStringBuilder class.@
	Object addSubclass: #CmdStringBuilder
**CmdStringBuilder >> quoteFor: arg
	arg includes?: '"', ifFalse: ['"'!];
	arg includes?: '\'', ifFalse: ['\''!];
	'`'!
**CmdStringBuilder >> build: colArgs
	true ->:first?;
	StringWriter new ->:wr;
	
	colArgs do:
		[:arg
		first? ifFalse: [wr put: ' '];
		first? not and: [arg includes?: ' '],
			ifTrue:
				[self quoteFor: arg ->:q;
				wr put: q, put: arg, put: q]
			ifFalse: [wr put: arg];
		false ->first?];
	wr asString!
	
*Collection >> asCmdString
	CmdStringBuilder new build: self!
**[man.m]
***#en
Generate a command string from the receiver.
***#ja
レシーバーからコマンド文字列を生成する。
