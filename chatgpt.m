chat with ChatGPT
$Id: mulk chatgpt.m 1319 2024-12-01 Sun 16:19:51 kt $
#ja ChatGPTとチャットする

*[man]
**#en
.caption SYNOPSIS
	chatgpt [OPTION] [CHATFILE]
	chatgpt.show CHATFILE --  show contents of CHATFILE
.caption DESCRIPTION
Chat with ChatGPT.

The input line is normally sent as is as a prompt.
The following input lines have special behavior.
	empty string -- enter text mode
	EOF or "!" -- exit
	!COMMAND -- execute COMMAND
	@save [FILE] -- save dialog in FILE. If omitted, CHATFILE is targeted
	@load [FILE] -- load dialog from FILE
	@show -- show all dialog contents
	@back -- cancel the last dialog
	@retry --  change the last prompt in text mode and retry
	@adjust -- change the last response in text mode

In text mode, it works with wb, and by typing ENTER at the end of a "<<" line, any text between the ">>" and "<<" lines (including line feeds) can be used as input.

The CHATFILE is the content of the message sent to the completions endpoint, and if specified, the dialog can be maintained and resumed.

Register https://platform.openai.com/ and the API-KEY to Cmd.chatgpt.apikey in the system dictionary.
.caption OPTION
	v -- show verbosity
	i CHATFILE -- initial CHATFILE
	p -- defaults to the previous prompt if an empty string is entered
	t -- display the time taken for completion
**#ja
.caption 書式
	chatgpt [オプション] [CHATFILE]
	chatgpt.show CHATFILE -- CHATFILEの内容を表示
.caption 説明
ChatGPTとチャットを行う。

入力された行は通常そのままプロンプトとして送信される。
以下の入力行は特殊な動作を行う。
	空文字列 -- テキストモードでプロンプトを入力する。
	EOF又は"!" -- exit
	!COMMAND -- COMMANDを実行する
	@save [FILE] -- FILEに対話の内容を保存する。省略時はCHATFILEを対象とする
	@load [FILE] -- FILEから対話の内容を読み込む
	@show -- 全ての対話内容を出力する
	@back -- 最後の対話を取り消す
	@retry -- 最後のプロンプトをテキストモードで修正しやり直す
	@adjust -- 最後の応答の内容をテキストモードで修正する
テキストモードではwbと連携し、"<<"行の行末でENTERを入力することで">>"と"<<"の間の任意のテキスト(改行を含んでも良い)を入力とすることが出来る。

CHATFILEはcompletions endpointに送る送信内容そのもので、指定すると対話を保持・継続出来る。

事前にhttps://platform.openai.com/に登録し、API-KEYをシステム辞書のCmd.chatgpt.apikeyに登録しておくこと。

.caption オプション
	v -- 処理を詳細に表示する
	i CHATFILE -- 初期CHATFILE
	p -- 空文字列を入力した場合、直前のプロンプトをデフォルトとする
	t -- completionにかかった時間を表示する

*import.@
	Mulk import: #("optparse" "hrlib" "jsonrd" "jsonwr")
	
*chatgpt driver.@
	Object addSubclass: #Cmd.chatgpt 
		instanceVars: "hr chat chatFile cmdReader verbose? wb usePrev? time?"
**Cmd.chatgpt >> init
	false ->verbose?;
	Mulk at: #Wb ifAbsent: [nil] ->wb;
	wb notNil? ifTrue: [wb get ->wb]

**Cmd.chatgpt >> messages
	chat at: "messages"!
**Cmd.chatgpt >> addMessageRole: roleArg content: contentArg
	Dictionary new ->:message;
	message at: "role" put: roleArg;
	message at: "content" put: contentArg;
	self messages addLast: message
**Cmd.chatgpt >> createChat
	Dictionary new ->chat;
	chat at: "model" put: "gpt-4o-mini";
	chat at: "messages" put: Array new;
	self addMessageRole: "system" content: "You are a helpful assistane"
**Cmd.chatgpt >> loadChat: file
	file readDo: [:s JsonReader new read: s ->chat]
**Cmd.chatgpt >> saveChat: file
	file writeDo: [:s JsonWriter new write: chat to: s]
**Cmd.chatgpt >> runJson: dataArg
	hr openData;
	Mulk.charset = #sjis
		ifTrue: 
			[[JsonWriter new write: dataArg to: Out] 
				pipe: "ctr s u" to: hr data]
		ifFalse: [JsonWriter new write: dataArg to: hr data];
	TempFile create ->:outFile;
	hr outFile: outFile;
	time? ifTrue: [OS floattime ->:st];
	hr run = 0 ifTrue: [nil!];
	time? ifTrue: [Out putLn: "completion: " + (OS floattime - st) + "sec"];
	Mulk.charset = #sjis
		ifTrue: [JsonReader new read: (outFile pipe: "ctr u s") ->:result]
		ifFalse: [outFile readDo: [:fs JsonReader new read: fs ->result]];
	outFile remove;
	result!
