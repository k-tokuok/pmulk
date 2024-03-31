character code conversion
$Id: mulk ctr.m 1179 2024-03-17 Sun 21:14:15 kt $
#ja 文字コード変換

*[man]
**#ja
**#en
.caption SYNOPSIS
	ctr [OPTION] [FROM] TO
.caption DESCRIPTION
Convert standard input character code and end-of-line code.

FROM and TO specify the conversion source and destination codes with two characters, the character code and the end-of-line code, respectively.

	character code
		u -- UTF-8
		s -- SJIS
		e -- EUC-JP
	end of line code
		n -- follows the behavior of putLn on the output stream.
		c -- CR/LF
		l -- LF
	
If '=' is specified for each, it follows the standard text specification of the host system.
If the end-of-line code is omitted, 'n' is assumed.
If FROM is omitted, '=' is assumed.
.caption OPTION
	f -- Read the file names and convert them.
.caption SEE ALSO
.summary ctrlib

**#ja
.caption 書式
	ctr [OPTION] [FROM] TO
.caption 説明
標準入力の文字コードと行末コードを変換する。

FROMとTOはそれぞれ変換元と変換先のコードを文字コードと行末コードの2文字で指定する。

	文字コード
		u -- UTF-8
		s -- SJIS
		e -- EUC-JP
	行末コード
		n -- 出力ストリームのputLnに動作に従う。
		c -- CR/LF
		l -- LF
	
それぞれ'='を指定した場合はホストシステムの標準テキスト仕様に従う。
行末コードを省略した場合は'n'が指定されたものと見做す。
FROMを省略した場合は'='が指定されたものと見做す。
.caption オプション
	f -- ファイル名列を入力し、それぞれのファイルを変換する。
.caption 関連項目
.summary ctrlib

*ctr tool.@
	Mulk import: #("ctrlib" "optparse");
	Object addSubclass: #Cmd.ctr instanceVars: "ctr putLn bytes"
**Cmd.ctr >> normalize: arg
	arg first ->:code, = '=' ifTrue:
		[Mulk.charset = #utf8 ifTrue: ['u'] ifFalse: ['s'] ->code];
	arg size = 1 
		ifTrue: ['n' ->:newline]
		ifFalse: 
			[arg at: 1 ->newline, = '=' ifTrue:
				[Mulk.newline = #lf ifTrue: ['l'] ifFalse: ['c'] ->newline]];
	code asString + newline!
**Cmd.ctr >> splitLineDo: block
	bytes size ->:size, = 0 ifTrue: [self!];
	0 ->:st;
	[bytes indexOf: '\n' code from: st until: size ->:en, notNil?]
		whileTrue:
			[en + 1 ->:nst;
			en > 0 and: [bytes at: en - 1, = '\r' code], ifTrue: [en - 1 ->en];
			block value: st value: en - st;
			nst = size ifTrue: [self!];
			nst ->st];
	block value: st value: size - st
**Cmd.ctr >> convertBytes
	self splitLineDo: 
		[:st :sz
		ctr nil? 
			ifTrue: [Out write: bytes from: st size: sz]
			ifFalse:
				[ctr translate: bytes from: st size: sz ->sz;
				Out write: ctr resultBuf size: sz];
		putLn value]
**Cmd.ctr >> main: args
	OptionParser new init: "f" ->:op, parse: args ->args;
	args size = 1 
		ifTrue: 
			[self normalize: "=" ->:from;
			self normalize: args first ->:to]
		ifFalse:
			[self normalize: args first ->from;
			self normalize: (args at: 1) ->to];

	from first <> to first ifTrue:
		[CodeTranslatorFactory new create: from first asString + to first
			->ctr];
	to last ->:ch, = 'n' ifTrue: [[Out putLn] ->putLn];
	ch = 'l' ifTrue: [[Out putByte: 0xa] ->putLn];
	ch = 'c' ifTrue: [[Out putByte: 0xd, putByte: 0xa] ->putLn];
	putLn nil? ifTrue: [self error: "illegal newline code " + ch];
	
	op at: 'f',
		ifTrue:
			[In contentLinesDo:
				[:fn
				fn asFile ->:file;
				file contentBytes ->bytes;
				[self convertBytes] pipeTo: file]]
		ifFalse:
			[In contentBytes ->bytes;
			self convertBytes]
