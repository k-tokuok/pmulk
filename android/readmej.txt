android版について
$Id: mulk/android readmej.txt 1594 2026-05-03 Sun 19:40:51 kt $

*基本的なビルド手順
**前提
../mulkディレクトリでMulk処理系がビルドしてある事。

**mulka0.zipの作成
androidディレクトリで、

	]cmd build.mc

でassetsとしてmulka0.zipが作成される。
これは最小限のイメージとmulka0パッケージからなる。

**android studioからの実行
android/Mulkをandroid studioプロジェクトとして開けば普通に実行出来る。

**apkの作成
適当なキーストアを用意し、build/generate signed bundle/apk...で署名付きapkを作成する。

これをadbや実機上のファイラからインストールする。

*起動と操作
apkをインストールして起動すると、アプリケーションのFilesDir、通常は
	/data/user/0/com.github.k_tokuok.mulk/files/mulka0
に最小限のシステムが展開され、replが起動する。
ここで実キーボードかソフトウェアキーボードから繰作出来る。

**ソフトウェアキーボード
ソフトウェアキーボードの操作は以下の通り。

右上空白ボタン左 -- テンキーとフルキーの切り替え
右上空白ボタン右 -- メニューの表示

フルキーはフリック入力によって記号や制御文字を入力出来る。
キーラベルは以下のようになる。

	U  L/R
	N  D

N -- その場のプレスで入力される文字。
U -- 上にフリック。大文字の場合は省略。
D -- 下にフリック。
L -- 左にフリック。制御文字(コントロールキー)の場合は省略。
R -- 右にフリック。その他の文字。

Tb -- tab
Sp -- space
Bs -- backspace
En -- enter

**メニュー
	^c -- ^cを送信する。
	reset -- Mulkをリブートする。
	prefs... -- 設定画面を開く。
	
**設定画面
	imageFile -- 起動イメージファイルの指定。
	useKeymap -- キーマップファイルの使用の可否。
	keymapFile -- キーマップファイルの位置。
		特殊シフトモードを用いる場合はキーマップファイルが必要。
	enableSoftwareKeyboard -- ソフトウェアキーボードの表示/非表示。
	extractMulka0 -- 次回起動時にapk内のシステムを展開し、base.miから起動。

*実運用環境
mulka0は基本的にreplが起動出来るだけなので、実際に運用する環境を別途構築する必要がある。

	>Mulk load: "setupa.m" asSystemFile

でgithub上の最新リリースを取得し、以下のような環境を構築する。

/data/user/0/com.github.k_tokuok.mulk/files
	mulka0 -- apk内のシステム
	mulk.mi -- 実運用用のイメージ
	mulk -- Mulk.systemDirectory
	work -- Mulk.workDirectory
	h -- home directory
	
ここでmulk.mi(コマンドインタプリタの動作する最小のイメージ)が起動イメージに設定されるので、次回起動からはコマンドインタプリタが動作する。

*ヒント
**mulka0
mulka0の構成でもicmd, zip, gdrive等最小限のツールを使う事は出来る。

icmdはreplから

	>Mulk at: #Cmd.icmd in: "icmd", new main: #()
	
で起動出来る。

**ストレージ
	]aset.dir

で使用可能なディレクトリを確認出来るのでSDメモリカードやDocuments下に環境を作ることも出来る。

FilesDir下なら自由に使用出来るがmulkをuninstallすると失われる。

それ以外のディレクトリは環境によっては「説定/アプリ/Mulk/権限」からメディアへのアクセス許可を与える必要があるとか、そもそもアクセス出来ない場合もある。

**更新・上書きインストール
上書きインストールした場合は設定済みのイメージから立ち上がる。
ただし、base.mの内容が大きく変わったり、プリミティブの仕様が変わった場合は正しく動作しなくなる。
この場合は設定のextractMulk0をチェックしてresetするとmulka0が再展開されて、mulka0のイメージから立ち上がる。

vmと起動イメージが大きく食い違うとGUIも立ち上がらずにフォールトする場合もある。
その場合は「設定/アプリケーション」のMulkの項から「データを消去」して再起動する。
事前にextractMulka0をチェックしてからapkをインストールするとインストール後の起動時にmulka0を展開するので、このような事態は避けられる。

