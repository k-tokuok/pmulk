clipboard with host os command (Clip.c clipboard)
$Id: mulk clipc.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ホストOSコマンドによるクリップボード (Clip.c class)

*[man]
**#en
.caption DESCRIPTION
Base class of implementation that accesses clipboard by host OS command.
.hierarchy Clip.c
.caption SEE ALSO
.summary cliplib
**#ja
.caption 説明
クリップボードをホストOSのコマンドでアクセスする実装の基定クラス。
.hierarchy Clip.c
.caption 関連項目
.summary cliplib

*import.@
	Mulk import: "cliplib"
	
*Clip.c class.@
	Clip.class addSubclass: #Clip.c instanceVars: "getCmd putCmd"
**Clip.c >> copyTo: streamArg
	getCmd pipeTo: streamArg
**Clip.c >> copyFrom: streamArg
	streamArg pipe: putCmd
