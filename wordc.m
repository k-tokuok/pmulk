count words
$Id: mulk wordc.m 1145 2023-12-09 Sat 21:39:51 kt $
#ja 単語を数える
*[man]
**#en
.caption SYNOPSIS
	wordc [OPTION]
.caption DESCRIPTION
Print the number of words on standard input.

A 'word' means a string of characters separated by blanks and line breaks.
.caption OPTION
	f -- Read file name and count for each file.
	w WIDTH -- Specifies the numeric width. If omitted, 7 is used.
**#ja
.caption 書式
	wordc [OPTION]
.caption 説明
標準入力の単語の数を出力する。

単語は空白、改行で区切られた文字の列を意味する。
.caption オプション
	f -- ファイル名を読み込み、それぞれのファイルに対して数える。
	w WIDTH -- 数値の幅を指定する。省略時は7とする。
	
*wordc tool.@
	Mulk at: #TraitCount in: "traitc", addSubclass: #Cmd.wordc
**Cmd.wordc >> count: in
	0 ->:count;
	true ->:space?;
	[in getChar ->:ch, notNil?] whileTrue:
		[ch space? ->:nextSpace?;
		space? <> nextSpace? ifTrue:
			[nextSpace? ifTrue: [count + 1 ->count];
			nextSpace? ->space?]];
	space? ifFalse: [count + 1 ->count];
	count!
