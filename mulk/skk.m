かな漢字変換日本語インプットメソッド
$Id: mulk skk.m 1433 2025-06-03 Tue 21:15:38 kt $

*[man]
.caption 書式
	skk [-l] -- 初期化しConsoleに結び付いて常駐する
	skk.off -- 常駐を解除する
	skk.regist 読み 変換結果 -- 個人辞書に登録する
	skk.load -- 個人辞書/候補順序を読み込む
	skk.save -- 個人辞書/候補順序を保存する
.caption 説明
かな漢字変換方式の日本語インプットメソッド。

漢字の開始点と送りがなの開始点を入力時に明に指定することで、形態素解析を行わずにかな漢字変換を行う。
.caption オプション
	l -- 変換ログをMulk.workDirectoryにskk.logとして出力する。
.caption 原案
Based on SKK (Simple Kana to Kanji conversion program) on GNU Emacs by Masahiko Sato and many others.

https://github.com/skk-dev/ddskk
.caption 制限事項
日本語の表示が可能で、画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary sconsole
.summary skkut
.summary azik
.caption 関連ファイル
	skkchunk.d -- かな漢字変換辞書
	skkrk.d -- ローマ字かな変換テーブル
**モード
skkは3つのモードを持ち、以下のキーで切り替える。
	^j (ctrl + j) -- 平仮名モード
	^k -- 片仮名モード
	^l -- 英数モード
英数モードでは打鍵した内容がそのまま入力される。
平仮名モード・片仮名モードではazikによる平仮名・片仮名と単文節変換による漢字入力を行う。
azikについてはマニュアルトピックazikを参照のこと。

**漢字変換
平仮名、片仮名モードで変換したい読みの先頭を大文字で入力すると▽に続けて読みが表示される。

この状態で^kを入力すると入力済みの読みが片仮名に変換される。
空白または後続する送り仮名の先頭文字を大文字で入力することで読みが確定し▼に続けて漢字変換候補が表示される。
送り仮名として「っ」を指定する場合は';'のシフトである'+'や':'ではなく'L'を入力する。

候補が表示された状態で改行又は後続の文字を入力することで漢字を入力出来る。
空白を入力すると次の候補に進み、^hを入力すると前の候補に戻る。
^jを入力するとキャンセルされ平仮名モードとなる。

3つ目の候補まで進むとホームポジションのキー(a:, s:, d:,...)が前置される形で最大十個の候補が一度に表示される。
ここではホームポジションのキーを入力することで漢字が入力される。

最後の変換候補として▼が表示される。
これを確定すると"!skk regist 読み"なる文字列が入力される。
wb上であれば続けて漢字を入力し'!'以降を実行することで辞書登録出来る。

*import.@
	Mulk import: #("optparse" "csvrd" "pi" "mtr")

*Skk.class class.@
	Mulk includesKey?: #Skk, ifFalse: [Mulk addGlobalVar: #Skk];
	Object addSubclass: #Skk.class instanceVars: 
		"log? rkDict chunkDict mtr extraHenkanDict pDict tDict updateCount"
		+ " mode queue ungetQueue"
		+ " interm intermBacking intermX intermY intermMaxWidth"
		+ " curX curY rkpos"
		+ " cadets cadetPrompts cadetsWidth cpos okuri singleHenkan"
		
**Skk.class >> log: messageArg
	log? ifFalse: [self!];
	[Out putLn: messageArg] pipeAppendTo: "skk.log" asWorkFile
**Skk.class >> comment: messageArg
	self log: ";" + DateAndTime new initNow + ' ' + messageArg
**Skk.class >> pDictFile
	"skk.mpi" asWorkFile!
**Skk.class >> tDictFile
	"skktmp.mpi" asWorkFile!
**Skk.class >> save
	tDict empty? ifTrue: [self!];
	tDict keysAndValuesDo: [:k :v pDict at: k put: v];
	self pDictFile ->:pf, writeObject: pDict;
	self comment: "save " + pf size + " update " + tDict size;
	self tDictFile ->:tf, readableFile? ifTrue: [tf remove];
	Dictionary new ->tDict;
	0 ->updateCount
