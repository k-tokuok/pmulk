console with screen control function (ScreenConsole class)
$Id: mulk sconsole.m 1082 2023-06-24 Sat 22:48:26 kt $
#ja 画面制御機能付きコンソール (ScreenConsole class)

*[man]
**#en
.caption DESCRIPTION
Abstract base class for consoles that have screen control functions.
.hierarchy ScreenConsole
Provides common functions for screen clear and cursor motion.
When actually using the function, it is necessary to use a class derived from this class as a Console.
.caption SEE ALSO
.summary console
**#ja
.caption 説明
画面制御機能を有するコンソールの抽象基底クラス。
.hierarchy ScreenConsole
画面消去やカーソルモーションの共通機能を提供する。
実際に機能を使用する際は、本クラスから派生したクラスをConsoleとする必要がある。
.caption 関連項目
.summary console

*import.@
	Mulk import: #("console" "wcarray" "wcbuild")

*ScreenConsole class.@
	AbstractConsole addSubclass: #ScreenConsole instanceVars:
		"reader wcBuilder inputMethod"
		+ " width height curX curY screen tabWidth",
		features: #(Writer Reader)

**ScreenConsole >> resetScreen
	self rawSetSize;
	FixedArray basicNew: width * height ->screen;
	self clear
	
**Console overwrite.
***ScreenConsole >> start
	self rawStart;
	4 ->tabWidth;
	self resetScreen
***ScreenConsole >> finish
	self inputMethod: nil;
	self rawFinish
***ScreenConsole >> in
	self!
***ScreenConsole >> out
	self!
***ScreenConsole >> autoLineFeedIfLineFilled?
	true!
***ScreenConsole >> height
	height!
***ScreenConsole >> width
	width!

**writer
***ScreenConsole >> scroll
	self shouldBeImplemented
***ScreenConsole >> lineFeed
	0 ->curX;
	curY + 1 ->curY;
	curY = height ifTrue:
		[self scroll;
		height - 1 ->curY]
***ScreenConsole >> screenIndexX: x Y: y
	y * width + x!
