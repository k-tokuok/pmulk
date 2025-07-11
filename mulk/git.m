revision control system
$Id: mulk git.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 改訂管理システム

*[man]
**#en
.caption SYNOPSIS
	git ARGS... -- Execute git with ARGS as an argument.
	git.log [OPTION] [ARG] -- Output log for ARG. If omitted, the current directory is the target.
.caption DESCRIPTION
Execute git on the host OS as a command.
.caption OPTION
	n N -- Display N lines of log. The default is 10. Specify '-' to display all.
	a yyyy-mm-dd -- Display logs after the date.
	b yyyy-mm-dd -- Display logs before the date.
**#ja
.caption 書式
	git ARGS... -- ARGSを引数のgitを実行する。
	git.log [OPTION] [ARG] -- ARGに対するログを出力する。省略時はカレントディレクトリを対象とする。
.caption 説明
コマンドとしてホストOSのgitを実行する。
.caption オプション
	n N -- ログをN行表示する。デフォルトは10。'-'を指定すると全て表示。
	a yyyy-mm-dd -- 日付以降のログを表示する。
	b yyyy-mm-dd -- 日付以前のログを表示する。
	
*git tool.@
	Mulk import: #("os" "optparse" "cmdstr");
	Object addSubclass: #Cmd.git
**Cmd.git >> runGit: strArg
	"os git " + strArg + " | ctr u =", runCmd
**Cmd.git >> main: args
	self runGit: args asCmdString
**Cmd.git >> main.log: args
	OptionParser new init: "n:a:b:" ->:op, parse: args ->args;
	
	"log --date=short --oneline \"--pretty=format:%cd %h %s\""->:ln;
	op at: 'n' ->:opt, nil?
		ifTrue: ["10" ->opt]
		ifFalse: [opt = "-" ifTrue: [nil ->opt]];
	opt notNil? ifTrue: [ln + " -n " + opt ->ln];
	op at: 'a' ->opt, notNil? ifTrue: [ln + " --after " + opt ->ln];
	op at: 'b' ->opt, notNil? ifTrue: [ln + " --before " + opt ->ln];
	args empty? ifFalse: [ln + ' ' + args first ->ln];
	self runGit: ln
