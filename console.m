console
$Id: mulk console.m 1299 2024-11-10 Sun 15:32:06 kt $
#ja コンソール

*[man]
**#en
.caption DESCRIPTION
Provides additional functions for standard input / output as a terminal.

The standard input / output is simply a character stream, but depending on the terminal and view functions, it is possible to perform wrapping, paging according to the screen size, cursor motion control, etc.

Each console module has a unique name <SET> and is defined as a derived class Console.<SET> of AbstractConsole.
If this instance is registered in Mulk.bootHook, it can be used automatically at system startup, and by defining it as a system module file c-<SET>.m, it is possible to switch terminals interactively with the cset command.

The current console instance is held in the global variable Console.
**#ja
.caption 説明
端末としての標準入出力に対する付加機能を提供する。

標準入出力は単に文字ストリームだが、端末やViewの機能に応じて画面サイズによる折り返し、ページングの他、カーソルモーション制御等が可能となる。

機能毎に固有の名称<SET>を持ち、AbstractConsoleの派生クラスConsole.<SET>として定義する。
このインスタンスをMulk.bootHookに登録しておくと、システム起動時に自動的に利用出来る他、システムモジュールファイルc-<SET>.mとして定義する事で、csetコマンドで会話的に端末を切り替える事が出来る。

現在のコンソールのインスタンスはグローバル変数のConsoleに保持される。

*Console.@
	Mulk addTransientGlobalVar: #Console

*AbstractConsole class.@
	Object addSubclass: #AbstractConsole
**[man.c]
***#en
Base class for various consoles.
***#ja
各種コンソールの基底クラス。

**AbstractConsole >> start
	self!
***[man.m]
****#en
Initialize the console and start using it.

It is automatically executed when the console is switched, and the terminal mode is switched.
****#ja
コンソールを初期化し使用を開始する。

コンソールの切り替え時に自動的に実行され、端末のモード切り替え等を行う。

**AbstractConsole >> finish
	self!
***[man.m]
****#en
Finish the console.

It is automatically executed when the console is switched and the system is terminated, and the terminal mode is restored.
****#ja
コンソールを終了する。

コンソールの切り替え、及びシステムを終了する際に自動的に実行され、端末のモード回復等を行う。

**AbstractConsole >> in
	self shouldBeImplemented
***[man.m]
****#en
Returns a stream corresponding to standard input.
****#ja
標準入力に相当するストリームを返す。

**AbstractConsole >> out
	self shouldBeImplemented
***[man.m]
****#en
Returns a stream equivalent to standard output.
****#ja
標準出力に相当するストリームを返す。

**AbstractConsole >> autoLineFeedIfLineFilled?
	self shouldBeImplemented
***[man.m]
****#en
Returns true if the line is automatically broken when the cursor reaches the end of the line.
****#ja
カーソルが行末に達した時に、自動的に改行されるなら真を返す。

**AbstractConsole >> height
	self shouldBeImplemented
***[man.m]
****#en
Returns the number of lines on the screen.
****#ja
画面の行数を返す。

**AbstractConsole >> width
	self shouldBeImplemented
***[man.m]
****#en
Returns the number of screen columns.
****#ja
画面のカラム数を返す。

**AbstractConsole >> switch
	Console ->:prev, notNil? ifTrue: [prev finish];
	self start;
	self in ->In0 ->In;
	self out ->Out0 ->Out;
	self ->Console
***[man.m]
****#en
Switch to the receiver console.

Finish the old console, initialize the new console, and set the global variables In, Out, In0, and Out0.
****#ja
レシーバーのコンソールに切り替える。

旧コンソールの終了、新コンソールの初期化、グローバル変数のIn, Out, In0, Out0の設定を行う。

**AbstractConsole >> onBoot
	self switch
		
*Console.Quitter class.@
	Object addSubclass: #Console.Quitter
**Console.Quitter >> onQuit
	Console ->:c, notNil? ifTrue: [c finish]
**registy quitter.@
	Mulk.quitHook addLast: Console.Quitter new

*Console.std class.@
	AbstractConsole addSubclass: #Console.std
**[man.c]
***#en
Console equivalent to the default standard input / output.

Assume a standard screen size of 80x24.
***#ja
デフォルトの標準入出力に相当するコンソール。

80x24の標準的な画面サイズを仮定する。

**Console.std >> in
	FileStream new init: (Kernel propertyAt: 100)!
**Console.std >> out
	FileStream new init: (Kernel propertyAt: 101)!
**Console.std >> autoLineFeedIfLineFilled?
	Mulk.hostOS ->:os, = #windows or: [os = #cygwin], or: [os = #dos]!
**Console.std >> height
	24!
**Console.std >> width
	80!
	
*@
	--when import console.m, In0/Out0 is connected to stdio.
	--even if redirected, In/Out resume to stdio.
	Console.std new ->Console
