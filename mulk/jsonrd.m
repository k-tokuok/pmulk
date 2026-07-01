JsonReader class
$Id: mulk jsonrd.m 1618 2026-06-25 Thu 22:39:11 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Read JSON format data.
.hierarchy JsonReader
Convert JSON description to Mulk's natural structure.
Numerical and character expressions are not completely compatible.
.caption SEE ALSO
.summary jsonwr
**#ja
.caption 説明
JSON形式のデータを読み込む。
.hierarchy JsonReader
JSONの記述をMulkの自然な構造に変換する。
数値、文字表現に完全な互換性がある訳ではない。
.caption 関連項目
.summary jsonwr

*import.@
	Mulk import: "ctrlib"
	
*JsonReader.Lexer class.@
	AheadReader addSubclass: #JsonReader.Lexer instanceVars: "ctr u16buf"
**JsonReader.Lexer >> getHexByte
	self skipChar asNumericValue: 16, << 4 
		+ (self skipChar asNumericValue: 16) ->:result;
	result!
**JsonReader.Lexer >> addU16: codeArg
	u16buf putByte: codeArg & 0xff;
	u16buf putByte: codeArg >> 8
**JsonReader.Lexer >> decodeU16
	ctr nil? ifTrue:
		[Mulk at: #CodeTranslatorFactory in: "ctrllib",
			create: "U" + (Mulk.charset = #sjis ifTrue: ['s'] ifFalse: ['u'])
			->ctr];
	MemoryStream new ->u16buf;
	self addU16: self getHexByte << 8 | self getHexByte;
	u16buf seek: 0;
	u16buf contentBytes ->:bytes;
	ctr translate: bytes from: 0 size: bytes size ->:sz;
	self add: (ctr resultBuf makeStringFrom: 0 size: sz)
**JsonReader.Lexer >> escapeCode
	self skipChar ->:ch;
	ch = 'b' ifTrue: [self add: '\b'!];
	ch = 'f' ifTrue: [self add: '\f'!];
	ch = 'n' ifTrue: [self add: '\n'!];
	ch = 'r' ifTrue: [self add: '\r'!];
	ch = 't' ifTrue: [self add: '\t'!];
	ch = 'u' ifTrue: [self decodeU16!];
	self add: ch
**JsonReader.Lexer >> getToken
	self skipSpace;
	nextChar nil? ifTrue: [#eof!];

	nextChar = '{' | (nextChar = '}') | (nextChar = '[') | (nextChar = ']')
		| (nextChar = ',') | (nextChar = ':') ifTrue: [self skipChar!];

	nextChar = '-' | nextChar digit? ifTrue: [self skipNumber!];

	self resetToken;
	nextChar alpha? ifTrue:
		[[nextChar alpha?] whileTrue: [self getChar];
		self token ->:tk, = "true", ifTrue: [true!];
		tk = "false" ifTrue: [false!];
		tk = "null" ifTrue: [nil!];
		self error: "illegal keyword " + tk];

	nextChar = '"' ifTrue:
		[self skipChar;
		[nextChar <> '"'] whileTrue: 
			[self skipWideChar ->:ch, = '\\' 
				ifTrue: [self escapeCode]
				ifFalse: [self add: ch]];
		self skipChar;
		self token!];

	self error: "illegal char " + nextChar
**JsonReader.Lexer >> getToken: requireArg
	self getToken <> requireArg ifTrue: [self error: "require " + requireArg]
	
*JsonReader class.@
	Object addSubclass: #JsonReader instanceVars: "lexer"
**JsonReader >> value?: arg
	arg nil? or: [arg kindOf?: Boolean], or: [arg kindOf?: String],
		or: [arg kindOf?: Number]!
**JsonReader >> readMap
	Dictionary new ->:result;
	[
		lexer getToken ->:tk, = '}' ifTrue: [result!];
		self assert: (tk kindOf?: String);
		lexer getToken: ':';
		result at: tk put: self readObject;
		lexer getToken ->tk, = '}' ifTrue: [result!];
		self assert: tk = ','
	] loop
**JsonReader >> readList
	Array new ->:result;
	[
		lexer getToken ->:tk, = ']' ifTrue: [result!];
		result addLast: (self readObject: tk);
		lexer getToken ->tk, = ']' ifTrue: [result!];
		self assert: tk = ','
	] loop
**JsonReader >> readObject: firstArg
	self value?: firstArg, ifTrue: [firstArg!];
	firstArg = '{' ifTrue: [self readMap!];
	firstArg = '[' ifTrue: [self readList!];
	self error: "illegal token " + firstArg
**JsonReader >> readObject
	self readObject: lexer getToken!
	
**JsonReader >> readNative: readerArg
	JsonReader.Lexer new initReader: readerArg ->lexer;
	self readObject ->:result;
	lexer getToken: #eof;
	result!
***[man.m]
****#en
Reads from the readerArg with the Mulk.charset character encoding and returns the content.
****#ja
Mulk.charsetの文字コードのreaderArgから読み込み、内容を返す。

**JsonReader >> read: readerArg
	Mulk.charset = #sjis
		ifTrue: [self readNative: (readerArg pipe: "ctr u s")]
		ifFalse: [self readNative: readerArg]!
***[man.m]
****#en
Reads from readerArg and returns the contents.
****#ja
readerArgから読み込み、内容を返す。

