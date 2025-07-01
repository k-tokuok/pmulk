line editor
$Id: mulk ed.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ラインエディタ

*[man]
**#en
.caption SYNOPSIS
	ed [FILE]
.caption DESCRIPTION
Edit a text file by inputting an edit command for each line.

The file to be edited can be specified by the command argument, and the file is read if it exists at startup.

The following is a list of directives written in the meta language of the Mulk language specification (manual topic 'lang').

	RANGE? 'p'? -- Print RANGE
	LOCATION? 'i' -- Insert before LOCATION
	LOCATION? 'a' -- Insert after LOCATION
	RANGE? 'd' 'p'? -- Delete RANGE
	LOCATION? 'r' FILE? -- Insert FILE contents after LOCATION
	RANGE? 'w' FILE? -- Output RANGE to FILE. If RANGE is omitted, the whole target
	RANGE? 's' SEPR REGEXP SEPR DEST SEPR ('r' rch)? 'g'? 'p'?
		-- Replace first REGEXP of RANGE with DEST
		-- SEPR is any single character
		-- If you specify one character RCH with 'r', replace RCH in DEST with REGEXP or the original text corresponding to the range enclosed by the mark in REGEXP
		-- If 'g' is specified, all REGEXP of RANGE will be replaced
	RANGE? 'c' LOCATION 'p'? -- Copy RANGE right after LOCATION
	RANGE? 'm' LOCATION 'p'? -- Move RANGE right after LOCATION
	RANGE? 'j' 'p'? -- Put RANGE into one line
	'!' COMMAND -- Execute COMMAND
	'q' -- Quit ed
	Blank line -- Equivalent to '.+1p'

If RANGE and LOCATION are omitted, it is assumed that the current line ('.') Has been specified.
The current line is positioned at the first line immediately after reading the file, and moves to the last line of the operation by a command.

In the insertion, the line input after the command is inserted as it is.
Enter a line consisting of only '.' to end.

If 'p' is specified, the edited contents will be displayed

If FILE is omitted in 'r' and 'w', it is assumed that the front of the file on the command line is specified.

|
The specification method of RANGE and LOCATION is as follows.

	LOCATION = TOP RELATIVE?
	TOP = LINENO | '.' | '$' | TOPREGEXP
		-- LINENO is the line number starting from 1
		-- '$' is end of line
	TOPREGEXP = '-'? REGEXPSP
		-- Equivalent to RELATIVE, but '.' And '+' can be omitted
	REGEXPSP = '/' REGEXP '/'
		-- The position where the regular expression REGEXP first matches before and after
	RELATIVE = ('+' | '-') (DIFFER | REGEXPSP)
		-- Relative position from TOP
		-- DIFFER is the number of lines to move back and forth
	RANGE = LOCATION ((',' | ';') LOCATION)?
		-- Specify the range between the start and end LOCATION
		-- When delimited by ';', the starting point is interpreted as '.'
		-- If the end point is omitted, the range of the start point is one line
.caption SEE ALSO
.summary regexp

**#ja
.caption 書式
	ed [FILE]
.caption 説明
行単位で編集指令を入力する事でテキストファイルを編集する。

コマンド引数で編集対象のファイルを指定出来、起動時にそのファイルがあれば読み込む。

以下にMulk言語仕様(マニュアルトピックlang)のメタ言語で表記した指令の一覧を示す。
	RANGE? 'p'? -- RANGEを表示
	LOCATION? 'i' -- LOCATIONの前に挿入
	LOCATION? 'a' -- LOCATIONの後に挿入
	RANGE? 'd' 'p'? -- RANGEを削除
	LOCATION? 'r' FILE? -- LOCATIONの後にFILEの内容を挿入
	RANGE? 'w' FILE? -- RANGEをFILEに出力。RANGE省略時は全体が対象
	RANGE? 's' SEPR REGEXP SEPR DEST SEPR ('r' RCH)? 'g'? 'p'? 
		-- RANGEの最初のREGEXPをDESTに置換
		-- SEPRは任意の1文字
		-- 'r'でRCHという1文字を指定するとDEST内のRCHをREGEXPかREGEXP内のマークで囲まれた範囲に対応する元テキストに置換
		-- 'g'を指定するとRANGEの全てのREGEXPを置換
	RANGE? 'c' LOCATION 'p'? -- RANGEをLOCATIONの直後に複製
	RANGE? 'm' LOCATION 'p'? -- RANGEをLOCATIONの直後に移動
	RANGE? 'j' 'p'? -- RANGEを1行にまとめる
	'!' COMMAND -- COMMANDを実行
	'q' -- 終了
	空行 -- '.+1p'と等価

