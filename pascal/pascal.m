pascal-p4 processor
$Id: mulk/pascal pascal.m 1442 2025-06-12 Thu 10:05:28 kt $
#ja

*[man]
**#en
.caption SYNOPSIS
	pascal [OPTION] PASFILE|P4FILE

.caption DESCRIPTION
If a Pascal source file (extension pas) is specified, it is compiled into a p-code file (extension p4) and then executed.
If a p-code file is specified, it is executed as is.

.lineBreak
This processor is a port of Pascal-P4 (1976).
The differences from Standard Pascal (Revised Report, 1973) are shown below.

.item
Procedural and functional parameters are not implemented.
.item
The jump destination for goto is only allowed within the procedure.
.item
Comments are denoted by (* ... *).
.item
Use the symbol '^' for pointer references.
.item
Identifiers are allowed in lowercase only and are distinguished by the first 8 characters.
.item
String literals are valid up to 128 characters.
.item
The exponent symbol for floating-point numbers is denoted by a lowercase 'e'.
.item
The operators 'or' and 'and' are valid only for logical values, with the operator '+' for union sets and '*' for common sets.
.item
dispose(p) is not implemented.
As alternatives, mark(p) and release(p) are provided.
This releases all areas allocated after mark(p) by passing the pointer variable value obtained by mark(p) to release(p).
.item
The packed specification is ignored.
The pack and unpack procedures are not implemented.
.item
The file type, text type, reset, rewrite, put, and get procedures are not implemented.
The following text type variables are defined and can be used in read/write procedures.
	input -- standard input
	output -- standard output
	prr -- additional output file
	prd -- additional input file
.item
Use the writeln procedure to output newlines, and readln (skip to newline) to input them.
The constant eol is not implemented.
eoln(text) can be used to detect if the input pointer is on a newline.
.item
Values of type boolean cannot be output by write or writeln.
.item
When outputting floating-point numbers, it is not possible to specify a decimal width.
.item
The round and all procedures are not implemented.
	
.caption OPTION
	v -- display the processing verbosely.
	r FN -- specify additional input file (default prd).
	w FN -- specify additional output file (default prr).
	p codeSize -- specifies the size of the program area (default 20000 instructions).
	s storeSize -- specifies the size of the data area (default 30000 cells).
	c -- compile only, do not execute.
	C FN -- specifies the compiler p-code file (default: pcom.p4 in the system directory).

.caption REFERENCE
	The programming language Pascal (Revised Report)
	https://www.research-collection.ethz.ch/handle/20.500.11850/68910
.lineBreak
	The PASCAL "P" compiler
	https://www.research-collection.ethz.ch/handle/20.500.11850/68666
.lineBreak
	Pascal-P: The portable Pascal compiler.
	https://www.standardpascaline.org/PascalP.html
	
.right 2
They require the courage to discard and abandon, to select simplicity and transparency as design goals rather than complexity and obscure sophistication.
--Niklaus Wirth, Computer Scientist (1934-2024)

**#ja
.caption 書式
	pascal [OPTION] PASFILE|P4FILE

.caption 説明
Pascalソースファイル(拡張子pas)を指定するとp-codeファイル(拡張子p4)にコンパイルした上で実行する。
p-codeファイルを指定するとそのまま実行される。

.lineBreak
本処理系はPascal-P4(1976)の移植版である。
Standard Pascal(Revised Report, 1973)との差異を以下に示す。

.item
手続きパラメータ、関数パラメータは実装されていない。
.item
gotoのジャンプ先は手続き内のみ可。
.item
コメントは(* ... *)で表記する。
.item
ポインタ参照は記号'^'を使用する。
.item
識別子は小文字のみ使用可能で、最初の8文字で区別する。
.item
文字列リテラルは最長128文字まで有効。
.item
浮動小数点数値の指数記号は小文字の'e'で表記する。
.item
演算子'or'と'and'は論理値に対してのみ有効で、和集合は演算子'+'を、共通集合は'*'を用いる。
.item
dispose(p)は実装されていない。
代替としてmark(p)、release(p)が提供されている。
これはmark(p)で取得したポインタ変数値をrelease(p)に渡すことでmark後に確保した全ての領域を一括して解放する。
.item
packed指定は無視される。
pack, unpack手続きは実装されていない。
.item
file型、text型、reset、rewrite、put、get手続きは実装されていない。
以下のtext型変数が定義されており、read/write手続きで使用できる。
		input -- 標準入力
		output -- 標準出力
		prr -- 追加の出力ファイル
		prd -- 追加の入力ファイル
