codepage 932
$Id: mulk cp932.m 1415 2025-04-27 Sun 07:29:30 kt $
#ja

*[man]
**#en
Switch codepage to Windows CP932.

To be load when building the boot image.
**#ja
Windows CP932にコードページを切替える。

起動イメージを構築する際に読み込むこと。

*@
	Mulk.hostOS = #windows ifTrue: [Mulk at: #Mulk.codepage put: 932];
	Mulk at: #Mulk.charset put: #sjis;
	
	0x40 to: 0x7e, do:
		[:c1
		c1 asChar ->:ch;
		ch basicAt: 1 put: (ch basicAt: 1) | 0x40];
		
	0x80 to: 0xff, do:
		[:c2
		0 ->:attr;
		(0xa1 <= c2) & (c2 <= 0xdf) ifTrue: [attr | 1 ->attr];
		((0x81 <= c2) & (c2 <= 0x9f)) | ((0xe0 <= c2) & (c2 <= 0xfc))
			ifTrue: [attr | 0x20 | (1 << 8) ->attr];
		(0x80 <= c2) & (c2 <= 0xfc) ifTrue: [attr | 0x40 ->attr];
		c2 asChar basicAt: 1 put: attr]
		
*WideChar >> width
	2!
	
*String >> lowerDo: blockArg
	0 ->:trail;
	self do:
		[:ch
		trail = 0
			ifTrue:
				[blockArg value: ch lower;
				ch trailSize ->trail]
			ifFalse:
				[blockArg value: ch;
				trail - 1 ->trail]]
				
*String >> caseInsensitiveEqual?: stringArg
	stringArg memberOf?: String, ifFalse: [false!];
	self size ->:sz, = stringArg size, ifFalse: [false!];
	self hash = stringArg hash,
		and: [self unmatchIndexWith: stringArg size: sz, nil?],
		ifTrue: [true!];

	0 ->:trail;
	self size timesDo:
		[:i
		self at: i ->:ch;
		stringArg at: i ->:ch2;
		trail = 0
			ifTrue:
				[ch lower = ch2 lower ifFalse: [false!];
				ch trailSize ->trail]
			ifFalse:
				[ch = ch2 ifFalse: [false!];
				trail - 1 ->trail]];
	true!