RANGE, LOCATIONを省略した場合はカレント行('.')が指定されたものとみなす。
カレント行はファイル読み込み直後は先頭行に位置付けられ、指令により操作の最終行に移動する。

挿入では指令後に入力する行がそのまま挿入される。
'.'のみの行を入力すると終了する。

'p'を指定すると、編集後の内容を表示する

'r', 'w'でFILEを省略するとコマンド行のファイル前が指定されたものとみなす。
|
RANGE, LOCATIONの指定法は以下の通り。

	LOCATION = TOP RELATIVE?
	TOP = LINENO | '.' | '$' | TOPREGEXP
		--LINENOは1から始まる行番号
		--'$'は行末
	TOPREGEXP = '-'? REGEXPSP
		--RELATIVEでの指定と同等だが'.'や'+'を省略できる
	REGEXPSP = '/' REGEXP '/'
		--正規表現REGEXPが前後に最初にマッチする位置
	RELATIVE = ('+' | '-') (DIFFER | REGEXPSP)
		--TOPからの相対位置
		--DIFFERは前後に移動させる行数
	RANGE = LOCATION ((',' | ';') LOCATION)?
		--始点と終点の間の範囲を指定する
		--';'で区切った場合は始点を'.'としてから解釈する
		--終点を省略した場合は始点の1行を範囲とする
.caption 関連項目
.summary regexp

*ed tool.@
	Mulk import: "regexp";
	Object addSubclass: #Cmd.ed instanceVars:
		"running? text currentPos startPos endPos cmdReader argFn lastRegExp"
**Cmd.ed >> error
	self error: "?"

**command parser.
***Cmd.ed >> pos?
	cmdReader nextChar ->:ch;
	ch digit? or: [ch = '.' ], or: [ch = '$'], or: [ch = '/'], or: [ch = '-']!
***Cmd.ed >> parseOffsetFrom: p forward?: forward?
	cmdReader skipUnsignedInteger timesRepeat:
		[forward? ifTrue: [p next] ifFalse: [p prev] ->p;
		p = text ifTrue: [self error]];
	p = text ifTrue: [self error];
	p!
***Cmd.ed >> parseUntil: sepr escape?: escape?
	cmdReader resetToken;
	[cmdReader nextChar <> sepr] whileTrue:
		[escape? and: [cmdReader nextChar = '\\'], ifTrue: [cmdReader getChar];
		cmdReader nextChar nil? ifTrue: [self error];
		cmdReader getChar];
	cmdReader skipChar;
	cmdReader token!
***Cmd.ed >> parseRegExpUntil: sepr
	sepr = '\\' ifTrue: [self error];
	self parseUntil: sepr escape?: true ->:s;
	s = "" ifTrue:
		[lastRegExp nil? ifTrue: [self error];
		lastRegExp!];
	RegExp new compile: s ->lastRegExp;
	lastRegExp!
***Cmd.ed >> parseRegExpFrom: p forward?: forward?
	cmdReader skipChar <> '/' ifTrue: [self error];
	self parseRegExpUntil: '/' ->:re;

	[forward? ifTrue: [p next] ifFalse: [p prev] ->p;
	p = text ifTrue: [self error];
	re match: p value, ifTrue: [p!]] loop
***Cmd.ed >> parseBase
	cmdReader nextChar ->:ch;
	ch digit? ifTrue: [self parseOffsetFrom: text forward?: true!];
	ch = '.' ifTrue:
		[cmdReader skipChar;
		currentPos!];
	ch = '$' ifTrue:
		[cmdReader skipChar;
		text prev!];
	ch = '/' or: [ch = '-'], ifTrue:
		[ch = '-' ifTrue: [cmdReader skipChar];
		self parseRegExpFrom: currentPos forward?: ch = '/'!];
	self error