.item
改行を出力するにはwriteln手続きを、入力するにはreadln(改行まで読み飛ばす)を使用する。
定数eolは実装されていない。
eoln(text)で入力ポインタが改行にあるかどうかを検知出来る。
.item
boolean型の値をwrite、writelnで出力することは出来ない。
.item
浮動小数点数値出力の際、小数部幅指定を行うことは出来ない。
.item
round、all手続きは実装されていない。
	
.caption オプション
	v -- 処理過程を表示する。
	r FN -- 追加の入力ファイル(デフォルト prd)を指定する。
	w FN -- 追加の出力ファイル(デフォルト prr)を指定する。
	p codeSize -- プログラム領域のサイズ(デフォルト 20000命令)を指定する。
	s storeSize -- データ領域のサイズ(デフォルト 30000セル)を指定する。
	c -- コンパイルのみを行い実行しない。
	C FN -- コンパイラのp-codeファイル(デフォルトはシステムディレクトリのpcom.p4)を指定する。
	
.caption 参考
	The programming language Pascal (Revised Report)
	https://www.research-collection.ethz.ch/handle/20.500.11850/68910
.lineBreak
	The PASCAL "P" compiler
	https://www.research-collection.ethz.ch/handle/20.500.11850/68666
.lineBreak
	Pascal-P: The portable Pascal compiler.
	https://www.standardpascaline.org/PascalP.html

.right 2
They require the courage to discard and abandon, to select simplicity and transparency as design goals rather than complexity and obscure sophistication.
--Niklaus Wirth, Computer Scientist (1934-2024)

*import.@
	Mulk import: #("optparse" "math")
	
*Pascal.Inst class.@
	Object addSubclass: #Pascal.Inst instanceVars: "opcode ch p q"
**Pascal.Inst >> opcode: arg
	arg ->opcode
**Pascal.Inst >> opcode
	opcode!
**Pascal.Inst >> ch: chArg
	chArg ->ch
**Pascal.Inst >> ch
	ch!
**Pascal.Inst >> p: pArg
	pArg ->p
**Pascal.Inst >> p
	p!
**Pascal.Inst >> q: qArg
	qArg ->q
**Pascal.Inst >> q
	q!

*Pascal.AheadReader class.@
	AheadReader addSubclass: #Pascal.AheadReader
**Pascal.AheadReader >> skipUnsignedNumber
	self skipUnsignedInteger ->:result;
	nextChar = '.' ifTrue:
		[self skipChar;
		0.1 ->:factor;
		[self digit?] whileTrue:
			[self skipChar asDecimalValue * factor + result ->result;
			factor / 10.0 ->factor]];
	nextChar = 'e' ifTrue:
		[self skipChar;
		nextChar = '+' ifTrue: [self skipChar];
		result asFloat power10: self skipInteger ->result];
	result!
		
*Pascal class.@
	Object addSubclass: #Pascal instanceVars: "code pc"
		+ " inst store mp sp ep epmax np npmin"
		+ " verbose?"
		+ " reader5 file7 stream7 reader7"
		+ " file8 stream8"
		+ " error? firstColumn?"
**Pascal >> initCodeSize: codeSizeArg storeSize: storeSizeArg 
		verbose: verboseArg
	FixedArray basicNew: codeSizeArg ->code;
	FixedArray basicNew: storeSizeArg ->store;
	verboseArg ->verbose?;
	"prd" asFile ->file7;
	"prr" asFile ->file8
	
