copy files and directories
$Id: mulk cp.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ファイル・ディレクトリの複製

*[man]
**#en
.caption SYNOPSIS
	cp [OPTION] [SRC...] DEST
.caption DESCRIPTION
Copy file or directory SRC to DEST.

When DEST is a directory, multiple SRCs can be specified, and all of them are copied under DEST.
If DEST does not exist and SRC is a directory, create a DEST directory and copy all files and directories under SRC to DEST.

When SRC is omitted, the copy source file list is acquired from the standard input.
.caption OPTION
	v -- Display processings verbosely.
	o -- Stop on error if file is overwritten.
**#ja
.caption 書式
	cp [OPTION] [SRC...] DEST
.caption 説明
ファイル又はディレクトリSRCをDESTへ複製する。

DESTがディレクトリの場合はSRCを複数指定可能で、全てをDEST下へ複製する。
DESTが存在せず、SRCがディレクトリの場合はDESTディレクトリを作成し、SRC下の全てのファイル・ディレクトリをDEST下へ複製する。

SRCが省略された場合は標準入力から複製元ファイルリストを取得する。
.caption オプション
	v -- 処理を詳細に表示する。
	o -- 上書きをエラーとする。
	
*cp tool.@
	Mulk at: #Cmd.mv in: "mv", addSubclass: #Cmd.cp
**Cmd.cp >> main: args
	OptionParser new init: "vo" ->:op, parse: args ->args;
	self parseOption_v: op;
	self parseOption_o: op;
	
	args last ->:destFn;
	args removeLast;
	self copyArgs: (self files: args) to: destFn
