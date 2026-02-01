chat with xAI Grok
$Id: mulk grok.m 1524 2026-01-15 Thu 20:36:24 kt $
#ja xAI Grokとチャットする

*[man]
**#en
.caption DESCRIPTION
Chat with xAI Grok.

See manual topic aichat for actual preparation and operation.

.caption SEE ALSO
	https://console.x.ai
.summary aichat

**#ja
.caption 説明
xAI Grokとチャットを行う。

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
	
