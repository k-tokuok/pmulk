CodeTranslator.w class
$Id: mulk ctrw.m 1204 2024-04-06 Sat 07:05:30 kt $
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
**CodeTranslator.w >> translate: bufArg from: fromArg size: sizeArg
	self reserve: sizeArg;
	DL call: #MultiByteToWideChar
		with: fromCode with: 0
		with: bufArg address + fromArg with: sizeArg
		with: wcBuf with: wcBuf size // 2 ->:wcCount;
	DL call: #WideCharToMultiByte
		with: toCode with: 0
		with: wcBuf with: wcCount
		with: resultBuf with: resultBuf size with: #(0 0) ->:result;
	result!
