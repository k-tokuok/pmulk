command interpreter
$Id: mulk cmd.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja コマンドインタプリタ

*[man]
**#en
.caption SYNOPSIS
	cmd [SCRIPT]
.caption DESCRIPTION
Read a Unix-like command line from standard input and execute it.

If a SCRIPT is specified, read from the SCRIPT file.
Command line descriptions correspond to comments (#), redirects (<, <<,>, >>), pipes (|), and sequential execution (;).
The description is interpreted as a sequence of tokens separated by white space, with the first token as the command name and the rest as arguments.
Redirection, pipe, and sequential execution specification must be at the beginning of the token.
If a token begins with a quotation mark (', ", `), the subsequent quotation marks are considered as one token, excluding the quotation marks.
The backslash character (\) is passed as an argument to the command.

The command is a class called Cmd.<command name> and needs to have a main: method.
When the command is executed, an instance of the class is constructed, standard input/output (In, Out) is set based on redirection and pipe specification, and main: is started with the argument as an array of character strings.

If there is no class, the system module with the command name is automatically imported.

Subcommand names can be specified by separating the command name with ".".
In this case, the main.<subcommand name>: method is executed instead of the main: method.
.caption SEE ALSO
.summary icmd
**#ja
.caption 書式
	cmd [スクリプト]
.caption 説明
標準入力からUnix-likeなコマンド行を読み込み、実行する。

スクリプトが指定された場合は、スクリプトファイルから読み込みを行う。

コマンド行記述はコメント(#)、リダイレクト(<, <<, >, >>)、パイプ(|)及び逐次実行(;)に対応する。
記述は空白で区切られたトークン列として解釈され、最初のトークンがコマンド名、それ以外が引数として解釈される。
リダイレクト、パイプ、逐次実行指定はトークンの先頭に無くてはならない。
トークンの先頭が引用符(', ", `)の場合は後続の対応する引用符までを、引用符を除いた上で一つのトークンと見做す。
バックスラッシュ文字(\)はそのまま引数としてコマンドに渡される。

コマンドは"Cmd.コマンド名"と言うクラスで、main:メソッドを持つ必要がある。
コマンドを実行すると当該クラスのインスタンスを構築し、標準入出力(In, Out)をリダイレクト及びパイプ指定に基いて設定、引数を文字列のArrayとしてmain:を起動する。

クラスが無い場合、コマンド名のシステムモジュールを自動的にインポートする。

コマンド名に続け"."で区切って副コマンド名を指定する事が出来る。
この場合、"main:"メソッドの代わりに"main.副コマンド名:"メソッドが実行される。
.caption 関連項目
.summary icmd

*Cmd.Reader class.@
	AheadReader addSubclass: #Cmd.Reader
**Cmd.Reader >> token?
	self skipSpace;
	#(';' '>' '<' '|') includes?: nextChar, ifTrue: [false!];
	nextChar nil? ifTrue: [false!];
	true!
**Cmd.Reader >> nextChar
	self skipSpace;
	nextChar!

*ExitException class.@
	Exception addSubclass: #ExitException
**[man.c]
***#en
An exception that terminates the command.

If this exception is raised while executing a command, the command is terminated and subsequent processing continues.
***#ja
コマンドを終了させる例外。

コマンドを実行中にこの例外を起こすと、コマンドを終了させ後続の処理を続行する。

*cmd tool.@
	Mulk import: "pipe";
	Object addSubclass: #Cmd.cmd instanceVars: "reader"
**Cmd.cmd >> exec: cmd args: args
	cmd indexOf: '.' ->:dotpos, nil?
		ifTrue:
			[cmd ->:module;
			"main:" ->:cmdName]
		ifFalse:
			[cmd copyUntil: dotpos ->module;
			"main." + (cmd copyFrom: dotpos + 1) + ':' ->cmdName];
	Mulk at: ("Cmd." + module) asSymbol in: module, new ->:cmdObject;

	[cmdObject perform: cmdName asSymbol with: args]
		on: ExitException do: [:quit self]
**Cmd.cmd >> hereDocument: in until: sepr
	MemoryStream new ->:out;
	in contentLinesDo:
		[:ln
		ln = sepr ifTrue: [out seek: 0!];
		out putLn: ln];
	self error: "clip by << failed"
**Cmd.cmd >> runIn: inArg out: outArg
	inArg ->:in;
	outArg ->:out;
	
	reader token? ifFalse: [self!];
	reader getToken ->:cmd;
	Array new ->:args;
	[reader token?] whileTrue: [args addLast: reader getToken];

	reader nextChar = '<' ifTrue:
		[reader skipChar;
		reader nextChar = '<'
			ifTrue:
				[reader skipChar;
				self hereDocument: in until: reader getToken]
			ifFalse: [reader getToken asFile] ->in];
	false ->:append?;
	reader nextChar = '>' ifTrue:
		[reader skipChar;
		reader nextChar = '>' ->append?, ifTrue: [reader skipChar];
		reader getToken asFile ->out];
	reader nextChar = '|' ifTrue:
		[reader skipChar;
		MemoryStream new ->out ->:pipe];

	in perform: (append? ifTrue: [#pipe:appendTo:] ifFalse: [#pipe:to:])
		with: [self exec: cmd args: args] with: out;
	
	pipe notNil? ifTrue:
		[pipe seek: 0;
		self runIn: pipe out: outArg!];
	reader nextChar = ';' ifTrue:
		[reader skipChar;
		self runIn: inArg out: outArg!];
	reader nextChar notNil? ifTrue:
		[self error: "illegal command at " + reader nextChar]
**Cmd.cmd >> run: cmdString
	cmdString empty? or: [cmdString first = '#'], ifTrue: [self!];
	Cmd.Reader new init: cmdString ->reader;
	self runIn: In out: Out
**Cmd.cmd >> mainLoop
	In contentLinesDo: [:s self run: s]
**Cmd.cmd >> main: args
	args empty?
		ifTrue: [self mainLoop]
		ifFalse: [args first asFile pipe: [self mainLoop] to: Out]

*String >> runCmd
	Cmd.cmd new run: self
**[man.m]
***#en
Run a string as a command line.
***#ja
文字列をコマンド行として実行する。
