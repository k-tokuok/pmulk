http communication library
$Id: mulk hrlib.m 956 2022-10-22 Sat 22:34:12 kt $
#ja http通信ライブラリ

*[man]
**#en
.caption DESCRIPTION
Library that communicates by http.
**#ja
.caption 説明
httpによる通信を行うライブラリ。

*import.@
	Mulk import: #("tempfile" "random")
	
*HttpRequest class.@
	Object addSubclass: #HttpRequest instanceVars: 
		"url method verbose? outFile dataFile data boundary"
**[man.c]
***#en
Send and receive once with http.
***#ja
httpによる一度の送受信を行う。

**HttpRequest >> init
	false ->verbose?
	
**HttpRequest >> verbose
	true ->verbose?
***[man.m]
****#en
Display processings verbosely.
****#ja
処理を詳細に表示する。

**HttpRequest >> url: urlArg
	urlArg ->url
***[man.m]
****#en
Specify the URL of the communication destination.

This argument is essential.
****#ja
通信先のURLを指定する。

この設定は必須となる。

**HttpRequest >> method: methodArg
	methodArg ->method
***[man.m]
****#en
Specify the method.

If omitted, GET communication is performed.
****#ja
メソッドを指定する。

省略時はGETでの通信を行う。

**HttpRequest >> header: keyArg value: valueArg
	self shouldBeImplemented
***[man.m]
****#en
Add header fields.
****#ja
ヘッダーフィールドを追加する。

**HttpRequest >> outFile: fileArg
	fileArg ->outFile
***[man.m]
****#en
Specify the file to save the received text.
****#ja
受信本文の保存先ファイルを指定する。

**post url encoded form
***HttpRequest >> openData
	TempFile create ->dataFile;
	dataFile openWrite ->data
****[man.m]
*****#en
Start to prescribe the transmission data.
*****#ja
送信データの設定を開始する。

***HttpRequest >> param: paramArg value: valueArg
	data tell <> 0 ifTrue: [data put: '&'];
	data put: paramArg + '=' + valueArg -- require encode
****[man.m]
*****#en
Add form-formatted parameter name and value to send data.
*****#ja
送信データにフォーム形式のパラメータ名と値を追加する。

**post multipart
***HttpRequest >> openMultipart
	self openData;
	"**BOUNDARY-" + (Random int32 asHexString0: 8) + "**" ->boundary;
	self header: "Content-Type" value: "multipart/form-data; boundary=" 
		+ boundary
****[man.m]
*****#en
Start to prescribe transmission data in multipart format.
*****#ja
マルチパート形式での送信データの設定を開始する。

***HttpRequest >> putLn
	data putByte: '\r' code, putByte: '\n' code
****[man.m]
*****#en
Add a blank line to the sent data.
*****#ja
送信データに空行を追加する。

***HttpRequest >> putLn: str
	data put: str;
	self putLn
****[man.m]
*****#en
Add one line to the transmitted data.
*****#ja
送信データに1行追加する。

***HttpRequest >> putBoundary
	self putLn: "--" + boundary
****[man.m]
*****#en
Add a part boundary to the transmitted data.
*****#ja
送信データにパートの区切りを追加する。

***HttpRequest >> data
	data!
****[man.m]
*****#en
Returns a stream of transmitted data.
*****#ja
送信データのストリームを返す。

**HttpRequest >> run
	self shouldBeImplemented
***[man.m]
****#en
Communicate according to the theory.

The communication is synchronous and returns from the method when the communication ends.
****#ja
設定に従って通信を行う。

通信は同期式で、通信が終わるとメソッドから戻る。

*HttpRequestFactory class.@
	Object addSubclass: #HttpRequestFactory
**[man.c]
***#en
Factory class.
***#ja
ファクトリークラス

**HttpRequestFactory >> create
	Mulk.hostOS = #android ifTrue: ["a"] ifFalse: ["c"] ->:name;
	Mulk at: ("HttpRequest." + name) asSymbol in: "hr" + name, new!
***[man.m]
****#en
Constructs and returns an instance of the HttpRequst class.
****#ja
HttpRequstクラスのインスタンスを構築して返す。
