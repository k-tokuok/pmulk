building a minimal image file
$Id: mulk setup.m 1445 2025-06-19 Thu 21:29:00 kt $
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

Other settings are as follows

	Mulk.lang 		"en"
	Mulk.charset	#utf8
	Mulk.newline 	#lf (#crlf on Windows/DOS)

When changing these, it is preferable to rewrite setup.m and rebuild your own mulk.mi from base.mi.
**#ja
.caption 書式
	mulk -i base.mi 'Mulk load: "setup.m", save: "mulk.mi"'
.caption 説明
コマンドインタプリタを実行する最小構成のイメージファイルを作成する。

makefileでsetup.mを指定しない場合のmulk.miに対応する。

Mulk.systemDirectoryとMulk.workDirectoryはイメージファイルのディレクトリに設定される為、システムを展開したディレクトリでそのまま運用する事が出来る。
他ディレクトリから実行する場合はPATHを通すか、mulk実行ファイルを直接指定する。

その他の設定は以下の通り。

	Mulk.lang		"en"
	Mulk.charset	#utf8
	Mulk.newline	#lf (Windows/DOSでは#crlf)

これらを変更する場合はsetup.mを書き換えて、base.miから自前のmulk.miを再構築するのが望ましい。

*import.@
	Mulk.hostOS = #windows | (Mulk.hostOS = #dos) 
		ifTrue: [Mulk import: "crlf"];
	Mulk import: "icmd";
	#Cmd.icmd ->Mulk.defaultMainClass;
	nil ->Mulk.systemDirectory ->Mulk.workDirectory ->File.home
