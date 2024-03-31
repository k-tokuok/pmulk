dynamic link library interface
$Id: mulk dl.m 1179 2024-03-17 Sun 21:14:15 kt $
#ja 動的リンクライブラリのインターフェイス

*[man]
**#en
.caption DESCRIPTION
Provides a function to link and execute the dynamic link library of the host system.

If the image is saved with the library linked, the library will be re-linked when restarting.
**#ja
.caption 説明
ホストシステムの動的リンクライブラリをリンクし実行する機能を提供する。

ライブラリをリンクした状態でイメージを保存すると、再起動時に改めて再リンクを行う。

*import.@
	Mulk at: #DL.ptrByteSize put: (OS propertyAt: 4);
	Mulk at: #DL.littleEndian? put: (OS propertyAt: 5);
	Mulk import: "fbdata"
	
*overwrite.
**[man.s]
***#en
Method added to existing class.
***#ja
既存クラスに追加されるメソッド。

**String >> asCString
	FixedByteArray basicNew: self size + 1 ->:result;
	result basicAt: 0 copyFrom: self at: 0 size: self size;
	result!
***[man.m]
****#en
Returns a FixedByteArray representing the receiver's C-format string (byte array with NUL bytes at the end).
****#ja
レシーバーのC形式文字列(末尾にNULバイトを置くバイト配列)表現のFixedByteArrayを返す。

**FixedByteArray >> address
	$dl_address
***[man.m]
****#en
Returns the start address of the receiver.
****#ja
レシーバーの先頭アドレスを返す。

**FixedByteArray >> asStringFromCString
	self makeStringFrom: 0 size: (self indexOf: 0)!
***[man.m]
****#en
Treat the receiver as a C-style string and return the corresponding String representation.
****#ja
レシーバーをC形式文字列と見做し、対応するString表現を返す。

**Array >> elements
	elements!
	
*DL.Buffer class.@
	Object addSubclass: #DL.Buffer instanceVars: "buffer"
**[man.c]
***#en
Base class for providing a buffer area for exchanging data with C functions.

The instance variable buffer becomes the actual byte array.
***#ja
C関数とのデータをやりとりする為のバッファ領域を提供する為の基底クラス。

インスタンス変数のbufferが実際のバイト配列となる。

**DL.Buffer >> address
	buffer address!
***[man.m]
****#en
Returns the address of the buffer.
****#ja
バッファのアドレスを返す。

**DL.Buffer >> init: size
	FixedByteArray basicNew: size ->buffer
***[man.m]
****#en
Allocate buffer for size bytes.
****#ja
バッファをsizeバイト分確保する。

**DL.Buffer >> buffer
	buffer!

*DL.IntPtrBuffer class.@
	DL.Buffer addSubclass: #DL.IntPtrBuffer
**[man.c]
***#en
Provides an intptr_t type area.
***#ja
intptr_t型の領域を提供する。

**DL.IntPtrBuffer >> init
	self init: DL.ptrByteSize
**DL.IntPtrBuffer >> value: i
	buffer nativePtrAt: 0 put: i
***[man.m]
****#en
Let the value of the area be i.
****#ja
領域の値をiとする。

**DL.IntPtrBuffer >> value
	buffer nativePtrAt: 0!
***[man.m]
****#en
Returns the value of the area.
****#ja
領域の値を返す。

*DL.NativeConverter class.@
	Object addSubclass: #DL.NativeConverter instanceVars: "chunk"
**DL.NativeConverter >> addChunk: obj
	chunk nil? ifTrue: [Array new ->chunk];
	chunk addLast: obj
**DL.NativeConverter >> convert: obj
	obj kindOf?: Integer, ifTrue: [obj asUintptr!];
	obj memberOf?: String, ifTrue: [obj asCString ->obj];
	obj memberOf?: FixedByteArray, or: [obj kindOf?: DL.Buffer], ifTrue:
		[self addChunk: obj;
		obj address!];
	self assertFailed
	
*DL.Struct class.@
	DL.Buffer addSubclass: #DL.Struct instanceVars: "nc"
**[man.c]
***#en
Provide a function to secure a structure area and access it.
***#ja
構造体領域を確保し、アクセスする機能を提供する。

**DL.Struct >> init
	DL.NativeConverter new ->nc
**DL.Struct >> at: pos put: obj
	buffer nativePtrAt: pos put: (nc convert: obj)