**Skk.class >> load
	self pDictFile ->:pf, readableFile? 
		ifTrue: 
			[self comment: "load " + pf size;
			pf readObject] 
		ifFalse: [Dictionary new] ->pDict;
	self tDictFile ->:tf, readableFile? ifTrue:
		[tf readObject ->tDict;
		self save]
**Skk.class >> init: logArg?
	logArg? ->log?;
	self comment: "start";
	"skkdict.mpi" asWorkFile ->:f, readableFile? ifFalse: 
		["skkut.init" runCmd];
	f readObject ->:dict;
	dict at: #rkDict ->rkDict;
	dict at: #chunkDict ->chunkDict;
	dict at: #mtr ->mtr;
	dict at: #extraHenkanDict ->extraHenkanDict;
	Dictionary new ->tDict;
	self load;
	Ring new ->queue;
	Ring new ->ungetQueue;
	#ascii ->mode;
	0 ->updateCount;
	WideCharArray new ->interm;
	Console width min: 80, - 1 ->cadetsWidth;
	3 ->singleHenkan
**Skk.class >> personalDictAt: keyArg
	tDict at: keyArg ifAbsent: [nil] ->:result;
	result nil? ifTrue: [pDict at: keyArg ifAbsent: [nil] ->result];
	result nil? ifTrue: [Array new ->result];
	result!
**Skk.class >> henkanAt: keyArg
	self personalDictAt: keyArg ->:larray;
	larray copy ->:result;
	"/" + keyArg + ',' ->:key;
	chunkDict indexOf: key size: key size from: 0 until: chunkDict size ->:ix;
	ix notNil? ifTrue:
		[ix + key size ->:st;
		chunkDict indexOf: '/' code from: st until: chunkDict size ->:sl;
		CsvReader new 
			parseRecord: (chunkDict makeStringFrom: st size: sl - st),
			do:
				[:s
				larray includes?: s, ifFalse: [result addLast: s]]];
	result!	
**Skk.class >> henkanAt: keyArg add: value
	self personalDictAt: keyArg ->:list;
	list indexOf: value ->:ix, notNil? ifTrue: [list removeAt: ix];
	list addFirst: value;
	tDict at: keyArg put: list;
	updateCount + 1 ->updateCount, >= 10 ifTrue: 
		[self tDictFile ->:f, writeObject: tDict;
		self comment: "savetmp " + f size;
		0 ->updateCount]
**Skk.class >> regist: key value: value
	self log: key + ',' + value;
	self henkanAt: key add: value
**Skk.class >> onQuit
	self save;
	self comment: "quit"

**interm control.
***Skk.class >> resumeInterm
	Console gotoX: intermX Y: intermY;
	Console put: intermBacking
***Skk.class >> showInterm
	intermBacking nil? ifTrue:
		[Console curX ->curX ->intermX;
		Console curY ->curY ->intermY];
	intermX + interm width >= (Console width - 1) ifTrue:
		[intermBacking notNil? ifTrue: 
			[self resumeInterm;
			nil ->intermBacking];
		intermX >= 162 
			ifTrue: [162]
			ifFalse: [intermX >= 81 ifTrue: [81] ifFalse: [0]] ->intermX;
		intermY + 1 ->intermY;
		intermY = Console height ifTrue: [intermY - 1 ->intermY]];
	intermBacking nil? ifTrue:
		[Console charsX: intermX Y: intermY size: Console width - intermX - 1
			->intermBacking;
		0 ->intermMaxWidth];
	interm width ->:iw;
	Console gotoX: intermX Y: intermY;
	Console put: interm asString;
	intermMaxWidth - iw ->:sp, > 0
		ifTrue:
			[Console putSpaces: sp;
			Console gotoX: intermX + iw Y: intermY]
		ifFalse: [iw ->intermMaxWidth]
***Skk.class >> eraseInterm
	interm size: 0;
	intermBacking notNil? ifTrue:
		[self resumeInterm;
		nil ->intermBacking;
		Console gotoX: curX Y: curY]
		
**Skk.class >> reset
	nil ->rkpos;
	mode = #yomi ifTrue: [#hiragana ->mode];
	self eraseInterm
**Skk.class >> addQueue: kana
	StringReader new init: kana ->:r;
	[r getWideChar ->:ch, notNil?] whileTrue: [queue addLast: ch]
