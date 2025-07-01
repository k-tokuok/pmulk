random number
$Id: mulk random.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 乱数

*[man]
**#en
.caption DESCRIPTION
Set a random number generator of Xorshift method to global variable Random.

Since the current time is initialized with the seed at the time of loading and system startup, there is no apparent reproducibility, and it is convenient for easy use on a program.
.caption SEE ALSO
.summary randgen
.summary xorshift
**#ja
.caption 説明
グローバル変数RandomにXorshift方式の乱数生成器を設定する。

ロード時及びシステム起動時に現在時刻を種に初期化するので、見掛け上の再現性がなく、プログラム上で簡易的に使用するのに都合が良い。
.caption 関連項目
.summary randgen
.summary xorshift

*@
	Mulk addGlobalVar: #Random
	
*Random.Randomizer class.@
	Object addSubclass: #Random.Randomizer
**Random.Randomizer >> onBoot
	Random randomize

*default generator.@
	Mulk at: #RandomGenerator.Xorshift in: "xorshift", new randomize ->Random;
	Mulk.bootHook addLast: Random.Randomizer new