**settings.
***Pascal >> file7: arg
	arg ->file7
***Pascal >> file8: arg
	arg ->file8
***Pascal >> verbose?
	verbose?!

**Pascal >> code
	code!
**Pascal >> store
	store!
**Pascal >> np: arg
	arg ->np

**Pascal >> base: arg
	mp ->:result;
	[arg > 0] whileTrue: 
		[store at: result + 1 ->result;
		arg - 1 ->arg];
	result!
**Pascal >> push: arg
	sp + 1 ->sp;
	store at: sp put: arg
**Pascal >> compare: p and: q
	inst ch = 'm' ifTrue:
		[inst q timesRepeat:
			[(store at: p) compareTo: (store at: q) ->:d, <> 0 ifTrue: [d!];
			p + 1 ->p;
			q + 1 ->q];
		0!];
	p compareTo: q!
**Pascal >> seteq: p and: q
	p size = q size and: [p allSatisfy?: [:p1 q includes?: p1]]!
**Pascal >> setincludes: p in: q
	p allSatisfy?: [:p1 q includes?: p1]!

**Pascal >> boolToInt: arg
	arg ifTrue: [1] ifFalse: [0]!
**Pascal >> intToBool: arg
	arg = 0 
		ifTrue: [false]
		ifFalse: 
			[arg = 1 ifTrue: [true] ifFalse: [self assertFailed]]!
		
**standard procedures.
***10.1.2. dynamic allocation procedure.
****Pascal >> stdproc.new
	np - (store at: sp) ->:ad;
	ad <= ep ifTrue: [self error: "store overflow"];
	ad ->np;
	np < npmin ifTrue: [np ->npmin];
	store at: (store at: sp - 1) put: np;
	sp - 2 ->sp
****Pascal >> stdproc.sav -- mark
	store at: (store at: sp) put: np;
	sp - 1 ->sp
****Pascal >> stdproc.rst -- release
	store at: sp ->np;
	sp - 1 ->sp
	
***11.1.2. arithmetic functions.
****Pascal >> stdproc.sin
	store at: sp put: (store at: sp) sin
****Pascal >> stdproc.cos
	store at: sp put: (store at: sp) cos
****Pascal >> stdproc.exp
	store at: sp put: (store at: sp) exp
****Pascal >> stdproc.log -- ln
	store at: sp put: (store at: sp) log
****Pascal >> stdproc.sqt -- sqrt
	store at: sp put: (store at: sp) sqrt
****Pascal >> stdproc.atn -- arctan
	store at: sp put: (store at: sp) atan
	
***read.
****Pascal >> readerAt: noArg -- 5: in, 7: prd
	noArg = 5 ifTrue:
		[reader5 nil? ifTrue: 
			[Pascal.AheadReader new initReader: In ->reader5];
		reader5!];
	noArg = 7 ifTrue:
		[reader7 nil? ifTrue:
			[file7 openRead ->stream7;
			Pascal.AheadReader new initReader: stream7 ->reader7];
		reader7!];
	self assertFailed
****Pascal >> stdproc.rdi
	self readerAt: (store at: sp) ->:rd;
	rd skipSpace;
	store at: (store at: sp - 1) put: rd skipInteger;
	sp - 2 ->sp
****Pascal >> stdproc.rdc
	self readerAt: (store at: sp) ->:rd;
	store at: (store at: sp - 1) put: rd skipChar;
	sp - 2 ->sp
****Pascal >> stdproc.rdr
	self readerAt: (store at: sp) ->:rd;
	rd skipSpace;
	store at: (store at: sp - 1) put: rd skipNumber asFloat
****Pascal >> stdproc.eln
	self readerAt: (store at: sp) ->:rd;
	rd nextChar = '\n' ->:result;
	store at: sp put: result
****Pascal >> stdproc.rln
	self readerAt: (store at: sp) ->:rd;
	[rd nextChar <> '\n'] whileTrue: [rd skipChar];
	sp - 1 ->sp
	
