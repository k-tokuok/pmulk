building a minimal image file (pmulk/android)
$Id: mulk setupa.m 1593 2026-05-02 Sat 20:59:30 kt $
#ja 最小構成のイメージファイルの構築 (pmulk/android)
*[man]
**#en
.caption SYNOPSIS
	Mulk load: "setupa.m" asSystemFile
.caption DESCRIPTION
Initialize the Android version.

Extract the system directory using the contents of the latest pmulk release on GitHub, and create an image file containing the minimum configuration required for the command interpreter to run.
It can be executed from the REPL immediately after installing the APK.
**#ja
.caption 書式
	Mulk load: "setupa.m" asSystemFile
.caption 説明
Android版の初期化を行う。

GitHub上のpmulkの最新リリースの内容でシステムディレクトリを展開し、コマンドインタプリタの動作する最小構成のイメージファイルを作成する。
apkインストール直後のreplから実行可能。

*@
	Mulk import: "icmd";
	#Cmd.icmd ->Mulk.defaultMainClass;
	Android filesDir ->:root;
	root + "work" ->Mulk.workDirectory, mkdir;
	root + "mulk" ->Mulk.systemDirectory;
	root + "h"  ->File.home, mkdir;
	root + "mulk.mi" ->:ifile;
	Android imageFile: ifile;
	Mulk save: ifile;
	
	Mulk.extraSystemDirectories addLast: root + "mulka0";
	"update.extract mulk" runCmd
