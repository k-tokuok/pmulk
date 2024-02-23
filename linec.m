count lines
$Id: mulk linec.m 1145 2023-12-09 Sat 21:39:51 kt $
#ja 行を数える

*[man]
**#en
.caption SYNOPSIS
	linec [OPTION]
.caption DESCRIPTION
Print the number of lines on standard input.
.caption OPTION
	f -- Read file name and count for each file.
	w WIDTH -- Specifies the numeric width. If omitted, 7 is used.
**#ja
.caption 書式
	linec [OPTION]
.caption 説明
標準入力の行数を出力する。
.caption オプション
	f -- ファイル名を読み込み、それぞれのファイルに対して数える。
	w WIDTH -- 数値の幅を指定する。省略時は7とする。
	
*linec tool.@
	Mulk at: #TraitCount in: "traitc", addSubclass: #Cmd.linec
**Cmd.linec >> count: in
	in contentLines size!
