graphic screen
$Id: mulk view.m 1182 2024-03-20 Wed 22:06:05 kt $
#ja グラフィック画面

*[man]
**#en
.caption DESCRIPTION
Provides functions related to graphic screen display and control.
**#ja
.caption 説明
グラフィック画面の表示と制御に関する機能を提供する。

*View.FontDrawer class.@
	Object addSubclass: #View.FontDrawer instanceVars: 
		"fontWidth fontHeight offx offy woffx woffy"
	
*View.class class.@
	Mulk import: "coord";
	Object addSubclass: #View.class instanceVars:
		"width height foreground background fontDrawer"
		+ " queuedChar lastEvent"
**[man.c]
***#en
Base class for graphic screen accessor objects.

Implement each architecture in a subclass, and make the global object View the only instance.
Under the window system, one window is allocated and associated with it.

When using the graphic screen as a console, switch Console.View or its inherited class with cset.

In the coordinate system, the upper left is (0, 0).
***#ja
グラフィック画面のアクセサオブジェクトの基底クラス。

アーキテクチャ毎の実装をサブクラスで行い、グローバルオブジェクトViewを唯一のインスタンスとする。
ウィンドウシステム下では一つのウィンドウを確保し、これに対応付ける。

グラフィック画面をコンソールとして使用する場合はConsole.Viewもしくはその継承クラスをcsetで切り替える。

座標系は左上を(0, 0)とする。

**View.class >> init
	self foreground: self colorBlack;
	self background: self colorWhite

**View.class >> open
	self shouldBeImplemented
***[man.m]
****#en
Open and clear a view of default size.
****#ja
デフォルトサイズのViewを開き、クリアする。

**View.class >> close
	self!
***[man.m]
****#en
Close View.
****#ja
Viewを閉じる。

**View.class >> onQuit
	self close

**View.class >> width
	width!
***[man.m]
****#en
Returns the number of horizontal pixels of the View.
****#ja
Viewの横ピクセル数を返す。

**View.class >> height
	height!
***[man.m]
****#en
Returns the number of vertical pixels of the View.
****#ja
Viewの縦ピクセル数を返す。

**colors.
***[man.s]
****#en
The color indicates the 24-bit true color with the following integer value.
	r << 16 | (g << 8) | b
****#ja
色は、24bit true colorを以下の整数値で示す。
	 r << 16 | (g << 8) | b

***View.class >> colorRed: r green: g blue: b
	 r << 16 | (g << 8) | b!
****[man.m]
*****#en
Returns a number indicating the color of the components r, g, b.
*****#ja
成分r, g, bの色を示す数値を返す。

***View.class >> colorWhite
	self colorRed: 255 green: 255 blue: 255!
****[man.m]
*****#en
Returns a number indicating white.
*****#ja
白色を示す数値を返す。

***View.class >> colorBlack
	self colorRed: 0 green: 0 blue: 0!
****[man.m]
*****#en
Returns a number indicating black.
*****#ja
黒色を示す数値を返す。

***View.class >> colorRed
	self colorRed: 255 green: 0 blue: 0!
****[man.m]
*****#en
Returns a number indicating red.
*****#ja
赤色を示す数値を返す。

***View.class >> colorGreen
	self colorRed: 0 green: 255 blue: 0!
****[man.m]
*****#en
Returns a number indicating green.
*****#ja
緑色を示す数値を返す。

***View.class >> colorBlue
	self colorRed: 0 green: 0 blue: 255!
****[man.m]
*****#en
Returns a number indicating blue.
*****#ja
青色を示す数値を返す。

**foreground/background color.
***View.class >> foreground: colorArg
	colorArg ->foreground
****[man.m]
*****#en
Set foreground color to colorArg.
*****#ja
前景色をcolorに設定する。

***View.class >> background: colorArg
	colorArg ->background
****[man.m]
*****#en
Set background color to colorArg.
*****#ja
背景色をcolorArgに設定する。

***View.class >> foreground
	foreground!
****[man.m]
*****#en
Returns the foreground color.
*****#ja
前景色を返す。

***View.class >> background
	background!
****[man.m]
*****#en
Returns the background color.
*****#ja
背景色を返す。

**View.class >> updateInterval: arg
	self shouldBeImplemented
***[man.m]
****#en
Set the screen update interval and return the old value.
****#ja
画面の更新間隔を設定し、旧値を返す。
	
**View.class >> updateInterval
	self updateInterval: 0 ->:result;
	self updateInterval: result;
	result!
