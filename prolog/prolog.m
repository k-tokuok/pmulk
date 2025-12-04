prolog prototype.
$Id: mulk/prolog prolog.m 1470 2025-08-29 Fri 23:04:09 kt $

*import.@
	Mulk import: #("optparse" "prompt" "repl")
	
*cell -- clause structure.
**Prolog.Functor class.@
	Object addSubclass: #Prolog.Functor 
		instanceVars: "atom arity type pri clauses builtin"
***Prolog.Functor >> initAtom: atomArg arity: arityArg
	atomArg ->atom;
	arityArg ->arity;
	nil ->clauses;
	0 ->pri

***accessing.
****Prolog.Functor >> name
	atom name!
****Prolog.Functor >> arity
	arity!
****Prolog.Functor >> type: typeArg pri: priArg
	typeArg ->type;
	priArg ->pri
****Prolog.Functor >> type
	type!
****Prolog.Functor >> pri
	pri!
****Prolog.Functor >> builtin: arg
	arg ->builtin
****Prolog.Functor >> builtin
	builtin!
****Prolog.Functor >> is: nameArg arity: arityArg
	self name = nameArg and: [arity = arityArg]!		

***clause.
****Prolog.Functor >> addClause: clauseArg
	clauses nil? ifTrue: [Array new ->clauses];
	clauses addLast: clauseArg
****Prolog.Functor >> removeClauses
	nil ->clauses
****Prolog.Functor >> clauses
	clauses!
****Prolog.Functor >> nclauses
	clauses nil? ifTrue: [0] ifFalse: [clauses size]!
***Prolog.Functor >> infixOfPri: priArg leftPri: leftPriArg
	type = #xfx | (type = #xfy) | (type = #yfx) ifFalse: [false!];
	pri > priArg ifTrue: [false!];
	type = #yfx ifTrue: [leftPriArg - 1 ->leftPriArg];
	pri > leftPriArg!
***Prolog.Functor >> postfixOfPri: priArg leftPri: leftPriArg
	type = #xf | (type = #yf) ifFalse: [false!];
	pri > priArg ifTrue: [false!];
	type = #yf ifTrue: [leftPriArg - 1 ->leftPriArg];
	pri > leftPriArg!
			
**Prolog.Atom class.@
	Object addSubclass: #Prolog.Atom instanceVars: "name functors"
***Prolog.Atom >> init: nameArg
	nameArg ->name;
	Array new ->functors
****Prolog.Atom >> printOn: writerArg
	writerArg put: name	
****Prolog.Atom >> name
	name!
***Prolog.Atom >> functorOf: arityArg
	arityArg >= functors size ifTrue: [functors size: arityArg + 1];
	functors at: arityArg, nil? ifTrue:
		[functors at: arityArg put: 
			(Prolog.Functor new initAtom: self arity: arityArg)];
	functors at: arityArg!
***Prolog.Atom >> functor
	self functorOf: 0!

**Prolog.ClauseVar class.@
	Object addSubclass: #Prolog.ClauseVar instanceVars: "name"
***Prolog.ClauseVar >> init: nameArg
	nameArg ->name
***Prolog.ClauseVar >> printOn: writerArg
	writerArg put: name

**Prolog.VoidVar class.@
	Object addSubclass: #Prolog.VoidVar
***Prolog.VoidVar >> printOn: writerArg
	writerArg put: '_'

**Prolog.Var class.@
	Object addSubclass: #Prolog.Var instanceVars: "no value"
***Prolog.Var >> init: noArg
	noArg ->no
***Prolog.Var >> printOn: writerArg
	writerArg put: '_', put: no
	
***accessing.
****Prolog.Var >> no
	no!
****Prolog.Var >> value
	value!
****Prolog.Var >> value: arg
	arg ->value

**Prolog.Term class.@
	Object addSubclass: #Prolog.Term instanceVars: "functor args"
***accessing.
****Prolog.Term >> functor
	functor!
****Prolog.Term >> args
	args!
	
***Prolog.Term >> initFunctor: functorArg args: argsArg
	functorArg ->functor;
	argsArg asFixedArray ->args

