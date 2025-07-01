pause
$Id: mulk pause.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 一時停止

*[man]
**#en
.caption SYNOPSIS
	pause.m [MESSAGE...]
.caption DESCRIPTION
Output a message and stop until the enter key is pressed.
**#ja

.caption 書式
	pause [MESSAGE]...
.caption 説明
メッセージを出力して、エンターキーが入力されるまで停止する。

*pause tool.@
	Object addSubclass: #Cmd.pause
**Cmd.pause >> main: args
	args empty? 
		ifTrue: ["--pause. press enter key?"]
		ifFalse: [args asString] ->:msg;
	Out0 put: msg;
	In0 getLn
