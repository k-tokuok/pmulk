PipeConnectable feature
$Id: mulk pipe.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Provide a framework for easy connection of input and output.
.hierarchy PipeConnectable
It applies to Reader, File, Block, String in default.

If the receiver is a Reader, the target is from the current position to the end.

If the receiver is Block, it is evaluated, and if it is String, it is executed as a command string, and the output to Out during processing is targeted.
At this time, the value of In at the time of evaluation is referred to as it is.
.caption SEE ALSO
.summary cmd

**#ja
.caption 説明
入出力の接続を簡便に行う枠組みを提供する。
.hierarchy PipeConnectable
標準ではReader, File, Block, Stringに対して適用される。

レシーバーがReaderの場合は現在位置から末尾までが対象となる。

レシーバーがBlockの場合これを評価、Stringの場合はコマンド文字列として実行し、処理中のOutへの出力が対象となる。
この時、Inは評価時のInの値がそのまま参照される。
.caption 関連項目
.summary cmd

*PipeConnectable feature.@
	Feature addSubclass: #PipeConnectable
**PipeConnectable >> pipeDo: block
	--for Block or String
	block value: self pipe!

**PipeConnectable >> pipe: intermArg to: fileOrWriterArg
	self pipeDo: [:rd rd pipe: intermArg to: fileOrWriterArg]
***[man.m]
****#en
Input the receiver to intermArg and connect the output to fileOrWriterArg.

intermArg is one of Block, String, and Array. 
If Block, evaluation is performed, and if String, it is executed as a command string.
In the case of Array, each element is executed sequentially as Block or String.

If an error occurs during execution, recover properly.

****#ja
intermArgにレシーバーを入力し、出力をfileOrWriterArgへ接続する。

intermArgはBlock、String、Arrayの何れかで、Blockの場合は評価、Stringの場合はコマンド文字列として実行する。
Arrayの場合、要素はBlockかStringでそれぞれを順次実行する。

実行中にエラーが起きた場合、適切に回復する。

**PipeConnectable >> pipe: intermArg appendTo: fileArg
	fileArg appendDo: [:wr self pipe: intermArg to: wr]
***[man.m]
****#en
Input the receiver to intermArg and append the output to fileArg.
****#ja
intermArgにレシーバーを入力し、出力をfileArgへ追記する。

**PipeConnectable >> pipe: intermArg
	self pipe: intermArg to: (MemoryStream new ->:result);
	result seek: 0!
***[man.m]
****#en
Input receiver to interm and return output as MemoryStream.

The return value of the method can be used as Reader as it is or connected to the next process.
****#ja
intermArgにレシーバーを入力し、出力をMemoryStreamとして返す。

メソッドの返り値はそのままReaderとして使用したり、次の処理へ接続する事が出来る。

**PipeConnectable >> pipeTo: fileOrWriterArg
	--for Block or String
	In pipe: self to: fileOrWriterArg
***[man.m]
****#en
Copy the contents of the receiver to fileOrWriterArg.
****#ja
レシーバーの内容をfileOrWriterArgへコピーする。

**PipeConnectable >> pipe
	--for Block or String
	In pipe: self!
***[man.m]
****#en
Returns the contents of the receiver as a MemoryStream.
****#ja
レシーバーの内容をMemoryStreamとして返す。

**PipeConnectable >> pipeAppendTo: fileArg
	--for Block or String.
	In pipe: self appendTo: fileArg
***[man.m]
****#en
Append the contents of the receiver to fileArg.

Currently applicable only to Block or String.
****#ja
レシーバーの内容をfileArgに追記する。

現状ではBlock/Stringに対してのみ適用可能。

**PipeConnectable >> contentLines
	Iterator new init: 
		[:doBlock
		self pipeDo: [:rd rd contentLinesDo: doBlock]]!
***[man.m]
****#en
Returns an Iterator for all lines of receivers.
****#ja
レシーバーの全ての行のIteratorを返す。

**PipeConnectable >> contentLinesDo: blockArg
	self contentLines do: blockArg
***[man.m]
****#en
Evaluate blockArg with each line of the receiver as an argument.
****#ja
レシーバーの各行を引数にblockArgを評価する。

**PipeConnectable >> contentBytes
	self pipe contentBytes!
***[man.m]
****#en
Returns a FixedByteArray of the contents of the receiver.
****#ja
レシーバーの内容のFixedByteArrayを返す。

*Reader feature.@
	Reader features: #(PipeConnectable)
**Reader >> pipeDo: block to: fileOrWriter
	fileOrWriter kindOf?: File,
		ifTrue: [fileOrWriter writeDo: [:wr block value: wr]]
		ifFalse: [block value: fileOrWriter]
**Reader >> pipe: interm to: fileOrWriter
	self pipeDo: [:wr interm pipeFromReader: self toWriter: wr]
		to: fileOrWriter
**Reader >> pipeToWriter: wr
	FixedByteArray basicNew: 4096 ->:buf;
	[self read: buf ->:rdSize, <> 0] whileTrue: [wr write: buf size: rdSize]
**Reader >> pipeTo: fileOrWriter
	self pipeDo: [:wr self pipeToWriter: wr] to: fileOrWriter
**Reader >> pipe
	MemoryStream new ->:result;
	self pipeToWriter: result;
	result seek: 0!
**Reader >> contentLines
	Iterator new init:
		[:doBlock
		[self getLn ->:ln, notNil?] whileTrue: [doBlock value: ln]]!

*AbstractMemoryStream class.
**AbstractMemoryStream >> contentBytes
	size - pos ->:sz;
	FixedByteArray basicNew: sz, basicAt: 0 copyFrom: buf at: pos size: sz!
	
*File class.@
	File features: #(PipeConnectable)
**File >> pipeDo: block
	self readDo: [:rd block value: rd]!
**File >> pipeTo: fileOrWriter
	self pipeDo: [:rd rd pipeTo: fileOrWriter]
**File >> pipe
	self readDo: [:rd rd pipe]!
**File >> contentBytes
	FixedByteArray basicNew: self size ->:result;
	self readDo: [:s s read: result];
	result!
	
*Block class.@
	Block features: #(PipeConnectable)
**Block >> pipeFromReader: rd toWriter: wr
	In ->:savedIn;
	Out ->:savedOut;
	rd ->In;
	wr ->Out;
	[self value] finally:
		[savedIn ->In;
		savedOut ->Out]!

*String class.@
	String features: #(Magnitude PipeConnectable)
**String >> pipeFromReader: rd toWriter: wr
	--useBeforeDeclare: String >> runCmd.
	[self runCmd] pipeFromReader: rd toWriter: wr

*Array class.
**Array >> pipeFromReader: rd toWriter: wr
	self size - 1 timesDo:
		[:i
		rd pipe: (self at: i) ->rd];
	rd pipe: self last to: wr
