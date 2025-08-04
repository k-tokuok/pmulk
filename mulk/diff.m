find differences in text files
$Id: mulk diff.m 1448 2025-07-03 Thu 14:21:56 kt $
#ja テキストファイルの差分を求める

*[man]
**#en
.caption SYNOPSIS
	diff [OPTION] [FILE1] FILE2
.caption DESCRIPTION
Show the line-by-line difference between FILE1 and FILE2.
When a directory is specified as FILE2, the file with the same name as FILE1 under the specified directory is assumed to be specified.
If FILE1 is omitted, FILE1 will be obtained from standard input.

The lines that are in FILE1 but not in FILE2 are displayed as follows:
Show lines in FILE1 but not in FILE2
	FILE1 line number - line content
The lines that are in FILE2 but not in FILE1 are displayed as follows:
Lines in FILE2 but not in FILE1
	FILE2 line number + line content
.caption OPTION
	r -- reverse FILE1 and FILE2 addition/deletion mark.
.caption SEE ALSO
Based on "An O (NP) Sequence Comparison Algorithm" by Sun Wu, Udi Manber, Gene Myers, Webb Miller.

**#ja
.caption 書式
	diff [OPTION] [FILE1] FILE2
.caption 説明
FILE1とFILE2を行単位の差分を求める。
FILE2としてディレクトリを指定すると、指定ディレクトリ下のFILE1と同名のファイルが指定されたものとする。
FILE1を省略した場合は標準入力からFILE1を取得する。

FILE1にあってFILE2にない行を
	FILE1の行番号-行の内容
.cont
FILE2にあってFILE1にない行を
	FILE2の行番号+行の内容
.cont
と言う形式で表示する。
.caption オプション
	r -- FILE1とFILE2の追加/削除記号を逆に表示する。
.caption 関連項目
Based on "An O(NP) Sequence Comparison Algorithm" by Sun Wu, Udi Manber, Gene Myers, Webb Miller.

*import.@
	Mulk import: "optparse"
	
*Cmd.diff.Cord class.@
	Object addSubclass: #Cmd.diff.Cord instanceVars: "x y k"
**Cmd.diff.Cord >> x: xArg y: yArg k: kArg
	xArg ->x;
	yArg ->y;
	kArg ->k
**Cmd.diff.Cord >> x
	x!
**Cmd.diff.Cord >> y
	y!
**Cmd.diff.Cord >> k
	k!
**Cmd.diff.Cord >> printOn: writer
	writer put: "(" + x + ',' + y + ',' + k + ')'

*diff tool.@
	Object addSubclass: #Cmd.diff
		instanceVars: "a b m n offset path pathCord reverse? fp sameLine"
**Cmd.diff >> fp: pos
	fp at: pos + offset!
**Cmd.diff >> fp: pos put: value
	fp at: pos + offset put: value
**Cmd.diff >> path: pos
	path at: pos + offset!
**Cmd.diff >> path: pos put: value
	path at: pos + offset put: value
**Cmd.diff >> snake: k
	(self fp: k - 1) + 1 ->:above;
	self fp: k + 1 ->:below;
	above > below
		ifTrue:
			[self path: k - 1 ->:r;
			above ->:y]
		ifFalse:
			[self path: k + 1 ->r;
			below ->y];
	y - k ->:x;
	[x < m & (y < n) and: [a at: x, = (b at: y)]] whileTrue:
		[x + 1 ->x;
		y + 1 ->y];
	self path: k put: pathCord size;
	pathCord addLast: (Cmd.diff.Cord new x: x y: y k: r);
	y!
**Cmd.diff >> solveFp: k
	self fp: k put: (self snake: k)
**Cmd.diff >> printDiff: side at: pos
	side = #a ifTrue: [a] ifFalse: [b] ->:array;
	side = #a = reverse? not ifTrue: ['-'] ifFalse: ['+'] ->:mark;
	Out put: pos + 1 + sameLine width: 7,
		put: mark,
		putLn: (array at: pos)
**Cmd.diff >> removeSameLines
	0 ->:i;
	a size ->:asize;
	[i < asize and: [a at: i, = (b at: i)]] whileTrue: [i + 1 ->i];
	i ->sameLine;
	a removeUntil: sameLine;
	b removeUntil: sameLine
**Cmd.diff >> main: args
	OptionParser new init: "r" ->:op, parse: args ->args;
	op at: 'r' ->reverse?;
	
	args size = 1
		ifTrue:
			[In contentLines asArray ->a;
			args first asFile]
		ifFalse:
			[args first asFile ->:aFile, contentLines asArray ->a;
			args at: 1, asFile ->:bFile, directory?
				ifTrue: [bFile + aFile name ->bFile];
			bFile],
		contentLines asArray ->b;
	
	a size > b size ifTrue:
		[reverse? not ->reverse?;
		a ->:tmp;
		b ->a;
		tmp ->b];
		
	self removeSameLines;
	a size ->m;
	b size ->n;

	n - m ->:delta;
	m + 1 ->offset;
	Array new size: m + n + 3, fill: -1 ->fp;
	Array new size: m + n + 3, fill: -1 ->path;
	Array new ->pathCord;

	-1 ->:p;
	[p + 1 ->p;
	p negated ->:k;
	[k <= (delta - 1)] whileTrue:
		[self solveFp: k;
		k + 1 ->k];
	delta + p ->k;
	[k >= (delta + 1)] whileTrue:
		[self solveFp: k;
		k - 1 ->k];
	self solveFp: delta;
	pathCord size > 1000000 ifTrue: [Out putLn: "TOO MANY DIFFS."!];
	self fp: delta, <> n] whileTrue;

	self path: delta ->:r;
	Array new ->:epc;
	[r <> -1] whileTrue:
		[pathCord at: r ->:c;
		epc addLast: c;
		c k ->r];

	0 ->:x;
	0 ->:y;
	epc reverse do:
		[:e
		[x < e x | (y < e y)] whileTrue:
			[e y - e x - y + x ->:d;
			d = 0
				ifTrue:
					[x + 1 ->x;
					y + 1 ->y]
				ifFalse:
					[d > 0
						ifTrue:
							[self printDiff: #b at: y;
							y + 1 ->y]
						ifFalse:
							[self printDiff: #a at: x;
							x + 1 ->x]]]]
