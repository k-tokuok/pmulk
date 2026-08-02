AIチャットかな漢字変換
$Id: mulk akk.m 1623 2026-07-19 Sun 20:48:51 kt $

*[man]
.caption 書式
	akk
.caption 説明
AIチャットサービスを使用して入力の仮名漢字変換を行う。

AIチャットサービスはシステム辞書のCmd.akk.cmdのものが使用される。
デフォルトではgeminiを使用する。
設定については当該項目を参照のこと。
.caption 関連項目
.summary aichat

*akk tool.@
	Mulk addGlobalVar: #Cmd.akk.cmd, set: "gemini.batch";
	Object addSubclass: #Cmd.akk
**Cmd.akk >> main: args
	[Out putLn: "以下を仮名漢字変換してください。\n"
	+ "結果のみを出力し、複数の候補がある場合は上位3つまでに絞ってください。\n"
	+ "--";
	"cat" runCmd] pipe: Cmd.akk.cmd to: Out
