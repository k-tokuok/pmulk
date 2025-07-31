basic interpreter
$Id: mulk/basic basic.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption SYNOPSIS
	basic [option] source
.caption DESCRIPTION
Execute source program as classic Microsoft BASIC compatible.
.lineBreak
Statements:
	cls
	def
	dim
	end
	for to step - next
	gosub - return
	goto
	if then (else)
	input
	let
	locate
	on goto
	on gosub
	print (using)
	read - data - restore
	rem
	run
	stop
	while - wend
Functions:
	abs
	asc
	atn
	chr$
	cos
	exp
	int
	inkey$ (no argument)
	left$
	len
	log
	mid$
	not
	right$
	rnd
	sgn
	sin
	spc (print only)
	sqr
	str$
	tan
	tab (print only)
	time$
	val
Operators:
	(unary) -
	^
	*, /
	+, -
	=, <, >, <>, <=, >=
	and
	or
Stubs:
	beep
	key
	randomize
	sound
	
The variable length is up to 2 characters by default.

String input is converted as caps-on by default.
.caption OPTION
	i -- implicitly declare an array
	f -- can break the for loop
	s -- show stack trace if error occur
	c -- caps-off for string input
	l -- variable with long name
	w -- words must be separated by spaces
.caption LIMITATION
Some functions require screen control.
.caption SEE ALSO
.summary sconsole

*imports.@
	Mulk import: #("prompt" "random" "math" "console")
	
*Basic.Line class.@
	Object addSubclass: #Basic.Line instanceVars: "ring no text"
**Basic.Line >> initNo: noArg text: textArg
	noArg ->no;
	textArg ->text
**Basic.Line >> text
	text!
**Basic.Line >> no
	no!
**Basic.Line >> addNextOf: ringArg
	ringArg addNext: self;
	ringArg next ->ring
**Basic.Line >> next
	ring next value!
	
*Basic.Ptr class.@
	-- point to Line
	Object addSubclass: #Basic.Ptr instanceVars: 
		"basic line text pos nextChar tokenWriter tokenValue ungetToken"
**Basic.Ptr >> init: basicArg
	basicArg ->basic
**Basic.Ptr >> line: lineArg pos: posArg
	lineArg ->line;
	line text ->text;
	posArg ->pos;
	text at: pos ->nextChar;
	nil ->ungetToken
**Basic.Ptr >> line: lineArg
	self line: lineArg pos: 0
**Basic.Ptr >> line
	line!
**Basic.Ptr >> no
	line no!
**Basic.Ptr >> pos
	pos!
**Basic.Ptr >> copy
	Basic.Ptr new init: basic, line: line pos: pos!
	
**Basic.Ptr >> skip
	pos + 1 ->pos;
	pos < text size ifTrue: [text at: pos] ifFalse: [nil] ->nextChar
**Basic.Ptr >> skipSpace
	[nextChar = ' '] whileTrue: [self skip]
	
**Basic.Ptr >> startToken
	StringWriter new ->tokenWriter
**Basic.Ptr >> get
	tokenWriter put: nextChar;
	self skip
**Basic.Ptr >> digit?
	nextChar notNil? and: [nextChar digit?]!
**Basic.Ptr >> getDigits
	[self digit?] whileTrue: [self get]
**Basic.Ptr >> getNumber
	self startToken;
	nextChar digit?
		ifTrue: [self getDigits]
		ifFalse: [tokenWriter put: '0'];
	nextChar = '.' ->:fraction?, ifTrue:
		[self get;
		self digit?
			ifTrue: [self getDigits]
			ifFalse: [tokenWriter put: '0']];
	nextChar = 'e' | (nextChar = 'E') ifTrue:
		[fraction? ifFalse: [tokenWriter put: ".0"];
		self skip;
		tokenWriter put: 'e';
		nextChar ->:ch, = '-'
			ifTrue: [self get]
			ifFalse: [ch = '+' ifTrue: [self skip]];
		self getDigits];
	nextChar = '!' ifTrue: [self skip];
	tokenWriter asString asNumber ->tokenValue
	
**Basic.Ptr >> identifierLeadChar?
	nextChar nil? ifTrue: [false!];
	nextChar alpha?!
**Basic.Ptr >> identifierTrailChar?
	nextChar nil? ifTrue: [false!];
	nextChar alpha? or: [nextChar digit?]!
**Basic.Ptr >> getIdentifier
	self startToken;
	[self identifierTrailChar?] whileTrue: [self get];
	nextChar = '$' ifTrue: [self get];
	tokenWriter asString lower ->tokenValue
