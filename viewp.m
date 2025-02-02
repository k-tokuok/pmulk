View.p class
$Id: mulk viewp.m 1347 2025-01-09 Thu 22:11:51 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
View.class class primitive implementation.
.hierarchy View.p
Implementation of graphic screen on Windows, X, SDL.

When opening a View, the font is selected from those common to the window system.
If View.p.font is specified in the system dictionary, it will take precedence.

In some environments, special shift mode can be used by specifying the keymap file of the keyboard to be used in View.p.keymap of the system dictionary.
The keymap file is a file starting with "k-" in the system directory.

In SDL, View.p.font and View.p.keymap must be specified.
.caption SEE ALSO
.summary view
.summary coord
**#ja
.caption 説明
View.class classのprimitive実装。
.hierarchy View.p
Windows、X、SDLでのグラフィック画面を実現する。

Viewを開く際、フォントはウィンドウシステムで一般的なものが選択される。
システム辞書のView.p.fontに指定があれば、そちらが優先される。

環境によってはシステム辞書のView.p.keymapに使用するキーボードのキーマップファイルを指定することで特殊シフトモードを使用することができる。
キーマップファイルはシステムディレクトリの"k-"で始まるファイルである。

SDLではView.p.font, View.p.keymapを必ず指定しなくてはならない。
.caption 関連項目
.summary view
.summary coord

*View.p class.@
	Mulk import: "coord";
	View.class addSubclass: #View.p instanceVars: "open?"
**View.p >> basicInit
	$view_init
**View.p >> init
	super init;
	self basicInit;
	false ->open?
**View.p >> serializeTo: writer
	open? ->:savedOpen?;
	false ->open?;
	super serializeTo: writer;
	savedOpen? ->open?
	
**View.p >> basicOpenWidth: w height: h
	$view_open
**View.p >> openWidth: widthArg height: heightArg
	open? ifFalse:
		[self basicOpenWidth: widthArg height: heightArg;	
		widthArg ->width;
		heightArg ->height;
		Mulk at: #View.p.font ifAbsent:
			[Mulk.hostOS = #windows ifTrue: [""] ifFalse: ["fixed"]] ->:font;
		self font: font;
		Mulk includesKey?: #View.p.keymap, ifTrue:
			[self loadKeymap: (Mulk at: #View.p.keymap)];
		true ->open?];
	self clear
***[man.m]
****#en
Open a View with width widthArg pixels and height heightArg pixels.
****#ja
幅widthArgピクセル、高さheightArgピクセルのViewを開く。

**View.p >> open
	self openWidth: 640 height: 480
	
**View.p >> basicFont: fontName
	$view_set_font
	
**View.p >> basicClose
	$view_close
**View.p >> close
	open? ifTrue:
		[self basicClose;
		false ->open?]
		
**View.p >> finish
	$view_finish
**View.p >> onQuit
	super onQuit;
	self finish
	
**View.p >> fillRectangleX: x Y: y width: w height: h color: color
	$view_fill_rectangle
**View.p >> drawX: x Y: y code: code color: color
	$view_draw_char
**View.p >> drawLineX: x0 Y: y0 X: x1 Y: y1 color: color
	$view_draw_line
**View.p >> putTrueColorImageX: x Y: y rgb: rgb width: w height: h
	$view_put_true_color_image
**View.p >> drawPolygon: pointsArg color: colorArg
	$view_draw_polygon
**View.p >> putMonochromeImageX: x Y: y bitmap: bitmap width: w height: h
		foreground: fg background: bg
	$view_put_monochrome_image
**View.p >> loadKeymap: fileArg
	Kernel propertyAt: 202 put: fileArg path
**View.p >> shiftMode: modeArg
	Kernel propertyAt: 203 put: modeArg
**View.p >> eventFilter: modeArg
	Kernel propertyAt: 201 put: modeArg!
**View.p >> basicGetEvent
	$view_get_event
**View.p >> eventEmpty?
	$view_event_empty_p
**View.p >> updateInterval: arg
	Kernel propertyAt: 200 put: arg!
**View.p >> updateInterval
	Kernel propertyAt: 200!

**View.p >> position
	Kernel propertyAt: 204!
***[man.m]
****#en
Returns the View position in coord format.
****#ja
Viewの位置をcoord形式で返す。

**View.p >> position: coordArg
	Kernel propertyAt: 204 put: coordArg
***[man.m]
****#en
Set the View position in coord format.
****#ja
Viewの位置をcoord形式で設定する。

**View.p >> size: coordArg
	Kernel propertyAt: 205 put: coordArg;
	coordArg coordX ->width;
	coordArg coordY ->height
***[man.m]
****#en
Sets the size of the View's drawing area in pixels in coord format.
****#ja
Viewの描画領域のサイズをピクセル単位でcoord形式で設定する。

**View.p >> screenSize
	Kernel propertyAt: 206!	
***[man.m]
****#en
Returns screen size in pixels in coord format.
****#ja
画面サイズをピクセル単位でcoord形式で返す。

**View.p >> frameSize
	Kernel propertyAt: 207!
***[man.m]
****#en
Returns the size of the View, including its frame, in pixels in coord format.
****#ja
Viewの枠を含めたサイズをピクセル単位でcoord形式で返す。
