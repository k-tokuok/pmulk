regular expression (RegExp class)
$Id: mulk regexp.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 正規表現 (RegExp class)

*[man]
**#en
.caption DESCRIPTION
Compile and match regular expressions.
.hierarchy RegExp.Elt
Compiled regular expressions can be stored in objects and matched arbitrarily.

The supported metacharacters are:

	^ -- Line head.
	$ -- Line tail.
	? -- Any single character.
	[...] -- Any one character included in the group. The first character ~ matches the character not included in the group. It corresponds to the character from x to y by x-y.
	@d -- Matches a digit.
	@n -- Matches non-ASCII characters.
	\ -- Escape character It corresponds to the Mulk standard escape sequence, and is used to directly describe metacharacters.
	x* -- Match the regular expression x corresponding to one character as much as possible.
	(x|y...) -- Try matching any regular expressions x, y ... in order.
	~x -- If it matches the regular expression x at the specified position, the whole match will fail regardless of the following.
	# -- Mark. You can refer to the matching position with matchMarkPosAt:.

Multi-byte characters can be used except for groups.
'?' matches a single multi-byte character.

.right
Eine Sprache, ein Regularer Ausdruck, ein Architekt.

**#ja
.caption 説明
正規表現をコンパイルし、マッチングする。
.hierarchy RegExp
コンパイルした正規表現はオブジェクト中に保持し、任意にマッチング出来る。

サポートするメタ文字は以下の通り。

	^ -- 行頭。
	$ -- 行末。
	? -- 任意の一文字。
	[...] -- グループに含まれる任意の1文字。先頭の~でクループに含まれない文字にマッチする。x-yでxからyまでの文字に対応。
	@d -- 数字にマッチする。
	@n -- 非ASCII文字にマッチする。
	@z -- 対応するASCII文字のある全角文字にマッチする。
	@o -- 旧字体の文字にマッチする。
	\ -- エスケープ文字。Mulk標準のエスケープシーケンスに対応する他、メタ文字を直接記述するのに用いる。
	x* -- 一文字に対応する正規表現xを可能な限りマッチさせる。
	(x|y...) -- 任意の正規表現x, y...のマッチを順に試みる。
	~x -- 指定位置で正規表現xにマッチした場合、後続に関わらずマッチ全体を失敗させる。
	# -- マーク。マッチした位置をmatchMarkPosAt:で参照出来る。

グループ以外であればマルチバイト文字を使用出来る。
?は一文字のマルチバイト文字にマッチする。
.caption 関連項目
.summary oldchars

.right
Eine Sprache, ein Regularer Ausdruck, ein Architekt.

*elements.
**RegExp.Elt class.@
	Object addSubclass: #RegExp.Elt instanceVars: "re next"
***RegExp.Elt >> init: reArg
	reArg ->re
***RegExp.Elt >> next: nextArg
	nextArg ->next
***RegExp.Elt >> next
	next!
***RegExp.Elt >> determin?
	false!

**RegExp.DeterminElt class.@
	RegExp.Elt addSubclass: #RegExp.DeterminElt
***RegExp.DeterminElt >> determin?
	true!

**RegExp.FirstElt class.@
	RegExp.DeterminElt addSubclass: #RegExp.FirstElt
***RegExp.FirstElt >> match
	re pos = 0!
****[test.m]
	RegExp new compile: "^" ->:re;
	self assert: (re match: "");
	RegExp new compile: "a^" ->re;
	self assert: (re match: "a") not
	
**Regexp.LastElt class.@
	RegExp.DeterminElt addSubclass: #RegExp.LastElt
***RegExp.LastElt >> match
	re fetch nil?!
****[test.m]
	RegExp new compile: "$" ->:re;
	self assert: (re match: "");
	RegExp new compile: "$a" ->re;
	self assert: (re match: "a") not

**Regexp.MarkElt class.@
	RegExp.DeterminElt addSubclass: #RegExp.MarkElt instanceVars: "pos"
