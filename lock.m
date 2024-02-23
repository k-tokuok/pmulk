exclusive processing
$Id: mulk lock.m 406 2020-04-19 Sun 11:29:54 kt $
#ja 排他処理

*[man]
**#en
.caption DESCRIPTION
Exclusive processing with file path as key.

The file does not need to exist, but it must be able to open in write mode.
The file is used only as a key, and even when it is locked, it cannot be written to the file while locked.
**#ja
.caption 説明
ファイルパスをキーとした排他処理。

ファイルは存在する必要はないがwriteモードでオープン出来る必要がある。
ファイルはキーとしてのみ使用され、ロック中は自プロセスであってもファイルに書き込みを行う事は出来ない。

*FileStream >> basicLock: lock? fp: fpArg
	$lock
*FileStream >> lock: lock?
	self basicLock: lock? fp: fp

*File >> lockDo: blockArg
	self writeDo:
		[:str
		str lock: true;
		[blockArg value] finally: [str lock: false]]!
**[man.m]
***#en
Evaluate block exclusively

If a conflict occurs, wait until it is resolved.
It is impossible to know in advance whether there is a conflict.
Do not leave the block in any way other than the end or exception.
***#ja
ブロックを排他的に評価する

競合が発生した場合、解消されるまで待ちに入る。
競合の有無を事前に知る事は出来ない。
終端もしくは例外以外の形でblockから抜けてはならない。
