arithmetic functions
$Id: mulk math.m 960 2022-10-27 Thu 22:12:46 kt $
#ja 算術関数

*[man]
**#en
.caption DESCRIPTION
Provide various arithmetic functions as methods of Number class.
**#ja
.caption 説明
Numberクラスのメソッドとして各種算術関数を提供する。

*[test] Test.Number.math class.@
	UnitTest addSubclass: #Test.Number.math ->testClass
**Test.Number.math >> assertEqual: x to: y
	self assert: (x - y) abs < 1.0e-14
	
*Number >> sqr
	self * self!
**[man.m]
***#en
self ^ 2 -- Squared
***#ja
self ^ 2 -- 二乗
**[test.m]
	self assert: 2 sqr = 4
	
*sqrt.
**Float >> sqrt
	self = 0.0 ifTrue: [0.0!];
	self assert: self > 0.0;
	1.0 max: self ->:s;
	[s ->:result;
	self / s + s / 2.0 ->s;
	s >= result ifTrue: [result!]] loop
**Number >> sqrt
	self asFloat sqrt!
***[man.m]
****#en
sqrt(self) -- Square root
****#ja
sqrt(self) -- 平方根
***[test.m]
	self assertEqual: 4 sqrt to: 2

*exponential and logarithm.
**[man.s]

**Float >> expPart
	self = 0.0
		ifTrue: [0]
		ifFalse:
			[(self basicAt: 7, << 4) | (self basicAt: 6, >> 4) & 0x7ff - 1022]!
***[test.m]
	self assert: 0.0 expPart = 0;
	self assert: 1.0 expPart = 1;
	self assert: -1.0 expPart = 1;
	self assert: 0.25 expPart = -1;
	self assert: -0.25 expPart = -1
	
**Float >> expPart: exp
	--warning: destroy receiver.
	exp + 1022 ->exp;
	self basicAt: 7 put: (self basicAt: 7, & 0x80 | (exp & 0x7f0 >> 4));
	self basicAt: 6 put: (self basicAt: 6, & 0xf | (exp & 0xf << 4))
***[test.m]
	self assertEqual: (1.0 expPart: 0) to: 0.5;
	self assertEqual: (1.0 expPart: 1) to: 1.0;
	self assertEqual: (1.0 expPart: -1) to: 0.25
	
**Float >> multiply2pow: x
	self = 0.0 ifTrue: [0.0!];
	self expPart + x ->x;
	x < -1021 ifTrue: [0.0!];
	x > 1024 ifTrue: [self error: "overflow"];
	self + 0.0, expPart: x!
***[test.m]
	self assertEqual: (0.0 multiply2pow: 1000) to: 0.0;
	self assertEqual: (2.0 multiply2pow: 2) to: 8.0;
	self assertError: [2.0 multiply2pow: 1023] message: "overflow";
	self assertEqual: (2.0 multiply2pow: -2) to: 0.5;
	self assertEqual: (2.0 multiply2pow: -1024) to: 0.0
	
**exp.
***Float >> exp
	0.6931471805599453 ->:log2;
	22 ->:n;
	self / log2 + (self >= 0.0 ifTrue: [0.5] ifFalse: [-0.5]), asInteger ->:k;
	self - (k * log2) ->:x;
	x sqr ->:x2;
	x2 / n ->:w;
	
	n - 4 ->:i;
	[i >= 6] whileTrue:
		[x2 / (w + i) ->w;
		i - 4 ->i];
	(2.0 + w + x) / (2.0 + w - x) multiply2pow: k!
***Number >> exp
	self asFloat exp!
****[man.m]
*****#en
exp(self) -- e base exponential
*****#ja
exp(self) -- eを底とする指数関数
****[test.m]
	self assertEqual: 1 exp to: 2.718281828459044

**log.
***Float >> log
	0.6931471805599453 ->:log2;
	1.4142135623730950 ->:sqrt2;
	self assert: self > 0.0;
	self / sqrt2, expPart ->:k;
	self / (1.0 multiply2pow: k) ->:x;
	(x - 1.0) / (x + 1.0) ->x;
	x sqr ->:x2;
	1.0 ->:i;
	x ->:s;
	[x * x2 ->x;
	i + 2.0 ->i;
	s ->:prev;
	s + (x / i) ->s;
	s = prev] whileFalse;
	log2 * k + (s * 2.0)!
***Number >> log
	self asFloat log!
****[man.m]
*****#en
log(self) -- Natural logarithm
*****#ja
log(self) -- 自然対数
****[test.m]
	self assertEqual: 2 exp log to: 2.0;
	self assertEqual: 3 exp log to: 3.0;
	self assertEqual: 4 exp log to: 4.0;
	self assertEqual: 100 exp log to: 100.0
	
**Number >> pow: y
	(y * self log) exp!
***[man.m]
****#en
self ^ y -- Exponentiation
****#ja
self ^ y -- べき乗
***[test.m]
	self assertEqual: (2 pow: 4) to: 16.0;
	self assertEqual: (2 pow: -4) to: 0.0625
	
*trigonometric functions.
**[man.s]
***#en
The angle of the trigonometric function is specified by radian.
***#ja
三角関数の角度はradianで指定する。

**Float >> urTan
	self / 0.5 pi + (self >= 0.0 ifTrue: [0.5] ifFalse: [-0.5]), asInteger
		->:quadrant;
	self - (3217.0 / 2048.0 * quadrant) + (4.45445510338076867831e-6 * quadrant)
		->:x;
	x * x ->:x2;
	0.0 ->:t;
	15.0 ->:i;
	[i >= 3.0] whileTrue:
		[x2 / (i - t) ->t;
		i - 2.0 ->i];
	Cons new car: x / (1.0 - t) cdr: quadrant abs!

