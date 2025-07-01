clipboard library (Clip.class class)
$Id: mulk cliplib.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja クリップボードライプラリ (Clip.class class)

*[man]
**#en
.caption DESCRIPTION
Provides the function to use the clipboard of the host OS.
.hierarchy Clip.class
Implementation is performed by a module that defines a derived class for each host OS, and an instance is defined in the global variable Clip by loading.

**#ja
.caption 説明
ホストOSのクリップボードを使用する機能を提供する。
.hierarchy Clip.class
実装はホストOS毎に派生クラスを定義するモジュールで行われ、ロードする事でグローバル変数Clipにインスタンスが設定される。

*Clip.class class.@
	Object addSubclass: #Clip.class;
	Mulk addGlobalVar: #Clip

**Clip.class >> copyFrom: streamArg
	self shouldBeImplemented
***[man.m]
****#en
Writes the contents of Reader streamArg to the clipboard.
****#ja
クリップボードにReader streamArgの内容を設定する。

**Clip.class >> put: arg
	self copyFrom: (MemoryStream new write: arg, seek: 0)
***[man.m]
****#en
Set a String or FixedByteArray on the clipboard.
****#ja
クリップボードに文字列かFixedByteArrayを設定する。

**Clip.class >> copyTo: streamArg
	self shouldBeImplemented
***[man.m]
****#en
Writes the contents of the clipboard to Writer streamArg.
****#ja
クリップボードの内容をWriter streamArgに書き込む。
