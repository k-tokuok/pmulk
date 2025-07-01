integer conversion
$Id: mulk intconv.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 整数値変換

*[man]
**#en
.caption Description
Perform mutual conversion between signed and unsigned integers.

It is an internal function of fbdata and is not used directly.
**#ja
.caption 説明
符号付き、符号無し整数間の相互変換を行う。

fbdataの内部関数であり、直接使うことはない。

*Integer >> asInt16
	self > 0x7fff ifTrue: [self - 0x10000] ifFalse: [self]!
*Integer >> asUint16
	self < 0 ifTrue: [self + 0x10000] ifFalse: [self]!
*Integer >> asInt32
	self > 0x7fffffff ifTrue: [self - 0x100000000] ifFalse: [self]!
*Integer >> asUint32
	self < 0 ifTrue: [self + 0x100000000] ifFalse: [self]!
*Integer >> asInt64
	self > 0x7fffffffffffffff
		ifTrue: [self - 0xffffffffffffffff - 1] ifFalse: [self]!
*Integer >> asUint64
	self < 0 ifTrue: [self + 0xffffffffffffffff + 1] ifFalse: [self]!
