View.p class
$Id: mulk viewp.m 1010 2023-02-01 Wed 22:44:35 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
View.class class primitive implementation.
.hierarchy View.p
Implementation of graphic screen on Windows, X, SDL.

When opening the View, fonts that are common to the host's window system are selected.
If it is specified in #View.p.initialFont of the system dictionary, that is prioritized.
You must always specify this in SDL.
.caption SEE ALSO
.summary view
**#ja
.caption 説明
View.class classのprimitive実装。
.hierarchy View.p
Windows、X、SDLでのグラフィック画面を実現する。

Viewを開く際、フォントはホストのウィンドウシステムで一般的なものが選択される。
システム辞書の#View.p.initialFontに指定があれば、そちらが優先される。
SDLでは必ずこれを指定する必要がある。
.caption 関連項目
.summary view

*View.p class.@
	View.class addSubclass: #View.p instanceVars: "open?"
**View.p >> init
	super init;
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
		Mulk at: #View.p.initialFont ifAbsent:
			[Mulk.hostOS = #windows
				ifTrue: ["MS Gothic"] ifFalse: ["8x13,kanji16,8x16kana"]]
			->:font;
		self font: font;
		Mulk includesKey?: #ScreenConsole.keymap, ifTrue:
			[self loadKeymap: (Mulk at: #ScreenConsole.keymap) path];
		true ->open?];
	self clear
***[man.m]
****#en
Open a View with width widthArg pixels and height heightArg pixels.
****#ja
幅widthArgピクセル、高さheightArgピクセルのViewを開く。

**View.p >> open
	self openWidth: 640 height: 480
	
**View.p >> x: x y: y
	$view_move
***[man.m]
****#en
Move View to coordinates (x,y).
****#ja
Viewを座標(x,y)に移動する。

**View.p >> basicWidth: w height: h
	$view_resize
**View.p >> width: widthArg height: heightArg
	self basicWidth: widthArg height: heightArg;
	widthArg ->width;
	heightArg ->height
***[man.m]
****#en
Resize View to width widthArg pixels and height heightArg pixels.
****#ja
Viewを幅widthArgピクセル、高さheightArgピクセルにリサイズする。

**View.p >> basicFont: fontName
	$view_set_font
	
**View.p >> basicClose
	$view_close
**View.p >> close
	open? ifTrue:
		[self basicClose;
		false ->open?]
		
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
**View.p >> loadKeymap: fnArg
	$view_load_keymap
**View.p >> shiftMode: modeArg
	$view_set_shift_mode
**View.p >> eventFilter: modeArg
	$view_set_event_filter
**View.p >> basicGetEvent
	$view_get_event
**View.p >> eventEmpty?
	$view_event_empty_p
**View.p >> updateInterval: arg
	$view_set_update_interval
