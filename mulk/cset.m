switch console
$Id: mulk cset.m 1433 2025-06-03 Tue 21:15:38 kt $
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
