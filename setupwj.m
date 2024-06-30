building a minimal image file for Windows/Japanese
$Id: mulk setupwj.m 1267 2024-06-28 Fri 22:17:08 kt $
#ja 最小構成のイメージファイルの構築 (Windows/日本語版)

*[man]
**#en
.caption SYNOPSIS
	mulk -i base.mi 'Mulk load: "setupwj.m", save: "mulk.mi"'
.caption DESCRIPTION
Build a minimum configuration image file for Windows/Japanese environment.

The character code set will be SJIS (code page 932).
.caption SEE ALSO
.summary setup
**#ja
.caption 書式
	mulk -i base.mi 'Mulk load: "setupwj.m", save: "mulk.mi"'
.caption 説明
Windows/日本語環境用の最小構成のイメージファイルを構築する。

文字コードセットはSJIS(コードページ932)となる。
.caption 関連項目
.summary setup

*import.@
	Mulk import: #("cp932" "crlf" "icmd");
	"ja" ->Mulk.lang;
	#Cmd.icmd ->Mulk.defaultMainClass;
	nil ->Mulk.systemDirectory ->Mulk.workDirectory
