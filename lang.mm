mulk language specification
$Id: mulk lang.mm 1417 2025-04-28 Mon 21:44:09 kt $
#ja Mulk言語仕様書

*#en
This document defines the specification of the programming language Mulk.

.right 2
Ask, don't touch.
--Adele Goldberg, Computer scientist
.index

For the base class library, see the manual topic 'base'.

*#ja
この資料はプログラミング言語Mulkの仕様を定義する。

.right 2	
頼むのよ、触っては駄目。
--Adele Goldberg 計算機科学者
.index

なお、基盤クラスライブラリについてはマニュアルトピックbaseを参照の事。

*Basic concept
**#en
Mulk is an object-oriented programming language.

Mulk derives many of its main concepts from Smalltalk, but it is fairly organized and simplified, and does not require Smalltalk knowledge or experience to use.
**#ja 基本概念
Mulkはオブジェクト指向プログラミング言語である。

Mulkは主要概念の多くをSmalltalkに由来しているが、相当に整理・簡略化されており、使用に当たってSmalltalkの知識や経験を必要としない。

**Object
***#en
In Mulk, everything from basic elements such as logical values, numbers, and characters to arrays, files, user-defined data types, etc. are objects.
***#ja オブジェクト
Mulkにおいては論理値、数、文字と言った基本的な要素から、配列、ファイル、ユーザーの定義するデータ型等々、全てがオブジェクトである。

**Message
***#en
Processing in Mulk is expressed in the form of sending a message to an object.
At this time, the object that receives the message is called a 'receiver'.
When the receiver receives the message, it performs some processing and returns a return value.
Normally, the receiver itself is the return value.
***#ja メッセージ
Mulkにおける処理は、オブジェクトに対してメッセージを送る形で表現される。
この時、メッセージを受け取ったオブジェクトをレシーバーと呼ぶ。
レシーバーはメッセージを受け取ると何らかの処理を行い、返り値を返す。
通常はレシーバー自身が返り値となる。

***Unary message
****#en
A unary message is a message consisting only of a name and has no arguments.
****#ja 単項メッセージ
単項メッセージは名前だけからなるメッセージで、引数を持たない。

***Binary message
****#en
A binary message is a message in the form of a binary operator and has one argument corresponding to the right-hand side value.
****#ja 二項メッセージ
二項メッセージは二項演算子の形式を持つメッセージで、右辺値に対応する引数を一つ持つ。

***Keyword message
****#en
A keyword message is a message with one or more keywords and arguments, and can have multiple arguments.
****#ja キーワードメッセージ
キーワードメッセージは一つ以上のキーワードと引数を持つメッセージで、複数の引数を持つ事が出来る。

**Class
***#en
All objects are classified according to their type.
This kind of thing is called a 'class'.
An object belonging to class X is called an 'instance' of X.

Instances of the same class have a common structure and can respond to common messages.

Here, the class itself is an object, and is an instance of the class Class.

A class has a tree structure with a class Object as a vertex, and a lower class (subclass) of a class inherits the structure and a message that can respond of a higher class (superclass).

Usually, an instance is created by sending a message to a class object.
***#ja クラス
全てのオブジェクトはその種類によって分類される。
この種類の事をクラスと呼ぶ。
クラスXに属するオブジェクトの事をXのインスタンスと呼ぶ。

同じクラスのインスタンスは共通の構造を持ち、共通のメッセージに応答する事が出来る。

ここで、クラス自体がオブジェクトであり、クラスClassのインスタンスである。

クラスはクラスObjectを頂点とする木構造を成しており、あるクラスの下位クラス(サブクラス)は上位クラス(スーパークラス)の構造と応答出来るメッセージを継承する。

通常、クラスオブジェクトにメッセージを送る事でインスタンスを生成する。

***Abstract class
****#en
An abstract class is a class that provides functions and structure to subclasses, and has names that begin with Abstract, except those that are customarily named.

