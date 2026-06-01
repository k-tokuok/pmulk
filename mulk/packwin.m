create Mulk/Windows binary package
$Id: mulk packwin.m 1607 2026-05-29 Fri 20:03:21 kt $
#ja Mulk/Windowsバイナリパッケージを作成する

*[man]
**#en
.caption SYNOPSIS
	packwin [OPTION] ZIP
.caption DESCRIPTION
Create a Mulk binary package for Windows and compress it in ZIP format.

.caption OPTION
	l LANG -- Language specification (en|ja). If omitted, Mulk.lang is assumed to be specified.
	c CHARSET -- Character code (utf8|sjis). If omitted, it is selected appropriately according to the language specification.
	C -- Create new mulk.exe and base.mi. On Windows, you need Visual C++; on Unix, you need Wine and a Mingw-based toolchain.
.caption SEE ALSO
.summary package
**#ja
.caption 書式
	packwin [OPTION] ZIP
.caption 説明
Windows向けMulkバイナリパッケージを作り、ZIP形式で圧縮する。

.caption オプション
	l LANG -- 言語指定(en|ja)。省略時はMulk.langが指定されたものとする。
	c CHARSET -- 文字コード(utf8|sjis)。省略時は言語指定によって適切に選ばれる。
	C -- mulk.exeとbase.miを新規に作成する。WindowsではVisual-C++を、Unixではwineとmingwベースのツールチェインが必要。
.caption 関連項目
.summary package

*packwin tool.@
	Mulk import: #("optparse" "tempfile");
	Object addSubclass: #Cmd.packwin instanceVars: 
		"lang charset ctrdst baseDir compileDir"

**->Cmd.packwin.install.bat
cd /d "%~dp0"
install\mulk -i install/mulk0.mi "Mulk load: \"install/install.m\""

**->Cmd.packwin.install.m
installer for Windows binary kit.

***installer.@
	Object addSubclass: #Installer 
****Installer >> readString: arArg
	StringWriter new ->:wr;
	[arArg getByte ->:b, <> 0] whileTrue: 
		[b = -1 ifTrue: [nil!];
		wr putByte: b];
	wr asString!
****Installer >> extract
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
****Installer >> make_mulk_mi
	Out putLn: "\"mulk\" asFile ->Mulk.systemDirectory;",
		putLn: "\"work\" asFile ->Mulk.workDirectory;",
		putLn: "Mulk import: \"icmd\";",
		putLn: "#Cmd.icmd ->Mulk.defaultMainClass;",
		putLn: "Mulk save: \"bin/mulk.mi\""
****Installer >> make_icmd_mc
	Out putLn: "set.home",
		putLn: "os.path -s " + "dll" asFile quotedPath,
		putLn: "ld -s h.m",
		putLn: "ld -s clipw.m"
****Installer >> make_mulkv_mc
	Out putLn: "cmd " + "work/icmd.mc" asFile quotedPath,
		putLn: "cd ~",
		putLn: "cset view";
	Mulk.lang = "ja" ifTrue: [Out putLn: "skk"];
	Out putLn: "hidecnsl",
		putLn: "icmd.next wb"
****Installer >> make_mulkv_bat
	Out putLn: "start \"\" " + "bin/mulk.exe" asFile quotedHostPath 
		+ " -- -s " + "work/mulkv.mc" asFile quotedPath
****Installer >> customFile: fileArg
	fileArg readableFile? ifTrue:
		[fileArg + ".." + (fileArg name + ".new") ->fileArg];
	fileArg!
****Installer >> start
	self extract;
	"mulk" asFile ->Mulk.systemDirectory;
	"work" asFile ->Mulk.workDirectory;
	Mulk import: "cmd";
	"mkdir bin" runCmd;
	"mkdir work" runCmd;
	"cp install/mulk.exe bin" runCmd;
	[self make_mulk_mi] pipe: "os -i install\\mulk -i install/mulk0.mi";
	[self make_icmd_mc] pipeTo: (self customFile: "work/icmd.mc" asFile);
	[self make_mulkv_mc] pipeTo: (self customFile: "work/mulkv.mc" asFile);
	[self make_mulkv_bat] pipeTo: (self customFile: "bin/mulkv.bat" asFile)
	
