find directory differences
$Id: mulk diffdir.m 1553 2026-03-14 Sat 23:08:49 kt $
#ja ディレクトリの差分を求める

*[man]
**#en
.caption SYNOPSIS
	diffdir [OPTION] DIR1 DIR2
.caption DESCRIPTION
Compare the files and directories under directories DIR1 and DIR2.

For files that exist in only one of the directories, the following lines are output: 
	---(-)Entry name -- If present only in DIR1
	---(+)Entry name -- If present only in DIR2
	---(*)Entry Name -- Entries with the same name exist in both directories but cannot be compared (e.g., one is a directory) 
	
For files that exist in both directories but have different contents, the diff results are output following "---File Name". 
.caption OPTION
	f -- Read a list of filenames to compare from standard input.
	r -- Recursively compare directories with the same name.
	d -- Do not display file differences.
.caption SEE ALSO
.summary diff
**#ja
.caption 書式
	diffdir [OPTION] DIR1 DIR2
.caption 説明
ディレクトリDIR1とDIR2下のファイル/ディレクトリ群を比較する。

一方のディレクトリにのみにあるファイルは次の行を出力する。
	---(-)エントリ名 -- DIR1にのみある場合
	---(+)エントリ名 -- DIR2にのみある場合
	---(*)エントリ名 -- 両方に同名のエントリがあるが比較できない(一方がディレクトリであるなど)
	
双方のディレクトリにあって内容が異なるファイルは"---ファイル名"に続けてdiffの結果を出力する。

.caption オプション
	f -- 標準入力から比較対象のファイル名列を取得する。
	r -- 同名のディレクトリに対し再帰的に比較する。
	d -- ファイルの差分を表示しない。
.caption 関連項目
.summary diff

*diffdir tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.diffdir instanceVars: "dir1top recur? diff?"
**Cmd.diffdir >> diff: fn dir1: dir1 dir2: dir2
	dir1 + fn ->:f1;
	dir2 + fn ->:f2;
	f1 none? ifTrue: [Out putLn: "---(+)" + (f1 pathFrom: dir1top)!];
	f2 none? ifTrue: [Out putLn: "---(-)" + (f1 pathFrom: dir1top)!];

	f1 file? & f2 file? ifTrue:
		[f1 contentsEqual?: f2, ifFalse:
			[Out putLn: "---" + (f1 pathFrom: dir1top);
			diff? ifTrue: 
				["diff " + f1 quotedPath + ' ' + f2 quotedPath, runCmd]]!];

	f1 directory? & f2 directory? ifTrue: 
		[recur? ifTrue:
			[self filesIn: f1 and: f2, do:
				[:fn2 self diff: fn2 dir1: f1 dir2: f2]]!];

	Out putLn: "---(*)" + (f1 pathFrom: dir1top)
**Cmd.diffdir >> filesIn: dir1 and: dir2
	Set new ->:set;
	set addAll: ("ls " + dir1 quotedPath) contentLines;
	set addAll: ("ls " + dir2 quotedPath) contentLines;
	set asArray sort!
**Cmd.diffdir >> main: args
	OptionParser new init: "frd" ->:op, parse: args ->args;
	op at: 'r' ->recur?;
	op at: 'd', not ->diff?;
	args first asFile ->dir1top ->:dir1;
	args at: 1, asFile ->:dir2;
	op at: 'f',
		ifTrue: [In contentLines]
		ifFalse: [self filesIn: dir1 and: dir2],
		do: [:fn self diff: fn dir1: dir1 dir2: dir2]
