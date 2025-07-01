make directory
$Id: mulk mkdir.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ディレクトリの作成

*[man]
**#en
.caption SYNOPSIS
	mkdir DIR
.caption DESCRIPTION
Create the directory DIR.

**#ja
.caption 書式
	mkdir DIR
.caption 説明
ディレクトリDIRを作成する。

*mkdir tool.@
	Object addSubclass: #Cmd.mkdir
**Cmd.mkdir >> main: args
	args first asFile mkdir
