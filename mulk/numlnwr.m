NumberedLineWriter class
$Id: mulk numlnwr.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Utility class for numerical line output.
.hierarchy NumberedLineWriter
**#ja
.caption 説明
数値付きの行出力のユーティリティクラス。
.hierarchy NumberedLineWriter

*NumberedLineWriter class.@
	Object addSubclass: #NumberedLineWriter instanceVars: "width"
**NumberedLineWriter >> init: defaultWidth op: opArg
	opArg at: 'w' ->:arg, notNil? 
		ifTrue: [arg asInteger]
		ifFalse: [defaultWidth] ->width
**NumberedLineWriter >> put: numberArg and: lnArg
	Out put: numberArg width: width;
	lnArg notNil? ifTrue: [Out put: ' ', put: lnArg];
	Out putLn
	
