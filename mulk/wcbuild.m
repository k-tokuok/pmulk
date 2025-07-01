WideCharBuilder class
$Id: mulk wcbuild.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja
*[man]
**#en
.caption DESCRIPTION
Receives character code byte by byte and builds Char and WideChar.
.hierarchy WideCharBuilder
**#ja
.caption 説明
文字コードを1バイトずつ受け取り、Char及びWideCharを構築する。
.hierarchy WideCharBuilder

*WideCharBuilder class.@
	Object addSubclass: #WideCharBuilder instanceVars: "leadCode remain"

**WideCharBuilder >> init
	0 ->remain

**WideCharBuilder >> build: code
	code asChar ->:ch;
	remain = 0
		ifTrue:
			[ch mblead? ifTrue:
				[ch trailSize ->remain;
				code ->leadCode;
				nil!]]
		ifFalse:
			[ch mbtrail? ifFalse:
				[0 ->remain;
				nil!];
			leadCode * 256 + code ->leadCode;
			remain - 1 ->remain;
			remain <> 0 ifTrue: [nil!];
			leadCode asWideChar ->ch];
	ch!
***[man.m]
****#en
The 8-bit character code received in the argument is converted to Char and returned.

Nil is returned when the code at the beginning or middle of a multibyte character is received, but when the code is completed up to the end, a WideChar that summarizes the codes received so far is returned.
****#ja
引数で受け取った8bitの文字コードを、Charに変換して返す。
マルチバイト文字の先頭や途中のコードを受け取るとnilを返すが、終端まで完結した時点でそれまでに受け取ったコードをまとめたWideCharを返す。
***#ja
****[test.m]
	WideCharBuilder new ->:wb;
	self assert: (wb build: 'a' code) = 'a';

	Mulk.charset = #utf8
		ifTrue:
			[self assert: (wb build: 0xe4) nil?;
			self assert: (wb build: 0xba) nil?;
			wb build: 0x9c]
		ifFalse:
			[self assert: (wb build: 0x88) nil?;
			wb build: 0x9f] ->:ch;
	self assert: ch = '亜'
