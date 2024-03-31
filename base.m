base class library
$Id: mulk base.m 1194 2024-03-31 Sun 09:36:59 kt $
#ja 基盤クラスライブラリ

*[man]
**#en
.caption DESCRIPTION
The base class library provides the basic functions for loading and executing programs written in Mulk.

This description is an excerpt of frequently used classes and methods and does not describe the entire system.
If the function of the method redefined in the subclass is equivalent to the function described in the superclass, it is omitted.

The class hierarchy is shown at the top of the class description.
In parentheses are features added to the class.

.index

**#ja
.caption 説明
基盤クラスライブラリはMulkで記述されたプログラムを読み込み、実行するための基本的な機能を提供する。

この説明は使用頻度の高いクラスやメソッドについての抜粋であり、システムの全体を説明している訳ではない。
サブクラスで再定義しているメソッドの機能がスーパークラスで説明された機能と同等であれば省略している。

クラスの説明の先頭にクラス階層を示している。
括弧内はそのクラスに付加されたフィーチャーである。

.index

*[test]
**Test.A class.@
	Object addSubclass: #Test.A instanceVars: "a"
***Test.A >> a: aArg
	aArg ->a
***Test.A >> a
	a!

**Test.B class.@
	Test.A addSubclass: #Test.B instanceVars: "b"
***Test.B >> a: aArg b: bArg
	aArg ->a;
	bArg ->b
***Test.B >> b
	b!
		
*Fundamental protocols.
**[man.s]
***#en
Fundamental protocols define the most basic part of the system.
***#ja
Fundamental protocolsはシステムの最も基礎となる部分を定義する。
**Object class.#
{ib.c/make_initial_objects:
	class Object;
}

***[man.s]
****#en
Object is a class that is the basis of all class hierarchies.

This class provides basic functionality common to all objects.
It is the only class that does not have a superclass.
****#ja
Objectは全てのクラス階層の基底となるクラスである。

このクラスは全てのオブジェクトに共通な基本機能を提供する。
唯一スーパークラスを持たないクラスである。
***[test] Test.Object class.@
	UnitTest addSubclass: #Test.Object instanceVars: "a"
****Test.Object >> setup
	Test.A new a: #a, hash: 123 ->a
	
***Object >> init
	self!
****[man.m]
*****#en
Method executed when an object is created by new.

Overwrite this method if there is class-specific initialization processing.
*****#ja
オブジェクトをnewで生成した場合に実行されるメソッド。

クラス固有の初期化処理があれば、このメソッドを上書きする。
****[test.m]
	a init
	
***primitives.
****Object >> class
	$object_class
*****[test.m]
	self assert: a class = Test.A

****Object >> == objectArg
	$object_equal
*****[man.m]
******#en
Returns true if the receiver and objectArg are the same object.
******#ja
レシーバーとobjectArgが同一のオブジェクトならtrueを返す。
*****[test.m]
	self assert: a == a;
	self assert: (a == nil) not
	
****Object >> basicSize
	$object_basicSize
*****[test.m]
	self assert: a basicSize = 1
	
****Object >> basicAt: posArg
	$object_basicAt
*****[test.m]
	self assert: (a basicAt: 0) = #a
	
****Object >> basicAt: posArg put: objectArg
	$object_basicAt_put
*****[test.m]
	a basicAt: 0 put: #b;
	self assert: a a = #b
	
****Object >> hash
	$object_hash
*****[man.m]
******#en
Return the receiver's hash value.
******#ja
レシーバーのハッシュ値を返す。
*****[test.m]
	self assert: a hash = 123
	
****Object >> hash: valueArg
	$object_sethash
*****[man.m]
******#en
Set valueArg to the receiver's hash value (0-0xfffff).

The hash value is set appropriately at object construction.
Since the hash values of objects that succeed in equivalence judgment must match, it is necessary to re-set at an appropriate timing in a class in which equivalence judgment is redefined.
******#ja
valueArgをレシーバーのハッシュ値(0〜0xfffff)に設定する。

ハッシュ値はオブジェクト構築時に適当に設定される。
同値判定に成功するオブジェクト同士のハッシュ値は一致しなくてはならない為、同値判定を再定義したクラスでは適切なタイミングで再設定する必要がある。
*****[test.m]
	 a hash: 456;
	 self assert: a hash = 456
	 
****Object >> perform: selectorArg args: fixedArrayArg
	$object_perform_args
*****[test.m]
	a perform: #a: args: #(#c);
	self assert: a a = #c
	
****Object >> performMethod: methodArg args: fixedArrayArg
	$object_performMethod_args
