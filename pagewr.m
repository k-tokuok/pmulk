PageWriter class
$Id: mulk pagewr.m 1344 2024-12-30 Mon 21:22:01 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
The contents written in Writer are displayed page by page to the screen.
.hierarchy PageWriter
**#ja
.caption 説明
Writerに書き込んだ内容を、ページ単位で画面に出力する。
.hierarchy PageWriter

*PageWriter class.@
	Mulk import: #("wcbuild" "console");
	Object addSubclass: #PageWriter instanceVars: "x y putLnIfLineFilled? wcb",
		features: #(Writer)
	
**PageWriter >> reset
	0 ->x ->y
**PageWriter >> init
	WideCharBuilder new ->wcb;
	self reset;
	Console autoLineFeedIfLineFilled? not ->putLnIfLineFilled?
**PageWriter >> lineFeed
	y + 1 ->y;
	0 ->x
**PageWriter >> pause
	Out0 put: "---";
	In0 getLn;
	0 ->y
**PageWriter >> putByte: code
	Console width ->:w;
	
	wcb build: code ->:ch, nil? ifTrue: [self!];
	x = w ifTrue:
		[self lineFeed;
		putLnIfLineFilled? ifTrue: [Out0 putLn];
		ch = '\n' ifTrue: [self!]];
	x = 0 and: [y = (Console height - 1)], ifTrue: [self pause];
	ch = '\t' ifTrue: [self putSpaces: 4 - (x % 4)!];
	ch width ->:cw;
	x + cw > w ifTrue:
		[self putLn;
		self put: ch!];
	ch = '\n' ifTrue: [self lineFeed];
	Out0 put: ch;
	x + cw ->x
