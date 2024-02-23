background execution
$Id: mulk bg.m 963 2022-10-30 Sun 20:28:43 kt $
#ja バックグラウンド実行

*[man]
**#en
.caption SYNOPSIS
	bg [COMMAND...]
	bg.now COMMAND... -- Execute the command immediately in the background.
	bg.cancelall -- Cancel the entire queue.
	bg.addproc -- Add a process to execute the queue.
.caption DESCRIPTION
Queue commands and execute them one at a time in the background.

If bg is executed without command argument, list of queues will be displayed, 'c' + number will cancel the specified command, 'r' + number will execute it in another process.
Any other input terminates.
.caption LIMITATION
The host OS must be able to execute mulk as a child process in the background, and the PATH environment variable etc. must be set appropriately.

**#ja
.caption 書式
	bg [コマンド...]
	bg.now コマンド... -- コマンドを直ちにバックグラウンドで実行。
	bg.cancelall -- キュー全体をキャンセルする。
	bg.addproc -- キューを実行するプロセスを追加する。
.caption 説明
コマンドをキューに入れ、バックグラウンドで一つずつ実行する。

コマンド引数なしでbgを実行するとキューの一覧を表示し、'c'+番号で指定のコマンドのキャンセル、'r'+番号で別プロセスでの実行を行う。
それ以外の入力で終了する。
.caption 制限事項
ホストOSがmulkを子プロセスとしてバックグラウンドで実行可能で、PATH環境変数等が適切に設定されていなくてはならない。

*bg tool.@
	Mulk import: #("pi" "lock" "tempfile" "prompt" "cmdstr");
	Object addSubclass: #Cmd.bg instanceVars: "queue"
	
**Cmd.bg >> createAction: cmdStr
	Cons new car: "." asFile cdr: cmdStr!
**Cmd.bg >> doAction: action
	[
		action car chdir;
		action cdr ->:s;
		Out putLn: "--cmd: " + s describe + " dir: " + action car;
		s runCmd
	] on: Error do:
		[:e
		Out putLn: "--";
		Out putLn: e message;
		In getLn]
		
**queueing.
***Cmd.bg >> lockDo: block
	"bg.lck" asWorkFile lockDo: block
***Cmd.bg >> queueFile
	"bg.mpi" asWorkFile!
***Cmd.bg >> readQueue
	self queueFile ->:file, none?
		ifTrue: [nil]
		ifFalse: [file readObject] ->queue! 
***Cmd.bg >> writeQueue
	self queueFile writeObject: queue
***Cmd.bg >> dequeue
	self lockDo:
		[nil ->:result;
		self readQueue nil? ifFalse:
			[queue empty?
				ifTrue: [self queueFile remove]
				ifFalse:
					[queue first ->result;
					queue removeFirst;
					self writeQueue]]];
	result!
	
**Cmd.bg >> main.run: args
	[self dequeue ->:action, notNil?] whileTrue: [self doAction: action]
**Cmd.bg >> main.runnow: args
	args first asWorkFile ->:file, readObject ->:action;
	self doAction: action;
	file remove
**Cmd.bg >> startBackground: cmd
	Mulk.hostOS = #windows ifTrue: ["os -o start mulk " + cmd, runCmd!];
	Mulk.hostOS = #macosx ifTrue:
		[[Out put:
			"tell application \"Terminal\"\n"
			+ "\tdo script \"mulk " + cmd + " ; exit\"\n"
			+ "end tell\n"] pipe: "os -i osascript"!];
	Mulk.hostOSUnix? ifTrue: ["os -o xterm -e mulk " + cmd + " &", runCmd!];
	self error: "not supported"
**Cmd.bg >> runActionNow: action
	TempFile create ->:file;
	file writeObject: action;
	self startBackground: "bg.runnow " + file name
**Cmd.bg >> control
	self readQueue nil? ifTrue: [self!];
	queue empty? ifTrue: [self!];
	queue size timesDo: 
		[:i Out put: i, put: ": ", putLn: (queue at: i) cdr];
	Prompt getString: "[c|r]no" ->:ln;
	ln empty? ifTrue: [self!];
	ln first ->:ch, = 'c' | (ch = 'r') ifFalse: [Out putLn: "?"!];
	ln copyFrom: 1, asInteger ->:no;
	ch = 'r' ifTrue: [self runActionNow: (queue at: no)];
	queue removeAt: no;
	self writeQueue
**Cmd.bg >> main: args
	args empty? ifTrue: [self lockDo: [self control]!];
	self lockDo:
		[self readQueue nil? ifTrue:
			[self startBackground: "bg.run";
			Array new ->queue];
		queue addLast: (self createAction: args asCmdString);
		self writeQueue]

**Cmd.bg >> main.now: args
	self runActionNow: (self createAction: args asCmdString)
**Cmd.bg >> main.cancelall: args
	self lockDo:
		[self readQueue notNil? ifTrue:
			[Array new ->queue;
			self writeQueue]]
**Cmd.bg >> main.addproc: args
	self startBackground: "bg.run"