***[man.m]
****#en
Write a C representation of the following object, assuming a member of type intptr_t at byte offset pos of the structure.

The following elements can be used:
	Integer -- Write the value as is.
	String -- Convert to a string in C format and write its address.
	FixedByteArray, DL.Buffer -- Write its address.
****#ja
構造体のバイトオフセットposの位置にintptr_t型のメンバーを仮定し、以下のオブジェクトのC表現を書き込む。

以下の要素が使用出来る。

	Integer -- 値をそのまま書き込む。
	String -- C形式の文字列に変換し、そのアドレスを書き込む。
	FixedByteArray, DL.Buffer -- そのアドレスを書き込む。
	
*DL.CallArgs class.@
	Object addSubclass: #DL.CallArgs instanceVars: "nc array"
**DL.CallArgs >> init
	DL.NativeConverter new ->nc;
	Array new ->array
**DL.CallArgs >> add1: object
	object memberOf?: Float, ifFalse: [nc convert: object ->object];
	array addLast: object
**DL.CallArgs >> add: object
	object memberOf?: Array, or: [object memberOf?: FixedArray],
		ifTrue: [object do: [:o self add1: o]]
		ifFalse: [self add1: object]
**DL.CallArgs >> farray
	array elements!

*DL.Proc class.@
	Object addSubclass: #DL.Proc instanceVars: "symbol type addr"
**DL.Proc >> symbolFrom: handle name: name
	$dl_sym
**DL.Proc >> call: addrArg type: typeArg args: fargs
	$dl_call
**DL.Proc >> init: symbolArg type: typeArg
	symbolArg ->symbol;
	typeArg ->type
**DL.Proc >> attachFrom: handle
	self symbolFrom: handle name: symbol asString ->addr
**DL.Proc >> call: args
	self call: addr type: type args: args farray!
**DL.Proc >> call
	self call: addr type: type args: nil!
	
*DL.Library class.@
	Object addSubclass: #DL.Library instanceVars: "name handle procs"
**DL.Library >> open: libName
	$dl_open
**DL.Library >> init: nameArg
	nameArg ->name;
	Array new ->procs
**DL.Library >> open
	self open: name ->handle
**DL.Library >> proc: pSymbol type: typeArg
	DL.Proc new init: pSymbol type: typeArg ->:proc;
	proc attachFrom: handle;
	procs addLast: proc;
	proc!
**DL.Library >> reload
	self open;
	procs do: [:p p attachFrom: handle]

*DL.class class.@
	Object addSubclass: #DL.class instanceVars: "libraryTable procTable"
**[man.c]
***#en
Class for accessor object to dynamic link library.

Don't construct instances with new, use global object DL.
***#ja
動的リンクライブラリへのアクセサオブジェクトのクラス。

インスタンスをnewで構築せず、グローバルオブジェクトDLを使用すること。

**DL.class >> init
	Dictionary new ->libraryTable;
	Dictionary new ->procTable
**DL.class >> onBoot
	libraryTable do: [:lib lib reload]

**memory access.
***DL.class >> byteAt: addr
	$dl_load_byte
****[man.m]
*****#en
Get the byte value of memory addr.
*****#ja
メモリaddrのbyte値を取得する。

***DL.class >> byteAt: addr put: byte
	$dl_store_byte
****[man.m]
*****#en
Write byte to memory addr.
*****#ja
メモリaddrにbyteを書き込む。

***DL.class >> loadString: addr
	StringWriter new ->:wr;
	[self byteAt: addr ->:byte, <> 0] whileTrue:
		[wr putByte: byte;
		addr + 1 ->addr];
	wr asString!
****[man.m]
*****#en
Get C language string starting from addr and return String expression.
*****#ja
addrから始まるC言語文字列を取得し、String表現を返す。

**import symbol.
***DL.class >> import: libName procs: array
	libraryTable at: libName ifAbsentPut:
		[DL.Library new init: libName, open] ->:lib;
	0 until: array size by: 2, do:
		[:i
		array at: i ->:sym;
		array at: i + 1 ->:type;
		procTable includesKey?: sym, ifFalse:
			[procTable at: sym put: (lib proc: sym type: type)]]
****[man.m]
*****#en
Loads the dynamic link library libName and makes the C functions specified by array available.

In the array, the symbol of the function name and the function type code are alternately specified.