***Cmd.ed >> parseRelative: p
	cmdReader skipChar = '+' ->:forward?;
	cmdReader nextChar digit?
		ifTrue: [self parseOffsetFrom: p forward?: forward?]
		ifFalse: [self parseRegExpFrom: p forward?: forward?]!
***Cmd.ed >> parsePos
	self parseBase ->:p;
	[cmdReader nextChar ->:ch, = '+' | (ch = '-')] whileTrue:
		[self parseRelative: p ->p];
	p!	
***Cmd.ed >> parseOption: ch
	cmdReader nextChar = ch ->:result, ifTrue: [cmdReader skipChar];
	result!
***Cmd.ed >> parseEnd
	cmdReader nextChar nil? ifFalse: [self error]
	
**Cmd.ed >> accept2Arg
	startPos nil? ifTrue: [currentPos ->startPos];
	endPos nil? ifTrue: [startPos ->endPos];

	currentPos = text ifTrue:
		[self assert: text empty?!];

	self assert: startPos <> text;
	self assert: endPos <> text;
	
	startPos ->:p;
	[p <> endPos] whileTrue:
		[p = text ifTrue: [self error];
		p next ->p]
**Cmd.ed >> accept1Arg
	endPos notNil? ifTrue: [self error!];
	self accept2Arg
**Cmd.ed >> acceptNoArg
	startPos notNil? ifTrue: [self error!]
**Cmd.ed >> textNotEmpty
	text empty? ifTrue: [self error]
**Cmd.ed >> inputAfter: pos
	[In getLn ->:s;
	s = "." ifTrue: [self!];
	pos addNext: s;
	pos next ->currentPos ->pos] loop
**Cmd.ed >> readFile: f after: p
	f contentLinesDo:
		[:s
		p addNext: s;
		p next ->p];
	p ->currentPos
**Cmd.ed >> rangeDo: block
	startPos ->:p;
	[p <> endPos next] whileTrue:
		[p next ->p;
		block value: p prev]
**Cmd.ed >> removeRange
	self rangeDo: [:p p remove]
**Cmd.ed >> rangePrint
	self rangeDo: [:p Out putLn: p value]

**commands.
***Cmd.ed >> cmd.q
	self parseEnd;
	startPos notNil? ifTrue: [self error];
	false ->running?
***Cmd.ed >> cmd.a
	self parseEnd;
	self accept1Arg;
	startPos ->currentPos;
	self inputAfter: startPos
***Cmd.ed >> cmd.i
	self parseEnd;
	self accept1Arg;
	startPos ->currentPos;
	self inputAfter: startPos prev
***Cmd.ed >> cmd.p
	self parseEnd;
	self textNotEmpty;
	self accept2Arg;
	self rangePrint;
	endPos ->currentPos
***Cmd.ed >> cmd.d
	self parseOption: 'p' ->:p?;
	self parseEnd;
	self textNotEmpty;
	self accept2Arg;
	
	endPos next ->currentPos;
	self removeRange;
	currentPos = text ifTrue: [currentPos prev ->currentPos];
	p? and: [currentPos <> text], ifTrue: [Out putLn: currentPos value]
***Cmd.ed >> cmd.r
	self accept1Arg;
	self readFile: cmdReader getRest asFile after: startPos
***Cmd.ed >> cmd.w
	self textNotEmpty;
	startPos nil? ifTrue:
		[text next ->startPos;
		text prev ->endPos];
	cmdReader getRestIfEnd: [argFn] ->:f;
	f nil? ifTrue: [self error];
	[self rangePrint] pipeTo: f asFile
	
***s command.
****Cmd.ed >> dest: dest fromSource: s re: re rch: rch
	rch nil? ifTrue: [dest!];
	StringWriter new ->:result;
	[dest indexOf: rch ->:pos, notNil?] whileTrue:
		[result put: (dest copyUntil: pos);
		re marksCount = 2 
			ifTrue: 
				[s copyFrom: (re matchMarkPosAt: 0) 
					until: (re matchMarkPosAt: 1)]
			ifFalse: [s copyFrom: re matchStartPos until: re matchEndPos] ->:r;
		result put: r;
		dest copyFrom: pos + 1 ->dest];
	result put: dest;
	result asString!
