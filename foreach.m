execute a command on a line for each of the standard input
$Id: mulk foreach.m 932 2022-09-18 Sun 17:45:15 kt $
#ja 標準入力のそれぞれに行に対してコマンドを実行する

*[man]
**#en
.caption SYNOPSIS
	foreach [OPTION] COMMAND...
.caption DESCRIPTION
The replacement character in the command arguments are replaced with the contents of the standard input line, then combined and executed.
If there is a space in the argument after replacement, it is properly enclosed in quotation marks.
The replacement character is '%' by default.
.caption OPTION
	f -- Treat the input line as a file name and connect it to the standard input of the executable.
	r CHAR -- Set replacement character to CHAR
**#ja
.caption 書式
	foreach [オプション] コマンド...
.caption 説明
コマンド引数列中の置換文字は標準入力の行の内容に置換された上で結合され実行される。
置換後の引数に空白が含まれる場合は適切に引用符で囲まれる。
置換文字はデフォルトでは'%'である。
.caption オプション
	f -- 入力行をファイル名と見做し、それを実行コマンドの標準入力に接続する。
	r CHAR -- 置換文字をCHARに設定する。

*foreach tool.@
	Mulk import: #("optparse" "cmdstr");
	Object addSubclass: #Cmd.foreach
**Cmd.foreach >> replace: arg from: rchar to: dest
	StringWriter new ->:wr;
	[arg indexOf: rchar ->:pos, notNil?] whileTrue:
		[wr put: (arg copyUntil: pos), put: dest;
		arg copyFrom: pos + 1 ->arg];
	wr put: arg, asString!
**Cmd.foreach >> main: args
	OptionParser new init: "fr:" ->:op, parse: args ->args;
	op at: 'f' ->:f?;
	op at: 'r' ->:oa, nil? ifTrue: ['%'] ifFalse: [oa first] ->:rchar;

	args ->:template;
	In contentLinesDo:
		[:dest
		template collect: [:arg self replace: arg from: rchar to: dest], 
			asCmdString ->:cmdstr;
		f?
			ifTrue: [dest asFile pipe: cmdstr to: Out]
			ifFalse: [cmdstr runCmd]]
