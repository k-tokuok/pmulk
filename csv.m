csv field processing
$Id: mulk csv.m 730 2021-07-17 Sat 16:39:10 kt $
#ja csvフィールド処理

*[man]
**#en
.caption SYNOPSIS
	csv [OPTION] FIELDNO...
.caption DESCRIPTION
Reads the standard input csv file and outputs only the contents of the specified field.
Field numbers start at 0. 
Rows with less than the specified number of fields are ignored.
.caption OPTION
	a NUMBER -- If there is a field after the specified NUMBER, add it to the end.
	l NUMBER -- For records with fields greater than or equal to the specified NUMBER.
**#ja
.caption 書式
	csv [option] フィールド番号...
.caption 説明
標準入力のcsvファイルを読み取って、指定フィールドの内容のみを出力する。
フィールド番号は0から数える。
指定フィールド数に満たない行は無視される。
.caption オプション
	a 番号 -- 指定番号以降のフィールドがあれば、末尾に追加する。
	l 番号 -- 指定番号以上のフィールドのあるレコードを対象とする。

*csv tool.@
	Mulk import: #("csvrd" "csvwr" "optparse");
	Object addSubclass: #Cmd.csv
**Cmd.csv >> main: args
	OptionParser new init: "a:l:" ->:op, parse: args ->args;
	op at: 'a' ->:oa, notNil? ifTrue: [oa asNumber ->:tailNo];
		
	Array new ->:fieldNo;
	0 ->:leastFieldNo;
	args do:
		[:f
		f asInteger ->f;
		f max: leastFieldNo ->leastFieldNo;
		fieldNo addLast: f];

	op at: 'l' ->oa, notNil? ifTrue:
		[oa asNumber max: leastFieldNo ->leastFieldNo];

	CsvReader new init: In ->:rd;
	CsvWriter new init: Out ->:wr;

	[rd get ->:in, notNil?] whileTrue:
		[in size > leastFieldNo ifTrue:
			[fieldNo collectAsArray: [:n in at: n] ->:out;
			tailNo notNil? ifTrue:
				[tailNo until: in size, do: [:i out addLast: (in at: i)]];
			wr put: out]]
