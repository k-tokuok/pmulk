fast move files
$Id: mulk fmv.m 1339 2024-12-26 Thu 21:56:19 kt $
#ja ファイルの高速移動

*[man]
**#en
.caption SYNOPSIS
	fmv [OPTION] [SRC...] DEST
.caption DESCRIPTION
Move file or directory SRC to DEST.

If DEST is a directory, multiple SRCs can be specified and all will be moved under DEST.
If SRC is omitted, get SRC list from standard input.

Fast, but may be subject to host OS specification limitations.
.caption option
	v -- Display processings verbosely.

**#ja
.caption 書式
	fmv [OPTION] [SRC...] DEST
.caption 説明
ファイル又はディレクトリSRCをDESTに移動する。

DESTがディレクトリの場合はSRCを複数指定可能で、全てをDEST下へ移動する。
SRCが省略された場合は標準入力からSRCのリストを取得する。

高速だが、ホストOSの仕様制限を受ける場合がある。
.caption オプション
	v -- 処理を詳細に表示する。

*fmv tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.fmv instanceVars: "verbose?"
	
**Mulk.hostOS = #windows >
***@
	Mulk at: #DL in: "dl", import: "kernel32.dll" procs: #(#MoveFileA 102)
***Cmd.fmv >> basicMove: src to: dest
	DL call: #MoveFileA with: src hostPath with: dest hostPath ->:st;
	self assert: st <> 0
	
**Mulk.hostOSUnix? >
***Cmd.fmv >> basicMove: src to: dest
	"os mv " + src quotedPath + ' ' + dest quotedPath, runCmd
	
**Cmd.fmv >> move: src to: dest
	verbose? ifTrue: [Kernel currentProcess printCall];
	self assert: src none? not;
	self assert: dest none?;
	self basicMove: src to: dest
**Cmd.fmv >> main: args
	OptionParser new init: "v" ->:op, parse: args ->args;
	op at: 'v' ->verbose?;
	args last asFile ->:dest;
	args removeLast;

	args empty? ifTrue: [In contentLines asArray ->args];

	dest directory?
		ifTrue:
			[args do:
				[:f
				self move: f asFile to: dest + f]]
		ifFalse:
			[self assert: args size = 1;
			self move: args first asFile to: dest]
