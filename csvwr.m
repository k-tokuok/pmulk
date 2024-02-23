CsvWriter class
$Id: mulk csvwr.m 413 2020-04-30 Thu 13:19:07 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Output a string array in csv format.
.hierarchy CsvWriter
.caption SEE ALSO
.summary csvrd
**#ja
.caption 説明
文字列の配列をcsv形式で出力する。
.hierarchy CsvWriter
.caption 関連項目
.summary csvrd

*CsvWriter class.@
	Object addSubclass: #CsvWriter instanceVars: "stream"
**CsvWriter >> init: streamArg
	streamArg ->stream
***[man.m]
****#en
Initialize to output to streamArg.
****#ja
streamArgに出力するよう初期化する。

**CsvWriter >> put: arrayArg
	arrayArg
		do:
			[:s
			s anySatisfy?: [:ch ch = ',' or: [ch = '"'], or: [ch = '\n']],
				ifTrue:
					[stream put: '"';
					StringReader new init: s ->:sr;
					[sr getChar ->ch, notNil?] whileTrue:
						[ch = '"' ifTrue: [stream put: '"'];
						stream put: ch];
					stream put: '"']
				ifFalse:
					[stream put: s]]
		separatedBy: [stream put: ','];
	stream putLn
***[man.m]
****#en
Output arrayArg in csv format.
****#ja
arrayArgをcsv形式で出力する。
