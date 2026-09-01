savebase.m.
$Id: mulk/android savebase.m 1635 2026-08-22 Sat 22:09:49 kt $

*@
	"../mulk" asFile ->Mulk.systemDirectory;
	Mulk import: #("android" "repl");
	Mulk at: #Console.view in: "c-view", new ->:console;
	Mulk.bootHook addLast: console;
	nil ->Mulk.systemDirectory ->Mulk.workDirectory;
	#Cmd.repl ->Mulk.defaultMainClass;
	Mulk save: "base.mi"
