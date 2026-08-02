forth processor
$Id: mulk/forth forth.m 1625 2026-07-31 Fri 22:21:07 kt $
#ja

*[man]
**#en
.caption SYNOPSIS
	forth
.caption DESCRIPTION
A 16-bit Forth implementation compliant with FIG-Forth.

To run the program, a memory image (forth.img) and a disk image (forth.scr) are required in the current directory; these are automatically generated upon the first startup.
For information on generating the images, see forthut.
.caption LIMITATION
This program runs only under a console with screen control capabilities.
.caption SEE ALSO
.summary sconsole
.summary forthut

**#ja
.caption 書式
	forth
.caption 説明
FIG-Forthに準拠した16bit forth処理系。

実行にはカレントディレクトリにメモリイメージ(forth.img)とディスクイメージ(forth.scr)の2ファイルが必要で、最初の起動時に自動的に生成する。
イメージの生成についてはforthutを参照。

.caption 制限事項
画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary sconsole
.summary forthut
	
*forth command.@
	Mulk import: "console";
	Object addSubclass: #Cmd.forth
		instanceVars: "mem sp rp ip wa primitives bfs cell blockSize memSize"

**files.
***Cmd.forth >> scrFile
	"forth.scr" asFile!
***Cmd.forth >> imgFile
	"forth.img" asFile!
	
**Cmd.forth >> init: ms
	2 ->cell;
	1024 ->blockSize;
	#( 	#spFetch #spStore #dup #swap #drop
		#rpStore #rFrom #toR #rFetch #fetch
		#store #cFetch #cStore #umPlus #xor
		#and #or #execute #exit #doColon
		#doBranch #do0Branch #doLiteral #doConstant #doVariable
		#bye #emit #key #blockRead #blockWrite
		#blockCount) ->primitives;

	ms ->memSize;
	FixedByteArray basicNew: ms ->mem;
	ms - (64 * cell) ->sp;
	sp - (64 * cell) ->rp;

	self scrFile openUpdate ->bfs

**memory access.
***Cmd.forth >> lw: addr
	mem at: addr, * 256 + (mem at: addr + 1)!
***Cmd.forth >> sw: addr data: data
	mem at: addr put: data >> 8 & 0xff;
	mem at: addr + 1 put: data & 0xff

**data stack.
***Cmd.forth >> push: d
	self sw: sp data: d;
	sp + cell ->sp
***Cmd.forth >> pop
	sp - cell ->sp;
	self lw: sp!

**return stack.
***Cmd.forth >> rPush: d
	self sw: rp data: d;
	rp + cell ->rp
***Cmd.forth >> rPop
	rp - cell ->rp;
	self lw: rp!

**primitives.
***Cmd.forth >> spFetch -- 0: sp@
	self push: sp
***Cmd.forth >> spStore -- 1: sp!
	self pop ->sp
***Cmd.forth >> dup -- 2
	self push: (self lw: sp - cell)
***Cmd.forth >> swap -- 3
	self pop ->:d1;
	self pop ->:d2;
	self push: d1;
	self push: d2
***Cmd.forth >> drop -- 4
	self pop
***Cmd.forth >> rpStore -- 5: rp!
	self pop ->rp
***Cmd.forth >> rFrom -- 6: r>
	self push: self rPop
***Cmd.forth >> toR -- 7: >r
	self rPush: self pop
***Cmd.forth >> rFetch -- 8: r@
	self push: (self lw: rp - cell)
***Cmd.forth >> fetch -- 9: @
	self push: (self lw: self pop)
***Cmd.forth >> store -- 10: !
	self pop ->:addr;
	self sw: addr data: self pop
***Cmd.forth >> cFetch -- 11: c@
	self push: (mem at: self pop)
***Cmd.forth >> cStore -- 12: c!
	self pop ->:addr;
	mem at: addr put: self pop
***Cmd.forth >> umPlus -- 13: um+
	self pop + self pop ->:result;
	self push: result & 0xffff;
	self push: result >> 16
***Cmd.forth >> xor -- 14
	self push: self pop ^ self pop
***Cmd.forth >> and -- 15
	self push: self pop & self pop
***Cmd.forth >> or -- 16
	self push: self pop | self pop
***Cmd.forth >> execute -- 17
	self pop ->wa;
	self perform: (primitives at: (mem at: (self lw: wa)))
***Cmd.forth >> exit -- 18
	self rPop ->ip
***Cmd.forth >> doColon -- 19: (:)
	self rPush: ip;
	wa + cell ->ip
***Cmd.forth >> doBranch -- 20: (branch)
	self lw: ip ->ip
***Cmd.forth >> do0Branch -- 21: (0branch)
	self pop = 0
		ifTrue: [self doBranch]
		ifFalse: [ip + cell ->ip]
***Cmd.forth >> doLiteral -- 22: (literal)
	self push: (self lw: ip);
	ip + cell ->ip
***Cmd.forth >> doConstant -- 23: (constant)
	self push: (self lw: wa + cell)
***Cmd.forth >> doVariable -- 24: (variable)
	self push: wa + cell
***Cmd.forth >> bye -- 25
	-1 ->ip
***Cmd.forth >> emit -- 26
	Console putByte: self pop
***Cmd.forth >> key -- 27
	self push: Console fetch code
***Cmd.forth >> blockRead -- 28
	self pop ->:blockNo;
	self pop ->:addr;
	bfs seek: blockNo - 1 * blockSize;
	bfs read: mem from: addr size: blockSize
***Cmd.forth >> blockWrite -- 29
	self pop ->:blockNo;
	self pop ->:addr;
	bfs seek: blockNo - 1 * blockSize;
	bfs write: mem from: addr size: blockSize
***Cmd.forth >> blockCount -- 30
	bfs seek: nil;
	self push: bfs tell // blockSize

**Cmd.forth >> innerIP
	[ip <> -1] whileTrue:
		[self lw: ip ->wa;
		ip + cell ->ip;
		mem at: (self lw: wa) ->:code;
		self perform: (primitives at: code)]
**Cmd.forth >> finish
	bfs close
**Cmd.forth >> main: args
	self imgFile ->:iFile, none? ifTrue: ["forthut.build" runCmd];
	
	iFile readDo:
		[:fs
		FixedByteArray basicNew: 6 ->mem;
		fs read: mem from: 0 size: 6;
		self lw: 4 ->:ms;
	
		self init: ms;
		fs seek: 0;
		fs read: mem from: 0 size: ms];

	[0 ->ip;
	true ->:exec?;
	[exec?] whileTrue:
		[[self innerIP;
		false ->exec?]
			on: Error
			do:
				[:e e message = "interrupt"
					ifTrue: [2 ->ip]
					ifFalse: [e signal]]]]
		finally: [self finish]
