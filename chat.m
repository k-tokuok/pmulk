AI chat common interface
$Id: mulk chat.m 1400 2025-03-31 Mon 20:55:37 kt $
#ja AIチャット共通インターフェイス

*[man]
**#en
.caption SYNOPSIS
	COMMAND [options] [CHATFILE]
	COMMAND.q CHATFILE -- display contents
	
.caption DESCRIPTION
Chat with the AI indicated by COMMAND.
See the description of each command for settings.

Once activated, the chat will be performed using the input line as it is, and the following input lines can be used to perform various functions.

	empty string -- enter text mode
	EOF or "!" -- exit
	!COMMAND -- execute COMMAND
	@save [FILE] -- save dialog contents to FILE (or CHATFILE if omitted)
	@load [FILE] -- load dialog from FILE
	@show -- show all dialog contents
	@back -- cancel the last dialog
	@retry --  change the last prompt in text mode and retry
	@adjust -- change the last response in text mode
	@recall -- toggle last prompt recall mode

In text mode, in conjunction with wb, any text between ">>" and "<<" (may include line breaks) can be used as input by typing ENTER at the end of a "<<" line.

CHATFILE is the content to be sent to the endpoint, and is in the target AI's own format.

.caption OPTION
	i CHATFILE -- Initial CHATFILE
    v -- Display processings verbosely.
	
.caption SEE ALSO
.summary chatgpt
.summary gemini

**#ja
.caption 書式
	COMMAND [オプション] [CHATFILE]
	COMMAND.show CHATFILE -- 内容を表示
	
.caption 説明
COMMANDで示されたAIとチャットを行う。
設定についてはそれぞれのコマンドの説明を参照のこと。

起動すると、入力行をそのままプロンプトとしてチャットを行う他、以下の入力行で様々な機能を実行できる。

	空文字列 -- テキストモードでプロンプトを入力する
	EOF又は"!" -- 終了する
	!COMMAND -- COMMANDを実行する
	@save [FILE] -- FILE(省略時はCHATFILE)に対話の内容を保存する
	@load [FILE] -- FILEから対話の内容を読み込む
	@show -- 全ての対話内容を出力する
	@back -- 最後の対話を取り消す
	@retry -- 最後のプロンプトをテキストモードで修正しやり直す
	@adjust -- 最後の応答の内容をテキストモードで修正する
	@recall -- 最終プロンプト再入力モードのトグル
	
テキストモードではwbと連携し、"<<"行の行末でENTERを入力することで">>"と"<<"の間の任意のテキスト(改行を含んでも良い)を入力とすることが出来る。

CHATFILEはendpointに送信する内容そのもので、対象AIの固有の形式となる。

.caption オプション
	i CHATFILE -- 初期CHATFILE
	v -- 処理を詳細に表示する
	
.caption 関連項目
.summary chatgpt
.summary gemini

*import.@
	Mulk import: #("optparse" "hrlib" "jsonrd" "jsonwr")
	
*Chat class.@
	Object addSubclass: #Chat instanceVars: 
		"hr chat chatFile cmdReader wb recall? verbose?"
	
**Chat >> init
	Mulk at: #Wb ifAbsent: [nil] ->wb;
	wb notNil? ifTrue: [wb get ->wb];
	false ->recall?;
	false ->verbose?
**Chat >> dialogs
	self shouldBeImplemented
**Chat >> dialogOf: jsonArg
	self shouldBeImplemented
**Chat >> addDialogRole: roleArg text: textArg
	self shouldBeImplemented

**Chat >> createChat
	self shouldBeImplemented
**Chat >> show: consArg
	Out put: '<', put: consArg car, putLn: '>', putLn: consArg cdr
**Chat >> showLastDialog
	self dialogs ->:ds, size ->:sz;
	sz - 2 max: 0, until: sz, do: [:i self show: (self dialogOf: (ds at: i))]
**Chat >> loadChat: fileArg
	fileArg readDo: [:s JsonReader new read: s ->chat]
**Chat >> saveChat: fileArg
	fileArg writeDo: [:s JsonWriter new write: chat to: s]

