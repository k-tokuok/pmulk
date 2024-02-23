JsonReader class
$Id: mulk jsonrd.m 1103 2023-09-09 Sat 22:02:43 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Read JSON format data.
.hierarchy JsonReader
Convert JSON description to Mulk's natural structure.
Character code conversion is not performed.
Numerical and character expressions are not completely compatible.
.caption SEE ALSO
.summary jsonwr
**#ja
.caption 説明
JSON形式のデータを読み込む。
.hierarchy JsonReader
JSONの記述をMulkの自然な構造に変換する。
文字コードの変換は行わない。
数値、文字表現に完全な互換性がある訳ではない。
.caption 関連項目
.summary jsonwr

*JsonReader class.@
	AheadReader addSubclass: #JsonReader

**JsonReader >> init: readerArg
	super initReader: readerArg
***[man.m]
****#en
Initialize the input source with Reader readerArg.
****#ja
入力元をReader readerArgで初期化する。

**JsonReader >> getEscapeChar
	self skipChar;
	self skipChar ->:ch;
	ch = 'b' ifTrue: [self add: '\b'!];
	ch = 'f' ifTrue: [self add: '\f'!];
	ch = 'n' ifTrue: [self add: '\n'!];
	ch = 'r' ifTrue: [self add: '\r'!];
	ch = 't' ifTrue: [self add: '\t'!];
	ch = 'u' ifTrue: [self error: "\\u unsupported"];
	self add: ch
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
			[nextChar = '\\' 
				ifTrue: [self getEscapeChar]
				ifFalse: [self getChar]];
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

**JsonReader >> read
	self readObject ->:result;
	self getToken: #eof;
	result!
***[man.m]
****#en
Returns the read contents.
****#ja
読み込んだ内容を返す。
