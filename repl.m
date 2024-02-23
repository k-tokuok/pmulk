interactive mode (read eval print loop)
$Id: mulk repl.m 406 2020-04-19 Sun 11:29:54 kt $
#ja 対話モード (read eval print loop)

*[man]
**#en
.caption SYNOPSIS
	repl
.caption DESCRIPTION
Execute repl on the command object.

See Object >> repl in the base system for details.
.caption SEE ALSO
.summary base
**#ja
.caption 書式
	repl
.caption 説明
コマンドオブジェクトに対してreplを実行する。

詳細はベースシステムのObject >> replの項を參照せよ。
.caption 関連項目
.summary base

*repl tool.@
	Object addSubclass: #Cmd.repl
**Cmd.repl >> main: args
	self repl
