update the system directory
$Id: mulk update.m 1597 2026-05-09 Sat 20:45:35 kt $
#ja システムディレクトリを更新する

*[man]
**#en
.caption SYNOPSIS
	update
	update.extract SUBDIR [DESTDIR]
.caption DESCRIPTION
Fetch the latest release of pmulk from GitHub and update the files in the system directory (Mulk.systemDirectory).

The extract subcommand extracts the contents of SUBDIR within a ZIP file to DESTDIR.
If DESTDIR is omitted, the directory one level above the system directory is treated as the specified destination.

If you are using the pmulk/windows binary release, running "update.extract mulk" will install the full version.
**#ja
.caption 書式
	update
	update.extract SUBDIR [DESTDIR]
.caption 説明
GitHub上のpmulkの最新リリースを取得し、システムディレクトリ(Mulk.systemDirectory)上のファイルを更新する。

extractサブコマンドはzip内のSUBDIRの内容をDESTDIRに展開する。
DESTDIRを省略するとシステムディレクトリの一つ上のディレクトリが指定されたものと見做す。

pmulk/windowsのバイナリリリースを使用している場合、update.extract mulkでフルセット版となる。
*Cmd.update tool.@
	Mulk import: #("jsonrd" "zip" "csvrd");
	Object addSubclass: #Cmd.update instanceVars: "tag zip zipDict moduleDict"
	
**Cmd.update >> downloadZip
	"hr https://api.github.com/repos/k-tokuok/pmulk/releases/latest"
	pipe:
		[JsonReader new read: In, at: "tag_name" ->tag];
	tag + ".zip", asWorkFile ->:result;
	result none? ifTrue:
		[Out putLn: "download " + result;
		"hr https://github.com/k-tokuok/pmulk/archive/refs/tags/" + tag 
			+ ".zip " + result quotedPath, runCmd;
		result stat];
	result!
**Cmd.update >> readZip: arg
	Zip new initRead: arg ->zip;
	Dictionary new ->zipDict;
	zip sweep: [:entry zipDict at: entry fileName put: entry]
**Cmd.update >> entryAt: arg
	zipDict at: "pmulk-" + (tag copyFrom: 1) + '/' + arg!
**Cmd.update >> moduleList: readerArg do: blockArg
	CsvReader new ->:csvrd;
	[readerArg getLn ->:ln, notNil?] whileTrue:
		[ln head?: ';', ifFalse:
			[csvrd parseRecord: ln ->:ar;
			blockArg value: ar first value: (ar at: 1) asInteger]]
**Cmd.update >> extract: fn
	MemoryStream new ->:result;
	zip extract: (self entryAt: fn) to: result;
	result seek: 0;
	result!
**Cmd.update >> makeModuleDict
	Dictionary new ->:result;
	self moduleList: (self extract: "mulk/package.d") 
		do: [:mn :rev result at: mn put: rev];
	result!
**Cmd.update >> systemFile: arg
	Mulk.systemDirectory + arg!
**Cmd.update >> removeUnextractEntry
	self systemFile: "package.d" ->:f, readableFile? ifFalse: [self!];
	f readDo:
		[:fs
		self moduleList: fs do:
			[:mn :rev
			moduleDict includesKey?: mn,
				and: [self systemFile: mn, readableFile?],
				and: [rev >= (moduleDict at: mn)],
				ifTrue: [moduleDict removeAt: mn]]]
**Cmd.update >> binary?: fileArg
	#("dotx" "jar" "ptt" "png" "dll") includes?: fileArg suffix!
**Cmd.update >> extract: fnArg to: fileArg
	Out putLn: "extract " + fnArg;
	self extract: fnArg ->:str;
	self binary?: fileArg,
		ifTrue: [str pipeTo: fileArg]
		ifFalse: [str pipe: "ctr ul =" to: fileArg]
**Cmd.update >> main: args
	self readZip: self downloadZip;
	self makeModuleDict ->moduleDict;
	self removeUnextractEntry;
	moduleDict keys do:
		[:mn self extract: "mulk/" + mn to: (self systemFile: mn)];
	zip close

**extract.
***Cmd.update >> zipKeysDo: blockArg
	zipDict keys do:
		[:en
		en copyFrom: (en indexOf: '/', + 1) ->en, empty? not,
			and: [en last <> '/'],
			ifTrue: [blockArg value: en]]
***Cmd.update >> main.extract: args
	self readZip: self downloadZip;
	args first + '/' ->:subdir;
	args size >= 2 
		ifTrue: [args at: 1, asFile] ifFalse: [Mulk.systemDirectory + ".."]
		->:destDir;
	self zipKeysDo:
		[:n
		n heads?: subdir, ifTrue: [self extract: n to: destDir + n]];
	zip close
