bzip2 compression and decompression
$Id: mulk bzip2.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja bzip2圧縮/伸張

*[man]
**#en
.caption SYNOPSIS
	bzip2 bz2File [file] -- Compress file into bz2File.
	bzip2.d bz2File [file] -- Decompress bz2File into file.

.caption DESCRIPTION
Compress and decompress to bzip2 format.

If file is omitted, the standard input and standard output are used.
**#ja
.caption 書式
	bzip2 bz2File [file] -- fileをbz2Fileに圧縮する。
	bzip2.d bz2File [file] -- bz2Fileをfileへ伸張する。

.caption 説明
bz2形式への圧縮、伸張を行う。

fileを省略した場合は、それぞれ標準入力、標準出力が対象になる。

*imports.@
	Mulk import: #("tempfile" "dl")
	
*Bzip2 class.@
	Object addSubclass: #Bzip2 instanceVars: "bufSize buf bzfp"

**libbz2 i/f.@
	"libbz2.so.1" ->:lib; -- linux.
	Mulk.hostOS ->:os, = #windows ifTrue: ["libbz2" ->lib];
	os = #macosx ifTrue: ["libbz2.dylib" ->lib];
	os = #cygwin ifTrue: ["cygbz2-1.dll" ->lib];
	os = #freebsd ifTrue: ["libbz2.so" ->lib];
	os = #windows
		ifTrue:
			[#(#BZ2_bzopen 102 #BZ2_bzread 103 #BZ2_bzwrite 103 #BZ2_bzflush 101
				#BZ2_bzclose 101)]
		ifFalse:
			[#(#BZ2_bzopen 2 #BZ2_bzread 3 #BZ2_bzwrite 3 #BZ2_bzflush 1
				#BZ2_bzclose 1)]
		->:procs;
	DL import: lib procs: procs

**Bzip2 >> init
	4096 ->bufSize;
	FixedByteArray basicNew: bufSize ->buf
**Bzip2 >> open: file mode: mode
	DL call: #BZ2_bzopen with: file hostPath with: mode ->bzfp;
	self assert: bzfp <> 0
**Bzip2 >> write: len
	DL call: #BZ2_bzwrite with: bzfp with: buf with: len!
**Bzip2 >> read: len
	DL call: #BZ2_bzread with: bzfp with: buf with: len!
**Bzip2 >> close
	DL call: #BZ2_bzflush with: bzfp;
	DL call: #BZ2_bzclose with: bzfp

**Bzip2 >> compress: bz2 from: file
	self open: bz2 mode: "wb";
	file readDo:
		[:str
		[str read: buf ->:size, <> 0]
			whileTrue: [self write: size]];
	self close
**Bzip2 >> decompress: bz2 to: file
	self open: bz2 mode: "rb";
	file writeDo:
		[:str
		[self read: bufSize ->:size, <> 0]
			whileTrue: [str write: buf size: size]];
	self close

*bzip2 tool.@
	Object addSubclass: #Cmd.bzip2 instanceVars: "bzip2"
**Cmd.bzip2 >> init
	Bzip2 new ->bzip2
**Cmd.bzip2 >> main: args
	args size = 1 ->:tmp?,
		ifTrue: [In pipeTo: (TempFile create ->:file)]
		ifFalse: [args at: 1, asFile ->file];
	bzip2 compress: args first asFile from: file;
	tmp? ifTrue: [file remove]
**Cmd.bzip2 >> main.d: args
	args size = 1 ->:tmp?,
		ifTrue: [TempFile create]
		ifFalse: [args at: 1, asFile] ->:file;
	bzip2 decompress: args first asFile to: file;
	tmp? ifTrue:
		[file pipeTo: Out;
		file remove]