***RegExp.MarkElt >> match
	re pos ->pos;
	true!
****[test.m]
	RegExp new compile: "a*#" ->:re;
	self assert: (re match: "aaa");
	self assert: (re matchMarkPosAt: 0) = 3
	
***RegExp.MarkElt >> pos
	pos!
	
**RegExp.SteppingElt class.@
	RegExp.DeterminElt addSubclass: #RegExp.SteppingElt
***RegExp.SteppingElt >> stepIfSatisfied: b
	b ifTrue: [re step];
	b!
	
**RegExp.AnyCharElt class.@
	RegExp.SteppingElt addSubclass: #RegExp.AnyCharElt
***RegExp.AnyCharElt >> match
	self stepIfSatisfied: re fetch notNil?!
****[test.m]
	RegExp new compile: "?" ->:re;
	self assert: (re match: "a");
	self assert: (re match: "") not
	
**RegExp.CharElt class.@
	RegExp.SteppingElt addSubclass: #RegExp.CharElt instanceVars: "ch"
***RegExp.CharElt >> ch: chArg
	chArg ->ch
***RegExp.CharElt >> match
	self stepIfSatisfied: re fetch = ch!
****[test.m]
	RegExp new compile: "a" ->:re;
	self assert: (re match: "a");
	self assert: (re match: "A") not

**RegExp.CaseInsensitiveCharElt class.@
	RegExp.SteppingElt addSubclass: #RegExp.CaseInsensitiveCharElt
		instanceVars: "lower upper"
***RegExp.CaseInsensitiveCharElt >> ch: chArg
	chArg ->lower;
	chArg upper ->upper
***RegExp.CaseInsensitiveCharElt >> match
	re fetch ->:ch;
	self stepIfSatisfied: (ch = lower or: [ch = upper])!
****[test.m]
	RegExp new caseInsensitive compile: "a" ->:re;
	self assert: (re match: "a");
	self assert: (re match: "A");
	self assert: (re match: "b") not
	
**RegExp.CharGroupElt class.@
	RegExp.SteppingElt addSubclass: #RegExp.CharGroupElt instanceVars: "set"
***RegExp.CharGroupElt >> set: setArg
	setArg ->set
***RegExp.CharGroupElt >> match
	self stepIfSatisfied: (set includes?: re fetch)!
****[test.m]
	RegExp new compile: "[bd]" ->:re;
	self assert: (re match: "a") not;
	self assert: (re match: "b");
	self assert: (re match: "c") not;
	self assert: (re match: "d");
	self assert: (re match: "e") not
****[test.m] range
	RegExp new compile: "[b-d]" ->:re;
	self assert: (re match: "a") not;
	self assert: (re match: "b");
	self assert: (re match: "c");
	self assert: (re match: "d");
	self assert: (re match: "e") not
****[test.m] caseInsensitive
	RegExp new caseInsensitive compile: "[bd]" ->:re;
	self assert: (re match: "A") not;
	self assert: (re match: "b");
	self assert: (re match: "c") not;
	self assert: (re match: "D");
	self assert: (re match: "e") not
****[test.m] caseInsensitiveRange
	RegExp new caseInsensitive compile: "[b-d]" ->:re;
	self assert: (re match: "A") not;
	self assert: (re match: "b");
	self assert: (re match: "c");
	self assert: (re match: "D");
	self assert: (re match: "e") not

**RegExp.ExcludeCharGroupElt class.@
	RegExp.CharGroupElt addSubclass: #RegExp.ExcludeCharGroupElt
***RegExp.ExcludeCharGroupElt >> match
	self stepIfSatisfied:
		(re fetch ->:ch, notNil? and: [set includes?: ch, not])!
****[test.m]
	RegExp new compile: "[~bd]" ->:re;
	self assert: (re match: "a");
	self assert: (re match: "b") not;
	self assert: (re match: "c");
	self assert: (re match: "d") not;
	self assert: (re match: "e")
