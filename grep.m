output lines that match a regular expression
$Id: mulk grep.m 1125 2023-11-02 Thu 22:01:20 kt $
#ja 正規表現にマッチする行を出力する

*[man]
**#en
.caption SYNOPSIS
	grep [OPTION] PATTERN [FORMAT]
.caption DESCRIPTION
Search the standard input for a line that matches the regular expression PATTERN, and output it to the standard output.

If the FORMAT is specified, the specified string is output instead of the matched line.
At this time, the part of "#N" in the specified character string is replaced with the contents of the N-th mark pair in the regular expression.
Only one digit can be specified for N.
.caption OPTION
	e -- Print lines that do not match the pattern.
	n -- Output line number
	f -- Search for each file using standard input as the file name string
	c -- Match uppercase letters to lowercase letters.
	C COLUMN -- Matches after the COLUMN character in the input line.
	F FIELD -- The input is regarded as CSV, and FIELD is the target of the match.
	a -- ASCII mode. Matches multibyte characters byte by byte.
.caption SEE ALSO
.summary regexp
.summary csvrd
**#ja
.caption 書式
	grep [option] パターン [出力形式]
.caption 説明
標準入力から正規表現のパターンにマッチする行を検索し、標準出力へ出力する。

出力形式を指定した場合はマッチした行の代わりに指定の文字列を出力する。
この時、指定文字列中の"#n"の部位を、正規表現中のn番目のマークのペアの内容で置き換える。
nは一桁の数値のみ指定可能。
.caption オプション
	e -- パターンにマッチしない行を出力する。
	n -- 行番号を出力する。
	f -- 標準入力をファイル名列として、それぞれのファイルに対して検索する。
	c -- 英小文字に対し大文字もマッチさせる。
	C COLUMN -- 入力行のCOLUMN文字目以降をマッチの対象とする。
	F FIELD -- 入力をCSVとみなし、FIELDをマッチの対象とする。
	a -- ASCIIモード。マルチバイト文字をバイト単位でマッチする。
	
.caption 関連項目
.summary regexp
.summary csvrd

*grep tool.@
	Mulk import: #("optparse" "regexp" "csvrd");
	Object addSubclass: #Cmd.grep instanceVars: 
		"exclude? lineNumber? file? fn re output csvrd field column"
**Cmd.grep >> convert: s
	StringWriter new ->:w;
	AheadReader new init: output ->:r;
	[r nextChar ->:ch, notNil?] whileTrue:
		[ch = '#'
			ifTrue:
				[r skipChar;
				r skipChar asNumericValue: 10 ->:no;
				re matchMarkPosAt: no * 2 ->:st;
				re matchMarkPosAt: no * 2 + 1 ->:en;
				w put: (s copyFrom: st until: en)]
			ifFalse: [w put: r skipChar]];
	w asString!
**Cmd.grep >> main
	1 ->:n;
	In contentLinesDo:
		[:s
		s ->:key;
		field notNil? ifTrue:
			[csvrd parseRecord: key ->:array;
			field < array size ifTrue: [array at: field] ifFalse: [""] ->key];
		column notNil? ifTrue: 
			[column < key size ifTrue: [key copyFrom: field] ifFalse: [""]
				 ->key];
		re match: key, <> exclude? ifTrue:
			[file? ifTrue: [Out put: fn, put: ':'];
			lineNumber? ifTrue: [Out put: n, put: ':'];
			output notNil? ifTrue: [self convert: s ->s];
			Out putLn: s];
		n + 1 ->n]
**Cmd.grep >> main: args
	OptionParser new init: "enfcF:C:a" ->:op, parse: args ->args;
	op at: 'e' ->exclude?;
	op at: 'n' ->lineNumber?;
	op at: 'f' ->file?;
	op at: 'F' ->:opt, notNil? ifTrue:
		[CsvReader new ->csvrd;
		opt asInteger ->field];
	op at: 'C' ->opt, notNil? ifTrue: [opt asInteger ->column];

	RegExp new ->re;
	op at: 'c', ifTrue: [re caseInsensitive];
	op at: 'a', ifTrue: [re ascii];
	re compile: args first;
	args size = 2 ifTrue: [args at: 1 ->output];
	
	file?
		ifTrue:
			[In contentLinesDo:
				[:f f ->fn;
				fn asFile pipe: [self main] to: Out]]
		ifFalse:
			[self main]