An instance of an abstract class has no meaning when constructed and does not always work properly.
****#ja 抽象クラス
抽象クラスはサブクラスに機能や構造を提供する為のクラスで、慣例的に名前が決められているもの以外はAbstractで始まる名前を持つ。
例えばObjectは抽象クラスである。

抽象クラスのインスタンスは構築しても意味が無く、適切に動作するとは限らない。

**Method
***#en
When the receiver receives the message, it executes a series of processes corresponding to the message.
This process is called a 'method' and is defined in the class.
For this reason, instances of the same class execute the same processing for the same message.

Even if a method corresponding to a message received in a certain class is not defined, if a corresponding method is defined in the super class, that method is executed.

If the corresponding method is not found after going back to Object, the doesNotUnderstand: message is sent to the receiver.
This is usually an error.
***#ja メソッド
レシーバーはメッセージを受け取るとこれに対応する一連の処理を実行する。
この処理はメソッドと呼ばれ、クラスで定義される。
この為、同じクラスのインスタンスは同じメッセージに対して同じ処理を実行する事になる。

あるクラスで受信したメッセージに対応したメソッドが定義されていなくても、スーパークラスで対応するメソッドが定義されていれば、そのメソッドが実行される。

Objectまで遡っても対応したメソッドが見付からない場合は、レシーバーにdoesNotUnderstand:メッセージが送信される。
これは通常エラーとなる。

**Feature
***#en
A 'feature' is a mechanism for defining common methods across classes.

A feature is a subclass of the Feature class, and a class to which a feature is assigned can execute methods defined in the feature in addition to the methods defined in the class.

If there is a method with the same name in the class, the class method is executed with priority.
If there is a method with the same name in the superclass, the feature method takes precedence.

A feature is a class, but there is no point in constructing an instance.
***#ja フィーチャー
フィーチャーはクラスを横断して共通のメソッドを定義する仕組みである。

フィーチャーはFeatureクラスのサブクラスで、フィーチャーを割り当てられたクラスはクラスで定義されたメソッドの他に、フィーチャーで定義されたメソッドを実行出来る。
クラスに同名のメソッドがあればクラスのメソッドが優先して実行される。
スーパークラスに同名のメソッドがあった場合はフィーチャーのメソッドが優先する。

フィーチャーはクラスではあるがインスタンスを構築する意味はない。

**Block
***#en
A 'block' is a mechanism of function closure.
Control structures such as branching and repetition are implemented in the class library by blocks and are not included in the language specification.

Blocks can have arguments and can reference values specified during evaluation.
***#ja ブロック
ブロックはクロージャ(関数閉包)の機構である。
分岐や繰り返し等の制御構造は、ブロックによってクラスライブラリで実現される為、言語仕様には含まれない。

ブロックは引数を持つ事が出来、評価時に指定された値を参照出来る。

**Global object
***#en
A 'global object' can be referenced from anywhere in the program by specifying its name.
It corresponds to logical value (true, false), void element (nil), class, etc.

Global objects other than true, false, nil start with an uppercase letter.

Global objects are defined by registering them in the system dictionary Mulk.
***#ja グローバルオブジェクト
グローバルオブジェクトは名前を指定する事でプログラム中の何処からでも参照出来る大域的なオブジェクトの事である。
論理値(true/false)、空要素(nil)、クラス等が相当する。

true/false/nil以外のグローバルオブジェクトはクラスを含め、英大文字で始める。

グローバルオブジェクトはシステム辞書Mulkに登録する事で定義する。

**Variable
***#en
A place where an object is held in the course of processing is called a 'variable'.

All the variables hold are object references.
When assigning values from variable to variable, the two variables refer to the same object.

There is no way to refer to an object that is not a global object and is not referenced by any variable.
Such objects are automatically released by the system.

Variables have names.
Reference by describing the name, and set by assignment expression.

Mulk has the following types of variables:
***#ja 変数
処理の過程でオブジェクトを保持しておく場所を変数と呼ぶ。

変数が保持しているのはあくまでオブジェクトの参照である。
変数から変数に値を代入した場合、この二つの変数は同じオブジェクトを参照している。

