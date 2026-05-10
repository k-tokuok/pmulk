HttpRequest.a class
$Id: mulk hra.m 1596 2026-05-08 Fri 15:42:46 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Android implementation of HttpRequest.
.caption SEE ALSO
.summary hrlib
**#ja
.caption 説明
HttpRequestのAndroid実装。
.caption 関連項目
.summary hrlib

*import.@
	Mulk import: #("hr" "tempfile")
	
*HttpRequest.a class.@
	Android method: #hra signature: "ISSSSSI";
	HttpRequest addSubclass: #HttpRequest.a instanceVars: 
		"method headers timeout"
**HttpRequest.a >> init
	super init;
	"GET" ->method;
	"" ->headers;
	0 ->timeout
**HttpRequest.a >> timeout: arg
	arg ->timeout
**HttpRequest.a >> method: arg
	arg ->method
**HttpRequest.a >> header: keyArg value: valueArg
	headers + keyArg + '\n' + valueArg + '\n' ->headers
**HttpRequest.a >> pathStr: fileArg
	fileArg nil? ifTrue: [nil] ifFalse: [fileArg path]!
**HttpRequest.a >> run
	dataFile notNil? ifTrue: [data close];
	outFile kindOf?: Android.File, ifTrue:
		[outFile ->:realOutFile;
		TempFile create ->outFile];
	Android call: #hra with: method with: url with: headers with:
		(self pathStr: dataFile) with: (self pathStr: outFile) 
		with: timeout ->:st;
	st = 0 ifTrue: [self error: "HttpRequest.a >> run failed"];
	dataFile notNil? ifTrue: [dataFile remove];
	realOutFile notNil? ifTrue:
		[outFile pipeTo: realOutFile;
		outFile remove];
	st!
