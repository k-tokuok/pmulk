disk usage
$Id: mulk du.m 1259 2024-06-15 Sat 21:38:52 kt $
#ja ディスク使用量

*[man]
**#en
.caption SYNOPSIS
	du [OPTION] [DIRECTORY]
.caption DESCRIPTION
Displays the disk usage (total file size) under the specified directory in directory units.

If the directory is omitted, the usage below the current directory is displayed.
.caption OPTION
	a -- Display for all elements, including files.
	s -- Limit the display to one level below the specified directory.
	k -- Display size in kilobytes.
	f -- Display for the read directory names.
	w WIDTH -- specifies the numeric width. If omitted, 11 is assumed.
**#ja
.caption 書式
	du [OPTION] [ディレクトリ]
.caption 説明
指定ディレクトリ以下のディスクの使用量(ファイルサイズの総計)をディレクトリ単位で表示する。

ディレクトリが省略された場合はカレントディレクトリ以下の使用量を表示する。
.caption オプション
	a -- ファイルを含めた全ての要素について表示する。
	s -- 表示を指定ディレクトリ下の1階層に限定する。
	k -- サイズをキロバイト単位で表示する。
	f -- 読み込んだディレクトリ名に対して表示する。
	w WIDTH -- 数値の幅を指定する。省略時は11とする。

*du tool.@
	Mulk import: #("optparse" "numlnwr");
	Object addSubclass: #Cmd.du instanceVars:
		"rootDir all? summary? kilo? writer"
**Cmd.du >> print: file size: size
	writer put: size and: 
		(file = rootDir ifTrue: ['.'] ifFalse: [file pathFrom: rootDir])
**Cmd.du >> sweep: list level: level
	0 ->:totalSize;
	list do:
		[:f
		f directory?
			ifTrue:
				[self sweep: f childFiles level: level + 1 ->:size;
				true ->:print?]
			ifFalse:
				[f size ->size;
				size nil? ifTrue:
					[Out putLn: "illegal file " + f;
					0 ->size];
				kilo? ifTrue: [size + 1023 // 1024 ->size];
				all? ->print?];
		summary? & (level <> 0) ifTrue: [false ->print?];
		print? ifTrue: [self print: f size: size];
		totalSize + size ->totalSize];
	totalSize!
**Cmd.du >> main: args
	OptionParser new init: "askfw:" ->:op, parse: args ->args;
	NumberedLineWriter new init: 11 op: op ->writer;
	args empty? ifTrue: ["."] ifFalse: [args first], asFile ->rootDir;

	op at: 'a' ->all?;
	op at: 's' ->summary?;
	op at: 'k' ->kilo?;
	op at: 'f',
		ifTrue: [In contentLines collect: [:fn rootDir + fn]]
		ifFalse: [rootDir childFiles] ->:files;
	self sweep: files level: 0 ->:size;
	self print: rootDir size: size
