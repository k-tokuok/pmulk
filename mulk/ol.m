outline file processing
$Id: mulk ol.m 1434 2025-06-05 Thu 20:56:36 kt $
#ja アウトラインファイル処理

*[man]
**#en
.caption SYNOPSIS
	ol [OPTION]
.caption DESCRIPTION
A filter for processing outline files.

By default, outline lines are numbered.
An outline file is a text file divided into items by outline lines (lines starting with "*"), and has a hierarchical structure based on the number (level) of "*".
That is, the level n item is a higher element of the subsequent level n + 1 item.
In the outline line, you can describe the item name after "*".
.caption OPTION
	i -- Indent outline lines to level.
	s -- Do not output the text.
	h -- Do not output outline lines.
	p Item name -- Output only the section with the specified item name.
	S -- Skip additional description of module file.
	o -- Output outline marks.
	l -- Level numbers are not output.
**#ja
.caption 書式
	ol [option]
.caption 説明
アウトラインファイルを処理する為のフィルター。
デフォルトではアウトライン行を番号付けする。

アウトラインファイルはアウトライン行("*"で始まる行)で項目に分割されたテキストファイルで、"*"の数(レベル)により階層化された構造を持つ。
即ち、レベルnの項目は、後続するレベルn+1の項目の上位要素となる。
アウトライン行には"*"に続けて項目名を記述する事が出来る。
.caption オプション
	i -- アウトライン行をレベルに合わせてインデントする。
	s -- 本文を出力しない。
	h -- アウトライン行を出力しない。
	p 項目名 -- 指定項目名のセクションのみを出力する。
	S -- モジュールファイルの付加記述をスキップする。
	o -- アウトラインマークを出力する。
	l -- レベル番号を出力しない。

*ol tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.ol instanceVars: "reader levels"
		+ " body? levelIndent? header? pick skipAnnex? outlineMark? level?"
**Cmd.ol >> putBlock
	reader level ->:l, <> 0 ifTrue:
		[reader header ->:h;
		skipAnnex? and: [h first = '['], ifTrue: [reader nextSection!];
		levels size < l
			ifTrue:
				[self assert: levels size + 1 = l;
				levels addLast: 1]
			ifFalse:
				[levels at: l - 1 put: (levels at: l - 1) + 1;
				levels size: l];
		--skip header
		reader getLn];

	pick notNil? and: [pick <> h], ifTrue: [reader nextBlock!];

	h notNil? & header? ifTrue:
		[levelIndent? ifTrue: [Out putSpaces: l * 2];
		outlineMark? ifTrue: [Out put: '*' times: l];
		level? ifTrue: 
			[levels do: [:n Out put: n, put: '.'];
			Out put: ' '];
		Out putLn: h];
		
	body? ifTrue: [reader contentLinesDo: [:s Out putLn: s]];
		
	reader nextBlock
**Cmd.ol >> main: args
	OptionParser new init: "sihp:Sol" ->:op, parse: args ->args;
	op at: 's', not ->body?;
	op at: 'i' ->levelIndent?;
	op at: 'h', not ->header?;
	op at: 'p' ->pick;
	op at: 'S' ->skipAnnex?;
	op at: 'o' ->outlineMark?;
	op at: 'l', not ->level?;
	Array new ->levels;
	
	OutlineReader new init: In ->reader;

	reader level = 0 ifTrue: [self putBlock];
	[reader level <> -1] whileTrue: [self putBlock]
