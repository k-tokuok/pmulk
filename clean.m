clean up temporary files
$Id: mulk clean.m 907 2022-08-15 Mon 22:15:35 kt $
#ja テンポラリファイルのクリーンアップ

*[man]
**#en
.caption SYNOPSIS
	clean
.caption DESCRIPTION
Delete all temporary files created by TempFile.
.caption LIMITATION
The temporary file is deleted regardless of whether it is in use or not.
.caption SEE ALSO
.summary tempfile
**#ja
.caption 書式
	clean
.caption 説明
TempFileで作られるテンポラリファイルを全て削除する。
.caption 制限事項
テンポラリファイルが使用中か否かに関わらず削除される。
.caption 関連項目
.summary tempfile

*clean tool.@
	Object addSubclass: #Cmd.clean
**Cmd.clean >> main: args
	"ls -F " + "_?*" asWorkFile quotedPath + " | rm", runCmd
