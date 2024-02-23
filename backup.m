differential backup
$Id: mulk backup.m 1054 2023-05-13 Sat 21:50:56 kt $
#ja 差分バックアップ

*[man]
**#en
.caption SYNOPSIS
	backup [-cmf] backupDir
	backup.verify [-m] backupDir -- Check the contents of the final backup.
	backup.restore backupDir restoreDir <listFile -- Read listFile and restore the contents of the backup under restoreDir.
	backup.remove backupDir start [end] -- The capacity of backupDir is reduced by deleting the listFile from start to end and the files necessary for restoring them.
	
.caption DESCRIPTION
Make a backup of any directory.

As a preparation, a directory (backupDir) for saving the backup is created, and a file named 'target' is created immediately below the directory.
The target file is a one-line text file that holds the backup target directory name.

listFile is a file created under backupDir with the extension lst consisting of date and time, and holds the file list at the time of backup.
By passing a part of the restore list with the restore subcommand, you can restore only some of the files.

.caption OPTION
	c -- Check file contents when checking for changes. By default, it is determined only by file size and time stamp.
	m -- Check only file contents.
	f -- Perform a full backup.
**#ja
.caption 書式
	backup [-cmf] backupDir
	backup.verify [-m] backupDir -- 最終バックアップの内容を確認する。
	backup.restore backupDir restoreDir <listFile -- listFileを入力し、restoreDir下にバックアップの内容を復元する。
	backup.remove backupDir start [end] -- startからendまでのlistFileとそれらの復元に必要なファイルを削除する事でbackupDirの容量を縮小する。

.caption 説明
任意のディレクトリのバックアップを取る。

準備として、バックアップを保存するディレクトリ(backupDir)を作成し、その直下に'target'という名称のファイルを作成する。
targetファイルは1行のテキストファイルでバックアップ対象ディレクトリ名を保持する。

listFileはbackupDir下に作られる日付と時分からなる拡張子lstのファイルで、バックアップ時のファイル一覧を保持している。
restoreサブコマンドでは復元リストの一部を渡す事で、一部のファイルのみを復元する事が出来る。

.caption オプション
	c -- ファイルの変更をチェックする際、内容をチェックする。デフォルトではファイルサイズとタイムスタンプのみで判定する。
	m -- ファイルの内容のみでチェックする。
	f -- フルバックアップを行う。

*backup tool.@
	Mulk import: "optparse";
	
	Object addSubclass: #Cmd.backup
		instanceVars: "backupDir targetDir "
			+ "contents? modtime? lastCode newCode lastMap modified?"
**Cmd.backup >> readTarget
	backupDir + "target", contentLines asArray first asFile ->targetDir
**Cmd.backup >> readList
	"ls " + (backupDir + "?*.lst") quotedPath, contentLines asArray!
**Cmd.backup >> readLastCode
	self readList ->:list, empty? ifFalse:
		[list last ->:f;
		f copyUntil: (f indexOf: '.') ->lastCode]
**Cmd.backup >> readLastMap
	Dictionary new ->lastMap;

	lastCode notNil? ifTrue:
		[backupDir + (lastCode + ".lst") contentLinesDo:
			[:line
			line indexOf: ',' ->:commaPos;
			lastMap at: (line copyFrom: commaPos + 1)
				put: (line copyUntil: commaPos)]]
**Cmd.backup >> equal?: file and: file2
	file2 none? ifTrue:
		[Out putLn: "missing file " + file2;
		false!];
	modtime? ifTrue: [file mtime = file2 mtime ifFalse: [false!]];
	contents?
		ifTrue: [file contentsEqual?: file2]
		ifFalse: [file size = file2 size]!
**Cmd.backup >> copy: src to: dest
	Kernel currentProcess printCall;
	src none?
		ifTrue: [Out putLn: "missing file " + src]
		ifFalse: 
			[src pipeTo: dest;
			dest mtime: src mtime]
**Cmd.backup >> targetFilesDo: block
	targetDir decendantFiles do:
		[:f
		f file?
			ifTrue: [block value: f]
			ifFalse:
				[f directory?
					ifTrue: [Out putLn: f path]
					ifFalse: [self error: "illegal file: " + f]]]

**backup.
***Cmd.backup >> setNewCode
	DateAndTime new initNow ->:date;
	(date year asString0: 4) + (date month asString0: 2) +
		(date day asString0: 2) + '-' + (date hour asString0: 2) +
		(date minute asString0: 2) ->newCode
