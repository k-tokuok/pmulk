CsvReader class
$Id: mulk csvrd.m 406 2020-04-19 Sun 11:29:54 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Parse csv format data.
.hierarchy CsvReader
The csv (comma-separated values) format is a data format in which one line is one record and each field character string is delimited by ','.
If the field string contains ',' or '"', describe the field enclosed in '"'.
At this time, '"' in the field is expressed as '""'.
**#ja
.caption 説明
csv形式のデータを解析する。
.hierarchy CsvReader
csv(comma-separated values)形式は1行を1レコードとし、各フィールド文字列を','を区切って表すデータ形式である。
フィールド文字列が','、'"'を含む場合、フィールドを'"'で囲んで記述する。
この時、フィールド中の'"'は'""'で表現する。

*CsvReader class.@
	Object addSubclass: #CsvReader instanceVars: "reader"

**CsvReader >> init: streamArg
	AheadReader new initReader: streamArg ->reader
***[man.m]
****#en
Initialize to read from the stream.
****#ja
ストリームから読み込みを行うよう初期化する。

**CsvReader >> getQuotedField
	reader skipChar;
	[reader nextChar ->:ch;
	ch = '"'
		ifTrue:
			[reader skipChar;
			reader nextChar = '"'
				ifTrue: [reader getChar]
				ifFalse: [reader token!]]
		ifFalse: [reader getChar]] loop
**CsvReader >> getField
	reader resetToken;
	reader nextChar = '"' ifTrue: [self getQuotedField!];
	[reader nextChar ->:ch, = ',', or: [ch = '\n']]
		whileFalse: [reader getChar];
	reader token!

**CsvReader >> get
	reader nextChar nil? ifTrue: [nil!];
	Array new ->:result;
	result addLast: self getField;
	[reader nextChar = ','] whileTrue:
		[reader skipChar;
		result addLast: self getField];
	reader skipChar;
	result!
***[man.m]
****#en
Reads one record from the stream and returns an array of fields.

Returns nil when reading to the end of the stream.
****#ja
ストリームから1レコードを読み込み、フィールドの配列を返す。

ストリームの終端まで読み込むとnilを返す。

**CsvReader >> getAll
	Array new ->:result;
	[self get ->:line, notNil?] whileTrue: [result addLast: line];
	result!
***[man.m]
****#en
Read the stream to the end and return an array of all records.
****#ja
ストリームを終端まで読み込み、全レコードの配列を返す。

**CsvReader >> parseRecord: lineArg
	self init: (StringReader new init: lineArg + '\n');
	self get!
***[man.m]
****#en
Parses lineArg as a csv line and returns an array of fields.
****#ja
lineArgをcsvの行として解析し、フィールドの配列を返す。
