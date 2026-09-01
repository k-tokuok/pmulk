debugger
$Id: mulk debug.m 1518 2026-01-11 Sun 18:35:02 kt $
#ja デバッガ

*[man]
**#en
.caption SYNOPSIS
	debug [-v] COMMAND -- Run debug COMMAND.
	debug.l CLASS SELECTOR -- Show bytecode list.
	debug.b [CLASS SELECTOR [POS]] -- Set/display breakpoint.
	debug.r [NO] -- Remove breakpoint.
	
.caption DESCRIPTION
Simple bytecode level debugger.

If started with a breakpoint set, it stops when the breakpoint is reached and displays a "debug>" prompt.

You can use the following commands.

	! COMMAND -- Execute COMMAND.
	@ EXPR -- Evaluate EXPR in the current frame.
	b [CLASS SELECTOR] [POS] -- Set/display breakpoints.
	c -- Continue execution.
	e -- Exit current frame and step out to the caller frame.
	f [NO] -- Select a frame and display its contents.
	l [CLASS SELECTOR] -- Display bytecode list.
	n -- Step over to the next instruction in the current method.
	q -- Exit.
	r [NO] -- Remove the breakpoint.
	s -- Step to the next instruction
	w -- Show then call sequence.

When evaluating frame with the @ command, the at: and at:put: methods can be used to reference and manipulate the evaluation stack (negative numbers are specified) and the contents of method variables.

If CLASS/SELECTOR is omitted in the b/l command, the current method is targeted.

If the b command is executed without arguments, a list of breakpoints is displayed.

When the r command is executed without arguments, all breakpoints are removed.

.caption OPTION
	v -- Show the debugger log.

**#ja
.caption 書式
	debug [-v] COMMAND -- COMMANDをデバッガ下で実行する。
	debug.l CLASS SELECTOR -- バイトコードリストの表示。
	debug.b [CLASS SELECTOR [POS]] -- ブレークポイントの設定/表示。
	debug.r [NO] -- ブレークポイントの削除。
	
.caption 説明
バイトコードレベルの簡易デバッガ。

ブレークポイントを設定して実行すると、ブレークポイントの位置で停止し"debug>"プロンプトを表示する。

以下のコマンドが使用可能。

	! COMMAND -- COMMANDを実行する。
	@ EXPR -- 現在のフレームでEXPRを評価する。
	b [CLASS SELECTOR] [POS] -- ブレークポイントの設定/表示。
	c -- 実行を継続。
	e -- 現在のフレームを終了し、呼び出したフレームまで進める (step out)。
	f [NO] -- フレームを選択し、内容を表示。
	l [CLASS SELECTOR] -- バイトコードリストを表示。
	n -- 現メソッドの次の命令まで進める (step over)。
	q -- 終了する。
	r [NO] -- ブレークポイントの削除
	s -- 次の命令まで進める (step in)。
	w -- 呼び出し系列の表示。

@コマンドでフレームを評価する際、at:, at:put:メソッドで評価スタック(負数を指定)及びメソッド変数の内容を参照、操作出来る。

b/lコマンドでCLASS/SELECTORを省略した場合は現在のメソッドが対象となる。

bコマンドを引数無しで実行するとブレークポイントの一覧が表示される。

rコマンドを引数無しで実行すると全てのブレークポイントが削除される。

.caption オプション
	v -- デバッガの動作ログを表示する。

*import.@
	Mulk import: #("repl" "optparse")

*kernel overwrite.
**Block.
***Block >> context
	context!
***Block >> start
	start!
	
**Process >> fp
	fp!

**Method.
***Method >> extTempSize
	attr >> 4 & 0xff!
***Method >> contextSize
	attr >> 12 & 0xff!
***Method >> primCode
	attr >> 20!
***Method >> primitive?
	self primCode <> 0x3ff {METHOD_MAX_PRIM}!
***Method >> primName
	self primCode ->:code;
	code < 0x200 {METHOD_INSTANCE_VAR_GETTER} ifTrue:
		[MethodCompiler.primitiveTable keysAndValuesDo:
			[:k :v
			v = code ifTrue: [k!]]];
	code < 0x300 {METHOD_INSTANCE_VAR_SETTER} ifTrue:
		["getInstanceVar " + (code - 0x200)!];
	"setInstanceVar " + (code - 0x300)!