****[test.m] range
	RegExp new compile: "[~b-d]" ->:re;
	self assert: (re match: "a");
	self assert: (re match: "b") not;
	self assert: (re match: "c") not;
	self assert: (re match: "d") not;
	self assert: (re match: "e")
****[test.m] caseInsensitive
	RegExp new caseInsensitive compile: "[~bd]" ->:re;
	self assert: (re match: "A");
	self assert: (re match: "b") not;
	self assert: (re match: "c");
	self assert: (re match: "D") not;
	self assert: (re match: "e") 
****[test.m] caseInsensitiveRange
	RegExp new caseInsensitive compile: "[~b-d]" ->:re;
	self assert: (re match: "A");
	self assert: (re match: "b") not;
	self assert: (re match: "c") not;
	self assert: (re match: "D") not;
	self assert: (re match: "e")

**RegExp.SelectElt class.@
	RegExp.Elt addSubclass: #RegExp.SelectElt instanceVars: "alternatives"
***RegExp.SelectElt >> init
	Array new ->alternatives
***RegExp.SelectElt >> add: e
	alternatives addLast: e
***RegExp.SelectElt >> next: nextArg
	alternatives size timesDo:
		[:i
		alternatives at: i ->:e, nil?
			ifTrue: [alternatives at: i put: nextArg]
			ifFalse:
				[[e next notNil?] whileTrue: [e next ->e];
				e next: nextArg]]
***RegExp.SelectElt >> match
	re pos ->:p;
	alternatives do:
		[:elt
		re matchElt: elt from: p, ifTrue: [true!]];
	false!
****[test.m]
	RegExp new compile: "(ab|cd)" ->:re;
	self assert: (re match: "ab");
	self assert: (re match: "cd");
	self assert: (re match: "ef") not
****[test.m] 2
	RegExp new compile: "(a*|b*)" ->:re;
	self assert: (re match: "aaa") & (re matchEndPos = 3);
	self assert: (re match: "bbb") & (re matchEndPos = 0)
	
**RegExp.ClosureElt class.@
	RegExp.Elt addSubclass: #RegExp.ClosureElt instanceVars: "elt"
***RegExp.ClosureElt >> elt: eltArg
	self assert: (eltArg kindOf?: RegExp.SteppingElt);
	eltArg ->elt
***RegExp.ClosureElt >> match
	Array new ->:poses;
	[poses addLast: re pos;
	elt match] whileTrue;
	poses addLast: re pos;
	poses reverse anySatisfy?: [:p re matchElt: next from: p]!
****[test.m]
	RegExp new compile: "^a*$" ->:re;
	self assert: (re match: "");
	self assert: (re match: "a");
	self assert: (re match: "aa");
	self assert: (re match: "aab") not
	
**RegExp.NotElt class.@
	RegExp.DeterminElt addSubclass: #RegExp.NotElt instanceVars: "elt"
***RegExp.NotElt >> elt: eltArg
	eltArg ->elt
***RegExp.NotElt >> match
	re pos ->:pos;
	re matchElt: elt from: pos, not ->:result, ifTrue: [re pos: pos];
	result!
****[test.m]
	RegExp new compile: "^~b?*$" ->:re;
	self assert: (re match: "");
	self assert: (re match: "a");
	self assert: (re match: "ab");
	self assert: (re match: "b") not;
	self assert: (re match: "bc") not
****[test.m] 2
	RegExp new compile: "^~(abc)d$" ->:re;
	self assert: (re match: "d");
	--require backtrack for match abc failed.
	self assert: (re match: "ad") not;
	self assert: (re match: "abd") not

*RegExp class.@
	Object addSubclass: #RegExp instanceVars:
		"reader sequence topElt pos target targetSize matchStartPos matchEndPos"
		+ " caseInsensitive? ascii? marks"

