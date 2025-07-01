arithmetic calculation
$Id: mulk calc.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 四則計算

*[man]
**#en
.caption SYNOPSIS
	calc [EXPR...]
.caption DESCRIPTION
Evaluate the expression and display the value.

If the expression is omitted, the expression is read from standard input.
The expression may include spaces.
Unlike Mulk's formula evaluation, multiplication and division have a high priority.
**#ja
.caption 書式
	calc [式...]
.caption 説明
式を評価し値を表示する。

式を省略すると標準入力から式を読み込む。
式は空白を含んでいても良い。
Mulkの式評価と異なり、乗除の優先順位が高い。

*calc tool.@
	Object addSubclass: #Cmd.calc instanceVars: "reader"

**Cmd.calc >> nextChar
	reader skipSpace;
	reader nextChar!
**Cmd.calc >> factor
	self nextChar = '(' ifTrue:
		[reader skipChar;
		self expression ->:val;
		self nextChar <> ')' ifTrue: [self error: "missing )"];
		reader skipChar;
		val!];

	reader skipNumber!
**Cmd.calc >> term
	self factor ->:val;
	[self nextChar ->:ch, = '*' | (ch = '/')] whileTrue:
		[reader skipChar;
		ch = '*' ifTrue: [val * self factor] ifFalse: [val / self factor]
			->val];
	val!
**Cmd.calc >> expression
	self term ->:val;
	[self nextChar ->:ch, = '+' | (ch = '-')] whileTrue:
		[reader skipChar;
		ch = '+' ifTrue: [val + self term] ifFalse: [val - self term] ->val];
	val!
**Cmd.calc >> eval: s
	AheadReader new init: s ->reader;
	Out putLn: self expression
**Cmd.calc >> main: args
	args empty?
		ifTrue: [In contentLinesDo: [:s self eval: s]]
		ifFalse: [self eval: args asString]
