urlencoder
$Id: mulk urlenc.m 1104 2023-09-10 Sun 20:37:24 kt $
#ja URLエンコード

*[man]
**#en
.caption DESCRIPTION
Returns the specified String or FixedByteArray as a URL-encoded string.
.caption LIMITATION
The subsequent bytes of ShiftJIS are not considered.
**#ja
.caption 説明
指定のStringもしくはFixedByteArrayをURLエンコードした文字列として返す。
.caption 制限事項
ShiftJISの後続バイトについては考慮されていない。

*UrlEncoder class.@
	Object addSubclass: #UrlEncoder instanceVars: "writer"
**UrlEncoder >> putHexChar: ch
	ch code asHexString0: 2 ->:hex;
	writer put: '%', put: hex first upper, put: (hex at: 1) upper
**UrlEncoder >> putChar: ch
	ch ascii? ifFalse: [self putHexChar: ch!];
	ch alnum? ifTrue: [writer put: ch!];
	ch = ' ' ifTrue: [writer put: '+'!];
	"-_.!*'()" includes?: ch, ifTrue: [writer put: ch!];
	self putHexChar: ch
**UrlEncoder >> encode: arg
	StringWriter new ->writer;
	arg size timesDo: [:i self putChar: (arg basicAt: i) asChar];
	writer asString!

*FixedByteArray >> urlEncode
	UrlEncoder new encode: self!
**[man.m]
***#en
Convert and return the receiver.
***#ja
レシーバーを変換して返す。
