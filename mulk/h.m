execution from command history
$Id: mulk h.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja コマンド履歴からの実行

*[man]
**#en
.caption SYNOPSIS
	h [LEAD] -- Re-execute command
	h.l -- Show command history
	h.d [NO] -- Show and select directory history
.caption DESCRIPTION
Re-execute the command executed in the past.

The command is determined by specifying LEAD.
	Omitted -- Previous command
	Number -- Serial number in history
	String -- The command begins with a string.

The l subcommand displays the command history and executes the command selected by number.

The d subcommand displays the directory history and moves to the directory selected by number.
You can also specify the number as an argument.
Specifying a negative number will move you to the directory you visited specified times ago.

This command keeps history after loaded.
.caption SEE ALSO
.summary icmd
**#ja
.caption 書式
	h [LEAD] -- コマンドの再実行
	h.l -- コマンド履歴の表示
	h.d [NO] -- ディレクトリ履歴の表示と選択
.caption 説明
過去に実行したコマンドを再実行する。

LEADの指定によりコマンドが定まる。
	省略 -- 直前のコマンド
	番号 -- 履歴中の通し番号
	文字列 -- コマンドの先頭が文字列と一致するもの。
	
lサブコマンドはコマンド履歴を表示し、番号で選択したコマンドを実行する。

dサブコマンドはディレクトリ履歴を表示し、番号で選択したディレクトリに移動する。
引数で番号を指定することもできる。
負の数を指定すると指定数回前に訪れたディレクトリへ移動する。

このコマンドはロード後に実行したコマンドを履歴として保持する。
.caption 関連項目
.summary icmd

*import.@
	Mulk import: "prompt"
	
*Cmd.h.History class.@
	Object addSubclass: #Cmd.h.History instanceVars: 
		"cmdArray last nesting dirArray lastDir"
**Cmd.h.History >> init
	Array new ->cmdArray;
	0 ->last;
	Array new ->dirArray;
	0 ->lastDir;
	0 ->nesting
**Cmd.h.History >> addCmd: cmd
	cmd trim ->cmd, empty? ifTrue: [self!];
	cmdArray detect: [:c c cdr = cmd] ->c, nil?
		ifTrue:
			[cmdArray addFirst: (Cons new car: last cdr: cmd);
			last + 1 ->last;
			cmdArray size = 20 ifTrue: [cmdArray removeLast]]
		ifFalse:
			[cmdArray remove: c;
			cmdArray addFirst: c]
**Cmd.h.History >> printCons: c
	Out0 put: c car width: 7, put: ' ', putLn: c cdr
**Cmd.h.History >> doCons: c
	c nil? ifTrue: [self error: "illegal history specified"];
	nesting = 2 ifTrue: [self error: "illegal history nesting"];
	cmdArray remove: c;
	cmdArray add: c beforeIndex: 1 + nesting;
	self printCons: c;
	nesting + 1 ->nesting;
	[c cdr runCmd] finally: [nesting - 1 ->nesting]
**Cmd.h.History >> main: args
	args empty? ifTrue: [self doCons: (cmdArray at: 1)!];
	args first ->:arg;
	arg first digit? ifTrue:
		[arg asNumber ->:no;
		self doCons: (cmdArray detect: [:c c car = no])!];
	self doCons: (cmdArray detect: [:c2 c2 cdr heads?: arg])
**Cmd.h.History >> inputIntegerOrExit
	Prompt getString: "no (just enter to exit)" ->:s;
	s empty? ifTrue: [ExitException new signal];
	s asInteger!
**Cmd.h.History >> list
	cmdArray reverse do: [:c self printCons: c];
	self inputIntegerOrExit ->:no;
	self doCons: (cmdArray detect: [:c2 c2 car = no])
	
**Cmd.h.History >> checkDir
	"." asFile ->:dir;
	dirArray detect: [:c c cdr = dir] ->c, nil?
		ifTrue:
			[dirArray addFirst: (Cons new car: lastDir cdr: dir);
			lastDir + 1 ->lastDir;
			dirArray size = 20 ifTrue: [dirArray removeLast]]
		ifFalse:
			[dirArray remove: c;
			dirArray addFirst: c]
**Cmd.h.History >> dir: args
	args empty?
		ifTrue:
			[dirArray size ->:size;
			dirArray reverse do: [:c self printCons: c];
			self inputIntegerOrExit]
		ifFalse: [args first asInteger] ->:no;
	no < 0 ifTrue: [dirArray at: no negated, car ->no];
	dirArray detect: [:c2 c2 car = no] ->c;
	args empty? ifFalse: [self printCons: c];
	c cdr chdir
	
*h tool.@
	Object addSubclass: #Cmd.h instanceVars: "history"
**Cmd.h >> init
	Cmd.icmd.history ->history
**Cmd.h >> main: args
	history main: args
**Cmd.h >> main.l: args
	history list
**Cmd.h >> main.d: args
	history dir: args
	
*regist.@
	Cmd.h.History new ->Cmd.icmd.history
