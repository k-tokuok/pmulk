shutdown execution
$Id: mulk onquit.m 1356 2025-01-21 Tue 21:59:14 kt $
#ja 終了時の実行

*[man]
**#en
.caption SYNOPSIS
	onquit COMMAND...
.caption DESCRIPTION
Execute the COMMAND at the shutdown of Mulk.
**#ja
.caption 書式
	onquit コマンド...
.caption 説明
コマンドをMulk終了時に実行する。

*onquit tool.@
	Mulk import: "cmdstr";
	Object addSubclass: #Cmd.onquit instanceVars: "cmd"
**Cmd.onquit >> main: args
	args asCmdString ->cmd;
	Mulk.quitHook addLast: self
**Cmd.onquit >> onQuit
	cmd runCmd
