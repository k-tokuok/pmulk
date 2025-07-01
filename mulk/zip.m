zip archiver
$Id: mulk zip.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja zipアーカイバ

*[man]
**#en
.caption SYNOPSIS
	zip.c [OPTION] ZIPFILE [DIR [FILE...]] -- Create ZIPFILE.
	zip.l [OPTION] ZIPFILE -- List files in ZIPFILE.
	zip.e [OPTION] ZIPFILE [DIR [FILE...]] -- Extract the contents of ZIPFILE.
	zip.p ZIPFILE FILE -- Outputs FILE in ZIPFILE.
.caption DESCRIPTION
Create a ZIPFILE from the contents of the current directory, or extract the contents of the ZIPFILE to the current directory.

You can specify the target directory as DIR and the target files as FILE.
Filenames are handled in UTF-8 regardless of the character encoding of the host OS.
.caption OPTION
	f -- Include only files in the file list from standard input(c, e).
	p PREFIX -- Create an entry to be expanded under the PREFIX directory (c).
	v -- Display processings verbosely (c, l, e).
		The l subcommand displays compressed size, expanded size, and date.
.caption SEE ALSO
.summary zlib
**#ja
.caption 書式
	zip.c [OPTION] ZIPFILE [DIR [FILE...]] -- ZIPFILEを作成する。
	zip.l [OPTION] ZIPFILE -- ZIPFILE内のファイル一覧を表示。
	zip.e [OPTION] ZIPFILE [DIR [FILE...]] -- ZIPFILEの内容を展開する。
	zip.p ZIPFILE FILE -- ZIPFILE内のFILEを出力する。
.caption 説明
カレントディレクトリの内容からZIPFILEを作成したり、ZIPFILEの内容をカレントディレクトリに展開する。

DIRとして対象のディレクトリを、FILEとして対象のファイルを指定することができる。
ホストOSの文字コードに関わらず、ファイル名はUTF-8で扱われる。
.caption オプション
	f -- 標準入力からのファイルリストのファイルのみを対象とする(c, e)。
	p PREFIX -- PREFIXディレクトリ下に展開されるようにエントリを作る(c)。
	v -- 処理を詳細に表示する(c, l, e)。
		lサブコマンドでは圧縮サイズ、展開サイズ、日付を表示する。
.caption 関連項目
.summary zlib

*import.@
	Mulk import: #("fbdatal" "optparse" "zlib")
	
*Zip.Entry class.@
	Object addSubclass: #Zip.Entry instanceVars:
		"zip compressionMethod compressionSize uncompressedSize fileName"
		+ " lastModifiedTime crc32 headerOffset"
**Zip.Entry >> init: zipArg
	zipArg ->zip
	
**accessing.
***Zip.Entry >> compressionMethod
	compressionMethod!
***Zip.Entry >> compressionSize
	compressionSize!
***Zip.Entry >> uncompressedSize
	uncompressedSize!
***Zip.Entry >> fileName
	fileName!
***Zip.Entry >> lastModifiedTime
	lastModifiedTime!
***Zip.Entry >> headerOffset
	headerOffset!
	
**Zip.Entry >> read
	zip u32 <> 0x02014b50 
		ifTrue: [self error: "illegal centralDirectoryEntry"];
	zip skip: 2; -- version
	zip skip: 2; -- minimumVersion
	zip skip: 2; -- flag
	zip u16 ->compressionMethod;
	zip u16 ->:time;
	zip u16 ->:date;
	DateAndTime new
		initYear: date >> 9 + 1980
		month: date >> 5 & 0xf
		day: date & 0x1f
		hour: time >> 11 & 0x1f
		minute: time >> 5 & 0x3f
		second: time & 0x1f * 2
		->lastModifiedTime;
	zip skip: 4; -- crc32
	zip u32 ->compressionSize;
	zip u32 ->uncompressedSize;
	zip u16 ->:fileNameLen;
	zip u16 ->:extraFieldLen;
	zip u16 ->:commentLen;
	zip skip: 2; -- diskNo
	zip skip: 2; -- internalFileAttribute
	zip skip: 4; -- externalFileAttribute
	zip u32 ->headerOffset;
	zip string: fileNameLen ->fileName;
	zip skip: extraFieldLen;
	zip skip: commentLen

