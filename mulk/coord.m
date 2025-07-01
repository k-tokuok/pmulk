screen coordinates and size (Coord format)
$Id: mulk coord.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 画面上の座標・サイズ (coord形式)

*[man]
**#en
Use Integer as a two-dimensional coordinate or rectangle size.

It is used for the return value of screen-related primitives and is not usually used directly.
**#ja
coord形式は28ビット正整数値を二次元の座標や矩形のサイズとして用いる。

*Integer >> coordX
	self >> 14 & 0x3fff!
**[man.m]
***#en
Returns X coordinate or width.
***#ja
X座標又は幅を返す。

*Integer >> coordY
	self & 0x3fff!
**[man.m]
***#en
Returns Y coordinate or height.
***#ja
Y座標又は高さを返す。

*Integer >> coordY: y
	self & 0x3fff << 14 | (y & 0x3fff)!
**[man.m]
***#en
Returns coord format value (self, y).
***#ja
(self, y)なるcoord値を返す。

*Integer >> asCoordString
	"(" + self coordX + ',' + self coordY + ')'!
**[man.m]
***#en
Returns a string representation of self as a coord value.
***#ja
selfのcoord値としての文字列表現を返す。
