output lines that match a fixed string
$Id: mulk fgrep.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 固定文字列にマッチする行を出力する

*[man]
**#en
.caption SYNOPSIS
	fgrep [OPTION] STRING
.caption DESCRIPTION
Search the line containing the STRING from the standard input by the Boyer-Moore method and output it to the standard output.

Unlike grep, you can't use regular expressions, but it's faster.

If you add '^' at the beginning of a character string, only those with a character string at the beginning of the line will be searched.
To search for a string starting with '^', escape with '\'.
.caption OPTION
	n -- Output the line number in the standard input.
	f -- Search for each file using standard input as a file name string.
**#ja
.caption 書式
	fgrep [option] 文字列
.caption 説明
標準入力から文字列が含まれる行をBoyer-Moore法で検索し、標準出力へ出力する。

grepと異なり正規表現は使えないが、より高速。

文字列の先頭に'^'を付けると、行頭に文字列があるもののみ検索する。
'^'で始まる文字列を検索する場合は'\'でエスケープする。

.caption オプション
	n -- 標準入力における行番号を出力する。
	f -- 標準入力をファイル名列として、それぞれのファイルに対して検索する。

*fgrep tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.fgrep instanceVars:
		"pat pattail patsize skip matchBlock lineNo? file? fileName"
**Cmd.fgrep >> match?: s
	s size ->:slen;
	patsize - 1 ->:i;
	[i < slen] whileTrue:
		[s basicAt: i ->:ch;
		ch = pattail ifTrue:
			[patsize - 1 ->:j;
			i ->:k;
			[j - 1 ->j, = -1 ifTrue: [true!];
			k - 1 ->k;
			(pat basicAt: j) = (s basicAt: k)] whileTrue];
		i + (skip at: ch) ->i];
	false!
**Cmd.fgrep >> prepare: patArg
	patArg ->pat;
	pat first = '^' ifTrue:
		[pat copyFrom: 1 ->pat;
		[:s2 s2 heads?: pat] ->matchBlock!];
	pat first = '\\' ifTrue: [pat copyFrom: 1 ->pat];
	pat size ->patsize;
	patsize = 1 ifTrue:
		[pat first ->:firstCh;
		[:s3 s3 includes?: firstCh] ->matchBlock!];
	FixedArray basicNew: 256, fill: patsize ->skip;
	pat basicAt: patsize - 1 ->pattail;
	patsize - 1 timesDo:
		[:i skip at: (pat basicAt: i) put: patsize - i - 1];
	[:s self match?: s] ->matchBlock
**Cmd.fgrep >> sweep
	1 ->:n;
	In contentLinesDo:
		[:s
		matchBlock value: s, ifTrue:
			[file? ifTrue: [Out put: fileName, put: ':'];
			lineNo? ifTrue: [Out put: n, put: ':'];
			Out putLn: s];
		n + 1 ->n]
**Cmd.fgrep >> main: args
	OptionParser new init: "nf" ->:op, parse: args ->args;
	op at: 'n' ->lineNo?;
	op at: 'f' ->file?;
	
	self prepare: args first;
	file?
		ifTrue:
			[In contentLinesDo:
				[:f
				f ->fileName, asFile pipe: [self sweep] to: Out]]
		ifFalse: [self sweep]
