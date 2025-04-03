chat with ChatGPT
$Id: mulk chatgpt.m 1397 2025-03-25 Tue 21:22:56 kt $
#ja ChatGPTとチャットする

*[man]
**#en
.caption SYNOPSIS
Chat with ChatGPT.

For actual operation, please refer to the manual topic chat.
It is necessary to register https://platform.openai.com/ and API-KEY to Cmd.chatgpt.apikey in the system dictionary in advance.

.caption SEE ALSO
.summary chat

**#ja
.caption 説明
ChatGPTとチャットを行う。

実際の操作についてはマニュアルトピックchatを参照のこと。
事前にhttps://platform.openai.com/に登録し、API-KEYをシステム辞書のCmd.chatgpt.apikeyに登録しておく必要がある。

.caption 関連項目
.summary chat

*import.@
	Mulk import: "chat"
	
*driver.@
	Chat addSubclass: #Cmd.chatgpt
**Cmd.chatgpt >> dialogs
	chat at: "messages"!
**Cmd.chatgpt >> dialogOf: jsonArg
	Cons new ->:result;
	result car: (jsonArg at: "role");
	result cdr: (jsonArg at: "content");
	result!
**Cmd.chatgpt >> addDialogRole: roleArg text: textArg
	Dictionary new ->:message;
	message at: "role" put: roleArg;
	message at: "content" put: textArg;
	self dialogs addLast: message
**Cmd.chatgpt >> createChat
	Dictionary new ->chat;
	chat at: "model" put: "gpt-4o-mini";
	chat at: "messages" put: Array new;
	self addDialogRole: "system" text: "You are a helpful assistant."
**Cmd.chatgpt >> generateMain: arg
	self addDialogRole: "user" text: arg;
	HttpRequestFactory new create ->hr;
	hr url: "https://api.openai.com/v1/chat/completions";
	hr header: "Content-Type" value: "application/json";
	hr header: "Authorization" 
		value: "Bearer " + (Mulk at: #Cmd.chatgpt.apikey);
	self runJson: chat ->:json;
	json includesKey?: "error", 
		ifTrue:
			[JsonWriter new write: json to: Out;
			"*error*"]
		ifFalse:
			[json at: "choices", first at: "message", at: "content"] 
		->:result;
	self addDialogRole: "assistant" text: result;
	result!	
