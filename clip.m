command line interface to clipboard
$Id: mulk clip.m 934 2022-09-19 Mon 21:10:16 kt $
#ja クリップボードへのコマンドラインインタフェース

*[man]
**#en
.caption SYNOPSIS
	clip.get -- Read from clipboard
	clip.put -- Write to clipboard
.caption DESCRIPTION
Reads and writes to the clipboard via standard input / output.

The content must be text data in host OS format.m
.caption SEE ALSO
.summary cliplib
**#ja
.caption 書式
	clip.get -- クリップボードからの読み込み
	clip.put -- クリップボードへの書き込み
.caption 説明
標準入出力を介してクリップボードへの読み書きを行う。

内容はホストOS形式のテキストデータでなければならない。
.caption 関連項目
.summary cliplib

*clip tool.@
	Mulk import: "cliplib";
	Object addSubclass: #Cmd.clip
**Cmd.clip >> main.get: args
	Clip copyTo: Out
**Cmd.clip >> main.put: args
	Clip copyFrom: "cat" pipe
