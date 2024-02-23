table formatting and processing
$Id: mulk table.m 1164 2024-02-11 Sun 21:47:40 kt $
#ja 表の整形と加工

*[man]
**#en
.caption SYNOPSIS
	table [OPTION] [FILE]
.caption DESCRIPTION
Input tables in csv format and output them after formatting and processing.

Lines beginning with "#" are ignored as comments.

Lines beginning with "." are processed as command lines to the table, not as data lines.
The available commands are as follows:

.caption .bar
Output horizontal bar.

.caption .format COLUMNFORMAT
Specify the format of the column at formatting.

The format is csv, specifying the width, format, and optional values for each column.

The format and option values are as follows
	s -- Output left-justified as a string.
	r -- Output right-justified as a string.
	i[c] -- Output as an integer. If option "c" is specified, each three digits are separated by ",".
	f SIGNIFICANTDIGITS (6) -- Output as floating-point number. Use exponential format if necessary.
	F FRACTIONALDIGITS (2) -- Outputs a floating-point number with a specified number of fractional part. Output is not performed in exponential format.
	
If width is omitted, the width is automatically determined according to the contents of each column.
If 0 is specified as the width, the column is not output.
If the format is omitted, it is assumed that "s" is specified.
Numerical values are output right-justified.
If the option value is omitted, the value in parentheses is used.

.caption .group
Switch group.

.caption .eval
Evaluate the contents of the Mulk statements up to the ".end" line.

Refer to the class specification below for classes that can be used in scripts.

.caption OPTION
	f COLUMNFORMAT -- Format in COLUMNFORMAT instead of the format specified by the ".format" command.
	
**#ja
.caption 書式
	table [オプション] [表ファイル]

.caption 説明
csv形式の表を入力し、整形・加工した上で出力する。

"#"で始まる行はコメントとして無視される。

"."で始まる行はデータ行ではなく、tableに対する命令行として処理される。
使用可能な命令は以下の通り:

.caption .bar
横線を出力する。

.caption .format カラム書式
整形時のカラムの書式を指定する。

書式はcsv形式でそれぞれのカラムの横幅、形式、オプション値を指定する。

形式とオプション値は以下の通り。
	s -- 文字列として左寄せで出力する。
	r -- 文字列として右寄せで出力する。
	i[c] -- 整数として出力する。オプション"c"を指定すると3桁毎に","で区切る。
	f 有効桁数(6) -- 浮動小数点数値として出力する。必要なら指数形式を用いる。
	F 小数部桁数(2) -- 小数部の桁数を指定して浮動小数点数値を出力する。指数形式での出力は行わない。

横幅を省略すると、各カラムの内容に応じた幅を自動で定める。
横幅として0を指定するとそのカラムは出力されない。
形式を省略した場合はsを指定したものと見做す。
数値は右寄せで出力する。
オプション値を省略した場合は括弧内の値を用いる。

.caption .group
groupを切り換える。

.caption .eval
".end"行までのMulk記述の内容を評価する。

スクリプト内で使用可能なクラスについては、後述のクラス仕様を参照。

.caption オプション
	f カラム書式 -- ".format"命令で指定されたカラム書式ではなく、指定の書式で整形する。

*import.@
	Mulk import: #("csvrd" "optparse")
	
*Table.Array class.@
	Array addSubclass: #Table.Array instanceVars: "filler"
**Table.Array >> filler: arg
	arg ->filler
**Table.Array >> extends: posArg
	[posArg >= size] whileTrue: [self addLast: filler]
**Table.Array >> at: posArg
	self extends: posArg;
	super at: posArg!
**Table.Array >> at: posArg put: valueArg
	self extends: posArg;
	super at: posArg put: valueArg
**Table.Array >> addAll: arrayArg beforeIndex: posArg
	arrayArg size ->:sz;
	self size: size + sz;
	elements basicAt: posArg + sz copyFrom: elements at: posArg 
		size: size - sz - posArg;
	arrayArg do:
		[:el
		elements at: posArg put: el;
		posArg + 1 ->posArg]
		
