codepage 932
$Id: mulk cp932.m 1551 2026-03-12 Thu 22:24:03 kt $
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
