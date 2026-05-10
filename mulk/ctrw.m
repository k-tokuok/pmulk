CodeTranslator.w class
$Id: mulk ctrw.m 1591 2026-04-29 Wed 21:32:35 kt $
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
	ch = 'U' ifTrue: [65536!]; --UTF16 little endian
	self error: "illegal char code " + ch
**CodeTranslator.w >> init: fromTo
	self codeNumber: fromTo first ->fromCode;
	self codeNumber: (fromTo at: 1) ->toCode
**CodeTranslator.w >> wcConvFrom: fromWc to: toWc count: count
	0 ->:pos;
	count * 2 ->:sz;
	[wcBuf indexOf: fromWc size: 2 from: pos until: sz ->pos, 
			notNil?] whileTrue:
		[pos % 2 = 1 
			ifTrue: [pos + 1]
			ifFalse:
				[wcBuf at: pos put: toWc first, at: pos + 1 put: (toWc at: 1);
				pos + 2] ->pos]
	
**CodeTranslator.w >> translate: bufArg from: fromArg size: sizeArg
	self reserve: sizeArg;
	fromCode = 65536 ifTrue:
		[DL call: #WideCharToMultiByte
			with: toCode with: 0
			with: bufArg address + fromArg with: sizeArg // 2
			with: resultBuf with: resultBuf size with: #(0 0) ->:result!];
	DL call: #MultiByteToWideChar
		with: fromCode with: 0
		with: bufArg address + fromArg with: sizeArg
		with: wcBuf with: wcBuf size // 2 ->:wcCount;

	toCode = 932 ifTrue:
		[self wcConvFrom: #[0x1c 0x30] to: #[0x5e 0xff] count: wcCount;
		self wcConvFrom: #[0x12 0x22] to: #[0x0d 0xff] count: wcCount];
	
	DL call: #WideCharToMultiByte
		with: toCode with: 0
		with: wcBuf with: wcCount
		with: resultBuf with: resultBuf size with: #(0 0) ->result;
	result!
