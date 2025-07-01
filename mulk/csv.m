csv field processing
$Id: mulk csv.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja csvフィールド処理

*[man]
**#en
.caption SYNOPSIS
	csv [OPTION] FIELDNO...
.caption DESCRIPTION
Reads a standard input csv file and outputs only the contents of specified fields in csv format.
Field numbers are counted from 0.
Lines with less than the specified number of fields are ignored.
.caption OPTION
	a NUMBER -- Add to the end of the record any fields after the specified NUMBER.
	l NUMBER -- Target records with fields above the specified NUMBER.
	t -- Output as text.
**#ja
.caption 書式
	csv [option] フィールド番号...
.caption 説明
標準入力のcsvファイルを読み取って、指定フィールドの内容のみをcsv形式で出力する。
フィールド番号は0から数える。
指定フィールド数に満たない行は無視される。
.caption オプション
	a 番号 -- 指定番号以降のフィールドがあれば、末尾に追加する。
	l 番号 -- 指定番号以上のフィールドのあるレコードを対象とする。
	t -- テキストとして出力する。

*csv tool.@
	Mulk import: #("csvrd" "csvwr" "optparse");
	Object addSubclass: #Cmd.csv
**Cmd.csv >> main: args
	OptionParser new init: "a:l:t" ->:op, parse: args ->args;
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
	op at: 't', ifFalse: [CsvWriter new init: Out ->:wr];

	[rd get ->:in, notNil?] whileTrue:
		[in size > leastFieldNo ifTrue:
			[fieldNo collectAsArray: [:n in at: n] ->:out;
			tailNo notNil? ifTrue:
				[tailNo until: in size, do: [:i out addLast: (in at: i)]];
			wr notNil?
				ifTrue: [wr put: out]
				ifFalse: 
					[out do: [:f2 Out put: f2] separatedBy: [Out put: ','];
					Out putLn]]]
