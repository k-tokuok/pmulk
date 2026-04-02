NumberedLineWriter class
$Id: mulk numlnwr.m 1549 2026-03-10 Tue 06:55:30 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Utility class for outputting right-aligned rows with numerical values.
.hierarchy NumberedLineWriter
.caption SEE ALSO
.summary optparse

**#ja
.caption 説明
右寄せ数値付きの行出力のユーティリティクラス。
.hierarchy NumberedLineWriter
.caption 関連項目
.summary optparse

*NumberedLineWriter class.@
	Object addSubclass: #NumberedLineWriter instanceVars: "width"

**NumberedLineWriter >> init: defaultWidth op: opArg
	opArg at: 'w' ->:arg, notNil? 
		ifTrue: [arg asInteger]
		ifFalse: [defaultWidth] ->width
***[man.m]
****#en
Initialization. 

Initialize with the default numeric range and an OptionParser object.
If the OptionParser has a w option, use the specified numeric value as the range.
****#ja
初期化。

デフォルトの数値幅とOptionParserのオブジェクトで初期化する。
OptionParserにwオプションがあれば、指定された数値を幅とする。

**NumberedLineWriter >> put: numberArg and: lnArg
	Out put: numberArg width: width;
	lnArg notNil? ifTrue: [Out put: ' ', put: lnArg];
	Out putLn
***[man.m]
****#en
Output the values and the contents of the rows.
****#ja
数値と行の内容を出力する。
