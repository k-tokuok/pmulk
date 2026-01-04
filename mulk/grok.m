chat with Grok
$Id: mulk grok.m 1490 2025-12-11 Thu 21:24:28 kt $
#ja Grokとチャットする

*[man]
**#en
.caption DESCRIPTION
Chat with Grok.

See manual topic aichat for actual preparation and operation.

.caption SEE ALSO
	https://console.x.ai
.summary aichat

**#ja
.caption 説明
Grokとチャットを行う。

実際の準備、操作についてはマニュアルトピックaichatを参照のこと。

.caption 関連項目
	https://console.x.ai
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
	
