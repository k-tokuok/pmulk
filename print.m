text printing
$Id: mulk print.m 1346 2025-01-02 Thu 20:00:51 kt $
#ja テキスト印刷

*[man]
**#en
.caption SYNOPSIS
	print [OPTION] FILE
	print.query [-l] FONTHEIGHT
.caption DESCRIPTION
Print a text file to your default printer.

The query subcommand displays the number of characters that the default printer can print in the specified height font in mm.
At this time, if the -l option is specified, landscape paper is used.
.caption OPTION
	m MODE -- Specifies the print mode.
		3 -- 3up/landscape (default)
		2 -- 2up/landscape
		1 -- 1up/portrait
		2p -- 2up/portrait
		w -- 1up/portrait 130 columns
		s -- 40x30 for smartphones and tablets
	n -- Print line numbers.
	d -- 2-sided printing.
	c N -- Print copies of N copies.
	u -- Print UTF-8 files.
.caption LIMITATION
Works only on Windows.
**#ja
.caption 書式
	print [オプション] FILE
	print.query [-l] fontHeight
.caption 説明
テキストファイルをデフォルトプリンタへ印刷する。

queryサブコマンドはデフォルトプリンタがmm単位で指定された高さのフォントで印刷出来る文字数を表示する。
この時-lオプションを指定すると横長の紙を使用する。
.caption オプション
	m mode -- 印刷モードを指定する。
		3 -- 3up/横 (default)
		2 -- 2up/横
		1 -- 1up/縦
		2p -- 2up/縦
		w -- 1up/縦 幅130カラム
		s -- スマホ/タブレット向け 40x30
	n -- 行番号を印刷。
	d -- 両面印刷。
	c N -- コピーをN部印刷。
	u -- UTF-8のファイルを印刷する。
.caption 制限事項
Windowsでのみ動作。

*print tool.@
	Mulk import: #("dl" "optparse");
	Object addSubclass: #Cmd.print
		instanceVars:
			--config
			"fontHeightMM height width column cgap landscape?"
			+ " duplex? copies title"
			--Windows print service.
			+ " device driver devmode hDC hFont hOldFont"
			+ " paperWidthPix paperHeightPix paperHeightMM fontHeightPix"
			+ " paperWidth paperHeight" -- char unit.

**setups.
***Cmd.print >> setup: args
	args at: 0 ->fontHeightMM;
	args at: 1 ->height;
	args at: 2 ->width;
	args at: 3 ->column;
	args at: 4 ->cgap;
	args at: 5 ->landscape?
***Cmd.print >> setup.1
	self setup: #(4.0 60 80 1 0 false)
***Cmd.print >> setup.2
	self setup: #(3.2 50 80 2 2 true)
***Cmd.print >> setup.3
	self setup: #(2.3 71 80 3 2 true)
***Cmd.print >> setup.2p
	self setup: #(2 130 80 2 2 false)
***Cmd.print >> setup.w
	self setup: #(2.8 90 130 1 0 false)
***Cmd.print >> setup.s
	self setup: #(8 30 40 1 0 false)
	
**Windows print service.
***load dll.@
	DL import: "kernel32.dll" procs: #(#GetProfileStringA 105);
	DL import: "winspool.drv" procs:
		#(#OpenPrinterA 103 #DocumentPropertiesA 106 #ClosePrinter 101);
	DL import: "gdi32.dll" procs:
		#(#CreateDCA 104 #GetDeviceCaps 102 #CreateFontA 114
		#GetTextMetricsA 102 #SelectObject 102 #StartDocA 102 #StartPage 101
		#TextOutA 105 #EndPage 101 #EndDoc 101 #DeleteObject 101 #DeleteDC 101)

***Cmd.print.DEVMODE class.@
	DL.Buffer addSubclass: #Cmd.print.DEVMODE
****Cmd.print.DEVMODE >> dmFields
	buffer i32At: 40!
****Cmd.print.DEVMODE >> landscape
	self dmFields & 1 {DM_ORIENTATION} = 0
		ifTrue: [self error: "printer does not support landscape."];
	buffer i16At: 44 put: 2 {DMORIENT_LANDSCAPE}
****Cmd.print.DEVMODE >> duplex
	self dmFields & 0x1000 {DM_DUPLEX} = 0
		ifTrue: [self error: "printer does not support duplex printing."];
	buffer i16At: 62 put: 2 {DMDUP_VERTICAL}