***@
Installer new start

**->Cmd.packwin.dllsetup.bat
rem dllsetup [/a] -- download dll from github, /a to download all
cd /d "%~dp0"
mkdir ..\dll
set url=https://raw.githubusercontent.com/k-tokuok/pmulk/master/dll
curl -o ../dll/zlib1.dll %url%/zlib1.dll
if "%1"=="/a" for %%i in (libbz2.dll libjpeg-9.dll libpng16.dll readme.txt sqlite3.dll) do curl -o ..\dll\%%i %url%/%%i

**Cmd.packwin >> make_mulk_ar: destArg
	TempFile create ->:dir, mkdir quotedPath ->:qdir;
	"pw" ->:expr;
	lang = "en" ifTrue: [expr + "-ja" ->expr];
	
	"package " + expr + '#' + lang + '@' + ctrdst + ' ' + qdir, runCmd;
	"ar.c " + qdir, pipeTo: destArg;
	"rm " + qdir, runCmd
**Cmd.packwin >> make_mulk_exe
	TempFile create mkdir ->compileDir ->baseDir, chdirDo:
		["package vm+pws@" + ctrdst + " .", runCmd;
		"os -o " 
			+ (Mulk.hostOS = #windows 
				ifTrue: ["nmake /fvc.mak"] 
				ifFalse: ["make hostos=windows cross=wine"])
			+ " mulk.exe base.mi", runCmd]
**Cmd.packwin >> make_mulk0_mi
	baseDir chdirDo:
		["os -io" ->:cmd;
		Mulk.hostOS <> #windows ifTrue: [cmd + " wine" ->cmd];
		cmd + " mulk -i base.mi" ->cmd;
		[Out putLn: "Mulk import: #(\"crlf\" \"optparse\" \"pipe\");";
		charset = "sjis" ifTrue: [Out putLn: "Mulk import: \"cp932\";"];
		Out put: '"', put: lang, putLn: "\" ->Mulk.lang;";
		Out putLn: "nil ->Mulk.systemDirectory ->Mulk.workDirectory;";
		Out putLn: "Mulk save: \"1.wk\""] pipe: cmd];
	baseDir + "1.wk"!
**Cmd.packwin >> main: args
	OptionParser new init: "l:c:C" ->:op, parse: args ->args;
	op at: 'l' ->:opt, nil? ifTrue: [Mulk.lang] ifFalse: [opt] ->lang;
	op at: 'c' ->opt, nil?
		ifTrue: [lang = "ja" ifTrue: ["sjis"] ifFalse: ["utf8"]]
		ifFalse: [opt] ->charset;
		
	Mulk.systemDirectory ->baseDir;
	charset = "sjis" ifTrue: ["s"] ifFalse: ["u"] ->ctrdst;
	ctrdst + "c" ->ctrdst;
	
	TempFile create ->:topDir;
	[Out put: Cmd.packwin.install.bat] pipe: "ctr = " + ctrdst, 
		pipeTo: topDir + "install.bat";
	[Out put: Cmd.packwin.install.m] pipe: "ctr = " + ctrdst,
		pipeTo: topDir + "install/install.m";
	[Out put: Cmd.packwin.dllsetup.bat] pipe: "ctr = " + ctrdst,
		pipeTo: topDir + "install/dllsetup.bat";
	self make_mulk_ar: topDir + "install/mulk.ar";
	op at: 'C', ifTrue: [self make_mulk_exe];
	baseDir + "mulk.exe" pipeTo: topDir + "install/mulk.exe";
	self make_mulk0_mi pipeTo: topDir + "install/mulk0.mi";

	"zip.c " + args first + ' ' + topDir quotedPath, runCmd;
	"rm " + topDir quotedPath, runCmd;
	compileDir notNil? ifTrue: ["rm " + compileDir quotedPath, runCmd]
	