**Chat >> runJson: dataArg
	hr openData;
	Mulk.charset = #sjis 
		ifTrue:
			[[JsonWriter new write: dataArg to: Out]
				pipe: "ctr s u" to: hr data]
		ifFalse: [JsonWriter new write: dataArg to: hr data];
	TempFile create ->:outFile;
	hr outFile: outFile;
	hr run = 0 ifTrue: [nil!];
	Mulk.charset = #sjis
		ifTrue: [JsonReader new read: (outFile pipe: "ctr us s") ->:result]
		ifFalse: [outFile readDo: [:fs JsonReader new read: fs ->result]];
	outFile remove;
	verbose? ifTrue: [JsonWriter new write: result to: Out];
	result!
	
**Chat >> inputText: default
	default notNil? ifTrue: [default trim + '\n' -> default];
	wb inputText: default ->:result, nil? ifTrue: [nil!];
	result trim!
**Chat >> more: stringArg
	[Out putLn: stringArg] pipe: "more"
	
**commands.
***Chat >> justEnter
	recall? and: [self dialogs ->:ds, size ->:sz, > 1], ifTrue:
		[self dialogOf: (ds at: sz - 2), cdr ->:prompt];
	self inputText: prompt ->prompt, notNil? ifTrue:
		[self more: (self generateMain: prompt)]
***Chat >> getFileArg
	cmdReader getTokenIfEnd: [chatFile!], asFile!
***Chat >> cmd.save
	self saveChat: self getFileArg
***Chat >> cmd.load
	self loadChat: self getFileArg;
	self showLastDialog
***Chat >> cmd.show
	self dialogs do: [:d self show: (self dialogOf: d)]
***Chat >> cmd.back
	self dialogs ->:ds, size < 2 ifTrue: [self error: "no dialog"];
	ds removeLast removeLast;
	self showLastDialog
***Chat >> cmd.retry
	self dialogs ->:ds, size < 3 ifTrue: [self error: "no dialog"];
	self show: (self dialogOf: (ds at: ds size - 3));
	self dialogOf: (ds at: ds size - 2), cdr ->:prompt;
	self inputText: prompt ->prompt, notNil? ifTrue:
		[ds removeLast removeLast;
		self more: (self generateMain: prompt)]
***Chat >> cmd.adjust
	self dialogs ->:ds, size < 2 ifTrue: [self error: "no dialog"];
	self dialogOf: ds last ->:cons;
	self inputText: cons cdr ->:text, notNil? ifTrue:
		[ds removeLast;
		self addDialogRole: cons car text: text]
***Chat >> cmd.recall
	recall? not ->recall?;
	Out putLn: "recall " + (recall? ifTrue: ["on"] ifFalse: ["off"])
	
**Chat >> processLn: arg
	arg empty? ifTrue: [self justEnter!];
	arg first = '!' ifTrue: [arg copyFrom: 1, runCmd!];
	arg first = '@' ifTrue:
		[AheadReader new init: arg ->cmdReader;
		cmdReader skipChar;
		self perform: ("cmd." + cmdReader getToken) asSymbol!];
	self more: (self generateMain: arg)
**Chat >> main: args
	OptionParser new init: "i:v" ->:op, parse: args ->args;
	op at: 'i' ->:opt, notNil? ifTrue: [opt asFile ->:initialFile];
	op at: 'v', ifTrue: [true ->verbose?];
	args empty? ifFalse:
		[args first asFile ->chatFile;
		chatFile readableFile? ifTrue: [chatFile ->initialFile]];
	initialFile notNil?
		ifTrue: 
			[self loadChat: initialFile;
			self showLastDialog]
		ifFalse: [self createChat];
	[Out put: "chat>"; In getLn ->:p, notNil? and: [p <> "!"]] whileTrue: 
		[[self processLn: p] on: Error do: [:e Out putLn: e message]];
	chatFile notNil? ifTrue: [self saveChat: chatFile]
**Chat >> main.show: args
	self loadChat: args first asFile;
	self cmd.show
