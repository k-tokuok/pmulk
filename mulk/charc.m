count characters
$Id: mulk charc.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 文字を数える

*[man]
**#en
.caption SYNOPSIS
	charc [OPTION]
.caption DESCRIPTION
Print the number of characters on standard input.

Characters represented by multibytes and CR/LF are counted together as one character.
.caption OPTION
	f -- Read file name and count for each file.
	w WIDTH -- Specifies the numeric width. If omitted, 7 is used.
**#ja
.caption 書式
	charc [OPTION]
.caption 説明
標準入力の文字数を出力する。

マルチバイトで表される文字、CR/LFは合わせて一文字と数える。
.caption オプション
	f -- ファイル名を読み込み、それぞれのファイルに対して数える。
	w WIDTH -- 数値の幅を指定する。省略時は7とする。
*charc tool.@
	Mulk at: #TraitCount in: "traitc", addSubclass: #Cmd.charc
**Cmd.charc >> count: in
	0 ->:count;
	[in getWideChar notNil?] whileTrue: [count + 1 ->count];
	count!