グローバルオブジェクトでなく、何如なる変数からも参照されていないオブジェクトを参照する手段はない。
このようなオブジェクトはシステムによって自動的に開放される。

変数は名前を持つ。
名前を記述する事で参照し、代入式で設定する。

Mulkには以下の種類の変数がある。

***Global variable
****#en
An instance of the class GlobalVar, which is a kind of global object.
In terms of notation, values can be referenced by name and set by assignment expression.
****#ja グローバル変数
クラスGlobalVarのインスタンスで、グローバルオブジェクトの一種だが、表記上は変数として値の参照、代入が出来る。

***Instance variable
****#en
Declared when defining a class with a variable that holds the internal state of the instance.

Instances of the same class will have the same name and number of instance variables.

An instance variable can be referenced and assigned only within the method of the class that defines it or its subclass methods.
You cannot refer to or assign an instance variable of a class assigned from a feature method.

Instance variable names start with a lowercase letter.
****#ja インスタンス変数
インスタンスの内部状態を保持する変数でクラス定義時に宣言する。

同一のクラスのインスタンスは同じ名前と数のインスタンス変数を持つ事になる。

インスタンス変数はそれを定義したクラス、又はそのサブクラスのメソッドの中でのみ参照、代入が出来る。
フィーチャーのメソッドから割り当てたクラスのインスタンス変数を参照、代入する事は出来ない。

インスタンス変数名は英小文字で始める。

***Method variable
****#en
Method variables are valid only inside the method and include 'self', 'super', arguments, and local variables.

'self' and 'super' are automatically declared to represent the receiver itself.
You cannot assign to these two variables.
If you send a message to 'super', you can call the superclass method of the class that defined the method.

Arguments are method arguments and  block arguments.
They are declared in the method definition and block notation within the definition.

Local variables are other variables that are declared at the same time as assignment.

Method variable names start with a lowercase letter.
Method variables have scope from definition to the end of the method.
Instance variable and name must not overlap.
****#ja メソッド変数
メソッド変数はメソッドの内部でのみ有効な変数で、self、super、引数、ローカル変数がある。

self、superは自動的に宣言されレシーバー自身を表す。
この二つの変数には代入出来ない。
superにメッセージを送ると、メソッドを定義したクラスのスーパークラスのメソッドを呼び出す事が出来る。

引数はメソッド引数/ブロック引数でメソッド定義や定義内のブロック表記で宣言される。

ローカル変数はそれ以外の変数で、代入と同時に宣言する。

メソッド変数名は英小文字で始める。
メソッド変数は定義からメソッド終端までのスコープを持つ。
インスタンス変数と名前が重複してはならない。

*Meta language
**#en
The grammar is defined by the following EBNF notation.

	x? -- x can be omitted.
	x | y -- x or y.
	x+ -- One or more repetition of x.
	x* -- Zero or more repetition of x.
	() -- Grouping.
	'x' -- Fixed phrase. Indicates the character sequence. x may be plural.
	[...] -- Character group. One of the characters specified in []. When writen as x-y, one of the ASCII character sets between x and y. The leading ~ indicates any character other than those specified in [].
	= -- Definition. The syntax element indicated on the left side is defined on the right side.

If '\' is described in a fixed phrase or a character group, it means the following character itself.
Exceptions are '\t' for tab characters, '\n' for newline characters, and '\m' for multibyte characters.
**#ja メタ言語
文法を以下のEBNF表記で定義する。

	x? -- xは省略可能。
	x | y -- x又はy。
	x+ -- xの一つ以上の繰り返し。
	x* -- xの0個以上の繰り返し。
	() -- グループ化。
	'x' -- 固定字句。文字の並びxを示す。xは複数の場合もある。
	[...] -- 文字グループ。[]内で指定された文字の何れか。x-yと表記された場合はASCII文字セットでxとyの間の何れか。先頭の~は[]内で指定された文字以外の何れかを示す。
	= -- 定義。左辺で示される構文要素は右辺で定義される。

