output a line of text
$Id: mulk echo.m 406 2020-04-19 Sun 11:29:54 kt $
#ja テキスト行の出力

*[man]
**#en
.caption SYNOPSIS
	echo [OPTION] [STRING...]
.caption DESCRIPTION
Outputs the argument string to the standard output.
Escape sequences in strings are interpreted.
.caption OPTION
	n -- Do not output trailing newline.
	l -- Break line after each argument.
**#ja
.caption 書式
	echo [OPTION] [STRING...]
.caption 説明
引数文字列を標準出力へ出力する。
文字列中のエスケープシーケンスは解釈される。
.caption オプション
	n -- 末尾の改行を出力しない。
	l -- 引数毎に改行する。

*echo tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.echo
**Cmd.echo >> main: args
	OptionParser new init: "nl" ->:op, parse: args ->args;
	op at: 'n' ->:noTrailNewline?;
	op at: 'l' ->:line?;
		
	args
		do:
			[:arg
			AheadReader new init: arg ->:r;
			[r nextChar notNil?] whileTrue: [Out put: r skipWideEscapeChar]]
		separatedBy:
			[line?
				ifTrue: [Out putLn]
				ifFalse: [Out put: ' ']];
	noTrailNewline? ifFalse: [Out putLn]
