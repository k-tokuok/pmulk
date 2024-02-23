google translation
$Id: mulk gtrans.m 1104 2023-09-10 Sun 20:37:24 kt $
#ja google翻訳

*[man]
**#en
.caption SYNOPSIS
	gtrans sourceLanguageCode targetLanguageCode
.caption DESCRIPTION
Translate the input text using google's translation service.

To translate, create the following web service at https://script.google.com.

	function doGet(e) {
	  var p = e.parameter;
	  var translatedText = LanguageApp.translate(p.text, p.source, p.target);
	  return ContentService.createTextOutput(translatedText);
	}
Make this service publicly executable by anonymous users and put the URL in the Mulk dictionary "Cmd.gtrans.service".
.caption EXAMPLE
	gtrans en ja -- Translate from English to Japanese.
**#ja
.caption 書式
	gtrans 翻訳元言語コード 翻訳先言語コード
.caption 説明
googleの翻訳サービスを使用して入力した文章を翻訳する。

翻訳を行うにはhttps://script.google.comで次のwebサービスを作成する。

	function doGet(e) {
	  var p = e.parameter;
	  var translatedText = LanguageApp.translate(p.text, p.source, p.target);
	  return ContentService.createTextOutput(translatedText);
	}

このサービスを匿名ユーザーから実行可能に公開し、URLをMulk辞書の"Cmd.gtrans.service"に設定する。
.caption 例
	gtrans en ja -- 英語から日本語に翻訳する。
	
*gtrans tool.@
	Mulk import: "urlenc";
	Object addSubclass: #Cmd.gtrans instanceVars: "source target"
**Cmd.gtrans >> translate
	In contentBytes ->:text, empty? ifTrue: [self error: "text empty"];
	StringWriter new,
		put: "hr ",
		put: Cmd.gtrans.service,
		put: "?text=", put: text urlEncode,
		put: "&source=", put: source,
		put: "&target=", put: target,
		asString runCmd
**Cmd.gtrans >> main: args
	args first ->source;
	args at: 1 ->target;
	Mulk.charset = #sjis
		ifTrue: 
			["cat | ctr u" pipe: [self translate], pipe: "ctr u =" to: Out]
		ifFalse: ["cat" pipe: [self translate] to: Out]
