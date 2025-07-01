全角文字の置換
$Id: mulk trz.m 1433 2025-06-03 Tue 21:15:38 kt $

*[man]
.caption 書式
	trz
.caption 説明
対応するASCII文字のある全角文字をASCII文字に変換する。
.caption 関連項目
.summary tr

*trz tool.@
	Mulk at: #Cmd.tr in: "tr", addSubclass: #Cmd.trz
**Cmd.trz >> main: args
	self makeArray: "　！”＃＄％＆’（）＊＋，−．／０-９：；＜＝＞？＠Ａ-Ｚ［￥］＾＿｀ａ-ｚ｛｜｝〜" ->from;
	self makeArray: " !-~" ->to;
	self makeMap;
	self translate
