Point class
$Id: mulk point.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Represents a point on a plane regular coordinate system.
.hierarchy Point
The value of the Point instance does not change after construction.
**#ja
.caption 説明
平面直交座標系上の点を表す。
.hierarchy Point
Pointのインスタンスは構築後に値が変化することはない。
*Point class.@
	Object addSubclass: #Point instanceVars: "x y"

*Number >> @ number
	Point new initX: self Y: number!
**[man.m]
***#en
Constructs and returns a Point at coordinates (x, y).

You cannot construct an instance of Point with Point >> new.
***#ja
座標(x, y)のPointを構築し返す。

PointのインスタンスをPoint >> newでは構築することは出来ない。
**[test] Test.Point class.@
	UnitTest addSubclass: #Test.Point instanceVars: "pt"
***Test.Point >> setup
	--test for initX:Y:
	Point new initX: 3 Y: 4 ->pt
	
**Point >> initX: argX Y: argY
	argX ->x;
	argY ->y;
	self hash: (x hash * 137 ^ y hash) & 0xfffff
***[test.m]
	self assert: pt x = 3 & (pt y = 4)
	
**Point >> x
	x!
***[man.m]
****#en
The X coordinate value of the receiver.
****#ja
レシーバーのX座標の値。

***[test.m]
	self assert: pt x = 3
	
**Point >> y
	y!
***[man.m]
****#en
The Y coordinate value of the receiver.
****#ja
レシーバーのY座標の値。
***[test.m]
	self assert: pt y = 4
	
**Point >> printOn: writer
	writer put: x, put: '@', put: y
***[test.m]
	self assert: pt asString = "3@4"
	
**Point >> = point
	point memberOf?: Point, ifFalse: [false!];
	x = point x and: [y = point y]!
***[test.m]
	self assert: pt = (3 @ 4);
	self assert: (pt = (2 @ 4)) not;
	self assert: (pt = (3 @ 5)) not;
	self assert: (pt = (2 @ 5)) not
	
**Point >> + pointArg
	x + pointArg x @ (y + pointArg y)!
***[man.m]
****#en
Returns the Point of the coordinates obtained by adding the coordinates of pointArg to the coordinates of the receiver.
****#ja
レシーバーの座標にpointArgの座標を加算した座標のPointを返す。

***[test.m]
	self assert: pt + pt = (6 @ 8)

**Point >> negated
	x negated @ y negated!
***[man.m]
****#en
Returns the Point with the coordinates of the X and Y coordinates of the receiver inverted.
****#ja
レシーバーのX, Y座標を符号反転させた座標のPointを返す。
***[test.m]
	self assert: pt negated = (-3 @ -4)
	
**Point >> - pointArg
	self + pointArg negated!
***[man.m]
****#en
Returns the Point resulting from subtracting the coordinates in pointArg from the coordinates of the receiver.
****#ja
レシーバーの座標からpointArgの座標を減算した結果のPointを返す。
