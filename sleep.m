sleep for a specified number of seconds
$Id: mulk sleep.m 1318 2024-12-01 Sun 14:28:50 kt $
#ja 指定秒数の間スリープする

*[man]
**#en
.caption SYNOPSIS
	sleep SECONDS
.caption DESCRIPTION
Sleep by Number >> sleep for the specified number of seconds.
.caption SEE ALSO
.summary sleeplib
**#ja
.caption 書式
	sleep SECONDS
.caption 説明
指定秒数の間、Number >> sleepによりスリープする。
.caption 関連項目
.summary sleeplib

*sleep tool.@
	Object addSubclass: #Cmd.sleep
**Cmd.sleep >> main: args
	args first asNumber sleep
