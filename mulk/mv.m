move files and directories
$Id: mulk mv.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ファイルの移動

*[man]
**#en
.caption SYNOPSIS
	mv [OPTION] [SRC...] DEST
.caption DESCRIPTION
Move file or directory SRC to DEST.

If DEST is a directory, multiple SRCs can be specified, and all of them are moved below DEST.
If DEST does not exist and SRC is a directory, create a DEST directory and move all files and directories under SRC to below DEST.

If SRC is omitted, get source file list from standard input.

Since the SRC is deleted after copying the entire contents of the SRC to the DEST, a sufficient margin is required on the disk.
On the other hand, even if the process is aborted, it is guaranteed that either SRC or DEST is complete.
.caption OPTION
	v -- Display processings verbosely.
	o -- Stop on error if file is overwritten.
	
**#ja
.caption 書式
	mv [OPTION] [SRC...] DEST
.caption 説明
ファイル又はディレクトリSRCをDESTへ移動する。

DESTがディレクトリの場合はSRCを複数指定可能で、全てをDEST以下へ移動する。
DESTが存在せず、SRCがディレクトリの場合はDESTディレクトリを作成し、SRC下の全てのファイル・ディレクトリをDEST以下へ移動する。

SRCが省略された場合は標準入力からファイルリストを取得する。

SRCの内容を全てDEST下へコピーしてからSRCを削除するので、ディスクに十分な余裕が必要となる。
一方、途中で処理を打ち切ってもSRCもしくはDESTの何れかが完全な内容である事が保証される。
.caption オプション
	v -- 処理を詳細に表示する。
	o -- 上書きをエラーとする。
	
*mv tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.mv instanceVars: "verbose? noOverwrite?"

**Cmd.mv >> parseOption_v: op
	op at: 'v' ->verbose?
**Cmd.mv >> parseOption_o: op
	op at: 'o' ->noOverwrite?
	
**remove.
***Cmd.mv >> remove: file
	verbose? ifTrue: [Kernel currentProcess printCall];
	file remove
***Cmd.mv >> removeFileOrDir: file
	file directory? ifTrue: [file decendantFiles do: [:f self remove: f]];
	self remove: file
***Cmd.mv >> removeArgs: args
	args do: [:fn self removeFileOrDir: fn asFile]
	
**copy.
***Cmd.mv >> copy: src to: dest
	verbose? ifTrue: [Kernel currentProcess printCall];
	src directory? ifTrue: [dest mkdir!];
	noOverwrite? and: [dest none? not],
		ifTrue: [self error: "overwrite " + dest];
	src pipeTo: dest
***Cmd.mv >> copy: src destFileBy: block
	src directory? ifTrue:
		[src decendantFiles do: [:f self copy: f to: (block value: f)]];
	self copy: src to: (block value: src)
***Cmd.mv >> copyArgs: args to: destFn
	destFn asFile ->:dest;
	dest directory? ifTrue:
		[args do:
			[:srcName
			srcName asFile ->:src;
			src parent ->:srcParent;
			self copy: src destFileBy: [:f dest + (f pathFrom: srcParent)]]!];
	self assert: args size = 1;
	args first asFile ->src;
	self copy: src destFileBy:
		[:f2
		f2 = src ifTrue: [dest] ifFalse: [dest + (f2 pathFrom: src)]]

**Cmd.mv >> files: args
	args empty?
		ifTrue: [In contentLines asArray]
		ifFalse: [args]!
**Cmd.mv >> main: args
	OptionParser new init: "vo" ->:op, parse: args ->args;
	self parseOption_v: op;
	self parseOption_o: op;
	
	args last ->:destFn;
	args removeLast;
	self files: args ->args;
	self copyArgs: args to: destFn;
	self removeArgs: args
