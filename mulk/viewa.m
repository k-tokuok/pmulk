View.a class
$Id: mulk viewa.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Android implementation of View.class class.
.hierarchy View.a
.caption SEE ALSO
.summary view
**#ja
.caption 説明
View.class classのAndroid実装。
.hierarchy View.a
.caption 関連項目
.summary view

*import.@
	Mulk import: "coord"
	
*View.a class.@
	View.class addSubclass: #View.a
**View.a >> open
	Android
		method: #viewGetSize signature: "I",
		method: #viewSetFontSize signature: "ID",
		method: #viewFillRectangle signature: "VIIIII",
		method: #viewDrawChar signature: "VIIJI",
		method: #viewDrawLine signature: "VIIIII",
		method: #viewDrawPolygon signature: "VAI",
		method: #viewSetShiftMode signature: "VI",
		method: #viewSetEventFilter signature: "VI",
		method: #viewGetEvent signature: "I",
		method: #viewIsEventEmpty signature: "I",
		method: #viewSetUpdateInterval signature: "II";
	Android call: #viewGetSize ->:coord, coordX ->width;
	coord coordY ->height;
	self font: "16";
	self clear	
**View.a >> basicFont: fontName
	Android call: #viewSetFontSize with: fontName asNumber asFloat!
**View.a >> fillRectangleX: x Y: y width: w height: h color: color
	Android call: #viewFillRectangle with: x with: y with: w with: h
		with: color
**View.a >> drawX: x Y: y code: code color: color
	Android call: #viewDrawChar with: x with: y with: code with: color
**View.a >> drawLineX: x0 Y: y0 X: x1 Y: y1 color: color
	Android call: #viewDrawLine with: x0 with: y0 with: x1 with: y1 with: color
**View.a >> putTrueColorImageX: x Y: y rgb: rgb width: w height: h
	self!
**View.a >> drawPolygon: points color: color
	Android call: #viewDrawPolygon with: points with: color
**View.a >> shiftMode: modeArg
	Android call: #viewSetShiftMode with: modeArg
**View.a >> eventFilter: modeArg
	Android call: #viewSetEventFilter with: modeArg
**View.a >> basicGetEvent
	Android call: #viewGetEvent!
**View.a >> eventEmpty?
	Android call: #viewIsEventEmpty, <> 0!
**View.a >> updateInterval: arg
	Android call: #viewSetUpdateInterval with: arg!
**View.a >> updateInterval
	self updateInterval: 0 ->:result;
	self updateInterval: result;
	result!
