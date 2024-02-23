building a minimal image file
$Id: mulk setup.m 406 2020-04-19 Sun 11:29:54 kt $
#ja 最小構成のイメージファイルの構築

*[man]
**#en
.caption SYNOPSIS
	mulk -i base.mi 'Mulk load: "setup.m", save: "mulk.mi"'
.caption DESCRIPTION
Create a minimal image file to run the command interpreter.

Corresponds to mulk.mi when setup.m is not specified in makefile.

Since Mulk.systemDirectory and Mulk.workDirectory are set as image file directories, they can be used as they are in the directory where the system is expanded.
When executing from another directory, pass PATH or specify the mulk executable file directly.
**#ja
.caption 書式
	mulk -i base.mi 'Mulk load: "setup.m", save: "mulk.mi"'
.caption 説明
コマンドインタプリタを実行する最小構成のイメージファイルを作成する。

makefileでsetup.mを指定しない場合のmulk.miに対応する。

Mulk.systemDirectoryとMulk.workDirectoryはイメージファイルのディレクトリに設定される為、システムを展開したディレクトリでそのまま運用する事が出来る。
他ディレクトリから実行する場合はPATHを通すか、mulk実行ファイルを直接指定する。

*import.@
	Mulk import: "icmd";
	#Cmd.icmd ->Mulk.defaultMainClass;
	nil ->Mulk.systemDirectory ->Mulk.workDirectory
