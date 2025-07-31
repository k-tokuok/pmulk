standalone pascal build script
$Id: mulk/pascal s-pascal.m 1442 2025-06-12 Thu 10:05:28 kt $

*[man]
.caption 書式
	make hostos=xxx view=off term=off dl=off target=pascal setup=../pascal/s-pascal.m sall
.caption 説明
mulkのvmのあるシステムディレクトリでコンパイルすることで単体で動作するpascal処理系を構築する。

*@
	Mulk.extraSystemDirectories addFirst: "../pascal" asFile;
	Mulk import: #("pascal" "pipe");
	Mulk.hostOS = #windows ifTrue: [Mulk import: "crlf"];
	"pcom.p4" asSystemFile readDo:
		[:s
		StringWriter new ->:wr;
		[s getLn ->:ln, notNil?] whileTrue: [wr putLn: ln];
		Mulk at: #Pascal.pcom put: wr asString];
	#Cmd.pascal ->Mulk.defaultMainClass;
	nil ->Mulk.systemDirectory ->Mulk.workDirectory
