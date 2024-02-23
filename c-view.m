console for view (Console.view class)
$Id: mulk c-view.m 1083 2023-06-25 Sun 21:01:33 kt $
#ja view用コンソール (Console.view class)

*[man]
**#en
.caption SYNOPSIS
	cset view
.caption DESCRIPTION
A console for inputting and outputting characters directly on View.
.hierarchy Console.view
.caption SEE ALSO
.summary console
.summary view
**#ja
.caption 書式
	cset view
.caption 説明
View上で直接文字の入出力を行う為のコンソール。
.hierarchy Console.view
.caption 関連項目
.summary console
.summary view

*import.@
	Mulk import: #("sconsole" "view" "sleeplib")

*Console.view class.@
	ScreenConsole addSubclass: #Console.view instanceVars:
		"view vw vh fw fh leftOffset maxWidth"
		+ " cursorColor cursorShow? cursorChar blinkTime blinkInterval"
		+ " imCursorColor imCursorUnderline?"
**Console.view >> rawStart
	View ->view;
	80 ->maxWidth;
	0 ->blinkTime;
	0.5 ->blinkInterval;
	view foreground ->cursorColor ->imCursorColor;
	false ->imCursorUnderline?;
	view open
**Console.view >> rawSetSize
	view width ->vw;
	view height ->vh;
	view fontWidth ->fw;
	view fontHeight ->fh;
	vw // fw min: maxWidth ->width;
	vw - (width * fw) // 2 ->leftOffset;
	vh // fh ->height
**Console.view >> rawFinish
	view close
**Console.view >> rawPutChar: ch foreground: fg background: bg
	curX * fw + leftOffset ->:x;
	curY * fh ->:y;
	view drawX: x Y: y char: ch foreground: fg background: bg
**Console.view >> rawPutChar: ch
	self rawPutChar: ch foreground: view foreground background: view background
**Console.view >> rawClear
	view clear
**Console.view >> putChar0: ch
	self screenIndexX: curX Y: curY ->:spos;
	ch width ->:w;
	screen at: spos, <> ch or: [w = 2 and: [screen at: spos + 1, <> #skip]],
			ifTrue:
		[screen at: spos put: ch;
		w = 2 ifTrue: [screen at: spos + 1 put: #skip];
		self rawPutChar: ch];
	curX + w ->curX;
	curX = width ifTrue:
		[0 ->curX;
		curY + 1 ->curY]
**Console.view >> scroll
	0 ->curY;
	width ->:pos;
	screen size ->:end;
	[pos < end] whileTrue:
		[screen at: pos ->:ch, <> #skip ifTrue: [self putChar0: ch];
		pos + 1 ->pos];
	width timesRepeat: [self putChar0: ' ']
**Console.view >> drawCursor
	self rawPutChar: cursorChar foreground: view background
		background: cursorColor
**Console.view >> drawImCursor
	imCursorUnderline? ifFalse:
		[self rawPutChar: cursorChar foreground: view background
			background: imCursorColor!];
	self rawPutChar: cursorChar;
	curX * fw + leftOffset ->:x;
	curY * fh ->:y;
	fh // 8 + 1 ->:h;
	view fillRectangleX: x Y: y + fh - h width: cursorChar width * fw height: h
		color: imCursorColor
**Console.view >> blink
	cursorShow? not ->cursorShow?;
	cursorShow?
		ifTrue:
			[self imAscii?
				ifTrue: [self drawCursor]
				ifFalse: [self drawImCursor]]
		ifFalse: [self rawPutChar: cursorChar]
**Console.view >> rawFetch
	false ->cursorShow?;
	view hit? ifFalse:
		[self charX: curX Y: curY ->cursorChar, = #skip ifTrue:
			[' ' ->cursorChar];
		0 ->:time ->:lastBlink;
		self blink;
		[view hit? not ->:notHit?, & (time < blinkTime)] whileTrue:
			[time - lastBlink >= blinkInterval ifTrue:
				[self blink;
				time ->lastBlink];
			0.05 sleep;
			time + 0.05 ->time];
		notHit? & cursorShow? not ifTrue: [self blink]];
	view getChar ->:result;
	result mblead? ifTrue:
		[result code ->:code;
		result trailSize timesRepeat: [code * 256 + view getChar code ->code];
		code asWideChar ->result];
	cursorShow? ifTrue: [self blink];
	result!
**Console.view >> hit?
	view hit?!
**Console.view >> rawShiftMode: modeArg
	view shiftMode: modeArg

**api.
***Console.view >> font: fontName
	view font: fontName;
	self resetScreen
****[man.m]
*****#en
Switch to the specified font.

The screen is cleared and the number of columns and lines are reset.
See View.class >> font: for how to specify the font.
*****#ja
指定されたフォントに切り替える。

画面はクリアされカラム数や行数は再設定される。
フォントの指定の仕方についてはView.class >> font:を参照の事。

***Console.view >> width: widthArg
	widthArg ->maxWidth;
	self resetScreen
****[man.m]
*****#en
Let widthArg be the number of characters per line (if possible).
*****#ja
一行当たりの文字数を(可能なら)widthArgとする。

***Console.view >> resizeViewWidth: widthArg
	View width: widthArg * fw height: vh;
	self width: widthArg
****[man.m]
*****#en
Resize the View and set the number of characters per line to widthArg.
*****#ja
Viewをリサイズして一行当たりの文字数をwidthArgとする。

***Console.view >> blinkTime: blinkTimeArg
	blinkTimeArg ->blinkTime
****[man.m]
*****#en
Specifies the number of seconds that the cursor blinks.
*****#ja
カーソルが点滅する秒数を指定する。

***Console.view >> blinkInterval: blinkIntervalArg
	blinkIntervalArg ->blinkInterval
****[man.m]
*****#en
Specifies the blinking interval of the cursor in seconds.
*****#ja
カーソルの点滅間隔を秒単位で指定する。

***Console.view >> cursorColor: cursorColorArg
	cursorColorArg ->cursorColor
****[man.m]
*****#en
Specifies the cursor color.
*****#ja
カーソルの色を指定する。

***Console.view >> imCursorColor: arg
	arg ->imCursorColor
****[man.m]
*****#en
Specifies the color of the cursor in non-ASCII mode in input methods.
*****#ja
インプットメソッドで非ASCIIモード時のカーソルの色を指定する。

***Console.view >> imCursorUnderline: arg
	arg ->imCursorUnderline?
****[man.m]
*****#en
Specify true to underline the cursor in non-ASCII mode in the input method.
*****#ja
インプットメソッドで非ASCIIモード時にカーソルをアンダーラインにする場合はtrueを指定する。