**Cmd.chatgpt >> completeMain: userArg
	self addMessageRole: "user" content: userArg;
	HttpRequestFactory new create ->hr;
	hr url: "https://api.openai.com/v1/chat/completions";
	hr header: "Content-Type" value: "application/json";
	hr header: "Authorization" 
		value: "Bearer " + (Mulk at: #Cmd.chatgpt.apikey);
	self runJson: chat ->:json;
	json includesKey?: "error", ifTrue:
		[JsonWriter new write: json to: Out;
		""!];
	verbose? ifTrue: [JsonWriter new write: json to: Out];
	json at: "choices", first at: "message", at: "content" ->:result;
	self addMessageRole: "assistant" content: result;
	result!
**Cmd.chatgpt >> main.test: args
	true ->verbose?;
	self createChat;
	self completeMain: args first

**Cmd.chatgpt >> inputText: default
	default notNil? ifTrue: [default trim + '\n' ->default];
	wb inputText: default ->:result, nil? ifTrue: [nil!];
	result trim!
**Cmd.chatgpt >> completeText: default
	self inputText: default ->:prompt, notNil? ifTrue:
		[Out putLn: (self completeMain: prompt)]
**Cmd.chatgpt >> show: messageArg
	Out put: '<', put: (messageArg at: "role"), putLn: '>',
		putLn: (messageArg at: "content")
**Cmd.chatgpt >> showLastDialog
	self messages ->:msgs, size ->:ms;
	ms - 2 max: 0, until: ms, do: [:i self show: (msgs at: i)]
			
**commands.
***Cmd.chatgpt >> justEnter
	usePrev? and: [self messages ->:ms, size <> 1], ifTrue:
		[ms at: ms size - 2, at: "content" ->:prompt];
	self completeText: prompt
***Cmd.chatgpt >> getFileArg
	cmdReader getTokenIfEnd: [chatFile!], asFile!
***Cmd.chatgpt >> cmd.save
	self saveChat: self getFileArg
***Cmd.chatgpt >> cmd.load
	self loadChat: self getFileArg;
	self showLastDialog
***Cmd.chatgpt >> cmd.show
	self messages do: [:m self show: m]
***Cmd.chatgpt >> cmd.back
	self messages ->:ms, size = 1 ifTrue: [self error: "no dialog"];
	ms removeLast;
	ms removeLast;
	self showLastDialog
***Cmd.chatgpt >> cmd.retry
	self messages ->:ms, size = 1 ifTrue: [self error: "no doalog"];
	ms at: ms size - 2, at: "content" ->:prompt;
	self inputText: prompt ->prompt;
	prompt notNil? ifTrue:
		[ms removeLast, removeLast;
		Out putLn: (self completeMain: prompt)]
***Cmd.chatgpt >> cmd.adjust
	self messages last ->:ms;
	self inputText: (ms at: "content") ->:content;
	content notNil? ifTrue: [ms at: "content" put: content]
**Cmd.chatgpt >> processLn: arg
	arg empty? ifTrue: [self justEnter!];
	arg first = '!' ifTrue: [arg copyFrom: 1, runCmd!];
	arg first = '@' ifTrue:
		[AheadReader new init: arg ->cmdReader;
		cmdReader skipChar;
		cmdReader getToken ->:cmd;
		self perform: ("cmd." + cmd, asSymbol)!];
	Out putLn: (self completeMain: arg)

**Cmd.chatgpt >> main: args
	OptionParser new init: "vi:pt" ->:op, parse: args ->args;
	op at: 'v' ->verbose?;
	op at: 'p' ->usePrev?;
	op at: 't' ->time?;
	op at: 'i' ->:opt, notNil? ifTrue: [opt asFile ->:initialFile];
	args empty? ifFalse: 
		[args first asFile ->chatFile;
		chatFile readableFile? ifTrue: [chatFile ->initialFile]];
	initialFile notNil? 
		ifTrue: 
			[self loadChat: initialFile;
			self showLastDialog]
		ifFalse: [self createChat];
	[Out put: '>'; In getLn ->:p, notNil? and: [p <> "!"]] whileTrue: 
		[[self processLn: p] on: Error do: [:e Out putLn: e message]];
	chatFile notNil? ifTrue: [self saveChat: chatFile]

**Cmd.chatgpt >> main.show: args
	self loadChat: args first asFile;
	self cmd.show
