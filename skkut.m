skkユーティリティ
$Id: mulk skkut.m 1260 2024-06-16 Sun 21:32:59 kt $

*[man]
.caption 書式
	skkut.jtod 最大熟語長
	skkut.init [DICT]
	skkut.mkfreq LOG|FREQ...
	skkut.checkfreq
	skkut.merge [DICT]
	skkut.exist [-n] DICT
	skkut.exclude EXCLUDELIST
	skkut.dump

.caption 説明
skkutはskkの使用を支援するユーティリティプログラムである。

.caption 関連項目
.summary oldchars

**skkut.jtod 最大熟語長
skkのjisyo形式をskk/Mulkの変換辞書形式に変換する。

skk/Mulkで使用出来ない情報、azikと競合する送りがな、変換結果にかな等を含むもの、指定の最大熟語長より長いエントリは削除される。

変換辞書はcsv形式で以下のフィールドからなる。
	読み,変換候補1,候補2,...

**skkut.init [DICT]
skk/Mulkの変換辞書DICT(デフォルトはskkchunk.d)、ローマ字かな変換テーブル(skkrk.d)、ひらがな-カタカナ変換テーブル(mtrhk.d)からデータファイル(skkdict.mpi)を生成し、Mulk.workDirectoryに保存する。

**skkut.mkfreq LOG|FREQ...
指定されたskk.log及び頻度情報を統合し、累積した頻度情報を出力する。

頻度情報ファイルはcsv形式で以下のフィールドからなる。
	読み,変換,頻度回数

**skkut.checkfreq
標準入力から頻度情報を読み込み、かなやjtodで弾いている文字を含むエントリを出力する。

**skkut.merge [DICT]
標準入力から頻度情報を読み込み、変換辞書DICTに追加する形で統合した変換辞書を出力する。
DICTが存在しない場合頻度情報のみから辞書を生成する。

**skkut.exist [-n] DICT
標準入力から頻度情報を読み込み、変換辞書に含まれるエントリを出力する。

-nオプションを指定すると含まれないエントリを出力する。

**skkut.exclude EXCLUDELIST
標準入力から頻度情報を読み込み、EXCLUDELISTにあるエントリを削除する。

**skkut.dump
現在の個人辞書(skk.mpi)の内容を出力する。

これを入力としてskkut.mergeを行うと、頻度を反映させた形で変換辞書に追記出来る。

*skkut tool.@
	Mulk import: #("wcarray" "csvrd" "csvwr" "mtr" "pi" "oldchars");
	Object addSubclass: #Cmd.skkut instanceVars: 
		"invalidCharSet compoundLen" -- jtod
		+ " chunk" -- init
		+ " freqDict" -- mkfreq
		+ " henkanDict" -- merge
**jtod.
***Cmd.skkut >> addInvalidChars: strArg
	invalidCharSet addAll: (WideCharArray new addString: strArg)
***Cmd.skkut >> setupInvalidChars
	Set new ->invalidCharSet;
	0x21 to: 0x7e, do: [:code invalidCharSet add: code asChar];
	self addInvalidChars: "０１２３４５６７８９";
	self addInvalidChars: 
		"ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ";
	self addInvalidChars: 
		"ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ";
	self addInvalidChars:
		"αβγδεζηθικλμνξοπρστυφχψω";
	self addInvalidChars:
		"ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ";
	self addInvalidChars: "あいうえおかきくけこさしすせそたちつてとなにぬねの";
	self addInvalidChars: "はひふへほまみむめもやゆよらりるれろわん";
	self addInvalidChars: "がぎぐげござじずぜぞだぢづでどばびぶべぼ";
	self addInvalidChars: "ぱぴぷぺぽ";
	self addInvalidChars: "ぁぃぅぇぉゃゅょっ";
	self addInvalidChars: "アイウエオカキクケコサシスセソタチツテトナニヌネノ";
	self addInvalidChars: "ハヒフヘホマミムメモヤユヨラリルレロワン";
	self addInvalidChars: "ガギグゲゴザジズゼゾダヂヅデドバビブベボヴ";
	self addInvalidChars: "パピプペポ";
	self addInvalidChars: "ァィゥェォャュョッ";
	self addInvalidChars: "ヶヵゐゑヰヱ";
	
	self addInvalidChars: OldChars oldstr;
	invalidCharSet remove: '龍';
	invalidCharSet remove: '凛'

