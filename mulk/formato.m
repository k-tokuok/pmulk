text formatting (common components for various office suites)
$Id: mulk formato.m 1615 2026-06-18 Thu 21:19:44 kt $
#ja テキスト整形 (各種office suite向け共通部)

*[man]
**#en
.caption DESCRIPTION
A utility class for formatting text by controlling office suite via Python.
**#ja
.caption 説明
Pythonを通じてオフィススイートを制御し、テキストの書式設定を行うためのユーティリティクラス。

*import.@
	Mulk import: #("format" "optparse")

*Format.Office class.@
	Format addSubclass: #Format.Office instanceVars: 
		"index? templateFile docFile"
**Format.Office >> init
	super init;
	false ->index?
**Format.Office >> command.index: args
	true ->index?;
	self changeMode: #index;
	Out putLn: "insertIndex()"
**Format.Office >> putString: buf
	Out put: '"';
	buf do:
		[:ch
		ch = '\\' | (ch = '"') ifTrue: [Out put: '\\'];
		Out put: ch];
	Out put: '"'
**Format.Office >> write: buf topMargin: tm restMargin: rm
	Out put: "insertText(";
	self putString: buf;
	Out put: ',', put: tm + leftMargin, put: ',', put: rm + leftMargin, 
		putLn: ')'
**Format.Office >> writeOutline: s level: l
	Out put: "insertOutline(";
	self putString: (WideCharArray new addString: s);
	Out put: ',', put: l, putLn: ')'
**Format.Office >> writeRightAlign: buf
	Out put: "insertRightAlign(";
	self putString: buf;
	Out putLn: ')'
**Format.Office >> writeCenterAlign: buf
	Out put: "insertCenterAlign(";
	self putString: buf;
	Out putLn: ')'
**Format.Office >> writeLineBreak
	Out putLn: "insertLineBreak()"
**Format.Office >> writePageBreak
	Out putLn: "insertPageBreak()"
**Format.Office >> main: args
	OptionParser new init: "t:" ->:op, parse: args ->args;
	op at: 't' ->:opt, notNil? ifTrue: [opt asFile ->templateFile];
	args empty? ifFalse: [args first asFile ->docFile]
**Format.Office >> main.debug: args
	self makeScript
