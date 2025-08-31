AI chat common interface
$Id: mulk aichat.m 1470 2025-08-29 Fri 23:04:09 kt $
#ja AIチャット共通インターフェイス

*[man]
**#en
.caption SYNOPSIS
	COMMAND [options] [CHATFILE]
	COMMAND.show CHATFILE -- display contents
	COMMAND.batch [CHATFILE] -- input prompts and output results
	
.caption DESCRIPTION
Chat with the AI indicated by COMMAND.
See the description of each command for settings.

Once activated, the chat will be performed using the input line as it is, and the following input lines can be used to perform various functions.

	empty string -- enter text mode
	EOF or "!" -- exit
	!COMMAND -- execute COMMAND
	@file [FILE] -- switch CHATFILE.
	@save [FILE] -- save dialog contents to FILE (or CHATFILE if omitted)
	@load [FILE] -- load dialog from FILE
	@show -- show all dialog contents
	@back -- cancel the last dialog
	@retry -- redo the last exchange
	@adjust -- change the last response in text mode
	@again -- reenter the prompt you just entered

In text mode, in conjunction with wb, any text between ">>" and "<<" (may include line breaks) can be used as input by typing ENTER at the end of a "<<" line.

The CHATFILE holds the content of the conversation, which can be specified to continue the dialogue.
It is the content itself that is sent to the endpoint, and is the unique format of the target AI.

.caption OPTION
	i CHATFILE -- Initial CHATFILE
    v -- Display processings verbosely
    a -- Save the CHATFILE for each interaction
	
.caption SEE ALSO
.summary chatgpt
.summary gemini

**#ja
.caption 書式
	COMMAND [オプション] [CHATFILE]
	COMMAND.show CHATFILE -- 内容を表示
	COMMAND.batch [CHATFILE] -- プロンプトを入力し、結果を出力する
	
.caption 説明
COMMANDで示されたAIとチャットを行う。
設定についてはそれぞれのコマンドの説明を参照のこと。

起動すると、入力行をそのままプロンプトとしてチャットを行う他、以下の入力行で様々な機能を実行できる。

	空文字列 -- テキストモードでプロンプトを入力する
	EOF又は"!" -- 終了する
	!COMMAND -- COMMANDを実行する
	@file [FILE] -- CHATFILEを切り替える。
	@save [FILE] -- FILE(省略時はCHATFILE)に対話の内容を保存する
	@load [FILE] -- FILEから対話の内容を読み込む
	@show -- 全ての対話内容を出力する
	@back -- 最後の対話を取り消す
	@retry -- 直前のやりとりをやり直す
	@adjust -- 最後の応答の内容をテキストモードで修正する
	@again -- 直前に入力したプロンプトを再入力する

テキストモードではwbと連携し、"<<"行の行末でENTERを入力することで">>"と"<<"の間の任意のテキスト(改行を含んでも良い)を入力とすることが出来る。

CHATFILEは会話の内容を保持し、これを指定することで対話を継続できる。
endpointに送信する内容そのもので、対象AIの固有の形式となる。

.caption オプション
	i CHATFILE -- 初期CHATFILE
	v -- 処理を詳細に表示する
	a -- 対話の都度、CHATFILEを保存する	
.caption 関連項目
.summary chatgpt
.summary gemini

*import.@
	Mulk import: #("optparse" "hrlib" "jsonrd" "jsonwr" "prompt")
	
*AIChat class.@
	Object addSubclass: #AIChat instanceVars: 
		"hr chat chatFile cmdReader wb verbose? lastPrompt quit? autosave?"
	
**AIChat >> init
	Mulk at: #Wb ifAbsent: [nil] ->wb;
	wb notNil? ifTrue: [wb get ->wb];
	false ->verbose?;
	false ->autosave?;
	"" ->lastPrompt
**AIChat >> suffix
	self shouldBeImplemented
**AIChat >> dialogs
	self shouldBeImplemented
**AIChat >> dialogOf: jsonArg
	self shouldBeImplemented
**AIChat >> addDialogRole: roleArg text: textArg
	self shouldBeImplemented

**AIChat >> createChat
	self shouldBeImplemented
**AIChat >> generateMain: arg
	self shouldBeImplemented

**AIChat >> show: consArg
	Out put: '<', put: consArg car, putLn: '>', putLn: consArg cdr
**AIChat >> showLastDialog
	self dialogs ->:ds, size ->:sz;
	sz - 2 max: 0, until: sz, do: [:i self show: (self dialogOf: (ds at: i))]
