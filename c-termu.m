console for utf-8 terminal (Console.termu class)
$Id: mulk c-termu.m 422 2020-05-09 Sat 22:42:52 kt $
#ja utf-8端末用コンソール (Console.termu class)

*[man]
**#en
.caption SYNOPSIS
	cset termu
.caption DESCRIPTION
Console compatible with display errors when using utf-8 fonts.
.hierarchy Console.termu
When using utf-8 fonts in uxterm etc., there are cases where the glyph moves the cursor by one character, even though the glyphs are full-width, and the glyphs of the font are different from the windows environment and the display is disturbed.
Such characters are displayed correctly by replacing the output characters or adding a blank space.
.caption SEE ALSO
.summary console
**#ja
.caption 書式
	cset termu
.caption 説明
utf-8フォント使用時の表示異常に対応したコンソール。
.hierarchy Console.termu
uxterm等でutf-8フォントを使用するとグリフが全角にも関わらず、カーソルを1文字分しか進めなかったり、フォントのグリフがwindows環境と異なっていて表示が乱れるケースが存在する。
こういった文字に対しても出力文字を差し替えたり、空白を後付けする事で正しく表示する。
.caption 関連項目
.summary console

*import.@
	Mulk import: "c-term"

*Console.termu class.@
	Console.term addSubclass: #Console.termu
**Console.termu >> rawPutChar: wchar
	wchar code ->:code;

	{convert ellipsis to midline horizontal ellipsis as Japanese standards}
	code = 0xe280a6 ifTrue: [0xe28baf ->code];

	super rawPutChar: code asWideChar;

	{Characters that glyph is full-width but terminal move the cursor by 
		half-width
		2000-206f general punctuation
		2190-21ff arrows
		2200-22ff mathematical operators
		25a0-25ff geometric shapes
		2600-26ff misc symbols

		d7 multiply for latin-1 supplement }
	code between: 0xe28080 and: 0xe29bbf, or: [code = 0xc397], 
		ifTrue: [term put: ' ']
