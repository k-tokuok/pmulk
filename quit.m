terminate system
$Id: mulk quit.m 406 2020-04-19 Sun 11:29:54 kt $
#ja システムを終了する

*[man]
**#en
.caption SYNOPSIS
	quit
.caption DESCRIPTION
Quit the Mulk interpreter and return to the host OS.

**#ja
.caption 書式
	quit
.caption 説明
Mulkインタプリタを終了し、ホストOSに戻る。

*quit tool.@
	Object addSubclass: #Cmd.quit
**Cmd.quit >> main: args
	Mulk quit
