DeepL Translate
$Id: mulk dtrans.m 1618 2026-06-25 Thu 22:39:11 kt $
#ja DeepL翻訳

*[man]
**#en
.caption SYNOPSIS
	dtrans targetLanguageCode
.caption DESCRIPTION
Translate the input document using DeepL Translate API.

Register with DeepL API Free in advance and set the authentication key to Cmd.dtrans.authKey in the Mulk dictionary.
.caption EXAMPLE
	dtrans JA -- Translate from any language to Japanese.
**#ja
.caption 書式
	dtrans 翻訳先言語コード
.caption 説明
DeepL翻訳APIを使用して入力した文書を翻訳する。

事前にDeepL API Freeに登録し、認証キーをMulk辞書のCmd.dtrans.authKeyに設定しておくこと。
.caption 例
	dtrans JA -- 任意の言語から日本語に翻訳する。
	
*dtrans tool.@
	Mulk import: #("tempfile" "hrlib" "jsonrd" "jsonwr");
	Object addSubclass: #Cmd.dtrans
**Cmd.dtrans >> main: args
	args first ->:target;
	StringWriter new ->:wr;
	"cat" pipe contentBytes asString ->:text;
	HttpRequestFactory new create ->:hr;
	hr method: "POST";
	hr url: "https://api-free.deepl.com/v2/translate";
	hr header: "Authorization" value: "DeepL-Auth-Key " + Cmd.dtrans.authKey;
	hr header: "Content-Type" value: "application/json";
	hr openData;
	Dictionary new ->:data;
	data at: "text" put: (Array new addLast: text);
	data at: "target_lang" put: target;
	JsonWriter new write: data to: hr data;
	TempFile create ->:outFile;
	hr outFile: outFile;
	hr run;
	outFile pipe: [JsonReader new read: In ->:json];
	Out put: (json at: "translations", first at: "text");
	
	outFile remove
