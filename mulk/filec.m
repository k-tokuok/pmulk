count files
$Id: mulk filec.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ファイルを数える

*[man]
**#en
.caption SYNOPSIS
	filec [OPTION] [DIRECTORY]
.caption DESCRIPTION
Displays the number of files under the specified directory in directory units.

If the directory is omitted, the number of files under the current directory is displayed.
If there are directories under the specified directory, those directories are also counted recursively.
.caption OPTION
	w WIDTH -- specifies the number of digits in the number of files. If omitted, 7 is assumed to be specified.
**#ja
.caption 書式
	filec [オプション] [ディレクトリ]
.caption 説明
指定ディレクトリ下のファイルの数をディレクトリ単位で表示する。

ディレクトリが省略された場合はカレントディレクトリ下のファイル数を表示する。
指定ディレクトリ下にディレクトリがある場合は、その下も再帰的に数える。
.caption オプション
	w WIDTH -- ファイル数の桁数を指定する。省略時は7が指定されたものと見做す。
	
*filec tool.@
	Mulk import: #("optparse" "numlnwr");
	Object addSubclass: #Cmd.filec instanceVars: "rootDir writer"
**Cmd.filec >> sweep: dir
	0 ->:count;
	dir childFiles do:
		[:f
		f directory?
			ifTrue: [count + (self sweep: f) ->count]
			ifFalse: [count + 1 ->count]];
	writer put: count and:
		(dir = rootDir ifTrue: ['.'] ifFalse: [dir pathFrom: rootDir]);
	count!
**Cmd.filec >> main: args
	OptionParser new init: "w:" ->:op, parse: args ->args;
	NumberedLineWriter new init: 7 op: op ->writer;
	args empty? ifTrue: ["."] ifFalse: [args first], asFile ->rootDir;
	self sweep: rootDir