***write.
****Pascal >> writerAt: noArg -- 6: out, 8: prr
	noArg = 6 ifTrue: [Out!];
	noArg = 8 ifTrue:
		[stream8 nil? ifTrue: [file8 openWrite ->stream8];
		stream8!];
	self assertFailed
****Pascal >> write: strArg
	self writerAt: (store at: sp ->:fd), put: strArg;
	fd = 6 ifTrue:
		[firstColumn? and: [strArg first = '!'], ifTrue: [true ->error?];
		false ->firstColumn?]
****Pascal >> stdproc.wrs
	store at: sp - 3 ->:ad;
	store at: sp - 2 ->:k;
	store at: sp - 1 ->:j;
	StringWriter new ->:wr;
	k > j 
		ifTrue: [k - j timesRepeat: [wr put: ' ']]
		ifFalse: [k ->j];
	j timesDo: [:i wr put: (store at: ad + i)];
	self write: wr asString;
	sp - 4 ->sp
****Pascal >> stdproc.wln
	self writerAt: (store at: sp ->:fd), putLn;
	fd = 6 ifTrue: [true ->firstColumn?];
	sp - 1 ->sp
****Pascal >> stdproc.wri
	StringWriter new ->:wr, put: (store at: sp - 2) width: (store at: sp - 1);
	self write: wr asString;
	sp - 3 ->sp
****Pascal >> stdproc.wrr
	self stdproc.wri
****Pascal >> stdproc.wrc
	self stdproc.wri
	
**instructions.
***Pascal >> abi
	store at: sp put: (store at: sp) abs
***Pascal >> abr
	store at: sp put: (store at: sp) abs
***Pascal >> adi
	sp - 1 ->sp;
	store at: sp put: (store at: sp) + (store at: sp + 1)
***Pascal >> adr
	sp - 1 ->sp;
	store at: sp put: (store at: sp) + (store at: sp + 1)
***Pascal >> and
	sp - 1 ->sp;
	store at: sp put: (store at: sp) & (store at: sp + 1)
***Pascal >> chk
	store at: sp ->:v;
	inst ch ->:ch, = 'c' ifTrue: [v code ->v];
	ch = 'b' ifTrue: [v ifTrue: [1] ifFalse: [0] ->v];
	v < inst p | (v > inst q) ifTrue: [self error: "value out of range"]
***Pascal >> chr
	store at: sp put: (store at: sp) asChar
***Pascal >> csp
	self perform: inst q
***Pascal >> cup
	sp - (inst p + 4) ->mp;
	store at: mp + 4 put: pc;
	inst q ->pc	
***Pascal >> dec
	store at: sp ->:v;
	inst q ->:q;
	inst ch ->:ch, = 'c' ifTrue: [store at: sp put: (v code - q) asChar!];
	ch = 'b' ifTrue:
		[store at: sp put: (self intToBool: (self boolToInt: v) - 1)!];
	store at: sp put: v - q
***Pascal >> dif
	sp - 1 ->sp;
	Set new addAll: (store at: sp) ->:set;
	store at: sp + 1, do: [:e set includes?: e, ifTrue: [set remove: e]];
	store at: sp put: set
***Pascal >> dvi
	sp - 1 ->sp;
	store at: sp put: (store at: sp) // (store at: sp + 1)
***Pascal >> dvr
	sp - 1 ->sp;
	store at: sp put: (store at: sp) / (store at: sp + 1)
***Pascal >> ent
	inst p = 1
		ifTrue: [mp + inst q ->sp]
		ifFalse: 
			[sp + inst q ->ep;
			epmax < ep ifTrue: [ep ->epmax];
			ep > np ifTrue: [self error: "store overflow"]]
***Pascal >> eof
	store at: sp put: (self readerAt: (store at: sp), nextChar nil?)
***Pascal >> equ
	sp - 1 ->sp;
	store at: sp ->:p;
	store at: sp + 1 ->:q;
	inst ch = 's' 
		ifTrue: [self seteq: p and: q]
		ifFalse: [self compare: p and: q, = 0] ->:result;
	store at: sp put: result
