find directory differences
$Id: mulk diffdir.m 932 2022-09-18 Sun 17:45:15 kt $
#ja ディレクトリの差分を求める

*[man]
**#en
.caption SYNOPSIS
	diffdir [-f] DIR1 DIR2
.caption DESCRIPTION
Compare the files directly under the directories DIR1 and DIR2.

Files in only one directory output the following line:
	---(-) file name -- only in DIR1
	---(+) file name -- only in DIR2

For files with different contents in both files, the diff result is output after "---file name".

.caption OPTION
	f -- gets the file name string for comparison from standard input.
.caption SEE ALSO
.summary diff
**#ja
.caption 書式
	diffdir [-f] DIR1 DIR2
.caption 説明
ディレクトリDIR1とDIR2の直下のファイル群を比較する。

一方のディレクトリにのみにあるファイルは次の行を出力する。
	---(-)ファイル名 -- DIR1にのみある場合
	---(+)ファイル名 -- DIR2にのみある場合

双方のファイルにあって内容が異なるファイルは"---ファイル名"に続けてdiffの結果を出力する。

.caption オプション
	f -- 標準入力から比較対象のファイル名列を取得する。
.caption 関連項目
.summary diff

*diffdir tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.diffdir instanceVars: "dir1 dir2"
**Cmd.diffdir >> diff: fn
	dir1 + fn ->:f1;
	dir2 + fn ->:f2;
	f1 none? ifTrue: [Out putLn: "---(+)" + fn!];
	f2 none? ifTrue: [Out putLn: "---(-)" + fn!];

	f1 contentsEqual?: f2, ifTrue: [self!];

	Out putLn: "---" + fn;
	"diff " + f1 quotedPath + ' ' + f2 quotedPath, runCmd
**Cmd.diffdir >> main: args
	OptionParser new init: "f" ->:op, parse: args ->args;
	args first asFile ->dir1;
	args at: 1, asFile ->dir2;
	op at: 'f',
		ifTrue: [In contentLines]
		ifFalse:
			[Set new ->:set;
			set addAll: ("ls -f " + dir1 quotedPath) contentLines;
			set addAll: ("ls -f " + dir2 quotedPath) contentLines;
			set asArray sort],
		do: [:fn self diff: fn]
