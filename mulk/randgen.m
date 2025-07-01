random number generator (RandomGenerator class)
$Id: mulk randgen.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 乱数生成器 (RandomGenerator class)

*[man]
**#en
.caption DESCRIPTION
Base class for random number generators.
.hierarchy RandomGenerator
The random number generator is implemented as a subclass of this class.
.caption SEE ALSO
.summary random
**#ja
.caption 説明
乱数生成器の基底クラス。
.hierarchy RandomGenerator
乱数生成器はこのクラスのサブクラスとして実装される。
.caption 関連項目
.summary random

*RandomGenerator class.@
	Object addSubclass: #RandomGenerator
**RandomGenerator >> randomize
	self randomize: OS time
***[man.m]
****#en
Initialize the current time with the seed.
****#ja
現在時刻を種に初期化する。

**RandomGenerator >> randomize: seedArg
	self shouldBeImplemented
***[man.m]
****#en
Initialize seed with an integer value seedArg.

The generators initialized with the seed of the same value generate the same random number sequence.
****#ja
整数値seedを種に初期化する。

同値の種で初期化された生成器は同じ乱数列を生成する。

**RandomGenerator >> int32
	self shouldBeImplemented
***[man.m]
****#en
Generates a 32-bit unsigned integer random number.
****#ja
32bit符号無し整数の乱数を生成する。

**RandomGenerator >> float
	self int32 / 0x100000000!
***[man.m]
****#en
Generates a floating point random number [0,1).
****#ja
[0,1)の浮動小数点乱数を生成する。

**RandomGenerator >> until: n
	self float * n, asInteger!
***[man.m]
****#en
Generates an integer random number of [0,n).
****#ja
[0,n)の整数乱数を生成する。

**RandomGenerator >> boolean
	self until: 2, = 0!
***[man.m]
****#en
Returns true or false at random.
****#ja
trueかfalseをランダムに返す。

**RandomGenerator >> shuffle: arrayArg
	arrayArg size ->:sz;
	sz timesDo:
		[:i
		arrayArg swap: i and: i + (self until: sz - i)];
	arrayArg!
***[man.m]
****#en
Shuffle the array arrayArg.
****#ja
配列arrayArgをシャッフルする。

**RandomGenerator >> select: arrayArg
	arrayArg at: (self until: arrayArg size)!
***[man.m]
****#en
Returns a random element from the array arrayArg.
****#ja
配列arrayArgからランダムな要素を返す。