***Pascal >> fjp
	store at: sp, ifFalse: [inst q ->pc];
	sp - 1 ->sp
***Pascal >> flo
	store at: sp - 1 put: (store at: sp - 1) asInteger
	--ToDo: what is store at: sp?
***Pascal >> flt
	store at: sp put: (store at: sp) asFloat
***Pascal >> geq
	sp - 1 ->sp;
	store at: sp ->:p;
	store at: sp + 1 ->:q;
	inst ch = 's' 
		ifTrue: [self setincludes: q in: p]
		ifFalse: [self compare: p and: q, >= 0] ->:result;
	store at: sp put: result
***Pascal >> grt
	sp - 1 ->sp;
	store at: sp
		put: (self compare: (store at: sp) and: (store at: sp + 1)) > 0
***Pascal >> inc
	store at: sp ->:v;
	inst q ->:q;
	inst ch ->:ch, = 'c' ifTrue: [store at: sp put: (v code + q) asChar!];
	ch = 'b' ifTrue: 
		[store at: sp put: (self intToBool: (self boolToInt: v) + q)!];
	store at: sp put: v + q
***Pascal >> ind
	store at: sp put: (store at: (store at: sp) + inst q)
***Pascal >> inn
	sp - 1 ->sp;
	store at: sp put: (store at: sp + 1, includes?: (store at: sp))
***Pascal >> int
	sp - 1 ->sp;
	Set new ->:set;
	store at: sp ->:set2;
	store at: sp + 1, do: [:i set2 includes?: i, ifTrue: [set add: i]];
	store at: sp put: set
***Pascal >> ior
	sp - 1 ->sp;
	store at: sp put: (store at: sp) | (store at: sp + 1)
***Pascal >> ixa
	store at: sp ->:i;
	sp - 1 ->sp;
	store at: sp put: inst q * i + (store at: sp)
***Pascal >> lao
	self push: inst q
***Pascal >> lca
	self push: inst q
***Pascal >> lda
	self push: (self base: inst p, + inst q)
***Pascal >> ldc
	self push: inst q
***Pascal >> ldo
	--note: evaluating text^ anticipates the text stream.
	inst q ->:ad, = 5 | (ad = 7) ifTrue: 
		[self push: (self readerAt: ad) nextChar!];
	self push: (store at: ad)
***Pascal >> leq
	sp - 1 ->sp;
	store at: sp ->:p;
	store at: sp + 1 ->:q;
	inst ch = 's'
		ifTrue: [self setincludes: p in: q]
		ifFalse: [self compare: p and: q, <= 0] ->:result;
	store at: sp put: result
***Pascal >> les
	sp - 1 ->sp;
	store at: sp
		put: (self compare: (store at: sp) and: (store at: sp + 1)) < 0
***Pascal >> lod
	self push: (store at: (self base: inst p) + inst q)
***Pascal >> mod
	sp - 1 ->sp;
	store at: sp put: (store at: sp) % (store at: sp + 1)
***Pascal >> mov
	store at: sp - 1 ->:dest;
	store at: sp ->:src;
	sp - 2 ->sp;
	inst q timesDo: [:i store at: dest + i put: (store at: src + i)]
***Pascal >> mpi
	sp - 1 ->sp;
	store at: sp put: (store at: sp) * (store at: sp + 1)
***Pascal >> mpr
	sp - 1 ->sp;
	store at: sp put: (store at: sp) * (store at: sp + 1)
***Pascal >> mst
	store at: sp + 2 put: (self base: inst p);
	store at: sp + 3 put: mp;
	store at: sp + 4 put: ep;
	sp + 5 ->sp
***Pascal >> neq
	sp - 1 ->sp;
	store at: sp ->:p;
	store at: sp + 1 ->:q;
	inst ch = 's'
		ifTrue: [self seteq: p and: q, not]
		ifFalse: [self compare: p and: q, <> 0] ->:result;
	store at: sp put: result
