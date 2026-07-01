Google Translate
$Id: mulk gtrans.m 1618 2026-06-25 Thu 22:39:11 kt $
#ja Google翻訳

*[man]
**#en
.caption SYNOPSIS
	gtrans TargetLanguageCode
.caption DESCRIPTION
Use the Google Cloud Platform translation service to translate the entered text.
Beforehand, you need to configure your project at https://console.cloud.google.com/ to enable the Cloud Translation API and set the API key in the system dictionary under Cmd.gtrans.apikey.
.caption EXAMPLE
	gtrand en -- Translate from any language into English
**#ja
.caption 書式
	gtrans 翻訳先言語コード
.caption 説明
Google Cloud Platformの翻訳サービスを使用して入力した文章を翻訳する。

事前にhttps://console.cloud.google.com/のプロジェクトから、Cloud Translation APIを使用できるよう設定し、APIキーをシステム辞書のCmd.gtrans.apikeyに設定しておく必要がある。
.caption 例
	gatrans en -- 任意の言語から英語に翻訳する
	
*gtrans tool.@
	Mulk import: #("jsonrd" "jsonwr");
	Object addSubclass: #Cmd.gtrans
**Cmd.gtrans >> main: args
	args first ->:target;
	In contentBytes asString ->:text;
	HttpRequestFactory new create ->:hr;
	hr method: "POST";
	hr url: "https://translation.googleapis.com/language/translate/v2?key="
		+ Cmd.gtrans.apikey;
	hr header: "Content-Type" value: "application/json";
	hr openData;
	Dictionary new ->:data;
	data at: "q" put: text;
	data at: "target" put: target;
	data at: "format" put: "text";
	JsonWriter new write: data to: hr data;
	TempFile create ->:outFile;
	hr outFile: outFile;
	hr run;
	outFile pipe: [JsonReader new read: In ->:json];
	Out put: (json at: "data", at: "translations", first, 
		at: "translatedText");
	outFile remove
