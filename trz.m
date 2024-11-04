全角文字の置換
$Id: mulk trz.m 1141 2023-12-02 Sat 14:15:46 kt $

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