**Skk.class >> processRk: ch
	rkpos nil? ifTrue: [interm size ->rkpos];
	interm addLast: ch;
	rkDict at: (interm copyFrom: rkpos, asString) ifAbsent: [nil] ->:result;
	result = #fetch 
		ifTrue: [self showInterm]
		ifFalse:
			[result nil?
				ifTrue:
					[interm removeLast;
					interm size = rkpos ifTrue: [nil ->rkpos]]
				ifFalse:
					[interm size: rkpos;
					nil ->rkpos]];
	result!
	
**henkan.
**Skk.class >> promptString
	cpos = cadets size ifTrue: ["▼"!];
	cadets at: cpos ->:result;
	okuri notNil? ifTrue: [result + okuri ->result];
	result!
**Skk.class >> addCadetPrompt
	cpos < singleHenkan ifTrue: 
		[cadetPrompts addLast: 
			(Cons new car: "▼" + self promptString, cdr: cpos);
		cpos + 1 ->cpos!];
	WideCharArray new addString: "▼" ->:buf;
	"asdfghjkl;" ->:key;
	0 ->:i;
	[buf size ->:bs;
	buf addString: (key copyFrom: i until: i + 1) + ':' + self promptString 
		+ ' ';
	buf width < cadetsWidth
		ifTrue:
			[cpos + 1 ->cpos;
			i + 1 ->i];
	buf width >= cadetsWidth | (cpos > cadets size) | (i = 10) ifTrue:
		[buf width >= cadetsWidth ifTrue: [buf size: bs];
		cadetPrompts addLast: (Cons new car: buf asString, cdr: cpos - i)!]]
		loop
**Skk.class >> henkanEnd: posArg key: keyArg
	self reset;
	posArg = cadets size ifTrue:
		[self addQueue: "\cg!skk.regist " + keyArg + ' '!];
	cadets at: posArg ->:cadet;
	self log: keyArg + ',' + cadet;
	posArg <> 0 ifTrue: [self henkanAt: keyArg add: cadet];
	self addQueue: cadet;
	okuri notNil? ifTrue: [ungetQueue addLast: okuri]
**Skk.class >> henkan: okuriArg
	okuriArg ->okuri;
	interm copyFrom: 1, asString ->:key;
	okuri notNil? ifTrue: [key + okuri ->key];
	interm copy ->:yomiinterm;
	self henkanAt: key ->cadets;
	Array new ->cadetPrompts;
	0 ->cpos;
	[cpos <= cadets size] whileTrue: [self addCadetPrompt];
	0 ->:pos;
	[cadetPrompts at: pos ->:cons;
	interm size: 0, addString: cons car;
	self showInterm;
	Console rawFetch ->:ch;
	ch = ' ' ifTrue:
		[pos + 1 min: cadetPrompts size - 1 ->pos;
		nil ->ch];
	ch = '\b' ifTrue:
		[pos = 0 ifTrue:
			[#yomi ->mode;
			yomiinterm ->interm;
			self showInterm!];
		pos - 1 ->pos;
		nil ->ch];
	ch = '\cj' ifTrue: [self reset!];
	ch notNil? ifTrue:
		[pos < singleHenkan
			ifTrue:
				[self henkanEnd: pos key: key;
				ch <> '\cm' ifTrue: [ungetQueue addLast: ch]!]
			ifFalse:
				[ch = '\ck' | (ch = '\cl') ifTrue:
					[self reset;
					ungetQueue addLast: ch!];
				"asdfghjkl;" indexOf: ch ->:off, notNil?
					and: [cons cdr + off ->:pos2, <= cadets size],
					ifTrue: [self henkanEnd: pos2 key: key!]]]] loop

