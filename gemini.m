chat with Google Gemini
$Id: mulk gemini.m 1399 2025-03-29 Sat 22:15:31 kt $
#ja Google Geminiとチャットする

*[man]
**#en
.caption SYNOPSIS
Chat with Google Gemini.

For actual operation, please refer to the manual topic chat.
It is necessary to register https://aistudio.google.com/apikey and API-KEY to Cmd.gemini.apikey in the system dictionary in advance.

.caption SEE ALSO
.summary chat

**#ja
.caption 説明
Google Geminiとチャットを行う。

実際の操作についてはマニュアルトピックchatを参照のこと。
事前にhttps://aistudio.google.com/apikeyに登録し、API-KEYをシステム辞書のCmd.gemini.apikeyに登録しておく必要がある。

.caption 関連項目
.summary chat
*import.@
	Mulk import: "chat"
	
*driver.@
	Chat addSubclass: #Cmd.gemini
**Cmd.gemini >> dialogs
	chat at: "contents"!
**Cmd.gemini >> dialogOf: jsonArg
	Cons new ->:result;
	result car: (jsonArg at: "role");
	result cdr: (jsonArg at: "parts", first at: "text");
	result!
**Cmd.gemini >> addDialogRole: roleArg text: textArg
	Dictionary new ->:content;
	content at: "role" put: roleArg;
	Dictionary new ->:part;
	part at: "text" put: textArg;
	content at: "parts" put: (Array new addLast: part);
	self dialogs addLast: content
**Cmd.gemini >> createChat
	Dictionary new ->chat;
	chat at: "contents" put: Array new
**Cmd.gemini >> generateMain: arg
	self addDialogRole: "user" text: arg;
	[HttpRequestFactory new create ->hr;
	hr url: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + Cmd.gemini.apikey;
	hr header: "Content-Type" value: "application/json";
	self runJson: chat ->:json;
	json at: "candidates", first, at: "content", at: "parts", first at: "text"
		->:result
	] on: Error do:
		[:e
		self dialogs removeLast;
		Out putLn: e message;
		JsonWriter new write: json to: Out;
		"*error"!];
	self addDialogRole: "model" text: result;
	result!