**Basic.Ptr >> splitIdentifierAt: posArg
	tokenValue size = posArg ifTrue: [self!];
	pos - tokenValue size + posArg - 1 ->pos;
	self skip;
	tokenValue copyUntil: posArg ->tokenValue
**Basic.Ptr >> splitIdentifierAndKeyword
	tokenValue size ->:sz;
	sz > 3 ifTrue:
		[tokenValue indexOfSubstring: "then" ->:p, notNil? ifTrue:
			[self splitIdentifierAt: p!];
		tokenValue indexOfSubstring: "goto" ->p, notNil? ifTrue:
			[self splitIdentifierAt: p!];
		basic longVar? ifFalse:
			[self error: "too long identifier " + tokenValue]]
**Basic.Ptr >> getString
	self skip; -- "
	self startToken;
	[nextChar <> '"'] whileTrue: 
		[nextChar nil? ifTrue: [self error: "missing double quote"];
		self get];
	tokenWriter asString ->tokenValue;
	self skip
	
**Basic.Ptr >> tokenValue
	tokenValue!
	
**Basic.Ptr >> ungetToken: tkArg
	self assert: ungetToken nil?;
	tkArg ->ungetToken

**Basic.Ptr >> getToken
	ungetToken notNil? ifTrue:
		[ungetToken ->:result;
		nil ->ungetToken;
		result!];
		
	self skipSpace;
	nextChar nil? ifTrue: [#eol!];
	
	nextChar = '<' ifTrue:
		[self skip;
		nextChar = '=' ifTrue: 
			[self skip;
			#<=!];
		nextChar = '>' ifTrue:
			[self skip;
			#<>!];
		'<'!];
		
	nextChar = '>' ifTrue:
		[self skip;
		nextChar = '=' ifTrue:
			[self skip;
			#>=!];
		'>'!];
	
	#('+' '-' '*' '/' '(' ')' '=' ':' ';' ',' '^') includes?: nextChar, 
		ifTrue:
			[nextChar ->result;
			self skip;
			result!];
			
	nextChar = '\'' ifTrue:
		[self skip;
		#rem!];
		
	self digit? | (nextChar = '.') ifTrue:
		[self getNumber;
		tokenValue kindOf?: Integer, ifTrue: [#integer] ifFalse: [#float]!];
		
	self identifierLeadChar? ifTrue:
		[self getIdentifier;
		#(	"abs" "and" "asc" "atn" "beep" "chr$" "cls" "cos" 
			"data" "def" "dim" "else" "end" "exp" "for" 
			"gosub" "goto" "if" "inkey$" "input" "int" "key"
			"left$" "len" "let" "locate" "log" "mid$"
			"next" "not" "on" "or" "print" 
			"randomize" "read" "rem" "restore" "return" "right$" "rnd" "run"
			"sgn" "sin" "spc" "sqr" "step" "stop" "str$" "sound"
			"tab" "tan" "then" "time$" "to" "using" "val" "wend" "while")
			->:keywords;
		basic wordSplitBySpace?
			ifTrue:
				[keywords includes?: tokenValue, 
					ifTrue: [tokenValue asSymbol]
					ifFalse: [#identifier]!]
			ifFalse:
				[keywords do:
					[:kw
					tokenValue heads?: kw, ifTrue:
						[self splitIdentifierAt: kw size;
						tokenValue asSymbol!]];
				self splitIdentifierAndKeyword;
				#identifier!]];
		
	nextChar = '"' ifTrue:
		[self getString;
		#string!];
	
	self error: "illegal token"
**Basic.Ptr >> getToken: requireArg
	self getToken <> requireArg ifTrue: [self error: "require " + requireArg]
**Basic.Ptr >> peepToken
	self getToken ->:result;
	self ungetToken: result;
	result!
	
**Basic.Ptr >> getDataString
	self skipSpace;
	nextChar = '"' 
		ifTrue: [self getString]
		ifFalse:
			[self startToken;
			[nextChar notNil? and: [nextChar <> ',']] whileTrue:
				[self get];
			tokenWriter asString ->tokenValue];
	tokenValue!
**Basic.Ptr >> getDataNumber
	self skipSpace;
	nextChar = '-' 
		ifTrue: [self skip; true]
		ifFalse: [false] ->:negative?;
	self getToken ->:tk, = #integer | (tk = #float) ifTrue:
		[self tokenValue ->:result;
		negative? ifTrue: [result negated ->result];
		result!];
	self error: "illegal data"
		
*Basic.Array class.@
	Object addSubclass: #Basic.Array instanceVars: "varName sizes values"
**Basic.Array >> init: varNameArg sizes: sizesArg
	varNameArg ->varName;
	sizesArg ->sizes;
	sizes inject: 1 into: [:x :y x * (y + 1)] ->:size;
	varName last = '$' ifTrue: [""] ifFalse: [0] ->:ival;
	FixedArray basicNew: size, fill: ival ->values
**Basic.Array >> pos: posesArg
	0 ->:result;
	sizes size timesDo:
		[:i
		sizes at: i ->:s;
		i <> 0 ifTrue: [result * (s + 1) ->result];
		posesArg at: i ->:p;
		p between: 0 and: s, ifFalse: [self error: "subscript out of range"];
		result + p ->result];
	result!
**Basic.Array >> at: posesArg
	values at: (self pos: posesArg)!
**Basic.Array >> at: posesArg put: valueArg
	values at: (self pos: posesArg) put: valueArg

*Basic.func class.@
	Object addSubclass: #Basic.Func instanceVars: "varName ptr"
**Basic.Func >> initVarName: varNameArg ptr: ptrArg
	varNameArg ->varName;
	ptrArg ->ptr
**Basic.Func >> varName
	varName!
**Basic.Func >> ptr
	ptr!
	
*Basic.For class.@
	Object addSubclass: #Basic.For instanceVars: "varName to step ptr"
**Basic.For >> initVarName: varNameArg to: toArg step: stepArg ptr: ptrArg
	varNameArg ->varName;
	toArg ->to;
	stepArg ->step;
	ptrArg ->ptr
**Basic.For >> varName
	varName!
**Basic.For >> to
	to!
**Basic.For >> step
	step!
**Basic.For >> ptr
	ptr!

*Basic.FloatWriter class.@
	FloatWriter addSubclass: #Basic.FloatWriter
**Basic.FloatWriter >> put: valueArg intWidth: iw fracWidth: fw to: writerArg
	self mantWidth: fw + fw;
	self value: valueArg;
	writerArg ->writer;

	iw ->remain;
	self putSign;
	exp + 1 > remain, ifTrue:
		[writer put: '#' times: iw;
		fw > 0 ifTrue: [writer put: '.', put: '#' times: fw]!];
	writer putSpaces: remain - (exp >= 0 ifTrue: [exp + 1] ifFalse: [1]);
	negative? ifTrue: [writer put: '-'];
	exp >= 0
		ifTrue:
			[exp + 1 timesRepeat: [self putMant1];
			0 ->remain;
			fw <> 0 ifTrue:
				[writer put: '.';
				fw ->remain;
				self putMant]]
		ifFalse:
			[writer put: "0.";
			mant <> 0 ifTrue:
				[writer put: '0' times: (exp negated - 1 min: fw ->:w);
				fw - w ->remain;
				self putMant]];
	writer putSpaces: remain
	
*Basic.Using class.@
	Object addSubclass: #Basic.Using instanceVars: "reader intWidth fracWidth"
**Basic.Using >> countSharp
	0 ->:result;
	[reader nextChar = '#'] whileTrue: 
		[result + 1 ->result;
		reader skipChar];
	result!
**Basic.Using >> init: fmtArg
	AheadReader new init: fmtArg ->reader;
	self countSharp ->intWidth;
	0 ->fracWidth;
	reader nextChar = '.' ifTrue:
		[reader skipChar;
		self countSharp ->fracWidth]
**Basic.Using >> format: value
	StringWriter new ->:wr;
	Basic.FloatWriter new put: value intWidth: intWidth fracWidth: fracWidth
		to: wr;
	wr asString!
	
*Basic class.@
	Object addSubclass: #Basic instanceVars: 
		"implicitDeclareArray? breakFor? stackTrace? capsoff? longVar?"
		+ " wordSplitBySpace? screenControllable?"
		+ " verbose? lines ip dp varDict arrayVarDict forStack subStack xpos"
		+ " whileStack"
		+ " funcDict using"
**Basic >> init
	Ring new ->lines;
	false ->verbose?;
	false ->implicitDeclareArray?;
	false ->breakFor?;
	false ->stackTrace?;
	false ->capsoff?;
	false ->longVar?;
	false ->wordSplitBySpace?;
	Mulk at: #ScreenConsole ifAbsent: [nil] ->:sc;
	sc notNil? and: [Console kindOf?: sc] ->screenControllable?	
**Basic >> implicitDeclareArray
	true ->implicitDeclareArray?
**Basic >> breakFor
	true ->breakFor?
**Basic >> stackTrace
	true ->stackTrace?
**Basic >> capsoff
	true ->capsoff?
**Basic >> longVar
	true ->longVar?
**Basic >> longVar?
	longVar?!
**Basic >> wordSplitBySpace
	true ->wordSplitBySpace?
**Basic >> wordSplitBySpace?
	wordSplitBySpace?!
	
**verbose.
***Basic >> verbose
	true ->verbose?
***Basic >> vputLn: msg
	verbose? ifTrue: [Out putLn: msg]
	
**Basic >> insertLine: line
	lines prev ->:r;
	[r value ->:l, notNil?] whileTrue:
		[l no = line no ifTrue: [self error: "duplicate line " + line no];
		l no < line no ifTrue: [line addNextOf: r!];
		r prev ->r];
	line addNextOf: r
**Basic >> load: readerArg
	readerArg contentLinesDo:
		[:ln
		AheadReader new init: ln ->:rd;
		rd skipInteger ->:lno;
		rd skipSpace;
		self insertLine: (Basic.Line new initNo: lno text: rd getRest)]
**Basic >> list
	lines do:
		[:line
		Out putLn: line no asString + ' ' + line text]

**var.
***Basic >> arrayAt: consArg
	consArg car ->:name;
	arrayVarDict includesKey?: name, ifFalse:
		[implicitDeclareArray? ifTrue:
			[consArg cdr ->:subsc;
			FixedArray basicNew: subsc size, fill: 10 ->:sizes;
			Basic.Array new init: name sizes: sizes ->:result;
			arrayVarDict at: name put: result;
			result!];
		self error: "undefined array " + name];
	arrayVarDict at: name!
***Basic >> varAt: varArg
	varArg kindOf?: Cons, 
		ifTrue: [self arrayAt: varArg, at: varArg cdr]
		ifFalse: 
			[varDict at: varArg ifAbsentPut: 
				[varArg last = '$' ifTrue: [""] ifFalse: [0]]]!
***Basic >> varAt: varArg put: valueArg
	varArg kindOf?: Cons,
		ifTrue: [self arrayAt: varArg, at: varArg cdr put: valueArg]
		ifFalse: [varDict at: varArg put: valueArg]
***Basic >> stringVar?: varArg
	varArg kindOf?: Cons, ifTrue: [varArg car ->varArg];
	varArg last = '$'!
	
**eval.
***Basic >> parseParen: block
	ip getToken: '(';
	block value ->:result;
	ip getToken: ')';
	result!
***Basic >> parseSubscript
	Array new ->:result;
	ip getToken: '(';
	[result addLast: self eval asInteger;
	ip getToken ->:tk, = ','] whileTrue;
	tk <> ')' ifTrue: [self error: "require )"];
	result!
***Basic >> parseVar
	ip getToken: #identifier;
	ip tokenValue ->:result;
	ip peepToken = '(' ifTrue:
		[Cons new car: result cdr: self parseSubscript ->result];
	result!
***Basic >> evalFunc: funcArg
	funcArg varName ->:vn;
	self varAt: vn ->:savedValue;
	self varAt: vn put: (self parseParen: [self eval]);
	ip ->:savedIp;
	funcArg ptr copy ->ip;
	self eval ->:result;
	savedIp ->ip;
	self varAt: vn put: savedValue;
	result!
***Basic >> evalTime
	DateAndTime new initNow ->:t;
	StringWriter new ->:wr,
		put: (t hour asString0: 2),
		put: ':',
		put: (t minute asString0: 2),
		put: ':',
		put: (t second asString0: 2),
		asString!
***Basic >> evalPrimary
	ip getToken ->:tk, = '(' ifTrue:
		[self eval ->:result;
		ip getToken: ')';
		result!];
	tk = #string | (tk = #integer) | (tk = #float) ifTrue: [ip tokenValue!];
	
	tk = #inkey$ ifTrue: 
		[screenControllable?
			ifTrue:
				[Console hit?
					ifTrue: 
						[Console fetch ->:ch;
						capsoff? ifFalse: [ch upper ->ch];
						ch asString]
					ifFalse: [""]]
			ifFalse: [In getLn + '\n']!];
	tk = #time$ ifTrue: [self evalTime!];
	
	tk = #identifier ifTrue: 
		[ip tokenValue ->:id;
		funcDict at: id ifAbsent: [nil] ->:func, notNil?
			ifTrue:
				[self evalFunc: func]
			ifFalse:
				[ip ungetToken: tk;
				self varAt: self parseVar]!];
	
	--functions.
	tk = #abs ifTrue: [self parseParen: [self eval abs]!];
	tk = #asc ifTrue: [self parseParen: [self eval first code]!];
	tk = #atn ifTrue: [self parseParen: [self eval atan]!];
	tk = #chr$ ifTrue: 
		[self parseParen: [self eval asInteger asChar asString]!];
	tk = #cos ifTrue: [self parseParen: [self eval cos]!];
	tk = #exp ifTrue: [self parseParen: [self eval exp]!];
	tk = #int ifTrue: 
		[self parseParen: 
			[self eval ->:n;
			n < 0 ifTrue: [n - 1 ->n];
			n asInteger]!];
	tk = #left$ ifTrue: 
		[self parseParen:
			[self eval ->:s;
			ip getToken: ',';
			s copyUntil: (self eval asInteger min: s size)]!];
	tk = #len ifTrue: [self parseParen: [self eval size]!];
	tk = #log ifTrue: [self parseParen: [self eval log]!];
	tk = #mid$ ifTrue:
		[self parseParen:
			[self eval ->s;
			ip getToken: ',';
			self eval asInteger - 1 ->:st;
			ip peepToken = ','
				ifTrue:
					[ip getToken;
					self eval asInteger + st min: s size]
				ifFalse: [s size] ->:en;
			s copyFrom: st until: en]!];
	tk = #not ifTrue:
		[self parseParen: [self eval = 0 ifTrue: [-1] ifFalse: [0]]!];
	tk = #right$ ifTrue:
		[self parseParen:
			[self eval ->s;
			ip getToken: ',';
			s copyFrom: (s size - self eval asInteger max: 0)]!];
	tk = #rnd ifTrue: [self parseParen: [self eval; Random float]!];
	tk = #sgn ifTrue: 
		[self parseParen:
			[self eval ->n, = 0
				ifTrue: [0]
				ifFalse: [n < 0 ifTrue: [-1] ifFalse: [1]]]!];
	tk = #sin ifTrue: [self parseParen: [self eval sin]!];
	tk = #sqr ifTrue: [self parseParen: [self eval sqrt]!];
	tk = #str$ ifTrue: [self parseParen: [self eval asString]!];
	tk = #tan ifTrue: [self parseParen: [self eval tan]!];
	tk = #val ifTrue: 
		[self parseParen: 
			[[self eval asNumber] on: Error do: [:e 0]]!];
		
	self error: "evalPrimary: illegal token " + tk
***Basic >> evalUnary
	ip getToken ->:tk, = '-' ifTrue: [self evalUnary negated!];
	ip ungetToken: tk;
	self evalPrimary!
***Basic >> pow: x with: y
	y >= 0 & (y asInteger = y) ifTrue:
		[1 ->:result;
		y timesRepeat: [result * x ->result];
		result!];
	x pow: y!
***Basic >> evalPow
	self evalUnary ->:result;
	[ip getToken ->:tk, = '^'] whileTrue: 
		[self pow: result with: self evalUnary ->result];
	ip ungetToken: tk;
	result!
***Basic >> evalMulDiv 
	self evalPow ->:result;
	[ip getToken ->:tk, = '*' | (tk = '/')] whileTrue:
		[self evalPow ->:right;
		tk = '*' ifTrue: [result * right] ifFalse: [result / right] ->result];
	ip ungetToken: tk;
	result!
***Basic >> evalAddSub
	self evalMulDiv ->:result;
	[ip getToken ->:tk, = '+' | (tk = '-')] whileTrue:
		[self evalMulDiv ->:right;
		tk = '+' ifTrue: [result + right] ifFalse: [result - right] ->result];
	ip ungetToken: tk;
	result!
***Basic >> boolToInt: bool
	bool ifTrue: [-1] ifFalse: [0]!
***Basic >> apply: tk with: left and: right
	tk = '=' ifTrue: [self boolToInt: left = right!];
	tk = '<' ifTrue: [self boolToInt: left < right!];
	tk = '>' ifTrue: [self boolToInt: left > right!];
	tk = #<> ifTrue: [self boolToInt: left <> right!];
	tk = #<= ifTrue: [self boolToInt: left <= right!];
	self boolToInt: left >= right!
***Basic >> evalRel
	self evalAddSub ->:result;
	[ip getToken ->:tk, = '=' or: [tk = '<'], or: [tk = '>'], or: [tk = #<>],
			or: [tk = #<=], or: [tk = #>=]] whileTrue:
		[self apply: tk with: result and: self evalAddSub ->result];
	ip ungetToken: tk;
	result!
***Basic >> numtobm: valArg
	valArg asInteger ->:result;
	result < 0 ifTrue: [0x100000000 + result ->result];
	result!
***Basic >> bmtonum: valArg
	valArg >= 0x80000000 ifTrue: [valArg - 0x100000000 ->valArg];
	valArg!
***Basic >> evalAnd
	self evalRel ->:result;
	[ip getToken ->:tk, = #and] whileTrue:
		[self bmtonum: (self numtobm: result, & (self numtobm: self evalRel))
			->result];
	ip ungetToken: tk;
	result!
***Basic >> evalOr
	self evalAnd ->:result;
	[ip getToken ->:tk, = #or] whileTrue:
		[self bmtonum: (self numtobm: result, | (self numtobm: self evalAnd))
			->result];
	ip ungetToken: tk;
	result!
***Basic >> eval
	self evalOr!
	
**run.
***Basic >> nextLine
	ip line next ->:nl, nil? ifTrue: [nil ->ip] ifFalse: [ip line: nl]
***Basic >> nextStatement
	ip getToken ->:tk, = ':' ifTrue: [self!];
	tk = #eol | (tk = #else) ifTrue: [self nextLine!];
	self error: "illegal token " + tk
	
***Basic >> statement.cls
	screenControllable?
		ifTrue: [Console clear]
		ifFalse: [5 timesRepeat: [self put: '\n']];
	self nextStatement
***Basic >> statement.data
	self nextLine -- multistatement not supported yet.
***Basic >> statement.def
	ip getToken: #identifier;
	ip tokenValue ->:fn;
	self parseParen: 
		[ip getToken: #identifier;
		ip tokenValue ->:vn];
	ip getToken: '=';
	funcDict at: fn put: (Basic.Func new initVarName: vn ptr: ip copy);
	self skipStatement
***Basic >> statement.dim
	[ip getToken: #identifier;
	ip tokenValue ->:vn;
	self parseSubscript ->:ss;
	Basic.Array new init: vn sizes: ss ->:ar;
	arrayVarDict at: vn put: ar;
	ip getToken ->:tk, = ','] whileTrue;
	ip ungetToken: tk;
	self nextStatement
***Basic >> statement.end
	nil ->ip
	
***for.
****Basic >> skipStatement
	ip peepToken = #rem ifTrue: [self nextLine!];
	[ip getToken ->:tk, = ':' | (tk = #eol)] whileFalse;
	tk = ':' ifTrue: [ip ungetToken: tk];
	self nextStatement
****Basic >> skipForLoop
	[ip peepToken ->:tk, <> #next] whileTrue:
		[self skipStatement;
		tk = #for ifTrue: [self skipForLoop]];
	ip getToken: #next;
	ip peepToken = #identifier ifTrue: [ip getToken];
	ip peepToken = ',' ifTrue: 
		[self error: "skip for with multi variable next"];
	self nextStatement
****Basic >> statement.for
	ip getToken: #identifier;
	ip tokenValue ->:vn;
	ip getToken: '=';
	self eval ->:from;
	self varAt: vn put: from;
	ip getToken: #to;
	self eval ->:to;
	ip getToken ->:tk, = #step
		ifTrue: [self eval]
		ifFalse:
			[ip ungetToken: tk;
			1] ->:step;
	from < to & (step < 0) | (from > to & (step > 0)) ifTrue:
		[self nextStatement;
		self skipForLoop!];
	self nextStatement;
	Basic.For new initVarName: vn to: to step: step ptr: ip copy ->:for;
	forStack addLast: for

***Basic >> lineAt: lno
	lines detect: [:l l no = lno] ->:result, nil? 
		ifTrue: [self error: "missing line " + lno];
	result!
***Basic >> goto: lno
	ip line: (self lineAt: lno)
***Basic >> gosub: lno
	self nextStatement;
	subStack addLast: ip copy;
	self goto: lno
***Basic >> statement.gosub
	ip getToken: #integer;
	self gosub: ip tokenValue
***Basic >> statement.goto
	ip getToken: #integer;
	self goto: ip tokenValue

***if.
****Basic >> skipThenClause
	[ip getToken ->:tk, = #eol | (tk = #rem)] whileFalse:
		[tk = #else ifTrue: 
			[ip peepToken = #integer ifTrue: [self goto: ip tokenValue]!]];
	self nextLine
****Basic >> statement.if
	self eval = 0 ifTrue: [self skipThenClause!];
	ip peepToken = #then ifTrue: [ip getToken];
	ip peepToken = #integer ifTrue: [self goto: ip tokenValue]
	
***input.
****Basic >> upperString: valueArg
	capsoff? ifTrue: [valueArg!];
	StringReader new init: valueArg ->:rd;
	StringWriter new ->:wr;
	[rd getChar ->:ch, notNil?] whileTrue: [wr put: ch upper];
	wr asString!
****Basic >> input: ln to: vars
	[vars do:
		[:v
		ln indexOf: ',' ->:pos, nil? 
			ifTrue: 
				[ln ->:value;
				nil ->ln]
			ifFalse:
				[ln copyUntil: pos ->value;
				ln copyFrom: pos + 1 ->ln];
		self stringVar?: v, 
			ifTrue: [self upperString: value]
			ifFalse: [value asNumber] ->value;
		self varAt: v put: value]] on: Error do:
			[:ex Out putLn: ex message;
			false!];
	true!
****Basic >> statement.input
	"" ->:prompt;
	ip peepToken = #string ifTrue:
		[ip getToken;
		ip tokenValue ->prompt;
		ip getToken: ';'];
	Array new ->:vars;
	[vars addLast: self parseVar;
	ip getToken ->:tk, = ','] whileTrue;
	ip ungetToken: tk;
	[self input: (Prompt getString: prompt) to: vars] whileFalse:
		["again" ->prompt];
	0 ->xpos;
	self nextStatement

****Basic >> statement.let
	self parseVar ->:v;
	ip getToken: '=';
	self varAt: v put: self eval;
	self nextStatement
****Basic >> statement.locate
	self eval asInteger - 1 ->:y;
	ip getToken: ',';
	self eval asInteger - 1 ->xpos;
	screenControllable?
		ifTrue: [Console gotoX: xpos Y: y]
		ifFalse: [Out putLn, putSpaces: xpos];
	self nextStatement

***next.
****Basic >> next: v
	breakFor? ifTrue:
		[forStack removeFrom: (forStack findLast: [:f f varName = v]) + 1];
	forStack last ->:for;
	for varName <> v ifTrue:
		[self error: "next " + v + " in for " + for varName + " loop"];
	self varAt: v, + for step ->:value;
	for step > 0 ifTrue: [value > for to] ifFalse: [value < for to] ->:result,
		ifTrue: [forStack removeLast]
		ifFalse: 
			[self varAt: v put: value;
			for ptr copy ->ip];
	result!
****Basic >> statement.next
	Array new ->:vs;
	ip peepToken ->:tk, = #identifier
		ifTrue:
			[[ip getToken: #identifier;
			vs addLast: ip tokenValue;
			ip getToken ->tk, = ','] whileTrue;
			ip ungetToken: tk]
		ifFalse: [vs addLast: forStack last varName];
	
	vs do:
		[:v
		self next: v, ifFalse: [self!]];
	self nextStatement

***Basic >> statement.on
	self eval asInteger ->:val;
	ip getToken ->:tk, <> #goto & (tk <> #gosub) 
		ifTrue: [self error: "require goto or gosub"];
	Array new ->:list;
	[ip getToken: #integer;
	list addLast: ip tokenValue;
	ip peepToken = ','] whileTrue: [ip getToken];
	val between: 1 and: list size,
		ifTrue: 
			[list at: (val - 1) ->:lno;
			tk = #goto
				ifTrue: [self goto: lno]
				ifFalse: [self gosub: lno]]
		ifFalse: [self nextStatement]
		
***print.
****Basic >> put: arg
	arg = '\n' ifTrue:
		[Out putLn;
		0 ->xpos!];
	arg kindOf?: Char, ifTrue:
		[Out put: arg;
		xpos + 1 ->xpos!];
	arg asString do: [:ch self put: ch]
****Basic >> print: tk
	tk = #tab ifTrue:
		[ip getToken;
		self eval asInteger - xpos timesRepeat: [self put: ' '];
		true!];
	tk = #spc ifTrue:
		[ip getToken;
		self eval asInteger timesRepeat: [self put: ' '];
		true!];
	tk = #using ifTrue:
		[ip getToken;
		Basic.Using new init: self eval ->using;
		true!];
	tk = ',' ifTrue:
		[ip getToken;
		[self put: ' ';
		xpos % 14 <> 0] whileTrue;
		false!];
	tk = ';' ifTrue: 
		[ip getToken;
		false!];
	self eval ->:val;
	val kindOf?: Number,
		ifTrue:
			[using notNil?
				ifTrue: [self put: (using format: val)]
				ifFalse:
					[val >= 0 ifTrue: [self put: ' '];
					self put: val, put: ' ']]
		ifFalse: [self put: val];
	true!
****Basic >> statement.print
	nil ->using;
	true ->:newline?;
	[ip peepToken ->:tk, = #eol | (tk = ':') | (tk = #else)] whileFalse:
		[self print: tk ->newline?];
	newline? ifTrue: [self put: '\n'];
	self nextStatement

***read.
****Basic >> nextDataLine
	[dp getToken <> #data] whileTrue:
		[dp line next ->:nl, nil? ifTrue: 
			[self error: "nextDataLine reach eof"];
		dp line: nl]
****Basic >> statement.read
	[self parseVar ->:v;
	dp nil? | (dp kindOf?: Integer),
		ifTrue:
			[Basic.Ptr new init: self, line:
				(dp nil? ifTrue: [lines next value] ifFalse: [self lineAt: dp])
				->dp;
			self nextDataLine]
		ifFalse: [dp getToken = ',' ifFalse: [self nextDataLine]];
	self stringVar?: v,
		ifTrue: [dp getDataString] ifFalse: [dp getDataNumber] ->:d;
	self varAt: v put: d;
	ip getToken ->:tk, = ','] whileTrue;
	ip ungetToken: tk;
	self nextStatement
	
***Basic >> statement.rem
	self nextLine
***Basic >> statement.restore
	ip peepToken = #integer 
		ifTrue:
			[ip getToken;
			ip tokenValue]
		ifFalse: [nil] ->dp;
	self nextStatement
***Basic >> statement.return
	subStack last ->ip;
	subStack removeLast
***Basic >> statement.stop
	Out putLn: "stop";
	nil ->ip

***Basic >> statement.wend
	ip ->:savedIp;
	whileStack last copy ->ip;
	self eval = 0 ifTrue:
		[whileStack removeLast;
		savedIp ->ip];
	self nextStatement
		
***while.
****Basic >> skipWhileLoop
	[ip peepToken ->:tk, <> #wend] whileTrue:
		[self skipStatement;
		tk = #while ifTrue: [self skipWhileLoop]];
	self skipStatement
***Basic >> statement.while
	ip copy ->:expr;
	self eval = 0 ifTrue: [self skipWhileLoop!];
	whileStack addLast: expr;
	self nextStatement
	

***Basic >> setupForRun
	Dictionary new ->varDict;
	Dictionary new ->arrayVarDict;
	Array new ->forStack;
	Array new ->subStack;
	Array new ->whileStack;
	Basic.Ptr new init: self, line: lines next value ->ip;
	nil ->dp;
	0 ->xpos;
	Dictionary new ->funcDict
***Basic >> performStatement
	ip getToken ->:tk;
	tk = #cls ifTrue: [self statement.cls!];
	tk = #data ifTrue: [self statement.data!];
	tk = #def ifTrue: [self statement.def!];
	tk = #dim ifTrue: [self statement.dim!];
	tk = #end ifTrue: [self statement.end!];
	tk = #for ifTrue: [self statement.for!];
	tk = #gosub ifTrue: [self statement.gosub!];
	tk = #goto ifTrue: [self statement.goto!];
	tk = #if ifTrue: [self statement.if!];
	tk = #input ifTrue: [self statement.input!];
	tk = #let ifTrue: [self statement.let!];
	tk = #locate ifTrue: [self statement.locate!];
	tk = #next ifTrue: [self statement.next!];
	tk = #on ifTrue: [self statement.on!];
	tk = #print ifTrue: [self statement.print!];
	tk = #read ifTrue: [self statement.read!];
	tk = #rem ifTrue: [self statement.rem!];
	tk = #restore ifTrue: [self statement.restore!];
	tk = #return ifTrue: [self statement.return!];
	tk = #run ifTrue: [self setupForRun!];
	tk = #stop ifTrue: [self statement.stop!];
	tk = #wend ifTrue: [self statement.wend!];
	tk = #while ifTrue: [self statement.while!];
	
	--stabs
	tk = #beep ifTrue: [self skipStatement!];
	tk = #key ifTrue: [self skipStatement!];
	tk = #randomize ifTrue: [self skipStatement!];
	tk = #sound ifTrue: [self skipStatement!];
	
	tk = #identifier ifTrue:
		[ip ungetToken: tk;
		self statement.let!];

	self error: "unknown statment"
***Basic >> run
	self setupForRun;
	[[ip notNil?] whileTrue: [self performStatement]] on: Error do:
		[:e
		stackTrace? ifTrue: [e printStackTrace];
		Out putLn: "!" + e message + " at " + ip no + ":" + ip pos]
***Basic >> run: symbolArg
	self load: (StringReader new init: (Mulk at: symbolArg));
	self run
	
*entry.@
	Object addSubclass: #Cmd.basic
**Cmd.basic >> main: args
	OptionParser new init: "ifsclw" ->:op, parse: args ->args;
	Basic new ->:basic;
	op at: 'i', ifTrue: [basic implicitDeclareArray];
	op at: 'f', ifTrue: [basic breakFor];
	op at: 's', ifTrue: [basic stackTrace];
	op at: 'c', ifTrue: [basic capsoff];
	op at: 'l', ifTrue: [basic longVar];
	op at: 'w', ifTrue: [basic wordSplitBySpace];
	args first asFile readDo:
		[:rd
		basic load: rd];
	basic run
