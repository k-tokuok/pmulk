Android specific functions (Android.class class)
$Id: mulk android.m 1599 2026-05-14 Thu 21:00:31 kt $
#ja Android固有機能 (Android.class class)

*[man]
**#en 
.caption DESCRIPTION
Accessor object class for Android specific functions.
.hierarchy Android.class
Don't construct instances with new, use the global object Android.
When the image is saved, the setting information is also saved.
**#ja
.caption 説明
Android固有機能へのアクセサオブジェクトのクラス。
.hierarchy Android.class
インスタンスをnewで構築せず、グローバルオブジェクトAndroidを使用すること。
イメージを保存すると設定情報も一緒に保存される。

*import.@
	Mulk import: #("fbdatal" "pfs")
	
*Android.Method class.@
	Object addSubclass: #Android.Method instanceVars: "symbol id signature"
**Android.Method >> getMethodId: string signature: signatureArg
	$android_getMethodId
**Android.Method >> setId
	self getMethodId: symbol asString signature: signature ->id
**Android.Method >> init: symbolArg signature: signatureArg
	symbolArg ->symbol;
	signatureArg ->signature;
	self setId
**Android.Method >> callMethod: idArg signature: signatureArg args: argsArg
	$android_callMethod
**Android.Method >> call: argsArg
	self callMethod: id signature: signature args: argsArg!
	
*Android.class class.@
	Object addSubclass: #Android.class instanceVars: "methods args pos"
		+ " safUri safReadMountPoint"
**Android.class >> init
	Dictionary new ->methods
**Android.class >> onBoot
	methods do: [:m m setId]
**Android.class >> method: symbolArg signature: signatureArg
	methods includesKey?: symbolArg, ifTrue: [self!];
	methods at: symbolArg put:
		(Android.Method new init: symbolArg signature: signatureArg)
***[man.m]
****#en
Import the method symbolArg of the com.github.k_tokuok.mulk.Main class.

signatureArg indicates the return value of the method and the argument type as a string.
The first character is the return type, and the rest is the argument type.
The correspondence between characters and types is as follows

	V -- void, can only be return value
	I -- int/ShortInteger
	J -- long/LongInteger
	D -- double/Float
	B -- byte []/FixedByteArray
	S -- byte []/String or FixedByteArray
	A -- int []/FixedArray
B and S type return values and arguments are expressed in byte [] in UTF-8 format on the Java side.
For B type arguments, the contents of byte [] on the Java side are written back to the FixedByteArray after the method call.

****#ja
com.github.k_tokuok.mulk.MainクラスのメソッドsymbolArgをインポートする。

signatureArgはメソッドの返り値、引数の型を文字列で示す。
先頭文字が返り値の型、残りが引数の型を意味する。
文字と型の対応関係は以下の通り
	V -- void 返り値のみ使用可能
	I -- int/ShortInteger
	J -- long/LongInteger
	D -- double/Float
	B -- byte[]/FixedByteArray
	S -- byte[]/StringもしくはFixedByteArray
	A -- int[]/FixedArray
B/S型の返り値、引数はJava側ではUTF-8形式のbyte[]で表現する。
B型の引数は、メソッド呼び出し後にJava側のbyte[]の内容がFixedByteArrayに書き戻される。

**Android.class >> make: size
	FixedArray basicNew: size ->args;
	0 ->pos
**Android.class >> push: obj
	obj kindOf?: Integer, ifTrue: [obj asUint64 ->obj];
	args at: pos put: obj;
	pos + 1 ->pos
**Android.class >> callIt: symbol
	methods at: symbol, call: args ->:result;
	nil ->args;
	result!

**Android.class >> call: symbolArg
	self make: 0, callIt: symbolArg!
***[man.m]
****#en
Calls the method of symbolArg.
****#ja
symbolArgのメソッドを呼び出す。

**Android.class >> call: symbolArg with: a0
	self make: 1, push: a0, callIt: symbolArg!
***[man.m]
****#en
Call the method of symbolArg with the following arguments.
****#ja
symbolArgのメソッドをwith以下の引数と共に呼び出す。

**Android.class >> call: symbolArg with: a0 with: a1
	self make: 2, push: a0, push: a1, callIt: symbolArg!
***[man.m]
****#en
Same as above.
****#ja
同上。

**Android.class >> call: symbolArg with: a0 with: a1 with: a2 
	self make: 3, push: a0, push: a1, push: a2, callIt: symbolArg!
***[man.m]
****#en
Same as above.
****#ja
同上。

**Android.class >> call: symbolArg with: a0 with: a1 with: a2 with: a3
	self make: 4, push: a0, push: a1, push: a2, push: a3, callIt: symbolArg!
***[man.m]
****#en
Same as above.
****#ja
同上。

**Android.class >> call: symbolArg with: a0 with: a1 with: a2 with: a3 with: a4
	self make: 5, push: a0, push: a1, push: a2, push: a3, push: a4,
		callIt: symbolArg!
***[man.m]
****#en
Same as above.
****#ja
同上。

**Android.class >> call: symbolArg with: a0 with: a1 with: a2 with: a3 with: a4
		with: a5
	self make: 6, push: a0, push: a1, push: a2, push: a3, push: a4, push: a5,
		callIt: symbolArg!
***[man.m]
****#en
Same as above.
****#ja
同上。

**Android.class >> filesDir
	self method: #getFilesDir signature: "S";
	self call: #getFilesDir, asFile!
