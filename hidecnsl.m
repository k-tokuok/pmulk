hide console
$Id: mulk hidecnsl.m 1179 2024-03-17 Sun 21:14:15 kt $
#ja コンソールを非表示とする

*[man]
**#en
.caption SYNOPSIS
	hidecnsl
.caption DESCRIPTION
Hide the console of mulk process.

Get the window handle of the console and hide it.
The console itself remains unopened, so no new console is allocated even if a child process is executed.
.caption LIMITATION
Can only work on Windows.
.caption SEE ALSO
https://learn.microsoft.com/ja-jp/troubleshoot/windows-server/performance/obtain-console-window-handle

**#ja
.caption 書式
	hidecnsl
.caption 説明
mulkプロセスのコンソールを非表示とする。

コンソールのwindow handleを取得し、それを非表示とする。
コンソール自体は開放されないまま残るので、子プロセスを実行しても新たなコンソールが確保されることはない。
.caption 制限事項
Windowsでのみ動作可。
.caption 参考
https://learn.microsoft.com/ja-jp/troubleshoot/windows-server/performance/obtain-console-window-handle

*@
	Mulk import: #("dl" "sleeplib" "random")
*@
	DL import: "kernel32.dll" procs: #(#SetConsoleTitleA 101),
		import: "user32.dll" procs: #(#FindWindowA 102 #ShowWindow 102)
		
*hidecnsl tool.@
	Object addSubclass: #Cmd.hidecnsl
**Cmd.hidecnsl >> main: args
	"x" + (Random until: 100000000) ->:name;
	DL call: #SetConsoleTitleA with: name;
	0.1 sleep;
	DL call: #FindWindowA with: 0 with: name ->:h;
	DL call: #ShowWindow with: h with: 0
		
