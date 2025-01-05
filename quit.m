terminate system
$Id: mulk quit.m 1346 2025-01-02 Thu 20:00:51 kt $
#ja システムを終了する

*[man]
**#en
.caption SYNOPSIS
	quit
.caption DESCRIPTION
Quit the Mulk processor and return to the host OS.

**#ja
.caption 書式
	quit
.caption 説明
Mulk処理系を終了し、ホストOSに戻る。

*quit tool.@
	Object addSubclass: #Cmd.quit
**Cmd.quit >> main: args
	Mulk quit
