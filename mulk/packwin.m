create Mulk/Windows binary package
$Id: mulk packwin.m 1597 2026-05-09 Sat 20:45:35 kt $
#ja Mulk/Windowsバイナリパッケージを作成する

*[man]
**#en
.caption SYNOPSIS
	packwin [OPTION] ZIP
.caption DESCRIPTION
Create a Mulk binary package for Windows and compress it in ZIP format.

.caption OPTION
	l LANG -- Language specification (en|ja). If omitted, Mulk.lang is assumed to be specified.
	b BASEDIR -- The directory where mulk.exe and base.mi are located. If omitted, Mulk.systemDirectory is assumed to be specified.
	c CHARSET -- Character code (utf8|sjis). If omitted, it is selected appropriately according to the language specification.
	C -- Create a new cross compiled version of mulk.exe and base.mi.
.caption SEE ALSO
.summary package
**#ja
.caption 書式
	packwin [OPTION] ZIP
.caption 説明
Windows向けMulkバイナリパッケージを作り、ZIP形式で圧縮する。

.caption オプション
	l LANG -- 言語指定(en|ja)。省略時はMulk.langが指定されたものとする。
	b BASEDIR -- コピー元のmulk.exeとbase.miのあるディレクトリ。省略時はMulk.systemDirectoryが指定されたものとする。
	c CHARSET -- 文字コード(utf8|sjis)。省略時は言語指定によって適切に選ばれる。
	C -- mulk.exeとbase.miをクロスコンパイルで新規に作成する。
.caption 関連項目
.summary package

*packwin tool.@
	Mulk import: #("optparse" "tempfile");
	Object addSubclass: #Cmd.packwin instanceVars: 
		"lang charset ctrdst baseDir cross?"
**Cmd.packwin >> make_install_bat
	Out putLn: "cd /d \"%~dp0\"",
		putLn: "install\\mulk -i install/mulk0.mi"
			+ " \"Mulk load: \\\"install/install.m\\\"\""
