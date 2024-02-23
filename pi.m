object serialization/deserialization with partial image format
$Id: mulk pi.m 956 2022-10-22 Sat 22:34:12 kt $
#ja 部分イメージ形式によるオブジェクトのシリアライズ

*[man]
**#en
.caption description
Serialize / deserialize a specific object and the objects referenced from it.

The class definition of the object to be deserialized must be defined in the execution environment with the same structure as at the time of serialization.
Objects associated with the internal mechanism of the interpreter, such as the class definition itself and FileStream and Context / Block, cannot be serialized correctly.

By convention, the extension of a file serialized using this mechanism is mpi (mulk partial image).
**#ja
.caption 説明
特定のオブジェクトとそこから参照しているオブジェクト群をシリアライズ/デシリアライズする。

デシリアライズするオブジェクトのクラス定義は実行環境中にシリアライズ時と同一の構造で定義されていなくてはならない。
クラス定義そのもの、FileStreamやContext/Blockのようにインタプリタの内部機構と結び付いたオブジェクトは正しくシリアライズ出来ない。

慣用として、この機構を用いてシリアライズしたファイルの拡張子をmpi(mulk partial image)とする。

*PartialImageWriter class.@
	ImageWriter addSubclass: #PartialImageWriter instanceVars: "classMap"
**PartialImageWriter >> init
	super init;
	Dictionary new ->classMap
**PartialImageWriter >> putString: str
	stream put: str, putByte: 0
**PartialImageWriter >> putClassRef: class
	classMap at: class ifAbsentPut:
		[self putByte: 0;
		self putString: class asString;
		classMap size]!
**PartialImageWriter >> putObject: object
	object = true or: [object = false], or: [object nil?],
			or: [object memberOf?: Class],
		ifTrue:
			[self putByte: 2;
			self putString: object asString!];
	object memberOf?: Symbol,
		ifTrue:
			[self putByte: 3;
			self putString: object asString!];
	object memberOf?: Char,
		ifTrue:
			[self putByte: 5;
			self putByte: object code!];
	object memberOf?: WideChar,
		ifTrue:
			[self putByte: 6;
			object code ->:code;
			self assert: (code memberOf?: ShortInteger);
			self putUint: code!];
			
	object class ->:class;
	self assert: (class <> ShortInteger);
	self putClassRef: class ->:classCode;
	self putByte: 1;
	self putUint: object hash;
	self putUint: classCode;
	class variableSize? ifTrue: [self putUint: object basicSize];
	object serializeTo: self
**PartialImageWriter >> write: object to: streamArg
	streamArg ->stream;
	object memberOf?: ShortInteger,
		ifTrue:
			[self putByte: 4;
			self putSint: object]
		ifFalse: [self objectRefCode: object];
	self writeQueue;
	self putByte: 255

*read image.
**deserialize methods.
***Object >> deserializeFrom: reader
	self basicSize timesDo: [:i reader getObjectRef: self at: i]
***Object >> deserializeBytesFrom: reader
	self basicSize timesDo: [:i self basicAt: i put: (reader getByte)]
***LongInteger >> deserializeFrom: reader
	self deserializeBytesFrom: reader
***Float >> deserializeFrom: reader
	self deserializeBytesFrom: reader
***FixedByteArray >> deserializeFrom: reader
	self deserializeBytesFrom: reader
	
**PartialImageReader.RefInfo class.@
	Object addSubclass: #PartialImageReader.RefInfo instanceVars: "object pos"
***PartialImageReader.RefInfo >> init: o pos: p
	o ->object;
	p ->pos
***PartialImageReader.RefInfo >> resolve: o
	object basicAt: pos put: o
	
**PartialImageReader class.@
	Object addSubclass: #PartialImageReader
		instanceVars: "stream classTable objectTable readObjectNo"
***PartialImageReader >> init
	Array new ->classTable;
	Array new ->objectTable;
	0 ->readObjectNo
***PartialImageReader >> getByte
	stream getByte!
***PartialImageReader >> getUint
	0 ->:result;
	0 ->:off;
	[self getByte ->:b, & 0x80 <> 0] whileTrue:
		[result | (b & 0x7f << off) ->result;
		off + 7 ->off];
	result | (b << off)!
***PartialImageReader >> getString
	StringWriter new ->:w;
	[self getByte ->:b, <> 0] whileTrue: [w putByte: b];
	w asString!
***PartialImageReader >> readClassEntry
	classTable addLast: (Mulk at: self getString asSymbol)
***PartialImageReader >> uintToSint: u
	u >> 1 ->:i;
	i >= 0x40000000 ifTrue: [i - 0x80000000 ->i];
	i!
***PartialImageReader >> getObjectRef: o at: pos
	self getUint ->:u;
	u & 1 = 1 ifTrue: [o basicAt: pos put: (self uintToSint: u)!];
		
	u >> 1 ->:code;
	code < readObjectNo
		ifTrue: [o basicAt: pos put: (objectTable at: code)!];

	objectTable size <= code, ifTrue: [objectTable size: code + 1];
	objectTable at: code ->:ris, nil? ifTrue: 
		[objectTable at: code put: (Array new ->ris)];

	ris addLast: (PartialImageReader.RefInfo new init: o pos: pos)
***PartialImageReader >> addReadObject: object
	objectTable size <= readObjectNo
		ifTrue: [objectTable size: readObjectNo + 1];
	objectTable at: readObjectNo ->:ris, notNil? ifTrue:
		[ris do: [:ri ri resolve: object]];
	objectTable at: readObjectNo put: object;
	readObjectNo + 1 ->readObjectNo
***PartialImageReader >> readObject
	self getUint ->:hash;
	classTable at: self getUint ->:class;
	class variableSize? ifTrue: [self getUint] ifFalse: [0] ->:ext;
	class basicNew: ext ->:object;
	object hash: hash;
	object deserializeFrom: self;
	self addReadObject: object
***PartialImageReader >> readMulkEntry
	self addReadObject: (Mulk at: self getString asSymbol)
***PartialImageReader >> readSymbolEntry
	self addReadObject: self getString asSymbol
***PartialImageReader >> readShortInteger
	self addReadObject: (self uintToSint: self getUint)
***PartialImageReader >> readChar
	self addReadObject: self getByte asChar
***PartialImageReader >> readWideChar
	self addReadObject: self getUint asWideChar
***PartialImageReader >> readFrom: streamArg
	streamArg ->stream;
	[self getByte ->:b, <> 255] whileTrue:
		[self perform: 
			(#(#readClassEntry #readObject #readMulkEntry #readSymbolEntry
				#readShortInteger #readChar #readWideChar)
			at: b)];
	objectTable at: 0!

*quick access.
**File >> writeObject: object
	self writeDo: [:str PartialImageWriter new write: object to: str]
***[man.m]
****#en
Write an object to a file.
****#ja
ファイルへobjectを書き出す。

**File >> readObject
	self readDo: [:str PartialImageReader new readFrom: str]!
***[man.m]
****#en
Read an object from a file.
****#ja
ファイルからオブジェクトを読み込む。
