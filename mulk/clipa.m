clipboard for Android (Clip.a class)
$Id: mulk clipa.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja Android版クリップボード (Clip.a class)

*[man]
**#en
.caption DESCRIPTION
Android implementation of clipboard.
.hierarchy Clip.a
.caption SEE ALSO
.summary cliplib
**#ja
.caption 説明
Androidのクリップボード実装。
.hierarchy Clip.a
.caption 関連項目
.summary cliplib

*import.@
	Mulk import: "cliplib";
	Android
		method: #clipPut signature: "VS",
		method: #clipGet signature: "B"
		
*Clip.a class.@
	Clip.class addSubclass: #Clip.a
**Clip.a >> copyTo: streamArg
	streamArg write: (Android call: #clipGet)
**Clip.a >> copyFrom: streamArg
	Android call: #clipPut with: streamArg contentBytes

*regist.@
	Clip.a new ->Clip