***Pascal >> ngi
	store at: sp put: (store at: sp) negated
***Pascal >> ngr
	store at: sp put: (store at: sp) negated
***Pascal >> not
	store at: sp put: (store at: sp) not
***Pascal >> odd
	store at: sp put: (store at: sp) % 2 = 1
***Pascal >> ord
	store at: sp ->:value;
	inst ch ->:ch, = 'c' ifTrue: [value code ->value];
	ch = 'b' ifTrue: [self boolToInt: value ->value];
	store at: sp put: value
***Pascal >> ret
	inst ch = 'p' ifTrue: [mp - 1] ifFalse: [mp] ->sp;
	store at: mp + 4 ->pc;
	store at: mp + 3 ->ep;
	store at: mp + 2 ->mp
***Pascal >> sbi
	sp - 1 ->sp;
	store at: sp put: (store at: sp) - (store at: sp + 1)
***Pascal >> sbr
	sp - 1 ->sp;
	store at: sp put: (store at: sp) - (store at: sp + 1)
***Pascal >> sgs
	store at: sp put: (Set new add: (store at: sp))
***Pascal >> sqi
	store at: sp put: (store at: sp ->:v) * v
***Pascal >> sqr
	store at: sp put: (store at: sp ->:v) * v
***Pascal >> sro
	store at: inst q put: (store at: sp);
	sp - 1 ->sp
***Pascal >> sto
	store at: (store at: sp - 1) put: (store at: sp);
	sp - 2 ->sp
***Pascal >> stp
	-1 ->pc	
***Pascal >> str
	store at: (self base: inst p) + inst q put: (store at: sp);
	sp - 1 ->sp
***Pascal >> trc
	store at: sp put: (store at: sp) asInteger
***Pascal >> ujc
	self error: "case error"
***Pascal >> ujp
	inst q ->pc
***Pascal >> uni
	sp - 1 ->sp;
	Set new addAll: (store at: sp), addAll: (store at: sp + 1) ->:set;
	store at: sp put: set
***Pascal >> xjp
	store at: sp, + inst q ->pc;
	sp - 1 ->sp

**Pascal >> run
	verbose? ifTrue: [Out putLn: "*run"];
	0 ->pc;
	-1 ->sp;
	--np is initialized by loader
	np ->npmin;
	5 ->ep ->epmax;
	0 ->:cycle;
	false ->error?;
	true ->firstColumn?;
	
	[pc <> -1] whileTrue:
		[code at: pc ->inst;
		pc + 1 ->pc;
		self perform: inst opcode;
		cycle + 1 ->cycle];
	
	stream7 notNil? ifTrue: [stream7 close];
	stream8 notNil? ifTrue: [stream8 close];
	
	verbose? ifTrue:
		[Out putLn: "*stop cycle: " + cycle + " epmax: " + epmax 
			+ " npmin: " + npmin + " store remain: " + (npmin - epmax)];
	error? not!

*Pascal.Loader class.@
	Object addSubclass: #Pascal.Loader instanceVars: 
		"pascal oprTypeDict code pc codesize labelDict reader inst"
		+ " store np"
