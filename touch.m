change the modification date and time of the file
$Id: mulk touch.m 475 2020-07-16 Thu 22:28:43 kt $
#ja ファイルの更新日時を変更する
*[man]
**#en
.caption SYNOPSIS
	touch FILE...
.caption DESCRIPTION
Change the modification date and time of FILE to the current time.
**#ja
.caption 書式
	touch FILE...
.caption 説明
FILEの更新日時を現在時刻に変更する。

*touch tool.@
	Object addSubclass: #Cmd.touch
**Cmd.touch >> main: args
	args do:
		[:fn
		fn asFile ->:file;
		file none? or: [file size = 0],
			ifTrue: [file openWrite close]
			ifFalse: 
				[file openUpdate ->:fs;
				fs getByte ->:b;
				fs seek: 0;
				fs putByte: b;
				fs close]]
