read-eval-print loop
$Id: mulk repl.m 1211 2024-04-14 Sun 05:16:20 kt $
#ja

*[man]
**#en
.caption SYNOPSIS
	repl
.caption DESCRIPTION
Evaluates the statement entered at the prompt and prints it if the result is not self.
EOF or '!' only line is entered, the repl terminates.

Local variables other than block arguments are valid for the duration of the session.
**#ja
.caption 書式
	repl
.caption 説明
プロンプトに対して入力されたステートメントを評価し、結果がselfで無い場合にそれを表示する。
EOFか'!'のみの行を入力すると終了する。

ブロック引数以外のローカル変数はセッションの間有効となる。

*Repl.Parser class.@
	MethodCompiler.Parser addSubclass: #Repl.Parser instanceVars: "replVars"
**Repl.Parser >> replVars: arg
	arg ->replVars
**Repl.Parser >> addVarCheck: name
	super addVarCheck: name;
	replVars includesKey?: name, ifTrue: 
		[self error: "redefine local var " + name]
**Repl.Parser >> addReplVar: nameArg
	self addVarCheck: nameArg;
	GlobalVar new ->:result;
	replVars at: nameArg put: result;
	result!

**Repl.Parser >> referVarOrGlobal: name
	replVars at: name ifAbsent: [nil] ->:gv, notNil? ifTrue:
		[self referGlobalVar: gv!];	
	super referVarOrGlobal: name!

**Repl.Parser >> assign: tr toNewVar: name
	self assign: tr toGlobalVar: (self addReplVar: name)!
**Repl.Parser >> assign: tr toVar: name
	replVars at: name ifAbsent: [nil] ->:gv, notNil? ifTrue:
		[self assign: tr toGlobalVar: gv!];
	super assign: tr toVar: name!

*Repl.Compiler class.@
	MethodCompiler addSubclass: #Repl.Compiler
**Repl.Compiler >> compileBody: readerArg class: belongClassArg 
		replVars: replVarsArg
	belongClassArg ->belongClass;
	Repl.Parser new init: readerArg, belongClass: belongClassArg, 
		replVars: replVarsArg ->parser;
	#_ ->selector;
	0 ->argCount;
	self compileMain!
	
*Object >> repl
	Dictionary new ->:rvs;
	[
		Out put: self describe + '>';
		In getLn ->:stmts, nil? or: [stmts = "!"], ifTrue: [self!];
		
		[Repl.Compiler new compileBody: (StringReader new init: stmts)
			class: self class replVars: rvs ->:m;
		self performMethod: m ->:result, <> self ifTrue:
			[Out putLn: result describe]
		] on: Error do:
			[:e
			e printStackTrace;
			Out putLn: e message]] loop
**[man.m]
***#en
Execute a read-eval-print loop against the receiver.
***#ja
レシーバーに対しread-eval-print loopを実行する。

*Cmd.repl tool.@
	Object addSubclass: #Cmd.repl
**Cmd.repl >> main: args
	self repl