***Cmd.print >> getDefaultPrinter
	FixedByteArray basicNew: 255 ->:buf;
	DL call: #GetProfileStringA with: #("windows" "device" "?") with: buf
		with: 256;
	buf asStringFromCString ->:s, = "?" ifTrue:
		[self error: "getDefaultPrinter failed"];
	s indexOf: ',' ->:cp0;
	s copyUntil: cp0 ->device;
	s indexOf: ',' after: cp0 + 1 ->:cp1;
	s copyFrom: cp0 + 1 until: cp1 ->driver
***Cmd.print >> setupDevmode
	DL call: #OpenPrinterA with: device
		with: (DL.IntPtrBuffer new ->:hPrinter) with: 0, = 0,
		ifTrue: [self error: "OpenPrinter failed."];
	hPrinter value ->hPrinter;
	
	DL call: #DocumentPropertiesA with: 0 with: hPrinter with: device
		with: #(0 0 0) ->:devmodeSize;
	Cmd.print.DEVMODE new init: devmodeSize ->devmode;

	DL call: #DocumentPropertiesA with: 0 with: hPrinter with: device
		with: devmode with: #(0 2 {DM_OUT_BUFFER}), <> 1,
		ifTrue: [self error: "DocumentProperties failed."];

	landscape? ifTrue: [devmode landscape];
	duplex? ifTrue: [devmode duplex];

	DL call: #DocumentPropertiesA with: 0 with: hPrinter with: device
		with: devmode with: devmode with: 10 {DM_(IN|OUT)_BUFFER}, <> 1,
		ifTrue: [self error: "DocumentProperties merge failed."];

	DL call: #ClosePrinter with: hPrinter
***Cmd.print >> createDC
	DL call: #CreateDCA with: driver with: device with: 0 with: devmode
		->hDC, = 0
		ifTrue: [self error: "CreateDC failed."]
***Cmd.print >> getPaperInfo
	DL call: #GetDeviceCaps with: hDC with: 8 {HORZRES} ->paperWidthPix;
	DL call: #GetDeviceCaps with: hDC with: 10 {VERTRES} ->paperHeightPix;
	DL call: #GetDeviceCaps with: hDC with: 6 {VERTSIZE} ->paperHeightMM
***Cmd.print >> createFont
	DL call: #CreateFontA
		with: (fontHeightMM asFloat * paperHeightPix / paperHeightMM) asInteger
			--nHeight
		with: #(0 --nWidth
			0 --nEscapement
			0 --nOrientation
			0 --fnWeight=FW_DONTCARE
			0 --fdwItalic=FALSE
			0 --fdwUnderline=FALSE
			0 --fdwStrikeOut=FALSE
			128 --fdwCharset=SHIFTJIS_CHARSET
			0 --fdwOutputPrecision=OUT_DEFAULT_PRECIS
			0 --fdwClipPrecision=CLIP_DEFAULT_PRECIS
			0 --fdwQuality=DEFAULT_QUALITY
			1 --fdwPitchAndFamily=FIXED_PITCH|FF_DONTCARE
			"MS Mincho" --lpszFace
			) ->hFont;
	hFont = 0 ifTrue: [self error: "CreateFont failed."]
***Cmd.print >> getFontInfo
	DL.Buffer new init: 56 {sizeof(TEXTMETRICA)} ->:textmetric;
	DL call: #GetTextMetricsA with: hDC with: textmetric;
	paperWidthPix // (textmetric buffer i32At: 20 {tmAveCharWidth})
		->paperWidth;
	textmetric buffer i32At: 0 {tmHeight} ->fontHeightPix;
	paperHeightPix // fontHeightPix -> paperHeight
***Cmd.print >> printerSetup
	self getDefaultPrinter;
	self setupDevmode;
	self createDC;
	self getPaperInfo;
	self createFont;
	DL call: #SelectObject with: hDC with: hFont ->hOldFont;
	self getFontInfo