****Cmd.ed >> replace: s re: re dest: dest rch: rch g?: g?
	StringWriter new ->:result;
	0 ->:st;
	[result put: (s copyFrom: st until: re matchStartPos);
	result put: (self dest: dest fromSource: s re: re rch: rch);
	re matchEndPos ->st;
	g? 
		ifTrue:
			[st = 0 ifTrue: [self error];
			re match: s from: st]
		ifFalse: [false]] whileTrue;
	result put: (s copyFrom: st);
	result asString!
****Cmd.ed >> cmd.s
	self textNotEmpty;
	self accept2Arg;
	cmdReader skipChar ->:sepr;
	self parseRegExpUntil: sepr ->:re;
	self parseUntil: sepr escape?: false ->:dest;
	nil ->:rch;
	self parseOption: 'r', ifTrue:
		[cmdReader nextChar nil? ifTrue: [self error];
		cmdReader skipChar ->rch];
	self parseOption: 'g' ->:g?;
	self parseOption: 'p' ->:p?;
	self parseEnd;
	
	self rangeDo:
		[:p
		p value ->:s;
		re match: s from: 0, ifTrue:
			[self replace: s re: re dest: dest rch: rch g?: g? ->s;
			p? ifTrue: [Out putLn: s];
			p value: s]];
	endPos ->currentPos
***Cmd.ed >> cmd.c
	self textNotEmpty;
	self accept2Arg;
	cmdReader nextChar = '0'
		ifTrue:
			[cmdReader skipChar;
			text ->currentPos]
		ifFalse: [self parsePos ->currentPos];
	self parseOption: 'p' ->:p?;
	self parseEnd;
	startPos ->:pos;
	[pos <> endPos] whileTrue: 
		[pos = currentPos ifTrue: [self error];
		pos next ->pos];
	self rangeDo:
		[:p
		currentPos addNext: p value;
		p? ifTrue: [Out putLn: p value];
		currentPos next ->currentPos]
***Cmd.ed >> cmd.m
	self cmd.c;
	self removeRange
***Cmd.ed >> cmd.j
	self textNotEmpty;
	self accept2Arg;
	self parseOption: 'p' ->:p?;
	self parseEnd;
	startPos prev ->currentPos;
	StringWriter new ->:w;
	self rangeDo: [:p w put: p value];
	self removeRange;
	currentPos addNext: w asString;
	currentPos next ->currentPos;
	p? ifTrue: [Out putLn: currentPos value]
***Cmd.ed >> cmd.cmd
	self acceptNoArg;
	cmdReader getRest runCmd

**Cmd.ed >> execCmd: cmdLine
	AheadReader new init: cmdLine ->cmdReader;
	nil ->startPos ->endPos;
	self pos?
		ifTrue:
			[self parsePos ->startPos;
			cmdReader nextChar ->:ch, = ',' | (ch = ';') ifTrue:
				[ch = ';' ifTrue: [startPos ->currentPos];
				cmdReader skipChar;
				self parsePos ->endPos]];

	cmdReader nextChar ->ch, nil?
		ifTrue: ['p' ->ch]
		ifFalse: [cmdReader skipChar];
	ch = '!' ifTrue: ["cmd" ->ch];
	
	"cmd." + ch, asSymbol ->:cmdSymbol;
	self respondsTo?: cmdSymbol, ifFalse: [self error];
	self perform: cmdSymbol
**Cmd.ed >> main: arg
	Ring new ->text ->currentPos;
	arg size = 1 ifTrue:
		[arg first ->argFn, asFile ->:file, readableFile? ifTrue:
			[self readFile: file after: text;
			text next ->currentPos]];
	true ->running?;
	[running?] whileTrue:
		[In getLn ->:ln, nil?
			ifTrue: [false ->running?]
			ifFalse:
				[ln = "" ifTrue: [".+1p" ->ln];
				[self execCmd: ln] on: Error do: 
					[:ex
					Out putLn: ex message
					-- ex printStackTrace
					]]]
