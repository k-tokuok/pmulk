create Mulk/Windows binary package
$Id: mulk packwin.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja Mulk/Windowsバイナリパッケージを作成する

*[man]
**#en
.caption SYNOPSIS
	packwin [OPTION] [EXPR] ZIP
.caption DESCRIPTION
Create a Mulk binary package for Windows and compress it in ZIP format.

Since it includes the execution module and the boot image, it can be installed as is even in an environment without a C compiler.
If EXPR is omitted, a package is created with the minimum configuration of std.
.caption OPTION
	l LANG -- Language specification (en|ja). If omitted, Mulk.lang is assumed to be specified.
	d DLLDIR -- Include the DLLs at DLLDIR in the package. You can also specify one file.
	b BASEDIR -- The directory where mulk.exe and base.mi are located. If omitted, Mulk.systemDirectory is assumed to be specified.
	i INPUTMETHOD -- Specifies the input method (jim|skk) to include.
	c CHARSET -- Character code (utf8|sjis). If omitted, it is selected appropriately according to the language specification.
	C -- Create a new cross compiled version of mulk.exe and base.mi.
.caption SEE ALSO
.summary package
**#ja
.caption 書式
	packwin [OPTION] [EXPR] ZIP
.caption 説明
Windows向けMulkバイナリパッケージを作り、ZIP形式で圧縮する。

実行モジュールと起動イメージを含むため、Cコンパイラのない環境でもそのままインストールできる。
EXPRを省略するとstdの最小構成でパッケージが作られる。
.caption オプション
	l LANG -- 言語指定(en|ja)。省略時はMulk.langが指定されたものとする。
	d DLLDIR -- パッケージにDLLDIRにあるDLLを含める。一つであればファイルを指定することもできる。
	b BASEDIR -- コピー元のmulk.exeとbase.miのあるディレクトリ。省略時はMulk.systemDirectoryが指定されたものとする。
	i INPUTMETHOD -- 組込むインプットメソッド(jim|skk)を指定する。
	c CHARSET -- 文字コード(utf8|sjis)。省略時は言語指定によって適切に選ばれる。
	C -- mulk.exeとbase.miをクロスコンパイルで新規に作成する。
.caption 関連項目
.summary package

*packwin tool.@
	Mulk import: #("optparse" "tempfile");
	Object addSubclass: #Cmd.packwin instanceVars: 
		"lang dll inputMethod charset ctrdst"
**Cmd.packwin >> make_install_bat
	Out putLn: "cd /d \"%~dp0\"",
		putLn: "install\\mulk -i install/base.mi"
			+ " \"Mulk load: \\\"install/install.m\\\"\""
