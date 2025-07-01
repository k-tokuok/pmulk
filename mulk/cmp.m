file comparison
$Id: mulk cmp.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ファイル比較

*[man]
**#en
.caption SYNOPSIS
	cmp FILE1 FILE2
.caption DESCRIPTION
Compare FILE1 and FILE2, and if there is a difference, display the line number.

If a directory is specified as FILE2, it is assumed that a file with the same name under the specified directory is specified.
**#ja
.caption 書式
	cmp FILE1 FILE2
.caption 説明
FILE1とFILE2を比較し、相違があれば行番号を表示する。

FILE2としてディレクトリを指定すると、指定ディレクトリ下の同名のファイルが指定されたものとする。

*cmp tool.@
	Object addSubclass: #Cmd.cmp
**Cmd.cmp >> main: args
	args first asFile ->:f1;
	args at: 1, asFile ->:f2, directory? ifTrue: [f2 + f1 name ->f2];
	f1 openRead ->:fs1;
	f2 openRead ->:fs2;
	1 ->:line;
	[fs1 getLn ->:l1;
	fs2 getLn ->:l2;
	l1 notNil? & (l1 = l2)] whileTrue: [line + 1 ->line];
	l1 nil? & l2 nil? ifFalse: [Out putLn: "differ at line " + line];
	fs1 close;
	fs2 close
