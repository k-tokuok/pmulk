forth utilities
$Id: mulk/forth forthut.m 1625 2026-07-31 Fri 22:21:07 kt $
#ja
*[man]
**#en
.caption SYNOPSIS
	forthut.build -- Environment Setup
	forthut.dtoscr, forthut.scrtod, forthut.dtolst -- Various Conversions
.caption DESCRIPTION
A utility for building memory images and disk images.

The "forth.d" file contains the source code for the Forth core and secondary word dictionary and various utilities, and is in an outline format (hereinafter referred to as "d format") divided into screen units.
In the current implementation, a screen is 64 characters by 16 lines, totaling 1,024 bytes, and each screen must not exceed this size.

forthut.build uses this to generate forth.img and forth.scr.

forthut.dtoscr takes d-format as input and outputs a disk image.

forthut.scrtod takes a disk image as input and outputs d-format.

forthut.dtolst reads d-format and outputs a text file suitable for listing.
.caption LIMITATION
This program runs only under a console with screen control capabilities.
.caption SEE ALSO
.summary forth
.summary sconsole
**#ja
.caption 書式
	forthut.build -- 環境構築
	forthut.dtoscr, forthut.scrtod, forthut.dtolst -- 各種変換
.caption 説明
メモリイメージ/ディスクイメージを構築する為のユーティリティ。

forth.dファイルがForth中核の二次語辞書及び各種ユーティリティのソースで、スクリーン単位で分割したアウトライン形式(以下d形式)となっている。
現在の実装のスクリーンは64文字x16行=1024バイトであり、各スクリーンはこの大きさを越えてはならない。

forthut.buildはこれよりforth.imgとforth.scrを生成する。

forthut.dtoscrはd形式を入力し、ディスクイメージを出力する。

forthut.scrtodはディスクイメージを入力し、d形式を出力する。

forthut.dtolstはd形式を読み込み、リスティング向けのテキストファイルを出力する。
.caption 制限事項
画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary forth
.summary sconsole

*@
	Mulk import: "forth"

*Forth.IB class.@
	Cmd.forth addSubclass: #Forth.IB
		instanceVars: "compile? dp dict blk lineBuf builtins"
**Forth.IB >> init
	Dictionary new ->builtins;
	#(	"_primitive" #bPrimitive		"(" #bParen
		":" #bColon						";" #bSemiColon
		"if" #bIf						"then" #bThen
		"else" #bElse					"begin" #bBegin
		"until" #bUntil					"constant" #bConstant
		"variable" #bVariable			"_dp" #bDp
		"while" #bWhile					"repeat" #bRepeat
		"_memsize" #bMemSize			"_dict" #bDict
		"again" #bAgain					"immediate" #bImmediate
		"[compile]" #bBracketCompile	"_blk!" #bBlockStore
		"'" #bQuote						"_save" #bSave
		"_dict!" #bDictStore) ->:array;
	0 until: array size by: 2, do:
		[:i builtins at: (array at: i) put: (array at: i + 1)]
**Forth.IB >> getToken
	lineBuf findFirst: [:ch ch <> ' '] ->:st, nil? ifTrue: [nil!];
	lineBuf indexOf: ' ' after: st ->:en, nil?
		ifTrue:
			[lineBuf copyFrom: st ->:result;
			"" ->lineBuf]
		ifFalse:
			[lineBuf copyFrom: st until: en ->result;
			lineBuf copyFrom: en ->lineBuf];
	result!
	
**dictionary accession.
***Forth.IB >> dictSb: d
	mem at: dp put: d;
	dp + 1 ->dp
***Forth.IB >> dictSw: d
	self sw: dp data: d;
	dp + cell ->dp
***Forth.IB >> dictCreate: name
	dp ->:nfa;
	self dictSb: name size;
	name bytesDo: [:b self dictSb: b];
	self dictSw: dict;
	self dictSw: blk;
	nfa ->dict
