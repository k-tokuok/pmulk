unit test utility
$Id: mulk unittest.m 1259 2024-06-15 Sat 21:38:52 kt $
#ja ユニットテストユーティリティ

*[man]
**#en
.caption SYNOPSIS
	unittest [OPTION] MFILE ... -- Test a module file.
	unittest.class [-v] CLASS ... -- Run a loaded test class.
	unittest.load MFILE -- Load a test class from module file.
.caption DESCRIPTION
The unittest command reads the test description from the module file, executes the test, determines pass / fail, and displays the pass rate.

Tests are defined in the form of test classes.
The test class is a class with the name "Test.CLASSNAME" that inherits UnitTest, and has a method of "test.TESTNAME".
The test executes all test methods and passes if no Error exception occurs.

Test class definitions can be loaded with the unittest tool by writing them in the [test] section.
It is not read by normal load.
On the other hand, descriptions outside the [test] section are not read by default by unittest.
Load it in advance or specify loading with the 'i' or 'l' option.

Test method definitions are described in the [test.m] section.
At this time, if the upper section is a method definition, the target class method is automatically determined from the signature.
If the test class is not defined, it is automatically generated.
Also, by registering a class object in testClass in the test evaluation description, you can arbitrarily set a class to add a test method in the [test.m] section.
This is valid at the same or lower outline level as testClass is set.

If the upper section is not a method definition, add a method with the name generated from the section title.
In this case, testClass must be specified.

When defining multiple [test.m] under the same section, it is necessary to write a unique item name as the title of the [test.m] section.
.caption OPTION
	v -- Display processings verbosely.
	f -- Read test file list from standard input.
	i -- Import with test file base name before testing.
	l -- Load a test file before testing.

**#ja
.caption 書式
	unittest [OPTION] MFILE... -- モジュールファイルをテストする。
	unittest.class [-v] CLASS... -- 読み込み済みのテストクラスを実行する。
	unittest.load MFILE -- モジュールファイルのテスト記述を読み込む。
.caption 説明
unittestコマンドはモジュールファイルからテスト記述を読み込み、テストを実行、合否判定を行い、合格率を表示する。

テストはテストクラスの形で定義する。
テストクラスはUnitTestを継承する名称"Test.クラス名"のクラスで、"test.テスト名"のメソッドを持つ。
検査は全てのテストメソッドを実行し、Error例外が発生しなければ合格となる。

テストクラスの定義は[test]セクション中に記述する事で、unittestツールでロード出来る。
通常のロードでは読み込まれない。
一方、[test]セクション外の記述はunittestはデフォルトでは読み込まない。
事前にロードしておくか、i/lオプションでロードを指定する。

テストメソッドの定義は[test.m]セクションに記述する。
この時、上位のセクションがメソッド定義ならばシグネチャーから対象とするクラス・メソッドを自動的に決定する。
テストクラスが未定義の場合は自動的に生成する。
又、テスト用の評価記述中でtestClassにクラスオブジェクトを登録する事で、[test.m]セクションでのテストメソッドを追加するクラスを任意に設定出来る。
これはtestClassを設定したものと同一もしくは下位のアウトラインレベルで有効となる。

上位セクションがメソッド定義でない場合は、セクションタイトルから生成した名称でメソッドを追加する。
この場合はtestClassが明示されていなくてはならない。

同一セクションの下に複数の[test.m]を定義する場合は、[test.m]セクションのタイトルとして一意の項目名を記す必要がある。

.caption オプション
	v -- 処理を詳細に表示する。
	f -- 標準入力からテストファイル一覧を読み込む。
	i -- テスト前にテストファイルのベース名でインポートする。
	l -- テスト前にテストファイルをロードする。

*import.@
	Mulk import: "tempfile"
	
*UnitTest class.@
	Object addSubclass: #UnitTest instanceVars: "tempFiles"
**[man.c]
***#en
Base class for test classes.

The test class is defined as a derived class of this class.
***#ja
テストクラスの基底クラス。

テストクラスはこのクラスの派生クラスとして定義する。

