load module file
$Id: mulk ld.m 406 2020-04-19 Sun 11:29:54 kt $
#ja モジュールファイルの読み込み

*[man]
**#en
.caption SYNOPSIS
	ld [[OPTION] FILE...]
.caption DESCRIPTION
Load the specified module file.

If the file name is omitted, load the contents of standard input.
.caption OPTION
	s -- Load a file under the system directory.
**#ja
.caption 書式
	ld [[option] file...]
.caption 説明
指定されたモジュールファイルを読み込む。

ファイル名が省略された場合は標準入力の内容が読み込まれる。
.caption オプション
	s -- システムディレクトリ下のファイルを読み込む。

*ld tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.ld
**Cmd.ld >> main: args
	args empty?
		ifTrue: [Loader new loadReader: In]
		ifFalse:
			[OptionParser new init: "s" ->:op, parse: args ->args;
			op at: 's',
				ifTrue: [#asSystemFile]
				ifFalse: [#asFile] ->:selector;
			args do: [:fn Mulk loadFile: (fn perform: selector)]]
