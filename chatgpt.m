chat with ChatGPT
$Id: mulk chatgpt.m 1428 2025-05-24 Sat 21:14:18 kt $
#ja ChatGPTとチャットする

*[man]
**#en
.caption SYNOPSIS
Chat with ChatGPT.

For actual operation, please refer to the manual topic aichat.
It is necessary to register https://platform.openai.com/ and API-KEY to Cmd.chatgpt.apikey in the system dictionary in advance.

.caption SEE ALSO
.summary aichat

**#ja
.caption 説明
ChatGPTとチャットを行う。

実際の操作についてはマニュアルトピックaichatを参照のこと。
事前にhttps://platform.openai.com/に登録し、API-KEYをシステム辞書のCmd.chatgpt.apikeyに登録しておく必要がある。

.caption 関連項目
.summary aichat

*import.@
	Mulk import: "aichat"
	
*driver.@
	AIChat addSubclass: #Cmd.chatgpt
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
	[HttpRequestFactory new create ->hr;
	hr url: "https://api.openai.com/v1/chat/completions";
	hr header: "Content-Type" value: "application/json";
	hr header: "Authorization" 
		value: "Bearer " + (Mulk at: #Cmd.chatgpt.apikey);
	self runJson: chat ->:json;
	json at: "choices", first at: "message", at: "content"
	] on: Error do:
		[:e
		JsonWriter new write: json to: Out;
		e message] ->:result;
	self addDialogRole: "assistant" text: result;
	result!	
