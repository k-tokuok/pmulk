encryption
$Id: mulk crypt.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 暗号化

*[man]
**#en
.caption SYNOPSIS
	crypt KEY
	crypt.d KEY -- Decription
.caption DESCRIPTION
Output the bytes that encrypted the input.

The original input is obtained by decrypting the byte string with the same key.
It is a simple stream cipher with pseudo random numbers that reflects KEY in the seed, and has no practical strength.
**#ja
.caption 書式
	crypt key
	crypt.d key -- 復号
.caption 説明
入力を暗号化したバイト列を出力する。

バイト列を同じキーで復号すると元の入力が得られる。
KEYを種に反映させた疑似乱数による単純ストリーム暗号で、実用的な強度はない。

*crypt tool.@
	Mulk import: #("fbdatal" "xorshift" "random");
	Object addSubclass: #Cmd.crypt
**Cmd.crypt >> codec: key
	RandomGenerator.Xorshift new randomize: key ->:r;
	[In getByte ->:b, <> -1] whileTrue: [Out putByte: b ^ (r until: 256)]
**Cmd.crypt >> main: args
	Random int32 ->:key;
	FixedByteArray basicNew: 4, ui32lAt: 0 put: key ->:buf;
	Out write: buf;
	self codec: args first hash ^ key
**Cmd.crypt >> main.d: args
	FixedByteArray basicNew: 4 ->:buf;
	In read: buf;
	buf ui32lAt: 0 ->:key;
	self codec: args first hash ^ key
