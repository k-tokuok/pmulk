clipboard for x11 (Clip.x class)
$Id: mulk clipx.m 422 2020-05-09 Sat 22:42:52 kt $
#ja X11版クリップボード (Clip.x class)

*[man]
**#en
.caption DESCRIPTION
Clipboard implementation by xsel command.
.hierarchy Clip.x
.caption SEE ALSO
.summary clipc
**#ja
.caption 説明
xselコマンドによるクリップボード実装。
.hierarchy Clip.x
.caption 関連項目
.summary clipc

*import.@
	Mulk import: "clipc"

*Clip.x class.@
	Clip.c addSubclass: #Clip.x
**Clip.x >> init
	"os xsel -bo" ->getCmd;
	"os -i xsel -bi" ->putCmd

*regist.@
	Clip.x new ->Clip