**RegExp >> init
	false ->caseInsensitive?;
	false ->ascii?;
	Array new ->marks
	
**compile.
***RegExp >> addElt: class
	class new init: self ->:e;
	sequence addLast: e;
	e!
***RegExp >> parseSelect
	reader skipChar;
	self addElt: RegExp.SelectElt ->:se;
	sequence ->:savedSequence;
	se add: self parseSequence;
	[reader nextChar = '|'] whileTrue:
		[reader skipChar;
		se add: self parseSequence];
	self assert: reader skipChar = ')';
	savedSequence ->sequence
***RegExp >> addChar: ch toSet: set
	caseInsensitive? and: [ch lower?], ifTrue: [set add: ch upper];
	set add: ch
***RegExp >> parseGroup
	reader skipChar;
	RegExp.CharGroupElt ->:class;
	reader nextChar = '~' ifTrue:
		[reader skipChar;
		RegExp.ExcludeCharGroupElt ->class];
	Set new ->:set;
	[reader nextChar <> ']'] whileTrue:
		[reader skipWideEscapeChar ->:ch;
		reader nextChar = '-',
			ifTrue:
				[reader skipChar;
				ch code to: reader skipWideEscapeChar code, do:
					[:code self addChar: code asWideChar toSet: set]]
			ifFalse: [self addChar: ch toSet: set]];
	reader skipChar;
	self addElt: class, set: set

***RegExp >> groupAliasEn: chArg
	chArg = 'd' ifTrue: ["[0-9]"!];
	chArg = 'n' ifTrue: ["[~ \t!-~]"!];
	self error: "undefined @" + chArg
	
***#en
****RegExp >> groupAlias: chArg
	self groupAliasEn: chArg!
