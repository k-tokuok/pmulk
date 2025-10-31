introduction
$Id: mulk intro.mm 1471 2025-08-31 Sun 21:19:45 kt $
#ja はじめに

*#en
Mulk is the name of the original object-oriented language, its processing system, tool commands written in Mulk itself, and a set of libraries.

It uses a UNIX-like command line interface, and there is some compatibility in the handling of the current directory, command interpreter (shell) operations such as redirection and pipes, and commands such as file operations and various filters.
Normally, the following prompt is printed when starting up, and it waits for input.

	]

At this point, enter a command and press ENTER to execute it.

Online manuals using the man command are supported, as in UNIX.

	] man TOPIC

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
Mulkはオリジナルのオブジェクト指向言語の名称であり、その処理系とMulk自身で記述されたツールコマンド、ライブラリ群の総体です。

UNIX風のコマンドラインインタフェースを採用しており、カレントディレクトリの扱い、リダイレクション、パイプといったコマンドインタプリタ(シェル)の動作、ファイル操作や各種フィルタといったコマンド群にはある程度の互換性があります。
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