***[man.m]
****#en
Returns the current screen update interval.
****#ja
現在の画面の更新間隔を返す。

**fill rectangle.
***View.class >> fillRectangleX: x Y: y width: w height: h color: color
	self shouldBeImplemented

***View.class >> fillRectangleX: x Y: y width: w height: h
	self fillRectangleX: x Y: y width: w height: h color: foreground
****[man.m]
*****#en
Fill the rectangle from coordinates (x, y) to (w, h) with the foreground color.
*****#ja
座標(x, y)から(w, h)の矩形を前景色で塗り潰す。

***View.class >> clearRectangleX: x Y: y width: w height: h
	self fillRectangleX: x Y: y width: w height: h color: background
****[man.m]
*****#en
Fill the rectangle from coordinates (x, y) to (w, h) with the background color.
*****#ja
座標(x, y)から(w, h)の矩形を背景色で塗り潰す。

***View.class >> clear
	self clearRectangleX: 0 Y: 0 width: self width height: self height
****[man.m]
*****#en
Clear the screen.

Fill the entire View with the background color.
*****#ja
画面をクリアする。

View全体を背景色で塗り潰す。

**draw char.
***View.class >> basicFont: fontName
	self shouldBeImplemented

***View.class >> font: fontArg
	fontArg kindOf?: View.FontDrawer,
		ifTrue: [fontArg]
		ifFalse: [View.FontDrawer new init: fontArg] ->fontDrawer
****[man.m]
*****#en
Specify the character font with the following character string that depends on the host environment.

|Unix/X11
	X11 font set name. ex. "8x13,kanji16,8x16kana".
	'*' freeType font name. ex. "*Monospace-12".
|Windows
	font name [',' font height [',' Non-ASCII font name [',' Non-ASCII font height]]]. ex. "MS Gothic,16".
|Android
	Size. ex. "9".
|SDL
	TTF file [',' font size] ex. "VL-Gothic-Regular.ttf,16"
	
Only fixed pitch fonts can be used, and Char with width 2 is displayed in full width.
By passing an instance of Dictionary, the drawing position of characters can be explained in detail.

	key 		meaning
	#font 		the font name above
	#fontWidth 	font width
	#fontHeight font height
	#offx 		x-coordinate correction of ASCII characters
	#offy 		y-coordinate correction
	#woffx 		x-coordinate correction of wide characters
	#woffy 		y-coordinate correction
*****#ja
文字フォントをホスト環境に依存する以下の文字列で指定する。

|Unix/X11
	フォントセット指定。ex. "8x13,kanji16,8x16kana"
	'*' FreeTypeフォント名 ex. "*monospace-12"
|Windows
	フォント名 [',' フォントの高さ [',' 非アスキーフォント名 [',' 非アスキーフォントの高さ]]] ex. "MS Gothic,16"
|Android
	サイズ ex. "9"
|SDL
	TTFファイル [',' サイズ] ex. "VL-Gothic-Regular.ttf,16"
	
固定ピッチフォントのみ使用可能で、widthが2となるCharは全角で表示される。
Dictionaryのインスタンスを渡すことで、文字の描画位置を細かく設定出来る。

	キー		意味
	#font		上記のフォント名
	#fontWidth	フォント幅
	#fontHeight	フォントの高さ
	#offx		アスキー文字のx座標補正
	#offy		y座標補正
	#woffx		全角文字のx座標補正
	#woffy		y座標補正
	
***View.class >> fontWidth
	fontDrawer fontWidth!
****[man.m]
*****#en
Returns the width of the current font.
*****#ja
現在のフォントの横幅を返す。

***View.class >> fontHeight
	fontDrawer fontHeight!
****[man.m]
*****#en
Returns the height of the current font.
*****#ja
現在のフォントの縦幅を返す。

***View.class >> drawX: x Y: y code: code color: color
	--for native draw.
	self shouldBeImplemented

***View.class >> drawX: x Y: y char: char foreground: fg background: bg
	fontDrawer drawX: x Y: y char: char foreground: fg background: bg

***View.class >> drawX: x Y: y string: stringArg
	self fontWidth ->:w;
	StringReader new init: stringArg ->:r;
	[r getWideChar ->:ch, notNil?] whileTrue:
		[self drawX: x Y: y char: ch
			foreground: foreground background: background;
		x + (ch width * w) ->x]
****[man.m]
*****#en
Displays the character string stringArg at the coordinates (x, y) with the foreground color.
*****#ja
座標(x, y)に前景色で文字列stringArgを表示する。

