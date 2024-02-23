text formatting
$Id: mulk format.m 932 2022-09-18 Sun 17:45:15 kt $
#ja テキスト整形

*[man]
**#en
.caption SYNOPSIS
	format
.caption DESCRIPTION
Format the text of the standard input and arrange it.

Normally, the range separated by blank lines is regarded as a paragraph, and packing and prohibition processing are performed.
The following lines each perform an individual action.

	<Space> or a line starting with '|' -- Output the contents of the line as it is. If it starts with '|', exclude '|'.
	*... -- Assign item numbers as outline lines.
	. COMMENT -- Comment. It is also a paragraph break.
	.title TITLE -- Output a title line.
	.id ID -- Output identification information immediately after the title.
	.caption CAPTION -- Output a caption line.
	.cont -- Paragraph continuation. Start without indenting the first line of the following paragraph.
	.eval EXPR -- Evaluate the expression under the Cmd.format object.
	.index -- Generate a table of contents from the outline and insert it. The standard input must be a seekable stream.
	.lineBreak -- Begin on a new line. The line of only '|' is also acceptable.
	.pageBreak -- Begin on a new page.
	.remark [SPEAKER] -- Output the following paragraph as a remarks. If the SPEAKER is omitted, the next line is treated as the speaker name.
	.remarkCont -- Output the following paragraph as the paragraph following the remarks.
	.right [N] -- Output the next N (default 1) lines right-justified.
	.center [N] -- Output the next N (default 1) lines centered.
	.quoteStart -- Start quote section.
	.quoteEnd -- End quote section.
	.item [MARK] -- Output the following paragraph a bullet with the MARK.
	.item2 [MARK] -- Output the following paragraph a second level bullet with the MARK.
	
The following variables can be set with the eval command.
	indentParagraphTop? -- Indent the beginning of a paragraph except for exception handling characters.
	paperWidth -- Maximum number of characters per line.
	remarkNameWidth -- The width of the speaker's name at the time of remark output.
	leftMargin -- Left margin width.
	rightMargin -- Right margin width.
.caption SEE ALSO
.summary ol

**#ja
.caption 書式
	format
.caption 説明
標準入力のテキストを整形し、体裁を整える。

通常は空行で区切られた範囲を段落と見做して詰め込み・禁則処理を行う。
以下の行は、各々個別の動作を行う。
	<空白>または'|'で始まる行 -- 行の内容をそのまま出力する。'|'で始まる場合は'|'を除く。
	*... -- アウトライン行として項番を付ける。
	. コメント -- コメント。段落の区切りにもなる。
	.title TITLE -- タイトル行を付ける。
	.id id -- タイトルの直後に識別情報を出力する。
	.caption CAPTION -- 見出し行を付ける。
	.cont -- 段落の継続。直後の段落の先頭行をインデントせずに開始する。
	.eval 式 -- Cmd.formatオブジェクトの下で式を評価する。
	.index -- アウトラインから目次を生成し、挿入する。標準入力はseek可能なストリームでなくてはならない。
	.lineBreak -- 改行する。'|'のみの行でも可。
	.pageBreak -- 改ページする。
	.remark [発言者] -- 後続の段落を台詞として出力する。発言者を省略すると、次の行を発言者名として扱う。
	.remarkCont -- 後続の段落を台詞の次の段落として出力する。
	.right [N] -- 後続のN(省略時1)行を右寄せで出力する。
	.center [N] -- 後続のN(省略時1)行を中央寄せで出力する。
	.quoteStart -- 引用部を開始する。
	.quoteEnd -- 引用部を終了する。
	.item [mark] -- markを行頭として次の段落を箇条書きとする。
	.item2 [mark] -- markを行頭として次の段落を第二階層の箇条書きとする。
以下の変数をevalコマンドで設定出来る。
	indentParagraphTop? -- 段落の先頭を例外処理文字を除いてインデントする。
	paperWidth -- 1行の最大文字数。
	remarkNameWidth -- remark出力時の発言者名の幅。
	leftMargin -- 左余白の幅。
	rightMargin -- 右余白の幅。
.caption 関連項目
.summary ol

*import.@
	Mulk import: #("console" "wcarray")

