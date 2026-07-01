ai chat translate
$Id: mulk atrans.m 1617 2026-06-21 Sun 22:35:04 kt $
#ja AIチャット翻訳

*[man] 
**#en
.caption SYNOPSIS
	atrans TargetLanguage(English)
.caption DESCRIPTION
Translate documents entered using the AI chat service.

The commands in the system dictionary 'Cmd.atrans.cmd' are used for translation.
By default, 'gemini' is used.
For configuration details, refer to the relevant section.
.caption EXAMPLE
	atrans English -- Translate the input into English
.caption SEE ALSO
.summary aichat
**#ja
.caption 書式
	atrans 翻訳先言語名(英語表記)
.caption 説明
AIチャットサービスを使用して入力した文書を翻訳する。

翻訳の際はシステム辞書Cmd.atrans.cmdのコマンドが使用される。
デフォルトではgeminiを使用する。
設定については当該項目を参照のこと。
.caption 例
	atrans English -- 入力内容を英語に翻訳する
.caption 関連項目
.summary aichat

*atrans tool.@
	Mulk addGlobalVar: #Cmd.atrans.cmd, set: "gemini.batch";
	Object addSubclass: #Cmd.atrans
**Cmd.atrans >> main: args
	[Out putLn: "Please translate the following text into " + args first
		+ " and return only the result.\n--";
	"cat" runCmd] pipe: Cmd.atrans.cmd, pipeTo: Out
