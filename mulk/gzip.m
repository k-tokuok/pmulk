gz file compression and decompression
$Id: mulk gzip.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja gzファイル圧縮/伸張

*[man]
**#en
.caption SYNOPSIS
	gzip gzFile -- compress input into gzFile
	gzip.d gzFile -- decompress gzFile and output
.caption DESCRIPTION
Compress and decompress to gz format.
**#ja
.caption 書式
	gzip gzFile -- 入力をgzFileに圧縮する。
	gzip.d gzFile -- gzFileを伸張し出力する。
.caption 説明
gz形式への圧縮、伸張を行う。

*gzip command.@
	Mulk import: "dl";
	Object addSubclass: #Cmd.gzip instanceVars: "bufsize buf gzfp"
**libz i/f.@
	"libz.so" ->:lib; -- linux/freebsd
	Mulk.hostOS ->:os, = #windows ifTrue: ["zlib1" ->lib];
	os = #cygwin ifTrue: ["cygz.dll" ->lib];
	os = #macosx ifTrue: ["libz.dylib" ->lib];
	DL import: lib procs: #(#gzopen 2 #gzread 3 #gzwrite 3 #gzclose 1)
***Cmd.gzip >> open: file mode: mode
	DL call: #gzopen with: file hostPath with: mode ->gzfp
***Cmd.gzip >> write: len
	DL call: #gzwrite with: gzfp with: buf with: len!
***Cmd.gzip >> read: len
	DL call: #gzread with: gzfp with: buf with: len!
***Cmd.gzip >> close
	DL call: #gzclose with: gzfp

**Cmd.gzip >> init
	4096 ->bufsize;
	FixedByteArray basicNew: bufsize ->buf
**Cmd.gzip >> main: args
	self open: args first asFile mode: "wb9";
	[In read: buf ->:s, <> 0] whileTrue: [self write: s];
	self close
**Cmd.gzip >> main.d: args
	self open: args first asFile mode: "rb";
	[self read: bufsize ->:s, <> 0] whileTrue: [Out write: buf size: s];
	self close