***ScreenConsole >> putChar: ch
	ch = '\f' ifTrue: [self clear!];
	ch = '\n' ifTrue: [self lineFeed!];
	ch = '\b' ifTrue: [self backspace: 1!];
	ch = '\t' ifTrue:
		[tabWidth - (curX % tabWidth) timesRepeat: [self putChar: ' ']!];
	ch width ->:w;
	curX + w > width ifTrue: [self lineFeed];

	self screenIndexX: curX Y: curY ->:spos;
	screen at: spos, <> ch or: [w = 2 and: [screen at: spos + 1, <> #skip]],
			ifTrue:
		[screen at: spos put: ch;
		w = 2 ifTrue: [screen at: spos + 1 put: #skip];
		self rawPutChar: ch];
	curX + w ->curX;
	curX = width ifTrue: [self lineFeed]
***ScreenConsole >> putByte: byte
	wcBuilder build: byte ->:ch, nil? ifFalse: [self putChar: ch]

**reader
***ScreenConsole >> text?: ch
	ch memberOf?: Char, ifTrue: [ch = '\t' | ch print?!];
	ch memberOf?: WideChar!
***ScreenConsole >> backspace: w
	curX - w ->:px;
	curY ->:py;
	px < 0 ifTrue:
		[px + width ->px;
		py - 1 ->py];
	self gotoX: px Y: py;
	self put: ' ' times: w;
	self gotoX: px Y: py
***ScreenConsole >> readLine
	WideCharArray new ->:buf;
	Array new ->:steps;
	[self fetch ->:ch;
	ch = '\cd' ifTrue: [nil!];
	ch = '\n' | (ch = '\r') ifTrue:
		[self putLn;
		buf asString!];
	ch = '\b'
		ifTrue:
			[buf empty? ifFalse:
				[self backspace: steps last;
				buf removeLast;
				steps removeLast]]
		ifFalse:
			[self text?: ch, ifTrue:
				[curX ->:px;
				self put: ch;
				buf addLast: ch;
				curX - px ->:step, < 0 ifTrue: [step + width ->step];
				steps addLast: step]]] loop
***ScreenConsole >> getByte
	reader nil? or: [reader getByte ->:byte, = -1], ifTrue:
		[self readLine ->:s;
		s nil? ifTrue: [-1!];
		StringReader new init: s + '\n' ->reader;
		reader getByte ->byte];
	byte!
	
**ScreenConsole api.
***ScreenConsole >> clear
	self rawClear;
	0 ->curX ->curY;
	screen fill: ' ';
	WideCharBuilder new ->wcBuilder
****[man.m]
*****#en
Clear the screen.
*****#ja
画面をクリアする。

***ScreenConsole >> gotoX: x Y: y
	x ->curX;
	y ->curY
****[man.m]
*****#en
Move the cursor to position x, y.
*****#ja
カーソルを位置x, yへ移動させる。

***ScreenConsole >> fetch
	inputMethod nil? ifTrue: [self rawFetch] ifFalse: [inputMethod fetch]!
****[man.m]
*****#en
Enter one character from the keyboard.

If there are no characters in the input queue, wait for input.
The return value is ASCII equivalent Char or WideChar.
*****#ja
キーボードから1文字入力する。

入力キューに文字が無い場合、入力が行われるまで待つ。
返り値はASCII相当のCharもしくはWideCharとなる。

***ScreenConsole >> hit?
	self shouldBeImplemented
****[man.m]
*****#en
Returns true if there are characters in the input queue from the keyboard.
*****#ja
キーボードからの入力キューに文字がある場合、trueを返す。

***ScreenConsole >> charX: x Y: y
	screen at: (self screenIndexX: x Y: y)!
****[man.m]
*****#en
Returns the character displayed at the cursor position x, y.

The part displaying tab is replaced with a blank.
Returns #skip for the second half of a multibyte character.
*****#ja
カーソル位置x, yに表示している文字を返す。

tabを表示した部位は空白に置換される。
マルチバイト文字の後半部分では#skipを返す。

***ScreenConsole >> crossShiftMode
	self rawShiftMode: 0
****[man.m]
*****#en
Switch to cross shift mode.

A key that should be pressed with the left hand while pressing "Conversion" on a JIS keyboard functions as a shift key when a key that should be pressed with the right hand is pressed while pressing "No Conversion".
Similarly, a key that should be pressed with the right hand while pressing "Conversion" and a key that should be pressed with the left hand while pressing "No Conversion" function as a control key.

Not all terminals and implementations support it.

When using special shift mode on Windows or when using SDL, it is necessary to specify the keymap file corresponding to the keyboard to be used in #ScreenConsole.keymap of the system dictionary.
Keymap files are files starting with "k-" in the system directory.
*****#ja
クロスシフトモードに切り替える。

JISキーボードの"変換"を押しながら左手で打鍵すべきキーを、"無変換"を押しながら右手で打鍵すべきキーを入力するとシフトキーとして機能する。
同様に"変換"を押しながら右手で打鍵すべきキーを、"無変換"を押しながら左手で打鍵すべきキーを入力するとコントロールキーとして機能する。

全ての端末・実装で対応している訳ではない。

Windowsで特殊シフトモードを使用する場合や、SDLを使用する場合はシステム辞書の#ScreenConsole.keymapに使用するキーボードに応じたキーマップファイルを指定する必要がある。
キーマップファイルはシステムディレクトリの"k-"で始まるファイルである。
***ScreenConsole >> spaceShiftMode
	self rawShiftMode: 1
****[man.m]
*****#en
Switch to space shift mode.

If you press another key while pressing the space bar, it functions as a shift key.
If you release another key without typing, a blank is entered.

Not all terminals and implementations support it.
*****#ja
スペースシフトモードに切り替える。

スペースバーを押しながら他のキーを打鍵するとシフトキーとして機能する。
他のキーを打鍵せずに離すと空白が入力される。

全ての端末・実装で対応している訳ではない。

**inputMethod i/f.
***ScreenConsole >> inputMethod: inputMethodArg
	inputMethodArg ->inputMethod
***ScreenConsole >> imAscii?
	inputMethod nil? or: [inputMethod ascii?]!
***ScreenConsole >> imAscii
	inputMethod notNil? ifTrue: [inputMethod ascii]
***ScreenConsole >> curX
	curX!
***ScreenConsole >> curY
	curY!
***ScreenConsole >> charsX: x Y: y size: size
	StringWriter new ->:w;
	self screenIndexX: x Y: y ->:pos;
	size timesRepeat:
		[screen at: pos ->:ch, <> #skip ifTrue: [w put: ch];
		pos + 1 ->pos];
	w asString!
