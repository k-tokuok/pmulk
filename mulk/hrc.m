HttpRequest.c class
$Id: mulk hrc.m 1537 2026-02-06 Fri 14:08:22 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Implementation by curl command of HttpRequest.

When using a proxy server, set the URL in the environment variables http_proxy and https_proxy.
.caption SEE ALSO
.summary hrlib
**#ja
.caption 説明
HttpRequestのcurlコマンドによる実装。

プロキシサーバーを経由する場合は環境変数のhttp_proxy及びhttps_proxyにURLを設定する。
.caption 関連項目
.summary hrlib

*HttpRequest.c class.@
	HttpRequest addSubclass: #HttpRequest.c instanceVars: "option"
**HttpRequest.c >> init
	super init;
	"-s -L -w '%{http_code}\\n'" ->option
**HttpRequest.c >> method: arg
	option + " -X " + arg ->option
**HttpRequest.c >> header: keyArg value: valueArg
	option + " -H \"" + keyArg + ": " + valueArg + '"' ->option
**HttpRequest.c >> run
	dataFile notNil? ifTrue:
		[data close;
		option + " --data-binary @" + dataFile hostPath ->option];
	outFile nil? 
		ifTrue: [Mulk.hostOS = #windows ifTrue: ["nul"] ifFalse: ["/dev/null"]]
		ifFalse: [outFile quotedHostPath] ->:outPath;
	option + " -o " + outPath ->option;

	"os " ->:cmdstr;
	Mulk.hostOS = #windows ifTrue: 
		[cmdstr + " c:\\windows\\system32\\" ->cmdstr];
	cmdstr + "curl " + option + ' ' + url ->cmdstr;
	verbose? ifTrue: [Out putLn: "HttpRequest: " + cmdstr];
	[cmdstr runCmd] pipe: [In getLn asInteger ->:st];
	dataFile notNil? ifTrue: [dataFile remove];
	st!
