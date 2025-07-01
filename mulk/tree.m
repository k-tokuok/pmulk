list directory contents in a tree-like format
$Id: mulk tree.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ツリー形式でディレクトリの内容を表示する

*[man]
**#en
.caption SYNOPSIS
	tree [OPTION] [PATH]
.caption DESCRIPTION
Display the directory structure under PATH as a tree structure.
.caption OPTION
	a -- Display the directory name starting with "."
	f -- Display both the file and the directory.
**#ja
.caption 書式
	tree [OPTION] [PATH]
.caption 説明
PATH下のディレクトリ構造を木構造として表示する。
.caption オプション
	a -- "."で始まるディレクトリ名を表示する。
	f -- ファイルとディレクトリを共に表示する。

*tree tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.tree instanceVars: "nodes all? ls"
**Cmd.tree >> show: file last?: last?
	nodes empty? ifFalse:
		[1 until: nodes size, do: 
			[:i
			Out put: (nodes at: i, ifTrue: [' '] ifFalse: ['|']);
			Out put: ' ' times: 3];
		Out put: "+---"];
	Out putLn: file name;
	
	Array new ->:subdirs;
	file directory? ifTrue:
		[ls + ' ' + file quotedPath contentLinesDo:
			[:fn
			all? or: [fn first <> '.'], ifTrue: [subdirs addLast: file + fn]]];

	subdirs empty? ifFalse:
		[nodes addLast: last?;
		subdirs size ->:scount, timesDo:
			[:j
			self show: (subdirs at: j) last?: j = (scount - 1)];
		nodes removeLast]
**Cmd.tree >> main: args
	OptionParser new init: "af" ->:op, parse: args ->args;
	op at: 'a' ->all?;
	"ls" + (op at: 'f', ifTrue: [""] ifFalse: [" -d"]) ->ls;
	Array new ->nodes;
	args empty? ifTrue: ["."] ifFalse: [args first], asFile ->:dir;
	self show: dir last?: true
