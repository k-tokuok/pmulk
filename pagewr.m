PageWriter class
$Id: mulk pagewr.m 406 2020-04-19 Sun 11:29:54 kt $
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
	Object addSubclass: #PageWriter instanceVars:
		"width height x y putLnIfLineFilled?"
		+ " wcb", 
		features: #(Writer)
	
**PageWriter >> reset
	0 ->x ->y
**PageWriter >> init
	Console width ->width;
	Console height - 1 ->height;
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
	wcb build: code ->:ch, nil? ifTrue: [self!];
	x = width ifTrue:
		[self lineFeed;
		putLnIfLineFilled? ifTrue: [Out0 putLn];
		ch = '\n' ifTrue: [self!]];
	x = 0 & (y = height) ifTrue: [self pause];
	ch = '\t' ifTrue: [self putSpaces: 4 - (x % 4)!];
	x + ch width > width ifTrue:
		[self putLn;
		self put: ch!];
	ch = '\n' ifTrue: [self lineFeed];
	Out0 put: ch;
	x + ch width ->x
