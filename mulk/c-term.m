console for character terminal (Console.term class)
$Id: mulk c-term.m 1633 2026-08-16 Sun 20:52:03 kt $
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
	ScreenConsole addSubclass: #Console.term instanceVars: 
		"tCurX tCurY reposition?"
**Console.term >> rawStart
	Term start;
	false ->reposition?
**Console.term >> rawSetSize
	Term width ->width;
	Term height ->height
**Console.term >> rawFinish
	Term finish
**Console.term >> scroll
	height - 1 * width ->:sz;
	screen basicAt: 0 copyFrom: screen at: width size: sz;
	screen fill: ' ' from: sz until: screen size;

	Term autoLineFeedIfLineFilled? & (tCurX = width) ifTrue: [self!];
	tCurY <> (height - 1) ifTrue:
		[height - 1 ->tCurY;
		Term gotoX: 0 Y: tCurY];
	0 ->tCurX;
	Term put: '\r', put: '\n'
**Console.term >> lineFeed
	super lineFeed;

	Term autoLineFeedIfLineFilled? & (tCurX = width) ifTrue:
		[0 ->tCurX;
		tCurY + 1 ->tCurY;
		tCurY = height ifTrue: [tCurY - 1 ->tCurY]]
**Console.term >> moveCursor
	curX <> tCurX or: [curY <> tCurY], or: [reposition?], ifTrue:
		[Term gotoX: curX Y: curY;
		curX ->tCurX;
		curY ->tCurY;
		false ->reposition?]
**Console.term >> rawPutChar: ch
	self moveCursor;
	Term put: ch;
	tCurX + ch width ->tCurX;
	Term repositionForWideChar? and: [ch kindOf?: WideChar] ->reposition?
**Console.term >> rawClear
	Term clear;
	0 ->tCurX ->tCurY
**Console.term >> rawFetch
	self moveCursor;
	Term get asChar ->:result;
	result mblead? ifTrue:
		[result code ->:code;
		result trailSize timesRepeat: [code * 256 + Term get ->code];
		code asWideChar ->result];
	result!
**Console.term >> hit?
	Term hit?!
