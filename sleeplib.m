sleep for a specified number of seconds (Number >> sleep)
$Id: mulk sleeplib.m 623 2020-12-30 Wed 21:59:53 kt $
#ja 指定秒数の間スリープする (Number >> sleep)

*[man]
**#en
.caption DESCRIPTION
Pauses process execution for the specified number of seconds in real time.

Floating point numbers can be specified, but their precision depends on the host system and implementation.
If an interrupt occurs during execution, the sleep ends and the corresponding interrupt is generated.
**#ja
.caption 説明
実時間で指定された秒数の間プロセスの実行を休止する。

浮動小数点数値を指定する事も出来るが、その精度はホストシステム及び実装に依存する。
実行中に割り込みが発生した場合は、休止を終了し対応する割り込みを発生させる。

*Number >> sleep
	self asFloat sleep
**[man.m]
***#en
Sleeps for the number of seconds specified by the receiver.
***#ja
レシーバーで指定された秒数の間スリープする。

*Float >> sleep
	$sleep
