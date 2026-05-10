savebase.m.
$Id: mulk/android savebase.m 1442 2025-06-12 Thu 10:05:28 kt $

*@
	"../mulk" asFile ->Mulk.systemDirectory;
	Mulk import: #("android" "repl");
	Mulk at: #Console.viewu in: "c-viewu", new ->:console,
		convertTilda: true, convertEllipsis: true;
	Mulk.bootHook addLast: console;
	nil ->Mulk.systemDirectory ->Mulk.workDirectory;
	#Cmd.repl ->Mulk.defaultMainClass;
	Mulk save: "base.mi"
