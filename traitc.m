TraitCount class
$Id: mulk traitc.m 1145 2023-12-09 Sat 21:39:51 kt $
#ja
*[man]
**#en
.caption DESCRIPTION
Base class for tools that count trait of file.
.hierarchy TraitCount
.caption SEE ALSO
.summary bytec
.summary linec
.summary charc
.summary wordc
**#ja
.caption 説明
ファイルの特性をカウントするツールの基底クラス。
.caption 関連項目
.summary bytec
.summary linec
.summary charc
.summary wordc

*TraitCount class.@
	Mulk import: #("optparse" "numlnwr");
	Object addSubclass: #TraitCount
**TraitCount >> main: args
	OptionParser new init: "fw:" ->:op, parse: args ->args;
	NumberedLineWriter new init: 7 op: op ->:wr;
	op at: 'f',
		ifTrue:
			[0 ->:total;
			In contentLinesDo:
				[:fn
				fn asFile readDo:
					[:fs self count: fs ->:count;
					wr put: count and: fn;
					count + total ->total]];
			total]
		ifFalse:
			[self count: In] ->count;
	wr put: count and: nil