***Forth.IB >> dictFind: name
	dict ->:nfa;
	[nfa <> 0] whileTrue:
		[mem at: nfa, & 0x7f ->:nlen;
		nfa + 1 + nlen ->:lfa;
		mem makeStringFrom: nfa + 1 size: nlen, = name
			ifTrue: [lfa + (cell * 2)!];
		self lw: lfa ->nfa];
	0!
***Forth.IB >> dictFindExist: name
	self dictFind: name ->:cfa;
	cfa = 0 ifTrue: [self error: name + " undefined"];
	cfa!

**builtin words.
***Forth.IB >> bPrimitive
	self dictCreate: self getToken;
	self dictSw: dp + cell;
	self dictSb: self pop
***Forth.IB >> bParen -- (
	lineBuf indexOf: ')' ->:pos, nil? ifTrue: [self error: "missing )"];
	lineBuf copyFrom: pos + 1 ->lineBuf
***Forth.IB >> bColon -- :
	self dictCreate: self getToken;
	self dictSw: (self dictFindExist: "(:)", + cell); -- pfa of (:)
	true ->compile?
***Forth.IB >> bSemiColon -- ;
	self dictSw: (self dictFindExist: "exit");
	false ->compile?
***Forth.IB >> bIf
	self assert: compile?;
	self dictSw: (self dictFindExist: "(0branch)");
	self push: dp;
	self dictSw: 0
***Forth.IB >> bThen
	self assert: compile?;
	self sw: self pop data: dp
***Forth.IB >> bElse
	self assert: compile?;
	self dictSw: (self dictFindExist: "(branch)");
	self pop ->:prev;
	self push: dp;
	self push: prev;
	self dictSw: 0;
	self bThen
***Forth.IB >> bBegin
	self assert: compile?;
	self push: dp
***Forth.IB >> bUntil
	self assert: compile?;
	self dictSw: (self dictFindExist: "(0branch)");
	self dictSw: self pop
***Forth.IB >> bConstant
	self dictCreate: self getToken;
	self dictSw: (self dictFindExist: "(constant)", + cell);
	self dictSw: self pop
***Forth.IB >> bVariable
	self dictCreate: self getToken;
	self dictSw: (self dictFindExist: "(variable)", + cell);
	self dictSw: self pop
***Forth.IB >> bDp
	self push: dp
***Forth.IB >> bWhile
	self assert: compile?;
	self bIf
***Forth.IB >> bRepeat
	self pop ->:whileLab;
	self dictSw: (self dictFindExist: "(branch)");
	self dictSw: self pop;
	self sw: whileLab data: dp
***Forth.IB >> bMemSize
	self push: memSize
***Forth.IB >> bDict
	self push: dict
***Forth.IB >> bAgain
	self assert: compile?;
	self dictSw: (self dictFindExist: "(branch)");
	self dictSw: self pop
***Forth.IB >> bImmediate
	mem at: dict put: (mem at: dict) | 0x80
***Forth.IB >> bBracketCompile -- [compile]
	self
***Forth.IB >> bBlockStore -- blk!
	self pop ->blk
***Forth.IB >> bQuote -- '
	self push: (self dictFindExist: self getToken)
***Forth.IB >> bSave -- ( boot abort st en)
	self pop ->:en;
	self pop ->:st;
	self pop ->:abort;
	self pop ->:boot;

	self sw: 0 data: boot;
	self sw: 2 data: abort;

	self imgFile writeDo:
		[:fs fs write: mem from: st size: en - st];

	Out putLn: "done"
***Forth.IB >> bDictStore -- dict!
	self pop ->dict

**outer interpreter.
***Forth.IB >> runBuiltin: token
	builtins at: token ifAbsent: [false!] ->:b;
	self perform: b;
	true!
***Forth.IB >> runDefined: token
	self dictFind: token ->:cfa;
	cfa = 0 ifTrue: [false!];

	compile?
		ifTrue: [self dictSw: cfa]
		ifFalse:
			[self sw: 0 data: cfa;
			self sw: 2 data: (self dictFindExist: "bye");
			0 ->ip;
			self innerIP];
	true!
***Forth.IB >> runNumeric: token
	token asNumber ->:value;
	value negative? ifTrue: [value + 0x10000 ->value];
	compile?
		ifTrue:
			[self dictSw: (self dictFindExist: "(literal)");
			self dictSw: value]
		ifFalse: [self push: value]
***Forth.IB >> outerIP
	false ->compile?;
	In contentLinesDo:
		[:l l ->lineBuf;
		[self getToken ->:token, notNil?] whileTrue:
			[self runBuiltin: token ->:done?;
			done? ifFalse: [self runDefined: token ->done?];
			done? ifFalse: [self runNumeric: token]]]

**Forth.IB >> makeImage
	super init: 16 * 1024; -- default memorySize
	20 ->dp;
	0 ->dict;
	self outerIP;
	self finish
				
*forthut tool.@
	Object addSubclass: #Cmd.forthut instanceVars: "nextLn"
**dtoscr
***Cmd.forthut >> readLn
	nextLn ->:result;
	In getLn ->nextLn;
	result!
***Cmd.forthut >> readBlock
	0 ->:lnNo;
	self readLn;
	[nextLn notNil? and: [nextLn head?: '*', not]] whileTrue:
		[self readLn ->:ln;
		self assert: ln size <= 64;
		Out put: ln, put: ' ' times: 64 - ln size;
		lnNo + 1 ->lnNo];
	self assert: lnNo <= 16;
	16 - lnNo timesRepeat: [Out put: ' ' times: 64]
***Cmd.forthut >> main.dtoscr: args
	self readLn;
	[nextLn notNil?] whileTrue: [self readBlock]

**Cmd.forthut >> main.dtosrc: args
	args at: 0, asNumber ->:st;
	args at: 1, asNumber ->:en;
	false ->:out?;
	In contentLinesDo:
		[:s
		s head?: '*',
			ifTrue:
				[s copyFrom: 1, asNumber ->:blkNo;
				blkNo between: st and: en ->out?,
					ifTrue: [Out putLn: blkNo asString + " _blk!"]]
			ifFalse:
				[out? ifTrue: [Out putLn: s]]]
**Cmd.forthut >> main.build: args
	"forth.d" asSystemFile ->:dFile;
	Forth.IB new ->:ib;
	
	dFile pipe: "forthut.dtoscr" to: ib scrFile;
	dFile pipe: "grep 'imagescr: #?*#' #0", getLn ->:imagescr;
	dFile pipe: "forthut.dtosrc " + imagescr, pipe: [ib makeImage]
**Cmd.forthut >> main.dtolst: args
	true ->:first?;
	In contentLinesDo:
		[:s
		s head?: '*',
			ifTrue:
				[first? ifTrue: [false ->first?] ifFalse: [Out putLn];
				Out putLn: "SCR#" + (s copyFrom: 1);
				0 ->:lineNo]
			ifFalse:
				[Out put: lineNo width: 3, put: ' ', put: s,
					putSpaces: 64 - s size, putLn: '<';
				lineNo + 1 ->lineNo]]
**Cmd.forthut >> main.scrtod: args
	16 ->:height;
	64 ->:width;
	1 ->:no;
	FixedByteArray basicNew: height * width ->:buf;
	[In read: buf from: 0 size: height * width, <> 0] whileTrue:
		[Out putLn: "*" + no;
		Ring new ->:r;
		height timesDo:
			[:i
			buf makeStringFrom: i * width size: width ->:s;
			s findLast: [:ch ch <> ' '] ->:pos, nil?
				ifTrue: ["" ->s]
				ifFalse: [s copyFrom: 0 until: pos + 1 ->s];
			r addLast: s];
		[r last size = 0] whileTrue: [r removeLast];
		r do: [:s2 Out putLn: s2];
		no + 1 ->no]
