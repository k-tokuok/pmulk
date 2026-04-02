hide console
$Id: mulk hidecnsl.m 1555 2026-03-16 Mon 22:04:26 kt $
#ja コンソールを非表示とする

*[man]
**#en
.caption SYNOPSIS
	hidecnsl
	hidecnsl.show -- Show the console again
.caption DESCRIPTION
Hide the console of Mulk process.

Get the window handle of the console and hide it.
The console itself remains unopened, so no new console is allocated even if a child process is executed.
.caption LIMITATION
Can only work on Windows.
.caption SEE ALSO
https://learn.microsoft.com/ja-jp/troubleshoot/windows-server/performance/obtain-console-window-handle

**#ja
.caption 書式
	hidecnsl
	hidecnsl.show -- コンソールを再度表示する
.caption 説明
Mulkプロセスのコンソールを非表示とする。

コンソールのwindow handleを取得し、それを非表示とする。
コンソール自体は開放されないまま残るので、子プロセスを実行しても新たなコンソールが確保されることはない。
.caption 制限事項
Windowsでのみ動作可。
.caption 参考
https://learn.microsoft.com/ja-jp/troubleshoot/windows-server/performance/obtain-console-window-handle

*@
	Mulk import: #("win32" "dl")
*@
	DL import: "user32.dll" procs: #(#ShowWindow 102)
		
*hidecnsl tool.@
	Object addSubclass: #Cmd.hidecnsl;
	Mulk addGlobalVar: #Cmd.hidecnsl.hWnd
	
**Cmd.hidecnsl >> main: args
	Win32 consoleWindow ->Cmd.hidecnsl.hWnd;
	DL call: #ShowWindow with: Cmd.hidecnsl.hWnd with: 0
**Cmd.hidecnsl >> main.show: args
	DL call: #ShowWindow with: Cmd.hidecnsl.hWnd with: 1
