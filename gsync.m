sync with google drive
$Id: mulk gsync.m 1140 2023-11-28 Tue 23:21:21 kt $
#ja グーグルドライブとの同期

*[man]
**#en
.caption SYNOPSIS
	gsync [SYNCDIR]
.caption DESCRIPTION
Compare the files under SYNCDIR with the files under the directory with the same name as SYNCDIR directly under Google Drive, and unify them on the new side.

If SYNCDIR is omitted, the current directory is used.

File is treated as text.
Files in the ".git" directory, files that start with '_', end with '~', and have a "wk" extension are not included.

Create a file "_sync" in SYNCDIR after synchronization.
At the time of next synchronization, a newer version than this is targeted.
Show a conflict if both the local file and the file on Google Drive are newer than _sync.
In this case, touch the priority side and gsync again.
.caption See Also
.summary gdrive
**#ja
.caption 書式
	gsync [SYNCDIR]
.caption 説明
SYNCDIR下のファイルとグーグルドライブ直下のSYNCDIRと同名のディレクトリ下のファイルを比較し、新しい側に統一する。

SYNCDIRを省略した場合はカレントディレクトリが対象となる。

ファイルはテキストとして扱う。
".git"ディレクトリ内のファイル、先頭が'_'、末尾が'~'、拡張子が"wk"のファイルは対象としない。

同期後にSYNCDIRに"_sync"というファイルを作成する。
次回同期時はこれより新しいものが対象となる。
ローカルファイルとグーグルドライブ上のファイルのどちらも_syncより新しい場合は競合した旨を表示する。
この場合、優先すべき側をtouchして再度gsyncする。
.caption 関連項目
.summary gdrive

*@
	Object addSubclass: #Cmd.gsync instanceVars:
		"localRoot remoteRoot consDict synctime remoteWritten"
**Cmd.gsync >> targetFile: fileArg
	fileArg readableFile? ifFalse: [false!];
	fileArg name ->:fn;
	fn first = '_' or: [fn last = '~'], or: [fileArg suffix = "wk"],
		ifTrue: [false!];
	true!
**Cmd.gsync >> consAt: fileArg from: upperArg
	consDict at: (fileArg pathFrom: upperArg) ifAbsentPut: [Cons new]!	
**Cmd.gsync >> syncFile: fileArg
	fileArg nil? ifTrue: [false!];
	synctime nil? ifTrue: [true!];
	fileArg mtime > synctime!
**Cmd.gsync >> copyFrom: from to: to
	Kernel currentProcess printCall;
	to kindOf?: GDrive.File, ifTrue: [to ->remoteWritten];
	to parent mkdir;
	from pipeTo: to
**Cmd.gsync >> copy: name cons: cons
	self syncFile: cons car,
		ifTrue:
			[self syncFile: cons cdr,
				ifTrue: 
					[Out putLn: "conflict " + name,
						putLn: "local\t" + cons car mtime,
						putLn: "remote\t" + cons cdr mtime]
				ifFalse: [self copyFrom: cons car to: remoteRoot + name]!];
	self syncFile: cons cdr, & (self syncFile: cons car) not ifTrue:
		[self copyFrom: cons cdr to: localRoot + name!];
	cons car nil? ifTrue: [Out putLn: name + " local removed"];
	cons cdr nil? ifTrue: [Out putLn: name + " remote removed"]
**Cmd.gsync >> main: args
	args empty? ifTrue: ["."] ifFalse: [args first], asFile ->localRoot;
	"/gdrive" asFile + localRoot name ->remoteRoot, directory? ifFalse:
		[self error: "missing "+ remoteRoot];
	localRoot + "_sync" ->:f, readableFile?
		ifTrue: [f mtime ->synctime];
	Dictionary new ->consDict;
	localRoot decendantFiles do:
		[:lf
		lf path includesSubstring?: "/.git/", not
			and: [self targetFile: lf], 
			ifTrue: [self consAt: lf from: localRoot, car: lf]];
	remoteRoot decendantFiles do:
		[:rf
		self targetFile: rf,
			ifTrue: [self consAt: rf from: remoteRoot, cdr: rf]];
	consDict keysAndValuesDo: [:k :cons self copy: k cons: cons];
	remoteWritten notNil? ifTrue:
		[remoteWritten mtime unixTime - DateAndTime new initNow unixTime ->:d;
		d > 0 ifTrue:
			[Out putLn: "sleep " + d;
			"sleep " + d, runCmd]];
	"touch " + f quotedPath, runCmd
