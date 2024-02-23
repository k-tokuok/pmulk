output dependency for makefile
$Id: mulk cdep.m 932 2022-09-18 Sun 17:45:15 kt $
#ja makefile用の依存関係を出力

*[man]
**#en
.caption SYNOPSIS
	cdep [SUFFIX]
.caption DESCRIPTION
Get C source file names from standard input and output dependency rule for makefile.

Specify the object file extension as SUFFIX.
If omitted, it is assumed that "o" is specified.
**#ja
.caption 書式
	cdep [SUFFIX]
.caption 説明
標準入力からC言語のソースファイル名列を取得し、makefile用の依存関係規則を出力する。

SUFFIXとしてオブジェクトファイルの拡張子を指定する。
省略すると"o"が指定されたものと見做す。

*cdep tool.@
	Object addSubclass: #Cmd.cdep instanceVars: "dependSet objectSuffix"

**Cmd.cdep >> addDepend: fn
	Out put: ' ', put: fn;
	dependSet add: fn
**Cmd.cdep >> sweepLine: line
	line heads?: "#include", ifFalse: [self!];
	line indexOf: '"' ->:spos, nil? ifTrue: [self!];
	line lastIndexOf: '"' ->:epos;
	line copyFrom: spos + 1 until: epos ->:fn;
	dependSet includes?: fn, ifTrue: [self!];
	self addDepend: fn;
	self sweep: fn asFile
**Cmd.cdep >> sweep: file
	file file? ifTrue: [file contentLinesDo: [:line self sweepLine: line]]
**Cmd.cdep >> makedep: fn
	Set new ->dependSet;
	fn asFile ->:f;

	Out put: f baseName, put: '.', put: objectSuffix, put: ':';
	self addDepend: fn;
	self sweep: f;

	Out putLn
**Cmd.cdep >> main: args
	args size = 1 ifTrue: [args first] ifFalse: ["o"] ->objectSuffix;
	In contentLinesDo: [:fn self makedep: fn]