***#ja
****RegExp >> groupAlias: chArg
	chArg = 'z' ifTrue:
		["[　！”＃＄％＆’（）＊＋，−．／０-９：；＜＝＞？＠Ａ-Ｚ［￥］＾＿｀ａ-ｚ｛｜｝〜]"!];
	chArg = 'o' ifTrue: 
		["[" + (Mulk at: #OldChars in: "oldchars", oldstr) + ']'!];
	self groupAliasEn: chArg!
	
***RegExp >> parseNot
	reader skipChar;
	self addElt: RegExp.NotElt ->:e;
	sequence ->:savedSequence;
	Array new ->sequence;
	self parseOne;
	e elt: sequence first;
	savedSequence ->sequence
***RegExp >> parseOne
	reader nextChar ->:ch;
	ch mblead? ifTrue: [self addElt: RegExp.CharElt, ch: reader skipWideChar!];
	ch = '?' ifTrue:
		[reader skipChar;
		self addElt: RegExp.AnyCharElt!];
	ch = '^' ifTrue:
		[reader skipChar;
		self addElt: RegExp.FirstElt!];
	ch = '$' ifTrue:
		[reader skipChar;
		self addElt: RegExp.LastElt!];
	ch = '*' ifTrue:
		[reader skipChar;
		sequence last ->:e;
		sequence removeLast;
		self addElt: RegExp.ClosureElt, elt: e!];
	ch = '(' ifTrue: [self parseSelect!];
	ch = '[' ifTrue: [self parseGroup!];
	ch = '@' ifTrue: 
		[reader skipChar;
		self groupAlias: reader skipChar ->:g;
		reader ->:saved;
		AheadReader new init: g ->reader;
		self parseOne;
		saved ->reader!];
	ch = '~' ifTrue: [self parseNot!];
	ch = '#' ifTrue:
		[reader skipChar;
		marks addLast: (self addElt: RegExp.MarkElt)!];
		
	caseInsensitive? and: [ch lower?],
		ifTrue: [self addElt: RegExp.CaseInsensitiveCharElt]
		ifFalse: [self addElt: RegExp.CharElt],
		ch: reader skipWideEscapeChar
***RegExp >> parseSequence
	Array new ->sequence;
	[reader nextChar ->:ch, nil? | (ch = '|') | (ch = ')')] whileFalse:
		[self parseOne];
	sequence empty?
		ifTrue: [nil]
		ifFalse:
			[sequence first ->:p;
			1 until: sequence size, do:
				[:i
				sequence at: i ->:n;
				p next: n;
				n ->p];
			sequence first]!

**match.
***access from elt.
****RegExp >> fetch
	pos = targetSize ifTrue: [nil!];
	target at: pos ->:result;
	ascii? or: [result trailSize ->:ts, = 0], ifTrue: [result!];
	result code ->:code;
	ts timesDo:
		[:off
		code << 8 + (target basicAt: pos + off + 1) ->code];
	code asWideChar!
****RegExp >> step
	ascii? ifFalse: [pos + (target at: pos) trailSize ->pos];
	pos + 1 ->pos
****RegExp >> pos
	pos!
****RegExp >> pos: posArg
	posArg ->pos
	
***RegExp >> matchElt: elt from: tp
	tp ->pos;
	[elt notNil?] whileTrue:
		[elt determin?
			ifTrue:
				[elt match ifFalse: [false!];
				elt next ->elt]
			ifFalse: [elt match!]];
	true!
***RegExp >> startMatchElt: elt from: st
	st ->matchStartPos;
	self matchElt: elt from: st,
		ifTrue:
			[pos ->matchEndPos;
			true]
		ifFalse: [false]!

**api.
***RegExp >> caseInsensitive
	true ->caseInsensitive?
****[man.m]
*****#en
Match upper case letters to lower case letters in regular expressions.

You need to execute it before calling compile:.
*****#ja
正規表現中の英小文字に対し、大文字もマッチさせる。

compile:を呼ぶ前に実行する必要がある。

***RegExp >> ascii
	true ->ascii?
****[man.m]
*****#en
Matches multibyte characters byte for byte.
*****#ja
マルチバイト文字をバイト単位でマッチする。

***RegExp >> compile: re
	AheadReader new init: re ->reader;
	self parseSequence ->topElt;
	self assert: reader nextChar nil?
****[man.m]
*****#en
Compile regular expression re.

*****#ja
正規表現reをコンパイルする。

***RegExp >> match: targetArg from: st
	targetArg ->target;
	target size ->targetSize;

	topElt memberOf?: RegExp.FirstElt, ifTrue:
		[st = 0
			ifTrue: [self startMatchElt: topElt next from: st]
			ifFalse: [false]!];
			
	[self startMatchElt: topElt from: st, ifTrue: [true!];
	st = targetSize ifTrue: [false!];
	ascii? ifFalse: [st + (target at: st) trailSize ->st];
	st + 1 ->st] loop
****[man.m]
*****#en
Match the regular expression after the st character of targetArg string and return success or failure.

*****#ja
targetArg文字列のst文字目以降を正規表現にマッチし、成否を返す。

***RegExp >> match: targetArg
	self match: targetArg from: 0!
****[man.m]
*****#en
Match the regular expression of targetArg string.

*****#ja
targetArg文字列が正規表現にマッチするか判定する。

***RegExp >> matchStartPos
	matchStartPos!
****[man.m]
*****#en
Returns the start position of the match that has been established.

*****#ja
成立したマッチの先頭位置を返す。

***RegExp >> matchEndPos
	matchEndPos!
****[man.m]
*****#en
Returns the end position of the match that has been established.

*****#ja
成立したマッチの終端位置を返す。

***RegExp >> marksCount
	marks size!
****[man.m]
*****#en
Returns the number of matching marks.
*****#ja
マッチしたマークの数を返す。

***RegExp >> matchMarkPosAt: i
	marks at: i, pos!
****[man.m]
*****#en
Returns the matched position of the i-th mark.

*****#ja
i番目のマークのマッチした位置を返す。
