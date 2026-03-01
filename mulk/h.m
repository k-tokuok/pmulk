execution from command history
$Id: mulk h.m 1544 2026-02-22 Sun 21:09:09 kt $
#ja コマンド履歴からの実行

*[man]
**#en
.caption SYNOPSIS
	h [ARG] -- Re-execute a command from history 
	h.l -- Display command history 
	h.d [ARG] -- Change to the history directory
.caption DESCRIPTION
Re-execute a previously executed command.
When re-executing a command, the command executed by ARG is determined as follows.
	Omission -- The most recent command 
	Number -- The command by its history number 
	String -- The command whose start-of-string matches the string
	
The l subcommand displays the command history and executes the command selected by its number.

In the d subcommand, the directory to move to is determined by ARG as follows.
	Omit -- Display directory history and select the directory by number 
	Negative number -- Directory visited the specified number of times prior 
	Non-negative number -- Directory with the specified history number 
	String -- Directory whose pathname matches the string regular expression. If multiple directories match, candidates are displayed and selected by number
	
This command retains executed commands as history after loading.
.caption SEE ALSO
.summary icmd
.summary regexp
**#ja
.caption 書式
	h [ARG] -- 履歴のコマンドの再実行
	h.l -- コマンド履歴の表示
	h.d [ARG] -- 履歴のディレクトリへ移動
.caption 説明
過去に実行したコマンドを再実行する。

コマンドの再実行時、ARGによって実行されるコマンドは以下のように定まる。
	省略 -- 直前のコマンド
	番号 -- 履歴番号
	文字列 -- 先頭文字列が文字列と一致するコマンド
	
lサブコマンドはコマンド履歴を表示し、番号で選択したコマンドを実行する。

dサブコマンドでは、ARGによって移動するディレクトリは以下のように定まる。
	省略 -- ディレクトリ履歴を表示し、番号で選択したディレクトリ
	負の数 -- 指定回数前に訪れたディレクトリ
	非負の数 -- 履歴番号のディレクトリ
	文字列 -- ディレクトリのパス名と文字列正規表現がマッチしたディレクトリ。マッチしたディレクトリが複数ある場合は候補が表示され、番号で選択する

このコマンドはロード後に実行したコマンドを履歴として保持する。
.caption 関連項目
.summary icmd
.summary regexp

*import.@
	Mulk import: #("prompt" "regexp")
	
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
		ifTrue: ["" ->:filter]
		ifFalse:
			[args first ->:arg, first ->:ch, = '-' | ch digit?, 
				ifTrue: 
					[arg asInteger ->:no;
					no < 0 ifTrue: [dirArray at: no negated, car ->no]]
				ifFalse: [arg ->filter]];
	filter notNil? ifTrue:
		[RegExp new compile: filter ->:re;
		dirArray selectAsArray: [:c re match: c cdr path] ->:ar;
		ar empty? ifTrue: [Out putLn: "no history directory"!];
		ar size = 1 
			ifTrue: [ar first car]
			ifFalse: 
				[ar reverse do: [:c2 self printCons: c2];
				self inputIntegerOrExit] ->no];
	dirArray detect: [:c3 c3 car = no] ->c;
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
