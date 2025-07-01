english japanese dictionary
$Id: mulk edict.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 英和辞書

*[man]
**#en
.caption SYNOPSIS
	edict KEY
	edict.download -- download dictionary
.caption DESCRIPTION
Search edict and display dictionary entries containing key.

The following dictionary data is used
	https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project
**#ja
.caption 書式
	edict key
	edict.download -- 辞書データをダウンロードする。
.caption 説明
edictを検索しkeyを含む辞書エントリーを表示する。

辞書データは以下のものを使用している。
	https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project

*edict tool.@
	Mulk import: "tempfile";
	Object addSubclass: #Cmd.edict instanceVars: "edict"
**Cmd.edict >> init
	"edict.wk" asWorkFile ->edict
**Cmd.edict >> main: args
	edict none? ifTrue: [self main.download: nil];
	edict pipe: "fgrep '" + args first + '\'' to: Out
**Cmd.edict >> main.download: args
	Out put: "downloading edict...";
	TempFile create ->:f;
	"hr http://ftp.edrdg.org/pub/Nihongo/edict2.gz " + f quotedPath,
		runCmd;
	"gzip.d " + f quotedPath + " | ctr e = >" + edict quotedPath, runCmd;
	f remove;
	Out putLn: "done."