**draw line.
***View.class >> drawLineX: x0 Y: y0 X: x1 Y: y1 color: color
	self shouldBeImplemented

***View.class >> drawLineX: x0 Y: y0 X: x1 Y: y1
	self drawLineX: x0 Y: y0 X: x1 Y: y1 color: foreground
****[man.m]
*****#en
Draw a straight line from coordinates (x0, y0) to (x1, y1) with the foreground color.
*****#ja
座標(x0, y0)から(x1, y1)に前景色で直線を描画する。

**View.class >> drawPolygon: pointsArg color: colorArg
	self shouldBeImplemented
***[man.m]
****#en
Fill the closed area of FixedArray pointsArg (x0 y0 x1 y1 ...) with colorArg.
Coordinates can be specified up to 20 points.
****#ja
FixedArray pointsArg (x0 y0 x1 y1...)の閉領域をcolorArgで塗り潰す。
座標は20点まで指定可能。

**image.
***View.class >> putTrueColorImageX: x Y: y rgb: rgb width: w height: h
	self shouldBeImplemented

***View.class >> putImage: imageArg X: x Y: y
	self putTrueColorImageX: x Y: y rgb: imageArg buffer
		width: imageArg width height: imageArg height
****[man.m]
*****#en
Display View.Image imageArg at coordinates (x, y).
*****#ja
座標(x, y)にView.Image imageArgを表示する。

***View.class >> putImage: imageArg
	self putImage: imageArg X: 0 Y: 0
****[man.m]
*****#en
Display View.Image imageArg on the screen.
*****#ja
画面にView.Image imageArgを表示する。

**View.class >> putMonochromeImageX: x Y: y bitmap: bitmapArg
		width: widthArg height: heightArg
		foreground: fgArg background: bgArg
	self shouldBeImplemented
***[man.m]
****#en
Display the FixedByteArray bitmapArg as a monochrome bitmap with width wArg and height hArg at the bottom right of the coordinates (x, y).
The bitmap must be 1 bit 1 pixel and the number of bytes in the slice must be 2 bytes aligned.
1 pixel is displayed in color fgArg, and 0 pixel is displayed in color bgArg.
****#ja
FixedByteArray bitmapArgを幅wArg、高さhArgのモノクロビットマップとして座標(x,y)の右下に表示する。
ビットマップは1ビット1ピクセルでスライスのバイト数は2バイトアラインでなければならない。
1のピクセルを色fgArgで、0のピクセルを色bgArgで表示する。

**event.
***View.class >> eventEmpty?
	self shouldBeImplemented
****[man.m]
*****#en
Returns true if the event queue is empty.
*****#ja
イベントキューが空の場合にtrueを返す。

***View.class >> lastEventType
	#(#char #ptrdown #ptrdrag #ptrup) at: lastEvent & 0x3!
****[man.m]
*****#en
Returns the type symbol of the last acquired event.

The types are as follows.
	#char -- character input
	#ptrdown -- pointer press
	#ptrdrag -- drag the pointer
	#ptrup -- release pointer
*****#ja
最後に取得したイベントの種別シンボルを返す。

種別は以下の通り。
	#char -- 文字入力
	#ptrdown -- ポインタのプレス
	#ptrdrag -- ポインタのドラッグ
	#ptrup -- ポインタのリリース

***View.class >> basicGetEvent
	self shouldBeImplemented

***View.class >> getEvent
	self basicGetEvent ->lastEvent;
	self lastEventType!
****[man.m]
*****#en
Acquire the event and return the type symbol.

See lastEventType for type.
If the event queue is empty, it waits.
*****#ja
イベントを取得し、種別シンボルを返す。

種別はlastEventTypeを参照。
イベントキューが空の場合は待ちに入る。

***View.class >> lastChar
	lastEvent >> 2, asChar!
****[man.m]
*****#en
Returns the character (Char) of the last character input event.
*****#ja
最後に取得した文字入力イベントの文字(Char)を返す。

***View.class >> lastX
	lastEvent >> 2, coordX!
****[man.m]
*****#en
Returns the X coordinate of the last acquired pointer event.
*****#ja
最後に取得したポインタイベントのX座標を返す。

***View.class >> lastY
	lastEvent >> 2, coordY!
****[man.m]
*****#en
Returns the Y coordinate of the last acquired pointer event.
*****#ja
最後に取得したポインタイベントのY座標を返す。

