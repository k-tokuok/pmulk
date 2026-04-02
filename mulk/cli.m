command line input helper
$Id: mulk cli.m 1565 2026-03-27 Fri 22:05:44 kt $
#ja

*[man]
**#en
.caption SYNOPSIS
	cli [MESSAGE...]
	cli.setup --  Specifying the target console window
.caption DESCRIPTION
Send arbitrary text to the application running in the specified console window.
This is done by setting the text to the clipboard, bringing the target console window into focus, and then sending ^v as a keyboard event.

If arguments are specified, its contents are sent.

If no arguments are provided, a prompt is displayed, and each line of input is sent as it is entered.
The following input lines provide various functions.

	Empty string -- Enter multiple lines using the wb integration.
	EOF or "!" -- Exit.
	!COMMAND -- Execute a Mulk command.

To specify a console window, run `cli.setup` in that window.
.caption SEE ALSO
.summary wb
.caption LIMITATION
It runs on Windows and X11.

On X11, you need to install the xdotool and xsel commands beforehand.
**#ja
.caption 書式
	cli [送信内容...]
	cli.setup -- 対象のコンソールウィンドウの指定
.caption 説明
指定のコンソールウィンドウで動作しているアプリケーションに任意のテキストを送信する。
これはテキストをクリップボードに設定し、対象のコンソールウィンドウにフォーカスした上で^vをキーボードイベントとして送信する事で行われる。

引数を指定すると、その内容を送信する。

引数を省略するとプロンプトが出力され、一行入力される度にその内容を送信する。
以下の入力行で様々な機能を提供する。

	空文字列 -- wb連携で複数行入力を行う。
	EOF又は"!" -- 終了する。
	!COMMAND -- Mulkのコマンドを実行する。

コンソールウィンドウの指定は、当該ウィンドウでcli.setupを実行する。
.caption 関連項目
.summary wb
.caption 制限事項
Windows及びX11で動作する。

X11では事前にxdotoolとxselコマンドをインストールしておく必要がある。

*cli tool.@
	Mulk import: "clip";
	Object addSubclass: #Cmd.cli instanceVars: "window wb"
	
**Mulk.hostOS = #windows >
***@
	Mulk import: "win32"
***Cmd.cli >> sendPaste
	Win32 foreground: window, ctrlv
***Cmd.cli >> consoleWindow
	Win32 consoleWindow!
	
**Mulk.hostOSUnix? >
***Cmd.cli >> sendPaste
	"os xdotool windowactivate " + window, runCmd;
	"os xdotool key ctrl+v" runCmd
***Cmd.cli >> consoleWindow
	"os xdotool getactivewindow" pipe: [In getLn asInteger ->:result];
	result!
	
**Cmd.cli >> send: arg
	Clip put: arg;
	self sendPaste
**Cmd.cli >> processLn: ln
	ln empty? ifTrue: [wb inputText: nil ->ln];
	ln nil? or: [ln trim ->ln, empty?], ifTrue: [self!];
	ln first ='!' ifTrue: [ln copyFrom: 1, runCmd!];
	self send: ln
**Cmd.cli >> numFile
	"cli.num" asWorkFile!
**Cmd.cli >> main: args
	self numFile pipe: [In getLn asInteger ->window];
	args empty? ifFalse: [self send: args asString!];
	Mulk at: #Wb ifAbsent: [nil] ->wb;
	wb notNil? ifTrue: [wb get ->wb];
	[Out put: "cli>"; In getLn ->:ln, notNil? and: [ln <> "!"]] whileTrue: 
		[[self processLn: ln] on: Error do:
			[:e Out putLn: e message]]
**Cmd.cli >> main.setup: args
	[Out putLn: self consoleWindow] pipeTo: self numFile