**Number >> pi
	self * 3.14159265358979323846!
***[man.m]
self * pi

**Number >> radian
	self / 360.0 * 2.0 pi!
***[man.m]
****#en
Convert angle number to radian.
****#ja
角度数をradianに変換する。

**Number >> degree
	self / 2.0 pi * 360.0!
***[man.m]
****#en
Convert radian to number of angles.
****#ja 
radianを角度数に変換する。

**Number >> sin
	(self / 2.0) urTan ->:tuple;
	tuple car ->:t;
	2.0 * t / (1.0 + t sqr) ->t;
	tuple cdr % 2 = 0 ifTrue: [t] ifFalse: [t negated]!
***[man.m]
sin(self)
***[test.m]
	self assertEqual: 0 sin to: 0;
	self assertEqual: 0.5 pi sin to: 1;
	self assertEqual: 0.25 pi sin to: 2 sqrt / 2
	
**Number >> cos
	0.5 pi - self abs, sin!
***[man.m]
cos(self)
***[test.m]
	self assertEqual: 0 cos to: 1;
	self assertEqual: 0.5 pi cos to: 0;
	self assertEqual: 0.25 pi cos to: 2 sqrt / 2

**tan.
***Float >> tan
	self urTan ->:t;
	t cdr % 2 = 0 ifTrue: [t car] ifFalse: [-1.0 / t car]!
***Number >> tan
	self asFloat tan!
****[man.m]
tan(self)
****[test.m]
	self assertEqual: 0 tan to: 0;
	self assertEqual: 0.25 pi tan to: 1
	
**asin.
***Float >> asin
	self = 1.0 ifTrue: [0.5 pi!];
	self = -1.0 ifTrue: [-0.5 pi!];
	self / (1.0 - self sqr) sqrt, atan!
***Number >> asin
	self asFloat asin!
****[man.m]
asin(self)
****[test.m]
	self assertEqual: 0 asin to: 0;
	self assertEqual: 1 asin degree to: 90;
	self assertEqual: -1 asin degree to: -90;
	self assertEqual: 0.5 asin degree to: 30

**Number >> acos
	0.5 pi - self asin!
***[man.m]
acos(self)
***[test.m]
	self assertEqual: 0 acos degree to: 90;
	self assertEqual: 1 acos degree to: 0;
	self assertEqual: -1 acos degree to: 180;
	self assertEqual: 0.5 acos degree to: 60
	
**atan.
***Float >> atan
	self abs > 1.0
		ifTrue:
			[self > 0.0 ifTrue: [0.5] ifFalse: [-0.5] ->:sign;
			1.0 / self ->:x]
		ifFalse:
			[nil ->sign;
			self ->x];
	0.0 ->:a;
	20.0 ->:i;
	[i >= 1.0] whileTrue:
		[i sqr * x sqr / (2.0 * i + 1.0 + a) ->a;
		i - 1.0 ->i];
	x / (1.0 + a) ->x;
	sign nil?
		ifTrue: [x]
		ifFalse: [sign pi - x]!
***Number >> atan
	self asFloat atan!
****[man.m]
atan(self)
****[test.m]
	self assertEqual: 0 atan to: 0;
	self assertEqual: 1 atan degree to: 45

**angle
***Float >> angle: y
	y asFloat ->y;
	self = 0.0 ifTrue:
		[self assert: y <> 0.0;
		y > 0.0 ifTrue: [0.5] ifFalse: [-0.5], pi!];
	self > 0.0 ifTrue: [y / self, atan!];
	y / self, atan + (y >= 0.0 ifTrue: [1.0] ifFalse: [-1.0], pi)!
***Number >> angle: y
	self asFloat angle: y!
****[man.m]
*****#en
atan2(y, self) -- The angle formed by the vector (self, y)
*****#ja
atan2(y, self) -- ベクタ(self,y)の成す角。
****[test.m]
	self assertEqual: (1 angle: 0) to: 0;
	self assertEqual: (0 angle: 1) degree to: 90;
	self assertEqual: (-1 angle: 0) degree to: 180;
	self assertEqual: (0 angle: -1) degree to: -90;
	self assertEqual: (1 angle: 1) degree to: 45
	
*Number >> floor
	self asInteger ->:i;
	i > self ifTrue: [i - 1] ifFalse: [i]!
**[man.m]
***#en
floor(self) -- Largest integer not greater than or equal to self
***#ja
floor(self) -- selfと等しいか上回らない最大の整数
**[test.m]
	self assert: -1 floor = -1;
	self assert: -0.5 floor = -1;
	self assert: 0 floor = 0;
	self assert: 0.5 floor = 0;
	self assert: 1 floor = 1
	
*statistics.
**Number >> fact
	self = 0 ifTrue: [1] ifFalse: [self * (self - 1) fact], asFloat!
***[man.m]
self!
***[test.m]
	self assert: 1 fact = 1;
	self assert: 2 fact = 2;
	self assert: 3 fact = 6
	
**Number >> c: m
	self < m
		ifTrue: [0]
		ifFalse: [self fact / (m fact * (self - m) fact)]!
***[man.m]
****#en
self C m -- Total number of combinations
****#ja
self C m -- 組合せの総数
***[test.m]
	self assert: (3 c: 2) = 3;
	self assert: (4 c: 3) = 4;
	self assert: (4 c: 2) = 6
