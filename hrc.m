HttpRequest.c class
$Id: mulk hrc.m 787 2021-12-05 Sun 14:16:49 kt $
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
	"-s -L" ->option
**HttpRequest.c >> header: keyArg value: valueArg
	option + " -H \"" + keyArg + ": " + valueArg + '"' ->option
**HttpRequest.c >> run
	dataFile notNil? ifTrue:
		[data close;
		option + " --data-binary @" + dataFile hostPath ->option];
	method notNil? ifTrue: [option + " -X " + method ->option];
	outFile notNil? 
		ifTrue: [option + " -o " + outFile quotedHostPath ->option];
	"os " ->:cmdstr;
	Mulk.hostOS = #windows ifTrue: 
		[cmdstr + " c:\\windows\\system32\\" ->cmdstr];
	cmdstr + "curl " + option + ' ' + url ->cmdstr;
	verbose? ifTrue: [Out putLn: "HttpRequest: " + cmdstr];
	cmdstr runCmd;
	dataFile notNil? ifTrue: [dataFile remove];
	1! --general success.