*format common part.@
	Object addSubclass: #Format instanceVars:
		"reader next nextLine prevMode"
		+ " paperWidth indentParagraphTop? remarkNameWidth"
		+ " leftMargin rightMargin quote?"
		+ " levels"
**Format >> init
	Console width - 1 ->paperWidth;
	true ->indentParagraphTop?;
	9 ->remarkNameWidth;
	0 ->leftMargin;
	0 ->rightMargin;
	false ->quote?;
	Array new ->levels
**Format >> fetchLine
	reader getLn ->nextLine, nil? ifTrue: [#eof!];
	nextLine empty? ifTrue: [#empty!];
	nextLine first ->:ch, = '*' ifTrue: [#outline!];
	ch = '.' ifTrue: [#command!];
	ch = '|' ifTrue:
		[nextLine size = 1 ifTrue: [#lineBreak] ifFalse: [#verbatim]!];
	ch = ' ' ifTrue:
		[nextLine allSatisfy?: [:ch2 ch2 = ' '],
			ifTrue: [#empty] ifFalse: [#verbatim]!];
	#text!
**Format >> readLine
	nextLine ->:result;
	self fetchLine ->next;
	result!

**settings.
***#en
****Format >> nonIndentCharsAtParagraphTop
	#('(')!
****Format >> nonInsertSpaceCharsAtLineHeadForConcatLine
	#('!' '?' ')')!
****Format >> headProhibitChars
	#('?' '!' ')' ']' '}' '>')!
****Format >> tailProhibitChars
	#('(' '[' '{' '"' '\'')!
***#ja
****Format >> nonIndentCharsAtParagraphTop
	#('「' '『' '(' '・')!
****Format >> nonInsertSpaceCharsAtLineHeadForConcatLine
	#('!' '?' ')' '」' '』')!
****Format >> headProhibitChars
	#('.' ',' '。' '、' '|' 'ー' '?' '!' ')' ']' '}' '」' '>' '』'
		'ぁ' 'ぃ' 'ぅ' 'ぇ' 'ぉ' 'ゃ' 'ゅ' 'ょ' 'っ'
		'ァ' 'ィ' 'ゥ' 'ェ' 'ォ' 'ャ' 'ュ' 'ョ' 'ッ' '…'
		'・')!
****Format >> tailProhibitChars
	#('(' '[' '{' '「' '<' '『' '"' '\'' '・')!

**lineBreak for change mode.
***Format >> lineBreak?: mode
	false!
***Format >> writeLineBreak
	self shouldBeImplemented
***Format >> changeMode: mode
	self lineBreak?: mode, ifTrue: [self writeLineBreak];
	mode ->prevMode

**Format >> write: buf topMargin: tm restMargin: rm
	self shouldBeImplemented

**paragraph.
***Format >> insertSpaceForConcatLineBetween: last and: nfirst
	self nonInsertSpaceCharsAtLineHeadForConcatLine includes?: nfirst, 
		ifTrue: [false!];
	last = '!' | (last = '?') ifTrue: [true!];
	last ascii? & nfirst ascii?!
***Format >> readParagraphTo: buf
	buf addString: self readLine;
	[next = #text] whileTrue:
		[buf last ->:last;
		StringReader new init: nextLine, getWideChar ->:nfirst;
		self insertSpaceForConcatLineBetween: last and: nfirst,
			ifTrue: [buf addLast: ' '];
		buf addString: self readLine]
***Format >> writeParagraph: buf topMargin: tm
	self write: buf topMargin: tm restMargin: 0
***Format >> indentParagraphTopForChar?: ch
	indentParagraphTop? ifFalse: [false!];
	self nonIndentCharsAtParagraphTop includes?: ch, not!
***Format >> processParagraph
	self changeMode: (quote? ifTrue: [#quoteParagraph] ifFalse: [#paragraph]);
	self readParagraphTo: (WideCharArray new ->:buf);
	self indentParagraphTopForChar?: buf first, ifTrue: [2] ifFalse: [0] ->:tm;
	self writeParagraph: buf topMargin: tm

**verbatim
***Format >> verbatimLine: line
	WideCharArray new init addString: line ->:buf;
	0 ->:st;
	buf first = '|' ifTrue: [1 ->st];
	buf find: [:ch ch <> ' '] after: st ->:off;
	off nil? ifTrue: [st ->off];
	buf removeUntil: off;
	self writeVerbatim: buf topMargin: off - st restMargin: off - st + 4
***Format >> writeVerbatim: buf topMargin: tm restMargin: rm
	self write: buf topMargin: tm restMargin: rm
***Format >> processVerbatim
	self changeMode: #verbatim;
	self verbatimLine: self readLine

**outline.
***Format >> processOutline
	self changeMode: #outline;
	self readLine ->:line;
	line findFirst: [:ch ch <> '*'] ->:l, nil? ifTrue: [line size ->l];
	levels size < l
		ifTrue: [[levels size < l] whileTrue: [levels addLast: 1]]
		ifFalse:
			[levels at: l - 1 put: (levels at: l - 1) + 1;
			levels size: l];
	self writeOutline: (line copyFrom: l) level: l
***Format >> writeOutline: s level: l
	WideCharArray new init ->:buf;
	buf addString: self levelString;
	buf addLast: ' ';
	buf addString: s;
	self write: buf topMargin: 0 restMargin: 4
***Format >> levelString
	StringWriter new ->:wr;
	levels do: [:i wr put: i, put: '.'];
	wr asString!
	
**commands.
***Format >> integerArg: arg
	arg getTokenIfEnd: ["1"], asInteger!
***Format >> command.eval: args
	self eval: args getRest

***title.
****Format >> writeTitle: buf
	self write: buf topMargin: 0 restMargin: 4
****Format >> command.title: args
	self changeMode: #title;
	WideCharArray new addString: args getRest ->:buf;
	self writeTitle: buf

***Format >> command.id: args
	prevMode <> #title ifTrue:
		[self error: ".id must immediately following .title."];
	self verbatimLine: args getRest

***caption.
****Format >> writeCaption: buf
	self write: buf topMargin: 0 restMargin: 4
****Format >> command.caption: args
	self changeMode: #caption;
	WideCharArray new addString: args getRest ->:buf;
	self writeCaption: buf
	
***Format >> command.index: args
	self changeMode: #index;
	In seek: 0;
	In pipe: "ol -is", contentLinesDo: [:l self verbatimLine: l]

***right.
****Format >> writeRightAlign: buf
	self shouldBeImplemented
****Format >> command.right: args
	self changeMode: #right;
	self integerArg: args, timesRepeat:
		[self writeRightAlign: (WideCharArray new addString: self readLine)]

***center.
****Format >> writeCenterAlign: buf
	self shouldBeImplemented
****Format >> command.center: args
	self changeMode: #center;
	self integerArg: args, timesRepeat:
		[self writeCenterAlign: (WideCharArray new addString: self readLine)]

***Format >> command.cont: args
	indentParagraphTop? ->:save;
	false ->indentParagraphTop?;
	self processParagraph;
	save ->indentParagraphTop?
***Format >> command.lineBreak: args
	self writeLineBreak
***Format >> command.remark: args
	self changeMode: #remark;
	WideCharArray new ->:buf;
	args getRestIfEnd: [self readLine] ->:name;
	buf addString: name;
	buf width ->:nameWidth;
	buf addLast: ':';
	
	self readParagraphTo: (WideCharArray new ->:texts);
	self indentParagraphTopForChar?: texts first, 
		ifTrue: [buf addString: "  "];
	buf addString: texts asString;

	self write: buf
		topMargin: (remarkNameWidth - nameWidth max: 0)
		restMargin: remarkNameWidth + 1
***Format >> command.remarkCont: args
	self changeMode: #remark;
	self readParagraphTo: (WideCharArray new ->:buf);
	remarkNameWidth + 1 ->:tm;
	self indentParagraphTopForChar?: buf first, ifTrue: [tm + 2 ->tm];
	self write: buf topMargin: tm restMargin: remarkNameWidth + 1

***pageBreak.
****Format >> writePageBreak
	self shouldBeImplemented
****Format >> command.pageBreak: args
	nil ->prevMode;
	self writePageBreak

***Format >> command.quoteStart: args
	leftMargin + 4 ->leftMargin;
	true ->quote?
***Format >> command.quoteEnd: args
	leftMargin - 4 ->leftMargin;
	false ->quote?

***item.
****Format >> item: args defaultMark: mark margin: margin
	self changeMode: #item;
	WideCharArray new ->:buf;
	args getTokenIfEnd: [mark] ->mark;
	buf addString: mark;
	mark last ascii? ifTrue: [buf addLast: ' '];
	buf width ->:markWidth;
	self readParagraphTo: buf;
	self write: buf topMargin: margin - markWidth restMargin: margin
****Format >> command.item: args
	self item: args defaultMark: "+" margin: 4
****Format >> command.item2: args
	self item: args defaultMark: "-" margin: 6

***Format >> processCommand
	AheadReader new init: self readLine ->:r;
	r skipChar;
	r nextChar nil? or: [r nextChar space?], ifTrue: [self!];
	"command." + r getToken + ':', asSymbol ->:cmd;
	r skipSpace;
	self perform: cmd with: r

**Format >> processLine
	next = #text ifTrue: [self processParagraph!];
	next = #lineBreak ifTrue:
		[self readLine;
		self writeLineBreak!];
	next = #verbatim ifTrue: [self processVerbatim!];
	next = #outline ifTrue: [self processOutline!];
	next = #command ifTrue: [self processCommand!];
	self readLine
**Format >> process
	In pipe: "detab" ->reader;
	self readLine; -- foreseeing.
	[next <> #eof] whileTrue: [self processLine]

*format tool.@
	Format addSubclass: #Cmd.format

**lineBreak for change mode.
***Cmd.format >> lineBreak?: mode
	prevMode nil? ifTrue: [false!];
	prevMode = #caption | (prevMode = #outline) ifTrue: [false!];
	prevMode = mode ifTrue: [prevMode = #item!];
	true!
***Cmd.format >> writeLineBreak
	Out putLn

**write with prohibition.
***Cmd.format >> splitPos: buf width: width
	buf width <= width ifTrue: [buf size!];

	0 ->:cadet ->:cadet2;
	1 ->:i;
	buf at: 0 ->:pch;
	pch width ->:w;
	
	[w <= width] whileTrue:
		[buf at: i ->:ch;
		self headProhibitChars includes?: ch, not and:
			[pch ascii?
				ifTrue: [pch = ' ']
				ifFalse: [self tailProhibitChars includes?: pch, not]],
			ifTrue:
				[i ->cadet];
		i ->cadet2;
		i + 1 -> i;
		w + ch width ->w;
		ch ->pch];

	cadet = 0 ifTrue: [cadet2 ->cadet];
	cadet!
***Cmd.format >> writeHead: buf until: pos
	pos ->:h;
	pos <> 0 and: [buf at: pos - 1, = ' '], ifTrue: [h - 1 ->h];
	h timesDo: [:i Out put: (buf at: i)];
	Out putLn;
	buf removeUntil: pos
***Cmd.format >> writeHead: buf width: width
	self writeHead: buf until: (self splitPos: buf width: width)
***Cmd.format >> contentWidth
	paperWidth - leftMargin - rightMargin!
***Cmd.format >> write: buf topMargin: tm restMargin: rm
	Out putSpaces: tm + leftMargin;
	self writeHead: buf width: self contentWidth - tm;
	[buf empty?] whileFalse:
		[Out putSpaces: rm + leftMargin;
		self writeHead: buf width: self contentWidth - rm]

**Cmd.format >> writeRightAlign: buf
	[buf empty?] whileFalse:
		[self splitPos: buf width: self contentWidth ->:pos;
		buf copyUntil: pos ->:b2;
		Out putSpaces: leftMargin + self contentWidth - b2 width;
		self writeHead: buf until: pos]
**Cmd.format >> writeCenterAlign: buf
	[buf empty?] whileFalse:
		[self splitPos: buf width: self contentWidth ->:pos;
		buf copyUntil: pos ->:b2;
		Out putSpaces: leftMargin + self contentWidth - b2 width // 2;
		self writeHead: buf until: pos]
**Cmd.format >> writePageBreak
	Out putLn: '\f'
**Cmd.format >> main: args
	self process
