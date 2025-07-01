big endian representation of integer values
$Id: mulk fbdatab.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 整数値のbig endian表現

*[man]
**#en
.caption DESCRIPTION
Provides the function to read and write Big Endian integer data to FixedByteArray.
**#ja
.caption 説明
FixedByteArrayにBig Endianの整数データを読み書きする機能を提供する。

*[test] Test.FixedByteArray class.@
	UnitTest addSubclass: #Test.FixedByteArray.fbdatab
		instanceVars: "bytes" ->testClass
**Test.FixedByteArray.fbdatab >> setup
	#[8 7 6 5 4 3 2 1 0xf3 0xf2 0xf1 0xf0] copy ->bytes
	
*import.@
	Mulk import: "intconv"

*FixedByteArray >> ui16bAt: pos
	(self at: pos, << 8) | (self at: pos + 1)!
**[man.m]
***#en
Returns the 2-byte area from the pos-th byte of the receiver interpreted as a 16-bit unsigned integer value.
***#ja
レシーバーのposバイト目から2バイト分の領域を16ビット符号無し整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes ui16bAt: 6) = 0x0201
	
*FixedByteArray >> ui16bAt: pos put: ui16
	self assert: (ui16 between: 0 and: 0xffff);
	self at: pos put: ui16 >> 8;
	self at: pos + 1 put: ui16 & 0xff
**[man.m]
***#en
Write the 16-bit unsigned integer value ui16 to the 2-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から2バイト分の領域に16ビット符号無し整数値ui16を書き込む。
**[test.m]
	bytes ui16bAt: 0 put: 0x1234;
	self assert: (bytes ui16bAt: 0) = 0x1234
	
*FixedByteArray >> i16bAt: pos
	self ui16bAt: pos, asInt16!
**[man.m]
***#en
Returns the 2-byte area from the pos-th byte of the receiver interpreted as a 16-bit signed integer value.
***#ja
レシーバーのposバイト目から2バイト分の領域を16ビット符号付き整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes i16bAt: 10) = -3600
	
*FixedByteArray >> i16bAt: pos put: i16
	self ui16bAt: pos put: i16 asUint16
**[man.m]
***#en
Write the 16-bit signed integer value i16 to the 2-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から2バイト分の領域に16ビット符号付き整数値i16を書き込む。
**[test.m]
	bytes i16bAt: 0 put: -3600;
	self assert: (bytes i16bAt: 0) = -3600
	
*FixedByteArray >> ui32bAt: pos
	(self ui16bAt: pos, << 16) | (self ui16bAt: pos + 2)!
**[man.m]
***#en
Returns the 4-byte area from the pos-th byte of the receiver interpreted as a 32-bit unsigned integer value.
***#ja
レシーバーのposバイト目から4バイト分の領域を32ビット符号無し整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes ui32bAt: 4) = 0x04030201
	
*FixedByteArray >> ui32bAt: pos put: ui32
	self ui16bAt: pos put: ui32 >> 16;
	self ui16bAt: pos + 2 put: ui32 & 0xffff
**[man.m]
***#en
Write the 32-bit unsigned integer value ui32 to the 4-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から4バイト分の領域に32ビット符号無し整数値ui32を書き込む。
**[test.m]
	bytes ui32bAt: 0 put: 0x12345678;
	self assert: (bytes ui32bAt: 0) = 0x12345678

*FixedByteArray >> i32bAt: pos
	self ui32bAt: pos, asInt32!
**[man.m]
***#en
Returns the 4-byte area from the pos-th byte of the receiver interpreted as a 32-bit signed integer value.
***#ja
レシーバーのposバイト目から4バイト分の領域を32ビット符号付き整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes i32bAt: 8) = -202182160
	
*FixedByteArray >> i32bAt: pos put: i32
	self ui32bAt: pos put: i32 asUint32
**[man.m]
***#en
Write the 32-bit signed integer value i32 to the 4-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から4バイト分の領域に32ビット符号付き整数値i32を書き込む。
**[test.m]
	bytes i32bAt: 0 put: -202182160;
	self assert: (bytes i32bAt: 0) = -202182160
	
*FixedByteArray >> ui64bAt: pos
	(self ui32bAt: pos, << 32) | (self ui32bAt: pos + 4)!
**[man.m]
***#en
Returns the 8-byte area from the pos-th byte of the receiver interpreted as a 64-bit unsigned integer value.
***#ja
レシーバーのposバイト目から8バイト分の領域を64ビット符号無し整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes ui64bAt: 0, = 0x0807060504030201)
	
*FixedByteArray >> ui64bAt: pos put: ui64
	self ui32bAt: pos put: ui64 >> 32;
	self ui32bAt: pos + 4 put: ui64 & 0xffffffff
**[man.m]
***#en
Write the 64-bit unsigned integer value ui64 to the 8-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から8バイト分の領域に64ビット符号無し整数値ui64を書き込む。
**[test.m]
	bytes ui64bAt: 0 put: 0x0203040506070809;
	self assert: (bytes ui64bAt: 0, = 0x0203040506070809)
	
*FixedByteArray >> i64bAt: pos
	self ui64bAt: pos, asInt64!
**[man.m]
***#en
Returns the 8-byte area from the pos-th byte of the receiver interpreted as a 64-bit signed integer value.
***#ja
レシーバーのposバイト目から8バイト分の領域を64ビット符号付き整数値として解釈した値を返す。
**[test.m]
	bytes ui64bAt: 0 put: 0xffffffffffffffff;
	self assert: (bytes i64bAt: 0) = -1
	
*FixedByteArray >> i64bAt: pos put: i64
	self ui64bAt: pos put: i64 asUint64
**[man.m]
***#en
Write the 64-bit signed integer value i64 to the 8-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から8バイト分の領域に64ビット符号付き整数値i64を書き込む。
**[test.m]
	bytes i64bAt: 0 put: -1;
	self assert: (bytes i64bAt: 0) = -1
