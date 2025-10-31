chat with Grok
$Id: mulk grok.m 1479 2025-10-18 Sat 21:05:23 kt $
#ja Grokとチャットする

*[man]
**#en
.caption DESCRIPTION
Chat with Grok.

See manual topic aichat for actual operation.
It is necessary to register https://console.x.ai and API-KEY to Cmd.grok.apikey in the system dictionary in advance.

.caption SEE ALSO
.summary aichat

**#ja
.caption 説明
Grokとチャットを行う。

実際の操作についてはマニュアルトピックaichatを参照のこと。
事前にhttps://console.x.aiに登録し、API-KEYをシステム辞書のCmd.grok.apikeyに登録しておく必要がある。

.caption 関連項目
.summary aichat

*import.@
	Mulk import: "chatgpt"

*driver.@
	Cmd.chatgpt addSubclass: #Cmd.grok
**Cmd.grok >> suffix
	"grok"!
**Cmd.grok >> models
	#("grok-4-fast-reasoning")!
**Cmd.grok >> endpoint
	"https://api.x.ai/v1/chat/completions"!
	
