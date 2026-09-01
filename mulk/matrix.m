Matrix class
$Id: mulk matrix.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Represents a matrix/two-dimensional array.
.hierarchy Matrix
Use an instance of Point class for size and subscript.
Subscripts start at 0 and are valid up to size - 1.
.caption SEE ALSO
.summary point
**#ja
.caption 説明
行列・二次元配列を表す。
.hierarchy Matrix
サイズ及び添字にはPointクラスのインスタンスを使用する。
添字は0から始まり、サイズ-1までが有効となる。
.caption 関連項目
.summary point

*Matrix class.@
	Mulk import: "point";
	Object addSubclass: #Matrix instanceVars: "width height contents",
		features: #(Collection)

**[test] Test.Matrix class.@
	UnitTest addSubclass: #Test.Matrix instanceVars: "m"
***Test.Matrix >> setup
	--test for init:
	Matrix new init: 2 @ 3 ->m
***Test.Matrix >> assign
	m width timesDo:
		[:x
		m height timesDo:
			[:y
			m at: x @ y put: x + y]]
	
**Matrix >> init: sizeArg
	sizeArg x ->width;
	sizeArg y ->height;
	FixedArray basicNew: width * height ->contents
***[man.m]
****#en
Initialize the size of the receiver to sizeArg.
****#ja
レシーバーのサイズをsizeArgに初期化する。

**Matrix >> width
	width!
***[man.m]
****#en
Returns the width (number of columns) of the receiver.
****#ja
レシーバーの幅(列数)を返す。
***[test.m]
	self assert: m width = 2
	
**Matrix >> height
	height!
***[man.m]
****#en
Returns the height (number of lines) of the receiver.
****#ja
レシーバーの高さ(行数)を返す。
***[test.m]
	self assert: m height = 3
	
**Matrix >> inside?: pointArg
	pointArg x between: 0 until: width, 
		and: [pointArg y between: 0 until: height]!
***[man.m]
****#en
Returns true if pointArg is a valid subscript within the range of the receiver.
****#ja
pointArgがレシーバーの範囲内にある有効な添字ならtrueを返す。
***[test.m]
	self assert: (m inside?: 0 @ 0);
	self assert: (m inside?: 1 @ 2);
	self assert: (m inside?: 2 @ 3) not
	
**Matrix >> contentsIndex: point
	self assert: (self inside?: point);
	point x + (point y * width)!
***[test.m]
	self assert: (m contentsIndex: 0 @ 0) = 0;
	self assert: (m contentsIndex: 1 @ 0) = 1;
	self assert: (m contentsIndex: 0 @ 2) = 4;
	self assert: (m contentsIndex: 1 @ 2) = 5
	
**Matrix >> at: pointArg
	contents at: (self contentsIndex: pointArg)!
***[man.m]
****#en
Returns the value of the receiver's subscript pointArg.
****#ja
レシーバーの添字pointArgの値を返す。
***[test.m]
	self assign;
	self assert: (m at: 0 @ 0) = 0;
	self assert: (m at: 1 @ 2) = 3

**Matrix >> at: pointArg put: valueArg
	contents at: (self contentsIndex: pointArg) put: valueArg
***[man.m]
****#en
Set the value of the receiver's subscript pointArg to valueArg.
****#ja
レシーバーの添字pointArgの値をvalueArgに設定する。
***[test.m]
	self assert: (m at: 0 @ 0) nil?;
	m at: 0 @ 0 put: 10;
	self assert: (m at: 0 @ 0) = 10
		
**Matrix >> fill: valueArg
	contents fill: valueArg
***[man.m]
****#en
Initialize all elements of the receiver with valueArg.
****#ja
レシーバーの全要素をvalueArgで初期化する。
***[test.m]
	self assert: (m at: 0 @ 0) nil?;
	m fill: 0;
	self assert: (m at: 0 @ 0) = 0

**Matrix >> do: blockArg
	contents do: blockArg
	
**Matrix >> keys
	Iterator new init: 
		[:b contents size timesDo: [:i b value: i % width @ (i // width)]]!
***[man.m]
****#en
Returns a Collection for all subscripts.
****#ja
全ての添字に対するCollectionを返す。

**Matrix >> keysAndValuesDo: blockArg
	contents size timesDo:
		[:i
		i % width @ (i // width) ->:point;
		blockArg value: point value: (contents at: i)]
***[man.m]
****#en
Evaluate blockArg with subscripts and values as arguments for all elements of the receiver.
****#ja
レシーバーの全要素に対し、添字と値を引数としてblockArgを評価する。
***[test.m]
	self assign;
	0 ->:sum;
	m keysAndValuesDo: [:k :v sum + v ->sum];
	self assert: sum = 9
	
**Matrix >> initWidth: widthArg height: heightArg contents: contentsArg
	widthArg ->width;
	heightArg ->height;
	contentsArg ->contents
**Matrix >> copy
	Matrix new initWidth: width height: height contents: contents copy!
***[man.m]
****#en
Return a copy of the receiver.
****#ja
レシーバーの複製を返す。