**Pascal.Loader >> init: pascalArg
	pascalArg ->pascal;
	pascal code ->code;
	pascal store ->store;
	store size ->np;
	
	#(	#abi nil -- absolute value of integer
		#abr nil -- absolute value of real
		#adi nil -- add two integers
		#adr nil -- add two reals
		#and nil -- and two booleans
		#chk "cii" -- checks value is between lower and upper bounds
		#chr nil -- converts integer to character
		#csp #parse.csp	-- call standard procedure
		#cup "_il" -- call user procedure
		#dec "c_i" -- decrement
		#dif nil -- set difference
		#dvi nil -- integer division
		#dvr nil -- real division
		#ent "_il" -- enter block
		#eof nil -- test on end of file
		#equ #parse.compare -- compare on equal
		#fjp "__l" -- false jump
		#flo nil -- float next to top
		#flt nil -- float top of the stack
		#geq #parse.compare -- compare greater or equal
		#grt #parse.compare -- compare greater than
		#inc "c_i" -- increment
		#ind "c_i" -- indexed fetch
		#inn nil -- test set membership
		#int nil -- set intersection
		#ior nil -- boolean inciusive or
		#ixa "__i" -- compute indexed address
		#lao "__i" -- load base level address
		#lca #parse.lca -- load address of constant
		#lda "_ii" -- load address of level p
		#ldc #parse.ldc -- load constant
		#ldo "c_i" -- load contents of base level address
		#leq #parse.compare -- compare less than or equal
		#les #parse.compare -- compare less than
		#lod "cii" -- load contents of address
		#mod nil -- modulo
		#mov "__i" -- move
		#mpi nil -- integer multiplication
		#mpr nil -- real multiplication
		#mst "_i_" -- mark stack
		#neq #parse.compare -- compare on not equal
		#ngi nil -- integer sign inversion
		#ngr nil -- real sign inversion
		#not nil -- boolean not
		#odd nil -- test on odd
		#ord "c__" -- convert to integer
		#ret "c__" -- return from block
		#sbi nil -- integer subtraction
		#sbr nil -- real subtraction
		#sgs nil -- generate singleton set
		#sqi nil -- square integer
		#sqr nil -- square real
		#sro "c_i" -- store at base level address
		#sto "c__" -- store at base level address
		#stp nil -- stop
		#str "cii" -- store at level p
		#trc nil -- truncate
		#ujc nil -- error in case statement
		#ujp "__l" -- unconditional jump
		#uni nil -- set union
		#xjp "__l" -- indexed jump
	) ->:ar;
	Dictionary new ->oprTypeDict;
	0 until: ar size by: 2, do: 
		[:i oprTypeDict at: (ar at: i) put: (ar at: i + 1)]
**Pascal.Loader >> getInt 
	reader skipSpace;
	reader skipNumber!
**Pascal.Loader >> getLabel
	reader skipSpace;
	reader nextChar <> 'l' ifTrue: [self error: "missing l"];
	reader skipChar;
	self getInt ->:lab;
	labelDict at: lab ifAbsentPut: [Array new] ->lab;
	lab kindOf?: Integer, 
		ifTrue: [lab]
		ifFalse: 
			[lab addLast: inst;
			0]!
**Pascal.Loader >> defLabel
	self getInt ->:lab;
	reader nextChar = '='
		ifTrue: 
			[reader skipChar;
			self getInt]
		ifFalse: [pc] ->:value;
	labelDict includesKey?: lab, 
		ifTrue: [labelDict at: lab, do: [:i i q: value]];
	labelDict at: lab put: value

**Pascal.Loader >> parseOpr: typeArg
	typeArg first = 'c' ifTrue: [inst ch: reader skipChar];
	
	typeArg at: 1, = 'i' ifTrue: [inst p: self getInt];
	typeArg at: 2 ->:ch, = 'i' ifTrue: [inst q: self getInt];
	ch = 'l' ifTrue: [inst q: self getLabel]

**instruction oriented operand parsers.
***Pascal.Loader >> parse.compare
	reader skipChar ->:ch;
	inst ch: ch;
	ch = 'm' ifTrue: [inst q: self getInt]
***Pascal.Loader >> parse.csp
	inst q: ("stdproc." + reader getToken) asSymbol
***Pascal.Loader >> parse.lca
	reader getRest ->:str;
	self assert: str first = '\'' & (str last = '\'');
	
	str size - 2 ->:sz;
	np - sz ->np;
	np < 0 ifTrue: [self error: "insufficient store"];
	inst q: np;
	sz timesDo: [:i store at: np + i put: (str at: i + 1)]
