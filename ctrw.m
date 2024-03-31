CodeTranslator.w class
$Id: mulk ctrw.m 1188 2024-03-26 Tue 22:43:40 kt $
#ja
*[man]
**#en
.caption DESCRIPTION
Windows implementation of CodeTranslator class.
.caption SEE ALSO
.summary ctrlib
**#ja
.caption 説明
CodeTranslator classのWindows実装。
.caption 関連項目
.summary ctrlib

*import.@
	Mulk import: "dl"
**import dll.@
	DL import: "kernel32.dll"
		procs: #(#MultiByteToWideChar 106 #WideCharToMultiByte 108)
		
*CodeTranslator.w class.@
	CodeTranslator addSubclass: #CodeTranslator.w
		instanceVars: "wcBuf fromCode toCode"
**CodeTranslator.w >> alloc
	super alloc;
	FixedByteArray basicNew: limit * 4 ->wcBuf
**CodeTranslator.w >> codeNumber: ch
	ch = 's' ifTrue: [932!]; --Windows-31J
	ch = 'e' ifTrue: [20932!]; --EUC-JP
	ch = 'u' ifTrue: [65001!]; --CP_UTF8
	self error: "illegal char code " + ch
**CodeTranslator.w >> init: fromTo
	self codeNumber: fromTo first ->fromCode;
	self codeNumber: (fromTo at: 1) ->toCode
**CodeTranslator.w >> replace: buf size: size source: src target: tgt
	0 ->:i;
	src size ->:srcsz;
	size - srcsz + 1->:en;
	[buf indexOf: src size: srcsz from: i until: en ->i, notNil?] whileTrue:
		[buf basicAt: i copyFrom: tgt at: 0 size: srcsz;
		i + srcsz ->i]
**CodeTranslator.w >> translate: bufArg from: fromArg size: sizeArg
	self reserve: sizeArg;
	fromCode = 65001 ifTrue:
		[bufArg copyFrom: fromArg until: fromArg + sizeArg ->bufArg;
		0 ->fromArg;
		self replace: bufArg size: sizeArg 
			source: "\xe3\x80\x9c" target: "\xef\xbd\x9e"];
	DL call: #MultiByteToWideChar
		with: fromCode with: 0
		with: bufArg address + fromArg with: sizeArg
		with: wcBuf with: wcBuf size // 2 ->:wcCount;
	DL call: #WideCharToMultiByte
		with: toCode with: 0
		with: wcBuf with: wcCount
		with: resultBuf with: resultBuf size with: #(0 0) ->:result;
	toCode = 65001 ifTrue:
		[self replace: resultBuf size: result
			source:"\xef\xbd\x9e" target: "\xe3\x80\x9c"];
	result!
