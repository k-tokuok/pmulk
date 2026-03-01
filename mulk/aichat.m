AI chat common interface
$Id: mulk aichat.m 1537 2026-02-06 Fri 14:08:22 kt $
#ja AIチャット共通インターフェイス

*[man]
**#en
.caption SYNOPSIS
	COMMAND [OPTION] [CHATFILE]
	COMMAND.show CHATFILE -- display contents
	COMMAND.batch [OPTION] -- input prompts and output results
	
.caption DESCRIPTION
Chat with the AI indicated by COMMAND.
See the description of each command for settings.

Once activated, the chat will be performed using the input line as it is, and the following input lines can be used to perform various functions.

	empty string -- enter text mode
	EOF or "!" -- exit
	!COMMAND -- execute COMMAND
	@file [FILE] -- switch CHATFILE
	@save [FILE] -- save dialog contents to FILE (or CHATFILE if omitted)
	@load [FILE] -- load dialog from FILE
	@show [N] -- the contents of the dialog from the Nth to the last are output. If omitted, the last three exchanges are output.
	@back [N] -- back to the Nth input. If omitted, the last input (and response) is canceled
	@retry -- redo the last exchange
	@adjust -- change the last response in text mode
	@again -- reenter the prompt you just entered

In text mode, in conjunction with wb, any text between ">>" and "<<" (may include line breaks) can be used as input by typing ENTER at the end of a "<<" line.

The CHATFILE holds the content of the conversation, which can be specified to continue the dialogue.
It is the content itself that is sent to the endpoint, and is the unique format of the target AI.

It is necessary to obtain api keys from each service provider in advance and register them in Cmd.COMMAND.apikey in the system dictionary.
If the -k option is specified, the api key in Cmd.COMMAND.apikey.KEYSUFFIX is used.

.caption OPTION
	k KEYSUFFIX -- Specify the suffix of the api key
	1-4 -- Use a different AI model by default
	m MODEL -- Specify the AI model explicitly
	i CHATFILE -- Initial CHATFILE
    v -- Display processings verbosely
    a -- Save the CHATFILE for each interaction
	s CHATFILE -- Save CHATFILE on exit
	
.caption SEE ALSO
.summary chatgpt
.summary gemini
.summary grok

**#ja
.caption 書式
	COMMAND [オプション] [CHATFILE]
	COMMAND.show CHATFILE -- 内容を表示
	COMMAND.batch [オプション] -- プロンプトを入力し、結果を出力する
	
.caption 説明
COMMANDで示されたAIとチャットを行う。
設定についてはそれぞれのコマンドの説明を参照のこと。

起動すると、入力行をそのままプロンプトとしてチャットを行う他、以下の入力行で様々な機能を実行できる。

	空文字列 -- テキストモードでプロンプトを入力する
	EOF又は"!" -- 終了する
	!COMMAND -- COMMANDを実行する
	@file [FILE] -- CHATFILEを切り替える
	@save [FILE] -- FILE(省略時はCHATFILE)に対話の内容を保存する
	@load [FILE] -- FILEから対話の内容を読み込む
	@show [N] -- N番目から最後までの対話内容を出力する。省略時は最後の3回分のやりとりが出力される
	@back [N] -- N番目の入力まで戻る。省略時は最後の入力(と応答)が取り消される
	@retry -- 直前のやりとりをやり直す
	@adjust -- 最後の応答の内容をテキストモードで修正する
	@again -- 直前に入力したプロンプトを再入力する

テキストモードではwbと連携し、"<<"行の行末でENTERを入力することで">>"と"<<"の間の任意のテキスト(改行を含んでも良い)を入力とすることが出来る。

CHATFILEは会話の内容を保持し、これを指定することで対話を継続できる。
endpointに送信する内容そのもので、対象AIの固有の形式となる。

事前にそれぞれのサービスプロバイダからapi keyを取得し、システム辞書のCmd.COMMAND.apikeyに登録しておく必要がある。
kオプションを指定するとCmd.COMMAND.apikey.KEYSUFFIXのapi keyが使用される。

.caption オプション
	k KEYSUFFIX -- api keyのサフィックスを指定する
	1-4 -- 既定の別のAIモデルを使用する
	m MODEL -- AIモデルを明に指定する
	i CHATFILE -- 初期CHATFILE
	v -- 処理を詳細に表示する
	a -- 対話の都度、CHATFILEを保存する	
	s CHATFILE -- 終了時にCHATFILEを保存する (batch)
