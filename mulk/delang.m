detangle multi-language file to mono-language file
$Id: mulk delang.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 多言語ファイルから単言語ファイルへの変換

*[man]
**#en
.caption SYNOPSIS
	delang [LANG]
.caption DESCRIPTION
Reads a multilingual module file or mm file and outputs the LANG language version.
If LANG is omitted, Mulk.lang is assumed to be specified.

Specific conversion details are as follows:

Language dependent version of the summary line (first line) -- Lines starting with '#' after the third line are the specific language version of the summary line. The language-specific version replaces the summary line, and the other language versions are deleted.

Language-dependent sections -- Blocks of outline lines beginning with '#' are language-dependent sections, and blocks of non-specified language versions are deleted.
.caption SEE ALSO
.summary lang
.summary man
**#ja
.caption 書式
	delang [LANG]
.caption 説明
多言語のモジュールファイル又はmmファイルを読み込み、LANG言語版のものを出力する。
LANGを省略すると、Mulk.langが指定されたものとみなす。

具体的な変換内容は以下の通り。

概要行(先頭行)の言語依存版 -- 3行目以降の'#'で始まる行群は概要行の特定言語版である。言語版で概要行を置き換えられ、他言語版は削除される。

言語依存部 -- '#'で始まるアウトライン行のブロックは言語依存部であり、指定言語版以外のブロックは削除される。
.caption 関連項目
.summary lang
.summary man

*delang tool.@
	Object addSubclass: #Cmd.delang instanceVars: "reader lang savedHeader"
**Cmd.delang >> readIdBlock
	reader getLn ->:summary;
	reader getLn ->:id;
	[reader getLn ->:ln, notNil? and: [ln head?: '#']] whileTrue:
		[ln size > 4 and: [ln copyFrom: 1 until: 3, = lang], ifTrue:
			[ln copyFrom: 4 ->summary]];
	Out putLn: summary;
	Out putLn: id;
	ln notNil? ifTrue:
		[Out putLn: ln;
		reader pipe: "cat" to: Out];
	reader nextBlock
**Cmd.delang >> readBody
	reader getLn; -- skip header
	reader pipe: "cat" to: Out;
	reader nextBlock
**Cmd.delang >> putHeader: header level: level
	Out put: '*' times: level;
	Out putLn: header
**Cmd.delang >> flushSavedHeader: level
	savedHeader notNil? ifTrue:
		[self putHeader: savedHeader level: level;
		nil ->savedHeader]
**Cmd.delang >> main: args
	args empty? ifTrue: [Mulk.lang] ifFalse: [args first] ->lang;
	OutlineReader new init: In ->reader;
	0 ->:langBlockLevel;
	self readIdBlock;
	[reader level ->:level, <> -1] whileTrue:
		[level <= langBlockLevel ifTrue: [0 ->langBlockLevel];
		reader header ->:h, size >= 3 and: [h first = '#'],
			ifTrue:
				[h copyFrom: 1, heads?: lang,
					ifTrue:
						[h size <= 4 
							ifTrue: [self flushSavedHeader: level - 1]
							ifFalse: 
								[self putHeader: (h copyFrom: 4) 
									level: level - 1;
								nil ->savedHeader];
						level ->langBlockLevel;
						self readBody]
					ifFalse: [reader nextSection]]
			ifFalse:
				[self flushSavedHeader: level - 1;
				langBlockLevel <> 0 ifTrue: [level - 1 ->level];
				h ->savedHeader;
				reader getLn; 
				reader contentLinesDo:
					[:ln
					self flushSavedHeader: level;
					Out putLn: ln];
				reader nextBlock]]
