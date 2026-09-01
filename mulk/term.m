character-based terminal control
$Id: mulk term.m 1634 2026-08-20 Thu 23:36:06 kt $
#ja キャラクタ端末制御

*[man]
**#en
.caption DESCRIPTION
A class that defines the accessor object (Term) for a character-based terminal.

Since screen control is typically handled through ScreenConsole, there is no need to interact with this class directly.
Term is a global object and must not be reconstructed.
.caption SEE ALSO
.summary c-term
**#ja
.caption 説明
キャラクタ端末のアクセサオブジェクト(Term)を定義するクラス。

通常、画面制御はScreenConsoleを経由して行うので、本クラスを直接扱う必要は無い。
Termはグローバルオブジェクトであり、再構築してはならない。
.caption 関連項目
.summary c-term

*Term.class class.@
	Mulk import: "coord";
	Object addSubclass: #Term.class instanceVars: 
		"width height repositionForWideChar?"
	
**primitives.
***Term.class >> basicStart
	$term_start
***Term.class >> finish
	$term_finish
***Term.class >> get
	$term_get
***Term.class >> putWideCode: code
	$term_put
***Term.class >> hit?
	$term_hit_p
***Term.class >> gotoX: x Y: y
	$term_goto_xy
***Term.class >> clear
	$term_clear

**Term.class >> init
	true ->repositionForWideChar?
**Term.class >> start
	self basicStart ->:coord, coordX ->width;
	coord coordY ->height
**Term.class >> width
	width!
**Term.class >> height
	height!
**Term.class >> put: wchar
	self putWideCode: wchar code
	
**Term.class >> autoLineFeedIfLineFilled?
	Mulk.hostOS ->:os, = #windows or: [os = #cygwin], or: [os = #dos]!

**Term.class >> repositionForWideChar: arg
	arg ->repositionForWideChar?
***[man.m]
****#en
If you set this to 'true', the cursor will be moved to the correct position each time a WideChar is output.
Set this when using a font where 'Char >> width' does not match the glyph width.
****#ja
trueを設定すると、WideCharを出力する際に毎回カーソルを正しい位置へ移動する。
Char >> widthとグリフの幅が一致しないフォントを使用する場合に設定する。

**Term.class >> repositionForWideChar?
	repositionForWideChar?!
	
*constract.@
	Mulk at: #Term put: Term.class new
