count bytes
$Id: mulk bytec.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja バイト数を数える

*[man]
**#en
.caption SYNOPSIS
	bytec [OPTION]
.caption DESCRIPTION
Print the number of bytes on standard input.
.caption OPTION
	f -- Read file name and count for each file.
	w WIDTH -- Specifies the numeric width. If omitted, 7 is used.
**#ja
.caption 書式
	bytec [OPTION]
.caption 説明
標準入力のバイト数を出力する。
.caption オプション
	f -- ファイル名を読み込み、それぞれのファイルに対して数える。
	w WIDTH -- 数値の幅を指定する。省略時は7とする。

*bytec tool.@
	Mulk at: #TraitCount in: "traitc", addSubclass: #Cmd.bytec
**Cmd.bytec >> count: in
	0 ->:result;
	[in getByte <> -1] whileTrue: [result + 1 ->result];
	result!
