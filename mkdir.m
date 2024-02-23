make directory
$Id: mulk mkdir.m 406 2020-04-19 Sun 11:29:54 kt $
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
