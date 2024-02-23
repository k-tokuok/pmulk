copy and manage mulk packages
$Id: mulk package.m 1130 2023-11-09 Thu 06:18:33 kt $
#ja mulkパッケージのコピー及び管理

*[man]
**#en
.caption SYNOPSIS
	package [OPTION] EXPR DIR
	package.list [OPTION] EXPR -- Outputs the file structure of the package expression.
	package.sysfiles -- Outputs the current system directory structure.
	package.diff -- Compare current system directory structure with package.d structure.
	package.sysclean -- Remove extra files in the current system directory.
.caption DESCRIPTION
Select and convert the files in the system directory according to the purpose and copy them.

Attribute symbols are assigned to each system file.
The attributes defined in the standard are as follows.
	vm -- Mulk virtual machine source
	lib -- Libraries
	tool -- Tools
	etc -- Etc. files.
	bin -- Binary file
	ja -- Only available in Japanese environment

The package expression specifies the copy target and conversion, and is defined by the following syntax.
	EXPR = attr ('+' attr)* ('-' attr)* ('#' lang)? ('@' code)? (':' revision)
	'+' -- Add files with attributes.
		'*' for all files, 'std' for vm+base+lib+tool.
	'-' -- Exclude files with attributes.
	'#' -- Filter by delang.
	'@' -- Specify the character code and end-of-line code in the argument format of ctr.
	':' -- Exclude those that are the same as or older than the specified revision.
.caption OPTION
	s SYSDIR -- Use SYSDIR as the system directory.
	r -- Display revision number of file (list).
	m -- Multi-column output (list).
.caption SEE ALSO
	package.d -- The file in csv format with the system filename, revision number (* if unknown), and the attributes.
.summary ctr
**#ja
.caption 書式
	package [OPTION] EXPR DIR
	package.list [OPTION] EXPR -- パッケージ式のファイル構成を出力する。
	package.sysfiles -- 現在のシステムディレクトリの構成を出力する。
	package.diff -- 現在のシステムディレクトリの構成とpackage.dの構成を比較する。
	package.sysclean -- 現在のシステムディレクトリの余分なファイルを削除する。
	
.caption 説明
システムディレクトリ中のファイルを用途に応じて選択・変換してコピーする。

各システムファイルは属性シンボルが割り当てられている。
標準で定義されている属性は以下の通り。

	vm -- Mulk仮想機械のソース
	lib -- ライブラリ
	tool -- ツール
	etc -- その他のファイル
	bin -- バイナリファイル
	ja -- 日本語環境でのみ使用可能
	
パッケージ式はコピーの対象や変換を指定するもので、次の構文で定義される。
	EXPR = attr ('+' attr)* ('-' attr)* ('#' lang)? ('@' code)? (':' revision)
	'+' -- 属性を持つファイルを加える。
		*で全てのファイル、stdでvm+lib+tool+etcが対象となる。
	'-' -- 属性を持つファイルを除く。
	'#' -- delangによるフィルタリング処理を行う。
	'@' -- 文字コード・行末コードをctrの引数形式で指定する。
	':' -- 指定revisionと同じか古いものを除く。
.caption オプション
	s SYSDIR -- システムディレクトリとしてSYSDIRを使用する。
	r -- ファイルのリビジョン番号を表示 (list)。
	m -- マルチカラム表示 (list)。
.caption 関連項目
	package.d -- csv形式でシステムファイル名とリビジョン番号(不明なら*)、その後に属性が書かれたファイル。
.summary ctr
*import.@
	Mulk import: #("csvrd" "optparse" "tempfile")

*Package.File class.@
	Object addSubclass: #Package.File instanceVars: 
		"file syms revision"
**Package.File >> init: ar
	ar first ->file;
	self hash: file hash;
	ar at: 1, trim ->:r, <> "*" ifTrue: [r asInteger ->revision];
	Set new ->syms;
	ar copyFrom: 2, do: 
		[:name 
		name trim asSymbol ->:sym;
		syms add: sym]
**Package.File >> file
	file!
**Package.File >> syms
	syms!
**Package.File >> = fileArg
	file = fileArg file!
**Package.File >> match?: symArg
	syms includes?: symArg!
**Package.File >> readRevision
	self match?: #bin, ifTrue: [0!];
	file pipe: "head 5 | grep '\\$Id: [~ ]* [~ ]* #@d*#' #0", pipe getLn 
		->:ln;
	ln nil? ifTrue: [0] ifFalse: [ln asInteger]!
**Package.File >> revision
	revision nil? ifTrue: [self readRevision ->revision];
	revision!
	
*package tool.@
	Object addSubclass: #Cmd.package instanceVars:
		"sysDir expr allFiles reader files syms textFilter packageFiles"
**Cmd.package >> setupSysDir: opArg
	opArg at: 's' ->:op, nil?
		ifTrue: [Mulk.systemDirectory]
		ifFalse: [op asFile] ->sysDir
**Cmd.package >> sysFile: fnArg
	sysDir + fnArg!
**Cmd.package >> idChar?
	reader nextChar ->:ch, nil? ifTrue: [false!];
	"+-#@:" includes?: ch, not!
**Cmd.package >> getId
	reader resetToken;
	[self idChar?] whileTrue: [reader getChar];
	reader token!
**Cmd.package >> getSym
	self getId asSymbol!
