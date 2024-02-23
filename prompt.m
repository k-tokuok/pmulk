conversational input (Prompt.class class)
$Id: mulk prompt.m 981 2022-12-20 Tue 22:29:17 kt $
#ja 会話的入力 (Prompt.class class)

*[man]
**#en
.caption DESCRIPTION
Enter any string / number / boolean value interactively.
.hierarchy Prompt.class
The argument p is output to the terminal as a prompt.

Don't construct instances with new, use the global object Prompt.
**#ja
.caption 説明
任意の文字列/数値/論理値を会話的に入力する。
.hierarchy Prompt.class
引数のpはプロンプトとして端末に出力される。

インスタンスをnewで構築せず、グローバルオブジェクトPromptを使用すること。

*Prompt.class class.@
	Object addSubclass: #Prompt.class
**Prompt.class >> getString: p
	Out0 put: p, put: '?';
	In0 getLn ->:result, nil? ifTrue: [self error: "input terminated"];
	result!
***[man.m]
****#en
Enter a string.
****#ja
文字列を入力する。

**Prompt.class >> getString: p satisfy: block
	[self getString: p ->:result;
	block value: result, ifTrue: [result!];
	Out0 putLn: "illegal input"] loop
***[man.m]
****#en
Enter a string.

The input string is passed to block, and if it returns false, it will ask for input again.
****#ja
文字列を入力する。

入力文字列はblockに渡され、これがfalseを返すと再度入力を要求する。

**Prompt.class >> getInteger: p satisfy: block
	self getString: p satisfy:
		[:s
		[s asInteger] on: Error do: [:e nil] ->:result, notNil?
			and: [block value: result]];
	result!
***[man.m]
****#en
Enter an integer.

If the integer value is not input, or if the result of evaluating the block using the input integer value as an argument is false, the input is requested again.
****#ja
整数を入力する。

数値が入力されない、又は入力数値を引数としてblockを評価した結果がfalseなら、再度入力を要求する。

**Prompt.class >> getInteger: p
	self getInteger: p satisfy: [:v true]!
***[man.m]
****#en
Enter an integer.
****#ja
整数を入力する。

**Prompt.class >> getInteger: p between: low and: hi
	self assert: low <= hi;
	self getInteger: p + '(' + low + '-' + hi + ')'
		satisfy: [:i i between: low and: hi]!
***[man.m]
****#en
Enter an integer.

If a integer value is not entered, or if an integer value is not between low and hi, the user is required to enter it again.
****#ja
整数を入力する。

数値が入力されない、又は整数値がlowとhiの間に無い場合は、再度入力を要求する。

**Prompt.class >> getInteger: p between: low until: hi
	self getInteger: p between: low and: hi - 1!
***[man.m]
****#en
Enter an integer.

If a integer value is not input or an integer value is not less than low and less than hi, the user is required to input again.
****#ja
整数を入力する。

数値が入力されない、又は整数値がlow以上hi未満でない場合は、再度入力を要求する。

**Prompt.class >> putOn: writer value: value default?: default?
	default? ifTrue: [writer put: '['];
	writer put: value;
	default? ifTrue: [writer put: ']']
**Prompt.class >> getInteger: p between: low and: hi default: default
	StringWriter new ->:wr;
	wr put: p, put: '(';
	self putOn: wr value: low default?: low = default;
	low <> default & (hi <> default) ifTrue:
		[wr put: '-';
		self putOn: wr value: default default?: true];
	wr put: '-';
	self putOn: wr value: hi default?: hi = default;
	wr put: ')';
	self getString: wr asString satisfy:
		[:s
		s = ""
			ifTrue: [default ->:result; true]
			ifFalse:
				[[s asInteger] on: Error do: [:e nil] ->result, notNil?
					and: [result between: low and: hi]]];
	result!
***[man.m]
****#en
Enter an integer.

If only a line feed is entered, default is returned.
Otherwise, like getInteger:between:and:.
****#ja
整数を入力する。

改行のみ入力した場合はdefaultを返す。
そうでない場合はgetInteger:between:and:と同様。

**Prompt.class >> getInteger: p between: low until: hi default: default
	self getInteger: p between: low and: hi - 1 default: default!
***[man.m]
****#en
Enter an integer.

If only a line feed is entered, default is returned.
Otherwise, like getInteger:between:until:.

****#ja
整数を入力する。

改行のみ入力した場合はdefaultを返す。
そうでない場合はgetInteger:between:until:と同様。

**Prompt.class >> getNumber: p satisfy: block
	self getString: p satisfy:
		[:s
		[s asNumber] on: Error do: [:e nil] ->:result, notNil?
			and: [block value: result]];
	result!
***[man.m]
****#en
Enter a numerical value.

If the numerical value is not input, or if the result of evaluating the block using the input numerical value as an argument is false, the input is requested again.
****#ja
数値を入力する。

数値が入力されない、又は入力数値を引数としてblockを評価した結果がfalseなら、再度入力を要求する。

**Prompt.class >> getNumber: p
	self getNumber: p satisfy: [:v true]!
***[man.m]
****#en
Enter a numerical value.
****#ja
数値を入力する。

**Prompt.class >> parseBoolean: s
	s size <> 0 and: ["y1n0" indexOf: s first ->:code, notNil?],
		ifTrue: [code // 2 = 0]
		ifFalse: [nil]!
**Prompt.class >> getBoolean: p
	self getString: p + "(y,1/n,0)" satisfy:
		[:ans self parseBoolean: ans ->:result, notNil?];
	result!
***[man.m]
****#en
Enter a boolean value.
****#ja
論理値を入力する。

**Prompt.class >> getBoolean: p default: default
	StringWriter new ->:wr;
	wr put: p, put: '(';
	self putOn: wr value: "y,1" default?: default;
	wr put: '/';
	self putOn: wr value: "n,0" default?: default not;
	wr put: ')', asString ->:prompt;
	self getString: prompt satisfy:
		[:ans
		ans = ""
			ifTrue: [default ->:result; true]
			ifFalse: [self parseBoolean: ans ->result, notNil?]];
	result!
***[man.m]
****#en
Enter a logical value.

If only a line feed is entered, default is returned.
Otherwise, like getBoolean:.
****#ja
論理値を入力する。

改行のみ入力した場合はdefaultを返す。
そうでない場合はgetBoolean:と同様。

*@
	Mulk at: #Prompt put: Prompt.class new