固定字句及び文字グループ中で'\'を記述した場合、後続する文字そのものを意味する。
例外として'\t'でタブ文字、'\n'で改行文字、'\m'でマルチバイト文字を示す。
	
*Lexical rules
**#ja 字句規則

**Delimiter
***#en
Mulk is a free-format language, and it is possible to write a comment or a space arbitrarily at a break point in the syntax rules.
They are ignored except when used as delimiters.
***#ja 要素の区切り
Mulkはフリーフォーマットの言語であり、構文規則上の区切り位置に任意にcommentかspaceを書く事が出来る。
これらは区切りとして使用される以外は無視される。

***comment
****#en
	comment = '--' [~\n]* | '{' [~}]* '}'
	
The <comment> is from '--' to the end of the line, or the range enclosed by '{' and '}'.
'{' ... '}' comments cannot be nested.
****#ja comment(コメント)
	comment = '--' [~\n]* | '{' [~}]* '}'

commentは'--'から行末まで、あるいは'{'と'}'で囲まれた範囲である。
'{' ... '}'型のcommentを入れ子にする事は出来ない。

***space
****#en
	space = [\t\n ]

<space> is a tab, a space character, or a line feed.
****#ja space(空白)
	space = [\t\n ]

spaceはタブ、空白文字、改行である。

**Constant
***#en
A constant is a unique object that represents a value in the notation itself.
All are objects of the corresponding type, but are statically initialized and not created at runtime.

nil, true, false are global objects, not constants.
***#ja 定数
定数は、表記自体で値を示すユニークなオブジェクトである。
何れも対応する型のオブジェクトであるが、静的に初期化され実行時には生成されない。

nil, true, falseは定数ではなくグローバルオブジェクトである。

***number
****#en
	number = integer | float
	
The <number> token is only a positive number.
Negative numbers are defined on the syntax rule side.
****#ja number(数値)
	number = integer | float

numberとして示される数値は正の数のみである。
負数は構文規則側で定義する。

****integer
*****#en
	integer = (digit+ 'x')? [0-9a-z]+
	digit = [0-9]

<integer> represents an integer value and is an instance of Integer.

For integers, you can specify the radix by prefixing the number + 'x'.
The radix can be set up to 36. 
However, if 0 is specified as an exception, it is assumed that 16 is specified.

Notation exceeding 64 bit unsigned integer will result in an error.
*****#ja integer(整数)
	integer = (digit+ 'x')? [0-9a-z]+
	digit = [0-9]

integerは整数値を表し、Integerのインスタンスとなる。

整数では数+'x'を前置する事で基数を指定出来る。
基数は36まで設定可能だが、例外として0を指定すると16が指定されたものと見做す。

64bit符号無し整数を越える表記はエラーとなる。

****float
*****#en
	float = digit+ '.' digit+ ('e' '-'? digit+)?

<float> is a double-precision floating-point number and is an instance of Float.
*****#ja float(浮動小数点数)
	float = digit+ '.' digit+ ('e' '-'? digit+)?

floatは倍精度浮動小数点数値で、Floatのインスタンスとなる。

