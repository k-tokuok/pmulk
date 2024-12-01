coordinate and size on screen
$Id: mulk coord.m 1299 2024-11-10 Sun 15:32:06 kt $
#ja 画面上の座標・サイズ

*[man]
**#en
Use Integer as a two-dimensional coordinate or rectangle size.

It is used for the return value of screen-related primitives and is not usually used directly.
**#ja
Integerを二次元の座標や矩形のサイズとして用いる。

画面関連のプリミティブの返り値などに使われ、通常直接使用することはない。

*Integer >> coordX
	self >> 14 & 0x3fff!
*Integer >> coordY
	self & 0x3fff!
*Integer >> coordY: y
	self & 0x3fff << 14 | (y & 0x3fff)!