***Cmd.backup >> doBackup: f
	f pathFrom: targetDir ->:rn;

	lastMap at: rn ifAbsent: [newCode] ->:fcode;
	fcode <> newCode ifTrue:
		[lastMap removeAt: rn;
		self equal?: f and: backupDir + fcode + rn,
			ifFalse: [newCode ->fcode]];
	fcode = newCode ifTrue:
		[self copy: f to: backupDir + newCode + rn;
		true ->modified?];
	fcode + ',' + rn!
***Cmd.backup >> main: args
	OptionParser new init: "cmf" ->:op, parse: args ->args;
	op at: 'c' ->contents?;
	op at: 'm', not ->modtime?;
	op at: 'f' ->:full?;

	modtime? ifFalse: [true ->contents?];
	false ->modified?;
	args first asFile ->backupDir;
	self readTarget;
	self readLastCode;
	full?
		ifTrue: [Dictionary new ->lastMap]
		ifFalse: [self readLastMap];
	self setNewCode;

	MemoryStream new ->:list;
	self targetFilesDo: [:f list putLn: (self doBackup: f)];

	lastMap empty? ifFalse: [true ->modified?];
	modified?
		ifTrue: [list seek: 0, pipe: "cat" to: backupDir + (newCode + ".lst")]

**verify.
***Cmd.backup >> doVerify: f
	f pathFrom: targetDir ->:rn;
	lastMap at: rn ifAbsent: [nil] ->:fcode;

	fcode nil?
		ifTrue:
			[Out putLn: rn + " is not backup."]
		ifFalse:
			[self equal?: f and: backupDir + fcode + rn,
				ifFalse: [Out putLn: rn + " is differ."];
			lastMap removeAt: rn]
***Cmd.backup >> main.verify: args
	OptionParser new init: "m" ->:op, parse: args ->args;
	op at: 'm', not ->modtime?;
	true ->contents?;
	args first asFile ->backupDir;
	self readTarget;
	self readLastCode;
	self readLastMap;

	self targetFilesDo: [:f self doVerify: f];

	lastMap keys do: [:k Out putLn: k + " is excess."]

**Cmd.backup >> main.restore: args
	args first asFile ->backupDir;
	args at: 1, asFile ->:restoreDir;

	In contentLinesDo:
		[:line
		line indexOf: ',' ->:commaPos;
		line copyUntil: commaPos ->:code;
		line copyFrom: commaPos + 1 ->:rn;
		self copy: backupDir + code + rn to: restoreDir + rn]

**remove.
***Cmd.backup >> indexOf: s in: list
	list indexOf: s ->:ix, nil? ifTrue: [self error: "illegal entry " + s];
	ix!
***Cmd.backup >> contents: lst do: block
	backupDir + lst contentLinesDo:
		[:line
		line indexOf: ',' ->:comma;
		line copyUntil: comma, + '/' + (line copyFrom: comma + 1) ->:path;
		block value: path]
***Cmd.backup >> removeFile: file
	Kernel currentProcess printCall;
	file remove
***Cmd.backup >> removeEmptyDir: dir
	dir childFiles do:
		[:subdir
		subdir directory? ifTrue: [self removeEmptyDir: subdir]];
	dir childFiles empty? ifTrue: [self removeFile: dir]
***Cmd.backup >> main.remove: args
	args first asFile ->backupDir;
	args at: 1 ->:st;
	args size = 3 ifTrue: [args at: 2] ifFalse: [st] ->:en;

	self readList ->:list;

	self indexOf: st in: list ->st;
	self indexOf: en in: list ->en;
	st > en ifTrue: [self error: "illegal order"];

	Set new ->:removes;
	st to: en, do:
		[:ix
		list at: ix ->:fn;
		self contents: fn do: [:p1 removes add: p1];
		self removeFile: backupDir + fn];

	[:p2 removes includes?: p2, ifTrue: [removes remove: p2]] ->:block;
	st <> 0 ifTrue: [self contents: (list at: st - 1) do: block];
	en <> (list size - 1) ifTrue: [self contents: (list at: en + 1) do: block];

	Set new ->:removeDirs;
	removes do:
		[:fn2
		removeDirs add: (fn2 copyUntil: (fn2 indexOf: '/'));
		self removeFile: backupDir + fn2];

	removeDirs do:
		[:dn
		self removeEmptyDir: backupDir + dn]
