base64 conversion
$Id: mulk base64.m 932 2022-09-18 Sun 17:45:15 kt $
#ja base64変換
*[man]
**#en
.caption SYNOPSIS
	base64
	base64.d -- Reverse conversion
.caption DESCRIPTION
Convert standard input to base64 format and output to standard output.
**#ja
.caption 書式
	base64
	base64.d -- 逆変換
.caption 説明
標準入力をbase64形式に変換し標準出力へ出力する。

*base64 tool.@
	Object addSubclass: #Cmd.base64
**encode.
***Cmd.base64 >> encodeBits: b6
	b6 < 26 ifTrue: [Out putByte: 'A' code + b6!];
	b6 < 52 ifTrue: [Out putByte: 'a' code + b6 - 26!];
	b6 < 62 ifTrue: [Out putByte: '0' code + b6 - 52!];
	b6 = 62 ifTrue: [Out put: '+'!];
	b6 = 63 ifTrue: [Out put: '/'!];
	b6 = 64 ifTrue: [Out put: '='!]
***Cmd.base64 >> encode: buf size: size
	buf fill: 0 from: size until: 3;
	buf at: 0, << 16 | (buf at: 1, << 8) | (buf at: 2) ->:n;
	self encodeBits: n >> 18;
	self encodeBits: n >> 12 & 0x3f;
	self encodeBits: (size = 1 ifTrue: [64] ifFalse: [n >> 6 & 0x3f]);
	self encodeBits: (size <= 2 ifTrue: [64] ifFalse: [n & 0x3f])
***Cmd.base64 >> main: args
	FixedByteArray basicNew: 3 ->:buf;
	0 ->:total;
	[In read: buf ->:s, <> 0] whileTrue:
		[self encode: buf size: s;
		total + s ->total;
		total % 48 = 0 ifTrue: [Out putLn]];
	total % 48 <> 0 ifTrue: [Out putLn]

**decode.
***Cmd.base64 >> decodeChar: ch
	ch upper? ifTrue: [ch code - 'A' code!];
	ch lower? ifTrue: [ch code - 'a' code + 26!];
	ch digit? ifTrue: [ch code - '0' code + 52!];
	ch = '+' ifTrue: [62!];
	ch = '/' ifTrue: [63!];
	ch = '=' ifTrue: [64!]
***Cmd.base64 >> decode: s
	self decodeChar: (s at: 0), << 18 ->:n;
	n | (self decodeChar: (s at: 1), << 12) ->n;
	self decodeChar: (s at: 2) ->:b6, = 64
		ifTrue: [1 ->:size]
		ifFalse:
			[n | (b6 << 6) ->n;
			self decodeChar: (s at: 3) ->b6, = 64,
				ifTrue: [2 ->size]
				ifFalse:
					[n | b6 -> n;
					3 ->size]];
	Out putByte: n >> 16;
	size >= 2 ifTrue: [Out putByte: n >> 8 & 0xff];
	size = 3 ifTrue: [Out putByte: n & 0xff]
***Cmd.base64 >> main.d: args
	In contentLinesDo:
		[:s
		0 ->:i;
		[i < s size] whileTrue:
			[self decode: (s copyFrom: i until: i + 4);
			i + 4 ->i]]
