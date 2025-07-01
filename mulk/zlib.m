deflate library (Zlib.class class)
$Id: mulk zlib.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja deflateライブラリ (Zlib.class class)

*[man]
**#en
.caption DESCRIPTION
Performs compression/decompression using the deflate algorithm.
.hierarchy Zlib.class
Don't construct instances with new, use the global object Zlib.
**#ja
.caption 説明
deflateアルゴリズムによる圧縮/伸張を行う。
.hierarchy Zlib.class
インスタンスをnewで構築せず、グローバルオブジェクトZlibを使用すること。

*Zlib.class class.@
	Object addSubclass: #Zlib.class
**Zlib.class >> compress: src
	self shouldBeImplemented
***[man.m]
****#en
Compress FixedByteArray src and return the resulting FixedByteArray.
Returns nil if it cannot be compressed.
****#ja
FixedByteArray srcを圧縮し、結果のFixedByteArrayを返す。
圧縮出来ない場合はnilを返す。

**Zlib.class >> crc32: src
	self shouldBeImplemented
***[man.m]
****#en
Returns the cyclic redundancy check value (CRC-32) of FixedByteArray src.
****#ja
FixedByteArray srcの巡回冗長検査値(CRC-32)を返す。

**Zlib.class >> uncompress: src destLen: destLen
	self shouldBeImplemented
***[man.m]
****#en
Decompress FixedByteArray src and return the resulting FixedByteArray.
The size after decompression must be destLen.
****#ja
FixedByteArray srcを伸張し、結果のFixedByteArrayを返す。
伸張後のサイズはdestLenでなくてはならない。

*resisdent.@
	"dl" ->:name;
	Mulk.hostOS = #android ifTrue: ["a" ->name];
	Mulk at: #Zlib put: 
		(Mulk at: ("Zlib." + name) asSymbol in: "zlib" + name, new)
