system file search path
$Id: mulk path.m 1468 2025-08-19 Tue 20:52:07 kt $
#ja システムファイル検索パス

*[man]
**#en
.caption SYNOPSIS
	path [OPTION] [PATH...]
.caption DESCRIPTION
Add the PATH list to the search path for system files in the specified order.
These will be the target of searches for libraries, loading system files, and command class modules.
.caption OPTION
	c -- reset additional paths.
	r -- delete the specified path.
	l -- display a list of paths.
**#ja
.caption 書式
	path [OPTION] [PATH...]
.caption 説明
PATHリストを指定の順序でシステムファイルの検索パスに追加する。
これらはライブラリやシステムファイルの読み込み、コマンドクラスモジュールの検索の対象となる。
.caption オプション
	c -- 追加パスをリセットする。
	r -- 指定のパスを削除する。
	l -- パスの一覧を表示する。
	
*path tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.path
**Cmd.path >> main: args
	OptionParser new init: "crl" ->:op, parse: args ->args;
	Mulk.extraSystemDirectories ->:paths;
	op at: 'c', ifTrue: [Array new ->paths];
	args collectAsArray: [:p p asFile] ->args;
	args do: [:p2 paths indexOf: p2 ->:i, notNil? ifTrue: [paths removeAt: i]];
	op at: 'r', ifFalse: [args reverse do: [:p3 paths addFirst: p3]];
	op at: 'l', ifTrue:
		[paths do: [:p4 Out putLn: p4 path];
		Out putLn: Mulk.systemDirectory path];
	paths ->Mulk.extraSystemDirectories
