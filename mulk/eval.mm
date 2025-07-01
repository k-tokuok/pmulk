evaluation of statement
$Id: mulk eval.mm 1433 2025-06-03 Tue 21:15:38 kt $
#ja ステートメントの評価

*#en
.caption SYNOPSIS
	eval [STATEMENT]
.caption DESCRIPTION
If a command argument exists, the argument string is evaluated as a statement.
Otherwise, the standard input content is evaluated as a statement.

This is the default startup command of base.mi.
*#ja
.caption 書式
	eval [STATEMENT]
.caption 説明
コマンド引数が存在すれば引数列をステートメントとして評価する。
そうでない場合は標準入力の内容をステートメントとして評価する。

base.miのデフォルトの起動コマンドである。
