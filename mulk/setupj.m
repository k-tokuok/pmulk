building a miniml image file for Japanese
$Id: mulk setupj.m 1598 2026-05-10 Sun 20:45:07 kt $
#ja 日本語版最小構成のイメージファイルの構築

*[man]
**#en
.caption SYNOPSIS
	mulk -i base.mi 'Mulk load: "setupj.m", save: "mulk.mi"'
.caption DESCRIPTION
Build a minimal image file for the Japanese version.

Set Mulk.lang to "ja"; otherwise, the process is the same as for setup.m, except that the character set on DOS/Windows is SJIS.
On DOS/Windows, you must change the character set of the system directory beforehand.
**#ja
.caption 書式
	mulk -i base.mi 'Mulk load: "setupj.m", save: "mulk.mi"'
.caption 説明
日本語版の最少構成のイメージファイルを構築する。

Mulk.langをjaとし、DOS/Windowsでは文字コードセットがSJISとなる以外はsetup.mと同様。
DOS/Windowsではシステムディレクトリの文字コードセットを変更しておく必要がある。

*@
	"ja" ->Mulk.lang;
	Mulk.hostOS = #windows | (Mulk.hostOS = #dos) 
		ifTrue: [Mulk import: #("crlf" "cp932")];
	Mulk import: "icmd";
	#Cmd.icmd ->Mulk.defaultMainClass;
	nil ->Mulk.systemDirectory ->Mulk.workDirectory	