***Method >> literalSize
	self basicSize - 4!
***Method >> literalAt: ix
	self basicAt: ix + 4!
***Method >> bytecodeStart
	self literalSize * Kernel ptrByteSize!
***Method >> varName: ix
	ix = 0 ifTrue: ["self"!];
	ix - 1 ->ix;
	ix < self nargs ifTrue: ["a" + ix!];
	"t" + (ix - self nargs)!
***Method >> nvars
	self contextSize ->:result, = 0 ifTrue:
		[self nargs + 1 + self extTempSize ->result];
	result!

**AbstractContext >> method
	method!

**Context.
***Context >> sp
	sp!
***Context >> varAt: ixArg put: valueArg
	self basicAt: ixArg + 1 put: valueArg
	
**StackContext >> varAt: ixArg put: valueArg
	process stack at: fp + ixArg put: valueArg

*Debug.GlobalObjectDict.class.@
	Object addSubclass: #Debug.GlobalObjectDict.class instanceVars: "dict"
**Debug.GlobalObjectDict.class >> init
	Dictionary new ->dict;
	#(Nil Boolean Number String Class) ->:avoid;
	Mulk keysAndValuesDo:
		[:k :v
		avoid anySatisfy?: [:c v kindOf?: c], ifFalse: [dict at: v put: k]]
**Debug.GlobalObjectDict.class >> explain: arg
	dict at: arg ifAbsent: [arg describe!], asString!
	
**@
	Mulk at: #Debug.GlobalObjectDict put: Debug.GlobalObjectDict.class new
	
*Debug.Inst class.@
	Object addSubclass: #Debug.Inst instanceVars: 
		"method pos code size opr1 opr2 lopr"
**accessing.
***Debug.Inst >> method
	method!
***Debug.Inst >> pos
	pos!
***Debug.Inst >> code
	code!
***Debug.Inst >> opr1
	opr1!
***Debug.Inst >> opr2
	opr2!
***Debug.Inst >> lopr
	lopr!
***Debug.Inst >> size
	size!
