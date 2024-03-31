character code translation library
$Id: mulk ctrlib.m 1188 2024-03-26 Tue 22:43:40 kt $
#ja 文字コード変換ライブラリ

*[man]
**#en
.caption DESCRIPTION
Library that performs character code translation.

**#ja
.caption 説明
文字コード変換を行うライブラリ。

*CodeTranslator class.@
	Object addSubclass: #CodeTranslator instanceVars: "limit resultBuf"
**[man.c]
***#en
Translator.

Translate the character code according to the specification at the time of construction.
***#ja
変換器。

構築時の指定に従い文字コードを変換する。

**CodeTranslator >> init
	0 ->limit
**CodeTranslator >> init: fromTo
	self shouldBeImplemented
**CodeTranslator >> alloc
	FixedByteArray basicNew: limit * 4 ->resultBuf 
		-- for UTF-32, may worst translation rate.
**CodeTranslator >> reserve: size
	limit > size ifTrue: [self!];
	limit = 0 ifTrue: [8 ->limit];
	[limit < size] whileTrue: [limit * 2 ->limit];
	self alloc

**CodeTranslator >> translate: bufArg from: fromArg size: sizeArg
	self shouldBeImplemented
***[man.m]
****#en
Translates the byte array for sizeArg bytes from the fromArg byte of FixedByteArray bufArg and returns the number of bytes of the result.
The translation result is stored in an internal buffer and can be obtained with resultBuf.
It is not possible to translate across breaks in multibyte characters.
****#ja
FixedByteArray bufArgのfromArgバイト目からsizeArgバイト分のバイト列を変換し、結果のバイト数を返す。
変換結果は内部バッファに保持され、resultBufで取得出来る。
マルチバイト文字の切れ目を跨って変換することは出来ない。

**CodeTranslator >> resultBuf
	resultBuf!
***[man.m]
****#en
Returns a FixedByteArray that is the translation result of translate:.
****#ja
translate:の変換結果のFixedByteArrayを返す。

**CodeTranslator >> translate: stringArg
	self translate: stringArg from: 0 size: stringArg size ->:resultSize;
	resultBuf makeStringFrom: 0 size: resultSize!
***[man.m]
****#en
Translates the String stringArg and returns the result as a string.
****#ja
文字列stringArgを変換して結果を文字列として返す。

**CodeTranslator >> finish
	self!
***[man.m]
****#en
Terminate process and release resource.
****#ja
処理を終了し、リソースを開放する。

*CodeTranslatorFactory class.@
	Object addSubclass: #CodeTranslatorFactory
**[man.c]
***#en
Factory class.
***#ja
ファクトリークラス

**CodeTranslatorFactory >> create: fromTo
	"iconv" ->:name;
	Mulk.hostOS = #windows ifTrue: ["w" ->name];
	Mulk.hostOS = #android ifTrue: ["a" ->name];

	Mulk at: ("CodeTranslator." + name) asSymbol in: "ctr" + name,
		new init: fromTo!
***[man.m]
****#en
Constructs and returns a CodeTranslator corresponding to the specified string fromTo.

fromTo specifies the code type to be translate with the following two alphabets.
	u -- UTF-8
	s -- SJIS
	e -- EUC-JP
****#ja
指定文字列fromToに対応する変換器を構築して返す。

fromToは変換するコード種別を以下のアルファベット二文字で指定する。
	u -- UTF-8
	s -- SJIS
	e -- EUC-JP
