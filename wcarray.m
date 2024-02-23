WideCharArray class
$Id: mulk wcarray.m 406 2020-04-19 Sun 11:29:54 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Array holding WideChar.
.hierarchy WideCharArray
In addition to the function as an Array, it provides a function that is effective for handling character strings that include WideChar.
**#ja
.caption 説明
WideCharを保持する配列。
.hierarchy WideCharArray
Arrayとしての機能の他に、WideCharを含んだ文字列を扱うのに有効な機能を提供する。

*WideCharArray class.@
	Array addSubclass: #WideCharArray

**#ja
***[test] Test.WideCharArray class.@
	UnitTest addSubclass: #Test.WideCharArray instanceVars: "ar"
****Test.WideCharArray >> setup
	WideCharArray new addString: "aあ" ->ar

**WideCharArray >> addString: stringArg
	StringReader new init: stringArg ->:r;
	[r getWideChar ->:ch, notNil?] whileTrue: [self addLast: ch]
***[man.m]
****#en
Appends a string to the end of the array.
****#ja
配列末尾に文字列を追加する。
***#ja
****[test.m]
	self assert: ar first = 'a';
	self assert: (ar at: 1) = 'あ';
	ar addString: "bい";
	self assert: (ar at: 2) = 'b';
	self assert: (ar at: 3) = 'い'
		
**WideCharArray >> width
	self inject: 0 into: [:w :c w + c width]!
***[man.m]
****#en
Returns the display length of the entire receiver.

Corresponds to the sum of the width of each element (see AbstractChar >> width).
****#ja
レシーバー全体の表示時の長さを返す。

各要素のwidth(AbstractChar >> widthを参照)の総和に相当する。
***#ja
****[test.m]
	self assert: ar width = 3
	
**WideCharArray >> asString
	StringWriter new ->:w;
	self do: [:c w put: c];
	w asString!
***[man.m]
****#en
Convert the entire receiver to a single String.
****#ja
レシーバー全体を単一のStringに変換する。
***#ja
****[test.m]
	self assert: ar asString = "aあ"
