count repeated lines
$Id: mulk repeatc.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 反復している行を数える
*[man]
**#en
.caption SYNOPSIS
	repeatc [OPTION]
.caption DESCRIPTION
Input from the standard input line by line, and output the number of line repetitions with the same contents.
.caption OPTION
	w WIDTH -- specifies the number of digits of the iteration. If omitted, 7 is assumed to be specified.
**#ja
.caption 書式
	repeatc [OPTION]
.caption 説明
標準入力から行毎に入力し、同一内容の行の反復数を出力する。
.caption オプション
	w WIDTH -- 反復数の桁数を指定する。省略時は7が指定されたと見做す。

*RepeatCounter class.@
	Object addSubclass: #RepeatCounter
**RepeatCounter >> count: countArg line: lineArg
	self shouldBeImplement
**RepeatCounter >> main: args
	In getLn ->:p, nil? ifTrue: [self!];
	1 ->:count;
	In contentLinesDo:
		[:l
		l = p
			ifTrue: [count + 1 ->count]
			ifFalse: 
				[self count: count line: p;
				l ->p;
				1 ->count]];
	self count: count line: p
	
*repeatc tool.@
	Mulk import: #("optparse" "numlnwr");
	RepeatCounter addSubclass: #Cmd.repeatc instanceVars: "wr"
**Cmd.repeatc >> count: countArg line: lineArg
	wr put: countArg and: lineArg
**Cmd.repeatc >> main: args
	OptionParser new init: "w:" ->:op, parse: args ->args;
	NumberedLineWriter new init: 7 op: op ->wr;
	super main: args
