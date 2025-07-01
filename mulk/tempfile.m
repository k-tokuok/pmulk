temporary file (TempFile.class class)
$Id: mulk tempfile.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 一時ファイル (TempFile.class class)

*[man]
**#en
.caption DESCRIPTION
Create a unique temporary file object.

.hierarchy TempFile.class

Don't construct an instance with new, use the global object TempFile.

Construct a file object with a unique name starting with '_' in the working directory and without the file entity.
The created file must be deleted by the acquired program.

It works correctly even if multiple Mulks are executed in parallel.

.caption LIMITATION
It is the responsibility of the acquired program to delete files that have been used.

Although it is a very long cycle, the file name is used cyclically, so there is a possibility of a collision if the reserved file is reused when it does not exist.

.caption SEE ALSO
.summary clean
**#ja
.caption 説明
ユニークな一時ファイルオブジェクトを作成する。

.hierarchy TempFile.class

インスタンスをnewで構築せず、グローバルオブジェクトTempFileを使用すること。

ワークディレクトリの'_'で始まるユニークな名称を持ち、ファイル実体のないファイルオブジェクトを構築する。
作成したファイルは取得したプログラムが削除しなくてはならない。

Mulkを複数並列実行しても正しく動作する。

.caption 制限事項
非常に長周期だがファイル名をサイクリックに使用する為、確保したファイルが存在しない状態で再利用されると衝突が起きる可能性がある。

.caption 関連項目
.summary clean

*TempFile.class class.@
	Object addSubclass: #TempFile.class

**TempFile.class >> makeFile: suffix
	"tempfile.num" asWorkFile->:numFile;
	numFile none?
		ifTrue: [0]
		ifFalse: [numFile readDo: [:fs fs getLn asInteger]] ->:num;
	[("_" + num + "." + suffix) asWorkFile ->:f;
	num + 1 % 10000000 ->num;
	f none?] whileFalse;
	numFile writeDo: [:fs2 fs2 putLn: num];
	f!
**TempFile.class >> create: suffixArg
	Mulk.hostOS = #dos | (Mulk.hostOS = #android)
		ifTrue: [self makeFile: suffixArg]
		ifFalse: 
			["tempfile.lck" asWorkFile lockDo: [self makeFile: suffixArg]]!
***[man.m]
****#en
Returns a temporary file object with extension String suffixArg.
****#ja
拡張子がString suffixArgの一時ファイルオブジェクトを返す。

**TempFile.class >> create
	self create: "wk"!
***[man.m]
****#en
Returns a temporary file object with extension "wk".
****#ja
拡張子が"wk"の一時ファイルオブジェクトを返す。
***[test.m]
	TempFile create ->:f;
	self assert: f parent = Mulk.workDirectory;
	self assert: f suffix = "wk";

	TempFile create ->:f2;
	self assert: f <> f2
	
*setup.@
	Mulk at: #TempFile put: TempFile.class new