**AIChat >> loadChat: fileArg
	fileArg readDo: [:s JsonReader new read: s ->chat]
**AIChat >> saveChat: fileArg
	fileArg writeDo: [:s JsonWriter new write: chat to: s]

**AIChat >> runJson: dataArg
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
	
**AIChat >> inputText: default
	default notNil? ifTrue: [default trim + '\n' -> default];
	wb inputText: default ->:result, nil? ifTrue: [nil!];
	result trim ->result, empty? ifTrue: [nil!];
	result!
**AIChat >> generate: promptArg
	promptArg ->lastPrompt;
	[Out putLn: (self generateMain: promptArg)] pipe: "more";
	chatFile notNil? & autosave? ifTrue: [self saveChat: chatFile]
		
**commands.
***AIChat >> justEnter
	self inputText: nil ->:prompt, notNil? ifTrue: [self generate: prompt]
***AIChat >> getFileArg
	cmdReader getTokenIfEnd: [chatFile!], asFile!
***AIChat >> cmd.file
	cmdReader getTokenIfEnd: [Out putLn: chatFile!], asFile ->chatFile
***AIChat >> cmd.save
	self saveChat: self getFileArg
***AIChat >> cmd.load
	self loadChat: self getFileArg;
	self showLastDialog
***AIChat >> cmd.show
	self dialogs do: [:d self show: (self dialogOf: d)]
***AIChat >> cmd.back
	self dialogs ->:ds, size < 2 ifTrue: [self error: "no dialog"];
	ds removeLast removeLast;
	self showLastDialog
***AIChat >> cmd.retry
	self dialogs ->:ds, size ->:sz, < 2 ifTrue: [self error: "no dialog"];
	self dialogOf: (ds at: sz - 2), cdr ->:prompt;
	self inputText: prompt ->prompt, notNil? ifTrue:
		[ds removeLast removeLast;
		self generate: prompt]
***AIChat >> cmd.adjust
	self dialogs ->:ds, size < 2 ifTrue: [self error: "no dialog"];
	self dialogOf: ds last ->:cons;
	self inputText: cons cdr ->:text, notNil? ifTrue:
		[ds removeLast;
		self addDialogRole: cons car text: text]
***AIChat >> cmd.again
	self inputText: lastPrompt ->:p, notNil? ifTrue: [self generate: p]
		
**AIChat >> processLn: arg
	arg nil? or: [arg = "!"], ifTrue: [true ->quit?!];
	arg empty? ifTrue: [self justEnter!];
	arg first = '!' ifTrue: [arg copyFrom: 1, runCmd!];
	arg first = '@' ifTrue:
		[AheadReader new init: arg ->cmdReader;
		cmdReader skipChar;
		self perform: ("cmd." + cmdReader getToken) asSymbol!];
	self generate: arg
**AIChat >> main: args option: op
	op at: 'i' ->:opt, notNil? ifTrue: [opt asFile ->:initialFile];
	op at: 'v', ifTrue: [true ->verbose?];
	op at: 'a' ->autosave?;
	args empty? ifFalse:
		[args first asFile ->chatFile;
		chatFile readableFile? ifTrue: [chatFile ->initialFile]];
	initialFile notNil?
		ifTrue: 
			[self loadChat: initialFile;
			self showLastDialog]
		ifFalse: [self createChat];
	false ->quit?;
	[quit?] whileFalse:
		[Out put: "chat>";
		In getLn ->:ln;
		[self processLn: ln] on: Error do: [:e Out putLn: e message]];
	chatFile nil? ifTrue:
		[DateAndTime new initNow ->:now;
		(now year asString0: 4) + (now month asString0: 2) 
			+ (now day asString0: 2) + '-' + (now hour asString0: 2) 
			+ (now minute asString0: 2) + '.' + self suffix, asWorkFile 
			->chatFile;
		Out putLn: "chatFile: " + chatFile path];
	self saveChat: chatFile
**AIChat >> main: args
	OptionParser new init: "i:va" ->:op, parse: args ->args;
	self main: args option: op
**AIChat >> main.show: args
	self loadChat: args first asFile;
	self cmd.show
**AIChat >> main.batch: args
	false ->verbose?;
	args empty? 
		ifTrue: [self createChat]
		ifFalse: [self loadChat: args first asFile];
	Out putLn: (self generateMain: ("cat" pipe contentBytes asString))