***Cmd.skkut >> validCol?: buf
	buf size > compoundLen ifTrue: [false!];
	buf allSatisfy?: [:ch invalidCharSet includes?: ch, not]!
***Cmd.skkut >> jtod: buf
	buf size = 0 ifTrue: [nil!];
	buf first ->:ch, between: 'ぁ' and: 'ん', ifFalse: [self!];
	Array new ->:result;
	0 ->:first;
	[buf indexOf: '/' after: first ->:last, nil?] whileFalse:
		[buf copyFrom: first until: last ->:s;
		first = 0 
			ifTrue: 
				[s includes?: '#', or: [s includes?: '>'], 
						or: [s includes?: 'を'], or: [s includes?: 'ゐ'],
					ifTrue: [self!];
				s removeLast;
				result addLast: s]
			ifFalse:
				[s indexOf: ';' ->:semi, notNil?
					ifTrue: [s copyUntil: semi ->s];
				self validCol?: s, ifTrue: [result addLast: s]];
		last + 1 ->first];
	result size = 1 ifTrue: [self!];
	result do: [:s2 Out put: s2 asString] separatedBy: [Out put: ','];
	Out putLn
***Cmd.skkut >> main.jtod: args
	args first asInteger ->compoundLen;
	self setupInvalidChars;
	In contentLines do: [:ln self jtod: (WideCharArray new addString: ln)]

**Cmd.skkut >> readChunk: fileArg
	MemoryStream new ->:ms;
	ms put: '/';
	fileArg contentLines do:
		[:ln
		ln first <> ';' ifTrue: [ms put: ln, put: '/']];
	ms seek: 0, contentBytes ->chunk
	
