replace parts that match the regular expression
$Id: mulk gres.m 932 2022-09-18 Sun 17:45:15 kt $
#ja 正規表現にマッチする部位を置換する

*[man]
**#en
.caption SYNOPSIS
	gres [OPTION] PATTERN [DEST]
.caption DESCRIPTION
Replace regular expression PATTERN in input with DEST and output.

Escape sequences can be used in DEST.
.caption OPTION
	m -- output only matching lines.
	g -- replace all matches in a line.
.caption SEE ALSO
.summary regexp
**#ja
.caption 書式
	gres [OPTION] PATTERN [DEST]
.caption 説明
入力中の正規表現PATTERNをDESTに置き換えて出力する。

DEST中でエスケープシーケンスを使用可能。
.caption オプション
	m -- マッチした行のみ出力する。
	g -- 行内の全てのマッチした箇所を置き換える。
.caption 関連項目
.summary regexp

*gres tool.@
	Mulk import: #("optparse" "regexp");
	Object addSubclass: #Cmd.gres instanceVars: "regexp dest global?"
**Cmd.gres >> replace: s
	StringWriter new ->:w;
	w put: (s copyUntil: regexp matchStartPos);
	w put: dest;
	s copyFrom: regexp matchEndPos ->s;
	global? ifTrue:
		[[regexp match: s] whileTrue:
			[w put: (s copyUntil: regexp matchStartPos);
			w put: dest;
			regexp matchEndPos ->:pos;
			self assert: pos <> 0;
			s copyFrom: pos ->s]];
	w put: s;
	w asString!
**Cmd.gres >> main: args
	OptionParser new init: "mg" ->:op, parse: args ->args;
	op at: 'm' ->:matchOnly?;
	op at: 'g' ->global?;
	
	RegExp new compile: args first ->regexp;

	"" ->dest;
	args size = 2 ifTrue:
		[AheadReader new init: (args at: 1), resetToken ->:r;
		[r nextChar notNil?] whileTrue: [r getWideEscapeChar];
		r token ->dest];
	In contentLinesDo:
		[:line
		regexp match: line,
			ifTrue: [Out putLn: (self replace: line)]
			ifFalse: [matchOnly? ifFalse: [Out putLn: line]]]
