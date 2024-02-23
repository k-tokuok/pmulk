複数文字に対する置換 (MultiCharTranslator class)
$Id: mulk mtr.m 960 2022-10-27 Thu 22:12:46 kt $

*[man]
.caption 説明
複数文字からなるパターンを指定に基いて別の文字列に置換する。
.hierarchy MultiCharTranslator
置換パターンはcsvファイルで設定し、第一カラムの内容を第二カラムに置き換える。
パターンの検出は最長一致法で行う。

	a,x
	ab,y

が指定された場合、acabaはxcyxに置換される。

*imports.@
	Mulk import: #("csvrd" "wcarray" "optparse")
	
*MultiCharTranslator class.@
	Object addSubclass: #MultiCharTranslator
		instanceVars: "dict buf cadet cadetSize out"
**MultiCharTranslator >> at: key
	dict at: key ifAbsentPut: [Cons new cdr: false]!
**MultiCharTranslator >> at: key put: target
	self at: key, car: target
**MultiCharTranslator >> setIntermidiateAt: key
	self at: key, cdr: true
**MultiCharTranslator >> init: file reverse?: reverse?
	reverse?
		ifTrue:
			[1 ->:from;
			0 ->:to]
		ifFalse:
			[0 ->from;
			1 ->to];
	Dictionary new ->dict;
	file pipe: "grep -e ^;",
		pipe:
			[CsvReader new init: In ->:rd;
			[rd get ->:ar, notNil?] whileTrue:
				[WideCharArray new addString: (ar at: from) ->:wcbuf;
				self at: wcbuf asString put: (ar at: to);
				wcbuf size > 1 ifTrue:
					[1 until: wcbuf size, do:
						[:i
						self setIntermidiateAt:
							(wcbuf copyFrom: 0 until: i) asString]]]]
***[man.m]
置換器をfileに基いて初期化する。

reverse?にtrueを設定すると第二カラムの内容を第一カラムの内容に置き換える。

**MultiCharTranslator >> serializeTo: writerArg
	nil ->buf ->cadet ->cadetSize ->out;
	super serializeTo: writerArg
	
**initialize presets.
***MultiCharTranslator >> initHk
	self init: "mtrhk.d" asSystemFile reverse?: false
****[man.m]
置換器をひらがな-カタカナ置換に初期化する。

***MultiCharTranslator >> initKh
	self init: "mtrhk.d" asSystemFile reverse?: true
****[man.m]
置換器をカタカナ-ひらがな置換に初期化する。

***MultiCharTranslator >> initRk
	self init: "mtrrk.d" asSystemFile reverse?: false
****[man.m]
置換器をローマ字-カタカナ置換に初期化する。

***MultiCharTranslator >> initKr
	self init: "mtrrk.d" asSystemFile reverse?: true
****[man.m]
置換器をカタカナ-ローマ字置換に初期化する。

***MultiCharTranslator >> initHz
	self init: "mtrhz.d" asSystemFile reverse?: false
****[man.m]
置換器を半角カナ-全角カナ置換に初期化する。

**MultiCharTranslator >> translateCadet
	out put: cadet car;
	buf removeUntil: cadetSize;
	nil ->cadet
**MultiCharTranslator >> translateBuf
	[buf asString ->:key;
	dict includesKey?: key,
		ifTrue:
			[dict at: key ->:t;
			t cdr
				ifTrue:
					[t ->cadet;
					buf size ->cadetSize]
				ifFalse:
					[out put: t car;
					buf removeAll;
					nil ->cadet]!]
		ifFalse:
			[cadet nil?
				ifTrue:
					[buf removeAll;
					out put: key!]
				ifFalse: [self translateCadet]]] loop

**MultiCharTranslator >> translateFrom: in to: outArg
	outArg ->out;
	WideCharArray new ->buf;
	nil ->cadet;
	0 ->cadetSize;
	[in getWideChar ->:ch, notNil?] whileTrue:
		[buf addLast: ch;
		self translateBuf];
	cadet notNil? ifTrue: [self translateCadet];
	out put: buf asString

**MultiCharTranslator >> translate: s
	self translateFrom: (StringReader new init: s) to: (StringWriter new ->:wr);
	wr asString!
***[man.m]
文字列sを変換し返す。
