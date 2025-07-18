chat with Google Gemini
$Id: mulk gemini.m 1446 2025-06-21 Sat 21:15:30 kt $
#ja Google Geminiとチャットする

*[man]
**#en
.caption SYNOPSIS
Chat with Google Gemini.

For actual operation, please refer to the manual topic aichat.
It is necessary to register https://aistudio.google.com/apikey and API-KEY to Cmd.gemini.apikey in the system dictionary in advance.

.caption SEE ALSO
.summary aichat

**#ja
.caption 説明
Google Geminiとチャットを行う。

実際の操作についてはマニュアルトピックaichatを参照のこと。
事前にhttps://aistudio.google.com/apikeyに登録し、API-KEYをシステム辞書のCmd.gemini.apikeyに登録しておく必要がある。

.caption 関連項目
.summary aichat
*import.@
	Mulk import: "aichat"
	
*driver.@
	AIChat addSubclass: #Cmd.gemini
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
	"gemini-2.5-flash" ->:model;
	hr url: "https://generativelanguage.googleapis.com/v1beta/models/" + model + ":generateContent?key=" + Cmd.gemini.apikey;
	hr header: "Content-Type" value: "application/json";
	self runJson: chat ->:json;
	json at: "candidates", first, at: "content", at: "parts", first at: "text"
	] on: Error do:
		[:e
		JsonWriter new write: json to: Out;
		e message] ->:result;
	self addDialogRole: "model" text: result;
	result!
