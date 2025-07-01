download by http
$Id: mulk hr.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja httpによるダウンロード
*[man]
**#en
.caption SYNOPSIS
	hr URL [FILE]
.caption DESCRIPTION
Download the resource indicated by URL and output to FILE.

If FILE is omitted, it will output to standard output.
.caption SEE ALSO
.summary hrlib
**#ja
.caption 書式
	hr URL [FILE]
.caption 説明
URLで示されるリソースをダウンロードし、FILEへ出力する。

FILEを省略すると標準出力に出力する。
.caption 関連項目
.summary hrlib

*hr tool.@
	Mulk import: #("tempfile" "hrlib");
	Object addSubclass: #Cmd.hr
**Cmd.hr >> main: args
	HttpRequestFactory new create ->:hr;
	hr url: args first;
	args size = 1 ->:out?, 
		ifTrue: [TempFile create] ifFalse: [args at: 1, asFile] ->:outFile;
	hr outFile: outFile;
	hr run;
	out? ifTrue:
		[outFile pipe: "cat" to: Out;
		outFile remove]
