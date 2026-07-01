read-eval-print loop
$Id: mulk repl.m 1610 2026-06-08 Mon 20:58:54 kt $
#ja

*[man]
**#en
.caption SYNOPSIS
	repl
.caption DESCRIPTION
Evaluate the statement entered in response to the prompt, and if the result is not self, set it to the local variable '_' and display it.
Local variables other than block arguments remain in scope for the duration of the session.

A line beginning with '!' is executed as a command line.
The program will exit if you enter EOF or a line containing only '!'.
**#ja
.caption 書式
	repl
.caption 説明
プロンプトに対して入力されたステートメントを評価し、結果がselfで無い場合にローカル変数'_'に設定した上で表示する。
ブロック引数以外のローカル変数はセッションの間有効となる。

'!'で始まる記述はコマンド行として実行する。
EOFか'!'のみの行を入力すると終了する。

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
	GlobalVar new ->:last;
	Dictionary new at: "_" put: last ->:rvs;
	[
		Out put: self describe + '>';
		In getLn ->:stmts, nil? or: [stmts = "!"], ifTrue: [self!];
		[stmts first = '!'
			ifTrue: [stmts copyFrom: 1, runCmd]
			ifFalse:
				[Repl.Compiler new compileBody: (StringReader new init: stmts)
					class: self class replVars: rvs ->:m;
				self performMethod: m ->:result, <> self ifTrue:
					[last set: result;
					Out putLn: result describe]]
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
