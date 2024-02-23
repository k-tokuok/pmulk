text browse filter
$Id: mulk more.m 406 2020-04-19 Sun 11:29:54 kt $
#ja テキスト閲覧フィルタ

*[man]
**#en
.caption SYNOPSIS
	more
.caption DESCRIPTION
Output standard input page by page to the screen.

At the end of the page, you will be prompted "more?".
If you enter <enter> here, the output will be continued, and if you enter q <enter>, it will end.

**#ja
.caption 書式
	more
.caption 説明
標準入力をページ単位で画面に出力する。

ページの切れ目で、"more?"なるプロンプトが表示される。
ここで<enter>を入力すると出力を継続し、q<enter>を入力すると終了する。

*more tool.@
	Mulk at: #PageWriter in: "pagewr", addSubclass: #Cmd.more
**Cmd.more >> pause
	Out0 put: "more?";
	In0 getLn = "q" ifTrue: [ExitException new signal];
	0 ->y
**Cmd.more >> main: args
	[In getChar ->:ch, notNil?] whileTrue: [self put: ch]