***Pascal.Loader >> parse.ldc
	reader skipChar ->:ch;
	inst ch: ch;
	ch = 'i' ifTrue: [inst q: self getInt!];
	ch = 'r' ifTrue: 
		[reader skipSpace;
		inst q: reader skipNumber!];
	ch = 'b' ifTrue: [inst q: self getInt = 1!];
	ch = '(' ifTrue:
		[Set new ->:set;
		[reader nextChar <> ')'] whileTrue: [set add: self getInt];
		inst q: set!];
	ch = 'c' ifTrue: 
		[reader getToken ->:cstr, empty? 
			ifTrue: [inst q: '\''] -- ''' specified
			ifFalse: [inst q: cstr first]!];
	-- nil, 0x3fffffff as ShortInteger max
	ch = 'n' ifTrue: [inst q: 1073741823!]; 
	self assertFailed

**Pascal.Loader >> parseInst
	Pascal.Inst new ->inst;
	reader resetToken;
	3 timesRepeat: [reader getChar];
	reader token asSymbol ->:opcode;
	inst opcode: opcode;
	
	oprTypeDict at: opcode ->:type, notNil? ifTrue:
		[type kindOf?: Symbol, 
			ifTrue: [self perform: type]
			ifFalse: [self parseOpr: type]];
	code at: pc put: inst;
	pc + 1 ->pc
**Pascal.Loader >> parseLine: lnArg
	Pascal.AheadReader new init: lnArg ->reader;
	reader skipChar ->:ch, = 'l' ifTrue: [self defLabel!];
	ch = 'i' ifTrue: [self!];
	ch = 'q' ifTrue: 
		[codesize nil? ifTrue: [pc ->codesize];
		0 ->pc!];
	ch = ' ' ifTrue: [self parseInst!];
	self assertFailed
**Pascal.Loader >> load: p4Arg
	pascal verbose? ifTrue: 
		[Out put: "*load ";
		p4Arg kindOf?: File, 
			ifTrue: [Out put: p4Arg] 
			ifFalse: [Out put: "#Pascal.pcom"];
		Out putLn];
	Dictionary new ->labelDict;
	
	3 ->pc;
	p4Arg contentLinesDo: [:ln self parseLine: ln];
	pascal np: np;

	pascal verbose? ifTrue: [
		Out putLn: "*done codesize: " + codesize + " np: " + np]

*driver.@
	Object addSubclass: #Cmd.pascal instanceVars: "option"
**Cmd.pascal >> createPascal
	20000 ->:codeSize;
	30000 ->:storeSize;
	option at: 'p' ->:opt, notNil? ifTrue: [opt asInteger ->codeSize];
	option at: 's' ->opt, notNil? ifTrue: [opt asInteger ->storeSize];
	Pascal new initCodeSize: codeSize storeSize: storeSize 
		verbose: (option at: 'v')!
**Cmd.pascal >> pcom
	option at: 'C' ->:opt, notNil? ifTrue: [opt asFile!];
	Mulk includesKey?: #Pascal.pcom, ifTrue:
		[StringReader new init: (Mulk at: #Pascal.pcom)!];
	"pcom.p4" asSystemFile!
**Cmd.pascal >> compile: srcFileArg
	srcFileArg + ".." + (srcFileArg baseName + ".p4") ->:result;
	self createPascal ->:pascal;
	Pascal.Loader new init: pascal, load: self pcom;
	pascal file8: result;
	srcFileArg pipe: [pascal run ->:state?] to: Out;
	state? ifFalse: 
		[result remove;
		nil ->result];
	result!
**Cmd.pascal >> run: p4FileArg
	self createPascal ->:pascal;
	Pascal.Loader new init: pascal ->:loader, load: p4FileArg;

	option at: 'r' ->:opt, notNil? ifTrue: [pascal file7: opt asFile];
	option at: 'w' ->opt, notNil? ifTrue: [pascal file8: opt asFile];
	pascal run
**Cmd.pascal >> main: args
	OptionParser new init: "r:w:p:s:cC:v" ->option, parse: args ->args;

	args first asFile ->:file;
	file suffix = "pas" ifTrue: 
		[self compile: file ->file, nil? ifTrue: [self!]];
		
	option at: 'c', ifFalse: [self run: file]
	
