chat with Google Gemini
$Id: mulk gemini.m 1497 2025-12-20 Sat 09:23:52 kt $
#ja Google Geminiとチャットする

*[man]
**#en
.caption SYNOPSIS
Chat with Google Gemini.

See manual topic aichat for actual preparation and operation.

.caption MODELS
		gemini-2.5-flash-lite		
	1	gemini-2.5-flash
	2	gemini-2.5-pro
	3	gemini-3-flash-preview
	4	gemini-3-pro-preview
	
.caption SEE ALSO
	https://aistudio.google.com
.summary aichat

**#ja
.caption 説明
Google Geminiとチャットを行う。

実際の準備、操作についてはマニュアルトピックaichatを参照のこと。

.caption モデル
		gemini-2.5-flash-lite		
	1	gemini-2.5-flash
	2	gemini-2.5-pro
	3	gemini-3-flash-preview
	4	gemini-3-pro-preview
	
.caption 関連項目
	https://aistudio.google.com
.summary aichat

*import.@
	Mulk import: "aichat"
	
*driver.@
	AIChat addSubclass: #Cmd.gemini
**Cmd.gemini >> suffix
	"gem"!
**Cmd.gemini >> models
	#("gemini-2.5-flash-lite" "gemini-2.5-flash" "gemini-2.5-pro" 
		"gemini-3-flash-preview" "gemini-3-pro-preview")!
**Cmd.gemini >> dialogs
	chat at: "contents"!
**Cmd.gemini >> dialogOf: jsonArg
	Cons new ->:result;
	result car: (jsonArg at: "role");
	result cdr: (jsonArg at: "parts", first at: "text");
	result!
**Cmd.gemini >> adjustLastDialog: textArg
	self dialogs last at: "parts", first at: "text" put: textArg
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
	hr url: "https://generativelanguage.googleapis.com/v1beta/models/" + model 
		+ ":generateContent?key=" + self apikey;
	hr header: "Content-Type" value: "application/json";
	self runJson: chat ->:json;
	json at: "candidates", first, at: "content", at: "parts", first ->:part;
	part at: "thoughtSignature" ifAbsent: [nil] ->:thoughtSignature;
	part at: "text"
	] on: Error do:
		[:e
		JsonWriter new write: json to: Out;
		e message] ->:result;
	self addDialogRole: "model" text: result;
	thoughtSignature notNil? ifTrue:
		[self dialogs last at: "parts", first 
			at: "thoughtSignature" put: thoughtSignature];
	result!
