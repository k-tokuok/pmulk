Google Translate (app script)
$Id: mulk gatrans.m 1616 2026-06-20 Sat 21:45:50 kt $
#ja Google翻訳 (app script)

*[man]
**#en
.caption SYNOPSIS
	gatrans sourceLanguageCode targetLanguageCode
.caption DESCRIPTION
Use the Google Translate service from App Script to translate the text you've entered.

To translate, create the following web service at https://script.google.com.

	function doGet(e) {
	  var p = e.parameter;
	  var translatedText = LanguageApp.translate(p.text, p.source, p.target);
	  return ContentService.createTextOutput(translatedText);
	}
	
Make this service publicly executable by anonymous users and put the URL in the Mulk dictionary "Cmd.gatrans.service".
.caption EXAMPLE
	gatrans en ja -- Translate from English to Japanese.
**#ja
.caption 書式
	gatrans 翻訳元言語コード 翻訳先言語コード
.caption 説明
App ScriptからGoogle翻訳サービスを使用して入力した文章を翻訳する。

翻訳を行うにはhttps://script.google.comで次のwebサービスを作成する。

	function doGet(e) {
	  var p = e.parameter;
	  var translatedText = LanguageApp.translate(p.text, p.source, p.target);
	  return ContentService.createTextOutput(translatedText);
	}

このサービスを匿名ユーザーから実行可能に公開し、URLをMulk辞書の"Cmd.gatrans.service"に設定する。
.caption 例
	gatrans en ja -- 英語から日本語に翻訳する。
	
*gatrans tool.@
	Mulk import: "urlenc";
	Object addSubclass: #Cmd.gatrans instanceVars: "source target"
**Cmd.gatrans >> translate
	In contentBytes ->:text, empty? ifTrue: [self error: "text empty"];
	StringWriter new,
		put: "hr ",
		put: Cmd.gatrans.service,
		put: "?text=", put: text urlEncode,
		put: "&source=", put: source,
		put: "&target=", put: target,
		asString runCmd
**Cmd.gatrans >> main: args
	args first ->source;
	args at: 1 ->target;
	Mulk.charset = #sjis
		ifTrue: 
			["cat | ctr u" pipe: [self translate], pipe: "ctr u =" to: Out]
		ifFalse: ["cat" pipe: [self translate] to: Out]