The function type code is as follows:
	0-14 -- Specify intptr_t type arguments for the number of code numbers and return the intptr_t type return value.
	20 -- double f(double)
	21 -- intptr_t f(intptr_t, intptr_t, double)
	22 -- double f(intptr_t, intptr_t)
	100-114 -- (Windows only) Call with __stdcall method. The signature is the same as the code number minus 100.

The intptr_t type corresponds to pointers and integer derived types.
*****#ja
動的リンクライブラリlibNameを読み込み、arrayで指定されたC関数群を使用可能とする。

arrayでは関数名のシンボルと関数型コードを交互に指定する。

関数型コードは以下の通り。
	0 - 14 -- コード番号数分のintptr_t型引数を指定し、intptr_t型の返り値を返す。
	20 -- double f(double)
	21 -- intptr_t f(intptr_t,intptr_t,double)
	22 -- double f(intptr_t,intptr_t)
	100 - 114 -- (Windowsのみ)__stdcall方式で呼び出す。シグネチャーはコード番号から100を引いたものと同様。

intptr_t型はポインタ及び整数派生型に対応する。

**calling.
***DL.class >> retval: result
	result kindOf?: Integer, ifTrue: [result asIntptr] ifFalse: [result]!
***DL.class >> call: p
	self retval: (procTable at: p, call)!
****[man.m]
*****#en
Call the function of Symbol p.
*****#ja
Symbol pの関数を呼び出す。

***DL.class >> call: p args: args
	self retval: (procTable at: p, call: args)!

***DL.class >> call: p with: a0
	self call: p args: (DL.CallArgs new add: a0)!
****[man.m]
*****#en
Call the function of Symbol p with the following arguments:

The following objects can be specified as arguments.
	Integer, Float -- Takes a value as an argument.
	String -- Convert to a C-style string and take its address as an argument.
	FixedByteArray, DL.Buffer -- Takes its address as an argument.
	FixedArray, Array -- Pass the contents of the array as arguments in order.

Argument types must match the function type code.
*****#ja
Symbol pの関数をwith:以下の引数と共に呼び出す。

引数としては以下のオブジェクトが指定出来る。
	Integer, Float -- 値をそのまま引数とする。
	String -- C形式の文字列に変換し、そのアドレスを引数とする。
	FixedByteArray, DL.Buffer -- そのアドレスを引数とする。
	FixedArray, Array -- 配列の内容を順に引数として渡す。

引数の型は関数型コードと一致していなくてはならない。

***DL.class >> call: p with: a0 with: a1
	DL.CallArgs new
		add: a0, add: a1 ->:args;
	self call: p args: args!
****[man.m]
*****#en
Same as above.
*****#ja
同上。

***DL.class >> call: p with: a0 with: a1 with: a2
	DL.CallArgs new
		add: a0, add: a1, add: a2 ->:args;
	self call: p args: args!
****[man.m]
*****#en
Same as above.
*****#ja
同上。

***DL.class >> call: p with: a0 with: a1 with: a2 with: a3
	DL.CallArgs new
		add: a0, add: a1, add: a2, add: a3 ->:args;
	self call: p args: args!
****[man.m]
*****#en
Same as above.
*****#ja
同上。

***DL.class >> call: p with: a0 with: a1 with: a2 with: a3 with: a4
	DL.CallArgs new
		add: a0, add: a1, add: a2, add: a3, add: a4 ->:args;
	self call: p args: args!
****[man.m]
*****#en
Same as above.
*****#ja
同上。

***DL.class >> call: p with: a0 with: a1 with: a2 with: a3 with: a4 with: a5
	DL.CallArgs new
		add: a0, add: a1, add: a2, add: a3, add: a4, add: a5 ->:args;
	self call: p args: args!
****[man.m]
*****#en
Same as above.
*****#ja
同上。

***DL.class >> call: p with: a0 with: a1 with: a2 with: a3 with: a4 with: a5
		with: a6
	DL.CallArgs new
		add: a0, add: a1, add: a2, add: a3, add: a4, add: a5, add: a6 ->:args;
	self call: p args: args!
****[man.m]
*****#en
Same as above.
*****#ja
同上。

*regist.@
	--note: do at last, because DL.class >> init must be declared.
	DL.class new ->:dl;
	Mulk at: #DL put: dl;
	Mulk.bootHook addLast: dl