*Table.Row class.@
	Object addSubclass: #Table.Row
**[man.c]
***#en
An object representing a row in a table.
***#ja
表中の行を表すオブジェクト。

**Table.Row >> type
	self shouleBeImplemented
**Table.Row >> size
	0!

*Table.BarRow class.@
	Table.Row addSubclass: #Table.BarRow
**Table.BarRow >> type
	#bar!

*Table.DataRow class.@
	Table.Row addSubclass: #Table.DataRow instanceVars: "array group"
**[man.c]
***#en
An object representing a row with data in a table.
***#ja
表中のデータを持つ行を表すオブジェクト。

**Table.DataRow >> type
	#data!
**Table.DataRow >> init: groupArg
	Table.Array new filler: "" ->array;
	groupArg ->group
**Table.DataRow >> group
	group!
**Table.DataRow >> size
	array size!
**Table.DataRow >> parse: strArg
	CsvReader new parseRecord: strArg, do:
		[:s
		array addLast: s trim]
**Table.DataRow >> at: posArg
	array at: posArg, asString!
***[man.m]
****#en
Return the contents of column posArg as a string.
****#ja
カラムposArgの内容を文字列として返す。

**Table.DataRow >> at: posArg put: valueArg
	array at: posArg put: valueArg
***[man.m]
****#en
Change the contents of column posArg to valueArg.

Specify a String or Number instance as the valueArg.
****#ja
カラムposArgの内容をvalueArgに変更する。

valueArgとしてはStringかNumberのインスタンスを指定する。

**Table.DataRow >> numberAt: posArg ifError: blockArg
	array at: posArg ->:result;
	result kindOf?: Number, ifTrue: [result!];
	AheadReader new init: result ->:r;
	[
		r skipNumber ->result;
		r nextChar nil? ifFalse: [self error: "not finished"]
	] 
		on: Error do: [:e blockArg value!];
	result!
***[man.m]
****#en
The contents of column posArg are returned as numeric values.

If the column content cannot be interpreted as a number, the content of blockArg is evaluated and the result is returned.
****#ja
カラムposArgの内容を数値として返す。

カラムの内容が数値として解釈出来ない場合はblockArgの内容を評価し、その結果を返す。

**Table.DataRow >> numberAt: posArg
	self numberAt: posArg ifError: [0]!
***[man.m]
****#en
The contents of column posArg are returned as numeric values.

If the column content cannot be interpreted as a number, 0 is returned.
****#ja
カラムposArgの内容を数値として返す。

カラムの内容が数値として解釈出来ない場合は0を返す。

*Table.FloatWriter class.@
	FloatWriter addSubclass: #Table.FloatWriter
**Table.FloatWriter >> put: valueArg mantWidth: mantWidthArg to: writerArg
	self mantWidth: mantWidthArg;
	self value: valueArg;
	writerArg ->writer;
	exp between: -3 and: mantWidthArg - 1, 
		ifTrue: [self putFstyle]
		ifFalse: [self putEstyle]
**Table.FloatWriter >> put: valueArg fracWidth: fracWidthArg to: writerArg
	self mantWidth: 10;
	self value: valueArg;
	writerArg ->writer;
	self mantWidth: (fracWidthArg + 1 + exp max: 1, min: 15);
	self value: valueArg;
	self putSign;
	exp >= 0
		ifTrue:
			[exp + 1 timesRepeat: [self putMant1];
			writer put: '.']
		ifFalse:
			[writer put: "0.";
			exp negated - 1 min: fracWidthArg ->:z;
			writer put: '0' times: z;
			fracWidthArg - z ->fracWidthArg];
	fracWidthArg timesRepeat: [self putMant1]
	
*columnFormats.
**Table.ColumnFormat.s class.@
	Object addSubclass: #Table.ColumnFormat.s instanceVars:
		"table columnNo width"
***Table.ColumnFormat.s >> strLength: strArg
	StringReader new init: strArg ->:r;
	0 ->:result;
	[r getWideChar ->:ch, notNil?] whileTrue: [result + ch width ->result];
	result!
