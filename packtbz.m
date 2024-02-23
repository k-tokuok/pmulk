create tar + bz2 format mulk package
$Id: mulk packtbz.m 1101 2023-09-03 Sun 10:54:09 kt $
#ja tar + bz2形式のmulkパッケージの作成

*[man]
**#en
.caption SYNOPSIS
	package EXPR TARBZ2
.caption DESCRIPTION
Create a Mulk package specified by EXPR and compress it in tar + bz2 format.
.caption LIMITATION
cygwin commands can be executed on windows.
.caption SEE ALSO
.summary package
**#ja
.caption 書式
	packtbz EXPR TARBZ2
.caption 説明
EXPRで指定されたMulkパッケージを作り、tar + bz2形式で圧縮する。
.caption 制限事項
windows上ではcygwinのコマンドが実行可能であること。
.caption 関連項目
.summary package

*packtbz tool.@
	Mulk import: "tempfile";
	Object addSubclass: #Cmd.packtbz
**Cmd.packtbz >> cygpath: fileArg
	Mulk.hostOS = #windows
		ifTrue: ["os cygpath -u " + fileArg quotedHostPath, pipe getLn]
		ifFalse: [fileArg path]!
**Cmd.packtbz >> main: args
	TempFile create ->:topDir;
	args at: 1, asFile ->:tbzFile;
	tbzFile baseName ->:baseName;
	"package " + args first + ' ' + (topDir + baseName) quotedPath, runCmd;
	"os tar cjf " + (self cygpath: tbzFile) + " -C " + (self cygpath: topDir)
		+ ' ' + baseName, runCmd;
	"rm " + topDir quotedPath, runCmd
