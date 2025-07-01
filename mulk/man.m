manual
$Id: mulk man.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja マニュアル

*[man]
**#en
.caption SYNOPSIS
	man [OPTION] PAGE
	man.whatis [OPTION] [PATTERN] -- Display an summary of all items. If you specify PATTERN, only lines matching the regular expression will be displayed.

.caption DESCRIPTION
Display the specified PAGE manual.

If it does not fit on one screen, it is paged in screen size.

It generally consists of the following sections:

	SUMMARY -- Summary described in one line.
	IDENTIFICATION -- File name, revision, last modified date, etc.
	SYNOPSIS -- Usage for command line use.
	DESCRIPTION
	OPTION
	LIMITATION
	SEE ALSO
	
Manuals are generated from system module files or mm files.

The summary and identification information use the contents of the first two lines of the file.

When generating from a module file, it is generated from the contents of the following additional description in addition to the contents of the [man] additional description.

	[man.s] -- Subsection.
	[man.c] -- Description of the class. The first line is a summary, and a class inheritance diagram is inserted between the following descriptions.
	[man.m] -- Description of the method.
	
These extract the item name, class name, method selector from the header line of the upper outline and assign item numbers at the appropriate outline level.
The class name uses the first token of the header line.
The method selector uses the entire header line and the contents of the line beginning with the two tabs that follow.

The following commands can be used in addition to the formatting command of format in the additional description.

	.summary PAGE -- Insert another PAGE summary.
	.hierarchy CLASS -- Insert a CLASS inheritance diagram.
	
When creating from a mm file, reshape the third and subsequent lines as they are.

.caption OPTION
	f -- Output the document before format (man command only).
	m -- Do not perform paging by more.
	l LANG -- Output the manual of the specified language.
	p ATTR -- Specifies the package attribute. If omitted, "*" is assumed (only for whatis).
	
.caption SEE ALSO
.summary more
.summary format
.summary regexp
.summary package

**#ja
.caption 書式
	man [OPTION] PAGE
	man.whatis [OPTION] [PATTERN] -- 全項目の概要を表示する。PATTERNを指定すると正規表現にマッチする行のみが表示される。
	
.caption 説明
指定ページのマニュアルを表示する。

一画面に収まらない場合は画面サイズでページングされる。

一般に以下のセクションからなる。

	概要 -- 1行で記した概要
	識別情報 -- 元ファイル名、リビジョン、最終更新日時等
	書式 -- コマンド等として指定する場合の記法
	説明 -- 内容の説明
	オプション -- コマンドとして使用する場合のオプション
	制限事項
	関連項目

マニュアルはシステムモジュールファイルもしくはmmファイルから生成する。

概要と識別情報はファイル先頭の2行の内容を用いる。

モジュールファイルから生成する場合、[man]付加記述の内容の他、以下の付加記述の内容から生成される。

	[man.s] -- サブセクション。
	[man.c] -- クラスの説明。先頭行を概要とし、それ以降の記述との間にクラス継承図を挿入する。
	[man.m] -- メソッドの説明。

これらは上位アウトラインのヘッダ行から項目名、クラス名、メソッドセレクタを抽出し、適切なアウトラインレベルで項目番号を割り当てる。
クラス名はヘッダ行の最初のトークンを用いる。
メソッドセレクタはヘッダ行全体と後続する2つのタブで始まる行の内容を用いる。

付加記述中ではformatの整形コマンドの他、以下のコマンドが使用出来る。

	.summary PAGE -- 他のPAGEの概要を挿入する。
	.hierarchy CLASS -- クラスの継承図を挿入する。

mmファイルから生成する場合は、3行目以降をそのまま整形する。

.caption オプション
	f -- format前の文書を出力する(manコマンドのみ)。
	m -- moreによるページングを行わない。
	l LANG -- 指定の言語のマニュアルを出力する。
	p ATTR -- パッケージ属性を指定する。省略時は"*"が設定されたと見做す(whatisのみ)。
	
.caption 関連項目
.summary more
.summary format
.summary regexp
.summary package

*import.@
	Mulk import: #("optparse")

*ManualSummaryGenerator class.@
	Object addSubclass: #ManualSummaryGenerator instanceVars:
		"lang name file"
**ManualSummaryGenerator >> init: langArg
	langArg ->lang
**ManualSummaryGenerator >> setupFile
	name + ".m", asSystemFileIfNotExist: [nil] ->file, notNil? ifTrue: [true!];
	name + ".mm", asSystemFileIfNotExist: [nil] ->file, notNil? 
		ifTrue: [true!];
	false!
**ManualSummaryGenerator >> getSummary: fs
	fs getLn ->:result;
	fs getLn; -- skip id line.
	[fs getLn ->:ln, notNil?] whileTrue:
		[ln head?: '#', ifFalse: [result!];
		ln copyFrom: 1 until: 3, = lang ifTrue:
			[ln size > 4 ifTrue: [ln copyFrom: 4] ifFalse: [result]!]];
	result!
**ManualSummaryGenerator >> summary: nameArg
	nameArg ->name;
	self setupFile
		ifTrue: [file readDo: [:fs self getSummary: fs]]
		ifFalse: ["<module not found>"] ->:summary;
	name + " -- " + summary!
	
*ManualGenerator class.@
	ManualSummaryGenerator addSubclass: #ManualGenerator
		instanceVars: "in out level header headers orgLevels"
