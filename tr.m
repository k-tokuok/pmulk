translate characters
$Id: mulk tr.m 1129 2023-11-08 Wed 22:28:42 kt $
#ja 文字の置換

*[man]
**#en
.caption SYNOPSIS
	tr SOURCE [DEST]
.caption DESCRIPTION
Translates the source character of standard input with the target character and outputs it to standard output.

The source and destination characters can be specified in the range "x-y".
If there is no character corresponding to the replacement source in the replacement destination, the replacement source character is deleted.
**#ja
.caption 書式
	tr 置換元 [置換先]
.caption 説明
標準入力の置換元の文字を置換先に文字に置換して、標準出力へ出力する。

置換元、置換先の文字は"x-y"の形で範囲指定する事が出来る。
置換先に置換元と対応する文字がない場合は、置換元の文字は削除される。

*tr tool.@
	Object addSubclass: #Cmd.tr instanceVars: "from to map"
**Cmd.tr >> makeArray: string
	AheadReader new init: string ->:reader;
	Array new ->:result;
	[reader nextChar notNil?] whileTrue:
		[reader skipWideEscapeChar ->:ch;
		result addLast: ch;
		reader nextChar = '-' ifTrue:
			[reader skipChar;
			ch code + 1 to: reader skipWideEscapeChar code, do:
				[:chcode result addLast: chcode asWideChar]]];
	result!
**Cmd.tr >> makeMap
	Dictionary new ->map;
	from size timesDo:
		[:i
		map at: (from at: i)
			put: (i < to size ifTrue: [to at: i] ifFalse: [nil])]
**Cmd.tr >> translate
	[In getWideChar ->:ch, notNil?] whileTrue:
		[map at: ch ifAbsent: [ch] ->ch;
		ch notNil? ifTrue: [Out put: ch]]
**Cmd.tr >> main: args
	self makeArray: args first ->from;
	args size > 1
		ifTrue: [self makeArray: (args at: 1)]
		ifFalse: [#()] ->to;
	self makeMap;
	self translate
