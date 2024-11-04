JsonReader class
$Id: mulk jsonrd.m 1292 2024-10-13 Sun 22:14:41 kt $
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

*JsonReader class.@
	Mulk import: "ctrlib";
	AheadReader addSubclass: #JsonReader instanceVars: "ctr u16buf"

**JsonReader >> getHexByte
	self skipChar asNumericValue: 16, << 4 
		+ (self skipChar asNumericValue: 16) ->:result;
	result!
**JsonReader >> addU16: codeArg
	u16buf putByte: codeArg & 0xff;
	u16buf putByte: codeArg >> 8
**JsonReader >> escapeCode: ch
	ch = 'b' ifTrue: ['\b' code!];
	ch = 'f' ifTrue: ['\f' code!];
	ch = 'n' ifTrue: ['\n' code!];
	ch = 'r' ifTrue: ['\r' code!];
	ch = 't' ifTrue: ['\t' code!];
	ch code!
**JsonReader >> getU16Char
	self skipChar ->:ch, = '\\' ifTrue:
		[self skipChar ->ch, = 'u' 
			ifTrue: [self addU16: self getHexByte << 8 | self getHexByte!];
		self addU16: (self escapeCode: ch)!];
	self assert: ch ascii?;
	self addU16: ch code
			
**JsonReader >> getRestStringWithEscapeU
	-- after "...\u"
	ctr nil? ifTrue:
		[Mulk at: #CodeTranslatorFactory in: "ctrlib",
			create: "U" + (Mulk.charset = #sjis ifTrue: ['s'] ifFalse: ['u'])
			->ctr];
	MemoryStream new ->u16buf;
	self addU16: self getHexByte << 8 | self getHexByte;
	[nextChar <> '"'] whileTrue: [self getU16Char];
	u16buf seek: 0;
	u16buf contentBytes ->:bytes;
	ctr translate: bytes from: 0 size: bytes size ->:sz;
	self add: (ctr resultBuf makeStringFrom: 0 size: sz)
**JsonReader >> getToken
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
			[self skipChar ->:ch, = '\\' 
				ifTrue:
					[self skipChar ->ch, = 'u'
						ifTrue: [self getRestStringWithEscapeU]
						ifFalse: [self add: (self escapeCode: ch) asChar]]
				ifFalse: [self add: ch]];
		self skipChar;
		self token!];

	self error: "illegal char " + nextChar
**JsonReader >> getToken: requireArg
	self getToken <> requireArg ifTrue: [self error: "require " + requireArg]

**JsonReader >> value?: arg
	arg nil? or: [arg kindOf?: Boolean], or: [arg kindOf?: String],
		or: [arg kindOf?: Number]!
**JsonReader >> readMap
	Dictionary new ->:result;
	[
		self getToken ->:tk, = '}' ifTrue: [result!];
		self assert: (tk kindOf?: String);
		self getToken: ':';
		result at: tk put: self readObject;
		self getToken ->tk, = '}' ifTrue: [result!];
		self assert: tk = ','
	] loop
**JsonReader >> readList
	Array new ->:result;
	[
		self getToken ->:tk, = ']' ifTrue: [result!];
		result addLast: (self readObject: tk);
		self getToken ->tk, = ']' ifTrue: [result!];
		self assert: tk = ','
	] loop
**JsonReader >> readObject: first
	self value?: first, ifTrue: [first!];
	first = '{' ifTrue: [self readMap!];
	first = '[' ifTrue: [self readList!];
	self error: "illegal token " + first
**JsonReader >> readObject
	self readObject: self getToken!

**JsonReader >> read: readerArg
	super initReader: readerArg;
	self readObject ->:result;
	self getToken: #eof;
	result!
***[man.m]
****#en
Read from readerArg and return the contents.
****#ja
readerArgから読み込み、内容を返す。

