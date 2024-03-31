clipboard for Windows (Clip.w class)
$Id: mulk clipw.m 1179 2024-03-17 Sun 21:14:15 kt $
#ja Windows版クリップボード (Clip.w class)

*[man]
**#en
.caption DESCRIPTION
Microsoft Windows implementation of clipboard.
.hierarchy Clip.w
.caption SEE ALSO
.summary cliplib
**#ja
.caption 説明
クリップボードのMicrosoft Windows実装。
.hierarchy Clip.w
.caption 関連項目
.summary cliplib

*import.@
	Mulk import: #("cliplib" "dl")
	
*Clip.w class.@
	Clip.class addSubclass: #Clip.w
**import procs.@
	DL import: "user32.dll" procs:
		#(#OpenClipboard 101
		#GetClipboardData 101
		#CloseClipboard 100
		#EmptyClipboard 100
		#SetClipboardData 102);
	DL import: "kernel32.dll" procs:
		#(#GlobalAlloc 102
		#GlobalLock 101
		#GlobalUnlock 101)
**Clip.w >> copyFrom: streamArg
	streamArg contentBytes ->:bytes;
	DL call: #GlobalAlloc with: 0x42 {GMEM_MOVEABLE|GMEM_ZEROINIT}
		with: bytes size + 1 ->:hGlobal;
	DL call: #GlobalLock with: hGlobal ->:p;
	bytes size timesDo: [:i DL byteAt: p + i put: (bytes at: i)];
	DL call: #GlobalUnlock with: hGlobal;
	DL call: #OpenClipboard with: 0;
	DL call: #EmptyClipboard;
	DL call: #SetClipboardData with: 1 {CF_TEXT} with: hGlobal;
	DL call: #CloseClipboard
**Clip.w >> copyTo: streamArg
	DL call: #OpenClipboard with: 0;
	DL call: #GetClipboardData with: 1 {CF_TEXT} ->:hMem, <> 0
		ifTrue:
			[DL call: #GlobalLock with: hMem ->:addr;
			[DL byteAt: addr ->:byte, <> 0] whileTrue:
				[byte = '\n' code
					ifTrue: [streamArg putLn]
					ifFalse:
						[byte <> '\r' code, ifTrue: [streamArg putByte: byte]];
				addr + 1 ->addr];
			DL call: #GlobalUnlock with: hMem];
	DL call: #CloseClipboard

*regist.@
	Clip.w new ->Clip