**Cmd.package >> addFiles: symArg
	symArg = #* ifTrue: 
		[allFiles do: 
			[:f 
			files add: f;
			syms addAll: f syms]!];
	symArg = #std ifTrue: [#(#vm #lib #tool #etc) do: [:s self addFiles: s]!];
	allFiles do: [:f2 f2 match?: symArg, ifTrue: [files add: f2]];
	syms add: symArg
**Cmd.package >> removeFilesIf: blockArg
	Set new ->:newfiles;
	files do:
		[:f
		blockArg value: f, ifFalse: [newfiles add: f]];
	newfiles ->files
**Cmd.package >> addTextFilter: filterArg
	textFilter nil? 
		ifTrue: [filterArg]
		ifFalse: [textFilter + " | " + filterArg] ->textFilter
**Cmd.package >> setupFiles: exprArg
	exprArg ->expr;
	Array new ->allFiles;
	CsvReader new init: (self sysFile: "package.d", pipe: "grep -e ^;") ->:rd;
	[rd get ->:ar, notNil?] whileTrue:
		[ar at: 0 put: (self sysFile: ar first);
		allFiles addLast: (Package.File new init: ar)];
	Set new ->files;
	Set new addAll: #(#bin #ja #npw) ->syms;
	AheadReader new init: expr ->reader;
	self addFiles: self getSym;
	[reader nextChar = '+'] whileTrue:
		[reader skipChar;
		self addFiles: self getSym];
	[reader nextChar = '-'] whileTrue:
		[reader skipChar;
		self getSym ->:sym;
		self removeFilesIf: [:f0 f0 match?: sym]];
	reader nextChar = '#' ifTrue:
		[reader skipChar;
		self getId ->:lang;
		self addTextFilter: "delang " + lang;
		lang = "en" ifTrue: [self removeFilesIf: [:f2 f2 match?: #ja]]];
	reader nextChar = '@' ifTrue:
		[reader skipChar;
		self addTextFilter: "ctr " + self getId];
	files asArray ->packageFiles;
	reader nextChar = ':' ifTrue:
		[reader skipChar;
		self getId asInteger ->:r;
		self removeFilesIf: 
			[:f3 
			f3 file name <> "package.d" & (f3 revision <= r)]];
	reader nextChar notNil? ifTrue: [self error: "illegal expr"]
**Cmd.package >> packageRevision
	packageFiles inject: 0 into: [:r :f r max: f revision]!
**Cmd.package >> make_package_d
	Out putLn: ";Mulk package " + expr + " (" + self packageRevision + ')';
	Out put: ";";
	"date" runCmd;
	packageFiles do:
		[:f
		f file name = "package.d" 
			ifTrue: [self packageRevision] ifFalse: [f revision] ->:r;
		Out put: f file name, put: ',', put: r;
		f syms do:
			[:s
			syms includes?: s, ifTrue: [Out put: "," + s]];
		Out putLn]
**Cmd.package >> copyText: srcArg to: destArg
	textFilter nil? 
		ifTrue: [srcArg pipe: "cat" to: destArg]
		ifFalse: [srcArg pipe: textFilter to: destArg]
**Cmd.package >> copy: fileArg to: destDirArg
	fileArg file ->:f;
	f name ->:fn;
	destDirArg + fn ->:dest;
	fn = "package.d" ifTrue: [[self make_package_d] pipe ->f];
	fileArg match?: #bin,
		ifTrue: [f pipeTo: dest]
		ifFalse: [self copyText: f to: dest]
**Cmd.package >> main: args
	OptionParser new init: "s:" ->:op, parse: args ->args;
	self setupSysDir: op;
	self setupFiles: args first;
	args at: 1, asFile ->:destDir;
	files do: [:f self copy: f to: destDir];
	files allSatisfy?: [:f2 f2 file name <> "package.d"], ifTrue:
		[self copyText:
			[
				Out putLn: "Mulk package " + expr 
					+ " (" + self packageRevision + ')';
				"date" runCmd
			] pipe
			to: destDir + "package.txt"]

**subcommands.
***Cmd.package >> main.list: args
	OptionParser new init: "s:rm" ->:op, parse: args ->args;
	self setupSysDir: op;
	op at: 'r' ->:rev?;
	"sort" ->:filter;
	op at: 'm', ifTrue: [filter + " | multicol" ->filter];
	self setupFiles: args first;
	[files do: 
		[:f 
		rev? ifTrue: [Out put: f revision width: 7, put: ' '];
		Out putLn: f file name]] pipe: filter to: Out
***Cmd.package >> main.sysfiles: args
	OptionParser new init: "s:" ->:op, parse: args ->args;
	self setupSysDir: op;
	"ls " + (sysDir 
		+ "(?*.([chmdlr]|txt|mak|el|m[cm]|ott|dotx|mpw|make)|makefile)")
			quotedPath,
		runCmd
***Cmd.package >> main.diff: args
	TempFile create ->:f1;
	"package.list *" pipeTo: f1;
	TempFile create ->:f2;
	"package.sysfiles" pipeTo: f2;
	"diff " + f1 quotedPath + ' ' + f2 quotedPath, runCmd;
	f1 remove;
	f2 remove
***Cmd.package >> main.sysclean: args
	"package.list *" contentLines asArray ->:pfiles;
	"package.sysfiles" contentLinesDo:
		[:f
		pfiles includes?: f, ifFalse: 
			[Out putLn: f;
			Mulk.systemDirectory + f, remove]]