***Table.ColumnFormat.s >> colStr0: rowArg
	rowArg at: columnNo!
***Table.ColumnFormat.s >> solveWidth
	table rows select: [:r r type = #data],
		inject: 0 into: [:w :r2 w max: (self strLength: (self colStr0: r2))]
		->width
***Table.ColumnFormat.s >> parseOption: readerArg
	self!
***Table.ColumnFormat.s >> init: tableArg columnNo: cnArg width: widthArg
		optReader: optReaderArg
	tableArg ->table;
	cnArg ->columnNo;
	widthArg ->width;
	optReaderArg notNil? and: [optReaderArg nextChar notNil?], 
		ifTrue: [self parseOption: optReaderArg];
	width nil? ifTrue: [self solveWidth]
***Table.ColumnFormat.s >> width
	width!
***Table.ColumnFormat.s >> truncate: strArg
	StringReader new init: strArg ->:r;
	StringWriter new ->:w;
	0 ->:len;
	[r getWideChar ->:ch, notNil?] whileTrue:
		[ch width ->:cw;
		cw + len > (width - 1) ifTrue: [w put: '*', asString!];
		w put: ch;
		len + cw ->len];
	self assertFailed
***Table.ColumnFormat.s >> chars: chArg times: timesArg
	StringWriter new ->:w;
	timesArg timesRepeat: [w put: chArg];
	w asString!
***Table.ColumnFormat.s >> colStr: rowArg
	self colStr0: rowArg ->:result;
	self strLength: result ->:len;
	len > width ifTrue:
		[self truncate: result ->result;
		self strLength: result ->len];
	len < width ifTrue:
		[result + (self chars: ' ' times: width - len) ->result];
	result!

**Table.ColumnFormat.r class.@
	Table.ColumnFormat.s addSubclass: #Table.ColumnFormat.r
***Table.ColumnFormat.r >> colStr: rowArg
	self colStr0: rowArg ->:result;
	self strLength: result ->:len;
	len > width ifTrue: [self chars: '#' times: width!];
	len < width ifTrue: 
		[(self chars: ' ' times: width - len) + result ->result];
	result!
	
**Table.ColumnFormat.i class.@
	Table.ColumnFormat.r addSubclass: #Table.ColumnFormat.i 
		instanceVars: "colon?"
***Table.ColumnFormat.i >> init
	false ->colon?
***Table.ColumnFormat.i >> parseOption: r
	r nextChar = 'c' ->colon?
***Table.ColumnFormat.i >> colStr0: rowArg
	rowArg numberAt: columnNo ifError: [super colStr0: rowArg!] ->:n;
	n kindOf?: Float, ifTrue: [n + 0.5, asInteger ->n];
	n asString ->:result;
	colon? ifTrue:
		[result size ->:len;
		StringWriter new ->:w;
		len timesDo:
			[:i
			w put: (result at: i);
			len - 1 - i ->:p;
			p <> 0 and: [p % 3 = 0], ifTrue: [w put: ',']];
		w asString ->result];
	result!
	
**Table.ColumnFormat.f class.@
	Table.ColumnFormat.i addSubclass: #Table.ColumnFormat.f instanceVars: 
		"mantWidth"
***Table.ColumnFormat.f >> init
	6 ->mantWidth
***Table.ColumnFormat.f >> parseOption: r
	r nextChar digit? ifTrue: [r skipNumber ->mantWidth]
***Table.ColumnFormat.f >> colStr0: rowArg
	rowArg numberAt: columnNo ifError: [super colStr0: rowArg!] ->:n;
	StringWriter new ->:w;
	Table.FloatWriter new put: n mantWidth: mantWidth to: w;
	w asString!
	
**Table.ColumnFormat.F class.@
	Table.ColumnFormat.i addSubclass: #Table.ColumnFormat.F instanceVars:
		"fracWidth"
***Table.ColumnFormat.F >> init
	2 ->fracWidth
***Table.ColumnFormat.F >> parseOption: r
	r nextChar digit? ifTrue: [r skipNumber ->fracWidth]
***Table.ColumnFormat.F >> colStr0: rowArg
	rowArg numberAt: columnNo ifError: [super colStr0: rowArg!] ->:n;
	StringWriter new ->:w;
	Table.FloatWriter new put: n fracWidth: fracWidth to: w;
	w asString!
	
*Table.Printer class.@
	Object addSubclass: #Table.Printer instanceVars: 
		"table widths totalWidth columnFormats"
**Table.Printer >> createColumnFormatAt: cnArg str: strArg
	nil ->:width;
	's' ->:type;
	strArg empty? ifFalse:
		[AheadReader new init: strArg ->:r;
		r nextChar digit? ifTrue: [r skipNumber ->width];
		r nextChar notNil? ifTrue: [r skipChar ->type]];
	width <> 0 ifTrue:
		[Mulk at: ("Table.ColumnFormat." + type) asSymbol, new
			init: table columnNo: cnArg width: width optReader: r ->:result];
	result!
**Table.Printer >> init: tableArg format: fmtArg
	tableArg ->table;
	Table.Array new filler: "", addAll: (CsvReader new parseRecord: fmtArg)
		->:array;
	table columnCount ->:cc;
	Array new ->columnFormats;
	0 ->totalWidth;
	cc timesDo:
		[:i
		self createColumnFormatAt: i str: (array at: i) ->:cf;
		cf notNil? ifTrue:
			[totalWidth + cf width ->totalWidth;
			columnFormats addLast: cf]];
	totalWidth + columnFormats size - 1 ->totalWidth
**Table.Printer >> printRow: rowArg
	rowArg type = #bar ifTrue: [Out put: '-' times: totalWidth!];

	columnFormats size timesDo:
		[:i
		i <> 0 ifTrue: [Out put: ' '];
		Out put: (columnFormats at: i, colStr: rowArg)]
**Table.Printer >> print
	table rows do:
		[:row
		self printRow: row;
		Out putLn]

*Table.Sorter class.@
	Object addSubclass: #Table.Sorter instanceVars: "colIx colStr rows"
**Table.Sorter >> init: specArg
	Array new ->colIx;
	Array new ->colStr;
	AheadReader new init: specArg ->:rd;
	[colIx addLast: rd skipInteger;
	rd nextChar = 's' ->:string?, ifTrue: [rd skipChar];
	colStr addLast: string?;
	rd nextChar = ','] whileTrue: [rd skipChar]
**Table.Sorter >> compare: r1 and: r2
	colIx size timesDo:
		[:i
		colIx at: i ->:ix;
		colStr at: i, 
			ifTrue: 
				[r1 at: ix ->:c1;
				r2 at: ix ->:c2]
			ifFalse:
				[r1 numberAt: ix ifError: [1.0e100] ->c1;
				r2 numberAt: ix ifError: [1.0e100] ->c2];
		c1 <> c2 ifTrue: [c1 < c2!]];
	false!
**Table.Sorter >> sort: rowsArg
	rowsArg ->rows;
	rows sortBy: [:r1 :r2 self compare: r1 and: r2];
	rows!
		
*Table.Eval class.@
	Object addSubclass: #Table.Eval instanceVars: "table"
**[man.c]
***#en
An object that executes Mulk statements evaluated with the ".eval" command.

The instance variable table can be used to access the Table object that is being displayed.
***#ja
".eval"命令で評価されるMulk文を実行するオブジェクト。

インスタンス変数tableで表示しようとしているTableオブジェクトにアクセスできる。

**Table.Eval >> init: tableArg
	tableArg ->table
	
**Table.Eval >> sumOf: arrayArg column: columnArg
	arrayArg inject: 0 into: [:sum :r sum + (r numberAt: columnArg)]!
***[man.m]
****#en
Calculate the sum of column columnArg of arrayarrayArg of Table.Row.
****#ja
Table.Rowの配列arrayArgのカラムcolumnArgの総和を計算する。

**Table.Eval >> sort: arrayArg with: specArg
	Table.Sorter new init: specArg, sort: arrayArg!
***[man.m]
****#en
Array of Table.Row is sorted in ascending order based on specArg.

specArg is a sequence of column numbers separated by ',', which is compared as a string if s is appended, or as a number otherwise.
****#ja
Table.Rowの配列をspecArgに基いて昇順に整列する。

specArgは','で区切られたカラム番号の列で、sを付加すると文字列として、さもなくば数値として比較する。

*Table class.@
	Object addSubclass: #Table instanceVars: "rows format"
		+ " line lastGroup"
**[man.c]
***#en
Table object
***#ja
表オブジェクト

**Table >> init
	Table.Array new ->rows;
	"" ->format
**Table >> columnCount
	rows inject: 0 into: [:cc :r cc max: r size]!
	
**reader.
***Table >> fetchLine
	In getLn ->line, nil? ifTrue: [#eof!];
	line empty? ifTrue: [#data!];
	line first ->:ch, = '.' ifTrue: [#command!];
	ch = '#' ifTrue: [#comment!];
	#data!
	
***commands.
****Table >> command.bar: arg
	rows addLast: Table.BarRow new;
	lastGroup + 1 ->lastGroup
****Table >> command.format: arg
	arg getRest ->format
****Table >> command.eval: arg
	MemoryStream new ->:ms;
	[In getLn ->line, <> ".end"] whileTrue: [ms putLn: line];
	ms seek: 0;
	Table.Eval new init: self, evalReader: ms
****Table >> command.group: arg
	lastGroup + 1 ->lastGroup
	
****Table >> parseCommand
	AheadReader new init: line ->:r;
	r skipChar;
	"command." + r getToken + ':', asSymbol ->:cmd;
	r skipSpace;
	self perform: cmd with: r
	
***Table >> parseLine: typeArg
	typeArg = #command ifTrue: [self parseCommand!];
	typeArg = #comment ifTrue: [self!];
	typeArg = #data ifTrue: 
		[rows addLast: (Table.DataRow new init: lastGroup, parse: line)!];
	self assertFailed
***Table >> read
	0 ->lastGroup;
	[self fetchLine ->:type, = #eof] whileFalse: [self parseLine: type]

**Table >> print: formatArg
	Table.Printer new init: self format: formatArg, print
**Table >> print
	self print: format
	
**utility.
***Table >> rows
	rows!
****[man.m]
*****#en
Returns an array of the rows (Table.Row) that make up the table.
*****#ja
表を構成する行(Table.Row)の配列を返す。

***Table >> groupRows: groupNoArg
	rows selectAsArray: [:r r type = #data and: [r group = groupNoArg]]!
****[man.m]
*****#en
Returns an array of Table.DataRow for the specified group number.

The group number starts at 0 and increases with each ".bar" or ".group" command.
*****#ja
指定のグループ番号のTable.DataRowの配列を返す。

グループ番号は0から始まり、.barや.group命令の度に増加していく。

***groupRows:replace:
****Table >> firstGroupRowIndex: groupNoArg
	rows findFirst: [:r r type = #data and: [r group = groupNoArg]]!
****Table >> lastGroupRowIndex: groupNoArg
	rows findLast: [:r r type = #data and: [r group = groupNoArg]]!
****Table >> groupRows: groupNoArg replace: arrayArg
	self firstGroupRowIndex: groupNoArg ->:first;
	self lastGroupRowIndex: groupNoArg ->:last;
	rows removeFrom: first until: last + 1;
	rows addAll: arrayArg beforeIndex: first
*****[man.m]
******#en
Replace the specified group number rows with the contents of arrayArg.
******#ja
指定のグループ番号の列をarrayArgの内容に置換する。

*table tool.@
	Object addSubclass: #Cmd.table
**Cmd.table >> main: args
	OptionParser new init: "f:" ->:op, parse: args ->args;
	Table new ->:table;
	args empty? 
		ifTrue: [table read]
		ifFalse: [args first asFile pipe: [table read] to: Out];
	op at: 'f' ->:fmt, nil?
		ifTrue: [table print]
		ifFalse: [table print: fmt]