**Cmd.packwin >> make_install_m
	Out putLn: (Mulk at: #Cmd.packwin.installer);
	Out putLn: "*@";
	Out putLn: "Installer new start"
**Cmd.packwin >> make_manual: topic to: dirArg
	"man -ml" + lang + ' ' + topic + " | ctr = " + ctrdst 
		pipeTo: dirArg + (topic + ".mm")
**Cmd.packwin >> make_mulk_ar: exprArg to: destArg
	TempFile create ->:dir, mkdir quotedPath ->:qdir;
	"package " + exprArg + ' ' + qdir, runCmd;
	self make_manual: "cmd" to: dir;
	self make_manual: "icmd" to: dir;
	"ar.c " + qdir, pipeTo: destArg;
	"rm " + qdir, runCmd
**Cmd.packwin >> make_mulk0_mi: destArg
	"." asFile ->:save;
	baseDir chdir;
	"os -i" ->:cmd;
	cross? ifTrue: [cmd + " wine" ->cmd];
	cmd + " mulk -i base.mi" ->cmd;
	[Out putLn: "Mulk import: #(\"crlf\" \"icmd\");";
	charset = "sjis" ifTrue: [Out putLn: "Mulk import: \"cp932\";"];
	Out put: '"', put: lang, putLn: "\" ->Mulk.lang;";
	Out putLn: "nil ->Mulk.systemDirectory ->Mulk.workDirectory;";
	Out putLn: "Mulk save: \"mulk0.mi\""] pipe: cmd;
	save chdir;
	baseDir + "mulk0.mi" pipeTo: destArg
**Cmd.packwin >> main: args
	OptionParser new init: "l:b:c:C" ->:op, parse: args ->args;
	op at: 'l' ->:opt, nil? ifTrue: [Mulk.lang] ifFalse: [opt] ->lang;
	op at: 'b' ->opt, nil? 
		ifTrue: [Mulk.systemDirectory] 
		ifFalse: [opt asFile] ->baseDir;
	op at: 'c' ->opt, nil?
		ifTrue: [lang = "ja" ifTrue: ["sjis"] ifFalse: ["utf8"]]
		ifFalse: [opt] ->charset;
	charset = "sjis" ifTrue: ["s"] ifFalse: ["u"] ->ctrdst;
	ctrdst + "c" ->ctrdst;
	
	op at: 'C' ->cross?, ifTrue:
		[TempFile create mkdir ->:crossDir;
		"package vm " + crossDir quotedPath, runCmd;
		#("base.m" "crlf.m" "cp932.m" "pipe.m" "optparse.m" "cmd.m" "icmd.m")
			do: [:m m asSystemFile pipeTo: crossDir + m];
		"os -o sh -c 'cd " + crossDir quotedPath + " ; "
			+ "make hostos=windows cross=wine mulk.exe base.mi'" ->:s;
		Out putLn: s;
		s runCmd;
		crossDir ->baseDir];
		
	"pw" ->:expr;
	lang = "en" ifTrue: [expr + "-ja" ->expr];
	expr + '#' + lang + '@' + ctrdst ->expr;
	args first ->:dest;

	TempFile create ->:topDir;
	[self make_install_bat] pipe: "ctr = " + ctrdst, 
		pipeTo: topDir + "install.bat";
	[self make_install_m] pipe: "ctr = " + ctrdst,
		pipeTo: topDir + "install/install.m";
	baseDir + "mulk.exe" pipeTo: topDir + "install/mulk.exe";
	self make_mulk0_mi: topDir + "install/mulk0.mi";
	self make_mulk_ar: expr to: topDir + "install/mulk.ar";
	Mulk.systemDirectory + "../dll/zlib1.dll" pipeTo: topDir + "dll/zlib1.dll";

	"zip.c " + dest + ' ' + topDir quotedPath, runCmd;
	"rm " + topDir quotedPath, runCmd;
	cross? ifTrue: ["rm " + crossDir quotedPath, runCmd]
	
*->Cmd.packwin.installer
installer for Windows binary kit.

**installer.@
	Object addSubclass: #Installer 
***Installer >> readString: arArg
	StringWriter new ->:wr;
	[arArg getByte ->:b, <> 0] whileTrue: 
		[b = -1 ifTrue: [nil!];
		wr putByte: b];
	wr asString!
***Installer >> extract
	"install/mulk.ar" asFile ->:arFile;
	"mulk" asFile ->:dest;
	dest directory? ifTrue: [dest decendantFiles do: [:f f remove]];
	arFile readDo:
		[:ar
		[self readString: ar ->:fn, notNil?] whileTrue:
			[self readString: ar, asInteger ->:sz;
			FixedByteArray basicNew: sz ->:bytes;
			ar read: bytes;
			dest + fn writeDo: [:wr wr write: bytes]]]
***Installer >> make_mulk_mi
	Out putLn: "\"mulk\" asFile ->Mulk.systemDirectory;",
		putLn: "\"work\" asFile ->Mulk.workDirectory;",
		putLn: "#Cmd.icmd ->Mulk.defaultMainClass;",
		putLn: "Mulk save: \"bin/mulk.mi\""
***Installer >> make_icmd_mc
	Out putLn: "os.path -s " + "dll" asFile quotedPath,
		putLn: "ld -s h.m",
		putLn: "ld -s clipw.m"
***Installer >> make_mulkv_mc
	Out putLn: "cmd " + "work/icmd.mc" asFile quotedPath,
		putLn: "cset view";
	Mulk.lang = "ja" ifTrue: [Out putLn: "skk"];
	Out putLn: "hidecnsl",
		putLn: "icmd.next wb"
***Installer >> make_mulkv_bat
	Out putLn: "start \"\" " + "bin/mulk.exe" asFile quotedHostPath 
		+ " -- -s " + "work/mulkv.mc" asFile quotedPath
***Installer >> customFile: fileArg
	fileArg readableFile? ifTrue:
		[fileArg + ".." + (fileArg name + ".new") ->fileArg];
	fileArg!
***Installer >> start
	self extract;
	"mulk" asFile ->Mulk.systemDirectory;
	"work" asFile ->Mulk.workDirectory;
	"bin" asFile mkdir;
	"work" asFile mkdir;
	"cp install/mulk.exe bin" runCmd;
	[self make_mulk_mi] pipe: "os -i install\\mulk -i install/mulk0.mi";
	[self make_icmd_mc] pipeTo: (self customFile: "work/icmd.mc" asFile);
	[self make_mulkv_mc] pipeTo: (self customFile: "work/mulkv.mc" asFile);
	[self make_mulkv_bat] pipeTo: (self customFile: "bin/mulkv.bat" asFile)