***char (character)
****#en
	char = '\'' (escapeSequence | [~']) '\''
	hexDigit = digit | [a-f]
	escapeSequence = '\\' ([~cx] | 'c' [@a-z\[-_] | 'x' hexDigit hexDigit)

<char> represents one character and can be a character represented by 1 byte (Char instance) or a multi-byte character (WideChar instance).

The character code set is SJIS or UTF-8, which is defined when the system is built.
In any case, the lower 7 bits are ASCII.

Characters beginning with '\' are escape sequences, which in principle indicate the following characters themselves, and are used when using '\' itself or quotation marks.
Each of the following characters represents an ASCII control character.

	\a	07	BEL	Bell
	\b	08	BS	Backspace
	\e	1b	ESC	Escape
	\f	0c	FF	Form feed
	\n	0a	LF	Line feed
	\r	0d	CR	Carriage return
	\t	09	HT	Horizontal tab
	\v	0b	VT	Vertical tab
	
Represents a byte character indicated by two hexadecimal characters following '\x'.

Control characters are indicated by specifying '\c' followed by an alphabet and any of '@', '[', '\', ']', '^', '_'.
****#ja char(文字)
	char = '\'' (escapeSequence | [~']) '\''
	hexDigit = digit | [a-f]
	escapeSequence = '\\' ([~cx] | 'c' [@a-z\[-_] | 'x' hexDigit hexDigit)

charは一つの文字を表し、1バイトで表される文字(Charのインスタンス)か、マルチバイト文字(WideCharのインスタンス)となる。

文字のコードセットはSJISもしくはUTF-8で、システム構築時に定義される。
何れにせよ下位7bitはASCIIとなる。

'\'で始まる文字はエスケープシーケンスで、原則として後続の文字自体を示し、'\'そのものや引用符を使用する場合に用いる。
次の文字はそれぞれASCIIの制御文字を示す。

	\a	07	BEL	ベル
	\b	08	BS	バックスペース
	\e	1b	ESC	エスケープ
	\f	0c	FF	改頁
	\n	0a	LF	改行
	\r	0d	CR	復帰
	\t	09	HT	水平タブ
	\v	0b	VT 	垂直タブ

'\x'に続けて16進数2文字で示されるバイトの文字を表す。

'\c'に続けてアルファベット及び'@', '[', '\', ']', '^', '_'の何れかを指定する事で制御文字を示す。

***string
****#en
	string = '"' (escapeSequence | [~"])* '"'

<string> is a string of any length (including 0) and is an instance of String.
****#ja string(文字列)
	string = '"' (escapeSequence | [~"])* '"'

stringは任意の(0を含む)長さの文字列でStringのインスタンスである。

***symbol
****#en
	symbol = '#' [a-zA-Z_0-9?.:$%&*+/<=>@\^|~-\m]+
	
<symbol> is an instance of Symbol.
Since there is only one element with the same name in the system, it is used for identification and enumeration of global objects and messages.
****#ja symbol(シンボル)
	symbol = '#' [a-zA-Z_0-9?.:$%&*+/<=>@\^|~-\m]+

symbolはSymbolのインスタンスである。
名前で特徴付けられ、システム中で同名の要素は一つだけ存在する為、グローバルオブジェクトやメッセージの識別、列挙等に用いられる。

**identifier
***#en
	identifier = [a-zA-Z_][a-zA-Z_0-9?.]*
	
<identifier> is used for global object names, variable names, and unary messages.
***#ja identifier(識別子)
	identifier = [a-zA-Z_][a-zA-Z_0-9?.]*

identifierはグローバルオブジェクト名、変数名、単項メッセージに用いられる。

**Selector
***#en
A selector is a component of a message and is used to uniquely determine a method.
***#ja セレクタ
セレクタはメッセージの構成要素で、メソッドを一意に決定するのに用いる。

***unarySelector
****#en
	unarySelector = identifier

A <unarySelector> is simply an identifier and becomes a unary message.
****#ja unarySelector(単項セレクタ)
	unarySelector = identifier

unarySelectorは単なる識別子で、単項メッセージとなる。

***binarySelector
****#en
	binarySelector = [%&*+/<=>@\^|~-]+

<binarySelector> is a sequence of symbolic characters used for binary messages.

As an exception, '->' is used for assignment statements and '--' is used for comments, so operators with the same name cannot be used.
****#ja binarySelector(二項セレクタ)
	binarySelector = [%&*+/<=>@\^|~-]+

binarySelectorは記号文字の並びで二項メッセージに用いる。

例外として、'->'は代入文に、'--'はコメントに用いる為、同名の演算子は使用出来ない。

***keywordSelector
****#en
	keywordSelector = identifier ':'

<keywordSelector> is an identifier with ':' appended and is used for keyword messages.
****#ja keywordSelector(キーワードセレクタ)
	keywordSelector = identifier ':'

keywordSelectorはidentifierに':'を付けたもので、キーワードメッセージに用いる。

**primitive
***#en
	primitive = '$' identifier

<primitive> is used to specify a primitive.
Normally not used.
***#ja primitive(プリミティブ)
	primitive = '$' identifier

primitiveはプリミティブの指定に用いる。
通常は使用しない。

*Syntax rules
**#ja 構文規則
**method
***#en
	method = class '>>' signature primitive? statement
	signature = unarySignature | binarySignature | keywordSignature
	unarySignature = unarySelector
	binarySignature = binarySelector variable
	keywordSignature = (keywordSelector variable)+
	class = identifier
	variable = identifier

The <method> defines a method corresponding to the <signature> of the <class> class as a <statement>

The <signature> specifies the message format, selector, and formal parameters.

In the method for which <primitive> is specified, the specified primitive is executed first, and <statement> is executed when the primitive fails.

See also 'Module file' for the actual program file notation.
***#ja method(メソッド定義)
	method = class '>>' signature primitive? statement
	signature = unarySignature | binarySignature | keywordSignature
	unarySignature = unarySelector
	binarySignature = binarySelector variable
	keywordSignature = (keywordSelector variable)+
	class = identifier
	variable = identifier

methodはクラスclassのsignatureに対応するメソッドをstatementとして定義する。

signatureではメッセージの形式、セレクタ、仮引数を指定する。

primitiveが指定されているメソッドでは、まず指定のプリミティブを実行し、失敗した場合にこのstatementを実行する。

実際のプログラムファイル上の表記は「モジュールファイル」についても参照せよ。

**statement
***#en
	statement = expression (';' expression)* '!'?
	
<statement> is a sequence of <expressions> separated by ';'.

Expressions are evaluated sequentially from the left.
If the statement ends with '! the method terminates with the value of the last expression as the return value of the method.
Otherwise, self is the return value.
***#ja statement(文)
	statement = expression (';' expression)* '!'?

statementは';'で区切られた式の列である。

式は左から順に評価される。
statementが'!'で終わる場合、最後の式の値をメソッドの返り値としてメソッドを終了する。
そうでない場合はselfが返り値となる。

**expression
***#en
	expression = keywordExpression (cascade | assign)*
	keywordExpression = binaryExpression keywordMessage?
	keywordMessage = (keywordSelector binaryExpression)+
	binaryExpression = unaryExpression binaryMessage*
	binaryMessage = binarySelector unaryExpression
	unaryExpression = factor unaryMessage*
	unaryMessage = unarySelector
	
An <expression> is a description for sending a message to an object or setting a value for a variable.

It consists of a factor that is a receiver, a unary message, a binary message, a keyword message, a cascade, and an assignment expression, and has a priority in this order.
Descriptions with the same priority are evaluated from left to right.
'()' is used to change the priority of calculation.
***#ja expression(式)
	expression = keywordExpression (cascade | assign)*
	keywordExpression = binaryExpression keywordMessage?
	keywordMessage = (keywordSelector binaryExpression)+
	binaryExpression = unaryExpression binaryMessage*
	binaryMessage = binarySelector unaryExpression
	unaryExpression = factor unaryMessage*
	unaryMessage = unarySelector

式はオブジェクトに何らかのメッセージを送ったり変数に値を設定する為の記述である。

レシーバーとなる項と単項メッセージ、二項メッセージ、キーワードメッセージ、カスケード、代入式から成り、この順の優先順位を持つ。
同じ優先順位の記述は左から右へ評価される。
演算の優先順位を変える場合は()を用いる。

***cascade
****#en
	cascade = ',' cascadeMessage
	cascade = ',' (unaryMessage+ binaryMessage* keywordMessage? 
		| binaryMessage+ keywordMessage? | keywordMessage)

Cascade continues to send messages for the value of the left-hand side of ','.
You can send a high priority message to the result of a low priority expression without using parentheses.
****#ja cascade(カスケード)
	cascade = ',' (unaryMessage+ binaryMessage* keywordMessage? 
		| binaryMessage+ keywordMessage? | keywordMessage)
	
カスケードは','の左辺式の値に対し続けてメッセージを送信する。
括弧を用いずに低優先度の式の結果に高優先度のメッセージを送信する事が出来る。

***assign
****#en
	assign = '->' ':'? variable

The assignment expression assigns the value on the left side of '->' to variable.
If ':' is prepended to the variable name, a new local variable is defined.

An assignment expression has a value, and you can then write an assignment expression for a cascade or another variable.
****#ja assign(代入式)
	assign = '->' ':'? variable

代入式は'->'の左辺の値をvariableに代入する。
変数名の前に':'が前置された場合は新たなローカル変数を定義する。

代入式は値を持ち、続けてカスケードや別の変数への代入式を記述出来る。

**factor
***#en
	factor = variable | '(' expression ')' | block | literal
	literal = global | fixedArray | fixedByteArray | '-'? number | char | string
	global = identifier

<factor> consists of a variable reference, an expression with parentheses, block, and literal.

Parenthesized expressions are evaluated first.

In <literal>, global object references, fixed arrays, positive and negative numbers, characters, character strings and symbols can be described.
***#ja factor(項)
	factor = variable | '(' expression ')' | block | literal
	literal = global | fixedArray | fixedByteArray | '-'? number | char | string | symbol
	global = identifier

factorは変数参照、括弧付きの式、block、literalからなる。

括弧付きの式は先に評価される。

literalにはグローバルオブジェクト参照、固定配列、正負の数値、文字、文字列、シンボルが記述出来る。

***fixedArray
****#en
	fixedArray = '#(' literal* ')'
	
<fixedArray> is an instance of FixedArray whose literal is an element in '()'.
The contents of the array must not be manipulated at runtime.

****#ja fixedArray(固定配列)
	fixedArray = '#(' literal* ')'
	
固定配列は'()'内のliteralを要素とするFixedArrayのインスタンスである。
実行時に配列の内容を操作してはならない。

***fixedByteArray
****#en
fixedByteArray = '#[' integer* ']'

<fixedByteArray> is an instance of FixedByteArray whose elements are the values in '[]'.
The value must be in the range 0..255.
The contents of the array must not be manipulated at runtime.

****#ja fixedByteArray(固定バイト配列)
	fixedByteArray = '#[' integer* ']'

固定バイト配列は'[]'内の値を要素とするFixedByteArrayのインスタンスである。
数値は0..255の範囲でなくてはならない。
実行時に配列の内容を操作してはならない。

***block
****#en
	block = '[' (':' variable)* statement ']'
	
<block> generates a block (an instance of Block) that executes the <statement> with <variable> as an argument at the time of execution.

When evaluating a block, you can use the environment of the method from the <statement> self, instance variables, method variables.
Since the block argument is a method variable, the value of the block argument specified at the time of evaluation can be referred to anywhere in the method.

If '!' is attached to the last expression of <statement>, the value itself is returned and the method itself is terminated.
At this time, the block may be evaluated by another method called from the method describing the block (global escape).
An error occurs if the method has already been executed.

If '!' Is not attached, the value of the last expression is returned as the return value to the block evaluation side.
****#ja block(ブロック)
	block = '[' (':' variable)* statement ']'

blockはvariableを引数としstatementを実行するブロック(Blockのインスタンス)を実行時に生成する。

ブロックを評価する際、statementからメソッドの環境、即ちself、インスタンス変数、メソッド変数を使用出来る。
ブロック引数はメソッド変数なので、評価時に指定されたブロック引数の値はメソッド内の任意の箇所で参照出来る。

statementの最後の式に'!'が付いている場合は、その値を返り値としてメソッド自体を終了する。
この時、blockを評価するのはブロックを記述したメソッドから呼び出される他のメソッドであっても良い(大域脱出)。
メソッドの実行が既に終了している場合は、エラーとなる。

'!'が付いていない場合は、最後の式の値を返り値としてブロックの評価側へ返す。

*Module file
**#en
The module file is the source code file format of the Mulk program, and class definitions, method definitions, documents, unit tests, etc. corresponding to a certain function (module) are described in one file.

The base name of the file becomes the module name, and 'm' is added as an extension.

To load a module file, use
	Mulk.class >> load: fn
	Mulk.class >> loadFile: file

When reading a module file placed in the system directory (Mulk.systemDirectory or Mulk.systemOverlayDirectory), also use
	Mulk.class >> import: module
	Mulk.class >> at: symbol in: module

The entire file is in outline format, and the sections are processed as follows according to the outline line. 

Sections that do not fit any of the following are ignored during reading, but tools such as 'man' and 'unittest' generate manuals and tests from these sections as needed.

See the manual topic 'ol' for outline format.
**#ja モジュールファイル
モジュールファイルはMulkプログラムのソースコードのファイル形式で、ある機能(モジュール)に対応するクラス定義やメソッド定義、ドキュメント、ユニットテスト等を一つのファイルにまとめて記述する。

ファイルのベース名がモジュール名となり、拡張子としてmを付加する。

モジュールファイルを読み込むには、以下のメソッドを用いる。
	Mulk.class >> load: fn
	Mulk.class >> loadFile: file

システムディレクトリ(Mulk.systemDirectory又はMulk.systemOverlayDirectory)に置かれたモジュールファイルは、以下のメソッドでも読み込みが行える。
	Mulk.class >> import: module
	Mulk.class >> at: symbol in: module

ファイル全体はアウトライン形式で、アウトライン行によって下位の区画をそれぞれ以下のように処理する。

以下の何れにもあてはまらない区画は読み込み時には無視されるが、man, unittestといったツールは必要に応じてこれらの区画からマニュアルやテストを生成する。

アウトライン形式についてはマニュアルトピックolを参照の事。

**Evaluation
***#en
A section whose outline line ends with '@'.
Evaluate the contents of the parcel as a <statement>.

The variable reader that can be referenced at the time of evaluation is an instance of OutlineReader and is positioned at the beginning of the next section.
When reading from now on, a part of the module file can be used for any purpose.
***#ja 評価
アウトライン行の末尾が'@'の区画。
区画の内容をstatementとして評価する。

評価時に参照できる変数readerはOutlineReaderのインスタンスで、次の区画の先頭に位置付けられている。
これから読み込みを行うとモジュールファイルの一部の区画を任意の用途に使用出来る。

**Method definitions
***#en
The outline line contains '>>'.
Read the outline line and its entire section as <method>.
***#ja メソッド定義
アウトライン行に' >> 'が含まれるもの。
アウトライン行とその区画全体をmethodとして読み込む。

**Condition description
***#en
The outline line ends with '>'.
Evaluates the contents of the outline line, and if the result is true, reads the lower section.
Skip if false.
***#ja 条件記述
アウトライン行の末尾が'>'のもの。
アウトライン行の内容を評価し、結果がtrueなら下位の区画を読み込む。
falseならスキップする。

**Language dependent part
***#en
The outline line starts with '#'.
If the next two characters (language code) match Mulk.lang, read the lower section.
If they do not match, skip them.
***#ja 言語依存部
アウトライン行の先頭が'#'のもの。
次の2文字(言語コード)がMulk.langと一致した場合、下位の区画を読み込む。
不一致ならスキップする。

**Tool dependent part
***#en
Outline line starts with '['.
In a section reserved for manuals and unit tests, the loader skips lower sections.
***#ja ツール依存部
アウトライン行の先頭が'['のもの。
マニュアルやユニットテストに予約されている区画で、ローダは下位の区画をスキップする。

**Text block
***#en
The outline line starts with '->name'.
Save the contents of the lower section as a string in the Mulk dictionary with the name symbol.
***#ja テキストブロック
アウトライン行の先頭が'->名称'のもの。
下位セクションの内容を文字列としてMulk辞書に名称シンボルで保存する。
