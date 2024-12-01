console for character terminal (Console.term class)
$Id: mulk c-term.m 1301 2024-11-16 Sat 15:42:00 kt $
#ja キャラクタ端末用コンソール (Console.term class)

*[man]
**#en
.caption SYNOPSIS
	cset term
.caption DESCRIPTION
Console that supports cursor motion on character terminals.
.hierarchy Console.term
.caption SEE ALSO
.summary console
**#ja
.caption 書式
	cset term
.caption 説明
キャラクタ端末上でのカーソルモーションに対応したコンソール。
.hierarchy Console.term
.caption 関連項目
.summary console

*import.@
	Mulk import: #("sconsole" "term")

*Console.term class.@
	ScreenConsole addSubclass: #Console.term instanceVars: "term tCurX tCurY"
**Console.term >> rawStart
	Terminal new start ->term
**Console.term >> rawSetSize
	term width ->width;
	term height ->height
**Console.term >> rawFinish
	term finish
**Console.term >> scroll
	height - 1 * width ->:sz;
	screen basicAt: 0 copyFrom: screen at: width size: sz;
	screen fill: ' ' from: sz until: screen size;

	term autoLineFeedIfLineFilled? & (tCurX = width) ifTrue: [self!];
	tCurY <> (height - 1) ifTrue:
		[height - 1 ->tCurY;
		term gotoX: 0 Y: tCurY];
	0 ->tCurX;
	term put: '\r', put: '\n'
**Console.term >> lineFeed
	super lineFeed;

	term autoLineFeedIfLineFilled? & (tCurX = width) ifTrue:
		[0 ->tCurX;
		tCurY + 1 ->tCurY;
		tCurY = height ifTrue: [tCurY - 1 ->tCurY]]
**Console.term >> moveCursor
	curX <> tCurX | (curY <> tCurY) ifTrue:
		[term gotoX: curX Y: curY;
		curX ->tCurX;
		curY ->tCurY]
**Console.term >> rawPutChar: ch
	self moveCursor;
	term put: ch;
	tCurX + ch width ->tCurX
**Console.term >> rawClear
	term clear;
	0 ->tCurX ->tCurY
**Console.term >> rawFetch
	self moveCursor;
	term get asChar ->:result;
	result mblead? ifTrue:
		[result code ->:code;
		result trailSize timesRepeat: [code * 256 + term get ->code];
		code asWideChar ->result];
	result!
**Console.term >> hit?
	term hit?!
