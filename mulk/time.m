measure command execution time
$Id: mulk time.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja コマンドの実行時間を測る
*[man]
**#en
.caption SYNOPSIS
	time COMMAND...
.caption DESCRIPTION
Execute a command and print the time and number of bytecode cycles it took.
**#ja
.caption 書式
	time コマンド...
.caption 説明
コマンドを実行し、かかった時間とバイトコードサイクル数を表示する。

*time tool.@
	Mulk import: "cmdstr";
	Object addSubclass: #Cmd.time
**Cmd.time >> main: args
	OS clock ->:clockStart;
	Kernel cycle ->:cycleStart;
	args asCmdString runCmd;
	Out putLn: "time=" + (OS clock - clockStart) + " cycle="
		+ (Kernel cycle - cycleStart)