**UnitTest >> assertError: blockArg message: messageArg
	[blockArg value] on: Error do:
		[:e
		e message = messageArg ifTrue: [self!]];
	self assertFailed
***[man.m]
****#en
Evaluate blockArg, and pass if messageArg Error occurs.
****#ja
blockArgを評価し、messageArgのErrorを起きれば合格とする。

**UnitTest >> setup
	self!
***[man.m]
****#en
Executed before executing the test method.

Override this method when defining test preconditions.
****#ja
テストメソッドを実行する前に実行される。

テストの事前条件を定義する場合にこのメソッドを上書きする。

**UnitTest >> teardown
	self!
***[man.m]
****#en
After the test method is executed, it is executed regardless of pass / fail.

Override this method to clear the test environment.
****#ja
テストメソッドを実行後、合否に関わらず実行される。

テスト環境をクリアする場合にこのメソッドを上書きする。

**UnitTest >> createTempFile
	TempFile create ->:result;
	tempFiles nil? ifTrue: [Array new ->tempFiles];
	tempFiles addLast: result;
	result!
***[man.m]
****#en
Create a file object for temporary file.

If this file exists after test method execution, it is automatically deleted.
****#ja
一時ファイル用のファイルオブジェクトを作成する。

このファイルがテストメソッド実行後に存在した場合は自動的に削除される。

**UnitTest >> doTest: selector
	true ->:result;
	nil ->tempFiles;
	self setup;
	[self perform: selector] on: Error do:
		[:e
		Out putLn: e message;
		false ->result];
	self teardown;
	tempFiles notNil? ifTrue:
		[[tempFiles do: [:f Out putLn: f]] pipe: "rm -n"];
	result!

*UnitTest.Loader class.@
	Loader addSubclass: #UnitTest.Loader instanceVars:
		"headers header level testLevel selectorCharDict classes"
		+ " testClass testClassLevel"
**UnitTest.Loader >> init
	Dictionary new ->selectorCharDict;
	#(	':' '_'				'%' "_percent"		'&' "_ampersand"
		'*' "_asterisk"		'+' "_plus" 		'/' "_slash"
		'<' "_lt"			'=' "_equal"		'>' "_gt"
		'@' "_at"			'\\' "_backslash"	'^' "_caret"
		'|' "_bar"			'~' "_tilde"		'-' "_minus"
		'!' "_class"		'_' "_underscore" ) ->:table;
	0 until: table size by: 2, do:
		[:i
		selectorCharDict at: (table at: i) put: (table at: i + 1)];
	Set new ->classes;
	Array new ->headers;
	99 ->testLevel ->testClassLevel
**UnitTest.Loader >> loadEval
	testClass nil?
		ifTrue:
			[super loadEval;
			testClass notNil? ifTrue: [level ->testClassLevel]]
		ifFalse: [super loadEval]
**UnitTest.Loader >> testMethodSelector: s
	StringReader new init: s ->:r;
	StringWriter new ->:w;
	w put: "test.";
	[r getChar ->:ch, notNil?] whileTrue:
		[w put: (selectorCharDict at: ch ifAbsent: [ch])];
	w asString asSymbol!
**UnitTest.Loader >> loadTestMethod
	headers at: level - 1 ->:h;
	--Out putLn: h;
	h includesSubstring?: " >> ",
		ifTrue:
			[MethodCompiler.Parser new init: (StringReader new init: h)
				->:parser;
			parser parseSignature;
			parser selector asString ->:selector;
			"Test." + parser belongClass, asSymbol ->:class]
		ifFalse: ["!" ->selector];

	AheadReader new init: header ->:r;
	r getToken;
	r getTokenIfEnd: [nil] ->:aux, notNil? ifTrue:
		[selector + '.' + aux ->selector];

	testClass nil?
		ifTrue:
			[self assert: class notNil?;
			Mulk at: class ifAbsent: [UnitTest addSubclass: class]]
		ifFalse: [testClass] ->class;	

	self assert: class notNil?;
	
	classes add: class;
	self testMethodSelector: selector ->selector;
	
	reader getLn;
	MethodCompiler new compileBody: reader class: class selector: selector ->:m;
	class addMethod: m;
	reader nextBlock
