print date and time
$Id: mulk date.m 1433 2025-06-03 Tue 21:15:38 kt $
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