**write.
***Zip.Entry >> time
	(lastModifiedTime hour << 11)
		| (lastModifiedTime minute << 5)
		| (lastModifiedTime second // 2)!
***Zip.Entry >> date
	(lastModifiedTime year - 1980 << 9)
		| (lastModifiedTime month << 5)
		| lastModifiedTime day!
***Zip.Entry >> write: file as: fileNameArg
	file mtime ->lastModifiedTime;
	fileNameArg ->fileName;
	file contentBytes ->:src;
	file size ->uncompressedSize;
	Zlib crc32: src ->crc32;
	Zlib compress: src ->:dest, nil?
		ifTrue:
			[0 ->compressionMethod;
			src ->dest]
		ifFalse: [8 ->compressionMethod];
	dest size ->compressionSize;
	
	--localFileHeader
	zip pos ->headerOffset;
	zip u32: 0x04034b50; -- header
	zip u16: 20; -- version
	zip u16: 2048; -- flag/UTF-8
	zip u16: compressionMethod;
	zip u16: self time;
	zip u16: self date;
	zip u32: crc32;
	zip u32: compressionSize;
	zip u32: uncompressedSize;
	zip u16: fileName size;
	zip u16: 0;
	zip putBytes: fileName;

	--fileData
	zip putBytes: dest
***Zip.Entry >> writeCentralDirectoryHeader
	zip u32: 0x02014b50;
	zip u16: 788; -- versionMadeBy
	zip u16: 20; -- versionNeed
	zip u16: 2048; -- flag/UTF8
	zip u16: compressionMethod;
	zip u16: self time;
	zip u16: self date;
	zip u32: crc32;
	zip u32: compressionSize;
	zip u32: uncompressedSize;
	zip u16: fileName size;
	zip u16: 0; -- extraFieldLength
	zip u16: 0; -- fileCommentLength
	zip u16: 0; -- diskNumberStart
	zip u16: 0; -- internalFileAttribute
	zip u32: 2176188416; -- externalFileAttribute
	zip u32: headerOffset;
	zip putBytes: fileName
	
*Zip class.@
	Object addSubclass: #Zip instanceVars: "zf zfp buf entries ctr"
	
**Mulk.charset = #sjis >
***Zip >> createCtr: arg
	Mulk at: #CodeTranslatorFactory in: "ctrlib", create: arg ->ctr

**Zip >> init
	FixedByteArray basicNew: 256 ->buf
**Zip >> initRead: fileArg
	fileArg ->zf;
	zf openRead ->zfp;
	Mulk.charset = #sjis ifTrue: [self createCtr: "us"]
**Zip >> initWrite: fileArg
	fileArg ->zf;
	zf openWrite ->zfp;
	Array new ->entries;
	Mulk.charset = #sjis ifTrue: [self createCtr: "su"]

**binary access.
***Zip >> pos
	zfp tell!
***Zip >> pos: posArg
	zfp seek: posArg
***Zip >> skip: sizeArg
	self pos: self pos + sizeArg
***Zip >> u32
	zfp read: buf size: 4;
	buf ui32lAt: 0!
***Zip >> u16
	zfp read: buf size: 2;
	buf ui16lAt: 0!
***Zip >> string: size
	zfp read: buf size: size;
	buf makeStringFrom: 0 size: size ->:result;
	ctr notNil? ifTrue: [ctr translate: result ->result];
	result!
***Zip >> u16: val
	buf ui16lAt: 0 put: val;
	zfp write: buf size: 2
***Zip >> u32: val
	buf ui32lAt: 0 put: val;
	zfp write: buf size: 4
***Zip >> putBytes: bytes
	zfp write: bytes

**Zip >> sweep: blockArg
	zf size < 256 ifTrue: [self error: "too small zip file"];
	self pos: zf size - 256;
	zfp read: buf;
	buf indexOf: "PK\x05\x06" size: 4 from: buf size - 4 until: 0 ->:p;
	self pos: zf size - 256 + p;
	self skip: 4; -- signature
	self skip: 2; -- numberOfThisDisk
	self skip: 2; -- numberOfTheDiskOfCentralDirectory
	self u16 ->:n; -- numberOfTheCentralDirectoryOfThisDisk
	self u16 ->:n2; -- numberOfTheCentralDirectory
	n <> n2 ifTrue: [self error: "may multiple disk archive"];
	self skip: 4; -- centralDirectorySize
	self pos: self u32; -- centralDirectoryOffset
	n timesRepeat: [blockArg value: (Zip.Entry new init: self, read)]
**Zip >> extract: entry to: stream
	self pos: entry headerOffset + 26;
	self u16 ->:fnlen;
	self u16 ->:extlen;
	self skip: fnlen + extlen;
	
	entry uncompressedSize ->:destLen;
	entry compressionMethod ->:m, = 0 ifTrue:
		[FixedByteArray basicNew: destLen ->:dest;
		zfp read: dest;
		stream write: dest!];
	self assert: m = 8;
	FixedByteArray basicNew: entry compressionSize ->:src;
	zfp read: src;
	Zlib uncompress: src destLen: destLen ->dest;
	stream write: dest
**Zip >> add: file as: fileName
	ctr notNil? ifTrue: [ctr translate: fileName ->fileName];
	Zip.Entry new init: self, write: file as: fileName ->:entry;
	entries addLast: entry
**Zip >> write
	self pos ->:centralDirectoryOffset;
	entries do: [:e e writeCentralDirectoryHeader];

	--EndOfCentralDirectoryRecord
	self pos ->:endOfCentralDirectoryOffset;
	self u32: 0x06054b50;
	self u16: 0; --numberOfThisDisk
	self u16: 0; --numberOfTheDiskOfCentralDirectory
	self u16: entries size;
	self u16: entries size;
	self u32: endOfCentralDirectoryOffset - centralDirectoryOffset;
	self u32: centralDirectoryOffset;
	self u16: 0 --commentLen
**Zip >> close
	zfp close
	
*zip tool.@
	Object addSubclass: #Cmd.zip instanceVars: 
		"zipFile zip rootDir fileNames prefix verbose?"

**Cmd.zip >> createZip
	Zip new ->zip!
**Cmd.zip >> parseArgs: args
	args first asFile ->zipFile;
	args size = 1 
		ifTrue: ["." asFile ->rootDir]
		ifFalse:
			[args at: 1, asFile ->rootDir;
			args size > 2 ifTrue: [args copyFrom: 2 ->fileNames]]
**Cmd.zip >> option_f: op
	op at: 'f', ifTrue: 
		[self assert: fileNames nil?;
		In contentLines ->fileNames]
**Cmd.zip >> option_v: op
	op at: 'v' ->verbose?
	
**c subcommand.
***Cmd.zip >> addFile: f
	f readableFile? ifFalse: [self!];
	verbose? ifTrue: [Out putLn: f];
	f pathFrom: rootDir ->:fn;
	prefix notNil? ifTrue: [prefix + '/' + fn ->fn];
	zip add: f as: fn
***Cmd.zip >> main.c: args
	OptionParser new init: "fp:v" ->:op, parse: args ->args;
	self parseArgs: args;
	self option_f: op;
	self option_v: op;
	op at: 'p' ->prefix;
	self createZip initWrite: zipFile;
	fileNames nil? 
		ifTrue: [rootDir decendantFiles do: [:f self addFile: f]]
		ifFalse: [fileNames do: [:fn self addFile: rootDir + fn]];
	zip write;
	zip close

**Cmd.zip >> main.l: args
	OptionParser new init: "v" ->:op, parse: args ->args;
	self option_v: op;
	self createZip initRead: args first asFile;
	zip sweep: 
		[:entry 
		verbose? ifTrue:
			[Out 
				put: entry compressionSize width: 11,
				put: ' ',
				put: entry uncompressedSize width: 11,
				put: ' ',
				put: entry lastModifiedTime,
				put: ' '];
		Out putLn: entry fileName];
	zip close
	
**e subcommand.
***Cmd.zip >> dirCheck: fileArg
	fileArg ->:file;
	[file parent ->file, = rootDir ifTrue: [self!];
	file notNil?] whileTrue;
	self error: "illegal extract file " + fileArg
***Cmd.zip >> main.e: args
	OptionParser new init: "fv" ->:op, parse: args ->args;
	self parseArgs: args;
	self option_f: op;
	fileNames notNil? ifTrue: [Set new addAll: fileNames ->:fileSet];
	self option_v: op;
	self createZip initRead: zipFile;
	zip sweep:
		[:entry
		entry uncompressedSize <> 0 and:
				[fileSet nil? or: [fileSet includes?: entry fileName]], ifTrue:
			[rootDir + entry fileName ->:file;
			verbose? ifTrue: [Out putLn: file];
			self dirCheck: file;
			zip pos ->:pos;
			file writeDo: [:str zip extract: entry to: str];
			zip pos: pos]];
	zip close
			
**Cmd.zip >> main.p: args
	self createZip initRead: args first asFile;
	args at: 1 ->:fn;
	zip sweep:
		[:entry
		entry fileName = fn ifTrue: 
			[zip extract: entry to: Out;
			zip close!]];
	zip close
