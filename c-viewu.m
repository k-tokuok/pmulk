console for UTF-8 view (Console.viewu class)
$Id: mulk c-viewu.m 1179 2024-03-17 Sun 21:14:15 kt $
#ja UTF-8 view用コンソール (Console.viewu class)

*[man]
**#en
.caption SYNOPSIS
	cset viewu
.caption DESCRIPTION
Console that supports fonts with some different glyphs in UTF-8 environment.
.hierarchy Console.viewu
By default, the character corresponding to the code is displayed as it is.
Conversion is performed by setting the method flag.
.caption SEE ALSO
.summary console
.summary c-view

**#ja
.caption 書式
	cset viewu
.caption 説明
UTF-8環境で一部のグリフが異なるフォントに対応したコンソール。
.hierarchy Console.viewu
デフォルトではコードに対応した文字をそのまま表示する。
メソッドのflagを立てると変換が行われる。
.caption 関連項目
.summary console
.summary c-view

*import.@
	Mulk import: "c-view"

*Console.viewu class.@
	Console.view addSubclass: #Console.viewu instanceVars:
		"convertTilda? convertEllipsis?"
**Console.viewu >> init
	super init;
	self convertTilda: false;
	self convertEllipsis: false

**Console.viewu >> convertTilda: flag
	flag ->convertTilda?
***[man.m]
****#en
Convert Full width tilda (U+FF5E) to Wave dash (U+301c).
****#ja
Full width tilda (U+FF5E)をWave dash (U+301c)に変換する。

**Console.viewu >> convertEllipsis: flag
	flag ->convertEllipsis?
***[man.m]
****#en
Convert Horizontal ellipsis (U+2026) to Midline horizontal ellipsis (U+22EF).
****#ja
Horizontal ellipsis (U+2026)をMidline horizontal ellipsis (U+22EF)に変換する。

**Console.viewu >> convert: ch
	ch code ->:code;
	convertTilda? and: [code = 0xefbd9e], ifTrue: [0xe3809c asWideChar!];
	convertEllipsis? and: [code = 0xe280a6], ifTrue: [0xe28baf asWideChar!];
	ch!
**Console.viewu >> rawPutChar: ch foreground: fg background: bg
	super rawPutChar: (self convert: ch) foreground: fg background: bg
