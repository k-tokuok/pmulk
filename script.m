create a carbon copy of the command session
$Id: mulk script.m 1259 2024-06-15 Sat 21:38:52 kt $
#ja コマンドセッションの写しを作成する

*[man]
**#en
.caption SYNOPSIS
	script [OPTION] [COMMAND...]
.caption DESCRIPTION
Perform the COMMAND and output the contents of the session up to the end of the session to a file, including any input from the user.
If the COMMAND is omitted, "icmd -s-" is executed.
.caption OPTION
	a -- Output in append mode.
	f FILE -- Specifies the output file. If omitted, "script.wk" in the current directory is assumed to be specified.
.caption LIMITATION
It is not possible to switch consoles while executing commands.
**#ja
.caption 書式
	script [option] [コマンド...]
.caption 説明
コマンドを実行し、終了までのセッションの内容をユーザーが入力したものを含めてファイルに出力する。
コマンド省略時は"icmd -s-"を実行する。
.caption オプション
	a -- 追記モードで出力する。
	f file -- 出力先ファイルを指定する。省略時はカレントディレクトリの"script.wk"が指定されたものと見做す。
.caption 制限事項
コマンド実行中にconsoleを切り替える事はできない。

*script tool.@
	Mulk import: #("console" "optparse" "cmdstr");
	Object addSubclass: #Cmd.script instanceVars: "in out fs",
		features: #(Reader Writer)

**Cmd.script >> main: args
	OptionParser new init: "af:" ->:op, parse: args ->args;
	
	In0 ->in;
	Out0 ->out;

	op at: 'f' ->:file, nil? ifTrue: ["script.wk" ->file];
	file asFile perform:
		(op at: 'a', ifTrue: [#openAppend] ifFalse: [#openWrite]) ->fs;
	args empty? ifTrue: ["icmd -s-"] ifFalse: [args asCmdString] ->:cmd;
	
	self ->In0 ->In ->Out0 ->Out;
	Out putLn: "--script start: " + DateAndTime new initNow;
	Out putLn: "--cmd: " + cmd + " dir: " + "." asFile;
	[cmd runCmd] finally:
		[Out putLn: "\n--script end: " + DateAndTime new initNow;
		fs close;
		in ->In0 ->In;
		out ->Out0 ->Out]

**Reader/Writer methods.
***Cmd.script >> getByte
	in getByte ->:result;
	result <> -1 ifTrue: [fs putCharCode: result];
	result!
***Cmd.script >> putByte: code
	out putCharCode: code;
	fs putCharCode: code
