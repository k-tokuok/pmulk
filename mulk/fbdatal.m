little endian representation of integer values
$Id: mulk fbdatal.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 整数値のlittle endian表現

*[man]
**#en
.caption DESCRIPTION
Provides the function to read and write Little Endian integer data to FixedByteArray.
**#ja
.caption 説明
FixedByteArrayにLittle Endianの整数データを読み書きする機能を提供する。

*[test] Test.FixedByteArray class.@
	UnitTest addSubclass: #Test.FixedByteArray.fbdatal
		instanceVars: "bytes" ->testClass
**Test.FixedByteArray.fbdatal >> setup
	#[1 2 3 4 5 6 7 8 0xf0 0xf1 0xf2 0xf3] copy ->bytes
	
*import.@
	Mulk import: "intconv"
	
*FixedByteArray >> ui16lAt: pos
	(self at: pos) | (self at: pos + 1, << 8)!
**[man.m]
***#en
Returns the 2-byte area from the pos-th byte of the receiver interpreted as a 16-bit unsigned integer value.
***#ja
レシーバーのposバイト目から2バイト分の領域を16ビット符号無し整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes ui16lAt: 0) = 0x0201
	
*FixedByteArray >> ui16lAt: pos put: ui16
	self assert: (ui16 between: 0 and: 0xffff);
	self at: pos put: ui16 & 0xff;
	self at: pos + 1 put: ui16 >> 8
**[man.m]
***#en
Write the 16-bit unsigned integer value ui16 to the 2-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から2バイト分の領域に16ビット符号無し整数値ui16を書き込む。
**[test.m]
	bytes ui16lAt: 0 put: 0x1234;
	self assert: (bytes ui16lAt: 0) = 0x1234

*FixedByteArray >> i16lAt: pos
	self ui16lAt: pos, asInt16!
**[man.m]
***#en
Returns the 2-byte area from the pos-th byte of the receiver interpreted as a 16-bit signed integer value.
***#ja
レシーバーのposバイト目から2バイト分の領域を16ビット符号付き整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes i16lAt: 8) = -3600

*FixedByteArray >> i16lAt: pos put: i16
	self ui16lAt: pos put: i16 asUint16
**[man.m]
***#en
Write the 16-bit signed integer value i16 to the 2-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から2バイト分の領域に16ビット符号付き整数値i16を書き込む。
**[test.m]
	bytes i16lAt: 0 put: -3600;
	self assert: (bytes i16lAt: 0) = -3600
	
*FixedByteArray >> ui32lAt: pos
	(self ui16lAt: pos) | (self ui16lAt: pos + 2, << 16)!
**[man.m]
***#en
Returns the 4-byte area from the pos-th byte of the receiver interpreted as a 32-bit unsigned integer value.
***#ja
レシーバーのposバイト目から4バイト分の領域を32ビット符号無し整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes ui32lAt: 0) = 0x04030201
	
*FixedByteArray >> ui32lAt: pos put: ui32
	self ui16lAt: pos put: ui32 & 0xffff;
	self ui16lAt: pos + 2 put: ui32 >> 16
**[man.m]
***#en
Write the 32-bit unsigned integer value ui32 to the 4-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から4バイト分の領域に32ビット符号無し整数値ui32を書き込む。
**[test.m]
	bytes ui32lAt: 0 put: 0x12345678;
	self assert: (bytes ui32lAt: 0) = 0x12345678

*FixedByteArray >> i32lAt: pos
	self ui32lAt: pos, asInt32!
**[man.m]
***#en
Returns the 4-byte area from the pos-th byte of the receiver interpreted as a 32-bit signed integer value.
***#ja
レシーバーのposバイト目から4バイト分の領域を32ビット符号付き整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes i32lAt: 8) = -202182160

*FixedByteArray >> i32lAt: pos put: i32
	self ui32lAt: pos put: i32 asUint32
**[man.m]
***#en
Write the 32-bit signed integer value i32 to the 4-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から4バイト分の領域に32ビット符号付き整数値i32を書き込む。
**[test.m]
	bytes i32lAt: 0 put: -202182160;
	self assert: (bytes i32lAt: 0) = -202182160

*FixedByteArray >> ui64lAt: pos
	(self ui32lAt: pos) | (self ui32lAt: pos + 4, << 32)!
**[man.m]
***#en
Returns the 8-byte area from the pos-th byte of the receiver interpreted as a 64-bit unsigned integer value.
***#ja
レシーバーのposバイト目から8バイト分の領域を64ビット符号無し整数値として解釈した値を返す。
**[test.m]
	self assert: (bytes ui64lAt: 0, = 0x0807060504030201)
	
*FixedByteArray >> ui64lAt: pos put: ui64
	self ui32lAt: pos put: ui64 & 0xffffffff;
	self ui32lAt: pos + 4 put: ui64 >> 32
**[man.m]
***#en
Write the 64-bit unsigned integer value ui64 to the 8-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から8バイト分の領域に64ビット符号無し整数値ui64を書き込む。
**[test.m]
	bytes ui64lAt: 0 put: 0x0203040506070809;
	self assert: (bytes ui64lAt: 0, = 0x0203040506070809)

*FixedByteArray >> i64lAt: pos
	self ui64lAt: pos, asInt64!
**[man.m]
***#en
Returns the 8-byte area from the pos-th byte of the receiver interpreted as a 64-bit signed integer value.
***#ja
レシーバーのposバイト目から8バイト分の領域を64ビット符号付き整数値として解釈した値を返す。
**[test.m]
	bytes ui64lAt: 0 put: 0xffffffffffffffff;
	self assert: (bytes i64lAt: 0, = -1)

*FixedByteArray >> i64lAt: pos put: i64
	self ui64lAt: pos put: i64 asUint64
**[man.m]
***#en
Write the 64-bit signed integer value i64 to the 8-byte area from the pos-th byte of the receiver.
***#ja
レシーバーのposバイト目から8バイト分の領域に64ビット符号付き整数値i64を書き込む。
**[test.m]
	bytes i64lAt: 0 put: -1;
	self assert: (bytes i64lAt: 0, = -1)
