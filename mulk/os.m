execute host OS commands
$Id: mulk os.m 1468 2025-08-19 Tue 20:52:07 kt $
#ja ホストOSのコマンドを実行

*[man]
**#en
.caption SYNOPSIS
	os [OPTION] ARG...
	os.path [OPTION] [ARG...] -- ARG... to the beginning of the PATH environment variable.
	os.which ARG -- Search the PATH column for the file indicated by the ARG and display the full path.
.caption DESCRIPTION
Execute host OS commands.

Each ARG is interpreted as a quoted command and argument string.

The output of the command is output to the standard output of Mulk in text mode, so you can input it to the Mulk command by redirection.
.caption OPTION
	i -- Input Mulk's standard input to the command. Do not invoke the command until the input reaches EOF
	o -- Outputs command output to the OS standard output
	v -- Display processings verbosely
	c -- Set PATH to ARG... only (os.path)
	r -- Exclude the specified ARG from PATH (os.path)
	l -- Display a list of PATH (os.path).
**#ja
.caption 書式
	os [OPTION] ARG...
	os.path [OPTION] [ARG...] -- ARG...をPATH環境変数の先頭に追加する。引数省略時はPATHの一覧を表示する。
	os.which ARG -- PATH列からARGで示されたファイルを検索し、フルパスを表示する。
.caption 説明
ホストOSのコマンドを実行する。

ARGはそれぞれがquoteされたコマンド及び引数列として解釈される。

コマンドの出力はテキストモードでMulkの標準出力に出力されるので、リダイレクションでMulkのコマンドに入力出来る。
.caption オプション
	i -- Mulkの標準入力をコマンドに入力する。入力がEOFになるまではコマンドを起動しない
	o -- コマンドの出力をOSの標準出力へ出力する
	v -- 処理を詳細に表示する
	c -- PATHをARG...のみに設定する (os.path)
	r -- 指定されたARGをPATHから除く (os.path)
	l -- PATHの一覧を表示する (os.path)
	
*os tool.@
	Mulk addGlobalVar: #Cmd.os.verbose?, set: false;
	Mulk import: #("optparse" "tempfile");
	Object addSubclass: #Cmd.os
	
**Mulk.hostOS = #windows >
***Cmd.os >> makeSystemStr: args inFile: inFile outFile: outFile
	StringWriter new ->:wr;
	wr put: "cmd /c \"";
	args 
		do:
			[:arg
			arg includes?: ' ' ->:quote?, ifTrue: [wr put: '"'];
			StringReader new init: arg ->:rd;
			[rd getWideChar ->:ch, notNil?] whileTrue:
				[ch = '&' | (ch = '|') | (ch = '<') | (ch = '>') | (ch = '^')
						| (ch = '%')
					ifTrue: [wr put: '^'];
				ch = '"' ifTrue: [self error: "can not use \""];
				wr put: ch];
			quote? ifTrue: [wr put: '"']] 
		separatedBy: [wr put: ' '];
	inFile notNil? ifTrue: [wr put: " <" + inFile quotedHostPath];
	outFile notNil? ifTrue: [wr put: " >" + outFile quotedHostPath + " 2>&1"];
	wr put: '"';
	wr asString!
**Mulk.hostOS = #dos >
***Cmd.os >> makeSystemStr: args inFile: inFile outFile: outFile
	StringWriter new ->:wr;
	args do: [:arg wr put: arg] separatedBy: [wr put: ' '];
	inFile notNil? ifTrue: [wr put: " <" + inFile hostPath];
	outFile notNil? ifTrue: [wr put: " >" + outFile hostPath];
	wr asString!
**Mulk.hostOSUnix? >
***Cmd.os >> makeSystemStr: args inFile: inFile outFile: outFile
	StringWriter new ->:wr;
	args 
		do:
			[:arg
			StringReader new init: arg ->:rd;
			true ->:first?;
			[rd getWideChar ->:ch, notNil?] whileTrue:
				[" \"#$&'()@[]^\\<>?;`{}|" includes?: ch,
					and: [ch = '&' & first?, not],
					ifTrue: [wr put: '\\'];
				wr put: ch;
				false ->first?]] 
		separatedBy: [wr put: ' '];
	inFile notNil? ifTrue: [wr put: " <" + inFile quotedPath];
	outFile notNil? ifTrue: [wr put: " >" + outFile quotedPath + " 2>&1"];
	wr asString!
	
**Cmd.os >> main: args
	OptionParser new init: "iov" ->:op, parse: args ->args;
	op at: 'i', ifTrue: [In pipe: "cat" to: (TempFile create ->:inFile)];
	op at: 'o', ifFalse: [TempFile create ->:outFile];
	Cmd.os.verbose? | (op at: 'v') ->:verbose?;
	
	self makeSystemStr: args inFile: inFile outFile: outFile ->:sysstr;
	verbose? ifTrue: [Out0 putLn: "OS system: " + sysstr];
	OS system: sysstr ->:st;
	verbose? ifTrue: [Out0 putLn: "status: " + st];

	inFile notNil? ifTrue: [inFile remove];
	outFile notNil? ifTrue:
		[outFile pipe: "cat" to: Out;
		outFile remove]

**path
***Cmd.os >> pathSeparator
	Mulk.hostOSUnix? ifTrue: [':'] ifFalse: [';']!
***Cmd.os >> value: fnArg on: blockArg
	fnArg empty? ifTrue: [self!];
	blockArg value: (OS fileFromHostPath: fnArg)
***Cmd.os >> paths
	self pathSeparator ->:sepr;
	Iterator new init:
		[:b
		OS getenv: "PATH" ->:path, nil? ifTrue: ["" ->path];
		[path indexOf: sepr ->:pos, notNil?] whileTrue:
			[self value: (path copyUntil: pos) on: b;
			path copyFrom: pos + 1 ->path];
		self value: path on: b]!
***Cmd.os >> main.path: args
	OptionParser new init: "crl" ->:op, parse: args ->args;
	self paths asArray ->:paths;
	op at: 'c', ifTrue: [Array new ->paths];
	args collectAsArray: [:p p asFile] ->args;
	args do: [:p2 paths indexOf: p2 ->:i, notNil? ifTrue: [paths removeAt: i]];
	op at: 'r', ifFalse: [args reverse do: [:p3 paths addFirst: p3]];
	op at: 'l', ifTrue: [paths do: [:p4 Out putLn: p4 path]];
	StringWriter new ->:wr;
	wr put: "PATH=";
	paths do:
		[:p5 wr put: p5 hostPath] separatedBy: [wr put: self pathSeparator];
	OS putenv: wr asString
***Cmd.os >> main.which: args
	args first ->:fn;
	Mulk.hostOSUnix? ifFalse:
		[fn asFile ->:f, readableFile? ifTrue: [Out putLn: f path!]];
	self paths do:
		[:path
		path + fn ->f, readableFile? ifTrue: [Out putLn: f path!]]
