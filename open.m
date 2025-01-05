opens a file or url in the host OS
$Id: mulk open.m 1339 2024-12-26 Thu 21:56:19 kt $
#ja ホストOSでファイルまたはURLを開く

*[man]
**#en
.caption SYNOPSIS
	open [ARG]
.caption DESCRIPTION
Opens the file or URL specified by the argument in the corresponding application of the host OS.

If ARG is omitted, the current directory is targeted.
.caption LIMITATION
Only URL is supported on Android.

**#ja
.caption 書式
	open [ARG]
.caption 説明
引数で指定されたファイル又はURLをホストOSの対応したアプリケーションで開く。

ARGを省略した場合、カレントディレクトリを対象とする。
.caption 制限事項
AndroidではURLのみ対応。

*open tool.@
	Object addSubclass: #Cmd.open
	
**Cmd.open >> url?: arg
	arg heads?: "http:", or: [arg heads?: "https:"]!
	
**Mulk.hostOS = #android >
***@
	Android method: #openUrl signature: "VS"
***Cmd.open >> main: args
	args first ->:url;
	self url?: url, ifFalse: [self error: "Android supports only url"];
	Android call: #openUrl with: url

**Mulk.hostOS <> #android >
***Cmd.open >> openCmd
	Mulk.hostOS = #linux | (Mulk.hostOS = #freebsd) ifTrue: ["xdg-open"!];
	Mulk.hostOS = #windows ifTrue: ["start \"\""!];
	Mulk.hostOS = #macosx ifTrue: ["open"!];
	self error: "no open command"
***Cmd.open >> main: args
	args empty? ifTrue: ["."] ifFalse: [args first] ->:arg;
	self url?: arg, ifFalse: [arg asFile hostPath ->arg];
	
	OS system: self openCmd + " \"" + arg + '"'
