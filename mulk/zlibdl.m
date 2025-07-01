Zlib.dl class
$Id: mulk zlibdl.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Dynamic library implementation of Zlib.class class.
.caption SEE ALSO
.summary zlib

**#ja
.caption 説明
Zlib.class classの動的ライブラリ実装。
.caption 関連項目
.summary zlib

*import.@
	Mulk import: "dl"
*import dll.@
	"libz.so" ->:lib; -- linux/freebsd
	Mulk.hostOS ->:os, = #windows ifTrue: ["zlib1" ->lib];
	os = #cygwin ifTrue: ["cygz.dll" ->lib];
	os = #macosx ifTrue: ["libz.dylib" ->lib];
	DL import: lib procs: #(#uncompress 4 #compress 4 #crc32 3)
	
*Zlib.dl class.@
	Zlib.class addSubclass: #Zlib.dl
**Zlib.dl >> compress: src
	src size ->:srcLen;
	FixedByteArray basicNew: srcLen ->:dest;
	DL.IntPtrBuffer new value: srcLen ->:destLenPtr;
	DL call: #compress with: dest with: destLenPtr with: src with: srcLen 
		->:st;
	st = 0 
		ifTrue: [dest copyFrom: 2 until: destLenPtr value - 4] 
		ifFalse: [nil]!
**Zlib.dl >> crc32: src
	DL call: #crc32 with: 0 with: src with: src size ->:result;
	result < 0 ifTrue: [0x100000000 + result ->result];
	result!
**Zlib.dl >> uncompress: src destLen: destLen
	FixedByteArray basicNew: src size + 2 ->:buf;
	buf at: 0 put: 0x78;
	buf at: 1 put: 0x9c;
	buf basicAt: 2 copyFrom: src at: 0 size: src size;
	FixedByteArray basicNew: destLen ->:dest;
	DL.IntPtrBuffer new value: destLen ->:destLenPtr;
	DL call: #uncompress with: dest with: destLenPtr with: buf with: buf size;
	dest!
