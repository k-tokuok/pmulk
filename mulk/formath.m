format text into html
$Id: mulk formath.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja テキストをhtml形式に整形

*[man]
**#en
.caption SYNOPSIS
	formath
.caption DESCRIPTION
Read the format style text from the standard input and output it in html format.
.caption SEE ALSO
.summary format
**#ja
.caption 書式
	formath
.caption 説明
標準入力よりformat形式の文書ファイルを読み込み、html形式で出力する。
.caption 関連項目
.summary format

*import.@
	Mulk import: #("format" "xmlwr")

*formath tool.@
	Format addSubclass: #Cmd.formath instanceVars: "xmlwr"
**Cmd.formath >> lineBreak?: mode
	mode = #caption ifTrue: [false!];
	super lineBreak?: mode!
**Cmd.formath >> command.index: args
	self changeMode: #index;
	In seek: 0;
	In pipe: "ol -is", contentLinesDo:
		[:l
		l findFirst: [:ch ch <> ' '] ->:spos;
		l indexOf: ' ' after: spos ->:epos;
		xmlwr startTag: "div";
		xmlwr putAttr: "style" value: "padding-left:" + (spos / 2) + "em";
		xmlwr startTag: "a";
		xmlwr putAttr: "href" value: "#" + (l copyFrom: spos until: epos);
		xmlwr putText: (l copyFrom: spos);
		xmlwr endTag;
		xmlwr endTag]
**Cmd.formath >> putText: buf
	xmlwr putText: buf asString
**Cmd.formath >> putText: buf tag: tag
	xmlwr startTag: tag;
	self putText: buf;
	xmlwr endTag
**Cmd.formath >> write: buf topMargin: tm restMargin: rm
	leftMargin + rm / 2 ->:om;
	tm - rm / 2->:im;
	om <> 0 ifTrue:
		[xmlwr startTag: "div";
		xmlwr putAttr: "style" value: "margin-left: " + om + "em"];
	xmlwr startTag: "tt";
	im <> 0 ifTrue:
		[xmlwr putAttr: "style" value: "margin-left: " + im + "em"];
	self putText: buf;
	xmlwr endTag;
	om <> 0 ifTrue: [xmlwr endTag];
	xmlwr putTag: "br"
**Cmd.formath >> writeParagraph: buf topMargin: tm
	leftMargin / 2 ->:om;
	om <> 0 ifTrue:
		[xmlwr startTag: "div";
		xmlwr putAttr: "style" value: "margin-left: " + om + "em"];
	xmlwr startTag: "p";
	tm <> 0 ifTrue:
		[xmlwr putAttr: "style" value: "text-indent:" + (tm / 2) + "em"];
	self putText: buf;
	xmlwr endTag;
	om <> 0 ifTrue: [xmlwr endTag]
**Cmd.formath >> writeOutline: string level: level
	xmlwr startTag: "h" + (level + 1 min: 6);
	self levelString ->:ls;
	xmlwr putAttr: "id" value: ls;
	xmlwr putText: ls + ' ' + string;
	xmlwr endTag
**Cmd.formath >> writeTitle: buf
	self putText: buf tag: "h1"
**Cmd.formath >> writeCaption: buf
	self putText: buf tag: "h2"
**Cmd.formath >> writeRightAlign: buf
	xmlwr startTag: "div";
	xmlwr putAttr: "style" value: "text-align:right";
	self putText: buf;
	xmlwr endTag
**Cmd.formath >> writeCenterAlign: buf
	xmlwr startTag: "div";
	xmlwr putAttr: "style" value: "text-align:center";
	self putText: buf;
	xmlwr endTag
**Cmd.formath >> writeLineBreak
	xmlwr putTag: "br"
**Cmd.formath >> writePageBreak
	self
**Cmd.formath >> title
	In seek: 0;
	In pipe: "grep ^.title", getLn ->:s;
	In seek: 0;
	s nil?
		ifTrue: ["---"]
		ifFalse: [s copyFrom: 7]!
**Cmd.formath >> main: args
	XmlWriter new init: Out ->xmlwr;
	xmlwr startTag: "html";
	xmlwr startTag: "head";
	xmlwr startTag: "meta";
	Mulk.charset = #utf8
		ifTrue: [xmlwr putAttr: "charset" value: "UTF-8"];
	Mulk.charset = #sjis
		ifTrue: [xmlwr putAttr: "charset" value: "SHIFT_JIS"];
	xmlwr endTag;
	xmlwr startTag: "title";
	xmlwr putText: self title;
	xmlwr endTag;
	xmlwr endTag;
	xmlwr startTag: "body";
	super process;
	xmlwr endAllTags
