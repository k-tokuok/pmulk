print working directory
$Id: mulk pwd.m 440 2020-06-09 Tue 22:21:55 kt $
#ja カレントディレクトリ名を表示する

*[man]
**#en
.caption SYNOPSIS
	pwd
.caption DESCRIPTION
Print the full path name of the current working directory.

**#ja
.caption 書式
	pwd
.caption 説明
カレントディレクトリのフルパス名を表示する。

*pwd tool.@
	Object addSubclass: #Cmd.pwd
**Cmd.pwd >> main: args
	Out putLn: "." asFile path