**Skk.class >> modeChar: ch
	ch = '\cj' | (ch = '\ck') | (ch = '\cl') ifFalse: [false!];
	self reset;
	ch = '\cj' 
		ifTrue: [#hiragana]
		ifFalse: [ch = '\ck' ifTrue: [#katakana] ifFalse: [#ascii]] ->mode;
	true!
**Skk.class >> asciiChar: ch
	self modeChar: ch, ifTrue: [self!];
	queue addLast: ch;
	true!
**Skk.class >> backChar: ch
	ch = '\b' ifFalse: [false!];
	interm empty? ifTrue: [false!];
	interm removeLast;
	interm size = rkpos ifTrue: [nil ->rkpos];
	interm empty? 
		ifTrue: [self reset]
		ifFalse: [self showInterm];
	true!
**Skk.class >> startYomiChar: ch
	ch upper? ifFalse: [false!];
	rkpos notNil? ifTrue:
		[self reset;
		true!];
	#yomi ->mode;
	interm addLast: '▽';
	ch lower ->ch;
	self processRk: ch ->:kana, = #fetch ifTrue: [true!];
	kana notNil? ifTrue:
		[interm addString: kana;
		self showInterm];
	true!
**Skk.class >> ctrlChar: ch
	ch code < 0x20 ifFalse: [false!];
	self reset;
	queue addLast: ch;
	true!
**Skk.class >> hiraganaKatakanaChar: ch
	self modeChar: ch, ifTrue: [self!];
	self backChar: ch, ifTrue: [self!];
	self ctrlChar: ch, ifTrue: [self!];
	self startYomiChar: ch, ifTrue: [self!];
	rkpos notNil? ->:rklead?;
	self processRk: ch ->:kana, = #fetch ifTrue: [self!];
	kana notNil? ifTrue:
		[mode = #katakana ifTrue: [mtr translate: kana ->kana];
		self addQueue: kana;
		self reset!];
	rklead? ifFalse: [queue addLast: ch]
**Skk.class >> henkanChar: ch
	rkpos notNil? ifTrue:
		[extraHenkanDict at: ch ifAbsent: [self!] ->:s;
		self processRk: s first ->:kana, nil? | (kana = #fetch) 
			ifTrue: [self!];
		interm addString: kana;
		s at: 1 ->ch];
	ch = ' ' ifTrue: [nil ->ch];
	ch = 'l' ifTrue: [';' ->ch];
	self henkan: ch
**Skk.class >> yomiChar: ch
	ch = '\ck' ifTrue: 
		[rkpos notNil? ifTrue: 
			[interm copyUntil: rkpos ->interm;
			nil ->rkpos];
		self addQueue: (mtr translate: (interm copyFrom: 1) asString);
		self reset!];
	self modeChar: ch, ifTrue: [self!];
	self backChar: ch, ifTrue: [self!];
	self ctrlChar: ch, ifTrue: [self!];
	ch = ' ' | ch upper? ifTrue: [self henkanChar: ch lower!];
	self processRk: ch ->:kana, = #fetch ifTrue: [self!];
	kana notNil? ifTrue: [interm addString: kana];
	self showInterm
**Skk.class >> cycle
	ungetQueue empty?
		ifTrue: [Console rawFetch ->:ch]
		ifFalse: 
			[ungetQueue first ->ch;
			ungetQueue removeFirst];
	mode = #ascii ifTrue: [self asciiChar: ch!];
	mode = #hiragana | (mode = #katakana) ifTrue: 
		[self hiraganaKatakanaChar: ch!];
	mode = #yomi ifTrue: [self yomiChar: ch!]
**Skk.class >>> cycleDebug
	[self cycle] on: Error do:
		[:e
		e printStackTrace;
		Out putLn: e message]
**Skk.class >> fetch
	[queue empty?] whileTrue: [self cycle];
	queue first ->:result;
	queue removeFirst;
	result!
**Skk.class >> mode
	mode!
**Skk.class >> mode: arg
	self reset;
	arg ->mode
		
*skk tool.@
	Object addSubclass: #Cmd.skk
**Cmd.skk >> main.off: args
	Skk notNil? ifTrue:
		[Skk onQuit;
		Mulk.quitHook remove: Skk;
		nil ->Skk];
	Console inputMethod: nil
**Cmd.skk >> main: args
	OptionParser new init: "l" ->:op, parse: args ->args;
	self main.off: nil;
	Skk.class new init: (op at: 'l') ->Skk;
	Mulk.quitHook addLast: Skk;
	Console inputMethod: Skk
**Cmd.skk >> main.load: args
	Skk load
**Cmd.skk >> main.regist: args
	args at: 1 ->:value;
	Skk regist: args first value: value;
	Out put: value
**Cmd.skk >> main.save: args
	Skk save
