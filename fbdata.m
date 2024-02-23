byte representation of integer values
$Id: mulk fbdata.m 990 2023-01-01 Sun 21:12:27 kt $
#ja 整数値のバイト表現

*[man]
**#en
.caption DESCRIPTION
Provides a function to read and write numerical data in FixedByteArray in the endian of the host system.
**#ja
.caption 説明
FixedByteArrayにホストシステムのエンディアンで数値データを読み書きする機能を提供する。

*import.@
	Mulk import: (DL.littleEndian? ifTrue: ["fbdatal"] ifFalse: ["fbdatab"])
	
*FixedByteArray >> i16At: pos
	DL.littleEndian?
		ifTrue: [self i16lAt: pos]
		ifFalse: [self i16bAt: pos]!
**[man.m]
***#en
Returns a value obtained by interpreting 2 bytes from the pos byte of the receiver as a 16-bit signed integer value.
***#ja
レシーバーのposバイト目から2バイト分を16ビット符号付き整数値として解釈した値を返す。

*FixedByteArray >> i16At: pos put: int16
	DL.littleEndian?
		ifTrue: [self i16lAt: pos put: int16]
		ifFalse: [self i16bAt: pos put: int16]
**[man.m]
***#en
Write a 16-bit signed integer value int16 to the 2 bytes from the pos byte of the receiver.
***#ja
レシーバーのposバイト目からの2バイトに16ビット符号付き整数値int16を書き込む。

*FixedByteArray >> i32At: pos
	DL.littleEndian?
		ifTrue: [self i32lAt: pos]
		ifFalse: [self i32bAt: pos]!
**[man.m]
***#en
Returns a value obtained by interpreting the 4 bytes from the pos byte of the receiver as a 32-bit signed integer value.
***#ja
レシーバーのposバイト目から4バイト分を32ビット符号付き整数値として解釈した値を返す。

*FixedByteArray >> i32At: pos put: i32
	DL.littleEndian?
		ifTrue: [self i32lAt: pos put: i32]
		ifFalse: [self i32bAt: pos put: i32]
**[man.m]
***#en
Write a 32-bit signed integer value i32 to 4 bytes from the pos byte of the receiver.
***#ja
レシーバーのposバイト目からの4バイトに32ビット符号付き整数値i32を書き込む。

*FixedByteArray >> i64At: pos
	DL.littleEndian?
		ifTrue: [self i64lAt: pos]
		ifFalse: [self i64bAt: pos]!
**[man.m]
***#en
Returns a value obtained by interpreting 8 bytes from the pos byte of the receiver as a 64-bit signed integer value.
***#ja
レシーバーのposバイト目から8バイト分を64ビット符号付き整数値として解釈した値を返す。

*FixedByteArray >> i64At: pos put: i64
	DL.littleEndian?
		ifTrue: [self i64lAt: pos put: i64]
		ifFalse: [self i64bAt: pos put: i64]
**[man.m]
***#en
Write the 64-bit signed integer value i64 to the 8th byte from the pos byte of the receiver.
***#ja
レシーバーのposバイト目からの8バイトに64ビット符号付き整数値i64を書き込む。

*Integer >> asUintptr
	DL.ptrByteSize = 4 ifTrue: [self asUint32] ifFalse: [self asUint64]!
*FixedByteArray >> nativePtrAt: pos
	DL.ptrByteSize = 4
		ifTrue: [self i32At: pos]
		ifFalse: [self i64At: pos]!
**[man.m]
***#en
Returns a value obtained by interpreting the area corresponding to the address length from the pos byte of the receiver as an integer value.
***#ja
レシーバーのposバイト目からアドレス長分の領域を整数値として解釈した値を返す。

*Integer >> asIntptr
	DL.ptrByteSize = 4 ifTrue: [self asInt32] ifFalse: [self asInt64]!
*FixedByteArray >> nativePtrAt: pos put: ptr
	DL.ptrByteSize = 4
		ifTrue: [self i32At: pos put: ptr]
		ifFalse: [self i64At: pos put: ptr]
**[man.m]
***#en
Write an integer value ptr for the address length from the pos byte of the receiver.
***#ja
レシーバーのposバイト目以降にアドレス長分の整数値ptrを書き込む。