.caption 関連項目
.summary chatgpt
.summary gemini
.summary grok

*import.@
	Mulk import: #("optparse" "hrlib" "jsonrd" "jsonwr" "prompt")
	
*AIChat class.@
	Object addSubclass: #AIChat instanceVars: 
		"hr model keysuffix chat chatFile"
		+ " cmdReader wb verbose? lastPrompt quit? autosave?"
	
**AIChat >> init
	Mulk at: #Wb ifAbsent: [nil] ->wb;
	wb notNil? ifTrue: [wb get ->wb];
	false ->verbose?;
	false ->autosave?;
	"" ->lastPrompt
**AIChat >> suffix
	self shouldBeImplemented
**AIChat >> models
	self shouldBeImplemented
**AIChat >> dialogs
	self shouldBeImplemented
**AIChat >> dialogOf: jsonArg
	self shouldBeImplemented
**AIChat >> adjustLastDialog: textArg
	self shouldBeImplemented

**AIChat >> createChat
	self shouldBeImplemented
**AIChat >> apikey
	self class asString + ".apikey" ->:key;
	keysuffix notNil? ifTrue: [key + '.' + keysuffix ->key];
	Mulk at: key asSymbol!
**AIChat >> generateMain: arg
	self shouldBeImplemented

**AIChat >> size
	self dialogs size!
**AIChat >> size: sizeArg
	self dialogs size: sizeArg
**AIChat >> at: posArg
	self dialogOf: (self dialogs at: posArg)!
**AIChat >> showAt: posArg
	self at: posArg ->:cons;
	Out put: '<', put: cons car, put: ' ', put: posArg, putLn: '>', 
		putLn: cons cdr
**AIChat >> showFrom: posArg
	posArg max: 0, until: self size, do: [:i self showAt: i]
**AIChat >> emptyCheck
	self size < 2 ifTrue: [self error: "no dialog"]
**AIChat >> showLastDialog
	self showFrom: self size - 2

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
	hr run;
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
	cmdReader getTokenIfEnd: [nil] ->:arg;
	arg nil? ifTrue: [self size - 6] ifFalse: [arg asInteger] ->:pos;
	self showFrom: pos
***AIChat >> cmd.back
	self emptyCheck;
	cmdReader getTokenIfEnd: [nil] ->:arg;
	self size ->:sz;
	arg nil? ifTrue: [sz - 2] ifFalse: [arg asInteger] ->:pos;
	pos between: 0 until: sz, and: [self at: pos, car = (self at: sz - 2) car],
		ifFalse: [self error: "illegal pos"];
	self size: pos;	
	self showLastDialog
***AIChat >> cmd.retry
	self emptyCheck;
	self at: (self size - 2 ->:nsz), cdr ->:prompt;
	self inputText: prompt ->prompt, notNil? ifTrue:
		[self size: nsz;
		self generate: prompt]
***AIChat >> cmd.adjust
	self emptyCheck;
	self at: self size - 1 ->:cons;
	self inputText: cons cdr ->:text, notNil? ifTrue: 
		[self adjustLastDialog: text]
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
**AIChat >> setModel: opArg
	opArg at: 'k' ->keysuffix;
	opArg at: '1', ifTrue: [self models at: 1 ->model!];
	opArg at: '2', ifTrue: [self models at: 2 ->model!];
	opArg at: '3', ifTrue: [self models at: 3 ->model!];
	opArg at: '4', ifTrue: [self models at: 4 ->model!];
	opArg at: 'm' ->:opt, notNil? ifTrue: [opt ->model!];
	self models first ->model
**AIChat >> main: args
	OptionParser new init: "1234m:k:i:va" ->:op, parse: args ->args;
	self setModel: op;
	op at: 'i' ->:opt, notNil? ifTrue: [opt asFile ->:initialFile];
	op at: 'v', ifTrue: 
		[true ->verbose?;
		Out putLn: "model: " + model];
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
		[Out put: "chat " + self size + '>';
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
**AIChat >> main.show: args
	self loadChat: args first asFile;
	self showFrom: 0
**AIChat >> main.batch: args
	OptionParser new init: "1234m:k:i:s:" ->:op, parse: args ->args;
	self setModel: op;
	false ->verbose?;
	op at: 'i' ->:opt, nil? 
		ifTrue: [self createChat]
		ifFalse: [self loadChat: opt asFile];
	Out putLn: (self generateMain: ("cat" pipe contentBytes asString));
	op at: 's' ->opt, notNil? ifTrue: [self saveChat: opt asFile]
