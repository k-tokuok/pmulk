Android specific settings
$Id: mulk aset.m 1545 2026-02-28 Sat 19:51:10 kt $
#ja Android固有の設定

*[man]
**#en
.caption SYNOPSIS
	aset.kbd [no value] -- Change the keyboard property "no" to "value".
	aset.dir -- Display directory information.
.caption DESCRIPTION
Configure Android-specific settings.

.caption kbd subcommand
Change the properties of the software keyboard. 
Omitting an argument displays the current value. 

0 -- keyColor 
	1 -- keyPressedColor 
	2 -- keyPressedLabelColor 
	3 -- keyboard position left 
	4 --   top 
	5 --   right 
	6 --   bottom 
	7 --   menu top for software keyboard disabled
	
.caption dir subcommand
Display the contents of Android's FilesDir, ExternalFilesDir, and ExternalStoragePublicDirectory.

**#ja
.caption 書式
	aset.kbd [no value] -- キーボードプロパテイのnoをvalueに変更
	aset.dir -- ディレクトリ情報の表示

.caption 説明
Android固有の設定を行う。

.caption kbdサブコマンド
ソフトウェアキーボードのプロパティを変更する。
引数を省略すると現在の値が表示される。

	0 -- keyColor
	1 -- keyPressedColor
	2 -- keyPressedLabelColor
	3 -- keyboard position left
	4 --   top
	5 --   right
	6 --   bottom
	7 --   menu top for software keyboard disabled
	
.caption dirサブコマンド
AndroidのFilesDir, ExternalFilesDir, ExternalStoragePublicDirectoryの内容を表示する。

*import.@
	Android
		method: #getExternalFilesDirs signature: "S",
		method: #getExternalStoragePublicDirectory signature: "S",
		method: #softwareKeyboardCustomize signature: "AA";
	Object addSubclass: #Cmd.aset

**Cmd.aset >> main.kbd: args
	Android call: #softwareKeyboardCustomize with: nil ->:array;
	args empty?
		ifTrue: [array inspect]
		ifFalse:
			[array at: args first asInteger put: (args at: 1) asInteger;
			Android call: #softwareKeyboardCustomize with: array]
**Cmd.aset >> main.dir: args
	Out
		putLn: "FilesDir " + Android filesDir,
		putLn: "ExternalFilesDir ",
		putLn: (Android call: #getExternalFilesDirs),
		putLn: "ExternalStoragePublicDirectory "
			+ (Android call: #getExternalStoragePublicDirectory)
