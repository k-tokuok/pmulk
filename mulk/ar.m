archiver
$Id: mulk ar.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja アーカイバ

*[man]
**#en
.caption SYNOPSIS
	ar.c [-f] [DIR [FILE...] >ARCHIVE -- Create ARCHIVE.
	ar.l <ARCHIVE -- List files in ARCHIVE.
	ar.e [DIR [FILE...]] <ARCHIVE -- Extract the contents of ARCHIVE.
Create an archive file from the contents of the current directory, or extract the contents of an archive file to the current directory.

You can specify the target directory as DIR and the target file as FILE.
.caption OPTION
	f --  Read the list of target files from standard input.
**#ja
.caption 書式
	ar.c [-f] [DIR [FILE...]] >ARCHIVE -- ARCHIVEを作成する。
	ar.l <ARCHIVE -- ARCHIVEのファイル一覧を表示。
	ar.e [DIR [FILE...]] <ARCHIVE -- ARCHIVEの内容を展開する。
カレントディレクトリの内容からアーカイブファイルを作成したり、アーカイブファイルの内容をカレントディレクトリに展開する。

DIRとして対象のディレクトリと、FILEとして対象のファイルを指定することが出来る。
.caption オプション
	f -- 標準入力から対象ファイルの一覧を読み込む。
	
*ar tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.ar instanceVars: "baseDir fileNames"
**Cmd.ar >> writeString: stringArg
	Out put: stringArg, putByte: 0
**Cmd.ar >> write: fileArg
	fileArg readableFile? ifFalse: [self!];
	fileArg pathFrom: baseDir ->:fn;
	self writeString: fn;
	fileArg contentBytes ->:bytes;
	self writeString: bytes size;
	Out write: bytes
**Cmd.ar >> parseArgs: args
	args empty?
		ifTrue: ["." asFile ->baseDir]
		ifFalse:
			[args first asFile ->baseDir;
			args size > 1 ifTrue: [args copyFrom: 1 ->fileNames]]
**Cmd.ar >> main.c: args
	OptionParser new init: "f" ->:op, parse: args ->args;
	self parseArgs: args;
	op at: 'f', ifTrue:
		[self assert: fileNames nil?;
		In contentLines ->fileNames];
	fileNames nil? 
		ifTrue: [baseDir decendantFiles do: [:f self write: f]]
		ifFalse: [fileNames do: [:fn self write: baseDir + fn]]
**Cmd.ar >> readString
	StringWriter new ->:wr;
	[In getByte ->:b, <> 0] whileTrue:
		[b = -1 ifTrue: [nil!];
		wr putByte: b];
	wr asString!
**Cmd.ar >> readEntriesDo: blockArg
	[self readString ->:fn, notNil?] whileTrue:
		[self readString asInteger ->:sz;
		blockArg value: fn value: sz]
**Cmd.ar >> skip: size
	size timesRepeat: [In getByte]
**Cmd.ar >> main.l: args
	self readEntriesDo:
		[:fn :sz
		Out putLn: fn;
		self skip: sz]
**Cmd.ar >> main.e: args
	self parseArgs: args;
	fileNames notNil? ifTrue: [Set new addAll: fileNames ->:fileSet];
	self readEntriesDo:
		[:fn :sz
		fileSet notNil? and: [fileSet includes?: fn, not], 
			ifTrue: [self skip: sz]
			ifFalse:
				[baseDir + fn writeDo:
					[:wr
					FixedByteArray basicNew: sz ->:bytes;
					In read: bytes;
					wr write: bytes]]]
