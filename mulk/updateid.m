update of identification information
$Id: mulk updateid.m 1443 2025-06-12 Thu 20:57:44 kt $
#ja 識別情報の更新

*[man]
**#en
.caption SYNOPSIS
	updateid [OPTION] IDFILE
.caption DESCRIPTION
Read the file list from standard input and update the file identification information.

The identification information corresponds to the second line of the module file, and is the section surrounded by '$' starting with '$Id:'.
The current system identifier, file name, revision number, update date and time, and author identifier are embedded here.

The system name, author identifier, and revision number are read from the first line of the IDFILE.
At this time, the revision number is incremented by one and the IDFILE is updated.

The directory containing ".git" is assumed to be the top directory of the system, and the system identifier of files under subdirectories different from the system name is the system name + "/" + subdirectory name, and other files are assumed to be the system name.

.caption OPTION
	k -- Do not update revision number, use current value.
	p -- Target files that have been updated since the last push of git.
	c -- Targets files updated since git's last commit.
**#ja
.caption 書式
	updateid [OPTION] IDFILE
.caption 説明
標準入力からファイルリストを読み込み、ファイルの識別情報を更新する。

識別情報はモジュールファイルの2行目に当たるもので、先頭がId:で始まる$で囲まれた区画である。
ここに現状のシステム識別子、ファイル名、リビジョン番号、更新日時、作者識別子を埋め込む。

システム名称、作者識別子、リビジョン番号はIDFILEの先頭行から順に読み込む。
この時、リビジョン番号は1増やされIDFILEも更新される。

".git"のあるディレクトリをシステムのトップディレクトリとし、システム名称と異なるサブディレクトリ下にあるファイルのシステム識別子はシステム名称+"/"+サブディレクトリ名、それ以外のファイルはシステム名称とする。

.caption オプション
	k -- リビジョン番号を更新せず、現在の値を使用する。
	p -- gitの前回pushから更新されたファイルを対象とする。
	c -- gitの前回commitから更新されたファイルを対象とする。

*updateid tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.updateid
		instanceVars: "buf endPos system root rev date author"
**Cmd.updateid >> match?: pos
	buf size - pos < 5 ifTrue: [false!];
	buf basicAt: pos unmatchIndexWith: "$Id:" at: 0 size: 4, notNil? ifTrue:
		[false!];
	buf indexOf: '$' code from: pos + 1 until: buf size ->endPos, nil? ifTrue:
		[false!];
	endPos + 1 ->endPos;
	buf indexOf: '\n' code from: pos until: endPos, nil?!
**Cmd.updateid >> findIdAfter: pos
	[buf indexOf: '$' code from: pos until: buf size ->pos, nil? ifTrue: [nil!];
	self match?: pos,
		ifTrue: [pos!]
		ifFalse: [pos + 1 ->pos]] loop
**Cmd.updateid >> update: fileArg
	fileArg readableFile? ifFalse: [self!];
	fileArg pathFrom: root ->:rpath;
	system ->:s;
	rpath indexOf: '/' ->:pos, notNil? ifTrue: 
		[rpath copyUntil: pos ->:ss;
		ss <> system ifTrue: [system + '/' + ss ->s]];
	
	fileArg contentBytes ->buf;
	0 ->pos;
	nil ->:wfs;
	[self findIdAfter: pos ->:npos, notNil?] whileTrue:
		[wfs nil? ifTrue:
			[Out putLn: "update: " + fileArg;
			fileArg openWrite ->wfs];
		wfs write: buf from: pos size: npos - pos;
		wfs put: "$Id: ", put: s,
			put: ' ', put: fileArg name,
			put: ' ', put: rev,
			put: ' ', put: date,
			put: ' ', put: author,
			put: " $";
		endPos ->pos];
	wfs notNil? ifTrue:
		[wfs write: buf from: pos size: buf size - pos;
		wfs close]
**Cmd.updateid >> setRoot
	"." asFile ->root;
	[root + ".git", none?] whileTrue:
		[root parent ->root, nil? ifTrue:
			[self error: "git directory not found"]]
**Cmd.updateid >> main: args
	OptionParser new init: "kpc" ->:op, parse: args ->args;
	args first asFile ->:idFile;

	self setRoot;
	In ->:in;
	
	op at: 'p', ifTrue:
		[root ->:home;
		"git diff --name-only origin/master..master" pipe ->in];
	
	op at: 'c', ifTrue:
		[root ->home;
		"git diff --name-only" pipe ->in];
		
	home nil? ifTrue: ["." asFile ->home];
	
	idFile readDo:
		[:rfs
		rfs getLn ->system;
		rfs getLn ->author;
		rfs getLn asInteger ->rev];
	op at: 'k', ifFalse:
		[rev + 1 ->rev;
		idFile writeDo:
			[:wfs
			wfs putLn: system, putLn: author, putLn: rev]];
	Out putLn: "revision: " + rev;
	DateAndTime new initNow ->date;
	in contentLinesDo: [:fn self update: home + fn]
