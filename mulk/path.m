system file search path
$Id: mulk path.m 1435 2025-06-06 Fri 16:09:23 kt $
#ja システムファイル検索パス

*[man]
**#en
.caption SYNOPSIS
	path [PATH...]
	path.reset -- reset additional paths
.caption DESCRIPTION
Adds the specified paths to the system file search path.
These paths are used for searching for libraries, system files, and command class modules.

If no PATH is specified, the current list of paths is displayed.
**#ja
.caption 書式
	path [PATH...]
	path.reset -- 追加のパスをリセット
.caption 説明
指定のパスをシステムファイルの検索パスに追加する。
これらはライブラリやシステムファイルの読み込み、コマンドクラスモジュールの検索の対象となる。

PATHを省略すると、現在のパスの一覧が表示される。

*path tool.@
	Object addSubclass: #Cmd.path
**Cmd.path >> main: args
	args empty? ifTrue:
		[Mulk.extraSystemDirectories do: [:p Out putLn: p path];
		Out putLn: Mulk.systemDirectory path!];
	
	args collectAsArray: [:f f asFile], addAll: Mulk.extraSystemDirectories
		->Mulk.extraSystemDirectories
**Cmd.path >> main.reset: args
	Array new ->Mulk.extraSystemDirectories