***[man.m]
****#en
Returns a File object from application-specific storage (Context#getFilesDir).
****#ja
アプリケーション固有ストレージ(Context#getFilesDir)のFileオブジェクトを返す。

**Android.class >> imageFile: fileArg
	self method: #setImageFile signature: "VS";
	self call: #setImageFile with: fileArg path
***[man.m]
****#en
Set imageFile at the next startup to fileArg.
****#ja
次回起動時のimageFileをfileArgに設定する。

**saf.
***Android.File class.@
	PseudoFile addSubclass: #Android.File
***Android.class >> safOpenDocumentTree
	self call: #safOpenDocumentTree ->safUri
***Android.class >> safRoot
	"saf"!
***Android.class >> safSetup
	self method: #safOpenDocumentTree signature: "S";
	self method: #safStat signature: "BSS";
	self method: #safReaddir signature: "SSS";
	self method: #safMkdir signature: "ISSS";
	self method: #safRemove signature: "ISS";
	self method: #safReadAll signature: "ISSB";
	self method: #safWriteAll signature: "ISSSSI";
	self safOpenDocumentTree;
	File.mount at: self safRoot put: Android.File
****[man.m]
*****#en
Initialization of Storage Access Framework.

Execute OpenDocumentTree action and assign the selected documentTree and below to the /saf directory.
Under the /saf directory, docuemntTree can be handled as a directory and document as a file.
*****#ja
Storage Access Frameworkの初期化。

OpenDocumentTree actionを実行し選択したdocumentTree以下を/safディレクトリに割り当てる。
/safディレクトリの下位ではdocuemntTreeをディレクトリ、documentをファイルとして扱う事が出来る。

***Android.class >> safReadMountPoint: mountPointArg
	mountPointArg ->safReadMountPoint
****[man.m]
*****#en
Specify the mount point for reading.

If there is a readable mount point for the directory specified in safSetup, specify it.
If specified, the mount point is accessed directly when the file is read.
*****#ja
読み込み用マウントポイントの指定。

safSetupで指定したdirectoryの読み込み可能なマウントポイントがあれば指定する。
指定するとファイルの読み込みの際、マウントポイントに直接アクセスする。

***Android.class >> safPath: file
	file parent root?
		ifTrue: [""]
		ifFalse: [file path copyFrom: self safRoot size + 2]!
***Android.class >> safReadPath: file
	safReadMountPoint nil? ifTrue: [nil!];
	safReadMountPoint + (file path copyFrom: self safRoot size + 1)!
***Android.class >> safStat: file
	self call: #safStat with: safUri with: (self safPath: file)!
***Android.class >> safReaddir: file
	self call: #safReaddir with: safUri with: (self safPath: file)!
***Android.class >> safRemove: file
	self call: #safRemove with: safUri with: (self safPath: file), = 0
		ifTrue: [self error: "safRemove failed."]
***Android.class >> safMkdir: file
	self call: #safMkdir with: safUri with: (self safPath: file parent)
		with: file name, = 0
		ifTrue: [self error: "safMkdir failed."]
***Android.class >> safReadAll: file buf: buf
	self call: #safReadAll with: safUri with: (self safPath: file) with: buf,
		= 0 ifTrue: [self error: "safReadAll failed."]
***Android.class >> safWriteAll: file buf: buf size: size
	self call: #safWriteAll with: safUri with: (self safPath: file parent)
		with: file name with: buf with: size, = 0
		ifTrue: [self error: "safWriteAll failed."]
		
**regist.@
	Android.class new ->:android;
	Mulk at: #Android put: android;
	Mulk.bootHook addLast: android

*Android.Stream class.@
	PseudoFileStream addSubclass: #Android.Stream
**Android.Stream >> init: fileArg mode: modeArg
	fileArg ->file;
	modeArg = 1 ->update?;
	modeArg <> 1 & file file? ifTrue:
		[file size ->size;
		FixedByteArray basicNew: size ->buf;
		Android safReadAll: file buf: buf;
		modeArg = 2 ifTrue: [size] ifFalse: [0] ->pos];
	buf nil? ifTrue: [self initEmpty]
**Android.Stream >> close
	update? ifTrue: [Android safWriteAll: file buf: buf size: size]
	
*Android.File class.
	--forward defined.
**Android.File >> pathFromRoot
	parent root?
		ifTrue: [""]
		ifFalse: [path copyFrom: Android safRoot size + 2]!
**Android.File >> stat
	Android safReadPath: self ->:rp, nil?
		ifTrue:
			[Android safStat: self ->:buf, nil?
				ifTrue: [1 ->mode]
				ifFalse:
					[buf at: 0 ->mode;
					buf i64lAt: 1 ->size;
					buf i64lAt: 9, // 1000 ->mtime]]
		ifFalse: [self statFromStatbuf: (OS stat: rp)]
**Android.File >> childFiles
	Iterator new init:
		[:b
		Android safReadPath: self ->:rp, nil?
			ifTrue: [Android safReaddir: self]
			ifFalse: [OS readdir: rp],
			split: '\n', do: [:fn b value: self + fn]]!
**Android.File >> basicRemove
	Android safRemove: self
**Android.File >> basicMkdir
	Android safMkdir: self
**Android.File >> openMode: modeArg
	modeArg = 0
		ifTrue:
			[self file? ifFalse: [self openError: modeArg];
			Android safReadPath: self ->:rp, notNil? ifTrue:
				[FileStream new init: (OS fopen: rp mode: 0)!]]
		ifFalse:
			[self file? | self none? ifFalse: [self openError: modeArg]];
	Android.Stream new init: self mode: modeArg ->:result;
	self resetStat;
	result!
**Android.File >> mtime: mtimeArg
	--DocumentFile does not support mtime.
	self!
	