**ManualGenerator >> setupFile
	super setupFile ifFalse: [self error: "missing manual for " + name]
**ManualGenerator >> generateHeader
	Out putLn: ".title " + name + " -- " + in getLn;
	Out putLn: ".id " + in getLn

**ManualGenerator >> concatHeader
	in getLn; -- skip header
	[in getLn ->:ln, notNil? and: [ln heads?: "\t\t"]] whileTrue:
		[header + ' ' + (ln copyFrom: 2) ->header]
		
**document body.
***ManualGenerator >> cmd.summary: rd
	Out putLn: "    " + 
		(ManualSummaryGenerator new init: lang, summary: rd getToken)
***ManualGenerator >> generateHierarchy: cn
	Array new ->:ar;
	[Mulk at: cn asSymbol in: name] on: Error do:
		[:e
		Out putLn: "  <import module failed>"!] ->:cl;
	0 ->:depth;
	cl hierarchies reverse do:
		[:c2
		Out put: ' ' times: depth * 2 + 4;
		Out put: c2;
		c2 features ->:fs, notNil? ifTrue: [Out put: "(" + fs + ')'];
		Out putLn;
		depth + 1 ->depth]
***ManualGenerator >> cmd.hierarchy: rd
	self generateHierarchy: rd getToken
***ManualGenerator >> processCommand: arg
	AheadReader new init: arg ->:rd;
	"cmd" + rd getToken + ":", asSymbol ->:selector;
	self respondsTo?: selector, ifFalse: [false!];
	rd skipSpace;
	self perform: selector with: rd;
	true!
***ManualGenerator >> generateRemain
	in contentLinesDo:
		[:ln
		ln head?: '.', and: [self processCommand: ln],
			ifFalse: [Out putLn: ln]];
	in nextBlock
***ManualGenerator >> generateBody
	in getLn; -- skip header
	self generateRemain
	
**ManualGenerator >> generate.man
	self generateBody;
	[in level > level] whileTrue:
		[Out put: '*' times: in level - level;
		Out putLn: in header;
		self generateBody]
**ManualGenerator >> generateOutlineHeader
	Out put: '*' times: orgLevels size + 1;
	Out putLn: (headers at: level - 1)
**ManualGenerator >> generate.man.s
	self generateOutlineHeader;
	orgLevels addLast: level;
	self generateBody
**ManualGenerator >> generate.man.c
	self generateOutlineHeader;
	orgLevels addLast: level;
	in getLn;
	Out putLn: in getLn;
	AheadReader new init: (headers at: level - 1), getToken ->:cn;
	self generateHierarchy: cn;
	self generateRemain
**ManualGenerator >> generate.man.m
	self generateOutlineHeader;
	self generateBody
**ManualGenerator >> generateBlock
	in level ->level;
	in header ->header;
	headers size <= level ifTrue: [headers size: level + 1];
	header includesSubstring?: " >> ", ifTrue: [self concatHeader];
	headers at: level put: header;
	[orgLevels empty? not, and: [orgLevels last > level]] whileTrue:
		[orgLevels removeLast];
	header = "[man]" ifTrue: [self generate.man!];
	header = "[man.s]" ifTrue: [self generate.man.s!];
	header = "[man.c]" ifTrue: [self generate.man.c!];
	header = "[man.m]" ifTrue: [self generate.man.m!];
	in nextBlock

**ManualGenerator >> generateM
	Array new ->headers;
	Array new ->orgLevels;
	in level = 0 ifTrue: [in nextBlock];
	[in level <> -1] whileTrue: [self generateBlock]
**ManualGenerator >> generateMM
	0 ->level;
	self generate.man
**ManualGenerator >> generate: nameArg
	nameArg ->name;
	self setupFile;
	Array new ->:pipes;
	file multiLanguage? ifTrue: [pipes addLast: "delang " + lang];
	pipes addLast:
		[OutlineReader new init: In ->in;
		self generateHeader;
		file suffix = "m" 
			ifTrue: [self generateM] 
			ifFalse: [self generateMM]];
	file pipe: pipes to: Out

*man tool.@
	Object addSubclass: #Cmd.man instanceVars: "op lang pipes"
**Cmd.man >> setLang
	Mulk.lang ->lang;
	op at: 'l' ->:opt, notNil? ifTrue: [opt ->lang]
**Cmd.man >> setMore
	op at: 'm', ifFalse: [pipes addLast: "more"]
**Cmd.man >> main: args
	OptionParser new init: "fml:" ->op, parse: args ->args;
	self setLang;
	Array new ->pipes;
	pipes addLast: [ManualGenerator new init: lang, generate: args first];
	op at: 'f', ifFalse:
		[pipes addLast: "format";
		self setMore];
	In pipe: pipes to: Out
**Cmd.man >> main.whatis: args
	OptionParser new init: "ml:p:" ->op, parse: args ->args;
	self setLang;
	Array new ->pipes;
	op at: 'p' ->:attr, nil? ifTrue: ['*' ->attr];
	pipes addLast: "package.list " + attr + " | grep ?*.m(m|)$ | gres .?*$";
	pipes addLast:
		[In contentLinesDo:
			[:ln
			Out putLn: 
				(ManualSummaryGenerator new init: lang, summary: ln)]];
	args empty? ifFalse:
		[pipes addLast: "grep '" + args first + "'"];
	self setMore;
	In pipe: pipes to: Out
