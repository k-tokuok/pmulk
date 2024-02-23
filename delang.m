detangle multi-language file to mono-language file
$Id: mulk delang.m 932 2022-09-18 Sun 17:45:15 kt $
#ja 多言語ファイルから単言語ファイルへの変換

*[man]
**#en
.caption SYNOPSIS
	delang [LANG]
.caption DESCRIPTION
Read multi-language module file or mm file and output LANG language mono-language file.

If LANG is omitted, it is assumed that Mulk.lang has been specified.
**#ja
.caption 書式
	delang [LANG]
.caption 説明
多言語のモジュールファイル又はmmファイルを読み込み、LANG言語の単言語ファイルを出力する。

LANGを省略すると、Mulk.langが指定されたものとみなす。

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
