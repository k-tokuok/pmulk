expand tab
$Id: mulk detab.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja タブの展開

*[man]
**#en
.caption format
	detab [N]
.caption description
The tab characters included in the standard input are expanded to spaces in units of N characters and output to the standard output.

If N is omitted, 4 is assumed to be specified.
**#ja
.caption 書式
	detab [N]
.caption 説明
標準入力に含まれるtab文字をN文字単位で空白に展開して、標準出力へ出力する。

Nを省略した場合は4が指定されたものと見做す。

*detab tool.@
	Object addSubclass: #Cmd.detab
**Cmd.detab >> main: args
	args empty? ifTrue: [4] ifFalse: [args first asInteger] ->:width;

	0 ->:pos;
	[In getWideChar ->:ch, notNil?] whileTrue:
		[ch = '\t'
			ifTrue:
				[Out putSpaces: width - (pos % width);
				0 ->pos]
			ifFalse:
				[Out put: ch;
				ch = '\n'
					ifTrue: [0 ->pos]
					ifFalse: [pos + ch width ->pos]]]
