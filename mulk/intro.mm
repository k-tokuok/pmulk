introduction
$Id: mulk intro.mm 1529 2026-01-21 Wed 21:17:30 kt $
#ja はじめに

*#en
Mulk is the name of an object-oriented programming language, encompassing its interpreter and the collective set of tools and libraries written in Mulk itself.

It adopts a UNIX-like command-line interface, offering a degree of compatibility with command interpreter (shell) behaviors such as command argument handling, current directory management, redirection, and pipes, as well as with command groups like file operations and various filters.
Typically, upon startup, it outputs the following prompt and waits for input. 

	]

At this point, enter a command and press ENTER to execute it.

Online manuals using the man command are supported, as in UNIX.

	]man TOPIC

If the screen cannot display all the information, "more?".
Press ENTER here, the next item will be displayed.

The following is a list of topics for the main items.

.summary man
.summary icmd
.summary lang
.summary base

The following commands list the available commands.

	]man.whatis -p tool

*#ja
Mulkはオブジェクト指向プログラミング言語の名称であり、その処理系とMulk自身で記述された各種ツール、ライブラリ群の総体です。

UNIX風のコマンドラインインタフェースを採用しており、コマンド引数の仕組み、カレントディレクトリの扱い、リダイレクション、パイプといったコマンドインタプリタ(シェル)の動作、ファイル操作や各種フィルタといったコマンド群にはある程度の互換性があります。
通常、起動すると次のプロンプトが出力され、入力待ちとなります。

	]
	
ここで、コマンドを入力しENTERを打鍵すると実行されます。

UNIX同様manコマンドによるオンラインマニュアルをサポートしています。

	]man 項目名

画面に表示しきれない場合は"more?"と表示されます。
ここでENTERを打鍵すると続きが表示されます。

以下に主要な項目についてトピックを示します。

.summary man
.summary icmd
.summary lang
.summary base

以下のコマンドで使用可能なコマンドの一覧が表示されます。

	]man.whatis -p tool

