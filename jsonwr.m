JsonWriter class
$Id: mulk jsonwr.m 920 2022-09-04 Sun 20:39:46 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Write the object in JSON format.
.hierarchy JsonWriter
The object must consist of Dictionary, Array, String, Boolean, Number and nil.
Character code conversion is not performed.
Numerical and character expressions are not completely compatible.
.caption SEE ALSO
.summary jsonrd
**#ja
.caption 説明
オブジェクトをJSON形式で書き出す。
.hierarchy JsonWriter
オブジェクトはDictionary Array String Boolean Number nilから成らなくてはならない。
文字コードの変換は行わない。
数値、文字表現に完全な互換性がある訳ではない。
.caption 関連項目
.summary jsonrd

*JsonWriter class.@
	Object addSubclass: #JsonWriter instanceVars: "stream"

**JsonWriter >> init: streamArg
	streamArg ->stream
***[man.m]
****#en
Initialize the output destination with Writer streamArg.
****#ja
出力先をWriter streamArgで初期化する。

**JsonWriter >> putIndent: indent
	stream put: '\n';
	indent * 2 timesRepeat: [stream put: ' ']
**JsonWriter >> put: arg indent: indent
	arg nil? ifTrue: [stream put: "null"!];
	arg kindOf?: Boolean, or: [arg kindOf?: Number], ifTrue: [stream put: arg!];
	--ToDo: escape.
	arg kindOf?: String, ifTrue: [stream put: '"', put: arg, put: '"'!];
	arg kindOf?: Array, ifTrue:
		[stream put: '[';
		arg 
			do:
				[:elt
					self putIndent: indent + 1;
					self put: elt indent: indent + 1]
			separatedBy: [stream put: ','];
		self putIndent: indent;
		stream put: ']'!];
	arg kindOf?: Dictionary, ifTrue:
		[stream put: '{';
		arg keys 
			do:
				[:k
				self putIndent: indent + 1;
				self put: k indent: indent;
				stream put: ':';
				self put: (arg at: k) indent: indent + 1]
			separatedBy: [stream put: ','];
		self putIndent: indent;
		stream put: '}'!];
	self assertFailed

**JsonWriter >> put: arg
	self put: arg indent: 0;
	stream put: '\n'
***[man.m]
****#en
Write Object arg.
****#ja
Object argを出力する。
