旧漢字表
$Id: mulk oldchars.m 1433 2025-06-03 Tue 21:15:38 kt $g

*[man]
.caption 説明
旧漢字の一覧を保持するオブジェクト。
.hierarchy OldChars.class
ロードするとグローバルオブジェクトOldCharsとして構築される。

	http://www2.japanriver.or.jp/search_kasen/search_help/refer_kanji.htm
の情報を元にしている。

*OldChars.class class.@
	Object addSubclass: #OldChars.class instanceVars: "oldstr newstr"
	
**OldChars.class >> oldstr
	oldstr!
***[man.m]
旧字体の漢字一覧を文字列として返す。

**OldChars.class >> newstr
	newstr!
***[man.m]
oldstrに対応する新字体の漢字一覧を文字列として返す。

**read.
***OldChars.class >> rmtab: fromArg to: writerArg
	StringReader new init: fromArg ->:rd;
	[rd getWideChar ->:ch, notNil?] whileTrue:
		[ch <> '\t' ifTrue: [writerArg put: ch]]
***OldChars.class >> read: in
	StringWriter new ->:newwr;
	StringWriter new ->:oldwr;
	[in getLn ->:ln, notNil?] whileTrue:
		[self rmtab: in getLn to: newwr;
		self rmtab: in getLn to: oldwr];
	newwr asString ->newstr;
	oldwr asString ->oldstr
	
*init.@
	reader getLn;
	Mulk at: #OldChars put: (OldChars.class new read: reader);
	reader nextBlock
**	
;1
亜	悪	圧	囲	為	医	壱	稲	飲	隠	羽	営	栄	衛	益	駅	悦	円	艶	塩
亞	惡	壓	圍	爲	醫	壹	稻	飮	隱	羽	營	榮	衞	益	驛	悅	圓	艷	鹽
;2
奥	応	横	欧	殴	穏	仮	価	画	会	回	懐	絵	拡	殻	覚	学	岳	楽	勧
奧	應	橫	歐	毆	穩	假	價	畫	會	囘	懷	繪	擴	殼	覺	學	嶽	樂	勸
;3
巻	寛	歓	缶	観	間	関	陥	館	巌	顔	帰	気	亀	偽	戯	犠	却	糾	旧
卷	寬	歡	罐	觀	閒	關	陷	館	巖	顏	歸	氣	龜	僞	戲	犧	卻	糺	舊
;4
拠	挙	峡	挟	教	狭	郷	尭	暁	区	駆	勲	薫	群	径	恵	携	渓	経	継
據	擧	峽	挾	敎	狹	鄕	堯	曉	區	驅	勳	薰	羣	徑	惠	攜	溪	經	繼
;5
茎	蛍	軽	鶏	芸	欠	倹	剣	圏	検	権	献	県	険	顕	験	厳	効	広	恒
莖	螢	輕	鷄	藝	缺	儉	劍	圈	檢	權	獻	縣	險	顯	驗	嚴	效	廣	恆
;6
鉱	号	国	黒	済	砕	斎	剤	冴	桜	冊	雑	参	惨	桟	蚕	賛	残	糸	飼
鑛	號	國	黑	濟	碎	齋	劑	冱	櫻	册	雜	參	慘	棧	蠶	贊	殘	絲	飼
;7
歯	児	辞	湿	実	舎	写	釈	寿	収	従	渋	獣	縦	粛	処	緒	諸	叙	奨
齒	兒	辭	濕	實	舍	寫	釋	壽	收	從	澁	獸	縱	肅	處	緖	諸	敍	奬
;8
将	床	焼	祥	称	証	乗	剰	壌	嬢	条	浄	畳	穣	譲	醸	嘱	触	寝	慎
將	牀	燒	祥	稱	證	乘	剩	壤	孃	條	淨	疊	穰	讓	釀	囑	觸	寢	愼
;9
晋	真	神	刃	尽	図	粋	酔	随	髄	数	枢	瀬	晴	清	精	青	声	静	斉
晉	眞	神	刄	盡	圖	粹	醉	隨	髓	數	樞	瀨	晴	淸	精	靑	聲	靜	齊
;10
跡	摂	窃	専	戦	浅	潜	繊	践	銭	禅	曽	双	壮	捜	挿	争	窓	総	聡
蹟	攝	竊	專	戰	淺	潛	纖	踐	錢	禪	曾	雙	壯	搜	插	爭	窗	總	聰
;11
荘	装	騒	増	臓	蔵	属	続	堕	体	対	帯	滞	台	滝	択	沢	単	担	胆
莊	裝	騷	增	臟	藏	屬	續	墮	體	對	帶	滯	臺	瀧	擇	澤	單	擔	膽
;12
団	弾	断	痴	遅	昼	虫	鋳	猪	庁	聴	勅	鎮	塚	逓	鉄	転	点	伝	都
團	彈	斷	癡	遲	晝	蟲	鑄	猪	廳	聽	敕	鎭	塚	遞	鐵	轉	點	傳	都
;13
党	盗	灯	当	闘	徳	独	読	届	縄	弐	妊	粘	悩	脳	覇	廃	拝	売	麦
黨	盜	燈	當	鬪	德	獨	讀	屆	繩	貳	姙	黏	惱	腦	霸	廢	拜	賣	麥
;14
発	髪	抜	飯	蛮	秘	浜	瓶	福	払	仏	並	変	辺	辺	弁	弁	弁	舗	穂
發	髮	拔	飯	蠻	祕	濱	甁	福	拂	佛	竝	變	邊	邉	辨	辯	瓣	舖	穗
;15
宝	萌	褒	豊	没	翻	槙	万	満	黙	餅	弥	薬	訳	薮	予	余	与	誉	揺
寶	萠	襃	豐	沒	飜	槇	萬	滿	默	餠	彌	藥	譯	藪	豫	餘	與	譽	搖
;16
様	謡	遥	瑶	欲	来	頼	乱	覧	略	隆	竜	両	猟	緑	隣	凜	塁	励	礼
樣	謠	遙	瑤	慾	來	賴	亂	覽	畧	隆	龍	兩	獵	綠	鄰	凛	壘	勵	禮
;17
隷	霊	齢	恋	炉	労	朗	楼	郎	禄	亘	湾
隸	靈	齡	戀	爐	勞	朗	樓	郞	祿	亙	灣