*reader.
**Prolog.Lexer class.@
	AheadReader addSubclass: #Prolog.Lexer instanceVars: "ungotChar"
***Prolog.Lexer >> initReader: readerArg
	super initReader: readerArg;
	nil ->ungotChar
***Prolog.Lexer >> skipChar
	self errorIfEof;	
	nextChar ->:result;
	ungotChar notNil? 
		ifTrue: 
			[ungotChar ->nextChar;
			nil ->ungotChar]
		ifFalse: [reader getChar ->nextChar];
	result!
***Prolog.Lexer >> identifierLeadChar?
	nextChar lower? or: [nextChar = '$']!
***Prolog.Lexer >> identifierTrailChar?
	nextChar alpha? or: [nextChar = '$'], or: [nextChar digit?]!
***Prolog.Lexer >> varLeadChar?
	nextChar = '_' or: [nextChar upper?]!
***Prolog.Lexer >> symbolChar?
	#('+' '-' '*' '/' '=' '<' '>' ':' '?') includes?: nextChar!
***Prolog.Lexer >> getDigits
	[self digit?] whileTrue: [self getChar]	
***Prolog.Lexer >> getToken
	self skipSpace;
	
	nextChar = '%' ifTrue:
		[[nextChar <> '\n'] whileTrue: [self skipChar];
		self skipChar;
		self getToken!];
	nextChar nil? ifTrue: [#eof!];

	#('(' ')' '[' ']' ',' '.' '|') includes?: nextChar, 
		ifTrue: [self skipChar!];

	self resetToken;
	self nextChar = ';' or: [self nextChar = '!'], ifTrue:
		[self getChar;
		#atom!];
	self identifierLeadChar? ifTrue:
		[self getChar;
		[self identifierTrailChar?] whileTrue: [self getChar];
		#atom!];
	self symbolChar? ifTrue:
		[self getChar;
		[self symbolChar?] whileTrue: [self getChar];
		#atom!];
		
	self varLeadChar? ifTrue:
		[self getChar;
		[self identifierTrailChar?] whileTrue: [self getChar];
		#var!];
	
	nextChar digit? ifTrue:
		[self getDigits;
		nextChar = '.' ifTrue:
			[self skipChar;
			self digit? 
				ifTrue:
					[self add: '.';
					self getDigits]
				ifFalse:
					[self assert: ungotChar nil?;
					nextChar ->ungotChar;
					'.' ->nextChar]];
			#number!];
			
	nextChar = '"' ifTrue:
		[self skipChar;
		[nextChar <> '"'] whileTrue: 
			[nextChar = '\n' or: [nextChar nil?],
				ifTrue: [self error: "quote not closed"];
			self getWideEscapeChar];
		self skipChar;
		#string!];

	self error: "illegal char " + nextChar

**Prolog.Reader class.@
	Object addSubclass: #Prolog.Reader instanceVars: "prolog lexer nextTk"
***Prolog.Reader >> init: prologArg reader: readerArg
	prologArg ->prolog;
	Prolog.Lexer new initReader: readerArg ->lexer;
	self skip
***Prolog.Reader >> skip
	lexer getToken ->nextTk
***Prolog.Reader >> skip: tkArg
	nextTk <> tkArg ifTrue: [self error: "missing " + tkArg];
	self skip
***Prolog.Reader >> nextAtom
	nextTk = ',' ifTrue: [prolog atomOf: ","!];
	nextTk = #atom ifTrue: [prolog atomOf: lexer token!];
	self error: "require , or atom"
***Prolog.Reader >> parseList
	self skip;
	prolog nilAtom ->:cdr;
	nextTk = ']' ifTrue:
		[self skip;
		cdr!];
	Array new ->:ar;
	[ar addLast: (self parseMain: 999); nextTk = ','] whileTrue: [self skip];
	nextTk = '|' ifTrue:
		[self skip;
		self parseMain: 999 ->cdr];
	self skip: ']';
	
	prolog consFunctor ->:cons;
	ar reverse do:
		[:e
		Prolog.Term new initFunctor: cons args:
			(Array new addLast: e, addLast: cdr) ->cdr];
	cdr!
***Prolog.Reader >> parseLeft: priArg
	nextTk = ',' | (nextTk = #atom) ifTrue:
		[self nextAtom ->:atom;
		self skip;
		Array new ->:args;
		nextTk = '('
			ifTrue:
				[self skip;
				[args addLast: (self parseMain: 999);
				nextTk = ','] whileTrue: [self skip];
				self skip: ')';
				atom functorOf: args size ->:f]
			ifFalse:
				[atom functorOf: 1 ->f;
				f type = #fx or: [f type = #fy], and: [f pri <= priArg], 
					ifTrue: [args addLast: (self parseMain: f pri -
							(f type = #fx ifTrue: [1] ifFalse: [0]))]];
		args size = 0 
			ifTrue: [atom] 
			ifFalse: [Prolog.Term new initFunctor: f args: args]!];
	nextTk = #var ifTrue: 
		[prolog varOf: lexer token ->:result;
		self skip;
		result!];
	nextTk = #number ifTrue:
		[lexer token asNumber ->result;
		self skip;
		result!];
	nextTk = #string ifTrue:
		[lexer token ->result;
		self skip;
		result!];
	nextTk = '[' ifTrue: [self parseList!];
	nextTk = '(' ifTrue:
		[self skip;
		self parseMain: 1200 ->result;
		self skip: ')';
		result!];
		
	self error: "syntax error"
***Prolog.Reader >> parseMain: priArg
	self parseLeft: priArg ->:left;
	0 ->:leftPri;
	[nextTk = ',' | (nextTk = #atom)] whileTrue:
		[self nextAtom ->:atom;
		atom functorOf: 2 ->:f;
		f infixOfPri: priArg leftPri: leftPri, 
			ifTrue:
				[self skip;
				Array new ->:args;
				args addLast: left;
				f pri ->leftPri;
				args addLast: (self parseMain: leftPri - 
					(f type <> #xfy ifTrue: [1] ifFalse: [0]));
				Prolog.Term new initFunctor: f args: args ->left]
			ifFalse:
				[atom functorOf: 1 ->f;
				f postfixOfPri: priArg leftPri: leftPri, 
					ifTrue:
						[self skip;
						f pri ->leftPri;
						Prolog.Term new initFunctor: f args: 
							(Array new addLast: left) ->left]
					ifFalse: [left!]]];
	left!
***Prolog.Reader >> read
	nextTk = #eof, ifTrue: [nil!];
	self parseMain: 1200 ->:result;
	self skip: '.';
	result!

*Prolog.Writer class.@
	Object addSubclass: #Prolog.Writer instanceVars: "prolog writer"
**Prolog.Writer >> init: prologArg writer: writerArg
	prologArg ->prolog;
	writerArg ->writer
**Prolog.Writer >> cons?: cell
	cell memberOf?: Prolog.Term, and: [cell functor = prolog consFunctor]!
**Prolog.Writer >> write: cell
	prolog deref: cell ->cell;

	self cons?: cell, ifTrue:
		[writer put: '[';
		[self write: cell args first;
		prolog deref: (cell args at: 1) ->cell;
		self cons?: cell] whileTrue:
			[writer put: ','];
		cell <> prolog nilAtom ifTrue: 
			[writer put: '|';
			self write: cell];
		writer put: ']'!];
		
	cell memberOf?: Prolog.Term, ifTrue:
		[writer put: cell functor name, put: '(';
		cell args do: [:a self write: a] separatedBy: [writer put: ','];
		writer put: ')'!];
	writer put: cell
	
*query.
**Prolog.Environment class.@
	Object addSubclass: #Prolog.Environment instanceVars: "ep cutCp body"
***Prolog.Environment >> initEp: epArg cutCp: cutCpArg body: bodyArg 
	epArg ->ep;
	cutCpArg ->cutCp;
	bodyArg ->body
	
***accessing.
****Prolog.Environment >> ep
	ep!
****Prolog.Environment >> cutCp
	cutCp!
****Prolog.Environment >> body
	body!
	
**Prolog.ChoicePoint class.@
	Object addSubclass: #Prolog.ChoicePoint instanceVars: 
		"head body ep cp tp nextClauseNo"
***Prolog.ChoicePoint >> initHead: headArg body: bodyArg ep: epArg cp: cpArg
		tp: tpArg
	headArg ->head;
	bodyArg ->body;
	epArg ->ep;
	cpArg ->cp;
	tpArg ->tp;
	1 ->nextClauseNo
***accessing.
****Prolog.ChoicePoint >> head
	head!
****Prolog.ChoicePoint >> body
	body!
****Prolog.ChoicePoint >> ep
	ep!
****Prolog.ChoicePoint >> cp
	cp!
****Prolog.ChoicePoint >> tp
	tp!
	
***Prolog.ChoicePoint >> alternative
	head functor clauses at: nextClauseNo ->:result;
	nextClauseNo + 1 ->nextClauseNo;
	result!
***Prolog.ChoicePoint >> alternativeExist?
	head functor clauses size <> nextClauseNo!
	
**Prolog.Query class.@
	Object addSubclass: #Prolog.Query instanceVars: 
		"prolog head body clause alter? ep cp trail"
		+ " vars clauseVars varNo"
		+ " resultVars resultClauseVars"
		+ " writer"

***Prolog.Query >> init: prologArg
	prologArg ->prolog;
	Prolog.Writer new init: prolog writer: Out ->writer;
	Array new ->trail
	
***materialize.
****Prolog.Query >> sweep: cellArg
	cellArg memberOf?: Prolog.ClauseVar, ifTrue:
		[clauseVars indexOf: cellArg ->:ix, nil?
			ifTrue:
				[Prolog.Var new init: varNo ->:result;
				clauseVars addLast: cellArg;
				vars addLast: result;
				varNo + 1 ->varNo;
				result!]
			ifFalse: [vars at: ix!]];
	cellArg memberOf?: Prolog.Term, ifTrue:
		[Array new ->:args;
		cellArg args do: [:arg args addLast: (self sweep: arg)];
		Prolog.Term new initFunctor: cellArg functor args: args!];
	cellArg!
****Prolog.Query >> materialize: cellArg cutCp: cutCpArg
	Prolog.Environment new initEp: ep cutCp: cutCpArg body: body ->ep;
	Array new ->vars;
	Array new ->clauseVars;
	self sweep: cellArg!
	
***unification.
****Prolog.Query >> bindVar: var value: val
	var value: val;
	trail addLast: var
****Prolog.Query >> unify: p and: q
	prolog deref: p ->p;
	prolog deref: q ->q;	

	--atom, number and string.
	p = q ifTrue: [true!];

	p memberOf?: Prolog.VoidVar, or: [q memberOf?: Prolog.VoidVar], 
		ifTrue: [true!];
		
	p memberOf?: Prolog.Var, ifTrue:
		[q memberOf?: Prolog.Var,
			ifTrue: 
				[p no < q no 
					ifTrue: [self bindVar: q value: p]
					ifFalse: [self bindVar: p value: q]]
			ifFalse: [self bindVar: p value: q];
			true!];
	q memberOf?: Prolog.Var, ifTrue:
		[self bindVar: q value: p;
		true!];
	
	p memberOf?: Prolog.Term, and: [q memberOf?: Prolog.Term],
			and: [p functor ->:f, = q functor], ifTrue:
		[p args ->:pa;
		q args ->:qa;
		f arity timesDo:
			[:i 
			self unify: (pa at: i) and: (qa at: i), ifFalse: [false!]];
		true!];
		
	false!
		
***builtins.
****Prolog.Query >> b.builtin: args
	--$builtin(atom,arity,methodName)
	args first functorOf: (args at: 1), builtin: (args at: 2) asSymbol;
	true!
****Prolog.Query >> b.op: args
	--$op(atom,arity,type,priority)
	args first, functorOf: (args at: 1), 
		type: (args at: 2) asSymbol pri: (args at: 3);
	true!
****Prolog.Query >> b.cut: args
	ep cutCp ->cp;
	true!
	
****meta-logical.
*****Prolog.Query >> b.var: args
	args first ->:a0, memberOf?: Prolog.Var, 
		or: [a0 memberOf?: Prolog.VoidVar]!
*****Prolog.Query >> b.number: args
	args first kindOf?: Number!

****Prolog.Query >> b.lt: args
	--X<Y
	args first < (args at: 1)!
				
****arithmetic.
*****Prolog.Query >> b.add: args
	--$add(X,Y,X+Y)
	self unify: args first + (args at: 1) and: (args at: 2)!
*****Prolog.Query >> b.minus: args
	--$minus(X,-X)
	self unify: args first negated and: (args at: 1)!
*****Prolog.Query >> b.multiply: args
	--$multiply(X,Y,X*Y)
	self unify: args first * (args at: 1) and: (args at: 2)!
*****Prolog.Query >> b.divide: args
	--$divide(X,Y,X/Y)
	self unify: args first / (args at: 1) and: (args at: 2)!
*****Prolog.Query >> b.clock: args
	--$clock(OS >> clock)
	self unify: OS clock and: args first!
	
****input/output.
*****Prolog.Query >> b.write: args
	writer write: args first;
	true!
*****Prolog.Query >> b.put: args
	Out put: args first asChar;
	true!

****clause control.
*****Prolog.Query >> b.consult: args
	prolog consult: args first asFile;
	true!
*****Prolog.Query >> b.abolish: args
	--abolish(atom,arity)
	args first functorOf: (args at: 1), removeClauses;
	true!
	
****debug support.
*****Prolog.Query >> b.debugTerm: args
	args first repl;
	true!
	
***main process.
****Prolog.Query >> processClause: cutCpArg
	self materialize: clause cutCp: cutCpArg ->clause;
	clause functor is: ":-" arity: 2, 
		ifTrue:
			[clause args first ->:h;
			clause args at: 1 ->body]
		ifFalse:
			[clause ->h;
			nil ->body];
	self unify: head and: h, ifTrue: [#processBody] ifFalse: [#processFail]!	
****Prolog.Query >> processClauses
	head functor ->:f;
	f nclauses ->:nc, = 0 ifTrue: [#processFail!];
	cp ->:cp0;
	nc >= 2 ifTrue:
		[Prolog.ChoicePoint new initHead: head body: body ep: ep cp: cp
			tp: trail size ->cp];
	f clauses first ->clause;
	self processClause: cp0!
****Prolog.Query >> processBody
	[body nil?] whileTrue:
		[ep body ->body;
		ep ep ->ep, nil? ifTrue: [#success!]];
	prolog deref: body ->body;
	body functor is: "," arity: 2, 
		ifTrue:
			[body args first ->head;
			body args at: 1 ->body]
		ifFalse:
			[body ->head;
			nil ->body];
	prolog deref: head ->head;
	head functor builtin ->:b, notNil? ifTrue:
		[head memberOf?: Prolog.Term, ifTrue:
			[head args ->:orgargs;
			FixedArray basicNew: orgargs size ->:args;
			orgargs size timesDo:
				[:i args at: i put: (prolog deref: (orgargs at: i))]];
		self perform: b with: args,
			ifTrue: [#processBody] ifFalse: [#processFail]!];
	#processClauses!
****Prolog.Query >> processFail
	cp nil? ifTrue: [#fail!];
	cp head ->head;
	cp ep ->ep;
	cp body ->body;
	cp alternative ->clause;
	[trail size <> cp tp] whileTrue:
		[trail last value: nil;
		trail removeLast];
	cp alternativeExist? ifFalse: [cp cp ->cp];
	self processClause: cp!
****Prolog.Query >> processLoop: next
	[next = #success or: [next = #fail]] whileFalse: 
		[self perform: next ->next];
	next = #success!

***api.
****Prolog.Query >> query: bodyArg
	0 ->varNo;
	self materialize: bodyArg cutCp: nil ->body;
	vars ->resultVars;
	clauseVars ->resultClauseVars;
	self processLoop: #processBody!
****Prolog.Query >> retry
	self processLoop: #processFail!
****Prolog.Query >> resultsExist?
	resultClauseVars empty? not!
****Prolog.Query >> showResults
	resultVars size timesDo:
		[:i
		Out put: (resultClauseVars at: i) asString, put: " = ";
		writer write: (resultVars at: i);
		Out putLn]
			
*Prolog class.@
	Object addSubclass: #Prolog instanceVars: "varDict atomDict"
		+ " nilAtom consFunctor"
**Prolog >> varOf: nameArg
	varDict at: nameArg ifAbsentPut: 
		[nameArg = "_" 
			ifTrue: [Prolog.VoidVar new]
			ifFalse: [Prolog.ClauseVar new init: nameArg]]!
**Prolog >> atomOf: nameArg
	atomDict at: nameArg ifAbsentPut: [Prolog.Atom new init: nameArg]!
**Prolog >> functorOf: nameArg arity: arityArg
	self atomOf: nameArg, functorOf: arityArg!

**Prolog >> nilAtom
	nilAtom!
**Prolog >> consFunctor
	consFunctor!

**Prolog >> deref: p
	[p memberOf?: Prolog.Var] whileTrue:
		[p value nil? ifTrue: [p!];
		p value ->p];
	p!

**Prolog >> init
	Dictionary new ->varDict;
	Dictionary new ->atomDict;
	self atomOf: "$nil" ->nilAtom;
	self functorOf: "$cons" arity: 2 ->consFunctor

**external api.
***Prolog >> query: cell silent: silent?
	Prolog.Query new init: self ->:query;
	query query: cell args first ->:result;
	silent? ifFalse:
		[result & query resultsExist? ifTrue:
			[true ->:retry?;
			[retry?] whileTrue:
				[query showResults;
				Prompt getBoolean: "retry" default: true ->retry?, ifTrue:
					[query retry ->result, ifFalse: [false ->retry?]]]];
		Out putLn: result]
***Prolog >> assert: cell
	cell functor is: ":-" arity: 2, ifTrue: [cell args first] ifFalse: [cell],
		functor addClause: cell
***Prolog >> assertOrQuery: cell
	cell functor is: "?-" arity: 1, ifTrue: [self query: cell silent: false!];
	cell functor is: ":-" arity: 1, ifTrue: [self query: cell silent: true!];
	self assert: cell
	
***Prolog >> consult: fileArg
	fileArg readDo:
		[:s
		Prolog.Reader new init: self reader: s ->:reader;
		[reader read ->:cell, notNil?] whileTrue: [self assertOrQuery: cell]]
		
*driver.@
	Object addSubclass: #Cmd.prolog instanceVars: "wb prolog"
**Cmd.prolog >> init
	Mulk at: #Wb ifAbsent: [nil] ->wb;
	wb notNil? ifTrue: [wb get ->wb]
**Cmd.prolog >> main.lexert: args
	Prolog.Lexer new initReader: In ->:lexer;
	[lexer getToken ->:tk, <> #eof] whileTrue:
		[Out put: "code: " + tk;
		tk = #atom | (tk = #number) | (tk = #var) | (tk = #string) ifTrue: 
			[Out put: " token: " + lexer token];
		Out putLn]
**Cmd.prolog >> processLn: ln
	ln = "" 
		ifTrue: [wb inputText: "" ->ln, nil? or: [ln = ""], ifTrue: [self!]]
		ifFalse: ["?-" + ln ->ln];
	Prolog.Reader new init: prolog reader: (StringReader new init: ln) 
		->:reader;
	prolog assertOrQuery: reader read
**Cmd.prolog >> main: args
	OptionParser new init: "d" ->:op, parse: args ->args;
	op at: 'd' ->:debug?;
	
	Prolog new ->prolog;
	prolog atomOf: "$builtin", functorOf: 3, builtin: #b.builtin:;
	prolog consult: "startup.pl" asSystemFile;	
	
	args do: [:a prolog consult: a asFile];
	[Out put: "?-"; In getLn ->:ln, notNil?] whileTrue:
		[[self processLn: ln] on: Error do:
			[:e
			debug? ifTrue: [e printStackTrace];
			Out putLn: e message]]
