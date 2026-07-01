copy and manage Mulk packages
$Id: mulk package.m 1608 2026-06-02 Tue 22:23:32 kt $
#ja Mulkパッケージのコピー及び管理

*[man]
**#en
.caption SYNOPSIS
	package [OPTION] EXPR DIR
	package.list [OPTION] EXPR -- Outputs the file structure of the package expression.
	package.sysfiles [OPTION] -- Outputs the current system directory structure.
	package.diff [OPTION] -- Compare current system directory structure with package.d structure.
	package.sysclean [OPTION] -- Remove extra files in the current system directory.
.caption DESCRIPTION
Select, convert, and copy files from the system directory according to their intended use.

Labels are assigned to each file as needed.
The standard labels are defined as follows:

	File categories:
		vm -- Mulk virtual machines
		lib -- Libraries
		tool -- Tools
		etc -- Miscellaneous
	Attributes:
		bin -- Binary files
		ja -- Specific to the Japanese environment
		dos -- Specific to the MS-DOS environment	
		pw -- Files to be packaged by packwin
	    pws -- Files required for packwin's self-compilation		
		android -- Specific to Android environment
		mulka0 -- Builtin modules for Android APK
		
The package expression specifies the target of the copy operation and the conversion, and is defined using the following syntax.
	EXPR = label ('+' label)* ('-' label)* ('#' lang)? ('@' code)?
	'+' -- Add files with the specified label. '*' includes all files.
	'-' -- Exclude files with the specified label.
	'#' -- Performs filtering using delang.
	'@' -- Specifies character encoding and line-end encoding using the ctr argument format.
.caption OPTION
	s SYSDIR -- Use SYSDIR as the system directory.
	r -- Display the file revision number (list).
	m -- Multi-column display (list).
.caption SEE ALSO
	package.d -- A file containing system filenames and revision numbers (or * if unknown) in CSV format, followed by labels.
.summary ctr

**#ja
.caption 書式
	package [OPTION] EXPR DIR
	package.list [OPTION] EXPR -- パッケージ式のファイル構成を出力する。
	package.sysfiles [OPTION] -- 現在のシステムディレクトリの構成を出力する。
	package.diff [OPTION] -- 現在のシステムディレクトリの構成とpackage.dの構成を比較する。
	package.sysclean [OPTION] -- 現在のシステムディレクトリの余分なファイルを削除する。
	
.caption 説明
システムディレクトリ中のファイルを用途に応じて選択・変換してコピーする。

各ファイルは必要に応じてラベルが付加されている。
標準で定義されているラベルは以下の通り。

	ファイルの分類:
		vm -- Mulk仮想機械
		lib -- ライブラリ
		tool -- ツール
		etc -- その他
	属性:
		bin -- バイナリファイル
		ja -- 日本語環境固有のもの
		dos -- MS-DOS環境固有のもの
		pw -- packwinのパッケージ対象ファイル
		pws -- packwinのセルフコンパイル時に必要なもの
		android -- Android環境固有のもの
		mulka0 -- Android APK用の組み込みモジュール
		
パッケージ式はコピーの対象や変換を指定するもので、次の構文で定義される。
	EXPR = label ('+' label)* ('-' label)* ('#' lang)? ('@' code)?
	'+' -- ラベルを持つファイルを加える。'*'で全てのファイルが対象となる。
	'-' -- ラベルを持つファイルを除く。
	'#' -- delangによるフィルタリング処理を行う。
	'@' -- 文字コード・行末コードをctrの引数形式で指定する。
.caption オプション
	s SYSDIR -- システムディレクトリとしてSYSDIRを使用する。
	r -- ファイルのリビジョン番号を表示 (list)。
	m -- マルチカラム表示 (list)。
.caption 関連項目
	package.d -- csv形式でシステムファイル名とリビジョン番号(不明なら*)、その後にラベルが書かれたファイル。
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
	symArg = #pmulk ifTrue: 
		[#(#vm #lib #tool #etc) do: [:s self addFiles: s]!];
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
	Set new addAll: #(#bin #ja #dos #pw #pws #android #mulka0) ->syms;
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
	files do: [:f self copy: f to: destDir]

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
***Cmd.package >> sysfiles
	"ls " + (sysDir 
		+ "(?*.([chmdl]|txt|mak|m[cm]|ott|dotx|p4)|makefile)")
			quotedPath,
		runCmd	
***Cmd.package >> main.sysfiles: args
	OptionParser new init: "s:" ->:op, parse: args ->args;
	self setupSysDir: op;
	self sysfiles

***Cmd.package >> allList
	self setupFiles: "*";
	[files do: [:f Out putLn: f file name]] pipe: "sort" to: Out
***Cmd.package >> main.diff: args
	OptionParser new init: "s:" ->:op, parse: args ->args;
	self setupSysDir: op;
	TempFile create ->:f1;
	[self allList] pipeTo: f1;
	TempFile create ->:f2;
	[self sysfiles] pipeTo: f2;
	"diff " + f1 quotedPath + ' ' + f2 quotedPath, runCmd;
	f1 remove;
	f2 remove
***Cmd.package >> main.sysclean: args
	OptionParser new init: "s:" ->:op, parse: args ->args;
	self setupSysDir: op;
	[self allList] contentLines asArray ->:pfiles;
	[self sysfiles] contentLinesDo:
		[:f
		pfiles includes?: f, ifFalse:
			[Out putLn: f;
			self sysFile: f, remove]]
