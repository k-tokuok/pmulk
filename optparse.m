parse command line options (OptionParser class)
$Id: mulk optparse.m 1179 2024-03-17 Sun 21:14:15 kt $
#ja コマンドラインオプションを解釈する (OptionParser class)

*[man]
**#en
.caption DESCRIPTION
A parser class for Unix-like command line options.

.hierarchy OptionParser

Options are command arguments that begin with a '-' character, and each character represents a function.
Therefore, you can specify multiple functions with one argument.

Some options have option arguments, in which case the string following the command argument becomes the option argument.
If there is no following string, the next command argument becomes an option argument.

If a command argument that is not an option or '--' is specified, it is considered that the command line option has been specified, and the subsequent command argument is not considered an option even if it begins with a '-' character.

**#ja
.caption 説明
Unix-likeなコマンドラインオプションのパーサ。

.hierarchy OptionParser

オプションは'-'文字で始まるコマンド引数で、一つの文字で一つの機能を表わす。
従って一つの引数で複数の機能を指定する事が出来る。

オプションはオプション引数を持つものがあり、その場合はコマンド引数の後続の文字列がオプション引数となる。
後続の文字列が無い場合は次のコマンド引数がオプション引数となる。

オプションで無いコマンド引数や'--'が指定されるとコマンドラインオプションの指定が終了したと見做し、その後のコマンド引数は'-'文字で始まっていてもオプションとは見做されない。

*OptionParser class.@
	Object addSubclass: #OptionParser instanceVars: "dict"

**[test] Test.OptionParser class.@
	UnitTest addSubclass: #Test.OptionParser instanceVars: "op"
***Test.OptionParser >> setup
	OptionParser new init: "abc:d:" ->op
***Test.OptionParser >> check: list
	op parse: list first ->:args;
	self assert: args asString = (list at: 1);
	self assert: (op at: 'a') = (list at: 2);
	self assert: (op at: 'b') = (list at: 3);
	self assert: (op at: 'c') = (list at: 4);
	self assert: (op at: 'd') = (list at: 5)

**OptionParser >> init: optionsArg
	Dictionary new ->dict;
	0 ->:i;
	[i < optionsArg size] whileTrue:
		[optionsArg at: i ->:ch;
		i + 1 ->i;
		i < optionsArg size and: [optionsArg at: i, = ':'] ->:arg?, ifTrue:
			[i + 1 ->i];
		--(arg?, value)
		dict at: ch put: (Cons new car: arg?)]
***[man.m]
****#en
Initialize the parser.

Specifies a character string listing option characters to be interpreted as optionsArg.
Options with ':' immediately after the specified character have option arguments.
****#ja
パーサを初期化する。

optionsArgとして解釈するオプション文字群を列挙した文字列を指定する。
指定文字の直後に':'が書かれたオプションはオプション引数を持つ。

**OptionParser >> parseMain: args
	0 ->:i;
	[i < args size] whileTrue:
		[args at: i ->:arg;
		arg first <> '-' ifTrue: [i!];
		i + 1 ->i;
		1 ->:j;
		arg at: j, = '-' ifTrue: [i!];
		[j < arg size] whileTrue:
			[arg at: j ->:ch;
			j + 1 ->j;
			dict at: ch ifAbsent: [self error: "unknown option " + ch] ->:t;
			t cdr notNil? ifTrue: [self error: "duplicate option " + ch];
			t car
				ifTrue:
					[j < arg size
						ifTrue: [t cdr: (arg copyFrom: j)]
						ifFalse:
							[i = args size ifTrue:
								[self error: "missing option arg for " + ch];
							t cdr: (args at: i);
							i + 1 ->i];
					arg size ->j]
				ifFalse: [t cdr: true]]];
	args size!

**OptionParser >> parse: args
	self parseMain: args ->:pos;
	args copyFrom: pos!
***[man.m]
****#en
Parse command arguments args.

The return value is an arguments excluding options.
****#ja
コマンド引数を解釈する。

返り値として、オプションを除いた引数が返される。

**OptionParser >> at: chArg
	dict at: chArg ->:t;
	t car ifTrue: [t cdr] ifFalse: [t cdr = true]!
***[man.m]
****#en
Returns whether or not the option chArg was specified in the command argument.

For options with optional arguments, the optional argument if specified.
Otherwise returns nil.
****#ja
オプションchArgがコマンド引数に指定されていたが否かを返す。

オプション引数を持つオプションの場合は、指定されていればオプション引数を。
さもなくばnilを返す。
***[test.m] 1
	self check: #(#("-a" "-c" "carg" "arg") "arg" true false "carg" nil)
***[test.m] 2
	self check: #(#("-accarg" "arg") "arg" true false "carg" nil)
***[test.m] 3
	self check: #(#("-a" "--" "-b") "-b" true false nil nil)
