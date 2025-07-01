remove files and directories
$Id: mulk rm.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ファイル・ディレクトリの削除

*[man]
**#en
.caption SYNOPSIS
	rm [OPTION] [TARGET...]
.caption DESCRIPTION
Delete files or directories TARGET.

When TARGET is a directory, the elements in the directory are deleted recursively.

When TARGET is omitted, get file list from standard input.
.caption OPTION
	v -- Display processings verbosely.
	n -- It is not an error if there is no specified file.
**#ja
.caption 書式
	rm [options] [target...]
.caption 説明
targetを削除する。

targetがディレクトリの場合はディレクトリ内の要素を含めて再帰的に削除する。

targetが省略された場合は標準入力からファイルリストを取得する。
.caption オプション
	n -- 指定ファイルが無くてもエラーとはしない。
	v -- 処理を詳細に表示する。

*rm tool.@
	Mulk at: #Cmd.mv in: "mv", addSubclass: #Cmd.rm instanceVars: "none?"
**Cmd.rm >> removeFileOrDir: file
	none? and: [file none?], ifTrue: [self!];
	super removeFileOrDir: file
**Cmd.rm >> main: args
	OptionParser new init: "vn" ->:op, parse: args ->args;
	self parseOption_v: op;
	op at: 'n' ->none?;
	self removeArgs: (self files: args)
