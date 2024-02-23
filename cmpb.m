binary file comparison
$Id: mulk cmpb.m 1145 2023-12-09 Sat 21:39:51 kt $
#ja バイナリファイル比較

*[man]
**#en
.caption SYNOPSIS
	cmpb FILE1 FILE2
.caption DESCRIPTION
Binary comparison of FILE1 and FILE2 is performed, and if there is a difference, the byte offset is displayed.

If a directory is specified as FILE2, it is assumed that a file with the same name under the specified directory is specified.
**#ja
.caption 書式
	cmpb FILE1 FILE2
.caption 説明
FILE1とFILE2をバイナリ比較し、相違があればバイトオフセットを表示する。

FILE2としてディレクトリを指定すると、指定ディレクトリ下の同名のファイルが指定されたものとする。

*cmpb tool.@
	Object addSubclass: #Cmd.cmpb
**Cmd.cmpb >> main: args
	args first asFile ->:f1;
	args at: 1, asFile ->:f2, directory? ifTrue: [f2 + f1 name ->f2];
	f1 unmatchIndexWith: f2 ->:pos, notNil? ifTrue:
		[Out putLn: "differ at offset " + pos]
