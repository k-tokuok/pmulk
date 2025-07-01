create a zipped Mulk package
$Id: mulk packzip.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja zip形式のMulkパッケージの作成

*[man]
**#en
.caption SYNOPSIS
	packzip EXPR ZIP
.caption DESCRIPTION
Create a Mulk package specified by EXPR and compress it in ZIP format.
.caption SEE ALSO
.summary package
**#ja
.caption 書式
	packzip EXPR ZIP
.caption 説明
EXPRで指定されたMulkパッケージを作り、ZIP形式で圧縮する。
.caption 関連項目
.summary package

*packzip tool.@
	Mulk import: "tempfile";
	Object addSubclass: #Cmd.packzip
**Cmd.packzip >> main: args
	TempFile create quotedPath ->:destDir;
	"package " + args first + ' ' + destDir, runCmd;
	"zip.c " + (args at: 1) + ' ' + destDir, runCmd;
	"rm " + destDir, runCmd
