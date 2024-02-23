sort lines
$Id: mulk sort.m 1030 2023-03-04 Sat 20:46:29 kt $
#ja 行単位で整列する

*[man]
**#en
.caption SYNOPSIS
	sort [OPTION]
.caption DESCRIPTION
Outputs the contents of the standard input in line units.
.caption OPTION
	F FIELD -- The input is regarded as CSV, and FIELD is the target of sorting.
	C COLUMN -- The column after the COLUMN character in the input line is the target of sorting.
	n -- Compare with the number interpreted by asNumber.
	i -- Take a decimal positive integer from the first occurrence and compare it.
	r -- Output in reverse order.
.caption SEE ALSO
.summary csvrd
**#ja
.caption 書式
	sort [option]
.caption 説明
標準入力の内容を行単位で整列して出力する。
.caption オプション
	F FIELD -- 入力をCSVとみなし、FIELDを整列の対象とする。
	C COLUMN -- 入力行のCOLUMN文字目以降を整列の対象とする。
	n -- asNumberで解釈された数値で比較する。
	i -- 最初に現れた数から十進正整数を取り出して比較する。
	r -- 逆順に出力する。
.caption 関連項目
.summary csvrd

*sort tool.@
	Mulk import: #("optparse" "csvrd");
	Object addSubclass: #Cmd.sort

**Cmd.sort >> asInteger: s
	AheadReader new init: s ->:rd;
	[rd nextChar ->:ch, notNil? and: [ch digit? not]] whileTrue: [rd skipChar];
	ch nil? ifTrue: [0] ifFalse: [rd skipUnsignedInteger]!
**Cmd.sort >> main: args
	OptionParser new init: "F:C:nir" ->:op, parse: args ->args;
	op at: 'F' ->:oa, notNil? ifTrue:
		[CsvReader new ->:csvrd;
		oa asInteger ->:field];
	op at: 'C' ->oa, notNil? ifTrue: [oa asInteger ->:column];
	op at: 'n' ->:numeric?;
	op at: 'i' ->:integer?;

	Array new ->:ar;
	In contentLinesDo:
		[:s
		s ->:key;
		field notNil? ifTrue: [csvrd parseRecord: key, at: field ->key];
		column notNil? ifTrue: [key copyFrom: column ->key];
		numeric? ifTrue: [key asNumber ->key];
		integer? ifTrue: [self asInteger: key ->key];
		ar addLast: (Cons new car: s cdr: key)];

	ar sortBy: [:p :q p cdr < q cdr];

	op at: 'r', ifTrue: [ar reverse ->ar];
	ar do: [:t Out putLn: t car]