**UnitTest.Loader >> loadBlock
	reader level ->level;
	reader header ->header;
	
	headers size <= level ifTrue: [headers size: level + 1];
	headers at: level put: header;

	header heads?: "[test]", ifTrue:
		[level ->testLevel;
		header last = '@' ifTrue: [self loadEval!];
		reader nextBlock!];

	header heads?: "[test.m]", ifTrue: [self loadTestMethod!];

	level > testLevel ifTrue:
		[header includesSubstring?: " >> ", ifTrue: [self loadMethod!];
		header last = '@' ifTrue: [self loadEval!]];

	level <= testLevel ifTrue: [99 ->testLevel];
	level < testClassLevel ifTrue:
		[nil ->testClass;
		99 -> testClassLevel];
	reader nextBlock
**UnitTest.Loader >> load: file
	file multiLanguage?
		ifTrue: [self loadReader: (file pipe: "delang")]
		ifFalse: [super load: file]
**UnitTest.Loader >> classes
	classes!
	
*UnitTest.Driver class.@
	Object addSubclass: #UnitTest.Driver
		instanceVars: "okCount totalCount class selector"
			+ " verbose? autoLoad? autoImport?"
**UnitTest.Driver >> init
	0 ->okCount ->totalCount;
	false ->verbose? ->autoLoad? ->autoImport?
**UnitTest.Driver >> verbose
	true ->verbose?
**UnitTest.Driver >> autoLoad
	true ->autoLoad?
**UnitTest.Driver >> autoImport
	true ->autoImport?
**UnitTest.Driver >> check: ok?
	verbose? | ok? not ifTrue:
		[Out put: (ok? ifTrue: ["OK"] ifFalse: ["NG"]),
			put: ' ', put: class, put: " >> ", putLn: selector];
	totalCount + 1 ->totalCount;
	ok? ifTrue: [okCount + 1 ->okCount]
**UnitTest.Driver >> printResult
	Out put: okCount, put: '/', put: totalCount,
		put: " : ", put: okCount * 100 / totalCount, putLn: "% succeeded."
**UnitTest.Driver >> testFor: classArg
	classArg ->class;
	class methods collect: [:m m selector],
		select: [:s s asString heads?: "test."] ->:tests;
	tests do:
		[:t t ->selector;
		self check: (class new doTest: selector)]
**UnitTest.Driver >> testClasses: classes
	classes do:
		[:c
		Out putLn: c;
		self testFor: c];
	self printResult
**UnitTest.Driver >> testFiles: fns
	UnitTest.Loader new ->:loader;
	fns do:
		[:fn
		fn asFile ->:file;
		autoLoad? ifTrue: [Mulk loadFile: file];
		autoImport? ifTrue: [Mulk import: file baseName];
		loader load: file];
	self testClasses: loader classes

**testAll
***UnitTest.Driver >> addSubclasses: cl into: set
	cl subclasses do:
		[:c
		set add: c;
		self addSubclasses: c into: set]
***UnitTest.Driver >> testAll
	Set new ->:set;
	self addSubclasses: UnitTest into: set;
	self testClasses: set

*unittest tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.unittest instanceVars: "driver"
**Cmd.unittest >> driverSetup: op
	UnitTest.Driver new ->driver;
	op at: 'v', ifTrue: [driver verbose]
**Cmd.unittest >> main: args
	OptionParser new init: "vfli" ->:op, parse: args ->:fns;
	self driverSetup: op;
	op at: 'l', ifTrue: [driver autoLoad];
	op at: 'i', ifTrue: [driver autoImport];
	op at: 'f', ifTrue: [In contentLines ->fns];

	driver testFiles: fns
**Cmd.unittest >> main.class: args
	OptionParser new init: "v" ->:op, parse:args ->args;
	self driverSetup: op;
	driver testClasses: (args collect: [:n Mulk at: n asSymbol])
**Cmd.unittest >> main.load: args
	UnitTest.Loader new load: args first asFile
