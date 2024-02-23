interactive change of current directory
$Id: mulk icd.m 919 2022-09-03 Sat 22:11:41 kt $
#ja 対話的なカレントディレクトリの変更

*[man]
**#en
.caption SYNOPSIS
	icd [DIR]
.caption DESCRIPTION
Change the current directory interactively.
The operation is as follows.

	Numeric -- Move to the directory indicated by the number
	p/n -- Go to previous / next page
	Enter -- End operation
	
If DIR is specified, the current directory is changed first.
**#ja
.caption 書式
	icd [DIR]
.caption 説明
対話的にカレントディレクトリを変更する。
操作は以下の通り。

	数値 -- 番号で示されたディレクトリへ移動
	p/n -- 前後のページへ移動
	Enter -- 終了
	
DIRを指定すると最初にカレントディレクトリを変更する。

*icd tool.@
	Mulk import: #("prompt" "console" "wcarray");
	Object addSubclass: #Cmd.icd instanceVars: "dir dirs unit width"
**Cmd.icd >> showList: pageTop
	WideCharArray new addString: dir path ->:buf;
	[buf width > width] whileTrue: [buf removeFirst];
	Out putLn: buf asString;
	
	pageTop + unit min: dirs size ->:last;
	pageTop until: last, do:
		[:i
		Out put: i;
		Out put: ')';
		i = 0 & dir root? not
			ifTrue: [".."] ifFalse: [dirs at: i, name] ->:name;
		WideCharArray new addString: name ->buf;
		[buf width > width] whileTrue: [buf removeLast];
		Out putLn: buf asString]
**Cmd.icd >> select
	dir childFiles select: [:f f directory?], asArray ->dirs;
	dirs sortBy: [:x :y x name < y name];
	dir root? ifFalse: [dirs addFirst: dir parent];
	
	0 ->:pageTop;
	[self showList: pageTop;
	Prompt getString: "dirNo n)ext p)rev [enter])end" ->:s;
	s empty? ifTrue: [false!];
	s first ->:ch, digit? ifTrue:
		[s asInteger ->:no;
		no between: 0 until: dirs size, ifTrue:
			[dirs at: no ->dir;
			true!]];
	ch = 'n' & (pageTop + unit < dirs size) ifTrue: [pageTop + unit ->pageTop];
	ch = 'p' & (pageTop - unit >= 0) ifTrue: [pageTop - unit ->pageTop]] loop
**Cmd.icd >> main: args
	args empty? ifFalse: [args first asFile chdir];
	Console height - 2 ->unit;
	Console width - 5 ->width;
	"." asFile ->dir;
	[self select] whileTrue;
	dir chdir
