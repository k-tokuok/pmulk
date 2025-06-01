sync with Google Drive
$Id: mulk gsync.m 1427 2025-05-23 Fri 22:48:03 kt $
#ja Googleドライブとの同期

*[man]
**#en
.caption SYNOPSIS
	gsync [SYNCDIR...]
.caption DESCRIPTION
Compare the files under SYNCDIR with the files under the directory with the same name as SYNCDIR directly under Google Drive, and unify them on the new side.

If SYNCDIR is omitted, the current directory is used.

File is treated as text.
Files in the ".git" directory, beginning with '_' or '.', files ending in '~' and with the extension "wk" are not included.

Create a file "_sync" in SYNCDIR after synchronization.
At the time of next synchronization, a newer version than this is targeted.
If both the local file and the file on Google Drive are newer than _sync, a conflict is indicated, so specify which has priority.
.caption See Also
.summary gdrive
**#ja
.caption 書式
	gsync [SYNCDIR...]
.caption 説明
SYNCDIR下のファイルとGoogleドライブ直下のSYNCDIRと同名のディレクトリ下のファイルを比較し、新しい側に統一する。

SYNCDIRを省略した場合はカレントディレクトリが対象となる。

ファイルはテキストとして扱う。
".git"ディレクトリ内のファイル、先頭が'_'又は'.'、末尾が'~'、拡張子が"wk"のファイルは対象としない。

同期後にSYNCDIRに"_sync"というファイルを作成する。
次回同期時はこれより新しいものが対象となる。
ローカルファイルとGoogleドライブ上のファイルのどちらも_syncより新しい場合は競合した旨を表示するので、どちらを優先するかを指定する。
.caption 関連項目
.summary gdrive

*@
	Object addSubclass: #Cmd.gsync instanceVars:
		"localRoot gdriveRoot consDict synctime gdriveWritten"
**Cmd.gsync >> targetFile: fileArg
	fileArg readableFile? ifFalse: [false!];
	fileArg name ->:fn;
	fn first ->:ch, = '_' or: [ch = '.'], or: [fn last = '~'], 
			or: [fileArg suffix = "wk"], not!
**Cmd.gsync >> consAt: fileArg from: upperArg
	consDict at: (fileArg pathFrom: upperArg) ifAbsentPut: [Cons new]!	
**Cmd.gsync >> syncFile: fileArg
	fileArg nil? ifTrue: [false!];
	synctime nil? ifTrue: [true!];
	fileArg mtime > synctime!
**Cmd.gsync >> copyFrom: from to: to
	Kernel currentProcess printCall;
	to kindOf?: GDrive.File, ifTrue: [to ->gdriveWritten];
	to parent mkdir;
	from pipeTo: to
**Cmd.gsync >> query
	Prompt getString: "priory to l)ocal or g)drive or s)kip" satisfy:
		[:s s empty? not 
			and: [s first ->:ch, = 'l' | (ch = 'g') | (ch = 's')]];
	ch!
**Cmd.gsync >> copyToGdrive: name
	self copyFrom: localRoot + name to: gdriveRoot + name
**Cmd.gsync >> copyToLocal: name
	self copyFrom: gdriveRoot + name to: localRoot + name
**Cmd.gsync >> remove: file
	Kernel currentProcess printCall;
	file remove
**Cmd.gsync >> copy: name cons: cons
	self syncFile: cons cdr ->:gnew?;
	self syncFile: cons car,
		ifTrue:
			[gnew?
				ifTrue: 
					[Out putLn: "conflict " + name,
						putLn: "local\t" + cons car mtime,
						putLn: "gdrive\t" + cons cdr mtime;
					self query ->:ch, = 'l' ifTrue: [self copyToGdrive: name];
					ch = 'g' ifTrue: [self copyToLocal: name]]
				ifFalse: [self copyToGdrive: name!]]
		ifFalse: [gnew? ifTrue: [self copyToLocal: name!]];
	cons car nil? ifTrue: 
		[Out putLn: name + " local removed";
		self query ->ch, = 'l' ifTrue: [self remove: gdriveRoot + name];
		ch = 'g' ifTrue: [self copyToLocal: name]];
	cons cdr nil? ifTrue: 
		[Out putLn: name + " gdrive removed";
		self query ->ch, = 'l' ifTrue: [self copyToGdrive: name];
		ch = 'g' ifTrue: [self remove: localRoot + name]]
**Cmd.gsync >> sync: file
	file ->localRoot;
	"/gdrive" asFile + localRoot name ->gdriveRoot, directory? ifFalse:
		[self error: "missing "+ gdriveRoot];
	localRoot + "_sync" ->:f, readableFile?
		ifTrue: [f mtime ->synctime];
	Dictionary new ->consDict;
	localRoot decendantFiles do:
		[:lf
		lf path includesSubstring?: "/.git/", not
			and: [self targetFile: lf], 
			ifTrue: [self consAt: lf from: localRoot, car: lf]];
	gdriveRoot decendantFiles do:
		[:rf
		self targetFile: rf,
			ifTrue: [self consAt: rf from: gdriveRoot, cdr: rf]];
	consDict keysAndValuesDo: [:k :cons self copy: k cons: cons];
	gdriveWritten notNil? ifTrue:
		[gdriveWritten mtime unixTime - DateAndTime new initNow unixTime ->:d;
		d > 0 ifTrue:
			[Out putLn: "sleep " + d;
			"sleep " + d, runCmd]];
	"touch " + f quotedPath, runCmd
**Cmd.gsync >> main: args
	args empty? ifTrue: [self sync: "." asFile!];
	args do: 
		[:dn 
		Out putLn: "sync: " + dn;
		self sync: dn asFile]

