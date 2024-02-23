switch console
$Id: mulk cset.m 406 2020-04-19 Sun 11:29:54 kt $
#ja コンソールの切り替え

*[man]
**#en
.caption SYNOPSIS
	cset SET
.caption DESCRIPTION
Switch console to SET.
.caption SEE ALSO
.summary console
**#ja
.caption 書式
	cset SET
.caption 説明
コンソールをSETに切り替える。
.caption 関連項目
.summary console

*Cmd.cset class.@
	Object addSubclass: #Cmd.cset
**Cmd.cset >> main: args
	args first ->:cn;
	Mulk at: ("Console." + cn) asSymbol in: "c-" + cn, new switch
