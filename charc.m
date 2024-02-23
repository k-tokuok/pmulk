count characters
$Id: mulk charc.m 1145 2023-12-09 Sat 21:39:51 kt $
#ja 文字を数える

*[man]
**#en
.caption SYNOPSIS
	charc [OPTION]
.caption DESCRIPTION
Print the number of characters on standard input.

Wide character count as one character.
CR/LF is count as one character in total.
.caption OPTION
	f -- Read file name and count for each file.
	w WIDTH -- Specifies the numeric width. If omitted, 7 is used.
**#ja
.caption 書式
	charc [OPTION]
.caption 説明
標準入力の文字数を出力する。

ワイド文字は1文字と数える。
CR/LFは合わせて1文字と数える。
.caption オプション
	f -- ファイル名を読み込み、それぞれのファイルに対して数える。
	w WIDTH -- 数値の幅を指定する。省略時は7とする。
*charc tool.@
	Mulk at: #TraitCount in: "traitc", addSubclass: #Cmd.charc
**Cmd.charc >> count: in
	0 ->:count;
	[in getWideChar notNil?] whileTrue: [count + 1 ->count];
	count!
