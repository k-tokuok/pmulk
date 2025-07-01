sleep for a specified number of seconds
$Id: mulk sleep.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 指定秒数の間スリープする

*[man]
**#en
.caption SYNOPSIS
	sleep SECONDS
.caption DESCRIPTION
Sleep by Number >> sleep for the specified number of seconds.
**#ja
.caption 書式
	sleep SECONDS
.caption 説明
指定秒数の間、Number >> sleepによりスリープする。

*sleep tool.@
	Object addSubclass: #Cmd.sleep
**Cmd.sleep >> main: args
	args first asNumber sleep
