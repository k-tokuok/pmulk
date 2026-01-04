chat with ChatGPT
$Id: mulk chatgpt.m 1496 2025-12-18 Thu 21:46:13 kt $
#ja ChatGPTとチャットする

*[man]
**#en
.caption SYNOPSIS
Chat with ChatGPT.

See manual topic aichat for actual preparation and operation.

.caption SEE ALSO
	https://platform.openai.com/
.summary aichat

**#ja
.caption 説明
ChatGPTとチャットを行う。

実際の準備、操作についてはマニュアルトピックaichatを参照のこと。

.caption 関連項目
	https://platform.openai.com/
.summary aichat

*import.@
	Mulk import: "aichat"
	
*driver.@
	AIChat addSubclass: #Cmd.chatgpt
**Cmd.chatgpt >> suffix
	"chat"!
**Cmd.chatgpt >> models
	#("gpt-5-mini")!
**Cmd.chatgpt >> dialogs
	chat at: "messages"!
**Cmd.chatgpt >> dialogOf: jsonArg
	Cons new ->:result;
	result car: (jsonArg at: "role");
	result cdr: (jsonArg at: "content");
	result!
**Cmd.chatgpt >> adjustLastDialog: textArg
	self dialogs last at: "content" put: textArg
**Cmd.chatgpt >> addDialogRole: roleArg text: textArg
	Dictionary new ->:message;
	message at: "role" put: roleArg;
	message at: "content" put: textArg;
	self dialogs addLast: message
**Cmd.chatgpt >> createChat
	Dictionary new ->chat;
	chat at: "messages" put: Array new;
	self addDialogRole: "system" text: "You are a helpful assistant."
**Cmd.chatgpt >> endpoint
	"https://api.openai.com/v1/chat/completions"!
**Cmd.chatgpt >> generateMain: arg
	chat at: "model" put: model;
	self addDialogRole: "user" text: arg;
	[HttpRequestFactory new create ->hr;
	hr url: self endpoint;
	hr header: "Content-Type" value: "application/json";
	hr header: "Authorization" value: "Bearer " + self apikey;
	self runJson: chat ->:json;
	json at: "choices", first at: "message", at: "content"
	] on: Error do:
		[:e
		JsonWriter new write: json to: Out;
		e message] ->:result;
	self addDialogRole: "assistant" text: result;
	result!	