**init.
***Cmd.skkut >> readRkDict: dictArg
	Dictionary new ->:rkTable;
	CsvReader new init: In ->:rd;
	[rd get ->:ar, notNil?] whileTrue:
		[1 until: ar size, do:
			[:i
			ar at: i ->:s;
			1 until: s size, do:
				[:j
				s copyUntil: j ->:key;
				self assert: (rkTable at: key ifAbsent: [#fetch], = #fetch);
				rkTable at: key put: #fetch];
			rkTable at: s put: ar first]];
	dictArg at: #rkDict put: rkTable
***Cmd.skkut >> makeExtraHenkanDict
	"/zaq/kiq/juq/deq/loq"
	+ "/qai/huu/wei/pou" ->:table;
	Dictionary new ->:result;
	0 until: table size by: 4, do:
		[:i
		result at: (table at: i + 1) 
			put: (table copyFrom: i + 2 until: i + 4)];
	result!
***Cmd.skkut >> main.init: args
	Dictionary new ->:dict;
	"skkrk.d" asSystemFile,
		pipe: "grep -e ^;",
		pipe: [self readRkDict: dict];
	args empty? 
		ifTrue: ["skkchunk.d" asSystemFile] ifFalse: [args first asFile]
		->:dfile;
	self readChunk: dfile;
	dict at: #chunkDict put: chunk;
	dict at: #mtr put: MultiCharTranslator new initHk;
	dict at: #extraHenkanDict put: self makeExtraHenkanDict;
	"skkdict.mpi" asWorkFile writeObject: dict

**Cmd.skkut >> csvs: readerArg
	CsvReader new ->:cr;
	readerArg contentLines 
		select: [:ln ln first <> ';'],
		collect: [:ln2 cr parseRecord: ln2]!
	
**mkfreq.
***Cmd.skkut >> freq: ar
	ar first + ',' + (ar at: 1) ->:key;
	ar size = 3 ifTrue: [ar last asInteger] ifFalse: [1] ->:count;
	freqDict at: key put: (freqDict at: key ifAbsent: [0]) + count
***Cmd.skkut >> main.mkfreq: args
	Dictionary new ->freqDict;
	args do: [:fn self csvs: fn asFile, do: [:ar self freq: ar]];
	freqDict keysAndValuesDo:
		[:k :v
		Out put: k, put: ',', putLn: v]
		
**Cmd.skkut >> main.checkfreq: args
	self setupInvalidChars;
	self csvs: In, do: 
		[:ar
		WideCharArray new addString: (ar at: 1),
			allSatisfy?: [:ch invalidCharSet includes?: ch, not], 
			ifFalse: [Out putLn: "illegal henkan " + (ar at: 1)]]

**merge.
***Cmd.skkut >> henkanAt: keyArg
	henkanDict includesKey?: keyArg, ifTrue: [henkanDict at: keyArg!];
	"/" + keyArg + ',' ->:key;
	chunk indexOf: key size: key size from: 0 until: chunk size ->:ix;
	ix nil? ifTrue: [Array new!];
	ix + key size ->:st;
	chunk indexOf: '/' code from: st until: chunk size ->:sl;
	chunk makeStringFrom: st size: sl - st ->:s;
	CsvReader new parseRecord: s!
***Cmd.skkut >> flushHenkanDict
	CsvWriter new init: Out ->:cw;
	henkanDict keysAndValuesDo:
		[:k :v
		Out put: k, put: ',';
		cw put: v]
***Cmd.skkut >> flushChunk
	1 ->:st;
	[chunk indexOf: '/' code from: st until: chunk size ->:sl, notNil?] 
			whileTrue:
		[chunk makeStringFrom: st size: sl - st ->:s;
		s copyUntil: (s indexOf: ',') ->:key;
		henkanDict includesKey?: key, ifFalse: [Out putLn: s];
		sl + 1 ->st]
***Cmd.skkut >> updateHenkan: args
	args first ->:key;
	args at: 1 ->:value;
	self henkanAt: key ->:henkan;
	henkan indexOf: value ->:pos;
	pos = 0 ifTrue: [self!];
	pos notNil? ifTrue: [henkan removeAt: pos];
	henkan addFirst: value;
	henkanDict at: key put: henkan
***Cmd.skkut >> main.merge: args
	args empty?
		ifTrue: [FixedByteArray basicNew: 0 ->chunk]
		ifFalse: [self readChunk: args first asFile];
	Dictionary new ->henkanDict;
	self csvs: In, do: [:ar self updateHenkan: ar];
	[self flushHenkanDict] pipeTo: Out;
	self flushChunk

**Cmd.skkut >> main.exist: args
	OptionParser new init: "n" ->:op, parse: args ->args;
	op at: 'n', not ->:exist?;
	self readChunk: args first asFile;
	Dictionary new ->henkanDict;
	CsvWriter new init: Out ->:wr;
	self csvs: In, do:
		[:ar
		self henkanAt: ar first ->:henkan;
		henkan includes?: (ar at: 1), = exist?, ifTrue: [wr put: ar]]
		
**Cmd.skkut >> main.exclude: args
	Set new addAll: args first asFile contentLines ->:exc;
	CsvWriter new init: Out ->:wr;
	self csvs: In, do:
		[:ar
		exc includes?: (ar at: 1), ifFalse: [wr put: ar]]
		
**Cmd.skkut >> main.dump: args
	"skk.mpi" asWorkFile readObject ->:dict;
	dict keysAndValuesDo:
		[:k :v
		v reverse do: 
			[:e
			Out put: k, put: ',', put: e, putLn]]
