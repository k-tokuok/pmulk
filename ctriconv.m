CodeTranslator.iconv class
$Id: mulk ctriconv.m 1289 2024-10-06 Sun 20:37:22 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
iconv shared library implementation of CodeTranslator class.
.caption SEE ALSO
.summary ctrlib
**#ja
.caption 説明
CodeTranslator classのiconv共有ライブラリ実装。
.caption 関連項目
.summary ctrlib

*CodeTranslator.iconv class.@
	Mulk import: "dl";
	CodeTranslator addSubclass: #CodeTranslator.iconv instanceVars:
		"open conv close ic bufAddr bufSizeAddr resultAddr resultSizeAddr"
**CodeTranslator.iconv >> init
	super init;
	DL.IntPtrBuffer new ->bufAddr;
	DL.IntPtrBuffer new ->bufSizeAddr;
	DL.IntPtrBuffer new ->resultAddr;
	DL.IntPtrBuffer new ->resultSizeAddr;
	Mulk.hostOS ->:os, = #cygwin | (os = #windows)
		ifTrue: [#(#libiconv_open 2 #libiconv 5 #libiconv_close 1)]
		ifFalse: [#(#iconv_open 2 #iconv 5 #iconv_close 1)] ->:procs;
	procs first ->open;
	procs at: 2 ->conv;
	procs at: 4 ->close;
	"" ->:libName; -- linux
	os = #cygwin ifTrue: ["cygiconv-2.dll" ->libName];
	os = #macosx ifTrue: ["libiconv.dylib" ->libName];
	os = #freebsd ifTrue: ["libiconv.so" ->libName];
	os = #windows ifTrue: ["libiconv-2.dll" ->libName];
	DL import: libName procs: procs
**CodeTranslator.iconv >> codeString: ch
	ch = 'u' ifTrue: ["UTF-8"!];
	ch = 's' ifTrue: ["CP932"!];
	ch = 'e' ifTrue: ["EUC-JP"!];
	ch = 'U' ifTrue: ["UTF-16LE"!];
	self error: "illegal code char " + ch
**CodeTranslator.iconv >> init: fromTo
	DL call: open with: (self codeString: (fromTo at: 1))
		with: (self codeString: fromTo first) ->ic
**CodeTranslator.iconv >> translate: bufArg from: fromArg size: sizeArg
	self reserve: sizeArg;
	bufAddr value: bufArg address + fromArg;
	bufSizeAddr value: sizeArg;
	resultAddr value: resultBuf address;
	resultSizeAddr value: resultBuf size;
	DL call: conv with: ic
		with: bufAddr with: bufSizeAddr with: resultAddr with: resultSizeAddr,
			= -1 ifTrue:
		[self error: "iconv failed."];
	resultBuf size - resultSizeAddr value!
**CodeTranslator.iconv >> finish
	DL call: close with: ic
