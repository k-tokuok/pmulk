terminate system
$Id: mulk quit.m 1433 2025-06-03 Tue 21:15:38 kt $
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