***Cmd.print >> print: ms
	DL.ptrByteSize = 4
		ifTrue:
			[20 ->:docInfoSize; {sizeof(DOCINFOA)}
			4 ->:titleOffset]
		ifFalse:
			[40 ->docInfoSize;
			8 ->titleOffset];
	DL.Struct new init: docInfoSize ->:docInfo;
	docInfo at: 0 put: docInfoSize;
	docInfo at: titleOffset put: title;
	DL call: #StartDocA with: hDC with: docInfo;

	copies timesRepeat:
		[0 ->:lineNo;
		0 ->:pageNo;
		ms seek: 0;
		ms contentLinesDo:
			[:s
			lineNo % paperHeight ->:y;
			y = 0 ifTrue:
				[lineNo <> 0 ifTrue:
					[DL call: #EndPage with: hDC;
					pageNo + 1 ->pageNo];
				DL call: #StartPage with: hDC];
			DL call: #TextOutA with: hDC with: 0 with: y * fontHeightPix
				with: s with: s size;
			lineNo + 1 ->lineNo];
		lineNo <> 0 ifTrue:
			[DL call: #EndPage with: hDC;
			pageNo + 1 ->pageNo];
		duplex? & (pageNo % 2 = 1) ifTrue:
			[DL call: #StartPage with: hDC;
			DL call: #EndPage with: hDC]];
	DL call: #EndDoc with: hDC
***Cmd.print >> printerFinish
	DL call: #SelectObject with: hDC with: hOldFont;
	DL call: #DeleteObject with: hFont;
	DL call: #DeleteDC with: hDC

**vertical format.
***Cmd.print >> putLines: n
	n timesRepeat: [Out putLn]
***Cmd.print >> putFooter: pageNo fgap: fgap
	Out putLn;
	pageNo asString ->pageNo;
	Out putSpaces: width - pageNo size // 2, putLn: pageNo;
	self putLines: fgap
***Cmd.print >> vformat
	width < 70 ifTrue: [2] ifFalse: [1] ->:headerHeight;
	paperHeight - height - 3 - headerHeight // 2 ->:hgap;
	paperHeight - height - 3 - headerHeight - hgap ->:fgap;

	DateAndTime new initNow asString ->:dateString;
	headerHeight = 1
		ifTrue:
			[StringWriter new put: title,
			putSpaces: width - title size - dateString size,
			put: dateString, asString ->:header]
		ifFalse:
			[title ->header;
			dateString ->:header2];
		
	0 ->:lineNo;
	1 ->:pageNo;
	
	In contentLinesDo:
		[:line
		lineNo = 0 ifTrue:
			[self putLines: hgap;
			Out putLn: header;
			header2 notNil? ifTrue: [Out putLn: header2];
			Out putLn];
		Out putLn: line;
		lineNo + 1 ->lineNo;
		lineNo = height ifTrue:
			[self putFooter: pageNo fgap: fgap;
			pageNo + 1 ->pageNo;
			0 ->lineNo]];
	lineNo <> 0 ifTrue:
		[self putLines: height - lineNo;
		self putFooter: pageNo fgap: fgap]

**horizontal format.
***Cmd.print >> flush: array
	array do:
		[:w
		Out putLn: w asString]
***Cmd.print >> hformat
	paperWidth - (column * width) - (column - 1 * cgap) // 2 ->:lgap;
	
	0 ->:lineNo;
	0 ->:columnNo;
	Array new size: paperHeight ->:array;
	In contentLinesDo:
		[:line
		columnNo = 0
			ifTrue:
				[array at: lineNo put: (StringWriter new ->:w);
				w putSpaces: lgap]
			ifFalse:
				[array at: lineNo ->w;
				w putSpaces: cgap];
		w put: line, putSpaces: width - line size;
		lineNo + 1 ->lineNo;
		lineNo = paperHeight ifTrue:
			[0 ->lineNo;
			columnNo + 1 ->columnNo;
			columnNo = column ifTrue:
				[self flush: array;
				0 ->columnNo]]];
	lineNo = 0 & (columnNo = 0) ifFalse:
		[self flush: array]

**Cmd.print >> main: args
	OptionParser new init: "m:ndc:u" ->:op, parse: args ->args;
	op at: 'm' ->:oa, nil? ifTrue: ["3"] ifFalse: [oa] ->:mode;
	op at: 'n' ->:nl?;
	op at: 'd' ->duplex?;
	op at: 'c' ->oa, nil? ifTrue: [1] ifFalse: [oa asInteger] ->copies;
	op at: 'u' ->:utf8?;

	args first ->:fn ->title;
	self perform: ("setup." + mode) asSymbol;

	self printerSetup;

	utf8? ifTrue: ["ctr u = | "] ifFalse: [""] ->:cmdLine;
	cmdLine + "detab" ->cmdLine;
	nl? ifTrue: [cmdLine + " | nl" ->cmdLine];
	cmdLine + " | fold " + width + " | deff " + height ->cmdLine;
	
	fn asFile pipe: cmdLine,
		pipe: [self vformat],
		pipe: [self hformat] ->:ms;

	self print: ms;

	self printerFinish
**Cmd.print >> main.query: args
	OptionParser new init: "l" ->:op, parse: args ->args;
	op at: 'l' ->landscape?;
	args first asNumber ->fontHeightMM;
	false ->duplex?;
	self printerSetup;
	Out putLn: paperWidth asString + 'x' + paperHeight;
	self printerFinish