***View.class >> lastEvent
	StringWriter new ->:wr;
	self lastEventType ->:type;
	wr put: type, put: ' ';
	type = #char ifTrue: [wr put: self lastChar describe];
	type = #ptrdown | (type = #ptrup) | (type = #ptrdrag)
		ifTrue: [wr put: self lastX, put: ' ', put: self lastY];
	wr asString!

***View.class >> eventFilter: value
	self shouldBeImplemented
****[man.m]
*****#en
Set the value of the event filter to value.

The values are as follows:
	0 -- Only character input events are valid.
	1 -- Enable character input and pointer events.
*****#ja
イベントフィルタの値をvalueに設定する。

値は以下の通り。
	0 -- 文字入力イベントのみ有効とする。
	1 -- 文字入力イベントとポインタイベントを有効とする。

***terminal i/f.
****View.class >> shiftMode: modeArg
	self shouldBeImplemented

****View.class >> getChar
	queuedChar notNil?
		ifTrue:
			[queuedChar ->:result;
			nil ->queuedChar]
		ifFalse:
			[[self getEvent = #char] whileFalse;
			self lastChar ->result];
	result!
*****[man.m]
******#en
Enter one character from the keyboard.

If there are no characters in the input queue, wait until an input is made.
******#ja
キーボードから一文字入力する。

入力キューに文字が無い場合、入力が行われるまで待つ。

****View.class >> hit?
	queuedChar notNil? ifTrue: [true!];
	[self eventEmpty?] whileFalse:
		[self getEvent = #char,
			ifTrue:
				[self lastChar ->queuedChar;
				true!]];
	false!
*****[man.m]
******#en
Returns true if there are characters in the input queue.
******#ja
入力キューに文字がある場合、trueを返す。

*@
	Mulk.hostOS = #android ifTrue: ["a"] ifFalse: ["p"] ->:name;
	Mulk at: ("View." + name) asSymbol in: "view" + name, new ->:v;
	Mulk at: #View put: v;
	Mulk.quitHook addLast: v

*View.FontDrawer implement.
**View.FontDrawer >> init: fontArg
	fontArg kindOf?: String, ifTrue: 
		[Dictionary new at: #font put: fontArg ->fontArg];
	View basicFont: (fontArg at: #font) ->:coord;
	fontArg at: #fontWidth ifAbsent: [coord coordX] ->fontWidth;
	fontArg at: #fontHeight ifAbsent: [coord coordY] ->fontHeight;
	fontArg at: #offx ifAbsent: [0] ->offx;
	fontArg at: #offy ifAbsent: [0] ->offy;
	fontArg at: #woffx ifAbsent: [0] ->woffx;
	fontArg at: #woffy ifAbsent: [0] ->woffy
**View.FontDrawer >> drawX: x Y: y char: ch foreground: fg background: bg
	ch width ->:cw;
	View fillRectangleX: x Y: y width: fontWidth * cw height: fontHeight
		color: bg;
	cw = 1 
		ifTrue: [View drawX: x + offx Y: y + offy code: ch code color: fg]
		ifFalse: [View drawX: x + woffx Y: y + woffy code: ch code color: fg]
**View.FontDrawer >> fontWidth
	fontWidth!
**View.FontDrawer >> fontHeight
	fontHeight!

*View.Image class.@
	Object addSubclass: #View.Image instanceVars: "width height buffer"
**[man.c]
***#en
Class indicating an image.

Wrap the true color raster image.
In addition to normal initialization, it can be generated from image files with the png and jpeg modules.
***#ja
画像を示すクラス。

True colorラスターイメージをラップする。
通常の初期化の他、pngやjpegモジュールで画像ファイルから生成する事が出来る。

**View.Image >> initWidth: widthArg height: heightArg buffer: bufferArg
	widthArg ->width;
	heightArg ->height;
	bufferArg ->buffer
***[man.m]
****#en
Initializes a View.Image with width widthArg pixels, height heightArg pixels, and content bufferArg.
One pixel in bufferArg is represented by 3 bytes of RGB, and is arranged from the upper left to the lower right without any gap.
****#ja
幅widthArgピクセル、高さheightArgピクセル、内容bufferArgのView.Imageを初期化する。

bufferArg中の1ピクセルはRGBの3バイトで表われ、左上から右下の順に隙間なく並ぶ。
**View.Image >> width
	width!
***[man.m]
****#en
Returns the width of the image.
****#ja
イメージの幅を返す。

**View.Image >> height
	height!
***[man.m]
****#en
Returns the height of the image.
****#ja
イメージの高さを返す。

**View.Image >> buffer
	buffer!
