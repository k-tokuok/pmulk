clipboard for macosx (Clip.m class)
$Id: mulk clipm.m 422 2020-05-09 Sat 22:42:52 kt $
#ja MacOSX版クリップボード (Clip.m class)

*[man]
**#en
.caption DESCRIPTION
Clipboard implementation by pbpaste / pbcopy command.
.hierarchy Clip.m
.caption SEE ALSO
.summary clipc
**#ja
.caption 説明
pbpaste/pbcopyコマンドによるクリップボード実装。
.hierarchy Clip.m
.caption 関連項目
.summary clipc

*import.@
	Mulk import: "clipc"

*Clip.m class.@
	Clip.c addSubclass: #Clip.m
**Clip.m >> init
	"os pbpaste" ->getCmd;
	"os -i pbcopy" ->putCmd

*regist.@
	Clip.m new ->Clip
