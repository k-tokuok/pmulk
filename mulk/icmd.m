interactive command interpreter
$Id: mulk icmd.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 対話用コマンドインタプリタ

*[man]
**#en
.caption SYNOPSIS
	icmd [OPTION] [COMMAND...]
	icmd.trace (on|off) -- Specify whether to display the stack trace when an error occurs.
	icmd.next [COMMAND...] -- When the next command is executed, the command specified by the argument is executed instead of the input from the user.

.caption DESCRIPTION
A command interpreter specialized for interactive use, which outputs a prompt (]) prior to command line input.
Also, if an Error exception occurs during command execution, icmd will not be terminated and you will return to the prompt.
If there is an argument, it is regarded as a command string and executed after combining.

If there is an icmd.mc file in the work directory, load it as a startup script at startup.

.caption OPTION
	s STARTUPSCRIPT -- Load STARTUPSCRIPT instead of icmd.mc. If "-" is specified, nothing is read.
.caption SEE ALSO
.summary cmd
**#ja
.caption 書式
	icmd [オプション] [コマンド...]
	icmd.trace (on|off) -- エラー時のスタックトレースの表示の有無を指定する。
	icmd.next [コマンド...] -- 次のコマンドを実行する時に、ユーザーからの入力の代わりに引数で指定されたコマンドを実行する。

.caption 説明
対話用に特化したコマンドインタプリタで、コマンド行入力に先立ってプロンプト(])を出力する。
又、コマンド実行中にError例外が発生してもicmdを終了せずにプロンプトに戻る。
引数がある場合、それをコマンド文字列と見做し、結合の上実行する。

起動時にワークディレクトリにicmd.mcファイルがあれば、これを起動スクリプトとして読み込む。
.caption オプション
	s 起動スクリプト -- icmd.mcの代わりに起動スクリプトを読み込む。"-"を指定すると何も読み込まない。
.caption 関連項目
.summary cmd

*import.@
	Mulk import: #("cmd" "optparse")

*icmd tool.@
	Mulk addGlobalVar: #Cmd.icmd.trace?, set: false;
	Mulk addGlobalVar: #Cmd.icmd.history;
	Mulk addGlobalVar: #Cmd.icmd.next;
	Cmd.cmd addSubclass: #Cmd.icmd
	
**Cmd.icmd >> resetInOut
	In0 ->In;
	Out0 ->Out

**Cmd.icmd >> getNext
	Cmd.icmd.next ->:result, notNil? ifTrue:
		[nil ->Cmd.icmd.next;
		result!];
	Out put: ']';
	In getLn!
**Cmd.icmd >> mainLoop
	Kernel currentProcess ->:cp;
	cp interruptBlock ->:ib;
	cp interruptBlock: nil;
		
	[self getNext ->:s, notNil?] whileTrue:
		[Cmd.icmd.history notNil? ifTrue: [Cmd.icmd.history addCmd: s];
		nil ->:exception;
		cp interruptBlock: ib;
		[self run: s] on: Error do: 
			[:e
			Cmd.icmd.trace? ifTrue: [e printStackTrace];
			Out putLn: e message];
		cp interruptBlock: nil;
		Cmd.icmd.history notNil? ifTrue: [Cmd.icmd.history checkDir];
		self resetInOut];
	cp interruptBlock: ib
**Cmd.icmd >> main: args
	OptionParser new init: "s:" ->:op, parse: args ->args;
	op at: 's' ->:opt, nil?
		ifTrue: 
			["icmd.mc" asWorkFile ->:startup, none? ifTrue: [nil ->startup]] 
		ifFalse: [opt <> "-" ifTrue: [opt asFile ->startup]];
	startup notNil? ifTrue: [startup pipe: "cmd" to: Out];

	self resetInOut;

	args empty?
		ifTrue: [self mainLoop]
		ifFalse: [self run: args asString]
**Cmd.icmd >> main.trace: args
	args first = "on" ->Cmd.icmd.trace?
**Cmd.icmd >> main.next: args
	args asString ->Cmd.icmd.next
