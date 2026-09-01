deflate compression and decompression
$Id: mulk deflate.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja deflate圧縮/伸張

*[man]
**#en
.caption SYNOPSIS
	deflate -- compress input to output
	deflate.d -- decompress input and output
.caption DESCRIPTION
Simple data compression is performed by the deflate algorithm.
.caption SEE ALSO
.summary zlib
**#ja
.caption 書式
	deflate -- 入力を圧縮して出力する
	deflate.d -- 入力を伸張して出力する
.caption 説明
deflateアルゴリズムにより単純なデータ圧縮を行う。
.caption 関連項目
.summary zlib

*deflate tool.@
	Mulk import: #("fbdatal" "zlib");
	Object addSubclass: #Cmd.deflate
**Cmd.deflate >> main: args
	In contentBytes ->:src;
	Zlib compress: src ->:dest;
	FixedByteArray basicNew: 4 ->:buf;
	buf ui32lAt: 0 put: src size;
	Out write: buf size: 4;
	Out write: dest
**Cmd.deflate >> main.d: args
	In contentBytes ->:buf;
	buf ui32lAt: 0 ->:destLen;
	Zlib uncompress: (buf copyFrom: 4) destLen: destLen ->:dest;
	Out write: dest
