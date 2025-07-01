newline crlf
$Id: mulk crlf.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
Handle end-of-line characters in text files as CR/LF.

To be load when building the boot image.
**#ja
テキストファイルの行末文字をCR/LFで扱うようにする。

起動イメージを構築する際に読み込むこと。

*NewlineCrlfStream feature.@
	Feature addSubclass: #NewlineCrlfStream
**NewlineCrlfStream >> getChar
	self getByte ->:byte, = '\r' code
		ifTrue: [self getChar]
		ifFalse: [byte asChar]!
**NewlineCrlfStream >> putCharCode: codeArg
	codeArg = '\n' code ifTrue: [self putByte: '\r' code];
	self putByte: codeArg
**NewlineCrlfStream >> putString: stringArg
	stringArg bytesDo: [:code self putCharCode: code]

*@
	Mulk at: #Mulk.newline put: #crlf;
	FileStream features: #(NewlineCrlfStream)
