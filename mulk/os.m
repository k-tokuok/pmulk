execute host OS commands
$Id: mulk os.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ホストOSのコマンドを実行

*[man]
**#en
.caption SYNOPSIS
	os [OPTION] ARG...
	os.path [-s] ARG... -- Add ARG... to the beginning of the PATH environment variable
.caption DESCRIPTION
Execute host OS commands.

Each ARG is interpreted as a quoted command and argument string.

The output of the command is output to the standard output of Mulk in text mode, so you can input it to the Mulk command by redirection.
.caption OPTION
	i -- Input Mulk's standard input to the command. Do not invoke the command until the input reaches EOF.
	o -- Outputs command output to the OS standard output.
	v -- Display processings verbosely.
	s - Set ARG... to PATH.
**#ja
.caption 書式
	os [OPTION] ARG...
	os.path [-s] ARG... -- ARG...をPATH環境変数の先頭に追加する。
.caption 説明
ホストOSのコマンドを実行する。

ARGはそれぞれがquoteされたコマンド及び引数列として解釈される。

コマンドの出力はテキストモードでMulkの標準出力に出力されるので、リダイレクションでMulkのコマンドに入力出来る。
.caption オプション
	i -- Mulkの標準入力をコマンドに入力する。入力がEOFになるまではコマンドを起動しない。
	o -- コマンドの出力をOSの標準出力へ出力する。
	v -- 処理を詳細に表示する。
	s -- PATHをARG...に設定する。
	
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
***Cmd.os >> addSeparater: wr
	wr put: (Mulk.hostOS = #windows ifTrue: [';'] ifFalse: [':'])
***Cmd.os >> main.path: args
	OptionParser new init: "s" ->:op, parse: args ->args;
	StringWriter new ->:wr;
	wr put: "PATH=";
	
	args size timesDo:
		[:i
		i <> 0 ifTrue: [self addSeparater: wr];
		wr put: (args at: i) asFile hostPath];
	op at: 's', ifFalse:
		[self addSeparater: wr;
		wr put: (OS getenv: "PATH")];
	OS putenv: wr asString
