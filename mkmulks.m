standalone Mulk build utility
$Id: mulk mkmulks.m 1212 2024-04-14 Sun 20:49:24 kt $
#ja スタンドアロンMulkの構築ユーティリティ

*[man]
**#en
.caption SYNOPSIS
	mkmulks
.caption DESCRIPTION
Input binary and output C language char array initialization description.

This is called from the makefile to embed the image in the standalone Mulk executable.
**#ja
.caption 書式
	mkmulks
.caption 説明
バイナリを入力し、C言語のchar配列初期化記述を出力する。

これはスタンドアロン版Mulkの実行モジュールにイメージを埋め込む為に、makefileから呼び出される。

*mkmulks tool.@
	Object addSubclass: #Cmd.mkmulks
**Cmd.mkmulks >> main: args
	Out putLn: "static char image[]={";

	FixedByteArray basicNew: 8 ->:buf;
	[In read: buf ->:size, <> 0] whileTrue:
		[Out put: "\t";
		size timesDo: [:i Out put: "0x" + (buf at: i, asHexString0: 2) + ", "];
		Out putLn];

	Out putLn: "};"
