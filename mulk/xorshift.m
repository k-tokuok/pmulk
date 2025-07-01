Xorshift method (RandomGenerator.Xorshift class)
$Id: mulk xorshift.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja Xorshift法 (RandomGenerator.Xorshift class)

*[man]
**#en
.caption DESCRIPTION
Random number generator by 32bit Xorshift method.
.hierarchy RandomGenerator.Xorshift
.caption SEE ALSO
.summary randgen
**#ja
.caption 説明
32bit Xorshift法による乱数生成器。
.hierarchy RandomGenerator.Xorshift
.caption 関連項目
.summary randgen

*@
	Mulk import: "randgen"

*RandomGenerator.Xorshift class.@
	RandomGenerator addSubclass: #RandomGenerator.Xorshift instanceVars: "y"
**RandomGenerator.Xorshift >> randomize: seedArg
	seedArg = 0 ifTrue: [2463534242] ifFalse: [seedArg] ->y;
	10 timesRepeat: [self int32]
**RandomGenerator.Xorshift >> int32
	y ^ (y << 13) ->y;
	y ^ (y >> 17) ->y;
	y ^ (y << 5) & 0xffffffff ->y!
