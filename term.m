character terminal control (Terminal class)
$Id: mulk term.m 1299 2024-11-10 Sun 15:32:06 kt $
#ja キャラクタ端末制御 (Terminal class)

*[man]
**#en
.caption DESCRIPTION
Accessor class for character terminal control primitives.
.hierarchy Terminal
Normally, screen control is performed via ScreenConsole, so it is not necessary to handle this class directly.
.caption SEE ALSO
.summary c-term
**#ja
.caption 説明
キャラクタ端末制御プリミティブのアクセサクラス。
.hierarchy Terminal
通常、画面制御はScreenConsoleを経由して行うので、本クラスを直接扱う必要はない。
.caption 関連項目
.summary c-term

*Terminal class.@
	Mulk import: "coord";
	Object addSubclass: #Terminal instanceVars: "width height"
	
**primitives.
***Terminal >> basicStart
	$term_start
***Terminal >> finish
	$term_finish
***Terminal >> get
	$term_get
***Terminal >> putWideCode: code
	$term_put
***Terminal >> hit?
	$term_hit_p
***Terminal >> gotoX: x Y: y
	$term_goto_xy
***Terminal >> clear
	$term_clear

**Terminal >> start
	self basicStart ->:coord, coordX ->width;
	coord coordY ->height
**Terminal >> width
	width!
**Terminal >> height
	height!
**Terminal >> put: wchar
	self putWideCode: wchar code
	
**Terminal >> autoLineFeedIfLineFilled?
	Mulk.hostOS ->:os, = #windows or: [os = #cygwin], or: [os = #dos]!