**Cmd.packwin >> make_install_m
	Out putLn: (Mulk at: #Cmd.packwin.installer);
	Out putLn: "*@";
	Out putLn: "Installer new ->:installer;";
	Out putLn: "installer charset: \"" + charset + "\";";
	Out putLn: "installer lang: \"" + lang + "\";";
	dll notNil? ifTrue: [Out putLn: "installer dll;"];
	inputMethod notNil? ifTrue: 
		[Out putLn: "installer inputMethod: \"" + inputMethod + "\";"];
	Out putLn: "installer start"
**Cmd.packwin >> make_mulk_ar: exprArg to: destArg
	TempFile create quotedPath ->:qdir;
	"package " + exprArg + ' ' + qdir, runCmd;
	"ar.c " + qdir, pipeTo: destArg;
	"rm " + qdir, runCmd
**Cmd.packwin >> main: args
	OptionParser new init: "l:d:b:i:c:C" ->:op, parse: args ->args;
	op at: 'l' ->:opt, nil? ifTrue: [Mulk.lang] ifFalse: [opt] ->lang;
	op at: 'd' ->dll;
	op at: 'b' ->opt, nil? 
		ifTrue: [Mulk.systemDirectory] 
		ifFalse: [opt asFile] ->:baseDir;
	op at: 'i' ->inputMethod;
	op at: 'c' ->opt, nil?
		ifTrue: [lang = "ja" ifTrue: ["sjis"] ifFalse: ["utf8"]]
		ifFalse: [opt] ->charset;
	charset = "sjis" ifTrue: ["s"] ifFalse: ["u"] ->ctrdst;
	ctrdst + "c" ->ctrdst;
	
	op at: 'C' ->:cross?, ifTrue:
		[TempFile create mkdir ->:crossDir;
		"package vm " + crossDir quotedPath, runCmd;
		"base.m" asSystemFile pipeTo: crossDir + "base.m";
		"os -o sh -c 'cd " + crossDir quotedPath + " ; make hostos=windows cross=wine mulk.exe base.mi'" ->:s;
		Out putLn: s;
		s runCmd;
		crossDir ->baseDir];
		
	args size = 1 
		ifTrue: 
			["std" ->:expr;
			inputMethod notNil? ifTrue: [expr + '+' + inputMethod ->expr];
			expr + "-vm-npw" ->expr;
			lang = "en" ifTrue: [expr + "-ja" ->expr];
			expr + '#' + lang ->expr;
			expr + '@' + ctrdst ->expr;
			args first ->:dest]
		ifFalse:
			[args first ->expr;
			args at: 1 ->dest];

	TempFile create ->:topDir;
	[self make_install_bat] pipe: "ctr = " + ctrdst, 
		pipeTo: topDir + "install.bat";
	[self make_install_m] pipe: "ctr = " + ctrdst,
		pipeTo: topDir + "install/install.m";
	baseDir + "mulk.exe" pipeTo: topDir + "install/mulk.exe";
	baseDir + "base.mi" pipeTo: topDir + "install/base.mi";
	self make_mulk_ar: expr to: topDir + "install/mulk.ar";
	dll notNil? ifTrue:
		[topDir + "dll" ->:dllDestDir;
		dll asFile ->:dllFile, file? ifTrue: [dllDestDir mkdir];
		"cp " + dllFile quotedPath + ' ' + dllDestDir quotedPath, runCmd];
	"zip.c " + dest + ' ' + topDir quotedPath, runCmd;
	"rm " + topDir quotedPath, runCmd;
	cross? ifTrue: ["rm " + crossDir quotedPath, runCmd]
*->Cmd.packwin.installer
installer for Windows binary kit.

**installer.@
	Object addSubclass: #Installer instanceVars: 
		"lang charset dll? inputMethod"
***Installer >> init
	false ->dll?
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
		putLn: "nil ->File.home;",
		putLn: "Mulk at: #charset put: #" + charset + ";",
		putLn: "\"" + lang + "\" ->Mulk.lang;",
		putLn: "Mulk import: #(\"crlf\" \"icmd\");";
	charset = "sjis" ifTrue: [Out putLn: "Mulk import: \"cp932\";"];
	Out	putLn: "#Cmd.icmd ->Mulk.defaultMainClass;",
		putLn: "Mulk save: \"bin/mulk.mi\""
***Installer >> make_icmd_mc
	dll? ifTrue: [Out putLn: "os.path " + "dll" asFile quotedPath];
	Out putLn: "ld -s h.m",
		putLn: "ld -s clipw.m"
***Installer >> make_mulkv_mc
	Out putLn: "cmd " + "work/icmd.mc" asFile quotedPath,
		putLn: "cset view";
	inputMethod notNil? ifTrue: [Out putLn: inputMethod];
	Out putLn: "hidecnsl",
		putLn: "icmd.next wb"
***Installer >> make_mulkv_bat
	Out putLn: "start \"\" " + "bin/mulk.exe" asFile quotedHostPath 
		+ " -- -s " + "work/mulkv.mc" asFile quotedPath
***Installer >> lang: langArg
	langArg ->lang
***Installer >> charset: charsetArg
	charsetArg ->charset
***Installer >> inputMethod: inputMethodArg
	inputMethodArg ->inputMethod
***Installer >> dll
	true ->dll?
***Installer >> customFile: fileArg
	fileArg readableFile? ifTrue:
		[fileArg + ".." + (fileArg name + ".new") ->fileArg];
	fileArg!
***Installer >> start
	self extract;
	"mulk" asFile ->Mulk.systemDirectory;
	"work" asFile ->Mulk.workDirectory;
	Mulk import: #("crlf" "cmd");
	"bin" asFile mkdir;
	"work" asFile mkdir;
	"cp install/mulk.exe bin" runCmd;
	[self make_mulk_mi] pipe: "os -i install\\mulk -i install/base.mi";
	[self make_icmd_mc] pipeTo: (self customFile: "work/icmd.mc" asFile);
	[self make_mulkv_mc] pipeTo: (self customFile: "work/mulkv.mc" asFile);
	[self make_mulkv_bat] pipeTo: (self customFile: "bin/mulkv.bat" asFile)