*****[test.m]
	a performMethod: (a class methodOf: #a:) args: #(#d);
	self assert: a a = #d

****Object >> primLastError
	$object_primLastError
	
***accessing.
****Object >> = objectArg
	$object_equal -- self == objectArg!
*****[man.m]
******#en
Returns true if the receiver and objectArg have the same value.

Overwrite this method if there is a class-specific equivalence decision.
******#ja
レシーバーとobjectArgが同じ値を持つ場合にtrueを返す。

クラス固有の同値判定があれば、このメソッドを上書きする。
*****[test.m]
	self assert: a = a;
	self assert: (a = nil) not
	
****Object >> <> objectArg
	self = objectArg, not!
*****[man.m]
******#en
Returns true if the receiver and objectArg are not equal.
******#ja
レシーバーとobjectArgが等しくない場合にtrueを返す。
*****[test.m]
	self assert: a <> nil;
	self assert: (a <> a) not
	
****Object >> nil?
	nil = self!
*****[man.m]
******#en
Returns true if the receiver is nil.
******#ja
レシーバーがnilならばtrueを返す。
*****[test.m]
	self assert: nil nil?;
	self assert: (a nil?) not
	
****Object >> notNil?
	self nil? not!
*****[man.m]
******#en
Returns true of the receiver is not nil.
******#ja
レシーバーがnilで無い場合にtrueを返す。
*****[test.m]
	self assert: a notNil?;
	self assert: (nil notNil?) not
	
****Object >> kindOf?: classArg
	self class hierarchies anySatisfy?: [:cl cl = classArg]!
*****[man.m]
******#en
Returns true if the receiver is an instance of classArg or its subclass.
******#ja
レシーバーがclassArgもしくはそのサブクラスのインスタンスならtrueを返す。
*****[test.m]
	Test.B new ->:b;
	self assert: (b kindOf?: Test.A);
	self assert: (a kindOf?: Test.B) not
	
****Object >> memberOf?: classArg
	self class = classArg!
*****[man.m]
******#en
Returns true if the receiver is an instance of classArg.
******#ja
レシーバーがclassArgのインスタンスならtrueを返す。
*****[test.m]
	Test.B new ->:b;
	self assert: (b memberOf?: Test.B);
	self assert: (b memberOf?: Test.A) not

***printings.
****Object >> printOn: writerArg
	--ToDo: if class name starts [aiueo], print "an"+classname
	writerArg put: 'a', put: self class
*****[test.m]
	a printOn: (StringWriter new ->:w);
	self assert: w asString = "aTest.A"
	
****Object >> asString
	StringWriter new put: self, asString!
*****[man.m]
******#en
Returns a String representing the receiver.
******#ja
レシーバーを表現するStringを返す。
*****[test.m]
	self assert: a asString = "aTest.A"
	
****Object >> describeOn: writerArg
	self printOn: writerArg
*****[test.m]
	a describeOn: (StringWriter new ->:w);
	self assert: w asString = "aTest.A"
	
****Object >> describe
	LimitableStringWriter new ->:writer;
	[self describeOn: writer] on: LimitableStringWriterOverrun do:
		[:e
		writer limit: 512;
		writer put: "..."];
	writer asString!
*****[man.m]
******#en
Return a debug representation of the receiver.

It is more detailed than asString.
******#ja
レシーバーのデバッグ向けの表現を返す。

asStringよりは詳しい内容となる。
*****[test.m]
	self assert: a describe = "aTest.A"
*****[test.m] overrun
	self assert: (FixedArray basicNew: 1000) describe size = 259

***inspects.
****Object >> basicInspect
	Out putLn: self describe;
	self class allInstanceVars ->:ivs;
	ivs size timesDo:
		[:i
		Out put: i, put: ' ', put: (ivs at: i), put: ' ',
			putLn: (self basicAt: i) describe]

****Object >> inspect
	self basicInspect
*****[man.m]
******#en
Display the internal structure of an object.
******#ja
オブジェクトの内部構造を表示する。

***perform indirect.
****Object >> performMethod: methodArg
	self performMethod: methodArg args: nil!
*****[test.m]
	self assert: (a performMethod: (Test.A methodOf: #a)) = #a
	
****Object >> perform: selectorArg
	self perform: selectorArg args: nil!
*****[man.m]
******#en
Send the Symbol selectorArg to the receiver.
******#ja
レシーバーにSymbol selectorArgを送信する。
*****[test.m]
	self assert: (a perform: #a) = #a
	
****Object >> perform: selectorArg with: arg
	self perform: selectorArg args: (FixedArray basicNew: 1, at: 0 put: arg)!
*****[man.m]
******#en
Send Symbol selectorArg and one argument arg to the receiver.
******#ja
レシーバーにSymbol selectorArgと一つの引数argを送信する。
*****[test.m]
	a perform: #a: with: #b;
	self assert: a a = #b
	
****Object >> perform: selectorArg with: arg0 with: arg1
	self perform: selectorArg args:
		(FixedArray basicNew: 2, at: 0 put: arg0, at: 1 put: arg1)!
*****[man.m]
******#en
Send the Symbol selectorArg and two arguments arg0 and arg1 to the receiver.
******#ja
レシーバーにSymbol selectorArgと二つの引数arg0, arg1を送信する。
*****[test.m]
	Test.B new ->:b;
	b perform: #a:b: with: #x with: #y;
	self assert: (b a = #x) & (b b = #y)
	
****Object >> respondsTo?: selectorArg
	self class findPerformMethod: selectorArg, notNil?!
*****[test.m]
	self assert: (a respondsTo?: #a);
	self assert: (a respondsTo?: #b) not
	
***evaluate and repl.
****Object >> evalReader: readerArg
	MethodCompiler new compileBody: readerArg class: self class ->:m;
	self performMethod: m!
*****[man.m]
******#en
Read the Mulk syntax rules statement from the readerArg and run the receiver as self.
******#ja
readerArgからMulk構文規則のstatementを読み込み、レシーバーをselfとして実行する。
*****[test.m]
	a evalReader: (StringReader new init: "#b ->a");
	self assert: a a = #b
	
****Object >> eval: stringArg
	self evalReader: (StringReader new init: stringArg)!
*****[man.m]
******#en
Execute Mulk statement stringArg under the receiver.
******#ja
Mulk命令文stringArgをレシーバーの下で実行する。
*****[test.m]
	a eval: "#c ->a";
	self assert: a a = #c
	
****Object >> evalExpr: stringArg
	self eval: stringArg + '!'!
*****[man.m]
******#en
Execute Mulk statement stringArg under the receiver and return the value of the last expression.
******#ja
Mulk命令文stringArgをレシーバーの下で実行し、最後の式の値を返す。
*****[test.m]
	self assert: (a evalExpr: "a") = #a

****Object >> evalAndPrint: stringArg
	self eval: stringArg ->:result, <> self ifTrue:
		[Out putLn: result describe;
		result ->_last]
****Object >> repl
	[
		Out put: self describe + '>';
		In getLn ->:stmts, nil? or: [stmts = "!"], ifTrue: [self!];
		[self evalAndPrint: stmts] on: Error do:
			[:e
			e printStackTrace;
			Out putLn: e message]
	] loop
*****[man.m]
******#en
Enter interactive mode (read eval print loop) for the receiver.

In interactive mode, it evaluates statements entered at the prompt.
At this time, if the evaluation result is not self, it is displayed and set in the global variable _last.

Enter EOF or a line containing only '!' at the prompt to terminate.
******#ja
レシーバーに対して対話モード(read eval print loop)に入る。

対話モードではプロンプトに対して入力されたステートメントを評価する。
この時、評価結果がselfでない場合はそれを表示し、グローバル変数_lastに設定する。

プロンプトに対しEOFか'!'のみの行を入力すると終了する。

***error and exceptions.
****Object >> signalError: messageArg
	Error new message: messageArg, signal
*****[test.m]
	self assertError: [a signalError: "x"] message: "x"

****Object >> assertFailed
	self signalError: "assertFailed"
*****[man.m]
******#en
Raises an assertFailed error.
It is used when an argument or an internal state is abnormal, or a process that can not be reached is executed.
******#ja
assertFailedエラーを発生させる。
引数や内部状態の異常、到達し得ない処理が実行された場合等に用いる。
*****[test.m]
	self assertError: [a assertFailed] message: "assertFailed"

****Object >> assert: exprArg
	exprArg ifFalse: [self assertFailed]
*****[man.m]
******#en
If exprArg is false, raises an assertFailed error.
******#ja
exprArgがfalseならassertFailedエラーを発生させる。
*****[test.m]
	a assert: true;
	self assertError: [a assert: false] message: "assertFailed"

****Object >> doesNotUnderstand: args
	self signalError: self describe + " doesNotUnderstand: " + args describe
*****[test.m]
	self assertError: [a x]
		message: "aTest.A doesNotUnderstand: aFixedArray(#x)"

****Object >> primitiveFailed: args
	self signalError: self describe + " primitiveFailed: " + args describe
*****[test.m]
	self assertError: [a perform: 0]
		message: "aTest.A primitiveFailed: aFixedArray(#perform:args: 0 nil)"

****Object >> error: messageArg
	self signalError: messageArg
*****[man.m]
******#en
Raises an error with messageArg.
******#ja
messageArgでエラーを発生させる。
*****[test.m]
	self assertError: [a error: "xx"] message: "xx"

***serialize.
****Object >> serializeTo: writerArg
	self basicSize timesDo: [:i writerArg putObjectRef: (self basicAt: i)]
****Object >> serializeBytesTo: writerArg
	self basicSize timesDo: [:i writerArg putByte: (self basicAt: i)]

***Object >> setTo: globalVarArg
	globalVarArg set: self
****[test.m]
	GlobalVar new ->:gv;
	#a setTo: gv;
	self assert: gv get = #a
	
***optimize.
****Object >> _inc
	self + 1!
*****[test.m]
	10 ->a;
	self assert: a + 1 = 11;
	self assert: 1 + a = 11
	
**Classes.
***Class class.#
{ib.c/make_initial_objects:
	class Class Object : name size superclass features instanceVars methods;
}

****[man.c]
*****#en
Class of class object.

All class objects are instances of Class class.
Class objects are global objects and can be referenced from any part of the program by the class name.

When declaring a new class, send an addSubclass:(instanceVars:) message to the superclass object.
*****#ja
クラスオブジェクトのクラス。

全てのクラスオブジェクトはClassのインスタンスである。
クラスオブジェクトはグローバルオブジェクトであり、クラス名によってプログラムの任意の箇所から参照出来る。

新たなクラスを宣言する場合は、スーパークラスのクラスオブジェクトにaddSubclass:(instanceVars:)メッセージを送信する。

****attributes.
*****Class >> name
	name!
******[test.m]
	self assert: Test.A name = #Test.A
	
*****Class >> size
	size!
******[test.m]
	self assert: Test.A size = 1;
	self assert: ShortInteger size = 255
	
*****Class >> special?
	size >= 248 {om.h SIZE_LAST}!
******[test.m]
	self assert: Test.A special? not;
	self assert: ShortInteger special?
	
*****Class >> variableSize?
	size between: 251 and: 254! {om.h SIZE_FBARRAY - SIZE_FARRAY}
******[test.m]
	self assert: Test.A variableSize? not;
	self assert: FixedArray variableSize?
	
*****Class >> superclass
	superclass!
******[test.m]
	self assert: Test.A superclass = Object;
	self assert: Object superclass nil?
	
*****Class >> instanceVars
	instanceVars!
******[test.m]
	self assert: Test.A instanceVars = "a"
	
****instance creation.
*****Class >> basicNew: optionArg
	$class_basicNew
******[man.m]
*******#en
Construct an instance of the receiver with arguments.

It must not be used unless expressly stated otherwise.
*******#ja
引数付きでレシーバーのインスタンスを構築する。

明示されている場合を除き使用してはならない。
******[test.m]
	self assert: (FixedByteArray basicNew: 1) size = 1
	
*****Class >> new
	self basicNew: 0, init!
******[man.m]
*******#en
Construct an instance of the receiver.

Instances are initialized by the init method after construction.
*******#ja
レシーバーのインスタンスを構築する。

インスタンスは構築後にinitメソッドによって初期化される。
******[test.m]
	self assert: (Test.A new memberOf?: Test.A)
	
****Class >> printOn: writerArg
	writerArg put: name
*****[test.m]
	self assert: Test.A asString = "Test.A"
	
****Class >> hierarchies
	Iterator new init:
		[:b
		self ->:cl;
		[cl notNil?] whileTrue: 
			[b value: cl;
			cl superclass ->cl]]!
*****[test.m]
	self assert: (Test.A hierarchies asArray asString = "Test.A Object")
	
****Class >> allInstanceVars
	Array new ->:result;
	self hierarchies reverse do:
		[:cl
		cl instanceVars notNil? ifTrue: 
			[result addAll: (cl instanceVars split: ' ')]];
	result!
*****[test.m]
	self assert: Test.B allInstanceVars asString = "a b"
	
****Class >> subclasses
	Mulk select: [:c c memberOf?: Class, and: [c superclass = self]]!
*****[test.m]
	self assert: Test.A subclasses asArray asString = "Test.B"
	
****methods.
*****Class >> methods
	methods nil?
		ifTrue: [Array new]
		ifFalse: [methods selectAsArray: [:m m notNil?]]!
******[test.m]
	self assert: Test.A methods asString
		= "aMethod(Test.A >> a:) aMethod(Test.A >> a)"
		
*****Class >> methodIndexOf: selectorArg
	methods findFirst:
		[:m
		m nil? ifTrue: [nil!];
		m selector = selectorArg]!
******[test.m]
	self assert: (Test.A methodIndexOf: #a) = 1;
	self assert: (Test.A methodIndexOf: #b) nil?
	
*****Class >> methodOf: selectorArg
	self methodIndexOf: selectorArg ->:ix, nil?
		ifTrue: [nil]
		ifFalse: [methods at: ix]!
******[test.m]
	self assert: (Test.A methodOf: #a) selector = #a;
	self assert: (Test.A methodOf: #b) nil?

*****Class >> findFeatureMethod: selectorArg
	--see ip.c/find_method_feature
	features nil? ifTrue: [nil!];
	features do:
		[:f
		f methodOf: selectorArg ->:result, notNil? ifTrue: [result!];
		f findFeatureMethod: selectorArg ->result, notNil? ifTrue: [result!]];
	nil!
******[test.m]
	Number findFeatureMethod: #> ->:m;
	self assert: m selector = #> & (m belongClass = Magnitude);
	self assert: (ShortInteger findFeatureMethod: #>) nil?
	
*****Class >> findPerformMethod: selectorArg
	--see ip.c/find_method_main
	self hierarchies do:
		[:c
		c methodOf: selectorArg ->:result, notNil? ifTrue: [result!];
		c findFeatureMethod: selectorArg ->result, notNil? ifTrue: [result!]];
	nil!
******[test.m]
	Test.B findPerformMethod: #a ->:m;
	self assert: m selector = #a & (m belongClass = Test.A)
	
*****Class >> addMethod: methodArg
	methods nil? ifTrue: [FixedArray basicNew: 4 ->methods];
	self methodIndexOf: methodArg selector ->:i, nil? ifTrue:
		[methods indexOf: nil ->i, nil? ifTrue:
			[methods size ->i;
			FixedArray basicNew: i * 2,
				basicAt: 0 copyFrom: methods at: 0 size: i ->methods]];
	methods at: i put: methodArg;
	Kernel cacheReset: methodArg selector
*****Class >> removeMethod: selectorArg
	self methodIndexOf: selectorArg ->:p1;
	self assert: p1 notNil?;
	methods findLast: [:m m notNil?] ->:p2;
	methods at: p1 put: (methods at: p2);
	methods at: p2 put: nil;
	Kernel cacheReset: selectorArg

****subclass creation.
*****Class >> initName: nameArg size: sizeArg superclass: superclassArg 
		instanceVars: instanceVarsArg
	nameArg ->name;
	sizeArg ->size;
	superclassArg ->superclass;
	instanceVarsArg ->instanceVars

*****Class >> addSubclass: nameArg instanceVars: instanceVarsArg
	self assert: self special? not;
	self assert: (nameArg memberOf?: Symbol);
	
	self allInstanceVars ->:ivs;
	instanceVarsArg notNil? ifTrue:
		[ivs addAll: (instanceVarsArg split: ' ');
		size until: ivs size, do:
			[:i
			ivs at: i ->:v;
			ivs indexOf: v, <> (ivs lastIndexOf: v) ifTrue:
				[self error: "duplicate instance var " + v]]];
	Class new initName: nameArg size: ivs size superclass: self
		instanceVars: instanceVarsArg ->:result;
	{note: if class overwrite, it's instance must be gone.}
	Mulk at: nameArg put: result;
	result!
******[man.m]
*******#en
Create a subclass of receiver class named Symbol nameArg.

Specify instance variable name by String instanceVarsArg.
If you have multiple instance variables, separate the variable names with blanks.
*******#ja
Symbol nameArgを名称とするレシーバークラスのサブクラスを作成する。

String instanceVarsArgでインスタンス変数名を指定する。
複数のインスタンス変数を持つ場合は変数名を空白で区切る。
******[test.m]
	self assertError: [Test.A addSubclass: #E instanceVars: "a"]
		message: "duplicate instance var a"

*****Class >> addSubclass: nameArg
	self addSubclass: nameArg instanceVars: nil!
******[man.m]
*******#en
Create a subclass of receiver class named Symbol nameArg.
*******#ja
Symbol nameArgを名称とするレシーバークラスのサブクラスを作成する。
******[test.m]
	self assertError: [Object addSubclass: Object] message: "assertFailed";
	self assertError: [ShortInteger addSubclass: #E] message: "assertFailed"

*****Class >> features
	features!
******[man.m]
*******#en
Return the feature list of the receiver.

Returns nil if it has no features.
*******#ja
レシーバーのフィーチャーリストを返す。

フィーチャーを持たない場合はnilを返す。
******[test.m]
	self assert: Number features first = Magnitude;
	self assert: Test.A features nil?
	
*****Class >> features: featuresArg
	featuresArg memberOf?: FixedArray,
		ifTrue: [featuresArg do: [:f self assert: f superclass = Feature]]
		ifFalse: [self assert: featuresArg nil?];
	featuresArg ->features;
	Kernel cacheReset: nil
******[man.m]
*******#en
Let featuresArg be the feature list of the receiver.

featuresArg must be a nil or FixedArray whose element is Feature subclass object.
*******#ja
レシーバーのフィーチャーリストをfeaturesArgとする。

featuresArgはnilもしくはFeatureのサブクラスオブジェクトを要素とするFixedArrayでなくてはならない。

****Class >> serializeTo: writerArg
	methods notNil? and: [methods indexOf: nil ->:s, notNil?], ifTrue:
		[methods copyUntil: s ->methods];
	super serializeTo: writerArg

***Feature class.#
	class Feature Object;
****[man.c]
*****#en
Base class for features.

Every feature must be a direct subclass of Feature and can not have instance variables.
*****#ja
フィーチャーの基底クラス。

全てのフィーチャーはFeatureの直接のサブクラスでなくてはならず、インスタンス変数を持つ事は出来ない。

**Nil class.#
{ib.c/make_initial_objects:
	class Nil Object;
		singleton Nil nil;
}
***[man.c]
****#en
Class defines nil.

nil is an object that indicates that it does not refer to other objects.
Variables and array elements are in principle initialized with nil.

nil is a global object and should not be reconstruct.
****#ja
nilを定義するクラス。

nilは他のオブジェクトを参照していない事を示すオブジェクトである。
変数や配列要素は原則としてnilで初期化される。

nilはグローバルオブジェクトであり、再構築してはならない。
***Nil >> printOn: writerArg
	writerArg put: "nil"
****[test.m]
	self assert: nil asString = "nil"
	
**Booleans.
***Boolean class.#
	class Boolean Object;

****[man.c]
*****#en
Base class for booleans.

Provides various boolean operations.
*****#ja
論理値の基底クラス。

様々な論理演算を提供する。
****[test] Test.Boolean class.@
	UnitTest addSubclass: #Test.Boolean instanceVars:
		"w tBlock fBlock tValue fValue"
*****Test.Boolean >> setup
	StringWriter new ->w;
	[w put: 't'; true] ->tBlock;
	[w put: 'f'; false] ->fBlock;
	true ->tValue;
	false ->fValue

****Boolean >> ifTrue: trueBlockArg ifFalse: falseBlockArg
	self shouldBeImplemented
*****[man.m]
******#en
Evaluate trueBlockArg if the receiver is true, otherwise evaluate falseBlockArg.
******#ja
レシーバーがtrueならtrueBlockArgを、さもなくばfalseBlockArgを評価する。

****Boolean >> ifTrue: trueBlockArg
	self ifTrue: trueBlockArg ifFalse: [self]!
*****[man.m]
******#en
Evaluate trueBlockArg if the receiver is true.
******#ja
レシーバーがtrueならtrueBlockArgを評価する。
*****[test.m] 1
	fValue ifTrue: tBlock;
	self assert: w asString = ""
*****[test.m] 1.inline
	fValue ifTrue: [w put: 't'];
	self assert: w asString = ""
*****[test.m] 1.inline2
	false ifTrue: [w put: 't'];
	self assert: w asString = ""
*****[test.m] 2
	tValue ifTrue: tBlock;
	self assert: w asString = "t"
*****[test.m] 2.inline
	tValue ifTrue: [w put: 't'];
	self assert: w asString = "t"
*****[test.m] 2.inline2
	true ifTrue: [w put: 't'];
	self assert: w asString = "t"
	
****Boolean >> ifFalse: falseBlockArg
	self ifTrue: [self] ifFalse: falseBlockArg!
*****[man.m]
******#en
Evaluate falseBlockArg is the receiver if false.
******#ja
レシーバーがfalseならfalseBlockArgを評価する。
*****[test.m] 1
	tValue ifFalse: fBlock;
	self assert: w asString = ""
*****[test.m] 1.inline
	tValue ifFalse: [w put: 'f'];
	self assert: w asString = ""
*****[test.m] 1.inline2
	true ifFalse: [w put: 'f'];
	self assert: w asString = ""
*****[test.m] 2
	fValue ifFalse: fBlock;
	self assert: w asString = "f"
*****[test.m] 2.inline
	fValue ifFalse: [w put: 'f'];
	self assert: w asString = "f"
*****[test.m] 2.inline2
	false ifFalse: [w put: 'f'];
	self assert: w asString = "f"

****Boolean >> not
	self = false!
*****[man.m]
******#en
Returns the negative value of the receiver.
******#ja
レシーバーの否定値を返す。
*****[test.m]
	self assert: true not = false;
	self assert: false not = true

****Boolean >> & booleanArg
	self ifTrue: [booleanArg] ifFalse: [false]!
*****[man.m]
******#en
Returns the logical AND of receiver and booleanArg.
******#ja
レシーバーとbooleanの論理積を返す。
*****[test.m]
	self assert: true & true;
	self assert: (false & true) not;
	self assert: (true & false) not;
	self assert: (false & false) not

****Boolean >> and: blockArg
	self ifTrue: [blockArg value] ifFalse: [false]!
*****[man.m]
******#en
Returns the logical AND of receiver and blockArg evaluation results.

If the receiver is false, the blockArg is not evaluated.
******#ja
レシーバーとblockArgの評価結果の論理和を返す。

レシーバーがfalseの場合、blockArgは評価されない。
*****[test.m] 1
	self assert: (tValue and: tBlock);
	self assert: w asString = "t"
*****[test.m] 1.inline
	self assert: (tValue and: [w put: 't'; true]);
	self assert: w asString = "t"
*****[test.m] 1.inline2
	self assert: (true and: [w put: 't'; true]);
	self assert: w asString = "t"
*****[test.m] 2
	self assert: (fValue and: tBlock) not;
	self assert: w asString = ""
*****[test.m] 2.inline
	self assert: (fValue and: [w put: 't'; true]) not;
	self assert: w asString = ""
*****[test.m] 2.inline2
	self assert: (false and: [w put: 't'; true]) not;
	self assert: w asString = ""
*****[test.m] 3
	self assert: (tValue and: fBlock) not;
	self assert: w asString = "f"
*****[test.m] 3.inline
	self assert: (tValue and: [w put: 'f'; false]) not;
	self assert: w asString = "f"
*****[test.m] 3.inline2
	self assert: (true and: [w put: 'f'; false]) not;
	self assert: w asString = "f"
*****[test.m] 4
	self assert: (fValue and: fBlock) not;
	self assert: w asString = ""
*****[test.m] 4.inline
	self assert: (fValue and: [w put: 'f'; false]) not;
	self assert: w asString = ""
*****[test.m] 4.inline2
	self assert: (false and: [w put: 'f'; false]) not;
	self assert: w asString = ""

****Boolean >> | booleanArg
	self ifTrue: [true] ifFalse: [booleanArg]!
*****[man.m]
******#en
Returns the logical OR of receiver and booleanArg.
******#ja
レシーバーとbooleanArgの論理和を返す。
*****[test.m]
	self assert: true | true;
	self assert: false | true;
	self assert: true | false;
	self assert: (false | false) not

****Boolean >> or: blockArg
	self ifTrue: [true] ifFalse: [blockArg value]!
*****[man.m]
******#en
Returns the logical OR of receiver and blockArg evaluation results.

If the receiver is true, the blockArg is not evaluated.
******#ja
レシーバーとblockArgの評価値の論理和を返す。

レシーバーがtrueの場合、blockArgは評価されない。
*****[test.m] 1
	self assert: (tValue or: tBlock);
	self assert: w asString = ""
*****[test.m] 1.inline
	self assert: (tValue or: [w put: 't'; true]);
	self assert: w asString = ""
*****[test.m] 1.inline2
	self assert: (true or: [w put: 't'; true]);
	self assert: w asString = ""
*****[test.m] 2
	self assert: (fValue or: tBlock);
	self assert: w asString = "t"
*****[test.m] 2.inline
	self assert: (fValue or: [w put: 't'; true]);
	self assert: w asString = "t"
*****[test.m] 2.inline2
	self assert: (false or: [w put: 't'; true]);
	self assert: w asString = "t"
*****[test.m] 3
	self assert: (tValue or: fBlock);
	self assert: w asString = ""
*****[test.m] 3.inline
	self assert: (tValue or: [w put: 'f'; false]);
	self assert: w asString = ""
*****[test.m] 3.inline2
	self assert: (true or: [w put: 'f'; false]);
	self assert: w asString = ""
*****[test.m] 4
	self assert: (fValue or: fBlock) not;
	self assert: w asString = "f"
*****[test.m] 4.inline
	self assert: (fValue or: [w put: 'f'; false]) not;
	self assert: w asString = "f"
*****[test.m] 4.inline2
	self assert: (false or: [w put: 'f'; false]) not;
	self assert: w asString = "f"

***True class.#
	class True Boolean;
		singleton True true;

****[man.c]
*****#en
Class defines true.

true is a global object and should not be reconstruct.
*****#ja
trueを定義するクラス。

trueはグローバルオブジェクトであり、再構築してはならない。
****[test] Test.True class.@
	Test.Boolean addSubclass: #Test.True
	
****True >> ifTrue: trueBlockArg ifFalse: falseBlockArg
	trueBlockArg value!
*****[test.m]
	tValue ifTrue: tBlock ifFalse: tBlock;
	self assert: w asString = "t"
*****[test.m] inline
	tValue ifTrue: [w put: 't'] ifFalse: [w put: 'f'];
	self assert: w asString = "t"
*****[test.m] inline2
	true ifTrue: [w put: 't'] ifFalse: [w put: 'f'];
	self assert: w asString = "t"
	
****True >> printOn: writerArg
	writerArg put: "true"
*****[test.m]
	self assert: true asString = "true"
	
***False class.#
	class False Boolean;
		singleton False false;

****[man.c]
*****#en
Class defines false.

false is a global object and should not be reconstruct.
*****#ja
falseを定義するクラス。

falseはグローバルオブジェクトであり、再構築してはならない。
****[test] Test.False class.@
	Test.Boolean addSubclass: #Test.False
	
****False >> ifTrue: trueBlockArg ifFalse: falseBlockArg
	falseBlockArg value!
*****[test.m]
	fValue ifTrue: tBlock ifFalse: fBlock;
	self assert: w asString = "f"
*****[test.m] inline
	fValue ifTrue: [w put: 't'] ifFalse: [w put: 'f'];
	self assert: w asString = "f"
*****[test.m] inline2
	false ifTrue: [w put: 't'] ifFalse: [w put: 'f'];
	self assert: w asString = "f"
	
****False >> printOn: writerArg
	writerArg put: "false"
*****[test.m]
	self assert: false asString = "false"

*Kernel protocols.
**[man.s]
***#en
Kernel protocols define internal components.
***#ja
Kernel protocolsは内部的な構成要素を定義する。

**Kernel.class class.#
	class Kernel.class Object : cycle usedMemory maxUsedMemory
		objectCount maxObjectCount
		cacheSize cacheEntry cacheCall cacheHit cacheInvalidate;
		singleton Kernel.class Kernel;
***Kernel.class >> currentProcess
	$kernel_currentProcess
***Kernel.class >> cacheReset: selectorArg
	$kernel_cacheReset
***Kernel.class >> sync
	$kernel_sync
***Kernel.class >> cycle
	self sync;
	cycle!
***Kernel.class >> inspect
	self sync;
	super inspect
		
**OS.class class.#
	class OS.class Object : fps timediff;
		singleton OS.class OS;
***[man.c]
****#en
Class that defines the OS object.

The OS abstracts the host system and provides access to its functions.

The OS is a global object and must not be reconstructed.
****#ja
OSを定義するクラス。

OSはホストシステムを抽象し、機能へのアクセスを提供する。

OSはグローバルオブジェクトであり、再構築してはならない。

***OS.class >> init
	Set new ->fps;
	self propertyAt: 3 ->timediff

***fopen.
****OS.class >> basicFopen: fnArg mode: modeArg
	$os_fopen
****OS.class >> fopen: fnArg mode: modeArg
	self basicFopen: fnArg mode: modeArg ->:fp;
	fps add: fp;
	fp!
	
***OS.class >> fgetc: fpArg
	$os_fgetc
***OS.class >> fputc: byte fp: fpArg
	$os_fputc
***OS.class >> fread: bufArg from: fromArg size: sizeArg fp: fpArg
	$os_fread
***OS.class >> fgets: fpArg
	$os_fgets
***OS.class >> fwrite: bufArg from: fromArg size: sizeArg fp: fpArg
	$os_fwrite
***OS.class >> fseek: fpArg offset: offArg
	$os_fseek
***OS.class >> ftell: fpArg
	$os_ftell

***fclose.
****OS.class >> basicFclose: fpArg
	$os_fclose
****OS.class >> fclose: fpArg
	fps remove: fpArg;
	self basicFclose: fpArg
	
***OS.class >> stat: fnArg
	$os_stat
***OS.class >> utime: fnArg mtime: timeArg
	$os_utime
***OS.class >> chdir: pathArg
	$os_chdir
***OS.class >> readdir: pathArg
	$os_readdir
***OS.class >> remove: pathArg
	$os_remove
***OS.class >> mkdir: pathArg
	$os_mkdir
	
***OS.class >> time
	$os_time
****[man.m]
*****#en
Returns the number of seconds since the Unix epoch (January 1, 1970, 00:00:00 UTC).
*****#ja
現時刻のUnix epoch(協定世界時 1970年1月1日0時0分0秒)からの相対秒数を返す。

***OS.class >> timediff
	timediff!
***OS.class >> clock
	$os_clock
***OS.class >> system: stringArg
	$os_system
	
***OS.class >> getenv: envArg
	$os_getenv
****[man.m]
*****#en
Returns the value of the environment variable envArg.

Returns nil if envArg is not in the current environment.
*****#ja
環境変数envArgの値を返す。

envArgが現在の環境に無い場合はnilを返す。

***OS.class >> putenv: envArg
	$os_putenv
****[man.m]
*****#en
Change/update environment variables.

envArg is a string of "variable name=value".
*****#ja
環境変数を変更・更新する。

envArgは"変数名=値"の文字列とする。
****[test.m]
	OS putenv: "mulktest=";
	self assert: (OS getenv: "mulktest" ->:mt) nil? | (mt = "");
	OS putenv: "mulktest=test";
	self assert: (OS getenv: "mulktest") = "test"

***OS.class >> propertyAt: ix
	$os_propertyAt
	
***OS.class >> fcloseAll
	fps asArray do: [:fp self fclose: fp]
****[man.m]
*****#en
Close all file streams.
*****#ja
全てのファイルストリームを閉じる。
	
**Method class.#
	class Method Object : belongClass selector attr bytecodeSize;
	-- note: a Method has literal and bytecode area.
	-- if release it with illegal bytecodeSize make fault.
***[test] Test.Method class.@
	UnitTest addSubclass: #Test.Method instanceVars: "m"
****Test.Method >> setup
	Test.A methodOf: #a: ->m

***Method >> bytecodeAt: posArg
	$method_bytecodeAt
***Method >> bytecodeAt: posArg put: valArg
	$method_bytecodeAt_put
***Method >> bytecodeSize
	bytecodeSize!
***Method >> serializeTo: writerArg
	super serializeTo: writerArg;
	bytecodeSize timesDo: [:i writerArg putByte: (self bytecodeAt: i)]
***Method >> initSelector: selectorArg argCount: argCountArg 
		belongClass: belongClassArg primCode: primCodeArg
		extTempSize: extTempSizeArg contextSize: contextSizeArg
		bytecode: bytecodeArg literal: literalArg
	selectorArg ->selector;
	belongClassArg ->belongClass;
	bytecodeArg size ->bytecodeSize;
	--see om.h
	argCountArg | (extTempSizeArg << 4) | (contextSizeArg << 12) 
		| (primCodeArg << 20) ->attr;

	literalArg size timesDo: 
		[:li self basicAt: li + 4 put: (literalArg at: li)];
	bytecodeArg size timesDo: 
		[:bi self bytecodeAt: bi put: (bytecodeArg at: bi)]
***Method >> belongClass
	belongClass!
****[test.m]
	self assert: m belongClass = Test.A

***Method >> selector
	selector!
****[test.m]
	self assert: m selector = #a:
	
***Method >> printSignatureOn: writerArg
	writerArg put: belongClass, put: " >> ", put: selector
****[test.m]
	m printSignatureOn: (StringWriter new ->:w);
	self assert: w asString = "Test.A >> a:"
	
***Method >> printOn: writerArg
	super printOn: writerArg;
	writerArg put: '(';
	self printSignatureOn: writerArg;
	writerArg put: ')'
****[test.m]
	self assert: m asString = "aMethod(Test.A >> a:)"
	
**Context class.#
	class Context Object :
		method sp cp {localVars};

***[test] Test.Context class.@
	UnitTest addSubclass: #Test.Context instanceVars: "cx"
****Test.Context >> setup
	[0 ->:a]; --to make context.
	Kernel currentProcess basicAt: 0 ->cx --getContext of setup

***Context >> method
	method!
****[test.m]
	self assert: cx method asString = "aMethod(Test.Context >> setup)"
	
***Context >> printOn: writerArg
	super printOn: writerArg;
	writerArg put: '(';
	method printSignatureOn: writerArg;
	writerArg put: ')'
****[test.m]
	self assert: cx asString = "aContext(Test.Context >> setup)"
	
***Context >> serializeTo: writerArg
	-- note: can't serialize, because Context has variable field.
	-- see: ImageWriter >> putObject
	self assertFailed
****[test.m]
	self assertError: [cx serializeTo: nil] message: "assertFailed"
	
**Block class.#
	class Block Object :
		context narg start;
	
***[man.c]
****#en
Block class.

Achieve closure and provide delay evaluation and various control structures.
An instance of Block is generated as a value of block syntax.
****#ja
ブロッククラス。

閉包を実現し、遅延評価や様々な制御構造を提供する。
Blockのインスタンスはブロック構文の値として生成される。

***Block >> valueArgs: fixedArrayArg
	$block_valueArgs
****[test.m]
	[:a :b :c a + b + c] ->:block;
	self assert: (block valueArgs: #(100 10 1)) = 111;
	self assert: (block valueArgs: #("a" "b" "c")) = "abc"

***Block >> value
	$block_value
****[man.m]
*****#en
Evaluate the receiver and return the result.
*****#ja
レシーバーを評価し、その結果を返す。
****[test.m]
	self assert: [111] value = 111

***Block >> value: arg
	$block_value1
****[man.m]
*****#en
Evaluate the receiver with one argument arg and return the result.
*****#ja
レシーバーを一つの引数argと共に評価し、その結果を返す。
****[test.m]
	self assert: ([:x 123 + x] value: 321) = 444

***Block >> value: arg0 value: arg1
	$block_value2
****[man.m]
*****#en
Evaluate the receiver with two arguments arg0 and arg1 and return the result.
*****#ja
レシーバーを二つの引数arg0, arg1と共に評価し、その結果を返す。
****[test.m]
	self assert: ([:x :y x + y] value: "a" value: "b") = "ab"

***Block >> value: arg0 value: arg1 value: arg2
	FixedArray basicNew: 3 ->:args;
	args at: 0 put: arg0;
	args at: 1 put: arg1;
	args at: 2 put: arg2;
	self valueArgs: args!
****[man.m]
*****#en
Evaluate the receiver with three arguments and return the result.
*****#ja
レシーバーを三つの引数と共に評価し、その結果を返す。
****[test.m]
	self assert: ([:x :y :z x + y + z] value: 1 value: 2 value: 3) = 6

***Block >> loop
.if ib
	self value
	$again
.else
	[self value] loop!
.end
****[man.m]
*****#en
Evaluate the receiver repeatedly.

Exit the loop when you finish the method with the return statement.
*****#ja
レシーバーを繰り返し評価する。

return文でメソッドを終了するとループから抜ける。
****[test.m]
	0 ->:i ->:sum;
	[i + sum ->sum;
	i + 1 ->i;
	i > 10 ifTrue: [self error: sum]] ->:block;
	self assertError: [block loop] message: 55
****[test.m] inline
	self assertError:
		[0 ->:i ->:sum;
		[i + sum ->sum;
		i + 1 ->i;
		i > 10 ifTrue: [self error: sum]] loop]
		message: 55

***Block >> whileTrue
	[self value ifFalse: [self!]] loop
****[man.m]
*****#en
Evaluate the receiver and repeat while the result is true.
*****#ja
レシーバーを評価し、結果がtrueなら繰り返す。
****[test.m]
	0 ->:i ->:sum;
	[i + sum ->sum; i + 1 ->i; i <= 10] ->:block;
	block whileTrue;
	self assert: sum = 55

***Block >> whileFalse
	[self value ifTrue: [self!]] loop
****[man.m]
*****#en
Evaluate the receiver and repeat while the result is false.
*****#ja
レシーバーを評価し、結果がfalseの間繰り返す。
****[test.m]
	0 ->:i ->:sum;
	[i + sum ->sum; i + 1 ->i; i > 10] ->:block;
	block whileFalse;
	self assert: sum = 55

***Block >> whileTrue: blockArg
	[self value ifFalse: [self!];
	blockArg value] loop
****[man.m]
*****#en
Evaluate the receiver and repeat the evaluation of blockArg while the result is true.
*****#ja
レシーバーを評価し、結果がtrueの間blockArgの評価を繰り返す。
****[test.m]
	0 ->:i ->:sum;
	[i + sum ->sum; i + 1 ->i] ->:block;
	[i <= 10] whileTrue: block;
	self assert: sum = 55
****[test.m] inline
	0 ->:i ->:sum;
	[i <= 10] whileTrue: [i + sum ->sum; i + 1 ->i];
	self assert: sum = 55

***Block >> whileFalse: blockArg
	[self value ifTrue: [self!];
	blockArg value] loop
****[man.m]
*****#en
Evaluate the receiver and repeat the evaluation of blockArg while the result is false.
*****#ja
レシーバーを評価し、結果がfalseの間blockArgの評価を繰り返す。
****[test.m]
	0 ->:i ->:sum;
	[i + sum ->sum; i + 1 ->i] ->:block;
	[i > 10] whileFalse: block;
	self assert: sum = 55
****[test.m] inline
	0 ->:i ->:sum;
	[i > 10] whileFalse: [i + sum ->sum; i + 1 ->i];
	self assert: sum = 55

***Block >> on: catchClassArg do: blockArg
	Kernel currentProcess ->:p;
	p addExceptionHandler: catchClassArg do: [:e blockArg value: e!] ->:tuple;
	self value ->:result;
	p removeExceptionHandler: tuple;
	result!
****[man.m]
*****#en
Evaluate the receiver, and if an exception of catchClassArg occurs during evaluation, evaluate blockArg using the exception as an argument.
*****#ja
レシーバーを評価し、評価中にcatchClassArgの例外が発生した場合は、例外を引数としてblockArgを評価する。
****[test.m]
	0 ->:count;
	[count + 1 ->count] on: Error do: [:e1 self assertFailed];
	[self error: "a"] on: Error do:
		[:e2 e2 message = "a" ifTrue: [count + 1 ->count]];
	self assert: count = 2

***Block >> finally: blockArg
	self on: Exception do:
		[:e
		blockArg value;
		e signal] ->:result;
	blockArg value;
	result!
****[man.m]
*****#en
Evaluate the receiver and evaluate the blockArg if an end or exception occurs.
*****#ja
レシーバーを評価し、終了もしくは例外が発生するとblockArgを評価する。
****[test.m]
	0 ->:count;
	[self] finally: [count + 1 ->count];
	[[self error: "a"] finally: [count + 1 ->count]] on: Error
		do: [:e e message = "a" ifTrue: [count + 1 ->count]];
	self assert: count = 3

**Exceptions.
***Exception class.#
	class Exception Object : message;
****[man.c]
*****#en
Base class for exceptions.

Exceptions provide a mechanism to control global escape.
By using Block >> on: do: or Block >> finally:, it is possible to catch the occurrence of exception during evaluation.
However, a block that is trying to catch an exception can not be terminated by a delayed evaluation using a return statement.
*****#ja
例外の基底クラス。

例外は大域脱出を制御する機構を提供する。
Block >> on:do:やBlock >> finally:を用いる事で、評価中の例外発生を捉える事が出来る。
ただし、例外を捕捉しようとしているブロックをreturn文による遅延評価で終了する事は出来ない。

****Exception >> signal
	Kernel currentProcess signal: self
*****[man.m]
******#en
Raise an exception.
******#ja
例外を発生させる。

****Exception >> message: messageArg
	messageArg ->message
*****[man.m]
******#en
Set the exception message.

The message can be used to explain the exception and inform the catcher.
******#ja
例外のメッセージを設定する。

メッセージは例外の説明や捕捉側への情報伝達に使用出来る。

****Exception >> message
	message!
*****[man.m]
******#en
Get the message set in message:.
******#ja
message:で設定されたメッセージを取得する。

***Error class.#
	class Error Exception : stackTrace;
****[man.c]
*****#en
Exception indicating that an error occurred.

If it occurs while executing repl or Cmd, you can abort the process and return to the prompt.
*****#ja
エラー発生を示す例外。

replやCmdの実行中に発生すると処理を打ち切ってプロンプトに戻る事が出来る。

****Error >> signal
	stackTrace nil? ifTrue: [Kernel currentProcess stackTrace ->stackTrace];
	super signal
****Error >> stackTrace
	stackTrace!
****Error >> printStackTrace
	stackTrace reverse do: [:m Out putLn: m]

***QuitException class.#
	class QuitException Exception;
****[man.c]
*****#en
Exception that terminates the system.

In principle, this exception is not caught and terminates the Mulk system itself.
*****#ja
システムを終了させる例外。

原則としてこの例外は捕捉されずMulk処理系自体を終了させる。

**Process class.#
	class Process Object :
		context method ip
		frameStack sp spUsed spMax fp
		contextStack cp cpUsed cpMax
		exceptionHandlers interruptBlock;
***Process >> resumeCp: cpArg sp: spArg
	$process_resumeCp_sp
***Process >> basicStart: selectorArg
	$process_basicStart
***Process >> basicSwitch
	$process_basicSwitch
***Process >> initExceptionHandlers
	Ring new ->exceptionHandlers
***Process >> addExceptionHandler: classArg do: blockArg
	Cons new car: classArg cdr: blockArg ->:result;
	exceptionHandlers addLast: result;
	result!
***Process >> removeExceptionHandler: handlerArg
	self assert: exceptionHandlers last = handlerArg;
	exceptionHandlers removeLast
***Process >> signal: exceptionArg
	[exceptionHandlers empty?] whileFalse:
		[exceptionHandlers last ->:tuple;
		exceptionHandlers removeLast;
		exceptionArg kindOf?: tuple car, 
			ifTrue: [tuple cdr value: exceptionArg]]
***Process >> stackTrace
	--get stacktrace immdiately after "currentProcess"
	cp ->:p;
	Array new ->:result;
	result addLast: method;
	p > 0 and: [contextStack at: p - 1, memberOf?: Context], ifTrue:
		[p - 1 ->p];
	[p > 0] whileTrue:
		[p - 3 ->p;
		contextStack at: p ->:cx, memberOf?: Context,
			ifTrue:
				[result addLast: cx method;
				p > 0 and: [contextStack at: p - 1, = cx], ifTrue: [p - 1 ->p]]
			ifFalse: [result addLast: cx]];
	result!
***Process >> printCall
	context nil?
		ifTrue:
			[frameStack ->:args;
			fp ->:argOff]
		ifFalse:
			[context ->args;
			3 ->argOff];
	method selector asString ->:sel;
	Out put: (args basicAt: argOff) describe;
	argOff + 1 ->argOff;
	sel includes?: ':',
		ifTrue:
			[sel split: ':', do:
				[:s
				Out put: " " + s + ": " + (args basicAt: argOff) describe;
				argOff + 1 ->argOff]]
		ifFalse:
			[Out put: " " + sel;
			sel first ->:ch, alpha? or: [ch = '_'], ifFalse:
				[Out put: " " + (args basicAt: argOff) describe]];
	Out putLn
***Process >> interruptBlock: blockArg
	blockArg ->interruptBlock
***Process >> interruptBlock
	interruptBlock!
***Process >> interrupt
	interruptBlock notNil? ifTrue: [interruptBlock value]
***Process >> trap: codeArg cp: curCpArg sp: curSpArg
	-- code = ip_trap_code : see ip.h
	codeArg = 2 ifTrue: [self interrupt];
	codeArg = 3 ifTrue: [Mulk quit];
	self resumeCp: curCpArg sp: curSpArg

**Global variables.
***GlobalVar class.#
	class GlobalVar Object : value;

****[test] Test.GlobalVar class.@
	UnitTest addSubclass: #Test.GlobalVar instanceVars: "gv"
*****Test.GlobalVar >> setup
	GlobalVar new ->gv;
	gv set: 0
	
****GlobalVar >> set: valueArg
	valueArg ->value
*****[test.m]
	gv set: 1;
	self assert: gv get = 1
	
****GlobalVar >> get
	value!
*****[test.m]
	self assert: gv get = 0
	
***TransientGlobalVar class.#
	class TransientGlobalVar GlobalVar;

****[test] Test.TransientGlobalVar class.@
	UnitTest addSubclass: #Test.TransientGlobalVar instanceVars: "ref"
*****Test.TransientGlobalVar >> putObjectRef: refArg
	refArg ->ref
	
****TransientGlobalVar >> serializeTo: writerArg
	value ->:save;
	nil ->value;
	super serializeTo: writerArg;
	save ->value
*****[test.m]
	TransientGlobalVar new ->:gv;
	gv set: 0;
	1 ->ref;
	
	gv serializeTo: self;
	self assert: ref nil?
	
*Magnitude / Numeric protocols.
**[man.s]
***#en
Magnitude / Numeric protocols define magnitude relationships themselves and objects (numerical values, characters, etc.) with magnitude relationships.
***#ja
Magnitude/Numeric protocolsでは、大小関係自体と、大小関係のあるオブジェクト(数値、文字等)を定義する。

**Magnitude feature.#
	class Magnitude Feature;

***[man.c]
****#en
A feature that provides comparison operators.
****#ja
大小関係のあるオブジェクトに対し、比較演算子を提供するフィーチャー。

***Magnitude >> < valueArg
	self shouldBeImplemented
****[man.m]
*****#en
Returns true if valueArg is greater than the receiver.

This method needs to be implemented in a class with Magnitude.
*****#ja
レシーバーよりvalueArgが大きいならtrueを返す。

このメソッドはMagnitudeを有するクラスで実装する必要がある。

***Magnitude >> > valueArg
	valueArg < self!
****[man.m]
*****#en
Returns true if valueArg is less than the receiver.
*****#ja
レシーバーよりvalueArgが小さいならtrueを返す。
****[test.m]
	self assert: (1 > 2) not;
	self assert: (2 > 2) not;
	self assert: 3 > 2
	
***Magnitude >> <= valueArg
	valueArg < self, not!
****[man.m]
*****#en
Returns true if valueArg is greater than or equal to the receiver.
*****#ja
レシーバーよりvalueArgが大きいか等しいならtrueを返す。
****[test.m]
	self assert: 1 <= 2;
	self assert: 2 <= 2;
	self assert: (3 <= 2) not
	
***Magnitude >> >= valueArg
	self < valueArg, not!
****[man.m]
*****#en
Returns true if valueArg is less than or equal to the receiver.
*****#ja
レシーバーよりvalueArgが小さいか等しいならtrueを返す。
****[test.m]
	self assert: (1 >= 2) not;
	self assert: 2 >= 2;
	self assert: 3 >= 2

***Magnitude >> compareTo: valueArg
	self = valueArg
		ifTrue: [0]
		ifFalse: [self < valueArg ifTrue: [-1] ifFalse: [1]]!
****[man.m]
*****#en
It returns 1 if valueArg is less than the receiver, -1 if it is greater, or 0 if they are equal.
*****#ja
レシーバーよりvalueArgが小さいなら1を、大きいなら-1を、等しいなら0を返す。
****[test.m]
	self assert: (1 compareTo: 0) = 1;
	self assert: (1 compareTo: 1) = 0;
	self assert: (1 compareTo: 2) = -1
	
***Magnitude >> between: lowArg and: hiArg
	lowArg <= self and: [self <= hiArg]!
****[man.m]
*****#en
Returns true if lowArg <= receiver and receiver <= hiArg.
*****#ja
レシーバーがlowArg以上、hiArg以下なら真を返す。
****[test.m]
	self assert: (1 between: 2 and: 4) not;
	self assert: (2 between: 2 and: 4);
	self assert: (3 between: 2 and: 4);
	self assert: (4 between: 2 and: 4);
	self assert: (5 between: 2 and: 4) not
	
***Magnitude >> between: lowArg until: untilArg
	lowArg <= self and: [self < untilArg]!
****[man.m]
*****#en
Returns true if lowArg <= receiver and receiver < untilArg.
*****#ja
レシーバーがlowArg以上untilArg未満なら真を返す。
****[test.m]
	self assert: (1 between: 2 until: 4) not;
	self assert: (2 between: 2 until: 4);
	self assert: (3 between: 2 until: 4);
	self assert: (4 between: 2 until: 4) not;
	self assert: (5 between: 2 until: 4) not

***Magnitude >> max: valueArg
	self > valueArg ifTrue: [self] ifFalse: [valueArg]!
****[man.m]
*****#en
Returns the greater object in receiver and valueArg.
*****#ja
レシーバーとvalueArgで大きい方のオブジェクトを返す。
****[test.m]
	self assert: (1 max: 2) = 2;
	self assert: (3 max: 2) = 3

***Magnitude >> min: valueArg
	self < valueArg ifTrue: [self] ifFalse: [valueArg]!
****[man.m]
*****#en
Returns the lesser object in receiver and valueArg.
*****#ja
レシーバーとvalueArgで小さい方のオブジェクトを返す。
****[test.m]
	self assert: (1 min: 2) = 1;
	self assert: (3 min: 2) = 2

**Numbers.
***Number class.#
	class Number Object;
		feature Number Magnitude;

****[man.c]
*****#en
Base class for numbers.

Constructed as the result of a numeric literal, input, or operation.
It should not be construct by new.
Even different numeric objects may have the same value, so do not perform equivalence judgment with ==.
*****#ja
数の基底クラス。

数値リテラル、入力、演算の結果として構築される。
newによって構築してはならない。
異なる数値オブジェクトでも同一の値を持つ場合がある為、==で等価判定をしてはならない。

****arithmetic.
*****Number >> generalizeMessageBetween: numberArg
	self memberOf?: Float, or: [numberArg memberOf?: Float], 
		ifTrue: [#asFloat!];
	#asLongInteger!
******[test.m]
	self assert: (1 generalizeMessageBetween: 1.1) = #asFloat;
	self assert: (1.1 generalizeMessageBetween: 1) = #asFloat;
	self assert: (1 generalizeMessageBetween: 0xffffffff) = #asLongInteger

*****Number >> = numberArg
	numberArg kindOf?: Number, ifFalse: [false!];
	self generalizeMessageBetween: numberArg ->:msg;
	(self perform: msg) = (numberArg perform: msg)!
******[test.m]
	--not Numner
	self assert: (3 = nil) not;
	--generalize
	self assert: 3 = 3.0

*****Number >> < numberArg
	self generalizeMessageBetween: numberArg ->:msg;
	(self perform: msg) < (numberArg perform: msg)!
******[test.m]
	--generalize
	self assert: 1 < 2.0

*****Number >> negated
	self * -1!
******[man.m]
*******#en
Returns the inverted value of the receiver's sign.
*******#ja
レシーバーの符号を反転させた値を返す。
******[test.m]
	self assert: 1.0 negated = -1.0
		
*****Number >> + numberArg
	self generalizeMessageBetween: numberArg ->:msg;
	(self perform: msg) + (numberArg perform: msg)!
******[man.m]
*******#en
Returns the sum of receiver and numberArg.
*******#ja
レシーバーとnumberArgの和を返す。
******[test.m]
	--generalize
	self assert: 2 + 2.5 = 4.5

*****Number >> - numberArg
	self + numberArg negated!
******[man.m]
*******#en
Returns the difference between receiver and numberArg.
*******#ja
レシーバーとnumberArgの差を返す。
******[test.m]
	self assert: 3 - 4 = -1

*****Number >> * numberArg
	self generalizeMessageBetween: numberArg ->:msg;
	(self perform: msg) * (numberArg perform: msg)!
******[man.m]
*******#en
Returns the product of receiver and numberArg.
*******#ja
レシーバーとnumberArgの積を返す。
******[test.m]
	--generalize
	self assert: 1.5 * 2 = 3.0

*****Number >> / numberArg
	self asFloat / numberArg asFloat!
******[man.m]
*******#en
Returns the quotient of the receiver divided by numberArg.

The result is a floating point number.
*******#ja
レシーバーをnumberArgで割った商を返す。

結果は浮動小数点数値となる。
******[test.m]
	--generalize
	self assert: 3 / 2 = 1.5

*****Number >> negative?
	self < 0!
******[man.m]
*******#en
Returns true if the receiver is a negative number.
*******#ja
レシーバーが負数であればtrueを返す。
******[test.m]
	self assert: -1 negative?;
	self assert: 1 negative? not

*****Number >> abs
	self negative? ifTrue: [self negated] ifFalse: [self]!
******[man.m]
*******#en
Returns the absolute value of the receiver.
*******#ja
レシーバーの絶対値を返す。
******[test.m]
	self assert: -1 abs = 1;
	self assert: 1 abs = 1

****interval.
*****Number >> until: untilArg by: byArg
	Iterator new init:
		[:b
		self ->:i;
		byArg > 0 
			ifTrue: [[i < untilArg] whileTrue: [b value: i; i + byArg ->i]]
			ifFalse: [[i > untilArg] whileTrue: [b value: i; i + byArg ->i]]]!
******[man.m]
*******#en
Returns an Iterator that repeats every byArg from the receiver until untilArg.

It does not reach untilArg.
Depending on the value, processing may not be performed even once.
*******#ja
レシーバーからuntilArgまで、byArg毎の繰り返しを行うIteratorを返す。

untilArgには到達しない。
値によっては一度も処理を行わない場合がある。
******[test.m]
	StringWriter new ->:writer;
	1 until: 11 by: 2, do: [:x writer put: x];
	self assert: writer asString = "13579"
******[test.m]
	self assert: (0 until: 10 by: 1) size = 10
******[test.m] 3
	StringWriter new ->:wr;
	2 until: 6 by: 2, do: [:i wr put: i];
	6 until: 2 by: -2, do: [:j wr put: j];
	self assert: wr asString = "2464"
	
*****Number >> until: untilArg
	self until: untilArg by: (self < untilArg ifTrue: [1] ifFalse: [-1])!
******[man.m]
*******#en
Returns an Iterator that repeats from the receiver until untilArg.

It does not reach untilArg.
Depending on the value, processing may not be performed even once.
*******#ja
レシーバーからuntilArgまでの繰り返しを行うIteratorを返す。

untilArgには到達しない。
値によっては一度も処理を行わない場合がある。
******[test.m]
	StringWriter new ->:writer;
	1 until: 5, do: [:x writer put: x];
	self assert: writer asString = "1234"

*****Number >> to: toArg by: byArg
	self until: toArg + byArg by: byArg!
******[man.m]
*******#en
Returns an Iterator that repeats every byArg from the receiver to toArg.

The execution is repeated to the first value of toArg or above as the last one.
*******#ja
レシーバーからtoArgまで、byArg毎の繰り返しを行うIteratorを返す。

最後の一回としてtoArgもしくはそれを越える最初の値まで実行が繰り返される。
******[test.m]
	StringWriter new ->:writer;
	5 to: 0 by: -2, do: [:x writer put: x];
	--ToDo: if overrun?
	self assert: writer asString = "531-1"

*****Number >> to: toArg
	self to: toArg by: (self < toArg ifTrue: [1] ifFalse: [-1])!
******[man.m]
*******#en
Returns an Iterator that repeats from the receiver to toArg.

The execution is repeated to the first value of toArg or above as the last one.
*******#ja
レシーバーからtoArgまでの繰り返しを行うIteratorを返す。

最後の一回としてtoArgもしくはそれを越える最初の値まで実行が繰り返される。
******[test.m]
	StringWriter new ->:writer;
	1 to: 5, do: [:x writer put: x];
 	self assert: writer asString = "12345"

****Number >> asInteger
	self shouldBeImplemented
*****[man.m]
******#en
Convert the receiver into an integer.
******#ja
レシーバーを整数化する。

***Integer class.#
	class Integer Number;

****[man.c]
*****#en
Base class for integer values.

Actual integer objects are implemented in derived classes.
*****#ja
整数値の基底クラス。

実際の整数オブジェクトは派生クラスで実装される。

****arithmethic.
*****Integer >> // intArg
	self asLongInteger // intArg asLongInteger!
******[man.m]
*******#en
Returns the quotient of the receiver divided by the integer intArg.

The return value is an integer.
*******#ja
レシーバーを整数intArgで除算した商を返す。

返り値は整数となる。
******[test.m]
	self assert: 0x100000000 // 0x10 = 0x10000000

*****Integer >> asLongPositiveInteger
	self asLongInteger ->:result, negative? ifTrue:
		[self error: "not positive"];
	result!
*****Integer >> % positiveIntArg
	self asLongPositiveInteger % positiveIntArg asLongPositiveInteger!
******[man.m]
*******#en
Returns the remainder of the receiver divided by positiveIntArg.

Receiver and positiveIntArg must be positive integers.
*******#ja
レシーバーをpositiveIntArgで割った余りを返す。

レシーバーとpositiveIntArgは正の整数でなくてはならない。
******[test.m]
	self assert: 0x123456789 % 0x10 = 9;
	self assertError: [-10 % 10] message: "not positive"
	
*****Integer >> << intArg
	self asLongPositiveInteger << intArg!
******[man.m]
*******#en
Shift the receiver intArg bits left and return the result.

The receiver must be a positive number.
*******#ja
レシーバーをintArgビット左シフトし、結果を返す。

レシーバーは正の数でなくてはならない。
******[test.m]
	self assert: 0x12345678 << 8 = 0x1234567800;
	1 ->:a;
	self assertError: [-1 << a] message: "not positive"
	
*****Integer >> >> intArg
	self << intArg negated!
******[man.m]
*******#en
Shift the receiver intArg bits right and return the result.

The receiver must be a positive number.
*******#ja
レシーバーをintArgビット右シフトし、結果を返す。

レシーバーは正の数でなくてはならない。
******[test.m]
	self assert: 0x1234 >> 8 = 0x12

*****Integer >> & positiveIntArg
	self asLongPositiveInteger & positiveIntArg asLongPositiveInteger!
******[man.m]
*******#en
Returns the bitwise AND of the receiver and positiveIntArg.

The receiver and positiveIntArg must be positive integer.
*******#ja
レシーバーとpositiveIntArgのビット毎の論理積を返す。

レシーバーとpositiveIntArgは正の整数でなくてはならない。
******[test.m]
	self assert: 0x333333333 & 3 = 3;
	1 ->:one;
	self assertError: [-1 & one] message: "not positive"
	
*****Integer >> | positiveIntArg
	self asLongPositiveInteger | positiveIntArg asLongPositiveInteger!
******[man.m]
*******#en
Returns the bitwise OR of the receiver and positiveIntArg.

The receiver and positiveIntArg must be positive integer.
*******#ja
レシーバーとpositiveIntArgのビット毎の論理和を返す。

レシーバーとpositiveIntArgは正の整数でなくてはならない。
******[test.m]
	self assert: 0x3 | 0x700000000 = 0x700000003;
	1 ->:one;
	self assertError: [-1 & one] message: "not positive"
	
*****Integer >> ^ positiveIntArg
	self asLongPositiveInteger ^ positiveIntArg asLongPositiveInteger!
******[man.m]
*******#en
Returns the bitwise exclusive OR of the receiver and positiveIntArg.

The receiver and positiveIntArg must be positive integer.
*******#ja
レシーバーとpositiveIntArgのビット毎の排他的論理和を返す。

レシーバーとpositiveIntArgは正の整数でなくてはならない。
******[test.m]
	self assert: 3 ^ 0x500000000 = 0x500000003;
	1 ->:one;
	self assertError: [-1 ^ one] message: "not positive"
	
****printings.
*****Integer >> printPositiveOn: writerArg radix: radixArg
	self = 0
		ifTrue: [writerArg put: '0']
		ifFalse:
			[self // radixArg ->:upper, <> 0 ifTrue:
				[upper printPositiveOn: writerArg radix: radixArg];
			writerArg put: (self % radixArg, asNumericChar)]
******[test.m]
	StringWriter new ->:wr;
	0xdead printPositiveOn: wr radix: 16;
	self assert: wr asString = "dead"

*****Integer >> printOn: writerArg radix: radixArg
	self negative?
		ifTrue: [writerArg put: '-'; self negated]
		ifFalse: [self],
		printPositiveOn: writerArg radix: radixArg
******[test.m]
	StringWriter new ->:wr;
	-0xdead printOn: wr radix: 16;
	self assert: wr asString = "-dead"

*****Integer >> printOn: writerArg
	self printOn: writerArg radix: 10
******[test.m]
	StringWriter new ->:wr;
	-1234 printOn: wr;
	self assert: wr asString = "-1234"

****asString variation.
*****Integer >> asStringRadix: radixArg
	self printOn: (StringWriter new ->:wr) radix: radixArg;
	wr asString!
******[man.m]
*******#en
Returns a string representation of the receiver in radixArg notation.
*******#ja
レシーバーをradixArg進法表記で文字列化したものを返す。
******[test.m]
	self assert: (0xdeadbeaf asStringRadix: 16) = "deadbeaf"

*****Integer >> asHexString
	self asStringRadix: 16!
******[man.m]
*******#en
Returns a string representation of the receiver in hexadecimal notation.
*******#ja
レシーバーを16進法表記で文字列化したものを返す。
******[test.m]
	self assert: 0xbeaf asHexString = "beaf"

*****Integer >> asStringRadix: radixArg zeroPadding: widthArg
	StringWriter new ->:wr;

	self negative?
		ifTrue:
			[wr put: '-';
			widthArg - 1 ->widthArg;
			self negated]
		ifFalse: [self],
		asStringRadix: radixArg ->:s;

	wr put: '0' times: widthArg - s size, put: s, asString!
******[man.m]
*******#en
Returns a string representation of the receiver in radixArg notation.

If the result is shorter than widthArg column, perform zero padding processing.
*******#ja
レシーバーをradixArg進法表記で文字列化したものを返す。

結果がwidthArgカラムより短い場合はゼロパディング処理を行う。
******[test.m]
	self assert: (0xabcd asStringRadix: 16 zeroPadding: 6) = "00abcd";
	self assert: (-10 asStringRadix: 10 zeroPadding: 6) = "-00010"

*****Integer >> asString0: widthArg
	self asStringRadix: 10 zeroPadding: widthArg!
******[man.m]
*******#en
Returns a string representation of the receiver in decimal.

If the result is shorter than widthArg column, perform zero padding processing.
*******#ja
レシーバーを十進数で文字列化したものを返す。

結果がwidthArgカラムより短い場合はゼロパディング処理を行う。
******[test.m]
	self assert: (123 asString0: 4) = "0123"

*****Integer >> asHexString0: widthArg
	self asStringRadix: 16 zeroPadding: widthArg!
******[man.m]
*******#en
Returns a string representation of the receiver in hexadecimal.

If the result is shorter than widthArg column, perform zero padding processing.
*******#ja
レシーバーを16進数で文字列化したものを返す。

結果がzpカラムより短い場合はゼロパディング処理を行う。
******[test.m]
	self assert: (0xab asHexString0: 4) = "00ab"

****Integer >> asInteger
	self!
*****[test.m]
	self assert: 1 asInteger = 1

****Integer >> asChar
	#(nil
	'\x00' '\x01' '\x02' '\x03' '\x04' '\x05' '\x06' '\x07'
	'\x08' '\x09' '\x0a' '\x0b' '\x0c' '\x0d' '\x0e' '\x0f'
	'\x10' '\x11' '\x12' '\x13' '\x14' '\x15' '\x16' '\x17'
	'\x18' '\x19' '\x1a' '\x1b' '\x1c' '\x1d' '\x1e' '\x1f'
	'\x20' '\x21' '\x22' '\x23' '\x24' '\x25' '\x26' '\x27'
	'\x28' '\x29' '\x2a' '\x2b' '\x2c' '\x2d' '\x2e' '\x2f'
	'\x30' '\x31' '\x32' '\x33' '\x34' '\x35' '\x36' '\x37'
	'\x38' '\x39' '\x3a' '\x3b' '\x3c' '\x3d' '\x3e' '\x3f'
	'\x40' '\x41' '\x42' '\x43' '\x44' '\x45' '\x46' '\x47'
	'\x48' '\x49' '\x4a' '\x4b' '\x4c' '\x4d' '\x4e' '\x4f'
	'\x50' '\x51' '\x52' '\x53' '\x54' '\x55' '\x56' '\x57'
	'\x58' '\x59' '\x5a' '\x5b' '\x5c' '\x5d' '\x5e' '\x5f'
	'\x60' '\x61' '\x62' '\x63' '\x64' '\x65' '\x66' '\x67'
	'\x68' '\x69' '\x6a' '\x6b' '\x6c' '\x6d' '\x6e' '\x6f'
	'\x70' '\x71' '\x72' '\x73' '\x74' '\x75' '\x76' '\x77'
	'\x78' '\x79' '\x7a' '\x7b' '\x7c' '\x7d' '\x7e' '\x7f'
	'\x80' '\x81' '\x82' '\x83' '\x84' '\x85' '\x86' '\x87'
	'\x88' '\x89' '\x8a' '\x8b' '\x8c' '\x8d' '\x8e' '\x8f'
	'\x90' '\x91' '\x92' '\x93' '\x94' '\x95' '\x96' '\x97'
	'\x98' '\x99' '\x9a' '\x9b' '\x9c' '\x9d' '\x9e' '\x9f'
	'\xa0' '\xa1' '\xa2' '\xa3' '\xa4' '\xa5' '\xa6' '\xa7'
	'\xa8' '\xa9' '\xaa' '\xab' '\xac' '\xad' '\xae' '\xaf'
	'\xb0' '\xb1' '\xb2' '\xb3' '\xb4' '\xb5' '\xb6' '\xb7'
	'\xb8' '\xb9' '\xba' '\xbb' '\xbc' '\xbd' '\xbe' '\xbf'
	'\xc0' '\xc1' '\xc2' '\xc3' '\xc4' '\xc5' '\xc6' '\xc7'
	'\xc8' '\xc9' '\xca' '\xcb' '\xcc' '\xcd' '\xce' '\xcf'
	'\xd0' '\xd1' '\xd2' '\xd3' '\xd4' '\xd5' '\xd6' '\xd7'
	'\xd8' '\xd9' '\xda' '\xdb' '\xdc' '\xdd' '\xde' '\xdf'
	'\xe0' '\xe1' '\xe2' '\xe3' '\xe4' '\xe5' '\xe6' '\xe7'
	'\xe8' '\xe9' '\xea' '\xeb' '\xec' '\xed' '\xee' '\xef'
	'\xf0' '\xf1' '\xf2' '\xf3' '\xf4' '\xf5' '\xf6' '\xf7'
	'\xf8' '\xf9' '\xfa' '\xfb' '\xfc' '\xfd' '\xfe' '\xff') at: self + 1!
*****[man.m]
******#en
Returns the instance of Char whose character code is the receiver.

The receiver should be between -1 and 255.
In case of -1 it returns nil.
******#ja
レシーバーを文字コードとするCharのインスタンスを返す。

レシーバーは-1〜255の間である事。
-1の場合はnilを返す。
*****[test.m]
	self assert: 'a' code asChar = 'a';
	self assert: -1 asChar nil?

****Integer >> asWideChar
	self >= 256
		ifTrue:
			[WideChar.dictionary at: self ifAbsentPut:
				[WideChar new initCode: self,
					hash: self & 0xfffff {OM_HASH_MASH}]]
		ifFalse: [self asChar]!
*****[man.m]
******#en
Returns an instance of WideChar whose character code is the receiver.

Same as asChar if the receiver is smaller than 256.
******#ja
レシーバーを文字コードとするWideCharのインスタンスを返す。

レシーバーが256より小さい場合はasCharと同様。
*****[test.m]
	self assert: 'a' code asWideChar = 'a'
*****#ja
******[test.m] wideChar
	self assert: '漢' code asWideChar = '漢'

****Integer >> asNumericChar
	self < 10 ifTrue: [self + '0' code] ifFalse: [self - 10 + 'a' code],
		asChar!
*****[test.m]
	self assert: 8 asNumericChar = '8';
	self assert: 11 asNumericChar = 'b'
	
***ShortInteger class.#
	class ShortInteger Integer 255;

****[man.c]
*****#en
31-bit signed integer value.

Since some iterations are subject to inline expansion, it can only be used for ShortInteger.
*****#ja
31bit符号付き整数値。

一部の繰り返し処理はインライン展開の対象となる為、ShortIntegerに対してのみ使用可能。

****primitives.
*****ShortInteger >> = numberArg
	$sint_equal
	super = numberArg!
******[test.m]
	--success
	self assert: 3 = 3;
	self assert: (3 = 4) not;
	--generalize
	self assert: 3 = 3.0

*****ShortInteger >> < numberArg
	$sint_lt
	super < numberArg!
******[test.m]
	--success
	self assert: (2 < 1) not;
	self assert: (2 < 2) not;
	self assert: 2 < 3;
	--generalize
	self assert: 2 < 3.0
	
*****ShortInteger >> + numberArg
	$sint_add
	super + numberArg!
******[test.m]
	--success
	self assert: 3 + 4 = 7;
	--generalize
	self assert: 3 + 4.0 = 7;
	--overflow
	self assert: 0x3fffffff + 1 = 1073741824

*****ShortInteger >> * numberArg
	$sint_multiply
	super * numberArg!
******[test.m]
	--success
	self assert: 3 * 4 = 12;
	--generalize
	self assert: 3 * 4.0 = 12.0;
	--overflow
	self assert: 0x10000 * 0x10000 = 0x100000000

*****ShortInteger >> // intArg
	$sint_divide
	super // intArg!
******[test.m]
	--success
	self assert: 20 // 3 = 6;
	self assert: 30 // 3 = 10;
	--overflow
	self assert: -0x40000000 // -1 = 0x40000000;
	--generalize
	self assert: 2 // 0x100000000 = 0
	
*****ShortInteger >> % intArg
	$sint_modulo
	super % intArg!
******[test.m]
	--success
	self assert: 20 % 3 = 2;
	--generalize
	self assert: 1 % 0x100000000 = 1

*****ShortInteger >> << intArg
	$sint_shift
	super << intArg!
******[test.m]
	self assert: 3 << 2 = 12;
	self assert: 8 >> 1 = 4

*****ShortInteger >> & positiveIntArg
	$sint_and
	super & positiveIntArg!
******[test.m]
	--success
	self assert: 3 & 5 = 1

*****ShortInteger >> | positiveIntArg
	$sint_or
	super | positiveIntArg!
******[test.m]
	--success
	self assert: 3 | 5 = 7;
	--generalize
	self assert: 3 | 0x500000005 = 0x500000007

*****ShortInteger >> ^ positiveIntArg
	$sint_xor
	super ^ positiveIntArg!
******[test.m]
	--success
	self assert: 3 ^ 5 = 6;
	--generalize
	self assert: 3 ^ 0x500000005 = 0x500000006

*****ShortInteger >> makeLongPositiveIntegerWithAbs
	$sint_makeLongPositiveIntegerWithAbs
	
*****ShortInteger >> asLongInteger
	self makeLongPositiveIntegerWithAbs ->:abs;
	self negative? ifTrue: [abs makeLongNegativeInteger] ifFalse: [abs]!
******[test.m]
	self assert: (1 asLongInteger kindOf?: LongInteger)

*****ShortInteger >> asFloat
	$sint_asFloat
******[test.m]
	self assert: (1 asFloat kindOf?: Float)

****interval.
*****ShortInteger >> timesDo: blockArg
	-- self must be ShortInteger, when in-line expansion.
	self > 0 ifTrue: [0 until: self, do: blockArg]
******[man.m]
*******#en
Evaluate blockArg repeatedly by using the value from 0 to receiver-1 as an argument.

If the receiver is 0, blockArg is not evaluated.
*******#ja
0からレシーバー-1までの値を引数にして、blockArgをレシーバー回繰り返し評価する。

レシーバーが0の場合blockArgは評価されない。
******[test.m]
	StringWriter new ->:wr;
	[:x wr put: x] ->:block;
	5 timesDo: block;
	0 timesDo: block;
	self assert: wr asString = "01234"
******[test.m] inline
	StringWriter new ->:wr;
	5 timesDo: [:x wr put: x];
	0 timesDo: [:y wr put: y];
	self assert: wr asString = "01234"

*****ShortInteger >> timesRepeat: blockArg
	-- self must be ShortInteger, when in-line expansion.
	self timesDo: [:dummy blockArg value]
******[man.m]
*******#en
Evaluate blockArg repeatedly for receiver times.

If the receiver is 0, blockArg is not evaluated.
*******#ja
blockArgをレシーバー回、繰り返し評価する。

レシーバーが0の場合blockArgは評価されない。
******[test.m]
	StringWriter new ->:wr;
	[wr put: 'x'] ->:block;
	0 timesRepeat: block;
	5 timesRepeat: block;
	self assert: wr asString = "xxxxx"
******[test.m] inline
	StringWriter new ->:wr;
	0 timesRepeat: [wr put: 'x'];
	5 timesRepeat: [wr put: 'x'];
	self assert: wr asString = "xxxxx"

***LongInteger class.#
	class LongInteger Integer;
****[man.c]
*****#en
64-bit integer value.

To handle the sign separately, it corresponds to a value in the range of -18446744073709551615 to 18446744073709551615.
*****#ja
64bit整数値。

符号を別に扱うため、-18446744073709551615から18446744073709551615の範囲の値に対応する。

****LongInteger >> asLongInteger
	self!
	
***LongPositiveInteger class.#
	class LongPositiveInteger LongInteger 250;
****[man.c]
*****#en
64-bit positive integer value.
*****#ja
64bit正整数値。

****LongPositiveInteger >> = y
	$lpint_equal
	y memberOf?: LongNegativeInteger, ifTrue: [false!];
	super = y!
*****[test.m]
	--success
	self assert: 0x100000000 = 0x100000000;
	self assert: (0x100000000 = 0x100000001) not;
	--LongNegativeInteger
	self assert: (0x100000000 = -0x100000000) not;
	--generalize
	self assert: (0x100000000 = 1) not
	
****LongPositiveInteger >> < y
	$lpint_lt
	y memberOf?: LongNegativeInteger, ifTrue: [false!];
	super < y!
*****[test.m]
	--success
	self assert: (0x200000000 < 0x100000000) not;
	self assert: (0x200000000 < 0x200000000) not;
	self assert: 0x200000000 < 0x300000000;
	--LongNegativeInteger
	self assert: (0x200000000 < -0x200000000) not;
	--generalize
	self assert: 0x200000000 < 1.0e308

****LongPositiveInteger >> asShortIntegerWith: negative?
	$lpint_asShortIntegerWith
	nil!
****LongPositiveInteger >> normalize
	self asShortIntegerWith: false ->:result, nil?
		ifTrue: [self] ifFalse: [result]!
****LongPositiveInteger >> makeLongNegativeInteger
	LongNegativeInteger new init: self!
	
****LongPositiveInteger >> negated
	self makeLongNegativeInteger normalize!
*****[test.m]
	self assert: 0x100000000 negated = -0x100000000;
	self assert: (0x40000000 negated memberOf?: ShortInteger)

****LongPositiveInteger >> subtract: y
	$lpint_subtract

****LongPositiveInteger >> + y
	$lpint_add
	self primLastError = 1 ifTrue: [self error: "overflow"];
	y memberOf?: LongNegativeInteger, ifTrue:
		[self > y abs
			ifTrue: [self subtract: y abs, normalize]
			ifFalse: [y abs subtract: self, negated]!];
	super + y!
*****[test.m]
	--success
	self assert: 0x0123456789abcdef + 0xfedcba9876543210 = 0xffffffffffffffff;
	--overflow
	1 ->:one;
	self assertError: [0xffffffffffffffff + one] message: "overflow";
	--LongNegativeInteger I
	self assert: 0x200000000 + (-0x100000000) = 0x100000000;
	--LongNegativeInteger II
	self assert: 0x100000000 + (-0x200000000) = -0x100000000;
	--generalize
	self assert: 0xffffffff + 1 = 0x100000000

****LongPositiveInteger >> multiply: y
	$lpint_multiply
	self error: "overflow"
****LongPositiveInteger >> * y
	y class ->:yclass, = LongPositiveInteger
		ifTrue: [self multiply: y, normalize!];
	yclass = LongNegativeInteger
		ifTrue: [self multiply: y abs, negated!];
	super * y!
*****[test.m]
	--success
	self assert: 0x80000000 * 0x80000000 = 0x4000000000000000;
	--normalize
	self assert: 0x80000000 * 0 = 0;
	--LongNegativeInteger
	self assert: 0x80000000 * -0x80000000 = -0x4000000000000000;
	--overflow
	0x100000000 ->:a;
	self assertError: [a * a] message: "overflow";
	--generalize
	self assert: 0x100000000 * 0x10 = 0x1000000000
	
****LongPositiveInteger >> divide: y
	$lpint_divide
	self error: "divide by 0"
****LongPositiveInteger >> // y
	y class ->:yclass, = LongPositiveInteger
		ifTrue: [self divide: y, normalize!];
	yclass = LongNegativeInteger
		ifTrue: [self divide: y abs, negated!];
	super // y!
*****[test.m]
	--success
	self assert: 0x4000000000000000 // 0x80000000 = 0x80000000;
	--normalize
	self assert: 0x4000000000000000 // 0x1000000000000000 = 4;
	--divide by 0
	0 ->:a;
	self assertError: [0x100000000 // a] message: "divide by 0";
	--LongNegativeInteger
	self assert: 0x4000000000000000 // -0x80000000 = -0x80000000;
	--generalize
	self assert: 0x100000000 // 0x100 = 0x1000000
	
****LongPositiveInteger >> modulo: y
	$lpint_modulo
	self error: "divide by 0"
****LongPositiveInteger >> % y
	y memberOf?: LongPositiveInteger, ifTrue: [self modulo: y, normalize!];
	super % y!
*****[test.m]
	--success
	self assert: 0x123456789 % 0x100000000 = 0x23456789;
	--divide by 0
	self assertError: [0x123456789 % 0] message: "divide by 0";
	--generalize
	self assert: 0x123456789 % 0x10 = 9
	
****LongPositiveInteger >> and: y
	$lpint_and
****LongPositiveInteger >> & y
	y memberOf?: LongPositiveInteger, ifTrue: [self and: y, normalize!];
	super & y!
*****[test.m]
	--success
	self assert: 0x333333333 & 0x555555555 = 0x111111111;
	--generalize
	self assert: 0x333333333 & 5 = 1
	
****LongPositiveInteger >> or: y
	$lpint_or
****LongPositiveInteger >> | y
	y memberOf?: LongPositiveInteger, ifTrue: [self or: y, normalize!];
	super | y!
*****[test.m]
	--success
	self assert: 0x333333333 | 0x555555555 = 0x777777777;
	--generalize
	self assert: 0x333333333 | 5 = 0x333333337
	
****LongPositiveInteger >> xor: y
	$lpint_xor
****LongPositiveInteger >> ^ y
	y memberOf?: LongPositiveInteger, ifTrue: [self xor: y, normalize!];
	super ^ y!
*****[test.m]
	--success
	self assert: 0x333333333 ^ 0x555555555 = 0x666666666;
	--generalize
	self assert: 0x333333333 ^ 5 = 0x333333336
		
****LongPositiveInteger >> shift: y
	$lpint_shift
****LongPositiveInteger >> << y
	self shift: y, normalize!
*****[test.m]
	self assert: 0x1234567890 << 4 = 0x12345678900;
	self assert: 0x1234567890 << -8 = 0x12345678
	
****LongPositiveInteger >> asFloat
	$lpint_asFloat
****LongPositiveInteger >> serializeTo: writerArg
	self serializeBytesTo: writerArg

***LongNegativeInteger class.#
	class LongNegativeInteger LongInteger : abs;
****[man.c]
*****#en
64-bit negative integer value.
*****#ja
64bit負整数値。

****LongNegativeInteger >> init: absArg
	absArg ->abs;
	self hash: self asFloat hash
	
****LongNegativeInteger >> abs
	abs!

****LongNegativeInteger >> = y
	y class ->:yclass, = LongNegativeInteger ifTrue: [abs = y abs!];
	yclass = LongPositiveInteger ifTrue: [false!];
	super = y!
*****[test.m]
	--success
	self assert: -0x100000000 = -0x100000000;
	self assert: (-0x100000000 = -0x100000001) not;
	--LongPositiveInteger
	self assert: (-0x100000000 = 0x100000000) not;
	--generalize
	self assert: (-0x100000000 = 1) not
	
****LongNegativeInteger >> < y
	y class ->:yclass, = LongNegativeInteger ifTrue: [abs > y abs!];
	yclass = LongPositiveInteger ifTrue: [true!];
	super < y!
*****[test.m]
	--success
	self assert: -0x200000000 < -0x100000000;
	self assert: (-0x200000000 < -0x200000000) not;
	self assert: (-0x200000000 < -0x300000000) not;
	--LongPositiveInteger
	self assert: (-0x200000000 < 0x100000000);
	--generalize
	self assert: -0x200000000 < 1.0e308
	
****LongNegativeInteger >> normalize
	abs asShortIntegerWith: true ->:result, nil?
		ifTrue: [self] ifFalse: [result]!

****LongNegativeInteger >> negated
	abs!
*****[test.m]
	self assert: -0x100000000 negated = 0x100000000
	
****LongNegativeInteger >> + y
	y class ->:yclass, = LongNegativeInteger ifTrue: [abs + y abs, negated!];
	yclass = LongPositiveInteger ifTrue: [y - abs!];
	super + y!
*****[test.m]
	--success
	self assert: -0x100000000 + -0x100000000 = -0x200000000;
	--LongPositiveInteger
	self assert: -0x100000000 + 0x100000000 = 0;
	--generalize
	self assert: -0x100000000 + 1 = -0xffffffff
	
****LongNegativeInteger >> * y
	y class ->:yclass, = LongNegativeInteger ifTrue: [abs * y abs!];
	yclass = LongPositiveInteger ifTrue: [abs * y, negated!];
	super * y!
*****[test.m]
	--success
	self assert: -0x80000000 * -0x80000000 = 0x4000000000000000;
	--LongPositiveInteger
	self assert: -0x80000000 * 0x80000000 = -0x4000000000000000;
	--generalize
	self assert: -0x80000000 * 0x10 = -0x800000000
	
****LongNegativeInteger >> // y
	y class ->:yclass, = LongNegativeInteger ifTrue: [abs // y abs!];
	yclass = LongPositiveInteger ifTrue: [abs // y, negated!];
	super // y!
*****[test.m]
	--success
	self assert: -0x4000000000000000 // -0x80000000 = 0x80000000;
	--LongPositiveInteger
	self assert: -0x4000000000000000 // 0x80000000 = -0x80000000;
	--generalize
	self assert: -0x800000000 // 0x10 = -0x80000000
	
****LongNegativeInteger >> asFloat
	abs asFloat negated!
	
***Float class.#
	class Float Number 249;

****[man.c]
*****#en
64 bit floating point number.

An error occurs if the result of the operation is an invalid number.
NaN and Inf values are not handled.
*****#ja
64bit浮動小数点数値。

演算の結果が無効な数値となった場合はエラーとなる。
NaNやInfの値は扱わない。

****primitives.
*****Float >> = numberArg
	$float_equal
	super = numberArg!
******[test.m]
	--success
	self assert: 1.0 = 1.0;
	self assert: (1.0 = 2.0) not;
	--generalize
	self assert: 1.0 = 1
	
*****Float >> < numberArg
	$float_lt
	super < numberArg!
******[test.m]
	--success
	self assert: (2.0 < 1.0) not;
	self assert: (2.0 < 2.0) not;
	self assert: 2.0 < 3.0;
	--generalize
	self assert: 2.0 < 3
	
*****Float >> + numberArg
	$float_add
	self primLastError = 1 ifTrue: [self error: "overflow"];
	super + numberArg!
******[test.m]
	--success
	self assert: 1.0 + 2.0 = 3.0;
	--overflow
	1.0e308 ->:a;
	self assertError: [a + a] message: "overflow";
	--generalize
	self assert: 1.0 + 2 = 3.0

*****Float >> * numberArg
	$float_multiply
	self primLastError = 1 ifTrue: [self error: "overflow"];
	super * numberArg!
******[test.m]
	--success
	self assert: 2.0 * 3.0 = 6.0;
	--overflow
	1.0e308 ->:a;
	self assertError: [a * 10.0] message: "overflow";
	--generalize
	self assert: 2.0 * 2 = 4.0
	
*****Float >> / numberArg
	$float_divide
	self primLastError = 1 ifTrue:
		[numberArg = 0
			ifTrue: [self error: "divide by 0"]
			ifFalse: [self error: "overflow"]];
	super / numberArg!
******[test.m]
	--success
	self assert: 2.0 / 2.0 = 1.0;
	--divide by 0
	0.0 ->:a;
	self assertError: [1.0 / a] message: "divide by 0";
	--overflow
	0.1 ->a;
	self assertError: [1.0e308 / a] message: "overflow";
	--generalize
	self assert: 2.0 / 2 = 1.0
	
*****Float >> asInteger
	$float_asInteger
	self < 0 ifTrue: [self negated asInteger negated!];
	self error: "overflow"
******[test.m]
	self assert: 123.456 asInteger = 123;
	self assert: 0x3fffffff asFloat asInteger = 0x3fffffff;
	self assert: -0x40000000 asFloat asInteger = -0x40000000
******[test.m] limit
	self assert: 0x1fffffffffffff asFloat asInteger = 0x1fffffffffffff;
	self assert: -0x1fffffffffffff asFloat asInteger = -0x1fffffffffffff;
	self assertError: [0x20000000000000 asFloat asInteger] message: "overflow";
	self assertError: [-0x20000000000000 asFloat asInteger] message: "overflow"

****Float >> printOn: writerArg
	FloatWriter new put: self to: writerArg
*****[test.m]
	self assert: -3141.0 asString = "-3141.0"
	
****Float >> serializeTo: writerArg
	self serializeBytesTo: writerArg

****Float >> asFloat
	self!
*****[test.m]
	self assert: 3.0 asFloat = 3.0

****Float >> power10: powArg
	self ->:result;
	powArg > 0
		ifTrue: [powArg timesRepeat: [result * 10.0 ->result]]
		ifFalse: [powArg negated timesRepeat: [result / 10.0 ->result]];
	result!
*****[test.m]
	self assert: (3.0 power10: 1) = 30.0;
	self assert: (30.0 power10: -1) = 3.0

***FloatWriter class.#
	class FloatWriter Object : negative? mant exp remain max writer;
****FloatWriter >> mantWidth: mantWidthArg
	mantWidthArg ->remain;
	1 ->max;
	mantWidthArg timesRepeat: [10 * max ->max]
****FloatWriter >> value: value
	value negative? ->negative?, ifTrue: [value negated ->value];
	0 ->exp;
	value = 0.0 ifTrue: [0 ->mant!];
	value >= 10.0 
		ifTrue:
			[[value >= 10.0] whileTrue:
				[value / 10.0 ->value;
				exp + 1 ->exp]]
		ifFalse:
			[[value < 1.0] whileTrue:
				[value * 10.0 ->value;
				exp - 1 ->exp]];
	value * max / 10.0 + 0.5, asInteger ->mant;
	mant >= max ifTrue:
		[mant // 10 ->mant;
		exp + 1 ->exp]
****FloatWriter >> putSign
	negative? ifTrue: [writer put: '-']
****FloatWriter >> putMant1
	mant * 10 ->mant;
	writer put: mant // max;
	mant % max ->mant;
	remain - 1 ->remain
****FloatWriter >> putMant
	[remain > 0 & (mant <> 0)] whileTrue: [self putMant1]
****FloatWriter >> putEstyle
	self putSign;
	self putMant1;
	writer put: '.';
	self putMant1;
	self putMant;
	exp <> 0 ifTrue: [writer put: 'e', put: exp]
****FloatWriter >> putFstyle
	self putSign;
	exp >= 0
		ifTrue:
			[exp + 1 timesRepeat: [self putMant1];
			writer put: '.']
		ifFalse:
			[writer put: "0.";
			writer put: '0' times: exp negated - 1];
	exp >= -1 ifTrue: [self putMant1];
	self putMant
****FloatWriter >> put: valueArg to: writerArg
	self mantWidth: 6;
	self value: valueArg;
	writerArg ->writer;
	exp between: -3 and: 5, 
		ifTrue: [self putFstyle]
		ifFalse: [self putEstyle]

**Characters.
***AbstractChar class.#
	class AbstractChar Object : code;
		feature AbstractChar Magnitude;

****[man.c]
*****#en
Base class for characters.

It is obtained character literal, input, and as a result of conversion from character code.
As there is only one object of the same character in the system, it should not be construct by new.
*****#ja
文字の基底クラス。

文字リテラル、入力、文字コードからの変換の結果として得られる。
同一文字のオブジェクトはシステム中に唯一つ存在するため、newによって構築してはならない。

****AbstractChar >> code
	code!
*****[man.m]
******#en
Returns the character code of the receiver.
******#ja
レシーバーの文字コードを返す。
*****[test.m]
	self assert: ('a' perform: #code) = 0x61	
*****[test.m] inline
	self assert: 'a' code = 0x61

****AbstractChar >> < charArg
	code < charArg code!
*****[test.m]
	self assert: 'a' < 'b';
	self assert: ('b' < 'b') not;
	self assert: ('c' < 'b') not
	
****AbstractChar >> describeOn: writerArg
	writerArg put: '\'';
	self printEscapedOn: writerArg;
	writerArg put: '\''
*****[test.m]
	StringWriter new ->:w;
	'a' describeOn: w;
	self assert: w asString = "'a'"
	
****AbstractChar >> width
	self shouldBeImplemented
*****[man.m]
******#en
Returns the character width of the receiver.

It means relative size in fixed pitch font when normal ASCII character is 1.
******#ja
レシーバーの文字幅を返す。

通常のASCII文字を1とした場合の固定ピッチフォントにおける相対サイズを意味する。

****character types.
*****AbstractChar >> ascii?
	code between: 0 and: 127!
******[man.m]
*******#en
Returns true if the receiver is in 7-bit ASCII range.
*******#ja
レシーバーが7bit ASCIIの範囲内ならばtrueを返す。
******[test.m]
	self assert: 'a' ascii?;
	self assert: '\x80' ascii? not

*****AbstractChar >> print?
	true!
******[man.m]
*******#en
Returns true if the receiver is a printable character.
*******#ja
レシーバーが印字可能文字ならtrueを返す。

*****AbstractChar >> space?
	false!
******[man.m]
*******#en
Returns true if the receiver is a space character.
*******#ja
レシーバーが空白文字ならtrueを返す。

*****AbstractChar >> digit?
	false!
******[man.m]
*******#en
Returns true if the receiver is a digit.
*******#ja
レシーバーが数字ならtrueを返す。

*****AbstractChar >> lower?
	false!
******[man.m]
*******#en
Returns true if the receiver is lower case alphabet.
*******#ja
レシーバーが英小文字ならtrueを返す。

*****AbstractChar >> upper?
	false!
******[man.m]
*******#en
Returns true if the receiver is upper case alphabet.
*******#ja
レシーバーが英大文字ならtrueを返す。

*****AbstractChar >> alpha?
	false!
******[man.m]
*******#en
Returns true if the receiver is alphabet.
*******#ja
レシーバーが英字ならtrueを返す。

*****AbstractChar >> alnum?
	false!
******[man.m]
*******#en
Returns true if the receiver is alphanumeric.
*******#ja
レシーバーが英数字ならtrueを返す。

***Char class.#
	class Char AbstractChar : attr;

****[man.c]
*****#en
Byte character.

Indicates the character represented by 1 byte.
Multibyte characters are treated as a sequence of multiple Chars.
*****#ja
バイト文字。

1バイトで表される文字を示す。
マルチバイト文字は複数のCharの列として扱われる。

****Char >> printOn: writerArg
	writerArg putCharCode: code
*****[test.m]
	'a' printOn: (StringWriter new ->:wr);
	self assert: wr asString = "a"
	
****Char >> printEscapedOn: writerArg
	self print? ifTrue:
		[self = '\\' or: [self = '\''], or: [self = '\"'], 
			ifTrue: [writerArg put: '\\'];
		self printOn: writerArg!];
	self = '\n' ifTrue: [writerArg put: "\\n"!];
	self = '\t' ifTrue: [writerArg put: "\\t"!];
	self = '\c@' ifTrue: [writerArg put: "\\c@"!];
	code between: 1 and: 0x1a, ifTrue:
		[writerArg put: "\\c", putCharCode: code + 0x60!];
	writerArg put: "\\x", put: (code asHexString0: 2)
*****[test.m]
	StringWriter new ->:wr;
	"a \\ ' \" \n \t \c@ \ca \xff" do: [:ch ch printEscapedOn: wr];
	self assert: wr asString ="a \\\\ \\' \\\" \\n \\t \\c@ \\ca \\xff"

****Char >> asDecimalValue -- nocheck.
	code - '0' code!
****Char >> asNumericValue: radixArg ifError: blockArg
	-1 ->:val;
	self digit? ifTrue: [self asDecimalValue ->val];
	self lower? ifTrue: [code - 'a' code + 10 ->val];
	val between: 0 until: radixArg, ifFalse: [blockArg value!];
	val!
****Char >> asNumericValue: radixArg
	self asNumericValue: radixArg ifError: [self error: "not numeric char"]!
*****[test.m]
	self assert: ('1' asNumericValue: 16) = 1;
	self assert: ('a' asNumericValue: 16) = 10;
	self assertError: ['a' asNumericValue: 10] message: "not numeric char";
	self assertError: ['2' asNumericValue: 2] message: "not numeric char";
	self assertError: ['!' asNumericValue: 2] message: "not numeric char"
	
****character types.
*****Char >> print?
	attr & 1 = 1!
******[test.m]
	self assert: 'a' print?;
	self assert: '\x00' print? not

*****Char >> space?
	attr & 2 = 2!
******[test.m]
	self assert: ' ' space?;
	self assert: '\t' space?;
	self assert: '\n' space?;
	self assert: 'a' space? not
	
*****Char >> digit?
	attr & 4 = 4!
******[test.m]
	self assert: '1' digit?;
	self assert: 'a' digit? not
	
*****Char >> lower?
	attr & 8 = 8!
******[test.m]
	self assert: 'a' lower?;
	self assert: 'A' lower? not
	
*****Char >> upper?
	attr & 16 = 16!
******[test.m]
	self assert: 'A' upper?;
	self assert: 'a' upper? not
	
*****Char >> alpha?
	attr & 0x18 <> 0!
******[test.m]
	self assert: 'a' alpha?;
	self assert: '0' alpha? not
	
*****Char >> lower
	self upper? ifTrue: [code + 0x20, asChar] ifFalse: [self]!
******[man.m]
*******#en
If the receiver is upper case then return lower case, otherwise return the receiver itself.
*******#ja
レシーバーが英大文字なら小文字を、そうでない場合はレシーバー自身を返す。
******[test.m]
	self assert: 'A' lower = 'a';
	self assert: 'a' lower = 'a'
	
*****Char >> upper
	self lower? ifTrue: [code - 0x20, asChar] ifFalse: [self]!
******[man.m]
*******#en
If the receiver is lower case then return upper case, otherwise return the receiver itself.
*******#ja
レシーバーが英小文字なら大文字を返す。
そうでない場合はレシーバー自身を返す。
******[test.m]
	self assert: 'a' upper = 'A';
	self assert: 'A' upper = 'A'
	
*****Char >> alnum?
	attr & 0x1c <> 0!
******[test.m]
	self assert: 'a' alnum?;
	self assert: '0' alnum?;
	self assert: ' ' alnum? not
	
*****Char >> mblead?
	attr & 0x20 = 0x20!
******[man.m]
*******#en
Returns true if the receiver is the lead byte of a multibyte character.
*******#ja
レシーバーがマルチバイト文字の先頭バイトならtrueを返す。
******#ja
*******[test.m]
	self assert: "あ" first mblead?;
	self assert: ' ' mblead? not
	
*****Char >> mbtrail?
	attr & 0x40 = 0x40!
******[man.m]
*******#en
Returns true if the receiver is the trail byte of a multibyte character.
*******#ja
レシーバーがマルチバイト文字の後続バイトならtrueを返す。
******#ja
*******[test.m]
	self assert: ("あ" at: 1) mbtrail?;
	self assert: ' ' mblead? not

*****Char >> trailSize
	attr >> 8 & 0xff!
******[man.m]
*******#en
Returns the number of trail bytes if the receiver is the lead byte of a multibyte character, 0 otherwise.
*******#ja
レシーバーがマルチバイト文字の先頭バイトの場合後続のバイト数を、そうでない場合は0が返る。
******#ja
*******[test.m]
	self assert: "あ" first trailSize = ("あ" size - 1);
	self assert: 'a' trailSize = 0

*****Char >> width
	self print? ifTrue: [1] ifFalse: [0]!
******[test.m]
	self assert: 'a' width = 1;
	self assert: '\x00' width = 0

***WideChar class.#
	class WideChar AbstractChar : width;
	--WideChar.dictionary.
****[man.c]
*****#en
Wide character.

Indicates a character represented by multiple bytes.
The value that directly represents the byte string in big endian is the character code.

Wide characters are treated as printable characters that are neither blank nor alphanumeric.
*****#ja
ワイド文字。

複数バイトで表される文字を示す。
バイト列を直接ビッグエンディアンで表した値が文字コードとなる。

ワイド文字は全て空白でも英数字でもない印字可能文字として扱う。

****WideChar >> solveWidth
	--ref: http://ftp.unicode.org/Public/UNIDATA/EastAsianWidth.txt
	code = 0xe280a6, {U+2026 Horizontal Ellipsis}
	or: [code = 0xe296bc], {U+25BC BLACK DOWN-POINTING TRIANGLE}
	or: [code = 0xe296bd], {U+25BD WHITE DOWN-POINTING TRIANGLE}
	or: [code between: 0xe2ba80 and: 0xe4b6bf],
		{U+2E80 CJK Radical Repeat - U+33FF SQUARE GAL
		U+3400-U+4DBF CJK Unified Ideographs Extension A}
	or: [code between: 0xe4b880 and: 0xe9bfbf],
		{U+4E00-U+9FFF CJK Unified Ideographs}
	or: [code between: 0xefa480 and: 0xefabbf],
		{U+F900-U+FAFF CJK Compatibility Ideographs}
	ifTrue: [2] ifFalse: [1]!

****WideChar >> initCode: codeArg
	codeArg ->code;
	self solveWidth ->width

****WideChar >> width
	width!
*****#ja
******[test.m]
	self assert: 'ｧ' width = 1;
	self assert: 'あ' width = 2
	
****WideChar >> printOn: writerArg
	writerArg putWideCharCode: code
*****#ja
******[test.m]
	self assert: 'あ' asString = "あ"
	
****WideChar >> printEscapedOn: writerArg
	self printOn: writerArg
*****#ja
******[test.m]
	StringWriter new ->:w;
	'漢' printEscapedOn: w;
	self assert: w asString = "漢"
	
**DateAndTime class.#
	class DateAndTime Object
		: unixTime year month day dayWeek hour minute second;
		{unixTime is seconds from unix epoch (1970-01-01 00:00 utc)}
		feature DateAndTime Magnitude;

***[man.c]
****#en
Date and Time class.

Process the date and time of the time zone set in the host system.
The time difference from UTC to Local Time follows the setting of the host system at startup.

After creating with new, you need to clear and initialize it using the method starting with init.
****#ja
日付と時刻。

ホストシステムに設定されたタイムゾーンにおける日付、時刻を扱う。
協定世界時から地方時への時差は起動のホストシステムの設定に従う。

newで生成してから、initで始まるメソッドで明に初期化する必要がある。

***[test] Test.DateAndTime class.@
	UnitTest addSubclass: #Test.DateAndTime instanceVars: "d"
****Test.DateAndTime >> setup
	--DateAndTime new initUnixTime: 1407705489 ->d -- 2014-08-11 Mon 06:18:09
	DateAndTime new initUnixTime: 1407737889 - OS timediff ->d -- 2014-08-11 Mon 06:18:09
***accessing.
****DateAndTime >> year
	year!
*****[man.m]
******#en
Returns the year of the receiver.
******#ja
レシーバーの西暦を返す。
*****[test.m]
	self assert: d year = 2014
	
****DateAndTime >> month
	month!
*****[man.m]
******#en
Returns the month of the receiver (1-12).
******#ja
レシーバーの月(1〜12)を返す。
*****[test.m]
	self assert: d month = 8
	
****DateAndTime >> day
	day!
*****[man.m]
******#en
Returns the day of the receiver (1-31).
******#ja
レシーバーの日(1〜31)を返す。
*****[test.m]
	self assert: d day = 11
	
****DateAndTime >> dayWeek
	dayWeek!
*****[man.m]
******#en
Returns the index of the day of the week of the receiver (0-6, 0 corresponds to Sunday).
******#ja
レシーバーの曜日の通し番号(0〜6, 0が日曜に対応)を返す。
*****[test.m]
	self assert: d dayWeek = 1
	
****DateAndTime >> hour
	hour!
*****[man.m]
******#en
Returns the receiver's hour (0-23).
******#ja
レシーバーの時刻(0〜23)を返す。
*****[test.m]
	self assert: d hour = 6

****DateAndTime >> minute
	minute!
*****[man.m]
******#en
Returns the receiver's minute (0-59).
******#ja
レシーバーの分(0〜59)を返す。
*****[test.m]
	self assert: d minute = 18
	
****DateAndTime >> second
	second!
*****[man.m]
******#en
Returns the receiver's second (0-59).
******#ja
レシーバーの秒(0〜59)を返す。
*****[test.m]
	self assert: d second = 9
	
****DateAndTime >> unixTime
	unixTime!
*****[man.m]
******#en
Returns the number of seconds relative to the receiver's Unix epoch (January 1, 1970, 00:00:00 UTC).
******#ja
レシーバーのUnix epoch(協定世界時 1970年1月1日0時0分0秒)からの相対秒数を返す。
*****[test.m]
	self assert: d unixTime = (1407737889 - OS timediff)
	
***DateAndTime >> = dateArg
	dateArg memberOf?: DateAndTime, ifFalse: [false!];
	unixTime = dateArg unixTime!
****[test.m]
	self assert: (d = nil) not;
	self assert: d = d;
	self assert: d = (DateAndTime new initUnixTime: d unixTime);
	self assert: (d = (DateAndTime new initUnixTime: d unixTime + 1)) not
	
***DateAndTime >> < dateArg
	unixTime < dateArg unixTime!
****[test.m]
	DateAndTime new initUnixTime: d unixTime - 1 ->:d0;
	DateAndTime new initUnixTime: d unixTime ->:d1;
	DateAndTime new initUnixTime: d unixTime + 1 ->:d2;
	self assert: (d < d0) not;
	self assert: (d < d1) not;
	self assert: d < d2
	
***DateAndTime >> daycountOfYear: yearArg month: monthArg day: dayArg
	--daycount from 0001-01-01, based on Zeller's congruence.
	monthArg <= 2 ifTrue:
		[yearArg - 1 ->yearArg;
		monthArg + 12 ->monthArg];
	
	(yearArg - 1) * 365 
		+ (yearArg // 4) - (yearArg // 100) + (yearArg // 400)
		+ (306 * monthArg - 324 // 10) 
		+ dayArg - 1!
***DateAndTime >> monthDay
	month = 2
		ifTrue:
			[self daycountOfYear: year month: 3 day: 1,
				- (self daycountOfYear: year month: 2 day: 1)]
		ifFalse:
			[month = 4 or: [month = 6], or: [month = 9], or: [month = 11],
				ifTrue: [30] ifFalse: [31]]!

***initialize.
****DateAndTime >> initUnixTime: unixTimeArg
	unixTimeArg ->unixTime;
	unixTime + OS timediff ->:t; -- utc to localtime
	t +
.if ib
		(621355968 * 100)
.else
		62135596800
.end
	->t; -- sec from 0001-01-01
	t % 60 ->second; t // 60 ->t;
	t % 60 ->minute; t // 60 ->t;
	t % 24 ->hour; t // 24 ->t; -- day from 0001-01-01
	t + 1 % 7 ->dayWeek; -- 0001-01-01 is Mon.
	
	t // 365 + 1 ->year;
	[self daycountOfYear: year month: 1 day: 1 ->:st, > t] 
		whileTrue: [year - 1 ->year];
	
	t - st // 31 + 1 ->month;
	self daycountOfYear: year month: month day: 1 ->st;
	self monthDay ->:md;
	st + md <= t ifTrue:
		[month + 1 ->month;
		st + md ->st];
	t - st + 1 ->day
*****[man.m]
******#en
Initialize the receiver with unixTimeArg.

unixTimeArg is the number of seconds from Unix epoch.
******#ja
レシーバーをunixTimeArgで初期化する。

unixTimeArgはUnix epochからの秒数。
*****[test.m]
	self assert: (DateAndTime new initUnixTime: OS timediff negated) asString
		= "1970-01-01 Thu 00:00:00";
	self assert: (DateAndTime new initUnixTime: -41104 - OS timediff) asString
		= "1969-12-31 Wed 12:34:56" -- = 1970/1/1 00:00:00 (utc)

****DateAndTime >> initNow
	self initUnixTime: OS time
*****[man.m]
******#en
Initialize the receiver with the current time.
******#ja
レシーバーを現在時刻で初期化する。

****DateAndTime >> unixTimeUtcYear: yearArg month: monthArg day: dayArg
		hour: hourArg minute: minuteArg second: secondArg
	self daycountOfYear: yearArg month: monthArg day: dayArg,
		- 719162 -- day from 1970-01-01
		* 24 + hourArg * 60 + minuteArg * 60 + secondArg!
****DateAndTime >> initUtcYear: yearArg month: monthArg day: dayArg
		hour: hourArg minute: minuteArg second: secondArg
	self initUnixTime: 
		(self unixTimeUtcYear: yearArg month: monthArg day: dayArg
		hour: hourArg minute: minuteArg second: secondArg)
****DateAndTime >> initYear: yearArg month: monthArg day: dayArg hour: hourArg
		minute: minuteArg second: secondArg
	self initUnixTime: 
		(self unixTimeUtcYear: yearArg month: monthArg day: dayArg
		hour: hourArg minute: minuteArg second: secondArg) - OS timediff
*****[man.m]
******#en
Initialize the receiver to year yearArg year monthArg month dayArg day hourArg day minuteArg hour minuteArg minute secondArg second.
******#ja
レシーバーを西暦yearArg年monthArg月dayArg日hourArg時minuteArg分secondArg秒に初期化する。

****DateAndTime >> initYear: yearArg month: monthArg day: dayArg
	self initYear: yearArg month: monthArg day: dayArg hour: 0 minute: 0
		second: 0
*****[man.m]
******#en
Initialize the receiver to year yearArg year monthArg month dayArg day 00:00:00.
******#ja
レシーバーを西暦yearArg年monthArg月dayArg日0時0分0秒に初期化する。
*****[test.m]
	DateAndTime new initYear: 2000 month: 1 day: 31 ->:d0;
	DateAndTime new initYear: 2000 month: 2 day: 1 ->:d1;
	self assert: d1 unixTime - d0 unixTime = 86400;
		
	DateAndTime new initYear: 2000 month: 2 day: 28 ->d0;
	DateAndTime new initYear: 2000 month: 3 day: 1 ->d1;
	self assert: d1 unixTime - d0 unixTime = (86400 * 2);

	DateAndTime new initYear: 2001 month: 2 day: 28 ->d0;
	DateAndTime new initYear: 2001 month: 3 day: 1 ->d1;
	self assert: d1 unixTime - d0 unixTime = 86400

***DateAndTime >> printOn: writerArg
	dayWeek * 3 ->:pos;
	writerArg
		put: (year asString0: 4), 
		put: '-', put: (month asString0: 2),
		put: '-', put: (day asString0: 2),
		put: ' ', put: ("SunMonTueWedThuFriSat" copyFrom: pos until: pos + 3),
		put: ' ', put: (hour asString0: 2),
		put: ':', put: (minute asString0: 2),
		put: ':', put: (second asString0: 2)
****[test.m]
	self assert: d asString = "2014-08-11 Mon 06:18:09"
	
***DateAndTime >> describeOn: writerArg
	super printOn: writerArg;
	writerArg put: '(', put: self, put: ')'
****[test.m]
	self assert: d describe = "aDateAndTime(2014-08-11 Mon 06:18:09)"
	
*Collection protocols.
**[man.s]
***#en
Collection protocols provide objects that hold multiple objects.
***#ja
Collection protocolsは複数のオブジェクトを保持するオブジェクトを提供する。

**Collection feature.#
	class Collection Feature;
***[man.c]
****#en
A feature that provides the ability to handle multiple objects sequentially or collectively.
****#ja
複数のオブジェクトを順に、あるいはまとめて扱う機能を提供するフィーチャー。
***[test] Test.Collection class.@
	UnitTest addSubclass: #Test.Collection instanceVars: "i"
****Test.Collection >> setup
	1 to: 10 ->i
	
***Collection >> do: blockArg
	self shouldBeImplemented
****[man.m]
*****#en
Evaluate blockArg using the holding objects as arguments in order.

This method needs to be implemented in a class that has a Collection.
*****#ja
オブジェクト群を順に引数としてblockArgを評価する。

このメソッドはCollectionを有するクラスで実装する必要がある。

***Collection >> do: blockArg separatedBy: separatedBlockArg
	true ->:first?;
	self do:
		[:o
		first?
			ifTrue: [false ->first?]
			ifFalse: [separatedBlockArg value];
		blockArg value: o]
****[man.m]
*****#en
Evaluate blockArg using the holding objects as arguments in order.

The second and subsequent objects evaluate the separatedBlockArg prior to evaluating the blockArg.
*****#ja
オブジェクト群を順に引数としてblockArgを評価する。

2番目以降のオブジェクトではblockArgの評価に先立ってseparatedBlockArgを評価する。
****[test.m]
	StringWriter new ->:w;
	i do: [:e w put: e] separatedBy: [w put: '-'];
	self assert: w asString = "1-2-3-4-5-6-7-8-9-10"
	
***Collection >> anySatisfy?: blockArg
	self do: [:o blockArg value: o, ifTrue: [true!]];
	false!
****[man.m]
*****#en
Evaluate blockArg using the objects as arguments in order, and returns true if there is even one that returns true.
*****#ja
オブジェクト群を順に引数としてblockArgを評価し、一つでもtrueを返すものがあればtrueを返す。
****[test.m]
	self assert: (i anySatisfy?: [:o o = 5]);
	self assert: (i anySatisfy?: [:o2 o2 = 11]) not

***Collection >> allSatisfy?: blockArg
	self do: [:o blockArg value: o, ifFalse: [false!]];
	true!
****[man.m]
*****#en
Evaluate blockArg using the holding objects as arguments in order, and return true if all return true.
*****#ja
オブジェクト群を順に引数としてblockArgを評価し、全てがtrueを返すならばtrueを返す。
****[test.m]
	self assert: (i allSatisfy?: [:o o <> 11]);
	self assert: (i allSatisfy?: [:o2 o2 <> 5]) not
	
***Collection >> includes?: objectArg
	self anySatisfy?: [:o o = objectArg]!
****[man.m]
*****#en
If there is a match among objectArg in the holding object, it returns true.
*****#ja
オブジェクト群にobjectArgと一致するものがあれはtrueを返す。
****[test.m]
	self assert: (i includes?: 5);
	self assert: (i includes?: 11) not

***Collection >> inject: valueArg into: blockArg
	self do: [:o blockArg value: valueArg value: o ->valueArg];
	valueArg!
****[man.m]
*****#en
Evaluates blockArg with the valueArg and the first object, and then the return value of the evaluation and the subsequent object as arguments, and returns the result of the last evaluation.
*****#ja
初回はvalueArgと最初のオブジェクトを、それ以降は評価の返り値と後続のオブジェクトを引数にblockArgを評価し、最後の評価の結果を返す。
****[test.m]
	self assert: (i inject: 0 into: [:x :y x + y]) = 55

***Collection >> detect: blockArg
	self do: [:o blockArg value: o, ifTrue: [o!]];
	nil!
****[man.m]
*****#en
Evaluates blockArg using the objects as arguments in order, and returns the object that first returned true.

Returns nil if there is no object that returns true.
*****#ja
オブジェクト群を順に引数としてblockArgを評価し、最初にtrueを返したオブジェクトを返す。

trueを返すオブジェクトが無い場合はnilを返す。
****[test.m]
	self assert: (i detect: [:x x % 3 = 0]) = 3;
	self assert: (i detect: [:x2 x2 % 11 = 0]) nil?
	
***Collection >> size
	self inject: 0 into: [:x :y x + 1]!
****[man.m]
*****#en
Return the number of the holding objects.
*****#ja
オブジェクト群の個数を返す。
****[test.m]
	self assert: i size = 10

***Collection >> empty?
	self size = 0!
****[man.m]
*****#en
If the number of holding objects is 0, it returns true.
*****#ja
オブジェクト群の個数が0ならtrueを返す。
****[test.m]
	self assert: i empty? not;
	self assert: Array new empty?

***Collection >> collect: blockArg
	Iterator new init:
		[:b self do: [:v b value: (blockArg value: v)]]!
****[man.m]
*****#en
Evaluates blockArg with the objects in order as arguments, and returns an Iterator of the return values.
*****#ja
オブジェクト群を順に引数としてblockArgを評価し、その返り値のIteratorを返す。

***Collection >> collectAsArray: blockArg
	Array new ->:result;
	self do: [:v result addLast: (blockArg value: v)];
	result!
****[man.m]
*****#en
Evaluates blockArg using the holding objects as arguments in order, and returns an array of return values.
*****#ja
オブジェクト群を順に引数としてblockArgを評価し、その返り値の配列を返す。
****[test.m]
	self assert: ((i collectAsArray: [:j j * 2]) inject: 0 into: [:x :y x + y])
		= 110

***Collection >> select: blockArg
	Iterator new init:
		[:b self do: [:v blockArg value: v, ifTrue: [b value: v]]]!
****[man.m]
*****#en
Evaluates blockArg with the objects in order as arguments, and returns an Iterator of objects that returned true.

*****#ja
オブジェクト群を順に引数としてblockArgを評価し、trueを返したオブジェクトのIteratorを返す。

***Collection >> selectAsArray: blockArg
	Array new ->:result;
	self do:
		[:v 
		blockArg value: v, ifTrue: [result addLast: v]];
	result!
****[man.m]
*****#en
Evaluates blockArg with the holding objects as arguments in order, and returns an array of objects that return true.
*****#ja
オブジェクト群を順に引数としてblockArgを評価し、trueを返したオブジェクトの配列を返す。
****[test.m]
	self assert: (i selectAsArray: [:x x % 3 = 0]) asString = "3 6 9"

***Collection >> asArray
	Array new addAll: self!
****[man.m]
*****#en
Returns an array holding the objects in order.
*****#ja
オブジェクト群を順に保持する配列を返す。
****[test.m]
	self assert: i asArray asString = "1 2 3 4 5 6 7 8 9 10"

***Collection >> reverse
	self asArray reverse!
****[man.m]
*****#en
Returns an Iterator that evaluates a group of objects in reverse order.
*****#ja
オブジェクト群を逆順に評価するIteratorを返す。
****[test.m]
	self assert: i reverse asArray asString = "10 9 8 7 6 5 4 3 2 1"
	
**Iterator class.#
	class Iterator Object : doBlock;
		feature Iterator Collection;
***[man.c]
****#en
Iterative process.

Provides a function that generates an object sequence based on specified conditions and behaves as a Collection.
****#ja
繰返し処理。

指定の条件に基づいてオブジェクト列を生成し、Collectionとして振舞う機能を提供する。

***Iterator >> init: doBlockArg
	doBlockArg ->doBlock
***Iterator >> do: blockArg
	doBlock value: blockArg

**Arrays.
***AbstractArray class.#
	class AbstractArray Object;
		feature AbstractArray Collection;

****[man.c]
*****#en
An abstract class that defines the common behavior of arrays.

Set element with element number as key and get it.
The element number is an integer value starting from 0, and specifying an out-of-range number results in an error.
*****#ja
配列の共通動作を定義する抽象クラス。

要素番号をキーに要素を設定、取得する。
要素番号は0から始まる整数値で、範囲外の番号を指定するとエラーとなる。
****[test] Test.AbstractArray class.@
	UnitTest addSubclass: #Test.AbstractArray instanceVars: "ar"
*****Test.AbstractArray >> setup
	#(0 1 2 3 4 0 1 2 3 4) copy ->ar

****AbstractArray >> at: posArg
	self shouldBeImplemented
*****[man.m]
******#en
Return the posArg-th element of the array.
******#ja
配列のposArg-th番目の要素を返す。

****AbstractArray >> at: posArg put: valueArg
	self shouldBeImplemented
*****[man.m]
******#en
Set the posArg-th element of the array to valueArg.
******#ja
配列のposArg番目の要素をvalueArgに設定する。

****AbstractArray >> do: blockArg
	self size timesDo: [:i blockArg value: (self at: i)]
*****[test.m]
	StringWriter new ->:wr;
	ar do: [:e wr put: e];
	self assert: wr asString = "0123401234"

****AbstractArray >> reverse
	Iterator new init:
		[:b
		self size - 1 ->:sz1;
		self size timesDo: [:i b value: (self at: sz1 - i)]]!
*****[test.m]
	StringWriter new ->:wr;
	ar reverse do: [:e wr put: e];
	self assert: wr asString = "4321043210"

****AbstractArray >> first
	self at: 0!
*****[man.m]
******#en
Return the first element of the array.
******#ja
配列の先頭要素を返す。
*****[test.m]
	self assert: ar first = 0

****AbstractArray >> last
	self at: self size - 1!
*****[man.m]
******#en
Return the last element of the array.
******#ja
配列の末尾の要素を返す。
*****[test.m]
	self assert: ar last = 4

****AbstractArray >> find: blockArg from: fromArg until: untilArg
	fromArg until: untilArg, 
		do: [:i blockArg value: (self at: i), ifTrue: [i!]];
	nil!
*****[man.m]
******#en
Evaluates block with the fromArg-th until untilArg-th elements as arguments in order, and returns the element number of the element that first returned true.

Returns nil if there is no element that returns true.
The untilArg-th element is not included in the search target.
It is also possible to search in the reverse order.
******#ja
fromArg番目からuntilArg番目までの要素を順に引数としてblockArgを評価し、最初にtrueを返した要素の要素番号を返す。

trueを返す要素が無い場合はnilを返す。
untilArg番目の要素は検索対象に含まれない。
逆順に探索する事も可能。
*****[test.m]
	[:e e = 3] ->:is3;
	self assert: (ar find: is3 from: 3 until: 9) = 3;
	self assert: (ar find: is3 from: 4 until: 9) = 8;
	self assert: (ar find: is3 from: 8 until: 2) = 8;
	self assert: (ar find: is3 from: 7 until: 2) = 3
	
****AbstractArray >> find: blockArg after: fromArg
	self find: blockArg from: fromArg until: self size!
*****[man.m]
******#en
The blockArg is evaluated using the fromArg-th and subsequent elements as arguments in order, and the element number of the element that first returned true is returned.

Returns nil if there is no element that returns true.
******#ja
fromArg番目以降の要素を順に引数としてblockArgを評価し、最初にtrueを返した要素の要素番号を返す。

trueを返す要素が無い場合はnilを返す。
*****[test.m]
	self assert: (ar find: [:e e % 3 = 1] after: 5) = 6;
	self assert: (ar find: [:e2 e2 % 3 = 1] after: 10) nil?

****AbstractArray >> findFirst: blockArg
	self find: blockArg after: 0!
*****[man.m]
******#en
Evaluates blockArg with the element from the first as an argument in order, and returns the element number of the element that first returned true.

Returns nil if there is no element that returns true.
******#ja
先頭からの要素を順に引数としてblockArgを評価し、最初にtrueを返した要素の要素番号を返す。

trueを返す要素が無い場合はnilを返す。
*****[test.m]
	self assert: (ar findFirst: [:e e % 3 = 1]) = 1;
	self assert: (ar findFirst: [:e2 e2 % 3 = 3]) nil?

****AbstractArray >> findLast: blockArg
	self find: blockArg from: self size - 1 until: -1!
*****[man.m]
******#en
Evaluates blockArg with the element from the end as an argument in order, and returns the element number of the element that first returned true.

Returns nil if there is no element that returns true.
******#ja
末尾からの要素を順に引数としてblockを評価し、最初にtrueを返した要素の要素番号を返す。

trueを返す要素が無い場合はnilを返す。
*****[test.m]
	self assert: (ar findLast: [:e e % 3 = 1]) = 9;
	self assert: (ar findLast: [:e2 e2 % 3 = 3]) nil?
	
****AbstractArray >> findAll: blockArg
	Array new ->:result;
	self size timesDo:
		[:i
		blockArg value: (self at: i), ifTrue: [result addLast: i]];
	result!
*****[man.m]
******#en
Evaluate blockArg using all elements as arguments in order, and return the element number sequence of the element that returned true.
******#ja
全ての要素を順に引数としてblockArgを評価し、trueを返した要素の要素番号列を返す。
*****[test.m]
	ar findAll: [:e e % 3 = 0] ->:fa;
	self assert: fa asString = "0 3 5 8"

****AbstractArray >> indexOf: targetArg from: fromArg until: untilArg
	self find: [:elt elt = targetArg] from: fromArg until: untilArg!
*****[man.m]
******#en
Returns the element number of the first element equal to targetArg in the fromArg-th until untilArg-th elements.

Returns nil if there is no equal element.
The untilArg-th element is not included in the search target.
It is also possible to search in the reverse order.
******#ja
fromArg番目からuntilArg番目までの要素でtargetArgに等しい最初の要素の要素番号を返す。

等しい要素がなければnilを返す。
untilArg番目の要素は検索対象に含まれない。
逆順に探索する事も可能。
*****[test.m]
	self assert: (ar indexOf: 3 from: 3 until: 8) = 3;
	self assert: (ar indexOf: 3 from: 4 until: 8) nil?;
	self assert: (ar indexOf: 3 from: 8 until: 3) = 8;
	self assert: (ar indexOf: 3 from: 7 until: 3) nil?
	
****AbstractArray >> indexOf: targetArg after: fromArg
	self indexOf: targetArg from: fromArg until: self size!
*****[man.m]
******#en
Returns the element number of the first element equal to targetArg in the elements after the fromArg-th.

Returns nil if there is no equal element.
******#ja
fromArg番目以降の要素でtargetArgに等しい最初の要素の要素番号を返す。

等しい要素がなければnilを返す。
*****[test.m]
	self assert: (ar indexOf: 2 after: 5) = 7;
	self assert: (ar indexOf: 5 after: 5) nil?

****AbstractArray >> indexOf: targetArg
	self indexOf: targetArg after: 0!
*****[man.m]
******#en
Returns the element number of the first element equal to targetArg.

Returns nil if there is no equal element.
******#ja
targetArgに等しい最初の要素の要素番号を返す。

等しい要素がなければnilを返す。

*****[test.m]
	self assert: (ar indexOf: 2) = 2;
	self assert: (ar indexOf: 11) nil?

****AbstractArray >> lastIndexOf: targetArg
	self indexOf: targetArg from: self size - 1 until: -1!
*****[man.m]
******#en
Returns the element number of the last element equal to targetArg.

Returns nil if there is no equal element.
******#ja
targetArgに等しい最後の要素の要素番号を返す。

等しい要素がなければnilを返す。
*****[test.m]
	self assert: (ar lastIndexOf: 2) = 7;
	self assert: (ar lastIndexOf: 11) nil?

****printing.
*****AbstractArray >> printContentsOn: writerArg by: selectorArg
	self 
		do: [:e e perform: selectorArg with: writerArg] 
		separatedBy: [writerArg put: ' ']
******[test.m]
	ar printContentsOn: (StringWriter new ->:w) by: #printOn:;
	self assert: w asString = "0 1 2 3 4 0 1 2 3 4"

*****AbstractArray >> describeOn: writerArg
	super printOn: writerArg;
	writerArg put: '(';
	self printContentsOn: writerArg by: #describeOn:;
	writerArg put: ')'
******[test.m]
	self assert: ar describe = "aFixedArray(0 1 2 3 4 0 1 2 3 4)"
	
*****AbstractArray >> printOn: writerArg
	self printContentsOn: writerArg by: #printOn:!
******[test.m]
	self assert: ar asString = "0 1 2 3 4 0 1 2 3 4"

****AbstractArray >> inspect
	Out putLn: self describe;
	self size timesDo:
		[:i
		Out put: i, put: ' ', putLn: (self at: i) describe]
		
****copying.
*****AbstractArray >> copyFrom: fromArg until: untilArg
	self shouldBeImplemented
******[man.m]
*******#en
Returns an instance of the same class as the receiver consisting of the fromArg-th until untilArg-th elements.

The untilArg-th element is not included in the copy target.
If fromArg and untilArg are equal, an empty instance is returned.
*******#ja
fromArg番目からuntilArg番目の要素からなるレシーバーと同じクラスのインスタンスを返す。

untilArg番目の要素はコピー対象に含まれない。
fromArgとuntilArgが等しい場合は空のインスタンスを返す。

*****AbstractArray >> copyFrom: fromArg
	self copyFrom: fromArg until: self size!
******[man.m]
*******#en
Returns an instance of the same class as the receiver consisting of the fromArg-th to last elements.
*******#ja
fromArg-th番目から最後の要素からなるレシーバーと同じクラスのインスタンスを返す。
******[test.m]
	self assert: (ar copyFrom: 7) asString = "2 3 4"
	
*****AbstractArray >> copyUntil: untilArg
	self copyFrom: 0 until: untilArg!
******[man.m]
*******#en
Returns an instance of the same class as the receiver consisting of the elements from the first to the untilArg-th.
*******#ja
先頭からuntilArg番目までの要素からなるレシーバーと同じクラスのインスタンスを返す。
******[test.m]
	self assert: (ar copyUntil: 3) asString = "0 1 2"
	
*****AbstractArray >> copy
	self copyFrom: 0!
******[man.m]
*******#en
Return a copy of the receiver.
*******#ja
レシーバーの複製を返す。
******[test.m]
	self assert: ar copy asString = "0 1 2 3 4 0 1 2 3 4"
	
****filling.
*****AbstractArray >> fill: objectArg from: fromArg until: untilArg
	fromArg until: untilArg, do: [:i self at: i put: objectArg]
******[man.m]
*******#en
Set objectArg to the elements from fromArg until untilArg.

The untilArg-th element is out of range.
*******#ja
fromArg番目からuntilArg番目までの要素にobjectArgを設定する。

untilArg番目の要素は範囲外となる。
******[test.m]
	ar fill: 5 from: 3 until: 6;
	self assert: ar asString = "0 1 2 5 5 5 1 2 3 4"
	
*****AbstractArray >> fill: objectArg
	self fill: objectArg from: 0 until: self size
******[man.m]
*******#en
Set objectArg for all elements.
*******#ja
全要素にobjectArgを設定する。
******[test.m]
	ar fill: 5;
	self assert: ar asString = "5 5 5 5 5 5 5 5 5 5"
	
****sorting.
*****AbstractArray >> swap: iArg and: jArg
	self at: iArg ->:t;
	self at: iArg put: (self at: jArg);
	self at: jArg put: t
******[test.m]
	ar swap: 0 and: 9;
	self assert: ar asString = "4 1 2 3 4 0 1 2 3 0"
	
*****AbstractArray >> sortBy: blockArg
	self empty? ifTrue: [self!];

	Array new addLast: 0, addLast: self size - 1 ->:queue;
	[queue empty?] whileFalse:
		[queue last ->:last;
		queue removeLast;
		queue last ->:first;
		queue removeLast;
		self at: (first + last) // 2 ->:x;
		first ->:i;
		last ->:j;
		[
			[blockArg value: (self at: i) value: x] whileTrue: [i + 1 ->i];
			[blockArg value: x value: (self at: j)] whileTrue: [j - 1 ->j];
			i < j
		] whileTrue:
			[self swap: i and: j;
			i + 1 ->i;
			j - 1 ->j];
		first < (i - 1) ifTrue: [queue addLast: first, addLast: i - 1];
		j + 1 < last ifTrue: [queue addLast: j + 1, addLast: last]]
******[man.m]
*******#en
Sort array using blockArg.

The blockArg is defined to accept two arguments and return true if the argument order corresponds to the sort order.
*******#ja
blockArgを用いて配列を整列する。

blockArgは2つの引数を受けとり、引数順序が整列順序に相当する場合はtrueを返す様に定義する。
******[test.m]
	self assert: (#(3 1 4 1 5 9 2) copy sortBy: [:i :j i > j])
		asString = "9 5 4 3 2 1 1"

*****AbstractArray >> sort
	self sortBy: [:x :y x < y]
******[man.m]
*******#en
Sort the sequences in ascending order.

The elements of the array must implement Magnitude.
*******#ja
配列を昇順に整列する。

配列の要素はMagnitudeを実装していなくてはならない。
******[test.m]
	self assert: #(3 1 4 1 5 9 2) copy sort asString = "1 1 2 3 4 5 9"

***AbstractFixedArray class.#
	class AbstractFixedArray AbstractArray;

****[man.c]
*****#en
An abstract class that defines common behavior for fixed-length arrays.

Fixed-length arrays are constructed by specifying the number of elements in the basicNew: message.
The number of elements cannot be changed after construction.
*****#ja
固定長配列の共通動作を定義する抽象クラス。

固定長配列はbasicNew:メッセージで要素数を指定して構築する。
構築後に要素数を変更する事は出来ない。
****[test] Test.AbstractFixedArray class.@
	UnitTest addSubclass: #Test.AbstractFixedArray instanceVars: "ar"
*****Test.AbstractFixedArray >> setup
	#(0 1 2 3 4 5 6 7 8 9) copy ->ar
	
****AbstractFixedArray >> size
	$object_basicSize -- self basicSize!
*****[test.m]
	self assert: ar size = 10
	
****AbstractFixedArray >> at: posArg
	$object_basicAt -- self basicAt: posArg!
*****[test.m]
	self assert: (ar at: 5) = 5
	
****AbstractFixedArray >> at: posArg put: valueArg
	$object_basicAt_put -- self basicAt: posArg put: val
*****[test.m]
	ar at: 5 put: 0;
	self assert: (ar at: 5) = 0

****AbstractFixedArray >> basicAt: destPosArg copyFrom: srcArg at: srcPosArg 
		size: sizeArg
	self shouldBeImplemented
*****[man.m]
******#en
Copy sizeArg elements from the srcPosArg-th element of the srcArg array to the receiver's destPosArg-th element and beyond.

The copy source and the copy destination may be the same array.
Even if the areas to be copied overlap, it operates correctly.
******#ja
srcArg配列のsrcPosArg番目からsizeArg個の要素をレシーバーのdestPosArg番目以降にコピーする。

コピー元とコピー先は同じ配列でもかまわない。
又、コピーする領域が重なっていても正しく動作する。
*****[test.m] 0
	ar basicAt: 0 copyFrom: ar at: 2 size: 8;
	self assert: ar asString = "2 3 4 5 6 7 8 9 8 9"
*****[test.m] 1
	ar basicAt: 2 copyFrom: ar at: 0 size: 8;
	self assert: ar asString = "0 1 0 1 2 3 4 5 6 7"
	
****AbstractFixedArray >> copyFrom: fromArg until: untilArg
	untilArg - fromArg ->:size;
	self class basicNew: size, 
		basicAt: 0 copyFrom: self at: fromArg size: size!
*****[test.m]
	ar copyFrom: 3 until: 6 ->:a;
	self assert: a describe = "aFixedArray(3 4 5)"
			
***FixedArray class.#
	class FixedArray AbstractFixedArray 251;

****[man.c]
*****#en
Fixed length array.

Arbitrary objects can be held as elements.
*****#ja
固定長配列。

要素として任意のオブジェクトを保持できる。

****FixedArray >> basicAt: destPosArg copyFrom: srcArg at: srcPosArg 
		size: sizeArg
	self == srcArg and: [srcPosArg < destPosArg],
		ifTrue:
			[srcPosArg + sizeArg - 1 ->:s;
			destPosArg + sizeArg - 1 ->:d;
			sizeArg timesDo: [:i self at: d - i put: (srcArg at: s - i)]]
		ifFalse:
			[sizeArg timesDo: 
				[:i2 self at: destPosArg + i2 
					put: (srcArg at: srcPosArg + i2)]]

***FixedByteArray class.#
	class FixedByteArray AbstractFixedArray 254;

****[man.c]
*****#en
Fixed-length byte array.

Only integers from 0 to 255 can be stored as elements.
*****#ja
固定長バイト配列。

要素として0〜255の整数のみを保持出来る。
****[test] Test.FixedByteArray class.@
	UnitTest addSubclass: #Test.FixedByteArray instanceVars: "ar"
*****Test.FixedByteArray >> setup
	FixedByteArray basicNew: 10 ->ar;
	ar size timesDo: [:i ar at: i put: i]
	
****FixedByteArray >> serializeTo: writerArg
	self serializeBytesTo: writerArg

****FixedByteArray >> byteAt: posArg
	$object_basicAt -- self basicAt: posArg!

****FixedByteArray >> bytesDo: blockArg
	self size timesDo: [:i blockArg value: (self byteAt: i)]
*****[test.m]
	StringWriter new ->:wr;
	ar bytesDo: [:byte wr put: byte];
	self assert: wr asString = "0123456789"

****FixedByteArray >> bytesHash: caseInsensitiveArg?
	$fbarray_bytesHash
*****[test.m]
	self assert: (ar bytesHash: false) = 597101

****FixedByteArray >> basicAt: destPosArg copyFrom: srcArg at: srcPosArg 
		size: sizeArg
	$fbarray_copy
*****[test.m]
	FixedByteArray basicNew: 3 ->:a;
	a basicAt: 0 copyFrom: ar at: 3 size: 3;
	self assert: a asString = "3 4 5"

****FixedByteArray >> basicAt: posArg unmatchIndexWith: fbaArg at: fbaPosArg
		size: sizeArg
	$fbarray_unmatchIndex
*****[test.m]
	ar copy ->:a;
	self assert: (ar basicAt: 0 unmatchIndexWith: a at: 0 size: a size) nil?;
	ar at: 5 put: 0;
	self assert: (ar basicAt: 0 unmatchIndexWith: a at: 0 size: a size) = 5

****FixedByteArray >> unmatchIndexWith: fbaArg size: sizeArg
	self basicAt: 0 unmatchIndexWith: fbaArg at: 0 size: sizeArg!
****FixedByteArray >> contentsEqual?: fbaArg
	self size ->:sz, = fbaArg size
		and: [self unmatchIndexWith: fbaArg size: sz, nil?]!
*****[test.m]
	#(1 2 3) asArray asFixedByteArray ->:a;
	self assert: (a contentsEqual?: #(1 2 3) asArray asFixedByteArray);
	self assert: (a contentsEqual?: #(1 2 2) asArray asFixedByteArray) not;
	self assert: (a contentsEqual?: #(1 2) asArray asFixedByteArray) not

****FixedByteArray >> makeStringFrom: fromArg size: sizeArg
	String basicNew: sizeArg,
		basicAt: 0 copyFrom: self at: fromArg size: sizeArg,
		initHash!
*****[test.m]
	FixedByteArray basicNew: 4, at: 1 put: 'a' code, at: 2 put: 'b' code ->:fba;
	self assert: (fba makeStringFrom: 1 size: 2) = "ab"

****FixedByteArray >> indexOf: byteArg from: fromArg until: untilArg
	$fbarray_index
*****[test.m]
	self assert: (ar indexOf: 3 from: 3 until: 7) = 3;
	self assert: (ar indexOf: 3 from: 4 until: 7) nil?;
	self assert: (ar indexOf: 6 from: 6 until: 2) = 6;
	self assert: (ar indexOf: 6 from: 5 until: 2) nil?

****FixedByteArray >> indexOf: fbaArg size: sizeArg 
		from: fromArg until: untilArg
	$fbarray_index2
	
***AbstractString class.#
	class AbstractString FixedByteArray;

****[man.c]
*****#en
An abstract class that provides common functionality for strings and symbols.

Elements are limited to instances of Char and their contents cannot be changed.
*****#ja
文字列及びシンボルの共通機能を提供する抽象クラス。

要素はCharのインスタンスに限定され、内容を変更する事は出来ない。
****[test] Test.AbstractString class.@
	UnitTest addSubclass: #Test.AbstractString instanceVars: "s"
*****Test.AbstractString >> setup
	"abc" ->s
	
****AbstractString >> at: posArg put: valueArg
	--modifications are not permitted.
	self assertFailed
*****[test.m]
	self assertError: [s at: 1 put: 'b'] message: "assertFailed"

****AbstractString >> initHash
	self hash: (self bytesHash: false)
*****[test.m]
	s hash ->:h;
	s hash: 0;
	s initHash;
	self assert: h = s hash

****AbstractString >> at: posArg
	self byteAt: posArg, asChar!
*****[test.m]
	self assert: (s at: 1) = 'b'

****AbstractString >> printOn: writerArg
	writerArg putString: self
*****[test.m]
	s printOn: (StringWriter new ->:wr);
	self assert: wr asString = "abc"

****AbstractString >> indexOf: charArg from: fromArg until: untilArg
	super indexOf: charArg code from: fromArg until: untilArg!
*****[test.m]
	"0123456789" ->s;
	self assert: (s indexOf: '3' from: 3 until: 7) = 3;
	self assert: (s indexOf: '3' from: 4 until: 7) nil?;
	self assert: (s indexOf: '6' from: 6 until: 2) = 6;
	self assert: (s indexOf: '6' from: 5 until: 2) nil?
	
****AbstractString >> includes?: charArg
	self indexOf: charArg from: 0 until: self size, notNil?!
*****[test.m]
	"0123456789" ->s;
	self assert: (s includes?: '5');
	self assert: (s includes?: 'a') not
	
***String class.#
	class String AbstractString 253;
		feature String Magnitude;

****[man.c]
*****#en
String class.

It can be constructed by literal notation in the program, asString message for objects, partial extraction by copyFrom:until:, etc.
*****#ja
文字列。

プログラム記述上のリテラル表記、オブジェクトに対するasStringメッセージ、copyFrom:until:による部分抽出等で構築出来る。
****[test] Test.String class.@
	UnitTest addSubclass: #Test.String instanceVars: "s"
*****Test.String >> setup
	"abcde" ->s
	
****String >> asString
	self!
*****[test.m]
	self assert: s asString = "abcde"
	
****String >> + objectArg
	StringWriter new put: self, put: objectArg, asString!
*****[man.m]
******#en
Construct a string with the string representation of objectArg added to the receiver.
******#ja
レシーバーにobjectArgの文字列表現を追加した文字列を構築する。
*****[test.m]
	self assert: s + 'x' = "abcdex";
	self assert: s + 1 = "abcde1"
	
****String >> describeOn: writerArg
	writerArg put: '"';
	StringReader new init: self ->:r;
	[r getWideChar ->:ch, notNil?] whileTrue: [ch printEscapedOn: writerArg];
	writerArg put: '"'
*****[test.m]
	s + "'" describeOn: (StringWriter new ->:wr);
	self assert: wr asString = "\"abcde\\'\""
	
****String >> < stringArg
	self unmatchIndexWith: stringArg size: (self size min: stringArg size) 
			->:pos, nil?
		ifTrue: [self size < stringArg size]
		ifFalse: [self byteAt: pos, < (stringArg byteAt: pos)]!
*****[test.m]
	self assert: (s < "abcd") not;
	self assert: (s < "abcdd") not;
	self assert: (s < "abcde") not;
	self assert: s < "abcdf";
	self assert: s < "abcdef"
	
****String >> = stringArg
	stringArg memberOf?: String,
		and: [self hash = stringArg hash],
		and: [self contentsEqual?: stringArg]!
*****[test.m]
	self assert: s = "abcde";
	self assert: (s = "abc") not;
	self assert: (s = nil) not

****String >> asSymbol
	SymbolTable get: self!
*****[man.m]
******#en
Returns a symbol with the same name as the string.
******#ja
文字列と同名のシンボルを返す。
*****[test.m]
	self assert: s asSymbol = #abcde

****String >> asNumber
	AheadReader new init: self, skipNumber!
*****[man.m]
******#en
Interprets the string as a numeric representation of the Mulk language and returns a Number instance.

Skip white space before numeric expression.
If the interpretation fails, an error is rased.
******#ja
文字列をMulk言語の数値表現として解釈しNumberのインスタンスを返す。

数値表現の前の空白はスキップする。
解釈に失敗した場合はエラーを発生させる。
*****[test.m]
	self assert: "123" asNumber = 123;
	self assert: "-123" asNumber = -123;
	self assert: "4294967296" asNumber = 4294967296;
	self assert: "3.14" asNumber = 3.14;
	self assert: "0xff" asNumber = 255;
	self assert: "0xff.123" asNumber = 255

****String >> asInteger
	self asNumber ->:result, kindOf?: Integer, ifFalse:
		[self error: "require Integer"];
	result!
*****[man.m]
******#en
Interprets the string as an integer representation of the Mulk language and returns an Integer instance.

Skip white space before numeric expression.
If the interpretation fails, an error is generated.
******#ja
文字列をMulk言語の整数表現として解釈し、Integerのインスタンスを返す。

数値表現の前の空白はスキップする。
解釈に失敗した場合はエラーを発生させる。
*****[test.m]
	self assert: "123" asInteger = 123;
	self assertError: ["123.45" asInteger] message: "require Integer"

****String >> asFile
	File.current fileOfPath: self!
*****[man.m]
******#en
Returns an instance of File whose path name is a string.
******#ja
文字列をパス名とするFileのインスタンスを返す。

****String >> asSystemFileIfNotExist: blockArg
	Mulk.extraSystemDirectory ->:ext, notNil? ifTrue:
		[ext + self ->:file, readableFile? ifTrue: [file!]];
	Mulk.systemDirectory + self ->file, readableFile? ifTrue: [file!];
	blockArg value!
****String >> asSystemFile
	self asSystemFileIfNotExist:
		[self error: "system file " + self + " not exist"]!
*****[man.m]
******#en
Returns a file object of the system directory whose file name is a string.

Generate an error if there is no readable file.
******#ja
文字列をファイル名とするシステムディレクトリのファイルオブジェクトを返す。

可読なファイルが存在しない場合はエラーと発生させる。

****String >> asWorkFile
	Mulk.workDirectory + self!
*****[man.m]
******#en
Returns a file object of the work directory whose file name is a string.
******#ja
文字列をファイル名とするワークディレクトリのファイルオブジェクトを返す。

****String >> copyFrom: fromArg until: untilArg
	super copyFrom: fromArg until: untilArg, initHash!
*****[test.m]
	self assert: (s copyFrom: 1 until: 4) = "bcd"

****String >> head?: charArg
	self size > 0 and: [self first = charArg]!
*****[man.m]
******#en
Returns true if the receiver is not an empty string and starts with charArg.
******#ja
レシーバーが空文字列でなく、先頭がcharArgだった場合にtrueを返す。
*****[test.m]
	self assert: ("" head?: 'a') not;
	self assert: (s head?: 'a');
	self assert: (s head?: 'b') not
	
****String >> substringAfter: posArg equal?: stringArg
	stringArg size ->:targetSize;
	self size < (targetSize + posArg) ifTrue: [false!];
	self basicAt: posArg unmatchIndexWith: stringArg at: 0 size: targetSize, 
		nil?!
*****[man.m]
******#en
Returns true if the stringArg after the posArg character of the receiver matches stringArg.

If the receiver is longer, it is considered to match.
******#ja
レシーバーのposArg文字目以降がstringArgと一致する場合、trueを返す。

レシーバーの方が長い分には一致すると見做される。
*****[test.m]
	self assert: (s substringAfter: 1 equal?: "bcd");
	self assert: (s substringAfter: 1 equal?: "bce") not

****String >> heads?: stringArg
	self substringAfter: 0 equal?: stringArg!
*****[man.m]
******#en
Returns true if the receiver starts with stringArg.
******#ja
レシーバーの先頭がstringArgで始まる場合、trueを返す。
*****[test.m]
	self assert: (s heads?: "abc");
	self assert: (s heads?: "bcd") not

****String >> indexOfSubstring: stringArg
	self indexOf: stringArg size: stringArg size from: 0 until: self size!
*****[man.m]
******#en
If the receiver contains stringArg as a substring, return its start position.

Returns nil if not included.
******#ja
レシーバーが部分文字列としてstringArgを含む場合、その先頭位置を返す。

含まない場合はnilを返す。
*****[test.m]
	self assert: (s indexOfSubstring: "cde") = 2;
	self assert: (s indexOfSubstring: "bce") nil?

****String >> includesSubstring?: stringArg
	self indexOfSubstring: stringArg, notNil?!
*****[man.m]
******#en
Returns true if the receiver contains stringArg as a substring.
******#ja
レシーバーが部分文字列としてstringArgを含む場合、trueを返す。
*****[test.m]
	self assert: (s includesSubstring?: "cde");
	self assert: (s includesSubstring?: "bce") not
		
****String >> split: charArg
	Iterator new init:
		[:b
		0 ->:st;
		[self indexOf: charArg after: st ->:pos, notNil?] whileTrue:
			[st <> pos ifTrue: [b value: (self copyFrom: st until: pos)];
			pos + 1 ->st];
		st <> self size ifTrue: [b value: (self copyFrom: st)]]!
*****[man.m]
******#en
Returns an Iterator over the substrings of the receiver separated by charArg character.
******#ja
レシーバーをcharArg文字で区切った部分文字列を巡回するIteratorを返す。
*****[test.m]
	self assert: (s split: 'c', asArray asString = "ab de")
	
****String >> lowerDo: blockArg
	self do: [:ch blockArg value: ch lower]

****String >> lower
	StringWriter new ->:w;
	self lowerDo: [:ch w put: ch];
	w asString!
*****[man.m]
******#en
Returns the uppercase letters in the string with lowercase letters.
******#ja
文字列に含まれる英大文字を小文字としたものを返す。
*****[test.m]
	self assert: "AbCdE" lower = "abcde"
*****#ja
******[test.m] wideChar
	-- SJISではアの第二バイトは'A'だが変換されない。
	self assert: "ア" lower = "ア" 

****String >> caseInsensitiveEqual?: stringArg
	stringArg memberOf?: String, ifFalse: [false!];
	self size ->:sz, = stringArg size, ifFalse: [false!];
	self hash = stringArg hash,
		and: [self unmatchIndexWith: stringArg size: sz, nil?],
		ifTrue: [true!];

	self size timesDo:
		[:i
		(self at: i) lower = (stringArg at: i) lower, ifFalse: [false!]];
	true!
*****[man.m]
******#en
Equivalent to stringArg and not case sensitive.
******#ja
stringArgと大文字と小文字を区別せずに等価判定する。
*****[test.m]
	self assert: ("AbCdE" caseInsensitiveEqual?: "aBcDe")
*****#ja
******[test.m] wideChar
	--trailCharは比較には影響しない
	self assert: ("ア" caseInsensitiveEqual?: "ヂ") not
	
****String >> trim
	self findFirst: [:ch ch space? not] ->:st, nil? ifTrue: [""!];
	self findLast: [:ch2 ch2 space? not] ->:en;
	self copyFrom: st until: en + 1!
*****[man.m]
******#en
Returns a string with leading and trailing whitespace characters removed.
******#ja
文字列の先頭と末尾の空白文字を除いた文字列を返す。
*****[test.m]
	self assert: "  \t  " trim = "";
	self assert: "abc" trim = "abc";
	self assert: "  abc  " trim = "abc"

***Symbol class.#
	class Symbol AbstractString 252;

****[man.c]
*****#end
A unique identifier.

Symbols can be constructed by sending an asSymbol message to a literal expression or String.
Since there is only one symbol object with the same name in the system and equivalence can be determined at high speed, it is treated like an enumeration type element.
*****#ja
ユニークな識別子。

シンボルはリテラル表現もしくはStringにasSymbolメッセージを送る事で構築出来る。
同名のシンボルオブジェクトはシステム中に一つだけ存在し、高速で等価判定が出来るので列挙型の要素のように扱う。
	
****Symbol >> describeOn: writerArg
	writerArg put: '#', put: self
*****[test.m]
	#a describeOn: (StringWriter new ->:wr);
	self assert: wr asString = "#a"

****Symbol >> copyFrom: fromArg until: untilArg
	self assertFailed
*****[test.m]
	self assertError: [#abc copyFrom: 1 until: 2] message: "assertFailed"

***Array class.#
	class Array AbstractArray : size elements;

****[man.c]
*****#en
General purpose array.

After construction, you can change to any size and hold any object.
*****#ja
汎用の配列。

構築後、任意のサイズに変更可能で任意のオブジェクトを保持出来る。
****[test] Test.Array class.@
	UnitTest addSubclass: #Test.Array instanceVars: "a"
*****Test.Array >> setup
	Array new addLast: 1, addLast: 4, addLast: 9, addLast: 16, addLast: 25 ->a
	
****Array >> init
	0 ->size;
	FixedArray basicNew: 4 ->elements
*****[test.m]
	self assert: Array new size = 0
	
****Array >> size
	size!
*****[test.m]
	self assert: a size = 5
	
****Array >> at: posArg
	self assert: posArg < size;
	elements at: posArg!
*****[test.m]
	self assert: (a at: 2) = 9;
	self assertError: [a at: 5] message: "assertFailed"
	
****Array >> at: posArg put: valueArg
	self assert: posArg < size;
	elements at: posArg put: valueArg
*****[test.m]
	a at: 2 put: #a;
	self assert: (a at: 2) = #a;
	self assertError: [a at: 5 put: #b] message: "assertFailed"
	
****Array >> size: sizeArg
	elements size ->:es;
	es < sizeArg ifTrue:
		[[es < sizeArg] whileTrue: [es * 2 ->es];
		FixedArray basicNew: es,
			basicAt: 0 copyFrom: elements at: 0 size: size ->elements];
	sizeArg < size ifTrue:
		[elements fill: nil from: sizeArg until: size];
	sizeArg ->size
*****[man.m]
******#en
Change the size of the array to sizeArg.
******#ja
配列のサイズをsizeArgに変更する。
*****[test.m]
	a size: 3;
	self assert: a size = 3;
	a size: 10;
	self assert: a size = 10;
	self assert: (a at: 3) nil?

****Array >> addLast: objectArg
	size ->:pos;
	self size: size + 1;
	elements at: pos put: objectArg
*****[man.m]
******#en
Add objectArg to the last of the array.
******#ja
配列の最後にobjectArgを追加する。
*****[test.m]
	a addLast: #last;
	self assert: a size = 6;
	self assert: (a at: 5) = #last

****Array >> add: objectArg beforeIndex: posArg
	self size: size + 1;
	elements basicAt: posArg + 1 copyFrom: elements at: posArg 
		size: size - 1 - posArg;
	elements at: posArg put: objectArg
*****[man.m]
******#en
Insert objectArg just before the posArg-th of the array.

After execution, the posArg-th element becomes objectArg.
******#ja
配列のposArg番目の直前にobjectArgを挿入する。

実行後、posArg番目の要素はobjectArgとなる。
*****[test.m]
	a add: #insert beforeIndex: 1;
	self assert: a size = 6;
	self assert: (a at: 0) = 1;
	self assert: (a at: 1) = #insert;
	self assert: (a at: 2) = 4

****Array >> addFirst: objectArg
	self add: objectArg beforeIndex: 0
*****[man.m]
******#en
Insert objectArg at the first of the array.
******#ja
配列の先頭にobjectArgを挿入する。
*****[test.m]
	a addFirst: 99;
	self assert: a asString = "99 1 4 9 16 25"

****Array >> addAll: collectionArg
	collectionArg do: [:obj self addLast: obj]
*****[man.m]
******#en
Append all elements of collectionArg to the last of the array.
******#ja
配列の最後にcollectionArgの全ての要素を追加する。
*****[test.m]
	a addAll: #(36 49);
	self assert: a asString = "1 4 9 16 25 36 49"
	
****Array >> removeAt: posArg
	self assert: posArg < size;
	elements basicAt: posArg copyFrom: elements at: posArg + 1 
		size: size - posArg - 1;
	size - 1 ->size;
	elements at: size put: nil
*****[man.m]
******#en
Remove the posArg-th element.
******#ja
posArg番目の要素を削除する。
*****[test.m]
	a removeAt: 1;
	self assert: a asString = "1 9 16 25"
*****[test.m] error
	self assertError: [a removeAt: 5] message: "assertFailed"
	
****Array >> removeFirst
	self removeAt: 0
*****[man.m]
******#en
Remove the first element.
******#ja
先頭の要素を削除する。
*****[test.m]
	a removeFirst;
	self assert: a asString = "4 9 16 25"
	
****Array >> removeLast
	self removeAt: size - 1
*****[man.m]
******#en
Remove the last element.
******#ja
末尾の要素を削除する。
*****[test.m]
	a removeLast;
	self assert: a asString = "1 4 9 16"

****Array >> remove: objectArg
	self removeAt: (self indexOf: objectArg)
*****[man.m]
******#en
Remove the first element equivalent to objectArg.
******#ja
objectArgと等価な最初の要素を削除する。
*****[test.m]
	a remove: 9;
	self assert: a asString = "1 4 16 25"

****Array >> removeFrom: fromArg until: untilArg
	self assert: fromArg <= untilArg;
	self assert: untilArg <= size;
	size - (untilArg - fromArg) ->:ns;
	elements basicAt: fromArg copyFrom: elements at: untilArg 
		size: size - untilArg;
	elements fill: nil from: ns until: size;
	ns ->size
*****[man.m]
******#en
Remove elements from fromArg to just before untilArg.
******#ja
fromArg番目からuntilArg番目の直前までの要素を削除する。
*****[test.m]
	a removeFrom: 1 until: 4;
	self assert: a asString = "1 25"
*****[test.m] error
	self assertError: [a removeFrom: 4 until: 6] message: "assertFailed";
	self assertError: [a removeFrom: 5 until: 4] message: "assertFailed"
	
****Array >> removeFrom: fromArg
	self removeFrom: fromArg until: size
*****[man.m]
******#en
Remove the elements from fromArg to the end.
******#ja
fromArg番目から最後までの要素を削除する。
*****[test.m]
	a removeFrom: 3;
	self assert: a asString = "1 4 9"
	
****Array >> removeUntil: untilArg
	self removeFrom: 0 until: untilArg
*****[man.m]
******#en
Remove the element from the first element to the element just before the untilArg.
******#ja
先頭要素からuntilArg番目の直前までの要素を削除する。
*****[test.m]
	a removeUntil: 2;
	self assert: a asString = "9 16 25"

****Array >> removeAll
	self size: 0
*****[man.m]
******#en
Remove all elements.
******#ja
全ての要素を削除する。
*****[test.m]
	a removeAll;
	self assert: a size = 0
		
****Array >> asFixedArray
	FixedArray basicNew: size,
		basicAt: 0 copyFrom: elements at: 0 size: size!
*****[man.m]
******#en
Returns a FixedArray with the same contents as the receiver.
******#ja
レシーバーと同じ内容のFixedArrayを返す。
*****[test.m]
	a asFixedArray ->a;
	self assert: (a memberOf?: FixedArray);
	self assert: a asString = "1 4 9 16 25"
	
****Array >> asFixedByteArray
	FixedByteArray basicNew: size ->:result;
	size timesDo:
		[:i
		result at: i put: (elements at: i)];
	result!
*****[man.m]
******#en
Returns a FixedByteArray with the same contents as the receiver.

The element must not contain an object other than an integer from 0 to 255.
******#ja
レシーバーと同じ内容のFixedByteArrayを返す。

要素として0〜255の整数以外のオブジェクトが含まれていてはならない。
*****[test.m]
	a asFixedByteArray ->a;
	self assert: (a memberOf?: FixedByteArray);
	self assert: a asString = "1 4 9 16 25"

****Array >> copyFrom: fromArg until: untilArg
	self class new ->:result;
	fromArg until: untilArg, do: [:i result addLast: (self at: i)];
	result!
*****[test.m]
	self assert: (a copyFrom: 1 until: 4) describe = "aArray(4 9 16)"
	
**Hash tables.
***HashTable.Node class.#
	class HashTable.Node Object : next key;
		feature HashTable.Node Collection;
****[test] Test.HashTable.Node class.@
	UnitTest addSubclass: #Test.HashTable.Node instanceVars: "n"
*****Test.HashTable.Node >> setup
	HashTable.Node new key: #a, next: (HashTable.Node new key: #b) ->n

****HashTable.Node >> next
	next!
*****[test.m]
	self assert: n next key = #b

****HashTable.Node >> key
	key!
*****[test.m]
	self assert: n key = #a

****HashTable.Node >> next: nodeArg
	nodeArg ->next
*****[test.m]
	n next: nil;
	self assert: n next nil?

****HashTable.Node >> key: keyArg
	keyArg ->key
*****[test.m]
	n key: #c;
	self assert: n key = #c

****HashTable.Node >> removeNode: nodeArg
	self = nodeArg ifTrue: [next!];
	self ->:n;
	[n next <> nodeArg] whileTrue: [n next ->n];
	n next: nodeArg next
*****[test.m] 1
	n removeNode: n next ->n;
	self assert: n key = #a & n next nil? 
*****[test.m] 2
	n removeNode: n ->n;
	self assert: n key = #b & n next nil?

****HashTable.Node >> do: blockArg
	self ->:n;
	[n notNil?] whileTrue:
		[n next ->:nNext;
		blockArg value: n;
		nNext ->n]
*****[test.m]
	"" ->:s;
	n do: [:node s + node key ->s];
	self assert: s = "ab"

***HashTable class.#
	class HashTable Object : table size;
		feature HashTable Collection;

****[man.c]
*****#en
Hash table.

An abstract class that provides the common functionality of Collection with any object as a key.
Elements can be accessed efficiently using the hash value of the key object.
*****#ja
ハッシュテーブル。

任意のオブジェクトをキーとするCollectionの共通機能を提供する抽象クラス。
キーとなるオブジェクトのハッシュ値を利用して効率的に要素にアクセス出来る。
****[test] Test.HashTable class.@
	UnitTest addSubclass: #Test.HashTable instanceVars: "ht"
*****Test.HashTable >> setup
	HashTable new ->ht;
	ht
		addNode: (HashTable.Node new key: #a),
		addNode: (HashTable.Node new key: #b),
		addNode: (HashTable.Node new key: #c)
	
****HashTable >> init
	FixedArray basicNew: 4 ->table;
	0 ->size
*****[test.m]
	ht init;
	self assert: ht empty?

****HashTable >> tableIndex: keyArg
	keyArg hash % table size!
*****[test.m]
	self assert: (ht tableIndex: 0) = 0

****HashTable >> nodeAt: keyArg
	table at: (self tableIndex: keyArg) ->:node;
	node nil? ifTrue: [nil] ifFalse: [node detect: [:n n key = keyArg]]!
*****[test.m]
	self assert: (ht nodeAt: #a) key = #a;
	self assert: (ht nodeAt: #z) = nil

****HashTable >> addNode: nodeArg
	size + 1 ->size;
	self tableIndex: nodeArg key ->:ix;
	nodeArg next: (table at: ix);
	table at: ix put: nodeArg
*****[test.m]
	ht addNode: (HashTable.Node new key: #d ->:n);
	self assert: (ht nodeAt: #d) = n

****HashTable >> removeNode: nodeArg
	size - 1 ->size;
	self tableIndex: nodeArg key ->:ix;
	table at: ix put: (table at: ix, removeNode: nodeArg)
*****[test.m]
	ht removeNode: (ht nodeAt: #a);
	self assert: (ht nodeAt: #a) = nil

****HashTable >> rehash
	table ->:oldTable;
	FixedArray basicNew: oldTable size * 2 ->table;
	0 ->size;
	oldTable do:
		[:node
		node notNil? ifTrue: [node do: [:n self addNode: n]]]

****HashTable >> size
	size!
*****[test.m]
	self assert: ht size = 3

****HashTable >> removeNodeAt: keyArg
	self nodeAt: keyArg ->:node, nil? ifTrue:
		[self error: keyArg describe +" not found"];
	self removeNode: node
*****[test.m]
	ht removeNodeAt: #b;
	self assert: ht size = 2;
	self assert: (ht nodeAt: #b) = nil

****HashTable >> do: blockArg
	table do:
		[:nodes
		nodes notNil? ifTrue: [nodes do: [:n blockArg value: n]]]
*****[test.m]
	StringWriter new ->:wr;
	ht do: [:n wr put: n key];
	self assert: wr asString = "abc"

***Set class.#
	class Set HashTable;

****[man.c]
*****#en
Set.

Any object can be used as a key in a collection with the key itself as a value.
*****#ja
集合。

キーそのものを値とするCollectionでキーとしては任意のオブジェクトを使用出来る。
****[test] Test.Set class.@
	UnitTest addSubclass: #Test.Set instanceVars: "set"
*****Test.Set >> setup
	Set new add: "a", add: "b", add: "c" ->set
	
****Set >> add: keyArg
	self nodeAt: keyArg ->:node, notNil? ifTrue: [self!];
	size > (table size * 3 // 4) and: [size < 0x100000], ifTrue: [self rehash];
	self addNode: (HashTable.Node new key: keyArg)
*****[man.m]
******#en
Add element keyArg.
******#ja
要素keyArgを追加する。
*****[test.m]
	set add: "b";
	self assert: set size = 3;
	set add: "d";
	self assert: set size = 4

****Set >> addAll: keysArg
	keysArg do: [:key self add: key]
*****[man.m]
******#en
Add all the contents of Collection keysArg.
******#ja
Collection keysArgの内容を全て追加する。
*****[test.m]
	set addAll: #("b" "d");
	self assert: set size = 4
	
****Set >> remove: keyArg
	self removeNodeAt: keyArg
*****[man.m]
******#en
Remove element keyArg.
******#ja
要素keyArgを削除する。

****Set >> includes?: keyArg
	self nodeAt: keyArg, notNil?!
*****[test.m]
	self assert: (set includes?: "a");
	self assert: (set includes?: "e") not

****Set >> do: blockArg
	super do: [:n blockArg value: n key]
*****[test.m]
	StringWriter new ->:wr;
	set do: [:x wr put: x];
	self assert: wr asString = "abc"

****Set >> describeOn: writerArg
	super printOn: writerArg;
	writerArg put: '(';
	self do: [:n n describeOn: writerArg] separatedBy: [writerArg put: ' '];
	writerArg put: ')'
*****[test.m]
	self assert: set describe = "aSet(\"a\" \"b\" \"c\")"
	
***SymbolTable class.#
	class SymbolTable.class Set;
		singleton SymbolTable.class SymbolTable;

****SymbolTable.class >> nodeAt: keyArg
	table at: (self tableIndex: keyArg) ->:node;
	node nil?
		ifTrue: [nil]
		ifFalse: [node detect: [:n n key contentsEqual?: keyArg]]!
*****[test.m]
	self assert: (SymbolTable nodeAt: "b") key = #b

****SymbolTable.class >> get: stringArg
	self nodeAt: stringArg ->:node, nil?
		ifTrue:
			[stringArg size ->:len;
			Symbol basicNew: len,
				basicAt: 0 copyFrom: stringArg at: 0 size: len, 
				initHash ->:symbol;
			self add: symbol;
			symbol]
		ifFalse: [node key]!
*****[test.m]
	self assert: (SymbolTable get: "b") = #b

***Dictionary.Node class.#
	class Dictionary.Node HashTable.Node : value;

****[test] Test.Dictionary.Node class.@
	UnitTest addSubclass: #Test.Dictionary.Node instanceVars: "node"
*****Test.Dictionary.Node >> setup
	Dictionary.Node new value: #a ->node

****Dictionary.Node >> value
	value!
*****[test.m]
	self assert: node value = #a

****Dictionary.Node >> value: valueArg
	valueArg ->value
*****[test.m]
	node value: #b;
	self assert: node value = #b

***Dictionary class.#
	class Dictionary HashTable;

****[man.c]
*****#en
Associative array class.

Holds any object combination as a key and value.
It also functions as a Collection for values.
*****#ja
連想配列クラス。

任意のオブジェクトの組み合わせをキーと値として保持する。
値に対するCollectionとしても機能する。
****[test] Test.Dictionary class.@
	UnitTest addSubclass: #Test.Dictionary instanceVars: "d"
*****Test.Dictionary >> setup
	Dictionary new,
		at: 1 put: "one",
		at: 2 put: "two",
		at: 3 put: "three" ->d

****Dictionary >> at: keyArg put: valueArg
	self nodeAt: keyArg ->:node, notNil?
		ifTrue: [node value: valueArg]
		ifFalse:
			[size > (table size * 3 // 4) and: [size < 0x100000],
				ifTrue: [self rehash];
			self addNode: (Dictionary.Node new key: keyArg, value: valueArg)]
*****[man.m]
******#en
Set valueArg for key keyArg.
******#ja
キーkeyArgに対してvalueArgを設定する。
*****[test.m]
	d at: 4 put: "four";
	self assert: (d at: 4) = "four";
	d at: 2 put: "zwei";
	self assert: (d at: 2) = "zwei"

****Dictionary >> at: keyArg ifAbsent: blockArg
	self nodeAt: keyArg ->:node, nil?
		ifTrue: [blockArg value]
		ifFalse: [node value]!
*****[man.m]
******#en
Returns the value assigned to the key keyArg.

If no value is assigned to keyArg, blockArg is evaluated.
******#ja
キーkeyArgに割り当てられた値を返す。

keyArgに値が割り当てられていない場合はblockArgが評価される。
*****[test.m]
	false ->:absent?;
	d at: 4 ifAbsent: [true ->absent?];
	self assert: absent?

****Dictionary >> at: keyArg
	self at: keyArg ifAbsent: [self error: keyArg describe +" not found"]!
*****[man.m]
******#en
Returns the value assigned to the key keyArg.

An error occurs if no value is assigned to keyArg.
******#ja
キーkeyArgに割り当てられた値を返す。
keyArgに値が割り当てられていない場合はエラーとなる。
*****[test.m]
	self assert: (d at: 2) = "two";
	self assertError: [d at: 4] message: "4 not found"

****Dictionary >> at: keyArg ifAbsentPut: blockArg
	self at: keyArg ifAbsent:
		[self at: keyArg put: (blockArg value ->:v);
		v]!
*****[man.m]
******#en
Returns the value assigned to the key keyArg.

If no value is assigned to keyArg, the blockArg evaluation result is set as the value and returned.
******#ja
キーkeyArgに割り当てられた値を返す。

keyArgに値が割り当てられていなければ、blockArgの評価結果を値として設定した上で返す。
*****[test.m]
	self assert: (d at: 2 ifAbsentPut: ["five"]) = "two";
	self assert: (d at: 4 ifAbsentPut: ["four"]) = "four"
	
****Dictionary >> removeAt: keyArg
	self removeNodeAt: keyArg
*****[man.m]
******#en
Remove the value assigned to the key keyArg.
******#ja
キーkeyArgに割り当てられた値を削除する。

****Dictionary >> do: blockArg
	super do: [:n blockArg value: n value]
	
****Dictionary >> keys
	Iterator new init: [:b super do: [:n b value: n key]]!
*****[man.m]
******#en
Returns an Iterator of all keys.
******#ja
全てのキーのIteratorを返す。
*****[test.m]
	self assert: d keys asArray asString = "1 2 3"
	
****Dictionary >> includesKey?: keyArg
	self nodeAt: keyArg, notNil?!
*****[man.m]
******#en
Returns true if a value is assigned to the key keyArg.
******#ja
キーkeyArgに値が割り当てられていればtrueを返す。
*****[test.m]
	self assert: (d includesKey?: 2);
	self assert: (d includesKey?: 4) not

****Dictionary >> keysAndValuesDo: blockArg
	super do: [:n blockArg value: n key value: n value]
*****[man.m]
******#en
Evaluate blockArg with all keys and values as arguments.
******#ja
全てのキーと値を引数としてblockArgを評価する。
*****[test.m]
	Array new ->:ar;
	d keysAndValuesDo:
		[:k :v 
		ar addLast: k;
		ar addLast: v];
	self assert: ar asString = "1 one 2 two 3 three"
	
****Dictionary >> inspect
	Out putLn: self describe;
	self keysAndValuesDo:
		[:k :v Out put: k describe, put: ' ', putLn: v describe]
	
***StrictDictionary class.#
	--StrictDictionary distinct 1 and 1.0 as other key.
	class StrictDictionary Dictionary;

****[test] Test.StrictDictionary class.@
	UnitTest addSubclass: #Test.StrictDictionary instanceVars: "d"
*****Test.StrictDictionary >> setup
	StrictDictionary new,
		at: 1 put: "one",
		at: 1.0 put: "float-one" ->d

****StrictDictionary >> nodeAt: keyArg
	table at: (self tableIndex: keyArg) ->:node;
	node nil?
		ifTrue: [nil]
		ifFalse:
			[node detect:
				[:n
				n key ->:nk;
				keyArg kindOf?: Number, and: [keyArg class <> nk class],
					ifTrue: [false]
					ifFalse: [keyArg = nk]]]!
*****[test.m]
	self assert: (d nodeAt: 1, value = "one");
	self assert: (d nodeAt: 1.0, value = "float-one")

**Cons class.#
	class Cons Object : car cdr;
		feature Cons Collection;

***[man.c]
****#en
Cons list.

A class that corresponds to the Cons cell in Lisp and is used to build general-purpose trees and tuples.
In addition to normal car and cdr references, it provides an API for using cdr-direction concatenation as a unidirectional list and can also be used as a collection.
car / cdr notation is in reverse order of Lisp.
****#ja
Consリスト。

LispのConsセルに相当するクラスで、汎用の木構造及びタブルを構築するのに用いる。
通常のcar, cdrの参照の他に、cdr方向の連接を単方向リストとして使用する為のAPIを供え、Collectionとしても使用出来る。
car/cdrの連続記法はLispの逆順となる。

***[test] Test.Cons class.@
	UnitTest addSubclass: #Test.Cons instanceVars: "c"
****Test.Cons >> setup
	Cons new car: #a, add: #b, add: #c, add: #d ->c

***Cons >> car: carArg cdr: cdrArg
	carArg ->car;
	cdrArg ->cdr
****[man.m]
*****#en
Set carArg to the receiver's car element and cdrArg to the cdr element.
*****#ja
レシーバーのcar要素にcarArgを、cdr要素にcdrArgをそれぞれ設定する。
****[test.m]
	c car: 1 cdr: 2;
	self assert: c asString = "(1 . 2)"
	
***Cons >> car: carArg
	carArg ->car
****[man.m]
*****#en
Set carArg to the car element of the receiver.
*****#ja
レシーバーのcar要素にcarArgを設定する。
****[test.m]
	c car: #new;
	self assert: c asString = "(#new #b #c #d)"

***Cons >> car
	car!
****[man.m]
*****#en
Returns the car element of the receiver.
*****#ja
レシーバーのcar要素を返す。
****[test.m]
	self assert: c car = #a

***Cons >> cdr: cdrArg
	cdrArg ->cdr
****[man.m]
*****#en
Set the cdr element of the receiver to cdrArg.
*****#ja
レシーバーのcdr要素をcdrArgに設定する。
****[test.m]
	c cdr: #new;
	self assert: c asString = "(#a . #new)"

***Cons >> cdr
	cdr!
****[man.m]
*****#en
Returns the cdr element of the receiver.
*****#ja
レシーバーのcdr要素を返す。
****[test.m]
	self assert: c cdr asString = "(#b #c #d)"

***Cons >> cdar
	cdr car!
****[man.m]
*****#en
Equivalent to self cdr car.
*****#ja
self cdr carと等価。
****[test.m]
	self assert: c cdar = #b

***Cons >> cddr
	cdr cdr!
****[man.m]
*****#en
Equivalent to self cdr cdr.
*****#ja
self cdr cdrと等価。
****[test.m]
	self assert: c cddr asString = "(#c #d)"

***Cons >> cddar
	cdr cdr car!
****[man.m]
*****#en
Equivalent to self cdr cdr car.
*****#ja
self cdr cdr carと等価。
****[test.m]
	self assert: c cddar = #c

***Cons >> cdddr
	cdr cdr cdr!
****[man.m]
*****#en
Equivalent to self cdr cdr cdr.
*****#ja
self cdr cdr cdrと等価。
****[test.m]
	self assert: c cdddr asString = "(#d)"

***Cons >> cdddar
	cdr cdr cdr car!
****[man.m]
*****#en
Equivalent to self cdr cdr cdr car.
*****#ja
self cdr cdr cdr carと等価。
****[test.m]
	self assert: c cdddar = #d

***Cons >> add: valueArg
	cdr nil? 
		ifTrue: [self class new car: valueArg ->cdr] 
		ifFalse: [cdr add: valueArg]
****[man.m]
*****#en
Consider the Cons link in the cdr direction as a list, and add valueArg at the end.
*****#ja
cdr方向へのConsリンクをリストと見做し、末尾にvalueArgを追加する。
****[test.m]
	c add: #e;
	self assert: c asString = "(#a #b #c #d #e)"

***Cons >> printOn: writerArg
	writerArg put: '(';
	car describeOn: writerArg;
	cdr ->:c;
	[c kindOf?: Cons] whileTrue:
		[writerArg put: ' ';
		 c car describeOn: writerArg;
		c cdr ->c];
	c notNil? ifTrue:
		[writerArg put: " . ";
		 c describeOn: writerArg];
	writerArg put: ')'
****[test.m]
	c printOn: (StringWriter new ->:w);
	self assert: w asString = "(#a #b #c #d)"

***Cons >> at: posArg
	posArg = 0 ifTrue: [car] ifFalse: [cdr at: posArg - 1]!
****[man.m]
*****#en
Considers a Cons link in the cdr direction as a list and returns the posArg-th element.
*****#ja
cdr方向へのConsリンクをリストと見做し、posArg-th番目の要素を返す。
****[test.m]
	self assert: (c at: 2) = #c

***Cons >> do: blockArg
	blockArg value: car;
	cdr notNil? ifTrue: [cdr do: blockArg]
****[test.m]
	StringWriter new ->:w;
	c do: [:e w put: e];
	self assert: w asString = "abcd"

**Rings.
***AbstractRing class.#
	class AbstractRing Object : prev next;

****[man.c]
*****#en
Base class for nodes in a circular list.

This class provides the basic functionality of Ring nodes.
*****#ja
環状リスト(Ring)のノードの基底クラス。

このクラスはRingのノードの基本機能を提供する。
****[test] Test.AbstractRing class.@
	UnitTest addSubclass: #Test.AbstractRing instanceVars: "a b c"
*****Test.AbstractRing >> setup
	AbstractRing new ->a;
	AbstractRing new ->b;
	AbstractRing new ->c;
	a link: b;
	b link: c

****AbstractRing >> value
	self shouldBeImplemented
*****[man.m]
******#en
Returns the value of the node.

Since an instance of the Ring class returns nil, if nil is not used as a value, it can be used to determine whether it is a sentinel or not.
******#ja
ノードの値を返す。

Ringクラスのインスタンスの場合はnilを返す為、値としてnilを使用しない場合は番兵か否かの判定に用いる事が出来る。

****AbstractRing >> prev
	prev!
*****[man.m]
******#en
Returns the node linked in previous of the receiver.
******#ja
レシーバーの前方にリンクされたノードを返す。
*****[test.m]
	self assert: b prev = a

****AbstractRing >> next
	next!
*****[man.m]
******#en
Returns the node linked to the next of the receiver.
******#ja
レシーバーの後方にリンクされたノードを返す。
*****[test.m]
	self assert: b next = c

****AbstractRing >> prev: ringArg
	ringArg ->prev
*****[test.m]
	c prev: a;
	self assert: c prev = a

****AbstractRing >> link: ringArg
	ringArg ->next;
	ringArg prev: self
*****[test.m]
	a link: c;
	self assert: a next = c & (c prev = a)
	
****AbstractRing >> addPrev: valueArg
	prev addNext: valueArg
*****[man.m]
******#en
Add a node with value valueArg in previous of the receiver.
******#ja
レシーバーの前方に値valueArgを持つノードを追加する。
*****[test.m]
	b addPrev: #new;
	self assert: b prev value = #new

****AbstractRing >> addNext: valueArg
	Ring.Node new value: valueArg ->:n;
	n link: next;
	self link: n
*****[man.m]
******#en
Add a node with value valueArg in next of the receiver.
******#ja
レシーバーの後方に値valueArgを持つノードを追加する。
*****[test.m]
	b addNext: #new;
	self assert: b next value = #new

***Ring.Node class.#
	class Ring.Node AbstractRing : value;
		
****[man.c]
*****#en
A node in a circular list.

Each element held in the list is held and used as an indicator of the position in the list.
Do not explicitly create instances of this class.
Use the insert message for the constructed node.
*****#ja
環状リストのノード。

リストの保持する個々の要素を保持しており、リスト中の位置のインジゲータとしても使用される。
このクラスのインスタンスを明に作成してはならない。
構築済みのノードに対する挿入メッセージを使用する事。
****[test] Test.Ring.Node class.@
	UnitTest addSubclass: #Test.Ring.Node instanceVars: "n"
*****Test.Ring.Node >> setup
	Ring new addLast: #a, next ->n
	
****Ring.Node >> value
	value!
*****[test.m]
	self assert: n value = #a

****Ring.Node >> value: valueArg
	valueArg ->value
*****[man.m]
******#en
Set valueArg as the value of the node.
******#ja
valueArgをノードの値として設定する。
*****[test.m]
	n value: #b;
	self assert: n value = #b

****Ring.Node >> remove
	prev link: next
*****[man.m]
******#en
Remove the node.

The previous and next nodes of the receiver are directly connected, and the receiver is disconnected from the Ring.
******#ja
ノードを削除する。

レシーバーの前方と後方のノードが直接接続され、レシーバーはRingから切り離される。
*****[test.m]
	n prev ->:r;
	n remove;
	self assert: r next = r & (r prev = r)
	
***Ring class.#
	class Ring AbstractRing;
		feature Ring Collection;

****[man.c]
*****#en
Circular list.

Represents the entire Ring and also functions as a Collection.
The node itself is a sentinel and cannot hold elements.
*****#ja
環状リスト。

Ring全体を代表し、Collectionとしても機能する。
このノード自体は番兵(sentinel)であり、要素を保持出来ない。
****[test] Test.Ring class.@
	UnitTest addSubclass: #Test.Ring instanceVars: "r"
*****Test.Ring >> setup
	Ring new addLast: #a, addLast: #b, addLast: #c ->r

****Ring >> init
	self link: self
*****[test.m]
	Ring new ->r;
	self assert: r empty?

****Ring >> value
	nil!
*****[test.m]
	self assert: r value nil?
	
****Ring >> do: blockArg
	self next ->:p;
	[p <> self] whileTrue: [blockArg value: p value; p next ->p]
*****[test.m]
	StringWriter new ->:w;
	r do: [:e w put: e];
	self assert: w asString = "abc"

****Ring >> empty?
	next = self!
*****[test.m]
	self assert: r empty? not

****Ring >> addFirst: valueArg
	self addNext: valueArg
*****[man.m]
******#en
Add the value valueArg at the first of the list.
******#ja
リストの先頭に値valueArgを追加する。
*****[test.m]
	r addFirst: #add;
	self assert: r first = #add & (r size = 4)

****Ring >> addLast: valueArg
	self addPrev: valueArg
*****[man.m]
******#en
Add the value valueArg at the last of the list.
******#ja
リストの末尾に値valueArgを追加する。
*****[test.m]
	r addLast: #add;
	self assert: r last = #add & (r size = 4)

****Ring >> first
	next value!
*****[man.m]
******#en
Returns the first element in the list.
******#ja
リストの先頭の要素を返す。
*****[test.m]
	self assert: r first = #a

****Ring >> last
	prev value!
*****[man.m]
******#en
Returns the last element in the list.
******#ja
リストの末尾の要素を返す。
*****[test.m]
	self assert: r last = #c

****Ring >> removeFirst
	next remove
*****[man.m]
******#en
Remove the first element of the list.
******#ja
リストの先頭の要素を削除する。
*****[test.m]
	r removeFirst;
	self assert: r first = #b & (r size = 2)

****Ring >> removeLast
	prev remove
*****[man.m]
******#en
Remove the last element of the list.
******#ja
リストの末尾の要素を削除する。
*****[test.m]
	r removeLast;
	self assert: r last = #b & (r size = 2)

****Ring >> nodeOf: valueArg
	self next ->:p;
	[p <> self] whileTrue:
		[p value = valueArg ifTrue: [p!];
		p next ->p];
	nil!
*****[man.m]
******#en
Returns the node with value valueArg.

Returns nil if valueArg is not in the list.
******#ja
値valueArgのノードを返す。

valueArgがリスト中に無い場合はnilを返す。
*****[test.m]
	self assert: (r nodeOf: #b) value = #b;
	self assert: (r nodeOf: nil) nil?

*Stream protocols.#
	singleton TransientGlobalVar Out;
	singleton TransientGlobalVar In;
	singleton TransientGlobalVar Out0;
	singleton TransientGlobalVar In0;
**[man.s]
***#en
Stream protocols define functions for handling streams.

A stream is a mechanism for handling files and consoles, and provides a function that performs input / output in units of characters, character strings, and lines in addition to bytes and byte sequences.

The standard input / output is the following global variable, and a stream corresponding to the standard input / output of the mulk interpreter is allocated.

	Out/Out0 -- standard input
	In/In0 -- standard output

In / Out can be switched by command redirection or pipe library, but In0 / Out0 cannot be switched by these.

***#ja
Stream protocolsはストリームを扱う為の機能を定義する。

ストリームはファイルやコンソールを扱う為の機構で、バイト、バイト列の他、文字、文字列、行といった単位で入出力を行う機能を提供する。

標準入出力は、以下のグローバル変数で、mulkインタプリタの標準入出力に対応するストリームが割り当てられる。

	Out/Out0 -- 標準出力
	In/In0 -- 標準入力。

In/Outはコマンドのリダイレクションやpipeライブラリによって切り替えられるが、In0/Out0はこれらによっては切り替えられない。

**Writer feature.#
	class Writer Feature;

***[man.c]
****#en
A feature that provides the ability to output data to a stream.
****#ja
ストリームにデータを出力する機能を提供するフィーチャー。
***[test] Test.Writer class.@
	UnitTest addSubclass: #Test.Writer instanceVars: "wr"
****Test.Writer >> setup
	StringWriter new ->wr
	
***Writer >> putByte: byteArg
	self shouldBeImplemented
****[man.m]
*****#en
Outputs 1 byte of byteArg to the stream.
*****#ja
ストリームに値byteArgの1バイトを出力する。

***Writer >> putCharCode: codeArg
	self putByte: codeArg
****[test.m]
	wr putCharCode: 'a' code;
	self assert: wr asString = "a"
	
***Writer >> putWideCharCode: codeArg
	codeArg >= 256
		ifTrue:
			[self putWideCharCode: codeArg >> 8;
			self putCharCode: codeArg & 0xff]
		ifFalse:
			[self putCharCode: codeArg]
****[test.m]
	wr putWideCharCode: 'a' code;
	self assert: wr asString = "a"
****#ja
*****[test.m] wideChar
	wr putWideCharCode: 'あ' code;
	self assert: wr asString = "あ"
	
***Writer >> put: objectArg
	objectArg printOn: self
****[man.m]
*****#en
Outputs a printed representation of objectArg to the stream.
*****#ja
ストリームにobjectArgの印字表現を出力する。
****[test.m]
	wr put: 1;
	self assert: wr asString = "1"
	
***Writer >> putLn
	self put: '\n'
****[man.m]
*****#en
Outputs a newline character to the stream.
*****#ja
ストリームに改行文字を出力する。
****[test.m]
	wr putLn;
	self assert: wr asString = "\n"
	
***Writer >> putLn: objectArg
	self put: objectArg, putLn
****[man.m]
*****#en
Outputs a print representation of objectArg and a newline character to the stream.

*****#ja
ストリームにobjectArgの印字表現と改行文字を出力する。
****[test.m]
	wr putLn: 1;
	self assert: wr asString = "1\n"
	
***Writer >> put: objectArg times: countArg
	countArg timesRepeat: [self put: objectArg]
****[man.m]
*****#en
Outputs the print representation of objectArg to the stream repeatedly countArg times.
*****#ja
ストリームにobjectArgの印字表現をcountArg回繰り返し出力する。
****[test.m]
	wr put: 1 times: 5;
	self assert: wr asString = "11111"
	
***Writer >> putSpaces: countArg
	self put: ' ' times: countArg
****[man.m]
*****#en
Output countArg whitespace characters to the stream.
*****#ja
ストリームにcountArg文字の空白文字を出力する。
****[test.m]
	wr putSpaces: 5;
	self assert: wr asString = "     "
	
***Writer >> put: objectArg width: widthArg
	StringWriter new put: objectArg, asString ->:contents;
	self putSpaces: widthArg - contents size, put: contents
****[man.m]
*****#en
Outputs a printed representation of objectArg right-justified in the stream by widthArg characters.

Operation is not guaranteed when multibyte characters are included in the printed expression.
If the printed representation of objectArg exceeds widthArg characters, it is output as it is.
*****#ja
ストリームにwidthArg文字右詰めでobjectArgの印字表現を出力する。

印字表現に全角文字が含まれる場合の動作は保証されない。
又、objectArgの印字表現がwidthArg文字を越えた場合はそのまま出力される。
****[test.m]
	wr put: 1 width: 2;
	self assert: wr asString = " 1"
	
***Writer >> write: bufArg from: fromArg size: sizeArg
	sizeArg timesDo:
		[:off
		self putByte: (bufArg byteAt: fromArg + off)]
****[man.m]
*****#en
Writes sizeArg bytes as they are from the fromArg byte of FixedByteArray bufArg.

bufArg can be a derived class.
*****#ja
FixedByteArray bufArgのfromArgバイト目からsizeArgバイト分をそのまま出力する。

bufArgは派生クラスでも可。
****[test.m]
	"abcde" collectAsArray: [:ch ch code], asFixedByteArray ->:ar;
	wr write: ar from: 1 size: 3;
	self assert: wr asString = "bcd"
	
***Writer >> write: bufArg size: sizeArg
	self write: bufArg from: 0 size: sizeArg!
****[man.m]
*****#en
Writes sizeArg bytes from the beginning of FixedByteArray bufArg.

bufArg can be a derived class.
*****#ja
FixedByteArray bufArgの先頭からsizeArgバイト分をそのまま出力する。

bufArgは派生クラスでも可。
****[test.m]
	"abcde" collectAsArray: [:ch ch code], asFixedByteArray ->:ar;
	wr write: ar size: 3;
	self assert: wr asString = "abc"

***Writer >> write: bufArg
	self write: bufArg size: bufArg size!
****[man.m]
*****#en
Writes the entire FixedByteArray bufArg.

bufArg can be a derived class.
*****#ja
FixedByteArray bufArg全体を出力する。

bufArgは派生クラスでも可。

***Writer >> putString: stringArg
	self write: stringArg size: stringArg size
	
**Reader feature.#
	class Reader Feature;

***[man.c]
****#en
A feature that provides the ability to input data from a stream.
****#ja
ストリームからデータを入力する機能を提供するフィーチャー。
***[test] Test.Reader class.@
	UnitTest addSubclass: #Test.Reader instanceVars: "rd"
****Test.Reader >> setup
	StringReader new init: "123\n456\n" ->rd
	
***Reader >> getByte
	self shouldBeImplemented
****[man.m]
*****#en
Input 1 byte from the stream and return a value in the range of 0-255.

Returns -1 when the stream reaches the end.
*****#ja
ストリームから1byte入力し、値を0〜255の範囲で返す。

ストリームが末尾に到達したら-1を返す。

***Reader >> getChar
	self getByte asChar!
****[man.m]
*****#en
Input one character from the stream and return an instance of Char.

Even if the stream contains multi-byte characters, it is treated as a sequence of Char corresponding to each byte.
Returns nil when the stream reaches the end.
*****#ja
ストリームから1文字入力し、Charのインスタンスを返す。

ストリームにマルチバイト文字が含まれている場合でも、各々のバイトに対応するCharの列として扱われる。
ストリームが末尾に到達したらnilを返す。
****[test.m]
	self assert: rd getChar = '1';
	7 timesRepeat: [rd getChar];
	self assert: rd getChar nil?
	
***Reader >> getLn
	StringWriter new ->:w;
	[self getChar ->:ch;
	ch nil? ifTrue: [nil!];
	ch = '\n' ifTrue: [w asString!];
	w put: ch] loop
****[man.m]
*****#en
Input one line from the stream and return a String instance.

The return value does not include the newline character at the end of the line.
Returns nil when the stream reaches the end.
*****#ja
ストリームから1行入力し、Stringのインスタンスを返す。

返り値には行末の改行文字は含まない。
ストリームが末尾に到達したらnilを返す。
****[test.m]
	self assert: rd getLn = "123";
	self assert: rd getLn = "456";
	self assert: rd getLn nil?
	
***Reader >> getWideCharTrail: charArg
	charArg mblead? ifTrue:
		[charArg code ->:code;
		charArg trailSize timesRepeat: [code << 8 + self getByte ->code];
		code asWideChar!];
	charArg!
****#ja
*****[test.m]
	StringReader new init: "あ" ->rd;
	rd getChar ->:ch;
	self assert: (rd getWideCharTrail: ch) = 'あ'
	
***Reader >> getWideChar
	self getChar ->:ch, nil? ifTrue: [nil!];
	self getWideCharTrail: ch!
****[man.m]
*****#en
Input one character from the stream and return an instance of Char / WideChar.

If the stream contains multibyte characters, construct a WideChar according to the content.
The other behavior is the same as getChar.
*****#ja
ストリームから1文字入力し、Char/WideCharのインスタンスを返す。

ストリームにマルチバイト文字が含まれている場合は、内容に沿ってWideCharを構築する。
それ以外の振舞いはgetCharと同様。
****#ja
*****[test.m]
	StringReader new init: "1あ" ->rd;
	self assert: rd getWideChar = '1';
	self assert: rd getWideChar = 'あ';
	self assert: rd getWideChar nil?
	
***Reader >> read: bufArg from: fromArg size: sizeArg
	sizeArg timesDo:
		[:off
		self getByte ->:byte, = -1 ifTrue: [off!];
		bufArg at: fromArg + off put: byte];
	sizeArg!
****[man.m]
*****#en
Reads up to sizeArg bytes from the stream and writes the read byte sequence after the fromArg bytes of FixedByteArray bufArg.

The return value is the number of bytes read.
*****#ja
ストリームから最大sizeArgバイトを読み込み、読み込んだバイト列をbufArgのfromArgバイト目以降に書き込みます。

返り値は読み込んだバイト数となります。
****[test.m]
	FixedByteArray basicNew: 10 ->:buf;
	rd read: buf from: 1 size: 10 ->:len;
	self assert: len = 8;
	self assert: (buf at: 1) = '1' code;
	self assert: (buf at: 5) = '4' code;
	self assert: (rd read: buf from: 1 size: 10) = 0
	
***Reader >> read: bufArg size: sizeArg
	self read: bufArg from: 0 size: sizeArg!
****[man.m]
*****#en
Reads up to sizeArg bytes from the stream and writes the read byte sequence after the fromArg bytes of FixedByteArray bufArg.

The return value is the number of bytes read.
*****#ja
ストリームから最大sizeArgバイトを読み込み、読み込んだバイト列をFixedByteArray bufArgのfromArgバイト目以降に書き込みます。

返り値は読み込んだバイト数となります。
****[test.m]
	FixedByteArray basicNew: 10 ->:buf;
	rd read: buf size: 10 ->:len;
	self assert: len = 8;
	self assert: buf first = '1' code;
	self assert: (buf at: 4) = '4' code;
	self assert: (rd read: buf size: 10) = 0

***Reader >> read: bufArg
	self read: bufArg size: bufArg size!
****[man.m]
*****#en
Read as much as possible from the stream into FixedByteArray bufArg and return the number of bytes read.
*****#ja
ストリームからFixedByteArray bufArgに可能な限り読み込み、読み込んだバイト数を返す。
	
**AbstractStream class.#
	class AbstractStream Object;
		feature AbstractStream Reader Writer;
***[man.c]
****#en
Common base class for streams.

It is the base class for classes that implement both Reader and Writer.
****#ja
ストリームの共通基底クラス。

ReaderとWriterの両方を実装するクラスの基底クラスとなる。

***AbstractStream >> putByte: byteArg
	self shouldBeImplemented
***AbstractStream >> write: bufArg from: fromArg size: sizeArg
	self shouldBeImplemented
***AbstractStream >> getByte
	self shouldBeImplemented
***AbstractStream >> read: bufArg from: fromArg size: sizeArg
	self shouldBeImplemented
	
***AbstractStream >> seek: posArg
	self shouldBeImplemented
****[man.m]
*****#en
Moves the access position to byte offset posArg from the beginning of the stream.

If nil is specified, move to the end of the stream.
*****#ja
アクセス位置をストリーム先頭からのバイトオフセットposArgに移動する。

nilを指定するとストリーム末尾に移動する。

***AbstractStream >> tell
	self shouldBeImplemented
****[man.m]
*****#en
Returns the current access position as a byte offset from the beginning of the stream.
*****#ja
現在のアクセス位置をストリーム先頭からのバイトオフセットとして返す。

**AbstractMemoryStream class.#
	class AbstractMemoryStream AbstractStream : buf size pos;
***AbstractMemoryStream >> initEmpty
	FixedByteArray basicNew: 256 ->buf;
	0 ->size ->pos
***AbstractMemoryStream >> extend: sizeArg
	pos + sizeArg max: size ->:nsize;
	buf size ->:bufsize, < nsize ifTrue:
		[[bufsize < nsize] whileTrue: [bufsize * 2 ->bufsize];
		FixedByteArray basicNew: bufsize,
			basicAt: 0 copyFrom: buf at: 0 size: size ->buf];
	nsize ->size
***AbstractMemoryStream >> putByte: byteArg
	self extend: 1;
	buf at: pos put: byteArg;
	pos + 1 ->pos
***AbstractMemoryStream >> write: bufArg from: fromArg size: sizeArg
	self extend: sizeArg;
	buf basicAt: pos copyFrom: bufArg at: fromArg size: sizeArg;
	pos + sizeArg ->pos
***AbstractMemoryStream >> getByte
	pos = size ifTrue: [-1!];
	buf byteAt: pos ->:result;
	pos + 1 ->pos;
	result!
***AbstractMemoryStream >> read: bufArg from: fromArg size: sizeArg
	sizeArg min: size - pos ->sizeArg;
	bufArg basicAt: fromArg copyFrom: buf at: pos size: sizeArg;
	pos + sizeArg ->pos;
	sizeArg!
***AbstractMemoryStream >> seek: posArg
	posArg nil? ifTrue: [size ->pos!];
	self assert: (posArg between: 0 and: size);
	posArg ->pos
***AbstractMemoryStream >> tell
	pos!

**MemoryStream class.#
	class MemoryStream AbstractMemoryStream;
***[man.c]
****#en
A stream that holds content in memory.

You need to seek to read what you wrote.
****#ja
メモリ上に内容を保持するストリーム。

書き込んだ内容を読み込むにはseekする必要がある。

***MemoryStream >> init
	super initEmpty
	
***MemoryStream >> reset
	0 ->size ->pos
****[man.m]
*****#en
Empty the contents of the stream.
*****#ja
ストリームの内容を空にする。

**StringWriter class.#
	class StringWriter MemoryStream;
***[man.c]
****#en
A construction stream of strings.
****#ja
文字列の構築ストリーム。

***StringWriter >> asString
	buf makeStringFrom: 0 size: size!
****[man.m]
*****#en
Returns a string containing what was written to the stream.
*****#ja
ストリームに書き込まれた内容の文字列を返す。
****[test.m]
	"1234567890" ->:s;
	StringWriter new ->:wr;
	30 timesRepeat: [wr put: s];
	wr asString ->:s2;
	self assert: s2 size = 300;
	30 timesDo:
		[:i
		self assert: s = (s2 copyFrom: i * 10 until: i + 1 * 10)]
		
**StringReader class.#
	class StringReader AbstractMemoryStream;
***[man.c]
****#en
A reference stream of strings.

Provides a function to retrieve the contents of a string via Reader from the top.
****#ja
文字列の参照ストリーム。

文字列の内容を先頭から順にReader経由で取得する機能を提供する。

***StringReader >> init: stringArg
	stringArg ->buf;
	stringArg size ->size;
	0 ->pos
****[man.m]
*****#en
Initialize the stream with stringArg.
*****#ja
ストリームをstringArgで初期化する。
****[test.m]
	StringReader new init: "a" ->:rd;
	self assert: rd getByte = 'a' code;
	self assert: rd getByte = -1
	
**LimitableStringWriterOverrun class.#
	class LimitableStringWriterOverrun Exception;

**LimitableStringWriter class.#
	class LimitableStringWriter StringWriter : limit;
***LimitableStringWriter >> init
	super init;
	256 ->limit
***LimitableStringWriter >> limit: limitArg
	limitArg ->limit
***LimitableStringWriter >> putByte: byteArg
	size >= limit ifTrue: [LimitableStringWriterOverrun new signal];
	super putByte: byteArg
***LimitableStringWriter >> write: bufArg from: fromArg size: sizeArg
	size + sizeArg >= limit ifTrue:
		[super write: bufArg from: fromArg size: limit - size;
		LimitableStringWriterOverrun new signal];
	super write: bufArg from: fromArg size: sizeArg
	
**File class.#
	class File Object : name path parent mode size mtime;
	singleton TransientGlobalVar File.current;
	singleton TransientGlobalVar File.home;

***[man.c]
****#en
Means a file or directory and provides a series of functions such as file information acquisition, creation and deletion, and stream construction.

Construct with String >> asFile or File >> +.
It should not be construct by new.

Pathnames are expressed in POSIX format regardless of the host OS.
In case of DOS/Windows, the drive is treated as a directory directly under the root directory.
Specifying "~" at the beginning of the path name makes it a relative path from the global variable File.home.
This is initialized at startup with the value of the environment variable HOME.

The current directory is obtained with "." asFile.
****#ja
ファイルやディレクトリを意味し、ファイルの情報取得、作成と削除、ストリームの構築といった一連の機能を提供する。

構築はString >> asFileもしくはFile >> +で行う。
newによって構築してはならない。

パス名はホストOSに関係なくPOSIX形式で表す。
DOS/Windowsの場会、ドライブはルートディレクトリ直下のディレクトリとして扱う。
パス名の先頭に"~"を指定すると大域変数File.homeからの相対パスとなる。
これは起動時に環境変数HOMEの値で初期化される

カレントディレクトリは"." asFileで収得する。

***[test] Test.File class.@
	UnitTest addSubclass: #Test.File instanceVars: "dir file"
****Test.File >> setup
	Mulk.workDirectory ->dir;
	dir + "1.wk" ->file
****Test.File >> makeFile
	self createTempFile ->:f;
	f openWrite put: "123", close;
	f!
	
***location.
****File >> initParent: parentArg name: nameArg
	parentArg ->parent;
	nameArg ->name;
	parent nil?
		ifTrue: [name]
		ifFalse:
			[StringWriter new ->:w;
			w put: parent path;
			parent root? ifFalse: [w put: '/'];
			w put: name;
			w asString] ->path;
.if caseInsensitiveFileName
	self hash: (path bytesHash: true)
.else
	self hash: path hash
.end
****File >> relative: nameArg
	self assert: nameArg empty? not;
	nameArg = "." ifTrue: [self!];
	nameArg = ".." ifTrue: [parent!];
	File new initParent: self name: nameArg!

****File >> + pathArg
	self ->:f;
	pathArg last = '/' ifTrue: [pathArg copyUntil: pathArg size - 1 ->pathArg];
	[pathArg indexOf: '/' ->:slpos, notNil?] whileTrue:
		[f relative: (pathArg copyUntil: slpos) ->f;
		pathArg copyFrom: slpos + 1 ->pathArg];
	f relative: pathArg!
*****[man.m]
******#en
Returns the file object corresponding to the relative path String pathArg starting from the receiver.
******#ja
レシーバーを起点とする相対パスString pathArgに相当するファイルオブジェクトを返す。
*****[test.m]
	self assert: file + "." = file;
	self assert: file + ".." = dir;
	self assert: file + "../2.wk" = (dir + "2.wk")

****File >> fileOfPath: pathArg
	self ->:f;
	pathArg first = '~' ifTrue: 
		[File.home ->:result;
		pathArg size >= 2 ifTrue: [result + (pathArg copyFrom: 2) ->result];
		result!];
	pathArg indexOf: '/' ->:slpos;
	slpos = 0 ifTrue:
		[File new initParent: nil name: "/" ->f;
		pathArg size = 1 ifTrue: [f!];
		pathArg copyFrom: slpos + 1 ->pathArg];
	f + pathArg!
*****[test.m]
	self assert: "/" asFile root?;
	self assert: "." asFile = File.current
	
***accessing.
****File >> path
	path!
*****[man.m]
******#en
Returns the full path string of the receiver.
******#ja
レシーバーのフルパス文字列を返す。
*****[test.m]
	self assert: dir path + "/1.wk" = file path

****File >> quotedPath
	StringWriter new put: '"', put: path, put: '"', asString!
*****[man.m]
******#en
Returns a full path string enclosed in double quotes.
******#ja
二重引用符で囲ったフルパス文字列を返す。

****File >> pathFrom: upperArg
	upperArg path size ->:usize;
	upperArg root? ifFalse: [usize + 1 ->usize];
	path copyFrom: usize!
*****[man.m]
******#en
Returns the relative path string from the File upperArg to the receiver.

upperArg must be the upper path of the receiver.
******#ja
File upperArgからレシーバーへの相対パス文字列を返す。

upperはレシーバーの上位パスでなくてはならない。
*****[test.m]
	self assert: (file pathFrom: dir) = "1.wk"
	
****File >> name
	name!
*****[man.m]
******#en
Returns the receiver's file name string.
******#ja
レシーバーのファイル名文字列を返す。
*****[test.m]
	self assert: file name = "1.wk"
	
****File >> baseName
	name indexOf: '.' ->:pos, nil?
		ifTrue: [name]
		ifFalse: [name copyUntil: pos]!
*****[man.m]
******#en
Returns the base name of the receiver (the file name with the suffix removed).
******#ja
レシーバーのベース名(ファイル名から拡張子を除いたもの)文字列を返す。
*****[test.m]
	self assert: file baseName = "1"

****File >> suffix
	name lastIndexOf: '.' ->:dotpos, nil?
		ifTrue: [""]
		ifFalse: [name copyFrom: dotpos + 1]!
*****[man.m]
******#en
Returns the suffix string of the receiver.
******#ja
レシーバーの拡張子文字列を返す。
*****[test.m]
	self assert: file suffix = "wk"

****File >> parent
	parent!
*****[man.m]
******#en
Returns the parent directory of the receiver.
******#ja
レシーバーの親ディレクトリを返す。
****File >> root?
	parent nil?!
*****[man.m]
******#en
Returns true if the receiver is a root directory.
******#ja
レシーバーがルートディレクトリなら真を返す。
*****[test.m]
	self assert: file root? not;
	self assert: "/" asFile root?
	
****File >> = fileArg
	self == fileArg ifTrue: [true!];
	fileArg memberOf?: self class, ifFalse: [false!];
.if caseInsensitiveFileName
	self hash = fileArg hash ifFalse: [false!];
	path caseInsensitiveEqual?: fileArg path!
.else
	path = fileArg path!
.end
*****[test.m]
	self assert: file + ".." = dir

****File >> system?
	parent = Mulk.extraSystemDirectory | (parent = Mulk.systemDirectory)!
*****[man.m]
******#en
Returns true if the receiver is a system file.
******#ja
レシーバーがシステムファイルなら真を返す。
*****[test.m]
	self assert: "base.m" asSystemFile system?

***host path
****File >> hostPath
.if windows|dos
	parent root? 
		ifTrue: [name + ':']
		ifFalse: [parent hostPath + '\\' + name]!
.else
	path!
.end
*****[man.m]
******#en
Returns the full path of the receiver's host OS form.
******#ja
レシーバーのホストOS形式でのフルパスを返す。

****File >> quotedHostPath
	StringWriter new put: '"', put: self hostPath, put: '"', asString!
*****[man.m]
******#en
Returns the full path of the receiver's host OS form, enclosed in double quotes.
******#ja
レシーバーのホストOS形式でのフルパスを二重引用符で囲ったものを返す。
***open FileStream.
****File >> openMode: modeArg
	modeArg <> 0 ifTrue: [self resetStat];
	FileStream new init: (OS fopen: path mode: modeArg)!

****File >> openRead
	self openMode: 0!
*****[man.m]
******#en
Returns a stream that reads the contents of the receiver.
******#ja
レシーバーの内容を読み込むストリームを返す。
*****[test.m]
	self makeFile ->:f;
	f openRead ->:fs;
	fs getChar ->:ch;
	fs close;
	self assert: ch = '1'
	
****File >> openWrite
	self openMode: 1!
*****[man.m]
******#en
Returns a stream to write to the contents of the receiver.
******#ja
レシーバーの内容へ書き込むストリームを返す。
*****[test.m]
	self createTempFile ->:f;
	f openWrite put: 'x', close;
	self assert: f size = 1
		
****File >> openAppend
	self openMode: 2!
*****[man.m]
******#en
Returns a stream to append to the receiver's content.
******#ja
レシーバーの内容へ追記するストリームを返す。
*****[test.m]
	self makeFile ->:f;
	f openAppend put: 'x', close;
	self assert: f size = 4
	
****File >> openUpdate
	self openMode: 3!
*****[man.m]
******#en
Returns a stream that updates the contents of the receiver.

The read / write position is at the beginning of the file.
The file size cannot be reduced.
******#ja
レシーバーの内容を更新するストリームを返す。

読み書きの位置はファイルの先頭となる。
ファイルサイズを縮小する事は出来ない。
*****[test.m]
	self makeFile ->:f;
	f openUpdate ->:fs;
	fs put: 'x';
	fs close;
	self assert: f size = 3;

	f openRead ->fs;
	fs getChar ->:ch;
	fs close;
	self assert: ch = 'x'

***safety FileStream accession.
****File >> openMode: modeArg do: blockArg
	self openMode: modeArg ->:str;
	[blockArg value: str] finally: [str close]!	

****File >> readDo: blockArg
	self openMode: 0 do: blockArg!
*****[man.m]
******#en
Evaluate blockArg with the stream that reads the contents of the receiver as an argument.

When blockArg is exited due to the end of processing or an exception, the stream is closed.
******#ja
レシーバーの内容を読み込むストリームを引数としてblockArgを評価する。

処理の終了もしくは例外でblockArgを抜けるとストリームが閉じられる。
*****[test.m]
	self makeFile ->:f;
	f readDo: [:fs fs getChar ->:ch];
	self assert: ch = '1'
	
****File >> writeDo: blockArg
	parent mkdir;
	self openMode: 1 do: blockArg!
*****[man.m]
******#en
Evaluate blockArg with the stream to be written to the contents of the receiver as an argument.

If the parent directory of the receiver does not exist, it will be created.
When blockArg is exited due to the end of processing or an exception, the stream is closed.
******#ja
レシーバーの内容へ書き込むストリームを引数としてblockArgを評価する。

レシーバーの親ディレクトリが存在しない場合は新規に作成される。
処理の終了もしくは例外でblockArgを抜けるとストリームを閉じる。
*****[test.m]
	self createTempFile ->:f;
	f writeDo: [:fs fs put: 'x'];
	self assert: f size = 1

****File >> appendDo: blockArg
	parent mkdir;
	self openMode: 2 do: blockArg!
*****[man.m]
******#en
Evaluate blockArg with the stream to be added to the contents of the receiver as an argument.

If the parent directory of the receiver does not exist, it will be created.
When blockArg is exited due to the end of processing or an exception, the stream is closed.
******#ja
レシーバーの内容へ追記するストリームを引数としてblockArgを評価する。

レシーバーの親ディレクトリが存在しない場合は新規に作成される。
処理の終了もしくは例外でblockArgを抜けるとストリームを閉じる。
*****[test.m]
	self makeFile ->:f;
	f appendDo: [:fs2 fs2 put: 'x'];
	self assert: f size = 4

***stat.
****File >> statFromStatbuf: bufArg
	bufArg nil?
		ifTrue: [1 ->mode]
		ifFalse:
			[bufArg at: 0 ->mode;
			bufArg at: 1 ->size;
			bufArg at: 2 ->mtime]
****File >> stat
	self statFromStatbuf: (OS stat: path)
****File >> checkStat
	mode nil? ifTrue: [self stat]
****File >> resetStat
	nil ->mode

****mode predicate.
	see pf.h

*****File >> none?
	self checkStat;
	mode & 1 <> 0! -- PF_NONE
******[man.m]
*******#en
Returns true if the receiver file does not exist.
*******#ja
レシーバーのファイルが存在しない場合にtrueを返す。
******[test.m]
	self createTempFile ->:f;
	self assert: f none?
	
*****File >> file?
	self checkStat;
	mode & 2 <> 0! -- PF_FILE
******[man.m]
*******#en
Returns true if the receiver is a regular file.
*******#ja
レシーバーが一般ファイルであればtrueを返す。
******[test.m]
	self makeFile ->:f;
	self assert: f file?
	
*****File >> directory?
	self checkStat;
	mode & 4 <> 0! -- PF_DIR
******[man.m]
*******#en
Returns true if the receiver is a directory.
*******#ja
レシーバーがディレクトリであればtrueを返す。
******[test.m]
	self assert: dir directory?
	
*****File >> other?
	self checkStat;
	mode & 8 <> 0! -- PF_OTHER
******[man.m]
*******#en
Returns true if the receiver is neither a regular file nor a directory.
*******#ja
レシーバーが通常ファイルでもディレクトリでも無ければtrueを返す。

*****File >> readable?
	self checkStat;
	mode & 16 <> 0! -- PF_READABLE
******[man.m]
*******#en
Returns true if the receiver is readable.
*******#ja
レシーバーが読み込み可能ならtrueを返す。
******[test.m]
	self makeFile ->:f;
	self assert: f readable?
	
*****File >> writable?
	self checkStat;
	mode & 32 <> 0! -- PF_WRITABLE
******[man.m]
*******#en
Returns true if the receiver is writable.
*******#ja
レシーバーが書き込み可能ならtrueを返す。
******[test.m]
	self makeFile ->:f;
	self assert: f writable?
	
*****File >> readableFile?
	self checkStat;
	mode & 18 = 18! -- PF_FILE|PF_READABLE
******[man.m]
*******#en
Returns true if the receiver is a readable regular file.
*******#ja
レシーバーが読み込み可能な通常ファイルならtrueを返す。
******[test.m]
	self makeFile ->:f;
	self assert: f readableFile?
	
****File >> size
	self checkStat;
	size!
*****[man.m]
******#en
Returns the size of the receiver in bytes.
******#ja
レシーバーのバイト単位のサイズを返す。
*****[test.m]
	self makeFile ->:f;
	self assert: f size = 3
	
****File >> mtime
	self checkStat;
	mtime kindOf?: Integer, ifTrue:
		[DateAndTime new initUnixTime: mtime ->mtime];
	mtime!
*****[man.m]
******#en
Returns the last update time of the receiver.
******#ja
レシーバーの最終更新時刻を返す。
*****[test.m]
	DateAndTime new initNow ->:now;
	self makeFile ->:f;
	self assert: f mtime >= now

****File >> mtime: mtimeArg
	self resetStat;
	OS utime: self path mtime: mtimeArg unixTime
*****[man.m]
******#en
Change the last update time of the receiver to DateAndTime mtimeArg.
******#ja
レシーバーの最終更新時刻をDateAndTime mtimeArgに変更する。
*****[test.m]
	DateAndTime new initYear: 2000 month: 1 day: 1 ->:d;
	self makeFile ->:f;
	f mtime: d;
	self assert: f mtime = d
	
***list.
****File >> childFiles
	Iterator new init: 
		[:b OS readdir: path, split: '\n', do: [:fn b value: self + fn]]!
*****[man.m]
******#en
Returns an Iterator of files directly under the receiver directory.
******#ja
レシーバーディレクトリの直下のファイル群のIteratorを返す。

****File >> decendantFiles
	Iterator new init:
		[:block
		Array new addAll: self childFiles ->:list;
		[list empty?] whileFalse:
			[list last ->:file;
			file nil? 
				ifTrue:
					[list removeLast;
					block value: list last;
					list removeLast]
				ifFalse:
					[file directory?
						ifTrue:
							[list addLast: nil;
							list addAll: file childFiles]
						ifFalse: 
							[list removeLast;
							block value: file]]]]!
*****[man.m]
******#en
Returns an Iterator over all files under the receiver directory.

Directories are listed after their subordinate files.
******#ja
レシーバーディレクトリの下位の全ファイル群のIteratorを返す。

ディレクトリはその下位のファイルの後に列挙される。

***directory operations.
****File >> basicRemove
	OS remove: path

****File >> remove
	self basicRemove;
	self resetStat
*****[man.m]
******#en
Remove the receiver file.
******#ja
レシーバーのファイルを削除する。
*****[test.m]
	self makeFile ->:f;
	f remove;
	self assert: f none?
	
****File >> basicMkdir
	OS mkdir: path
****File >> mkdir
	self directory? ifTrue: [self!];
	self none? ifTrue:
		[parent mkdir;
		self basicMkdir;
		self resetStat!];
	self error: "mkdir failed"
*****[man.m]
******#en
Create a receiver directory.

If the receiver's parent directory does not exist, subdirectories are created in order from the existing directory.
******#ja
レシーバーのディレクトリを作成する。

レシーバーの親ディレクトリは存在しない場合は、存在するディレクトリから順に下位ディレクトリを作る。
*****[test.m]
	self createTempFile ->:f, mkdir;
	self assert: f directory?

****File >> chdir
	OS chdir: path;
	self ->File.current
*****[man.m]
******#en
Make the receiver directory the current directory.
******#ja
レシーバーディレクトリをカレントディレクトリとする。
*****[test.m]
	"." asFile ->:saveDir;
	self createTempFile ->:f;
	f mkdir;
	f chdir;
	"." asFile ->:f2;
	self assert: f = f2;
	saveDir chdir
	
***File >> printOn: writerArg
	super printOn: writerArg;
	writerArg put: "(" + path + ')'

***File >> unmatchIndexWith: fileArg
	4096 ->:bufSize;
	FixedByteArray basicNew: bufSize ->:b1;
	FixedByteArray basicNew: bufSize ->:b2;
	self openRead ->:fs1;
	fileArg openRead ->:fs2;
	0 ->:off;
	true ->:cont?;
	nil ->:result;
	[cont?] whileTrue:
		[fs1 read: b1 ->:b1Size;
		fs2 read: b2 ->:b2Size;
		b1Size <> b2Size
			ifTrue:
				[b1Size min: b2Size ->:cmpSize;
				b1 unmatchIndexWith: b2 size: cmpSize ->:pos, nil?
					ifTrue: [off + cmpSize]
					ifFalse: [off + pos] ->result;
				false ->cont?]
			ifFalse:
				[b1Size = 0
					ifTrue: [false ->cont?]
					ifFalse:
						[b1 unmatchIndexWith: b2 size: b1Size ->pos, nil?
							ifTrue: [off + b1Size ->off]
							ifFalse:
								[off + pos ->result;
								false ->cont?]]]];
	fs1 close;
	fs2 close;
	result!
****[man.m]
*****#en
Compare the receiver file with the contents of fileArg and return the byte offset where the difference occurred.

Returns nil if they are the same file.
*****#ja
レシーバーファイルとfileArgの内容を比較し、差異の生じたバイトオフセットを返す。

同一のファイルであればnilを返す。
****[test.m]
	self makeFile ->:f1;
	self createTempFile ->:f2;
	f1 pipeTo: f2;
	self assert: (f1 unmatchIndexWith: f2) nil?

***File >> contentsEqual?: fileArg
	self size = fileArg size and: [self unmatchIndexWith: fileArg, nil?]!
****[man.m]
*****#en
Compare the receiver file with the contents of fileArg and return true if they match.
*****#ja
レシーバーファイルとfileArgの内容を比較し、一致していればtrueを返す。
****[test.m]
	self makeFile ->:f1;
	self createTempFile ->:f2;
	f1 pipeTo: f2;
	self assert: (f1 contentsEqual?: f2)

***File >> multiLanguage?
	self readDo:
		[:fs
		fs getLn;
		fs getLn;
		fs getLn head?: '#' ->:result];
	result!
	
**FileStream class.#
	class FileStream AbstractStream : fp;

***[man.c]
****#en
Stream to file.

Constructed by a method of the File class.
Must not be constructed by new.

When character input/output is performed on Windows OS, newline characters are processed as CR/LF.
On Unix-based OS, only LF is available.
****#ja
ファイルに対するストリーム。

Fileクラスのメソッドによって構築する。
newによって構築してはならない。

Windows系OSでキャラクタ入出力を行うと、改行文字はCR/LFとして処理される。
Unix系OSではLFのみとなる。
***[test] Test.FileStream class.@
	UnitTest addSubclass: #Test.FileStream
****Test.FileStream >> makeFile
	self createTempFile ->:f, writeDo: [:fs fs put: "abcde"];
	f!
	
***FileStream >> init: fpArg
	fpArg ->fp
***FileStream >> fp
	fp!

***FileStream >> getByte
	OS fgetc: fp!
***FileStream >> putByte: byteArg
	OS fputc: byteArg fp: fp
****[test.m]
	self createTempFile ->:f;
	f openWrite ->:fs;
	fs putByte: 'a' code;
	fs close;
	f openRead ->fs;
	self assert: fs getByte = 'a' code;
	self assert: fs getByte = -1;
	fs close
	
***FileStream >> read: bufArg from: fromArg size: sizeArg
	OS fread: bufArg from: fromArg size: sizeArg fp: fp!
***FileStream >> write: bufArg from: fromArg size: sizeArg
	OS fwrite: bufArg from: fromArg size: sizeArg fp: fp!
****[test.m]
	--read and write
	self createTempFile ->:f;
	"abcde" collectAsArray: [:ch ch code], asFixedByteArray ->:ar;
	f writeDo: [:wr wr write: ar from: 1 size: 3];
	f readDo:
		[:rd
		FixedByteArray basicNew: 5 ->ar;
		rd read: ar from: 0 size: 5 ->:size;
		self assert: (ar makeStringFrom: 0 size: size) = "bcd"]
	
***FileStream >> seek: offsetArg
	OS fseek: fp offset: offsetArg
****[test.m]
	self makeFile ->:f;
	f readDo:
		[:fs
		fs seek: 1;
		self assert: fs getChar = 'b']
****[test.m] seekTail
	self makeFile ->:f;
	f openUpdate ->:fs;
	fs seek: nil;
	fs put: 'z';
	fs close;
	f readDo:
		[:fs2
		fs2 seek: 5;
		self assert: fs2 getChar = 'z']
		
***FileStream >> tell
	OS ftell: fp!
****[test.m]
	self makeFile ->:f;
	f readDo:
		[:fs
		fs getChar;
		self assert: fs tell = 1]
		
***FileStream >> close
	OS fclose: fp
****[man.m]
*****#en
Close the file stream.

If multiple file streams are opened or closed for the same file, the input / output operation may not be completed correctly.
*****#ja
ファイルストリームを閉じる。

同一のファイルに対し複数のファイルストリームを開いたり、closeせずに終了すると入出力動作が正しく完結しない場合がある。

***FileStream >> getLn
	OS fgets: fp!
****[test.m]
	self createTempFile ->:f;
	f openWrite put: "a\nb\n", close;
	f openRead ->:fs;
	self assert: fs getLn = "a";
	self assert: fs getLn = "b";
	self assert: fs getLn nil?;
	fs close
		
**AheadReader class.#
	class AheadReader Object : reader nextChar tokenWriter;

***[man.c]
****#en
A one-character look-ahead reader.

While prefetching one character at a time from a character string or Reader, if necessary, cut out a part as a token.
Can be used as a syllable reader or lexical analyzer.
****#ja
1文字先読みリーダー。

文字列やReaderから一文字ずつ先読みを行いながら、必要に応じて一部をトークンとして切り出す。
シラブルリーダーや字句解析器として使用出来る。
	
***AheadReader >> initReader: readerArg
	readerArg ->reader;
	reader getChar ->nextChar
****[man.m]
*****#en
Assign a readerArg to the receiver and initialize it.
*****#ja
レシーバーにreaderArgを割り当てて初期化する。
****[test.m]
	AheadReader new initReader: (StringReader new init: "a") ->:r;
	self assert: r nextChar = 'a'
	
***AheadReader >> init: stringArg
	self initReader: (StringReader new init: stringArg)
****[man.m]
*****#en
Assign a stringArg to the receiver and initialize it.
*****#ja
レシーバーにstringArgを割り当てて初期化する。
****[test.m]
	AheadReader new init: "a" ->:r;
	self assert: r nextChar = 'a'
	
***AheadReader >> nextChar
	nextChar!
****[man.m]
*****#en
Returns a pre-read Char type character.

Returns nil when the end of the stream is reached.
*****#ja
先読みしたChar型の文字を返す。

ストリーム末尾に到達するとnilを返す。
****[test.m]
	AheadReader new init: "ab" ->:r;
	r skipChar;
	self assert: r nextChar = 'b'

***AheadReader >> errorIfEof
	nextChar nil? ifTrue: [self error: "eof reached"]

***AheadReader >> skipChar
	self errorIfEof;
	nextChar ->:result;
	reader getChar ->nextChar;
	result!
****[man.m]
*****#en
Skips the next character and returns that character.
*****#ja
次の一文字を読み飛ばし、その文字を返す。
****[test.m]
	AheadReader new init: "a" ->:r;
	self assert: r skipChar = 'a';
	self assert: r nextChar nil?;
	self assertError: [r skipChar] message: "eof reached"
	
***AheadReader >> add: objectArg
	tokenWriter put: objectArg
****[man.m]
*****#en
Add objectArg to the end of the token regardless of the stream.
*****#ja
ストリームとは無関係にobjectArgをトークンの末尾に追加する。
****[test.m]
	AheadReader new init: "" ->:r;
	r resetToken;
	r add: 'a';
	self assert: r token = "a"
	
***AheadReader >> getChar
	self add: (self skipChar ->:ch);
	ch!
****[man.m]
*****#en
Appends the next character to the end of the token and returns that character.
*****#ja
次の一文字をトークンの末尾に追加し、その文字を返す。
****[test.m]
	AheadReader new init: "a" ->:r;
	r resetToken;
	self assert: r getChar = 'a';
	self assert: r token = "a"
	
***AheadReader >> skipSpace
	[nextChar notNil? and: [nextChar space?]] whileTrue: [self skipChar]
****[man.m]
*****#en
Skip as long as a space character follows.
*****#ja
空白文字が続く限りをスキップする。
****[test.m]
	AheadReader new init: " x" ->:r;
	r skipSpace;
	self assert: r nextChar = 'x'
	
***AheadReader >> resetToken
	StringWriter new ->tokenWriter
****[man.m]
*****#en
Initialize the token to be cut.
*****#ja
切り出すトークンを初期化する。

***AheadReader >> token
	tokenWriter asString!
****[man.m]
*****#en
Returns the token string currently cut out.
*****#ja
現在切り出しているトークン文字列を返す。
****[test.m]
	--contain test for resetToken
	AheadReader new ->:r;
	r resetToken;
	self assert: r token = ""
	
***read number.
****AheadReader >> digit?
	nextChar notNil? and: [nextChar digit?]!
*****[test.m]
	AheadReader new init: "x1" ->:r;
	self assert: r digit? not;
	r skipChar;
	self assert: r digit?
	
****AheadReader >> skipUnsignedInteger
	0 ->:result;
	self digit? ifFalse: [self error: "missing digits"];
	[self digit?] whileTrue:
		[self skipChar asDecimalValue + (result * 10) ->result];
	result!
*****[test.m]
	AheadReader new init: "123x" ->:r;
	self assert: r skipUnsignedInteger = 123;
	self assertError: [r skipUnsignedInteger] message: "missing digits"
	
****AheadReader >> skipSign
	nextChar = '-' ->:result, ifTrue: [self skipChar];
	result!
*****[test.m]
	AheadReader new init: "-x" ->:r;
	self assert: r skipSign;
	self assert: r nextChar = 'x';
	self assert: r skipSign not;
	self assert: r nextChar = 'x'
	
****AheadReader >> skipInteger
	self skipSign ->:minus?;
	self skipUnsignedInteger ->:result;
	minus? ifTrue: [result negated ->result];
	result!
*****[test.m]
	AheadReader new init: "123-456" ->:r;
	self assert: r skipInteger = 123;
	self assert: r skipInteger = -456
	
****AheadReader >> numericChar?
	nextChar notNil? and: [nextChar digit? or: [nextChar lower?]]!
*****[test.m]
	AheadReader new init: "5x!" ->:r;
	self assert: r numericChar?;
	r skipChar;
	self assert: r numericChar?;
	r skipChar;
	self assert: r numericChar? not

****AheadReader >> skipUnsignedNumber
	self skipUnsignedInteger ->:result;
	nextChar = 'x'
		ifTrue:
			[result ->:radix;
			radix = 0 ifTrue: [16 ->radix];
			0 ->result;
			self skipChar;
			self numericChar? ifFalse: [self error: "missing lower or digits"];
			[self numericChar?] whileTrue:
				[self skipChar asNumericValue: radix,
					+ (result * radix) ->result]]
		ifFalse:
			[nextChar = '.' ifTrue:
				[self skipChar;
				0.1 ->:factor;
				self digit? ifFalse: [self error: "missing fraction"];
				[self digit?] whileTrue:
					[self skipChar asDecimalValue * factor + result ->result;
					factor / 10.0 ->factor];
				nextChar = 'e' ifTrue:
					[self skipChar;
					result power10: self skipInteger ->result]]];
	result!
*****[test]
	AheadReader new init: "1 0xff 2x10 0x 1.23 1. 1.0e1" ->:r;
	self assert: r skipUnsignedNumber = 1;
	self assert: r skipChar = ' ';
	self assert: r skipUnsignedNumber = 255;
	self assert: r skipChar = ' ';
	self assert: r skipUnsignedNumber = 2;
	self assert: r skipChar = ' ';
	self assertError: [r skipUnsignedNumber] message: "missing lower or digits";
	self assert: r skipChar = ' ';
	self assert: r skipUnsignedNumber = 1.23;
	self assert: r skipChar = ' ';
	self assert: [r skipUnsignedNumber] message: "missing fraction";
	self assert: r skipChar = ' ';
	self assert: r skipUnsignedNumber = 10.0

****AheadReader >> skipNumber
	self skipSpace;
	self skipSign ->:minus?;
	self skipUnsignedNumber ->:result;
	minus? ifTrue: [result negated ->result];
	result!
*****[man.m]
******#en
Returns an instance of Number by skipping the character string corresponding to the numeric representation of Mulk language.

Skip the white spaces just before.
If the interpretation fails, an error is generated.
******#ja
Mulk言語の数値表現に相当する文字列をスキップしてNumberのインスタンスを返す。

直前の空白はスキップする。
解釈に失敗した場合はエラーを発生させる。
*****[test.m]
	AheadReader new init: " 3.14 -3.14" ->:r;
	self assert: r skipNumber = 3.14;
	self assert: r skipNumber = -3.14
	
***read wide and escape char.
****AheadReader >> skipWideChar
	self errorIfEof;
	reader getWideCharTrail: nextChar ->:ch;
	reader getChar ->nextChar;
	ch!
*****[man.m]
******#en
Skips the next ordinary character or multibyte character and returns that character.

Returns WideChar for multibyte characters.
******#ja
次の通常文字、マルチバイト文字を一文字読み飛ばし、その文字を返す。

マルチバイト文字の場合はWideCharを返す。
*****#ja
******[test.m]
	AheadReader new init: "aあ" ->:r;
	self assert: r skipWideChar = 'a';
	self assert: r skipWideChar = 'あ';
	self assertError: [r skipWideChar] message: "eof reached"
	
****AheadReader >> getWideChar
	self add: (self skipWideChar ->:ch);
	ch!
*****[man.m]
******#en
Appends the next ordinary character or multibyte character to the end of a one-character token and returns that character.
******#ja
次の通常文字、マルチバイト文字を一文字トークンの末尾に追加し、その文字を返す。
*****#ja
******[test.m]
	AheadReader new init: "aあ" ->:r;
	r resetToken;
	self assert: r getWideChar = 'a';
	r add: '-';
	self assert: r getWideChar = 'あ';
	self assert: r token = "a-あ"

****AheadReader >> skipWideEscapeChar
	nextChar = '\\'
		ifTrue:
			[self skipChar;
			self skipChar ->:ch;
			#('a' '\a' 'b' '\b' 'e' '\e' 'f' '\f' 'n' '\n' 'r' '\r' 't' '\t'
				'v' '\v') ->:table;
			0 until: table size by: 2, do:
				[:i
				ch = (table at: i) ifTrue: [table at: i + 1!]];
			ch = 'c' ifTrue:
				[self skipChar upper ->ch, between: '@' and: '_',
					ifTrue: [ch code & 0x1f, asChar!]
					ifFalse: [self error: "illegal ctrl char"]];
			ch = 'x' ifTrue:
				[self skipChar asNumericValue: 16,
					* 16 + (self skipChar asNumericValue: 16), asChar!];
			ch mblead? ifTrue: [self error: "widechar escaped"];
			ch!];
	self skipWideChar!
*****[man.m]
******#en
Skips the next ordinary character, multibyte character, and Mulk escape sequence, and returns that character.
******#ja
次の通常文字、マルチバイト文字、Mulkのエスケープシーケンスを一文字読み飛ばし、その文字を返す。
*****[test.m] 1
	AheadReader new init: "\\a" ->:r;
	self assert: r skipWideEscapeChar = '\a'
*****[test.m] 2
	AheadReader new init: "\\cA\\ca\\c!" ->:r;
	self assert: r skipWideEscapeChar = '\ca';
	self assert: r skipWideEscapeChar = '\ca';
	self assertError: [r skipWideEscapeChar] message: "illegal ctrl char"
*****[test.m] 3
	AheadReader new init: "\\xff\\x!!" ->:r;
	self assert: r skipWideEscapeChar = '\xff';
	self assertError: [r skipWideEscapeChar] message: "not numeric char"
*****#ja
******[test.m] 4
	AheadReader new init: "\\!\\あ" ->:r;
	self assert: r skipWideEscapeChar = '!';
	self assertError: [r skipWideEscapeChar] message: "widechar escaped"
******[test.m] 5
	AheadReader new init: "aあ" ->:r;
	self assert: r skipWideEscapeChar = 'a';
	self assert: r skipWideEscapeChar = 'あ';
	self assertError: [r skipWideEscapeChar] message: "eof reached"
	
****AheadReader >> getWideEscapeChar
	self add: (self skipWideEscapeChar ->:ch);
	ch!
*****[man.m]
******#en
Appends the next regular character, multibyte character, or Mulk escape sequence to the end of a single character token, and returns that character.
******#ja
次の通常文字、マルチバイト文字、Mulkのエスケープシーケンスを一文字トークンの末尾に追加し、その文字を返す。
*****[test.m]
	AheadReader new init: "\\n\\xff" ->:r;
	r resetToken;
	self assert: r getWideEscapeChar = '\n';
	r add: '-';
	self assert: r getWideEscapeChar = '\xff';
	self assert: r token = "\n-\xff"

***read generic token.
****AheadReader >> getQuoted
	self skipChar ->:quote;
	self resetToken;
	[nextChar = quote] whileFalse:
		[nextChar = '\n' or: [nextChar nil?],
			ifTrue: [self error: "quote not closed"];
		self getWideChar];
	self skipChar;
	self token!
*****[test.m]
	AheadReader new init: "'abc'" ->:r;
	self assert: r getQuoted = "abc";
	AheadReader new init: "'def" ->r;
	self assertError: [r getQuoted] message: "quote not closed"
	
****AheadReader >> getTokenIfEnd: endBlockArg
	self skipSpace;
	nextChar nil? ifTrue: [endBlockArg value!];
	nextChar = '\'' or: [nextChar = '"'], or: [nextChar = '`'], ifTrue:
		[self getQuoted!];
	self resetToken;
	[nextChar nil? or: [nextChar space?]] whileFalse: [self getChar];
	self token!
*****[man.m]
******#en
Reads and returns a sequence of strings delimited by whitespace or a range enclosed in quotation marks (', ", `) as a token.

If there is no token, endBlockArg is evaluated and the result is returned.
******#ja
空白で区切られた一連の文字列もしくは引用符(', ", `)で囲まれた範囲をトークンとして読み込み、返す。

トークンが無い場合はendBlockArgを評価し、結果を返す。
*****[test.m]
	AheadReader new init: " 123 '456' \"789\" " ->:r;
	[#end] ->:b;
	
	self assert: (r getTokenIfEnd: b) = "123";
	self assert: (r getTokenIfEnd: b) = "456";
	self assert: (r getTokenIfEnd: b) = "789";
	self assert: (r getTokenIfEnd: b) = #end

****AheadReader >> getToken
	self getTokenIfEnd: [self error: "missing token"]!
*****[man.m]
******#en
Reads and returns a sequence of strings delimited by whitespace or a range enclosed in quotation marks (', ", `) as a token.

It is an error if there is no token.
******#ja
空白で区切られた一連の文字列もしくは引用符(', ", `)で囲まれた範囲をトークンとして読み込み、返す。
トークンが無い場合はエラーとなる。
*****[test.m]
	AheadReader new init: " 123 " ->:r;
	self assert: r getToken = "123";
	self assertError: [r getToken] message: "missing token"
	
****AheadReader >> getRestIfEnd: endBlock
	self skipSpace;
	nextChar nil? ifTrue: [endBlock value!];
	self resetToken;
	[nextChar notNil?] whileTrue: [self getChar];
	self token!
*****[man.m]
******#en
Returns everything except whitespace as a string.

If there are no characters other than white space, endBlock is evaluated and the result is returned.
******#ja
空白を除いた残り全てを文字列として返す。

空白以外の文字が無い場合はendBlockを評価し、結果を返す。
*****[test.m]
	AheadReader new init: "  a b c" ->:r;
	self assert: (r getRestIfEnd: [#end]) = "a b c";
	AheadReader new init: " " ->r;
	self assert: (r getRestIfEnd: [#end]) = #end
	
****AheadReader >> getRest
	self getRestIfEnd: [self error: "missing rest"]!
*****[man.m]
******#en
Returns everything except whitespace as a string.

An error occurs if there are no non-whitespace characters.
******#ja
空白を除いた残り全てを文字列として返す。

空白以外の文字が無い場合はエラーとする。
*****[test.m]
	AheadReader new init: "  a b c" ->:r;
	self assert: r getRest = "a b c";
	AheadReader new init: " " ->r;
	self assertError: [r getRest] message: "missing rest"
	
**OutlineReader class.#
	class OutlineReader Object :
		reader file lineNo buf0 buf level pos break? breakLevel;
		feature OutlineReader Reader;
***[man.c]
****#en
Provides a function for reading in units of sections separated by outline lines.
****#ja
アウトライン行で区切られた区画単位で読み込みを行う機能を提供する。

***OutlineReader >> bufLevel
	buf nil? ifTrue: [-1!];
	buf findFirst: [:ch ch <> '*'] ->:result, notNil? ifTrue: [result!];
	buf size!
***OutlineReader >> fetchLine
	reader getLn ->buf;
	lineNo + 1 ->lineNo;
	0 ->pos
***OutlineReader >> startBlock
	buf ->buf0;
	self bufLevel ->level, = -1 ->break?

***OutlineReader >> init: readerArg
	readerArg ->reader;
	0 ->lineNo;
	99 ->breakLevel;
	self fetchLine;
	self startBlock
****[man.m]
*****#en
Initialize the receiver with Reader readerArg.
*****#ja
Reader readerArgでレシーバーを初期化する。

***OutlineReader >> init: readerArg file: fileArg
	fileArg ->file;
	self init: readerArg
***OutlineReader >> file
	file!
***OutlineReader >> setBreak
	self bufLevel ->:l, = -1 | (l between: 1 and: breakLevel) ->break?
***OutlineReader >> getByte
	break? ifTrue: [-1!];
	pos < buf size ifTrue:
		[buf byteAt: pos ->:result;
		pos + 1 ->pos;
		result!];
	self fetchLine;
	self setBreak;
	'\n' code!
***OutlineReader >> getLn
	break? ifTrue: [nil!];
	pos = 0
		ifTrue: [buf]
		ifFalse: [buf copyFrom: pos] ->:result;
	self fetchLine;
	self setBreak;
	result!

***OutlineReader >> nextBlock
	[break?] whileFalse:
		[self fetchLine;
		self setBreak];
	self startBlock
****[man.m]
****#en
Start reading from the beginning of the next block (outline line).

Used to switch to the next block after reading the contents of the block to the end.
****#ja
次の区画の先頭(アウトライン行)から読み込みを開始する。

区画の内容を最後まで読み込んだ後に、次の区画に切り換えるのに使用する。

***OutlineReader >> nextSection
	self assert: level > 0;
	level ->breakLevel;
	self nextBlock;
	99 ->breakLevel
****[man.m]
*****#en
The block corresponding to the lower part of the current block is read, and reading is started from the head of the next section.
*****#ja
現在の区画の下位に当たる区画を読み取ばし、次の区画の先頭から読み込みを開始する。

***OutlineReader >> lineNo
	lineNo!
****[man.m]
*****#en
Returns the line number from the beginning of the current stream.

*****#ja
現在のストリームの先頭からの行番号を返す。

***OutlineReader >> level
	level!
****[man.m]
*****#en
Returns the current parcel level.

Returns 0 if there is no outline at the beginning of the stream, and -1 if there is no block at the end of the stream.
*****#ja
現在の区画のレベルを返す。

ストリーム先頭のアウトライン行がない区画では0を、ストリーム末で区画そのものが存在しない場合-1を返す。

***OutlineReader >> header
	buf0 copyFrom: level, trim!
****[man.m]
*****#en
Returns the contents of the current block header.
*****#ja
現在の区画のヘッダの内容を返す。

***OutlineReader >> skipOutlineMark
	self assert: buf = buf0 & (pos = 0);
	level timesRepeat: [self getByte]
****[man.m]
*****#en
Skip '*' in the outline line from the beginning of the block.
*****#ja
区画の先頭から、アウトライン行の'*'を読み飛ばす。

*Utilities.
**MethodCompiler.
***MethodCompiler.Error class.#
	class MethodCompiler.Error Error : lineNo file;
****MethodCompiler.Error >> lineNo: lineNoArg file: fileArg
	lineNoArg ->lineNo;
	fileArg ->file
****MethodCompiler.Error >> message
	StringWriter new ->:wr;
	wr put: message;
	lineNo notNil? ifTrue: [wr put: " at " + lineNo];
	file notNil? ifTrue: [wr put: " in " + file];
	wr asString!
****MethodCompiler.Error >> file
	file!
****MethodCompiler.Error >> lineNo
	lineNo!
	
***MethodCompiler.Lexer class.#
	class MethodCompiler.Lexer AheadReader;
****MethodCompiler.Lexer >> error: messageArg
	MethodCompiler.Error new message: messageArg ->:error;
	reader kindOf?: OutlineReader, ifTrue:
		[error lineNo: reader lineNo file: reader file];
	error signal
****MethodCompiler.Lexer >> getQuotedString
	self skipChar;
	[nextChar <> '"'] whileTrue:
		[nextChar = '\n' or: [nextChar nil?], ifTrue:
			[self error: "missing close \""];
		self getWideEscapeChar];
	self skipChar;
	self token!
****MethodCompiler.Lexer >> getQuotedChar
	self skipChar;
	self skipWideEscapeChar ->:result;
	self skipChar <> '\'' ifTrue: [self error: "missing close \'"];
	result!
****MethodCompiler.Lexer >> identifierLeadChar?
	nextChar alpha? or: [nextChar = '_']!
****MethodCompiler.Lexer >> identifierTrailChar?
	nextChar nil? ifTrue: [false!];
	self identifierLeadChar? or: [nextChar digit?], or: [nextChar = '?'],
		or: [nextChar = '.']!
****MethodCompiler.Lexer >> binarySelectorChar?
	#('%' '&' '*' '+' '/' '<' '=' '>' '@' '\\' '^' '|' '~' '-')
		includes?: nextChar!
****MethodCompiler.Lexer >> symbolChar?
	nextChar nil? ifTrue: [false!];
	self identifierTrailChar? or: [self binarySelectorChar?],
		or: [nextChar = ':'], or: [nextChar = '$'], or: [nextChar mblead?]!
****MethodCompiler.Lexer >> getToken
	self skipSpace;

	nextChar = '{' ifTrue:
		[[nextChar <> '}'] whileTrue: [self skipWideChar];
		self skipChar;
		self getToken!];

	nextChar nil? ifTrue: [Cons new car: #eof!];

	#('!' '(' ')' ',' ':' ';' '[' ']') includes?: nextChar,
		ifTrue: [Cons new car: self skipChar!];

	self resetToken;

	nextChar = '"' ifTrue:
		[Cons new car: #string, add: self getQuotedString!];
	nextChar = '\'' ifTrue:
		[Cons new car: #char, add: self getQuotedChar!];
	nextChar digit? ifTrue:
		[Cons new car: #number, add: self skipUnsignedNumber!];
	self identifierLeadChar? ifTrue:
		[[self identifierTrailChar?] whileTrue: [self getChar];
		nextChar = ':'
			ifTrue:
				[self getChar;
				Cons new car: #keywordSelector, add: self token]
			ifFalse:
				[Cons new car: #identifier, add: self token]!];
	self binarySelectorChar? ifTrue:
		[self getChar = '-' ifTrue:
			[nextChar = '>' ifTrue: [self skipChar; Cons new car: #arrow!];
			nextChar = '-' ifTrue:
				[[nextChar <> '\n'] whileTrue: [self skipChar];
				self getToken!]];
		[self binarySelectorChar?] whileTrue: [self getChar];
		Cons new car: #binarySelector, add: self token!];
	nextChar = '#' ifTrue:
		[self skipChar;
		nextChar = '(' ifTrue:
			[self skipChar;
			Cons new car: #arrayLiteral!];
		[self symbolChar?] whileTrue: [self getWideChar];
		Cons new car: #symbol, add: self token!];
	nextChar = '$' ifTrue:
		[self skipChar;
		[self identifierTrailChar?] whileTrue: [self getChar];
		Cons new car: #special, add: self token!];

	self error: "illegal char " + nextChar describe!

***MethodCompiler.Parser class.#
	class MethodCompiler.Parser Object :
		lexer next belongClass selector localVars instanceVars primCode;

	singleton Dictionary MethodCompiler.primitiveTable;
****MethodCompiler.Parser >> error: messageArg
	lexer error: messageArg
****MethodCompiler.Parser >> addLocalVar: name
	instanceVars includes?: name, ifTrue:
		[self error: "override instance var " + name];
	localVars indexOf: name, notNil? ifTrue:
		[self error: "duplicate local var " + name];
	localVars addLast: name

****lexer i/f.
*****MethodCompiler.Parser >> scan
	next size = 2 ifTrue: [next cdar ->:result];
	lexer getToken ->next;
	result!
*****MethodCompiler.Parser >> next?: code
	next car = code!
*****MethodCompiler.Parser >> scan: code
	self next?: code, ifFalse: [self error: "missing " + code];
	self scan!

****parser.
*****MethodCompiler.Parser >> globalAt: nameArg
	Mulk at: nameArg asSymbol ifAbsent: [self error: nameArg + " undefined"]!
*****MethodCompiler.Parser >> parseSignature
	self globalAt: (self scan: #identifier) ->:bc,
		memberOf?: Class, ifFalse: [self error: "missing belong class"];
	self belongClass: bc;
	
	self scan: #binarySelector, = ">>" ifFalse: [self error: "missing >>"];

	self next?: #identifier, ifTrue:
		[self scan asSymbol ->selector!];

	self next?: #binarySelector, ifTrue:
		[self scan asSymbol ->selector;
		self addLocalVar: (self scan: #identifier)!];

	StringWriter new ->:buf;
	[self next?: #keywordSelector] whileTrue:
		[buf put: self scan;
		self addLocalVar: (self scan: #identifier)];
	buf asString asSymbol ->selector
*****MethodCompiler.Parser >> parseLiteral
	self next?: #identifier, ifTrue:
		[self globalAt: self scan ->:o, kindOf?: GlobalVar, ifTrue:
			[self error: "global var in literal"];
		o!];

	self next?: #number, ifTrue: [self scan!];
	self next?: #symbol, ifTrue: [self scan asSymbol!];
	self next?: #char, ifTrue: [self scan!];
	self next?: #string, ifTrue: [self scan!];
	self next?: #binarySelector, ifTrue:
		[self scan <> "-", ifTrue: [self error: "missing -"];
		self scan: #number, negated!];
	self next?: #arrayLiteral, ifTrue:
		[self scan;
		Array new ->:ar;
		[self next?: ')'] whileFalse: [ar addLast: self parseLiteral];
		self scan;
		ar asFixedArray!];

	self error: "illegal token " + next
*****MethodCompiler.Parser >> parseBlock
	self scan: '[';
	localVars size ->:argPos;
	[self next?: ':'] whileTrue:
		[self scan;
		self addLocalVar: (self scan: #identifier)];
	Cons new car: #block, add: argPos, add: localVars size - argPos,
		add: self parseStatement ->:tr;
	self scan: ']';
	tr!
*****MethodCompiler.Parser >> parseFactor
	self next?: #identifier, ifTrue:
		[self scan ->:name, = "super" ifTrue: [Cons new car: #super!];
		localVars indexOf: name ->:no, notNil? ifTrue:
			[Cons new car: #localVar, add: no!];
		instanceVars indexOf: name ->no, notNil? ifTrue:
			[Cons new car: #instanceVar, add: no!];
		self globalAt: name ->:o;
		Cons new car: #literal, add: o ->:tr;
		o kindOf?: GlobalVar, ifTrue:
			[Cons new car: #send, add: #get, add: tr ->tr];
		tr!];

	self next?: '(', ifTrue:
		[self scan;
		self parseExpression ->tr;
		self scan: ')';
		tr!];

	self next?: '[', ifTrue: [self parseBlock!];

	Cons new car: #literal, add: (self parseLiteral)!
*****MethodCompiler.Parser >> parseUnaryMessage: tr
	Cons new car: #send, add: self scan asSymbol, add: tr!
*****MethodCompiler.Parser >> parseUnaryExpression
	self parseFactor ->:tr;
	[self next?: #identifier] whileTrue: [self parseUnaryMessage: tr ->tr];
	tr!
*****MethodCompiler.Parser >> parseBinaryMessage: tr
	Cons new car: #send, add: self scan asSymbol, add: tr,
		add: self parseUnaryExpression!
*****MethodCompiler.Parser >> parseBinaryExpression
	self parseUnaryExpression ->:tr;
	[self next?: #binarySelector] whileTrue: [self parseBinaryMessage: tr ->tr];
	tr!
*****MethodCompiler.Parser >> parseKeywordMessage: tr
	StringWriter new ->:buf;
	Cons new car: #send, add: nil, add: tr ->tr;
	[self next?: #keywordSelector] whileTrue:
		[buf put: (self scan);
		tr add: (self parseBinaryExpression)];
	tr cdr car: buf asString asSymbol;
	tr!
*****MethodCompiler.Parser >> parseKeywordExpression
	self parseBinaryExpression ->:tr;
	self next?: #keywordSelector, ifTrue: [self parseKeywordMessage: tr ->tr];
	tr!
*****MethodCompiler.Parser >> parseAssign: tr
	self scan: #arrow;
	self next?: ':',
		ifTrue:
			[self scan;
			self addLocalVar: (self scan: #identifier);
			Cons new car: #setLocalVar, add: tr, add: localVars size - 1!]
		ifFalse:
			[self scan: #identifier ->:name;
			localVars indexOf: name ->:no, notNil? ifTrue:
				[no = 0 ifTrue: [self error: "can't assign to self"];
				Cons new car: #setLocalVar, add: tr, add: no!];
			instanceVars indexOf: name ->no, notNil? ifTrue:
				[Cons new car: #setInstanceVar, add: tr, add: no!];
			self globalAt: name ->:gv, kindOf?: GlobalVar, ifFalse:
				[self error: name + " is not var"];
			Cons new car: #literal, add: gv ->gv;
			Cons new car: #send, add: #setTo:, add: tr, add: gv!]
*****MethodCompiler.Parser >> parseCascade: tr
	self scan: ',';
	tr ->:tr0;
	[self next?: #identifier, or: [self next?: #binarySelector],
			or: [self next?: #keywordSelector]]
		whileTrue:
			[self next?: #identifier,
				ifTrue:
					[self parseUnaryMessage: tr]
				ifFalse:
					[self next?: #binarySelector,
						ifTrue:
							[self parseBinaryMessage: tr]
						ifFalse:
							[self parseKeywordMessage: tr]] ->tr];
	tr = tr0 ifTrue: [self error: "missing selector"];
	tr!
*****MethodCompiler.Parser >> parseExpression
	self parseKeywordExpression ->:result;
	[self next?: #arrow, or: [self next?: ',']]
		whileTrue:
			[self next?: #arrow,
				ifTrue: [self parseAssign: result]
				ifFalse: [self parseCascade: result] ->result];
	result!
*****MethodCompiler.Parser >> parseStatement
	self next?: #eof, ifTrue: [self error: "statement empty"];

	self parseExpression ->:result;

	self next?: ';', ifTrue:
		[Cons new car: ';', cdr: (Cons new car: result ->:tail) ->result;
		[self scan;
		tail cdr: (Cons new car: self parseExpression ->tail);
		self next?: ';'] whileTrue];

	self next?: '!', ifTrue:
		[self scan;
		Cons new car: '!', add: result ->result];

	result!
*****MethodCompiler.Parser >> parseBody
	self next?: #special, ifTrue:
		[MethodCompiler.primitiveTable at: self scan
			ifAbsent: [self error: "illegal primitive"] ->primCode;
		self next?: #eof, ifTrue: [nil!]];

	self parseStatement ->:tr;

	self scan: #eof;
	tr!

****public.
*****MethodCompiler.Parser >> init: reader
	MethodCompiler.Lexer new initReader: reader ->lexer;
	Array new ->localVars;
	localVars addLast: "self";
	lexer getToken ->next;
	0x3ff {METHOD_MAX_PRIM} ->primCode
*****MethodCompiler.Parser >> selector
	selector!
*****MethodCompiler.Parser >> selector: symbol
	symbol ->selector
*****MethodCompiler.Parser >> belongClass
	belongClass!
*****MethodCompiler.Parser >> belongClass: class
	class ->belongClass;
	belongClass allInstanceVars ->instanceVars
*****MethodCompiler.Parser >> primCode
	primCode!
*****MethodCompiler.Parser >> localVarsCount
	localVars size!

***MethodCompiler.TreeWalker class.#
	class MethodCompiler.TreeWalker Object;
****MethodCompiler.TreeWalker >> walkList: list
	list do: [:tr self walk: tr]
****MethodCompiler.TreeWalker >> walk: tr
	tr car ->:code, = '!' ifTrue: [self walk: tr cdar!];
	code = ';' ifTrue: [self walkList: tr cdr!];
	code = #setLocalVar or: [code = #setInstanceVar], ifTrue:
		[self walk: tr cdar!];
	code = #send ifTrue: [self walkList: tr cddr!];
	code = #block ifTrue: [self walk: tr cdddar!];
	code = #inline ifTrue:
		[tr cdar ->:sel, = #timesDo: or: [sel = #timesRepeat:],
			ifTrue:
				[self walk: tr cddar;
				self walk: tr cdddar]
			ifFalse: [self walkList: tr cddr]!];
	code = #statement ifTrue: [self walk: tr cdar!]

***MethodCompiler.Optimizer class.#
	class MethodCompiler.Optimizer MethodCompiler.TreeWalker : object?;
****MethodCompiler.Optimizer >> init: object?arg
	object?arg ->object?
****MethodCompiler.Optimizer >> unblock: tr
	-- (#block argpos argcount stmt...)
	tr cdddar!
****MethodCompiler.Optimizer >> blockArgCount: block mustBe: argc for: msg
	-- block = (#block argpos argcount stmt)
	block cddar <> argc ifTrue: [self error: "illegal block for " + msg]
****MethodCompiler.Optimizer >> convertLoop: tr
	-- (#send #loop (#block argpos argcount stmt))
	tr cddr ->:stmts;
	self blockArgCount: stmts car mustBe: 0 for: tr cdar;

	tr car: #inline;
	stmts car: (self unblock: stmts car)
****MethodCompiler.Optimizer >> literal?: c
	c car = #literal!
****MethodCompiler.Optimizer >> convertIfTrueIfFalse: tr
	-- (#send #ifTrue:ifFalse: stmts...) ...
	tr cdar ->:selector;
	tr cddr ->:stmts;
	self blockArgCount: stmts cdar mustBe: 0 for: selector;
	self blockArgCount: stmts cddar mustBe: 0 for: selector;

	stmts car ->:cond;
	self literal?: cond, ifTrue:
		[cond cdar ifTrue: [stmts cdr] ifFalse: [stmts cddr] ->:c;
		tr car: #statement;
		tr cdr car: (self unblock: c car);
		tr cdr cdr: nil!];
		
	tr car: #inline;
	stmts cdr car: (self unblock: stmts cdar);
	stmts cddr car: (self unblock: stmts cddar)
****MethodCompiler.Optimizer >> convertCond: tr
	-- (#send selector stmts...) ...
	tr cdar ->:selector;
	tr cddr ->:stmts;
	self blockArgCount: stmts cdar mustBe: 0 for: selector;

	selector = #ifTrue: or: [selector = #and:],
		ifTrue: [#ifTrue: ->selector]
		ifFalse: [#ifFalse: ->selector];

	stmts car ->:cond;
	self literal?: cond, ifTrue:
		[cond cdar = (selector = #ifTrue:)
			ifTrue: [self unblock: stmts cdar]
			ifFalse: [Cons new car: #literal, add: cond cdar] ->:c;
		tr car: #statement;
		tr cdr car: c;
		tr cdr cdr: nil!];

	tr car: #inline;
	tr cdr car: selector;
	stmts cdr car: (self unblock: stmts cdar)
****MethodCompiler.Optimizer >> convertWhile: tr
	tr cdar ->:selector;
	tr cddr ->:stmts;
	self blockArgCount: stmts car mustBe: 0 for: selector;
	self blockArgCount: stmts cdar mustBe: 0 for: selector;

	tr car: #inline;
	stmts car: (self unblock: stmts car);
	stmts cdr car: (self unblock: stmts cdar)
****MethodCompiler.Optimizer >> convertTimesDo: tr
	tr cdar ->:selector;
	tr cddr ->:stmts;
	self blockArgCount: stmts cdar
		mustBe: (selector = #timesDo: ifTrue: [1] ifFalse: [0]) for: selector;

	tr car: #inline;
	stmts cdr car cdar ->:vn;
	stmts cdr car: (self unblock: stmts cdar);
	stmts add: vn
****MethodCompiler.Optimizer >> convertBinaryConstExpr: tr
	-- #(#send #==/#=/#|/#&/#*/#+/#<< (#literal 1) (#literal 2))
	tr cdar ->:selector;
	tr cddr ->:exps;
	
	tr car: #literal;
	exps car cdar perform: selector with: exps cdar cdar ->:result;
	tr cdr car: result;
	tr cdr cdr: nil
****MethodCompiler.Optimizer >> literal1?: tr
	self literal?: tr, and: [tr cdar == 1]!
****MethodCompiler.Optimizer >> convertInc: tr
	tr cdar ->:selector;
	tr cddar ->:opr1;
	tr cdddar ->:opr2;
	nil ->:opr;
	
	self literal1?: opr1,
		ifTrue: [opr2 ->opr]
		ifFalse: [self literal1?: opr2, ifTrue: [opr1 ->opr]];
	opr notNil? ifTrue:
		[tr cdr car: #_inc;
		tr cddr car: opr;
		tr cddr cdr: nil]
****MethodCompiler.Optimizer >> block?: tr
	tr car = #block!
****MethodCompiler.Optimizer >> convertSend: tr
	-- (#send selector exps...)
	tr cdar ->:selector;
	tr cddr ->:exps;

	selector = #loop and: [self block?: exps car], ifTrue:
		[self convertLoop: tr!];
	selector = #ifTrue:ifFalse:
		and: [self block?: exps cdar], and: [self block?: exps cddar],
		ifTrue: [self convertIfTrueIfFalse: tr!];
	#(#ifTrue: #and: #ifFalse: #or:) includes?: selector,
		and: [self block?: exps cdar],
		ifTrue: [self convertCond: tr!];
	selector = #whileTrue: or: [selector = #whileFalse:],
		and: [self block?: exps car], and: [self block?: exps cdar],
		ifTrue: [self convertWhile: tr!];
	selector = #timesDo: or: [selector = #timesRepeat:],
		and: [self block?: exps cdar],
		ifTrue: [self convertTimesDo: tr!];
	#(#= #== #& #| #* #+ #<<) includes?: selector,
		and: [self literal?: exps car], and: [self literal?: exps cdar],
		ifTrue: [self convertBinaryConstExpr: tr!];
	selector = #code and: [self literal?: exps car],
		and: [exps car cdar kindOf?: AbstractChar],
		ifTrue:
			[tr car: #literal;
			tr cdr car: exps car cdar code;
			tr cdr cdr: nil!];
	object? not and: [selector = #+], ifTrue: [self convertInc: tr]
****MethodCompiler.Optimizer >> walk: tr
	super walk: tr;
	tr car = #send ifTrue: [self convertSend: tr]
****MethodCompiler.Optimizer >> optimize: tr
	tr nil? ifFalse: [self walk: tr]	

***MethodCompiler.BlockFinder class.#
	class MethodCompiler.BlockFinder MethodCompiler.TreeWalker
		: findBlock;
****MethodCompiler.BlockFinder >> walk: tr
	tr car = #block ifTrue: [findBlock value];
	super walk: tr
****MethodCompiler.BlockFinder >> blockExist?: tr
	tr notNil? ifTrue:
		[[true!] ->findBlock;
		self walk: tr];
	false!
	
***MethodCompiler.CG class.#
	class MethodCompiler.CG Object
		: bytecode literal argCount blockExist?;
****MethodCompiler.CG >> initArgCount: narg blockExist?: blockExistArg?
	Array new ->bytecode;
	Array new ->literal;
	narg ->argCount;
	blockExistArg? ->blockExist?
****MethodCompiler.CG >> literalIndex: o
	literal findFirst:
		[:l
		l kindOf?: Number, ifTrue: [l == o] ifFalse: [l = o]] ->:no;
	no nil? ifTrue:
		[literal size ->no;
		literal addLast: o];
	no!		

****generate instruction.
*****MethodCompiler.CG >> opcode: code
	#(	#pushInstanceVar 0
		#pushContextVar 1
		#pushTempVar 2
		#pushLiteral 3
		#setInstanceVar 4
		#setContextVar 5
		#setTempVar 6
		#branchBackward 7
		#drop 8
		#end 9
		#return 10
		#dup 11
		#send 16 -- 1 * 16
		#sendSuper 32 -- 2 * 16
		#block 48 -- 3 * 16
		#branchForward 64 -- 4 * 16 + 0
		#branchTrueForward 65 -- 4 * 16 + 1
		#branchFalseForward 66 -- 4 * 16 + 2
		#startTimesDo 67 -- 4 * 16 + 3
		#timesDo 68 -- 4 * 16 + 4
		#pushInstanceVarShort 80 -- 5 * 16
		#pushContextVarShort 96 -- 6 * 16
		#pushTempVarShort 112 -- 7 * 16
		#pushLiteralShort 128 -- 8 * 16
		#setInstanceVarShort 144 -- 9 * 16
		#setContextVarShort 160 -- 10 * 16
		#setTempVarShort 176 -- 11 * 16
		#send0Short 192 -- 12 * 16
		#send1Short 208 -- 13 * 16
		#sendCommon 224 -- 14 * 16
		#pushCommonLiteral 240 -- 15 * 16
		) ->:table;
	0 until: table size by: 2, do:
		[:i table at: i, = code ifTrue: [table at: i + 1!]];
	self error: "illegal opcode " + code
*****MethodCompiler.CG >> gen: byte
	bytecode addLast: byte
*****MethodCompiler.CG >> genInst: code
	self gen: (self opcode: code)
*****MethodCompiler.CG >> genInst: code with: opr
	self genInst: code;
	self gen: opr
*****MethodCompiler.CG >> genPushInstanceVar: no
	no < 16
		ifTrue: [self gen: (self opcode: #pushInstanceVarShort) + no]
		ifFalse: [self genInst: #pushInstanceVar with: no]
*****MethodCompiler.CG >> genPushContextVar: no
	no < 16
		ifTrue: [self gen: (self opcode: #pushContextVarShort) + no]
		ifFalse: [self genInst: #pushContextVar with: no]
*****MethodCompiler.CG >> genPushTempVar: no
	no < 16
		ifTrue: [self gen: (self opcode: #pushTempVarShort) + no]
		ifFalse: [self genInst: #pushTempVar with: no]
*****MethodCompiler.CG >> genPushLiteral: lit
	#(0 1 2 -1 nil true false) findFirst: [:l l == lit] ->:no, notNil? ifTrue:
		[self gen: (self opcode: #pushCommonLiteral) + no!];
		
	self literalIndex: lit ->no;
	no < 16
		ifTrue: [self gen: (self opcode: #pushLiteralShort) + no]
		ifFalse: [self genInst: #pushLiteral with: no]
*****MethodCompiler.CG >> genSetInstanceVar: no
	no < 16
		ifTrue: [self gen: (self opcode: #setInstanceVarShort) + no]
		ifFalse: [self genInst: #setInstanceVar with: no]
*****MethodCompiler.CG >> genSetContextVar: no
	no < 16
		ifTrue: [self gen: (self opcode: #setContextVarShort) + no]
		ifFalse: [self genInst: #setContextVar with: no]
*****MethodCompiler.CG >> genSetTempVar: no
	no < 16
		ifTrue: [self gen: (self opcode: #setTempVarShort) + no]
		ifFalse: [self genInst: #setTempVar with: no]
*****MethodCompiler.CG >> genSendSuper: sel narg: narg
	self gen: (self opcode: #sendSuper, + narg);
	self gen: (self literalIndex: sel)
*****MethodCompiler.CG >> genSend: sel narg: narg
.if ~disableSendCommon
	#(#= #+ #< #nil? #notNil? #_inc #at: #value: #at:put: #byteAt:)
			indexOf: sel ->:cno, notNil? ifTrue:
		[self gen: (self opcode: #sendCommon) + cno!];
.end
	self literalIndex: sel ->:sno;
	narg < 2 and: [sno < 16],
		ifTrue:
			[narg = 0 ifTrue: [#send0Short] ifFalse: [#send1Short] ->:op;
			self gen: (self opcode: op) + sno]
		ifFalse:
			[self gen: (self opcode: #send, + narg);
			self gen: sno]

****tree walk.
*****MethodCompiler.CG >> generateLoop: tr
	tr cddr ->:exps;
	bytecode size ->:l1;
	self generateStatement: exps car drop?: true;
	self genInst: #branchBackward with: bytecode size + 2 - l1
*****MethodCompiler.CG >> generateIfTrueIfFalse: tr
	tr cddr ->:exps;
	self generateExpression: exps car;
	self genInst: #branchFalseForward with: 0;
	bytecode size ->:refL1;
	self generateStatement: exps cdar;
	self genInst: #branchForward with: 0;
	bytecode size ->:refL2;
	bytecode at: refL1 - 1 put: refL2 - refL1;
	self genInst: #drop;
	self generateStatement: exps cddar;
	bytecode at: refL2 - 1 put: bytecode size - refL2
*****MethodCompiler.CG >> generateCond: tr
	tr cddr ->:stmts;
	self generateExpression: stmts car;
	tr cdar = #ifTrue:
		ifTrue: [#branchFalseForward]
		ifFalse: [#branchTrueForward] ->:inst;
	self genInst: inst with: 0;
	bytecode size ->:refL1;
	self generateStatement: stmts cdar;
	bytecode at: refL1 - 1 put: bytecode size - refL1
*****MethodCompiler.CG >> generateWhile: tr
	tr cddr ->:stmts;
	bytecode size ->:l1;
	self generateStatement: stmts car;
	self genInst: (tr cdar = #whileTrue:
		ifTrue: [#branchFalseForward] ifFalse: [#branchTrueForward]) with: 0;
	bytecode size ->:refL2;
	self generateStatement: stmts cdar drop?: true;
	self genInst: #branchBackward with: bytecode size + 2 - l1;
	bytecode at: refL2 - 1 put: bytecode size - refL2
*****MethodCompiler.CG >> generateTimesDo: tr
	tr cddr ->:stmts;
	self generateExpression: stmts car;
	self genInst: #startTimesDo;
	bytecode size ->:l1;
	self genInst: #timesDo;
	self gen: (tr cdar = #timesDo: ifTrue: [stmts cddar] ifFalse: [0]);
	self gen: 0;
	bytecode size ->:l2;
	self generateStatement: stmts cdar drop?: true;
	self genInst: #branchBackward with: bytecode size + 2 - l1;
	bytecode at: l2 - 1 put: bytecode size - l2
*****MethodCompiler.CG >> generateInline: tr
	-- (#line selector receiver arg ...)
	tr cdar ->:selector;
	tr cddr ->:exps;
	selector = #loop ifTrue: [self generateLoop: tr!];
	selector = #ifTrue:ifFalse: ifTrue: [self generateIfTrueIfFalse: tr!];
	selector = #ifTrue: or: [selector = #ifFalse:], ifTrue:
		[self generateCond: tr!];
	selector = #whileTrue: or: [selector = #whileFalse:], ifTrue:
		[self generateWhile: tr!];
	selector = #timesDo: or: [selector = #timesRepeat:], ifTrue:
		[self generateTimesDo: tr!];
	self assertFailed	
*****MethodCompiler.CG >> generateSend: tr
	-- (#send #selector receiver arg ...)
	tr cdar ->:selector;
	tr cddr ->:exps;
	exps size - 1 ->:narg;
	
	exps car car = #super
		ifTrue:
			[self genPushTempVar: 0;
			narg > 0 ifTrue:
				[exps cdr do: [:exp self generateExpression: exp]];
			self genSendSuper: selector narg: narg!];

	exps do: [:exp2 self generateExpression: exp2];
	self genSend: selector narg: narg
*****MethodCompiler.CG >> generateBlock: tr
	-- (#block argPos narg stmt)
	tr cdar ->:argPos;
	tr cddar ->:narg;

	self gen: (self opcode: #block, + narg);
	self gen: 0;
	
	bytecode size ->:st;

	narg timesDo:
		[:i
		self genPushTempVar: i + 1;
		self genSetContextVar: argPos + i];
		
	tr cdddar ->:stmt;
	self generateStatement: stmt;
	stmt car <> '!' ifTrue: [self genInst: #end];
	bytecode at: st - 1 put: bytecode size - st
*****MethodCompiler.CG >> generateValueExpression: tr
	tr car ->:code, = #literal ifTrue: [self genPushLiteral: tr cdar!];
	code = #localVar ifTrue:
		[blockExist?
			ifTrue: [self genPushContextVar: tr cdar]
			ifFalse: [self genPushTempVar: tr cdar]!];
	code = #instanceVar ifTrue: [self genPushInstanceVar: tr cdar!];
	code = #send ifTrue: [self generateSend: tr!];
	code = #inline ifTrue: [self generateInline: tr!];
	code = #block ifTrue: [self generateBlock: tr!];
	code = #statement ifTrue: [self generateStatement: tr cdar!];
	self assertFailed
*****MethodCompiler.CG >> generateExpression: tr drop?: drop?
	tr car ->:code, = #setInstanceVar ifTrue:
		[self generateExpression: tr cdar;
		drop? ifFalse: [self genInst: #dup];
		self genSetInstanceVar: tr cddar!];
	code = #setLocalVar ifTrue:
		[self generateExpression: tr cdar;
		drop? ifFalse: [self genInst: #dup];
		blockExist?
			ifTrue: [self genSetContextVar: tr cddar]
			ifFalse: [self genSetTempVar: tr cddar]!];
	drop? and: [tr car = #statement], and: [tr cdar car = #literal],
		ifTrue: [self!];
	self generateValueExpression: tr;
	drop? ifTrue: [self genInst: #drop]
*****MethodCompiler.CG >> generateExpression: tr
	self generateExpression: tr drop?: false
*****MethodCompiler.CG >> generateStatement: tr drop?: drop?
	tr car ->:code, = '!' ifTrue:
		[self generateStatement: tr cdar drop?: false;
		self genInst: #return!];

	code = ';' ifTrue:
		[tr cdr ->tr;
		[self generateExpression: tr car
			drop?: (tr cdr ->tr, nil? ifTrue: [drop?] ifFalse: [true]);
		tr notNil?] whileTrue!];
	
	self generateExpression: tr drop?: drop?
*****MethodCompiler.CG >> generateStatement: tr
	self generateStatement: tr drop?: false

****public.
*****MethodCompiler.CG >> generateBody: tr
	tr nil? ifTrue: [self!];

	blockExist? ifTrue:
		[argCount + 1 timesDo:
			[:i
			self genPushTempVar: i;
			self genSetContextVar: i]];

	tr car = '!'
		ifTrue: [self generateStatement: tr]
		ifFalse:
			[self generateStatement: tr drop?: true;
			self genPushTempVar: 0;
			self genInst: #return]
*****MethodCompiler.CG >> bytecode
	bytecode!
*****MethodCompiler.CG >> literal
	literal!

***MethodCompiler class.#
	class MethodCompiler Object :
		parser cg reader argCount localVarsCount blockExist?;
****MethodCompiler >> makeMethod
	Method basicNew: cg literal size + (cg bytecode size << 8) ->:result;
	blockExist?
		ifTrue:
			[result
				initSelector: parser selector
				argCount: argCount
				belongClass: parser belongClass
				primCode: parser primCode
				extTempSize: 0
				contextSize: localVarsCount
				bytecode: cg bytecode
				literal: cg literal]
		ifFalse:
			[result
				initSelector: parser selector
				argCount: argCount
				belongClass: parser belongClass
				primCode: parser primCode
				extTempSize: localVarsCount - argCount - 1
				contextSize: 0
				bytecode: cg bytecode
				literal: cg literal]!
****MethodCompiler >> compile: r
	r ->reader;
	MethodCompiler.Parser new init: reader ->parser;

	parser parseSignature;
	--Out putLn: "compile: " + parser belongClass + ' ' + parser selector;
	parser localVarsCount - 1 ->argCount;
	parser parseBody ->:tr;
	parser localVarsCount ->localVarsCount;
	MethodCompiler.Optimizer new init: parser belongClass = Object,
		optimize: tr;
	MethodCompiler.BlockFinder new blockExist?: tr ->blockExist?;
	MethodCompiler.CG new initArgCount: argCount blockExist?: blockExist? ->cg;
	cg generateBody: tr;
	
	self makeMethod!
****MethodCompiler >> compileBody: r class: bc selector: s
	r ->reader;
	MethodCompiler.Parser new init: reader, selector: s, belongClass: bc
		->parser;

	0 ->argCount;
	parser parseBody ->:tr;
	parser localVarsCount ->localVarsCount;
	MethodCompiler.Optimizer new init: bc = Object, optimize: tr;
	MethodCompiler.BlockFinder new blockExist?: tr ->blockExist?;
	MethodCompiler.CG new initArgCount: argCount blockExist?: blockExist? ->cg;
	cg generateBody: tr;
	
	self makeMethod!
****MethodCompiler >> compileBody: r class: bc
	self compileBody: r class: bc selector: #_!

**Loader class.#
	class Loader Object : reader;
***Loader >> loadMethod
	reader skipOutlineMark;
	MethodCompiler new compile: reader ->:m;
	m belongClass addMethod: m;
	reader nextBlock
***Loader >> loadEval
	--eval block can access reader for next block.
	reader getLn;
	MethodCompiler new compileBody: reader class: self class ->:m;
	reader nextBlock;	
	self performMethod: m
***Loader >> copyBlock: nameArg
	reader level ->:blockLevel;
	StringWriter new ->:wr;
	reader getLn;
	[reader getLn ->:ln, notNil?] whileTrue: [wr putLn: ln];
	reader nextBlock;
	[reader level ->:level, > blockLevel] whileTrue:
		[reader getLn;
		wr put: "*" times: level - blockLevel, putLn: reader header;
		[reader getLn ->ln, notNil?] whileTrue: [wr putLn: ln];
		reader nextBlock];
	Mulk at: nameArg asSymbol put: wr asString
***Loader >> loadBlock
	reader header ->:header;
	header empty? ifTrue: [reader nextBlock!];
	header first ->:first, = '[', ifTrue: [reader nextSection!];
	first = '#' and: [header copyFrom: 1, heads?: Mulk.lang, not],
		ifTrue: [reader nextSection!];
	header includesSubstring?: " >> ", ifTrue: [self loadMethod!];
	header last ->:last, = '@' ifTrue: [self loadEval!];
	last = '>' ifTrue:
		[self evalExpr: (header copyUntil: header size - 1),
			ifFalse: [reader nextSection!]];
	header heads?: "->", ifTrue: [self copyBlock: (header copyFrom: 2)!];
	reader nextBlock
***Loader >> loadLoop
	reader level = 0 ifTrue: [reader nextBlock];
	[reader level <> -1] whileTrue: [self loadBlock]
***Loader >> loadReader: r
	OutlineReader new init: r ->reader;
	self loadLoop
***Loader >> load: file
	file readDo:
		[:r
		OutlineReader new init: r file: file ->reader;
		self loadLoop]

**ImageWriter class.#
	class ImageWriter Object : stream objectMap lastObjectCode queue;
***ImageWriter >> init
	StrictDictionary new ->objectMap;
	0 ->lastObjectCode;
	Ring new ->queue
***ImageWriter >> putByte: byte
	stream putByte: byte
***ImageWriter >> putUint: val
	self assert: val >= 0;
	[val > 0x7f] whileTrue:
		[self putByte: val & 0x7f + 0x80;
		val >> 7 ->val];
	self putByte: val
***ImageWriter >> putSint: val
	--negative value uses 5 byte always.
	val < 0 ifTrue: [(1 << 31) + val ->val];
	self putUint: val * 2 + 1
***ImageWriter >> addQueue: object
	lastObjectCode ->:result;
	lastObjectCode + 1 ->lastObjectCode;
	queue addLast: object;
	result!
***ImageWriter >> objectRefCode: object
	objectMap at: object ifAbsentPut: [self addQueue: object]!
***ImageWriter >> putObjectRef: object
	object memberOf?: ShortInteger,
		ifTrue: [self putSint: object]
		ifFalse: [self putUint: (self objectRefCode: object) * 2]
***ImageWriter >> putObject: object
	object class ->:class, = Method
		ifTrue: [248 {SIZE_METHOD_IR}] ifFalse: [class size] ->:sz;
	self putByte: sz;
	self putUint: object hash;
	class special?
		ifTrue: [class variableSize? ifTrue: [self putUint: object basicSize]]
		ifFalse:
			[class = Method
				ifTrue:
					[self putByte: object basicSize;
					self putUint: object bytecodeSize]
				ifFalse: [self putObjectRef: class]];
	object serializeTo: self
***ImageWriter >> writeQueue
	[queue empty?] whileFalse:
		[self putObject: queue first;
		queue removeFirst]
***ImageWriter >> writeTo: file
	file openWrite ->stream;
	#(
	-- system objects. (om.h)
		nil
		true
		false
		Class
		ShortInteger
		LongPositiveInteger
		Float
		FixedByteArray
		String
		Symbol
		FixedArray
		Method
		Process
		Context
		Block
		Char
		Mulk
		#boot:
		#doesNotUnderstand:
		#primitiveFailed:
		#error:
		#trap:cp:sp:
		#=
		#+
		#<
		#_inc
		#at:
		#value:
		#at:put:
		#byteAt:
	) do: [:o self objectRefCode: o];
	self writeQueue;
	self putByte: 255; --SIZE_SINT (is not om)
	stream close

*Cmd.eval class.#
	class Cmd.eval Object;
	singleton GlobalVar _last; -- for repl.
**Cmd.eval >> main: args
	args size <> 0
		ifTrue: [self evalAndPrint: args asString]
		ifFalse: [self evalReader: In]

*Mulk.class class.#
	class Mulk.class Dictionary : imageFile imported;
	singleton Mulk.class Mulk;
	singleton Dictionary WideChar.dictionary;
	
	singleton GlobalVar Mulk.defaultMainClass;
	singleton GlobalVar Mulk.systemDirectory;
	singleton GlobalVar Mulk.extraSystemDirectory;
	singleton GlobalVar Mulk.workDirectory;
	singleton GlobalVar Mulk.lang;
	
	singleton Array Mulk.bootHook;
	singleton Array Mulk.quitHook;

	--Mulk.hostOS
	--Mulk.codepage
	--Mulk.charset
	--Mulk.newline
	--Mulk.caseInsensitiveFileName?
	
**[man.c]
***#en
Class that defines the system dictionary Mulk.

Mulk is an associative array that holds all global objects, and Mulk itself is a global object.
All keys must be symbols.

It should not be reconstruct.

The startup image is the Mulk object itself, and loading a module is equivalent to adding an element to the Mulk.
Therefore, image saving and module loading are also processed as messages to Mulk.

The following global objects hold configuration information.

	Mulk.defaultMainClass -- Class name symbol for objects that are executed at startup. The object must have a main: method.
	Mulk.systemDirectory -- System directory. Holds system files.
	Mulk.extraSystemDirectory -- Additional system directory. It is searched before systemDirectory.
	Mulk.workDirectory -- Work directory. Hold work files.
	Mulk.lang -- Language settings. "en" or "ja".

The following are fixed values, and hold information about the implementation.

	Mulk.hostOS -- OS name symbol of the running host system.
	Mulk.hostOSUnix? -- true if the host system is Unix compatible.
	Mulk.codepage -- (Windows only) Codepage number. If undefined, UTF-8 is used.
	Mulk.charset -- A symbol representing a wide character code. #utf8 or #sjis.
	Mulk.newline -- Newline character for text files. #lf or #crlf.
	Mulk.caseInsensitiveFileName? -- true if the file name is not case sensitive.
***#ja
システム辞書Mulkを定義するクラス。

Mulkはグローバルオブジェクト全てを保持する連想配列で、Mulk自身もグローバルオブジェクトである。
キーは全てシンボルでなくてはならない。

再構築してはならない。

起動イメージはMulkオブジェクトそのものであり、モジュールの読み込みはMulkに要素を追加する事に相当する。
そのためイメージの保存やモジュールの読み込みもMulkへのメッセージとして処理される。

以下のグローバルオブジェクトは設定情報を保持する。

	Mulk.defaultMainClass -- 起動時に実行されるオブジェクトのクラス名シンボル。オブジェクトはmain:メソッドを持つ必要がある。
	Mulk.systemDirectory -- システムディレクトリ。システムファイルを保持する。
	Mulk.extraSystemDirectory -- 追加のシステムディレクトリ。systemDirectoryに先行して検索される。
	Mulk.workDirectory -- ワークディレクトリ。ワークファイルを保持する。
	Mulk.lang -- 言語設定。"en"か"ja"。

以下は固定値であり、実装についての情報を保持している。

	Mulk.hostOS -- 動作しているホストシステムのOS名称シンボル。
	Mulk.hostOSUnix? -- ホストシステムがUnix互換ならtrue。
	Mulk.codepage -- (Windowsのみ)コードページ番号。未定義時はUTF-8となる。
	Mulk.charset -- ワイド文字の文字コードを表すシンボル。#utf8もしくは#sjis。
	Mulk.newline -- テキストファイルの改行文字。#lfもしくは#crlf。
	Mulk.caseInsensitiveFileName? -- ファイル名は英字の大文字小文字を区別しない場合、true。
	
**image.
***Mulk.class >> imageFile
	imageFile!
****[man.m]
*****#en
Returns a File object for the boot image.
*****#ja
起動イメージのFileオブジェクトを返す。

***Mulk.class >> saveFile: fileArg
	ImageWriter new writeTo: fileArg
	
***Mulk.class >> save: fileNameArg
	self saveFile: fileNameArg asFile
****[man.m]
*****#en
Save the image to the file indicated by String fileNameArg.
*****#ja
String fileNameArgで示されるファイルへイメージを保存する。

***Mulk.class >> save
	self saveFile: imageFile
****[man.m]
*****#en
Write the current Mulk back to the boot image file.
*****#ja
現在のMulkを起動イメージファイルに書き戻す。

**load and import.
***Mulk.class >> loadFile: fileArg
	Loader new load: fileArg;
	fileArg system? ifTrue: [imported add: fileArg baseName]
	
***Mulk.class >> load: fileNameArg
	self loadFile: fileNameArg asFile
****[man.m]
*****#en
Loads the module file indicated by String fileNameArg.
*****#ja
String fileNameArgで示されるモジュールファイルをロードする。

***Mulk.class >> import: moduleArg
	moduleArg memberOf?: FixedArray, ifTrue:
		[moduleArg do: [:p self import: p];
		self!];
	imported includes?: moduleArg, ifFalse:
		[self loadFile: (moduleArg + ".m") asSystemFile]
****[man.m]
*****#en
Load system modules.

The argument specifies a single module name or a FixedArray of module names.
If the module is already loaded, do nothing.
If you need to reload the module file, use Mulk.class >> load:.
*****#ja
システムモジュールをロードする。

引数は単一のモジュール名もしくはモジュール名のFixedArrayを指定する。
モジュールが既にロード済みの場合は、なにもしない。
モジュールファイルの再読み込みが必要な場合はMulk.class >> load:を使用する。

***Mulk.class >> at: symbolArg in: moduleArg
	self at: symbolArg ifAbsent:
		[self import: moduleArg;
		self at: symbolArg]!
****[man.m]
*****#en
Returns the global object symbol defined in the system module moduleArg.

If the module is not loaded, it will be loaded automatically.
*****#ja
システムモジュールmoduleArg中で定義されているグローバルオブジェクトsymbolArgを返す。

モジュールがロードされていない場合は自動的にロードする。

***Mulk.class >> imported
	imported asArray!
****[man.m]
*****#en
Returns a list of loaded system modules.
*****#ja
ロード済みのシステムモジュールの一覧を返す。

**global variables.
***Mulk.class >> addGlobalVar: symbolArg
	self at: symbolArg put: (GlobalVar new ->:result);
	result!
****[man.m]
*****#en
Create a global variable Symbol symbolArg.

Returns variable object and can be initialize the value with set: method in the cascade.
Once saved to the image, it will be initialized with the saved value on reboot.
*****#ja
大域変数Symbol symbolArgを作成する。

返り値として変数オブジェクトを返し、カスケードでset:する事で初期化出来る。
イメージに保存すると、再起動時は保存した値で初期化される。

***Mulk.class >> addTransientGlobalVar: symbolArg
	self at: symbolArg put: (TransientGlobalVar new ->:result);
	result!
****[man.m]
*****#en
Create a volatile global variable Symbol symbolArg.

Returns variable object and can be initialize the value with set: method in the cascade.
Once saved to an image, it will be initialized with nil on reboot.
*****#ja
揮発性の大域変数Symbol symbolArgを作成する。

返り値として変数オブジェクトを返し、カスケードでset:する事で初期化出来る。
イメージに保存すると、再起動時はnilで初期化される。

**Mulk.class >> quit
	QuitException new signal
***[man.m]
****#en
Quit the system.
****#ja
システムを終了する。

.if windows
**Mulk.class >> codepage: arg
	$codepage
.end

**Mulk.class >> initFiles
	OS init;
	FileStream new init: (OS propertyAt: 0) ->In ->In0;
	FileStream new init: (OS propertyAt: 1) ->Out ->Out0;
	File new fileOfPath: (OS propertyAt: 2) ->File.current;
	OS getenv: "HOME" ->:home, nil? ifFalse:
.if windows|dos
		[StringWriter new ->:w;
		StringReader new init: home ->:r;
		w put: '/', put: r getChar;
		r getChar;
		[r getWideChar ->:ch, notNil?] whileTrue:
			[ch = '\\' ifTrue: ['/' ->ch];
			w put: ch];
		w asString asFile ->File.home]
.else
		[home asFile ->File.home]
.end
**Mulk.class >> boot: args
.if ib
	{args = #(globalTable symbolTable mainArgs)
		--see ib.c/make_boot_args
	}
	self init;

	args at: 0 ->:globals;
	0 until: globals size by: 2, do:
		[:i
		self at: (globals at: i) put: (globals at: i + 1)];

	SymbolTable init;
	args at: 1, do: [:symbol SymbolTable add: symbol];

	WideChar.dictionary init;

	self initFiles;

	MethodCompiler.primitiveTable init;
	0 ->:no;
	"mulkprim.wk" asFile openRead ->:reader;
	[reader getLn ->:s, notNil?] whileTrue:
		[MethodCompiler.primitiveTable at: (s copyFrom: 8 until: s size - 1)
			put: no;
		no + 1 ->no];
	reader close;

	Set new add: "base" ->imported;

	Mulk at: #Mulk.hostOS put:
.if linux
		#linux
.elseif cygwin
		#cygwin
.elseif android
		#android
.elseif macosx
		#macosx
.elseif minix
		#minix
.elseif freebsd
		#freebsd
.elseif netbsd
		#netbsd
.elseif illumos
		#illumos
.elseif windows
		#windows
.elseif dos
		#dos
.elseif cm
		#cm
.end
		;

	Mulk at: #Mulk.hostOSUnix? put:
.if unix
		true
.else
		false
.end
		;
		
	Mulk at: #Mulk.charset put: #utf8;
	Mulk at: #Mulk.newline put: #lf;

	Mulk at: #Mulk.caseInsensitiveFileName? put:
.if caseInsensitiveFileName
		true
.else
		false
.end
		;
		
	#Cmd.eval ->Mulk.defaultMainClass ->:mainClass;
	Mulk.bootHook init;
	Mulk.quitHook init;
	"en" ->Mulk.lang;

	args at: 2 ->:mainArgs;
.else
	{args=#(mainClass mainArgs imageFileName)
		--see mulk.c/make_boot_args
	}
	
	args at: 0 ->:mainClass,
		nil? ifTrue: [Mulk.defaultMainClass] ifFalse: [mainClass asSymbol]
		->mainClass;
	args at: 1 ->:mainArgs;

.if windows
	self codepage: (Mulk at: #Mulk.codepage ifAbsent: [65001]);
.end
	self initFiles;
	
	args at: 2,
		asFile ->imageFile;

	Mulk.systemDirectory nil?
		ifTrue: [imageFile parent ->Mulk.systemDirectory];
	Mulk.workDirectory nil?
		ifTrue: [Mulk.systemDirectory ->Mulk.workDirectory];
.end
	Kernel currentProcess initExceptionHandlers
		interruptBlock: [self error: "interrupt"];
	[
.if android
		Mulk.bootHook do: [:bh bh onBoot];
.else
		mainClass <> #Cmd.eval ifTrue:
			[Mulk.bootHook do: [:bh bh onBoot]];
.end
		Mulk at: mainClass, new main: mainArgs
	] on: Exception do: [:e e message ->:msg, notNil? ifTrue: [Out putLn: msg]];

	Mulk.quitHook do: [:eh eh onQuit]
