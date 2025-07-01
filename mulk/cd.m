change current directory
$Id: mulk cd.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja カレントディレクトリの変更

*[man]
**#en
.caption SYNOPSIS
	cd [-m] DIR
.caption DESCRIPTION
Change the current directory to DIR.
.caption OPTION
	m -- create directory if DIR doesn't exist.
**#ja
.caption 書式
	cd [-m] DIR
.caption 説明
カレントディレクトリをDIRへ変更する。
.caption オプション
	m -- DIRがない場合はディレクトリを作成する。
	
*cd tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.cd
**Cmd.cd >> main: args
	OptionParser new init: "m" ->:op, parse: args ->args;
	args first asFile ->:dir;
	op at: 'm', ifTrue: [dir mkdir];
	dir chdir
