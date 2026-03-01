system file search path
$Id: mulk path.m 1543 2026-02-21 Sat 20:57:29 kt $
#ja システムファイル検索パス

*[man]
**#en
.caption SYNOPSIS
	path [OPTION] [PATH...]
.caption DESCRIPTION
Adds the PATH list to the additional system file search path list (Mulk.extraSystemDirectories) in the specified order and outputs the list.
These will be the target of searches for libraries, loading system files, and command class modules.
.caption OPTION
	c -- clear additional paths.
	r -- remove the specified path.
	s -- suppress the output of the path list.
**#ja
.caption 書式
	path [OPTION] [PATH...]
.caption 説明
PATHリストを指定の順序でシステムファイルの追加検索パスリスト(Mulk.extraSystemDirectories)に追加し、一覧を出力する。
これらはライブラリやシステムファイルの読み込み、コマンドクラスモジュールの検索の対象となる。
.caption オプション
	c -- 全ての追加パスを消去する。
	r -- 指定のパスを削除する。
	s -- パスの一覧出力を抑止する。
	
*path tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.path
**Cmd.path >> main: args
	OptionParser new init: "crs" ->:op, parse: args ->args;
	Mulk.extraSystemDirectories ->:paths;
	op at: 'c', ifTrue: [Array new ->paths];
	args collectAsArray: [:p p asFile] ->args;
	args do: [:p2 paths indexOf: p2 ->:i, notNil? ifTrue: [paths removeAt: i]];
	op at: 'r', ifFalse: [args reverse do: [:p3 paths addFirst: p3]];
	op at: 's', ifFalse:
		[paths do: [:p4 Out putLn: p4 path];
		Out putLn: Mulk.systemDirectory path];
	paths ->Mulk.extraSystemDirectories
