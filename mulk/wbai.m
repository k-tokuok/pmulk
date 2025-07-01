wb AI support
$Id: mulk wbai.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja wb AI支援
*[man]
**#en
.caption DESCRIPTION
Provides AI support features for wb.

Pressing ^x + @ inserts AI suggestions based on the document content at the cursor position.
During a leap, the leap range content is replaced with the AI suggestion.

Uses gemini by default.
Refer to the relevant sections for configuration.

The AI is invoked using the system dictionary "Wb.ai" command.

.caption SEE ALSO
.summary aichat

**#ja
.caption 説明
wbにAIによる支援機能を提供する。

^x + @を入力すると、そのドキュメントの内容に沿ったAIの提案をカーソル位置に挿入する。
リープ中はリープ範囲の内容をAIの提案内容と入れ換える。

デフォルトではgeminiを使用する。
設定については当該項目を参照のこと。

AI呼び出しの際は、システム辞書のWb.aiのコマンドが使用される。

.caption 関連項目
.summary aichat

*@
	Mulk addGlobalVar: #Wb.ai, set: "gemini.batch";
	Wb xDict at: '@' put: #aiCommand
	
*Wb.class >> aiCommand
	nil ->:info;
	mode <> #insert ifTrue:
		[self focusLeapAndFinish;
		self focusedBytes ->info;
		self at: startPos remove: endPos - startPos];
	self focusDocAt: cursor, = #bottom ifTrue: [self error: "illegal cursor"];
	self refocusContents;
	MemoryStream new ->:str,
		putLn: "Please consider what should be described by replacing [*start] to [*end] in the following text.",
		putLn: "Output only the content and no other extra output at all!",
		putLn: "--",
		write: (buffer copyFrom: startPos until: cursor),
		put: "[*start]";
	info notNil? ifTrue: [str write: info];
	str put: "[*end]",
		write: (buffer copyFrom: cursor until: endPos),
		putLn;
	str seek: 0;
	str pipe: Wb.ai to: (Wb.BytesStream new ->:rd);
	rd removeLastNewline;
	self at: cursor insert: (rd seek: 0, contentBytes)
