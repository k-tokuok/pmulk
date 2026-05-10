deflate library for Android
$Id: mulk zliba.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Android implementation of Zlib.class class.
.caption SEE ALSO
.summary zlib

**#ja
.caption 説明
Zlib.class classのAndroid実装。
.caption 関連項目
.summary zlib

*import.@
	Android
		method: #zipCompress signature: "BB",
		method: #zipCrc32 signature: "JB",
		method: #zipUncompress signature: "BB"
		
*Zlib.a class.@
	Zlib.class addSubclass: #Zlib.a
**Zlib.a >> compress: src
	Android call: #zipCompress with: src!
**Zlib.a >> crc32: src
	Android call: #zipCrc32 with: src!
**Zlib.a >> uncompress: src destLen: destLen
	Android call: #zipUncompress with: src!
