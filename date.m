print date and time
$Id: mulk date.m 415 2020-05-03 Sun 21:22:02 kt $
#ja 日付と時刻の表示

*[man]
**#en
.caption SYNOPSIS
	date
.caption DESCRIPTION
Print the current date and time to standard output.
**#ja
.caption 書式
	date
.caption 説明
現在の日付・時刻を標準出力へ出力する。

*date tool.@
	Object addSubclass: #Cmd.date
**Cmd.date >> main: args
	Out putLn: DateAndTime new initNow
