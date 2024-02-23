deepl translation
$Id: mulk dtrans.m 1126 2023-11-03 Fri 22:35:43 kt $
#ja deepl翻訳

*[man]
**#en
.caption SYNOPSIS
	dtrans targetLanguageCode
.caption DESCRIPTION
Translate the input document using deepL's translation api.

Register with DeepL API Free in advance and set the authentication key to Cmd.dtrans.authKey in the Mulk dictionary.
.caption EXAMPLE
	dtrans JA -- Translate from any language to Japanese.
**#ja
.caption 書式
	dtrans 翻訳先言語コード
.caption 説明
deepLの翻訳apiを使用して入力した文書を翻訳する。

事前にDeepL API Freeに登録し、認証キーをMulk辞書のCmd.dtrans.authKeyに設定しておくこと。
.caption 例
	dtrans JA -- 任意の言語から日本語に翻訳する。
	
*dtrans tool.@
	Mulk import: #("tempfile" "hrlib" "jsonrd" "urlenc");
	Object addSubclass: #Cmd.dtrans instanceVars: "target"
**Cmd.dtrans >> translate
	In contentBytes ->:text, empty? ifTrue: [self error: "text empty"];
	HttpRequestFactory new create ->:hr;
	hr method: "POST";
	hr url: "https://api-free.deepl.com/v2/translate?target_lang="
		+ target + "&text=" + text urlEncode;
	hr header: "Authorization" value: "DeepL-Auth-Key " + Cmd.dtrans.authKey;
	TempFile create ->:outFile;
	hr outFile: outFile;
	hr run;
	outFile readDo: [:fs JsonReader new init: fs, read ->:json];
	Out put: (json at: "translations", first at: "text");
	outFile remove
**Cmd.dtrans >> main: args
	args first ->target;
	Mulk.charset = #sjis 
		ifTrue: 
			["cat | ctr u" pipe: [self translate], pipe: "ctr u =" to: Out]
		ifFalse: ["cat" pipe: [self translate] to: Out]
