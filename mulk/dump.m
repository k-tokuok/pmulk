dump list
$Id: mulk dump.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ダンプリスト
*[man]
**#en
.caption SYNOPSIS
	dump [OPTION]
.caption DESCRIPTION
Print a hexadecimal dump list of standard input.
.caption OPTION
	d dumpSize -- Dump for dumpSize bytes. The default is 256 bytes.
	s skipSize -- Skip skipSize bytes from the beginning.
	h -- Print addresses in hexadecimal.
**#ja
.caption 書式
	dump [OPTION]
.caption 説明
標準入力の16進ダンプリストを出力する。
.caption オプション
	d dumpSize -- dumpSizeバイト分のダンプを行う。省略時は256バイトとなる。
	s skipSize -- 先頭からskipSizeバイトスキップする。
	h -- アドレスを16進で出力する。

*dump tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.dump instanceVars: "hex? buf bufSize addr"
**Cmd.dump >> write
	Out put: (hex? ifTrue: [addr asHexString] ifFalse: [addr]) width: 7;
	bufSize timesDo:
		[:i
		Out put: ' ', put: (buf at: i, asHexString0: 2)];
	Out putSpaces: (16 - bufSize) * 3 + 1;
	bufSize timesDo:
		[:j
		Out put: (buf at: j, asChar ->:char, print?
			ifTrue: [char] ifFalse: ['.'])];
	Out putLn
**Cmd.dump >> skip: skipSize
	FixedByteArray basicNew: 4096 ->buf;
	[skipSize > 0] whileTrue:
		[In read: buf size: (skipSize min: 4096) ->bufSize;
		skipSize - bufSize ->skipSize]
**Cmd.dump >> main: args
	OptionParser new init: "hd:s:" ->:op, parse: args ->args;
	op at: 'h' ->hex?;
	op at: 'd' ->:oa, nil? ifTrue: [256] ifFalse: [oa asInteger] ->:dumpSize;
	op at: 's' ->oa, nil? ifTrue: [0] ifFalse: [oa asInteger] ->addr,
		<> 0 ifTrue: [self skip: addr];
		
	FixedByteArray basicNew: 16 ->buf;

	[In read: buf size: (dumpSize min: 16) ->bufSize, <> 0] whileTrue:
		[self write;
		addr + bufSize ->addr;
		dumpSize - bufSize ->dumpSize]