***Debug.Inst >> pushLiteral?
	code = #pushLiteral | (code = #pushLiteralShort) 
		| (code = #pushCommonLiteral)!
***Debug.Inst >> send?
	code = #send | (code = #sendSuper) | (code = #send0Short) 
		| (code = #send1Short) | (code = #sendCommon)!
	
**Debug.Inst >> decodeOpcode
	method bytecodeAt: pos ->:byte;
	byte >> 4 ->:hi;
	byte & 0xf ->:lo;
	1 ->size;
	hi = 0 ifTrue:
		[#( #pushInstanceVar #pushContextVar #pushTempVar #pushLiteral
			#setInstanceVar #setContextVar #setTempVar #branchBackward
			#drop #exit #return #dup) at: lo ->code;
		lo <= 7 ifTrue:
			[method bytecodeAt: pos + 1 ->opr1;
			2 ->size]!];
	hi = 4 ifTrue:
		[#(	#branchForward #branchTrueForward #branchFalseForward #startTimesDo
			#timesDo #break) at: lo ->code;
		lo <= 2 ifTrue:
			[method bytecodeAt: pos + 1 ->opr1;
			2 ->size];
		lo = 4 ifTrue:
			[method bytecodeAt: pos + 1 ->opr1;
			method bytecodeAt: pos + 2 ->opr2;
			3 ->size]!];
	#(	nil #send #sendSuper #block nil #pushInstanceVarShort
		#pushContextVarShort #pushTempVarShort #pushLiteralShort
		#setInstanceVarShort #setContextVarShort #setTempVarShort
		#send0Short #send1Short #sendCommon #pushCommonLiteral) at: hi ->code;
	lo ->opr1;
	hi <= 3 ifTrue:
		[method bytecodeAt: pos + 1 ->opr2;
		2 ->size]
**Debug.Inst >> decodePushCommonLiteral
	--refer MethodCompiler.CG >> genPushLiteral:
	#(0 1 2 -1 nil true false) at: opr1 ->lopr;
	nil ->opr1
**Debug.Inst >> decodeSendCommon
	--refer MethodCompiler.CG >> genSend:narg:
	#(#= #+ #< #nil? #notNil? #_inc #at: #value: #at:put: #byteAt:) at: opr1
		->lopr;
	#(1 1 1 0 0 0 1 1 2 1) at: opr1 ->opr1
**Debug.Inst >> decodeOperand
	#(#pushContextVar #pushTempVar #setContextVar #setTempVar
		#pushContextVarShort #pushTempVarShort #setContextVarShort
		#setTempVarShort) includes?: code, 
		ifTrue: [method varName: opr1 ->opr1!];
	#(#pushInstanceVar #setInstanceVar #pushInstanceVarShort 
		#setInstanceVarShort) includes?: code, 
		ifTrue: [method belongClass allInstanceVars at: opr1 ->opr1!];
	code = #pushLiteral | (code = #pushLiteralShort) ifTrue:
		[method literalAt: opr1 ->lopr;
		nil ->opr1!];
	code = #send | (code = #sendSuper) ifTrue:
		[method literalAt: opr2 ->lopr;
		nil ->opr2!];
	code = #send0Short | (code = #send1Short) ifTrue:
		[method literalAt: opr1 ->lopr;
		code = #send0Short ifTrue: [0] ifFalse: [1] ->opr1!];
	code = #pushCommonLiteral ifTrue: [self decodePushCommonLiteral!];
	code = #sendCommon ifTrue: [self decodeSendCommon!];
	code = #branchBackward ifTrue: [pos + size - opr1 ->opr1!];
	#(#branchForward #branchTrueForward #branchFalseForward) includes?: code,
		ifTrue: [pos + size + opr1 ->opr1!];
	code = #block | (code = #timesDo) ifTrue: [pos + size + opr2 ->opr2!]

**Debug.Inst >> = objectArg
	objectArg kindOf?: Debug.Inst, ifFalse: [false!];
	self hash <> objectArg hash ifTrue: [false!];
	objectArg method ->:m;
	method belongClass name = m belongClass name,
		and: [method selector = m selector],
		and: [pos = objectArg pos]!
**Debug.Inst >> initMethod: methodArg pos: posArg
	methodArg ->method;
	posArg ->pos;
	self decodeOpcode;
	self decodeOperand;
	self hash: method belongClass name hash ^ method selector hash 
		^ (pos & 0xfffff)
		
**Debug.Inst >> explain
	StringWriter new ->:wr;
	wr put: pos, put: ' ', put: code;
	opr1 notNil? ifTrue: [wr put: ' ', put: opr1];
	opr2 notNil? ifTrue: [wr put: ',', put: opr2];

	self pushLiteral? 
		ifTrue: [wr put: ' ', put: (Debug.GlobalObjectDict explain: lopr)];
	self send? ifTrue: [wr put: ',', put: lopr describe];
	wr asString!

**Method >> dump
	self primitive? ifTrue: 
		[Out putLn: "primitive: " + self primName];
	0 ->:p;
	[p < bytecodeSize] whileTrue:
		[Debug.Inst new initMethod: self pos: p ->:i;
		Out putLn: i explain;
		p + i size ->p]
	
*Debug.Frame class.@
	Object addSubclass: #Debug.Frame 
		instanceVars: "process method context fp sp ip inst"
**accessing.
***Debug.Frame >> method
	method!
***Debug.Frame >> context
	context!
***Debug.Frame >> ip
	ip!
***Debug.Frame >> fp
	fp!
		
**Debug.Frame >> init: processArg pos: pos
	processArg ->process;
	process stack ->:stack;
	stack at: pos - 1, kindOf?: Context, ifTrue: [pos - 1 ->pos]; {marker}
	stack at: pos - 1 ->ip;
	stack at: pos - 2 ->fp;
	stack at: pos - 3 ->method;
	pos - 3 ->sp;
	method kindOf?: Method, 
		ifTrue: 
			[StackContext new initMethod: method process: process 
				fp: fp ->context]
		ifFalse: 
			[method ->context;
			context method ->method];
	ip - method bytecodeStart ->ip
**Debug.Frame >> instAt: pos
	Debug.Inst new initMethod: method pos: pos!
**Debug.Frame >> inst
	inst nil? ifTrue: [self instAt: ip ->inst];
	inst!
**Debug.Frame >> dump
	Out putLn: method;
	Out putLn: inst explain;
	Out putLn: "---context";
	method nvars timesDo:
		[:i
		Out put: i, put: ' ', put: (method varName: i), put: ' ',
			putLn: (context varAt: i) describe];
	Out putLn: "---stack";
	fp ->:sp0;
	context kindOf?: StackContext, ifTrue: [sp0 + method nvars ->sp0];
	sp0 until: sp, do:
		[:i2
		Out put: i2 - sp, put: ' ', putLn: (process stack at: i2) describe]
**Debug.Frame >> upFrame
	Debug.Frame new init: process pos: fp!
**Debug.Frame >> adjustReturnPos
	ip - 1 ->ip;
	process stack at: sp + 2 put: ip + method bytecodeStart
**Debug.Frame >> at: pos
	pos negative? 
		ifTrue: [process stack at: sp + pos]
		ifFalse: [context varAt: pos]!
**Debug.Frame >> at: pos put: value
	pos negative?
		ifTrue: [process stack at: sp + pos put: value]
		ifFalse: [context varAt: pos put: value]
**Debug.Frame >> debugUses?: m
	m = (GlobalVar methodOf: #get) ifTrue: [true!];
	m belongClass = Writer ifTrue: [true!];
	false!
**Debug.Frame >> stepSendInst
	self at: inst opr1 negated - 1 ->:r;
	r class ->:rc;
	inst code = #sendSuper ifTrue: [rc superclass ->rc];
	inst lopr ->:sel;	
	rc findPerformMethod: sel ->:m;
	(rc = Block) & ((sel = #value) | (sel = #value:) | (sel = #value:value:)
			| (sel = #value:value:value:) | (sel = #valueArgs:)) ifTrue:
		[r context method ->:bm;
		Debug.Inst new initMethod: bm pos: r start - bm bytecodeStart!];
	self debugUses?: m, or: [m primitive?], 
		ifTrue: [self instAt: ip + inst size!];
	Debug.Inst new initMethod: m pos: 0!
**Debug.Frame >> exitInst
	inst code = #exit | (context kindOf?: StackContext)
		ifTrue: [self upFrame]
		ifFalse: [Debug.Frame new init: process pos: context sp],
		inst!
**Debug.Frame >> stepInst
	inst code ->:c;
	c = #branchBackward, | (c = #branchForward) ifTrue: 
		[self instAt: inst opr1!];
	c = #branchTrueForward, | (c = #branchFalseForward) 
		and: [self at: -1, = (c = #branchTrueForward)],
		ifTrue: [self instAt: inst opr1!];
	inst send? ifTrue: [self stepSendInst!];
	c = #return | (c = #exit) ifTrue: [self exitInst!];
	c = #block ifTrue: [self instAt: inst opr2!];
	c = #timesDo ifTrue:
		[self at: -1, >= (self at: -2) ifTrue: 
			[self instAt: inst opr2!]];
	self instAt: ip + inst size!
**Debug.Frame >> nextInst
	inst send? ifTrue: [self instAt: ip + inst size!];
	self stepInst!

*Debug.Breakpoint class.@
	Object addSubclass: #Debug.Breakpoint instanceVars:
		"debug type inst prevbc enable?"
**Debug.Breakpoint >> init: debugArg type: typeArg inst: instArg
	debugArg ->debug;
	typeArg ->type;
	instArg ->inst;
	false ->enable?
**Debug.Breakpoint >> printOn: arg
	super printOn: arg;
	arg put: '(', put: type, put:' ', put: inst method, put: '#', 
		put: inst pos, put: ')'

**accessing.
***Debug.Breakpoint >> type
	type! {#user #stop #internal}
***Debug.Breakpoint >> inst
	inst!
***Debug.Breakpoint >> enable?
	enable?!

**Debug.Breakpoint >> reinit
	inst method ->:m;
	debug findMethodInClass: m belongClass name selector: m selector ->m;
	Debug.Inst new initMethod: m pos: inst pos ->inst
**Debug.Breakpoint >> enable
	enable? ifTrue: [self!];
	debug log: "enable " + self;
	inst method ->:m;
	inst pos ->:p;
	m bytecodeAt: p ->prevbc;
	m bytecodeAt: p put: 0x45 {break};
	true ->enable?
**Debug.Breakpoint >> disable
	enable? ifFalse: [self!];
	inst method bytecodeAt: inst pos put: prevbc;
	false ->enable?

*Debug.class class.@
	Object addSubclass: #Debug.class instanceVars:
		"verbose? process sp fpTop breakpoints reenableBreakpoint"
		+ " frames framePos lastFrame curMethod";
	Mulk addTransientGlobalVar: #Debug
**Debug.class >> init
	false ->verbose?;
	Array new ->breakpoints
**Debug.class >> verbose: arg
	verbose? ->:result;
	arg ->verbose?;
	result!
**Debug.class >> log: arg
	verbose? ifTrue: [Out putLn: arg]
**Debug.class >> findMethodInClass: classArg selector: selectorArg
	Mulk at: classArg ->:c;
	c methodOf: selectorArg ->:result;
	result nil? ifTrue: 
		[self error: classArg asString + " >> " + selectorArg + " not found"];
	result!
	
**breakpoints.
***Debug.class >> breakpointAt: instArg
	breakpoints detect: [:bp bp inst = instArg]!
***Debug.class >> createBreakpoint: typeArg inst: instArg
	Debug.Breakpoint new init: self type: typeArg inst: instArg ->:result;
	self breakpointAt: instArg, notNil? 
		ifTrue: [self error: "redefine " + result];
	breakpoints addLast: result;
	result!
***Debug.class >> removeBreakpoint: barg
	self log: "removeBreakpoint: " + barg;
	breakpoints remove: barg
***Debug.class >> breakpointList
	breakpoints size timesDo:
		[:i
		Out putLn: i asString + ' ' + (breakpoints at: i)]
***Debug.class >> cleanupBreakpoints
	Array new ->:newbps;
	breakpoints do: 
		[:b
		b disable;
		b type = #user ifTrue: [newbps addLast: b]];
	newbps ->breakpoints
***Debug.class >> removeBreakpointAt: posArg
	posArg nil? ifTrue:
		[[breakpoints empty?] whileFalse: [self removeBreakpointAt: 0]!];
	breakpoints at: posArg ->:bp;
	bp disable;
	reenableBreakpoint = bp ifTrue: [nil ->reenableBreakpoint];
	breakpoints removeAt: posArg
		
**Debug.class >> resume
	reenableBreakpoint notNil? ifTrue:
		[lastFrame stepInst ->:i;
		self breakpointAt: i, nil? ifTrue:
			[self createBreakpoint: #internal inst: i, enable]];
	self log: "resume debugee";
	process resumesp: sp

**Debug.class >> curFrame
	frames at: framePos!
		
**commands.
***Debug.class >> fence: blockArg
	blockArg on: Error do: 
		[:e
		verbose? ifTrue: [e printStackTrace];
		Out putLn: e message]
***Debug.class >> command.cmd: arg
	arg copyFrom: 1, runCmd
***Debug.class >> command.eval: arg
	self curFrame ->:f;
	f eval: (arg copyFrom: 1) ->:result;
	result <> f ifTrue: [Out putLn: result describe]
***Debug.class >> command.break: args
	args size ->:argc, = 0 ifTrue: [self breakpointList!];
	argc = 1 ifTrue:
		[self curFrame instAt: args first asInteger ->:inst];
	argc >= 2 ifTrue:
		[self findMethodInClass: args first asSymbol 
			selector: (args at: 1) asSymbol ->:m;
		argc = 3 ifTrue: [(args at: 2) asInteger] ifFalse: [0] ->:pos;
		Debug.Inst new initMethod: m pos: pos ->inst];
	self createBreakpoint: #user inst: inst, enable
***Debug.class >> command.where
	frames size ->:sz, timesDo:
		[:i
		sz - i - 1 ->i;
		Out putLn: i asString + ' ' + (frames at: i) context]
***Debug.class >> command.list: args
	args size = 2
		ifTrue:
			[self findMethodInClass: args first asSymbol 
				selector: (args at: 1) asSymbol]
		ifFalse: [self curFrame method] ->:m;
	breakpoints select: [:bp bp inst method = m & bp enable?], asArray ->:bps;
	bps do: [:bp2 bp2 disable];
	m dump;
	bps do: [:bp3 bp3 enable]
***Debug.class >> command.removebp: args
	self removeBreakpointAt: 
		(args empty? ifTrue: [nil] ifFalse: [args first asInteger])
***Debug.class >> command.frame: args
	args size = 1 ifTrue:
		[args first asInteger ->:nf, between: 0 until: frames size, ifFalse:
			[Out putLn: "illegal frame"!];
		nf ->framePos;
		self curFrame inst;
		self curFrame method ->curMethod];
	self curFrame dump
***Debug.class >> command: arg
	arg empty? ifTrue: [self!];
	arg first ->:ch;
	ch = '!' ifTrue: [self fence: [self command.cmd: arg]!];
	ch = '@' ifTrue: [self fence: [self command.eval: arg]!];

	arg split: ' ', asArray ->:args;
	args first size <> 1 ifTrue: [Out putLn: "?"!];
	args copyFrom: 1 ->args;
	
	ch = 'c' ifTrue: [self resume];
	ch = 'w' ifTrue: [self command.where!];
	ch = 's' | (ch = 'n') | (ch = 'e') ifTrue: 
		[ch = 's' ifTrue: [lastFrame stepInst ->:i];
		ch = 'n' ifTrue: [lastFrame nextInst ->i];
		ch = 'e' ifTrue: [self curFrame exitInst ->i];
		self breakpointAt: i, nil? ifTrue:
			[self createBreakpoint: #stop inst: i, enable];
		self resume];
	ch = 'q' ifTrue: [ExitException new signal];
	ch = 'f' ifTrue: [self command.frame: args!];
	ch = 'l' ifTrue: [self fence: [self command.list: args]!];
	ch = 'b' ifTrue: [self fence: [self command.break: args]!];
	ch = 'r' ifTrue: [self fence: [self command.removebp: args]!];
	Out putLn: "?"
***Debug.class >> commandLoop
	[Out put: "debug>";
	self command: In getLn] loop

**Debug.class >> breaksp: spArg
	self log: "break";
	spArg ->sp;
	Debug.Frame new init: process pos: spArg ->lastFrame;
	lastFrame adjustReturnPos;
	reenableBreakpoint notNil? ifTrue:
		[reenableBreakpoint enable;
		nil ->reenableBreakpoint];
	self breakpointAt: (lastFrame instAt: lastFrame ip) ->:b; 
		-- note. break inst
	b nil? ifTrue: [self error: "breakpoint not found"];
	b disable;
	b type = #user 
		ifTrue: [b ->reenableBreakpoint]
		ifFalse: [self removeBreakpoint: b];
	b type = #internal ifTrue: [self resume];
	
	--ToDo: unefficient to solve frames always?
	Array new ->frames;
	frames addLast: lastFrame;
	lastFrame ->:f;
	[f upFrame ->f, fp > fpTop] whileTrue: [frames addLast: f];
	0 ->framePos;
	lastFrame method ->:m, <> curMethod ifTrue:
		[m ->curMethod;
		Out putLn: m];
	Out putLn: lastFrame inst explain;
	self commandLoop
**Debug.class >> start: cmdstr
	Kernel currentProcess ->process;
	nil ->curMethod;
	nil ->reenableBreakpoint;
	process fp ->fpTop;
	breakpoints do: [:b b reinit, enable];
	self log: "start debugee";
	[cmdstr runCmd] finally:
		[self log: "end debugee";
		self cleanupBreakpoints]
	
**construct.@
	Debug.class new ->Debug
**Process >> breaksp: spArg
	Debug breaksp: spArg

*driver.@
	Object addSubclass: #Cmd.debug instanceVars: "iv"
**Cmd.debug >> main.l: args
	Debug findMethodInClass: args first asSymbol 
		selector: (args at: 1) asSymbol, dump
**Cmd.debug >> main.b: args
	args empty? ifTrue: [Debug breakpointList!];
	args size = 3 ifTrue: [args at: 2, asInteger] ifFalse: [0] ->:pos;
	Debug findMethodInClass: args first asSymbol 
		selector: (args at: 1) asSymbol ->:m;
	Debug.Inst new initMethod: m pos: pos ->:i;
	Debug createBreakpoint: #user inst: i
**Cmd.debug >> main.r: args
	args empty? ifTrue: [nil] ifFalse: [args first asInteger] ->:arg;
	Debug removeBreakpointAt: arg
**Cmd.debug >> main: args
	OptionParser new init: "v" ->:op, parse: args ->args;
	Debug verbose: (op at: 'v') ->:save;
	Debug start: args asString;
	Debug verbose: save
