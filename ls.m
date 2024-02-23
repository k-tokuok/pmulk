list directory contents
$Id: mulk ls.m 1054 2023-05-13 Sat 21:50:56 kt $
#ja ディレクトリの内容を一覧表示する

*[man]
**#en
.caption SYNOPSIS
	ls [OPTION] [PATH/PATTERN]
.caption DESCRIPTION
Outputs a list of files and directories whose entire file name matches the regular expression PATTERN under the PATH directory.

One or both of PATH and PATTERN can be specified.
If both are specified, PATTERN is the last element of the path name separated by '/'.
If PATH is omitted, the contents of the current directory are output.
If PATTERN is omitted, all files and directories in the specified directory are output.

On systems that do not distinguish between uppercase and lowercase letters in file names, lowercase letters in regular expressions also match uppercase letters.
.caption OPTION
	l -- Outputs the type, access right, size, and update time together.
	r -- Recursively output subordinate directories.
	f -- Output only regular files.
	d -- Output only directories.
	m -- Multi-column output.
	F -- Display file name with full path.
	n -- Do not align. If not specified, they are sorted by name.
	t -- Sort by update time (long format only).
	s -- Sort by size (long format only).
	R -- Sort in reverse order.
	i -- Ignore errors while browsing the directory.
	N DATE -- Output a newer file including DATE.
	O DATE -- Output older files, including DATE.
		DATE is a numeric sequence of yyyymmddhhmmss and corresponds to year, month, day, hour, minute, second. 0 cannot be omitted. It can be omitted from any stage below the year, and when omitted, it is assumed to be January 1, 00:00:00.
.caption SEE ALSO
.summary regexp

**#ja
.caption 書式
	ls [OPTION] [PATH/PATTERN]
.caption 説明
PATHディレクトリ下の正規表現PATTERNにファイル名全体がマッチするファイル・ディレクトリの一覧を出力する。

PATHとPATTERNは一方あるいは両方を指定する事が出来る。
両方を指定した場合は'/'で区切られたパス名の最後の要素をPATTERNとする。
PATHを省略した場合はカレントディレクトリの内容を出力する。
PATTERNを省略した場合は指定ディレクトリの全てのファイル・ディレクトリを出力する。

ファイル名の英大文字小文字を区別しないシステムでは、正規表現中の英小文字は大文字にもマッチする。

.caption オプション
	l -- 種別・アクセス権・サイズ・更新時刻を併せて出力する。
	r -- 下位ディレクトリ以下も再帰的に出力する。
	f -- 通常ファイルのみ出力する。
	d -- ディレクトリのみ出力する。
	m -- マルチカラム出力。
	F -- ファイル名をフルパスで表示する。
	n -- 整列しない。指定しない場合、名称順に整列される。
	t -- 更新時刻で整列する(長形式のみ)。
	s -- サイズで整列する(長形式のみ)。
	R -- 逆順に整列する。
	i -- ディレクトリ参照中のエラーを無視する。
	N DATE -- DATEを含め、より新しいファイルを出力する。
	O DATE -- DATEを含め、より古いファイルを出力する。
		DATEはyyyymmddhhmmssなる数列で、年月日時分秒に対応する。0は省略出来ない。年より下位の任意の段階から省略出来、省略時は1月1日0時0分0秒と見做される。
.caption 関連項目
.summary regexp

*ls tool.@
	Mulk import: #("optparse" "regexp");
	Object addSubclass: #Cmd.ls instanceVars:
		"long? recur? file? directory? multiColumn? fullPath? filter sortFilter"
		+ " ignoreError? baseDir newer older"
**Cmd.ls >> addSortFilter: s
	sortFilter + ' ' + s ->sortFilter
**Cmd.ls >> setSortFilter: type reverse?: reverse?
	nil ->sortFilter;
	type nil? ifTrue: [self!];
	type = #time | (type = #size) ifTrue: [true ->long?];

	"sort" ->sortFilter;
	reverse? ifTrue: [self addSortFilter: "-r"];
	long? ifTrue:
		[type = #name ifTrue: [self addSortFilter: "-C40"];
		type = #time ifTrue: [self addSortFilter: "-C16"];
		type = #size ifTrue: [self addSortFilter: "-nC3"]]
**Cmd.ls >> parseDate: s
	s copyUntil: 4, asInteger ->:year;
	1 ->:month ->:day;
	0 ->:hour ->:minute ->:second;
	s size ->:slen;
	slen >= 6 ifTrue: [s copyFrom: 4 until: 6, asInteger ->month];
	slen >= 8 ifTrue: [s copyFrom: 6 until: 8, asInteger ->day];
	slen >= 10 ifTrue: [s copyFrom: 8 until: 10, asInteger ->hour];
	slen >= 12 ifTrue: [s copyFrom: 10 until: 12, asInteger ->minute];
	slen = 14 ifTrue: [s copyFrom: 12 until: 14, asInteger ->second];

	DateAndTime new initYear: year month: month day:
		day hour: hour minute: minute second: second!
**Cmd.ls >> parseOption: args
	OptionParser new init: "lrfdmFntsRiN:O:" ->:op, parse: args ->args;
	op at: 'l' ->long?;
	op at: 'r' ->recur?;
	op at: 'f' ->file?;
	op at: 'd' ->directory?;
	op at: 'm' ->multiColumn?;
	op at: 'F' ->fullPath?;
	#name ->:sortType;
	op at: 'n', ifTrue: [nil ->sortType];
	op at: 't', ifTrue: [#time ->sortType];
	op at: 's', ifTrue: [#size ->sortType];
	op at: 'i' ->ignoreError?;
	self setSortFilter: sortType reverse?: (op at: 'R');
	op at: 'N' ->:opt, notNil? ifTrue: [self parseDate: opt ->newer];
	op at: 'O' ->opt, notNil? ifTrue: [self parseDate: opt ->older];
	args!
**Cmd.ls >> typeChar: f
	f directory? ifTrue: ['d'!];
	f other? ifTrue: ['?'!];
	'-'!
**Cmd.ls >> printFile: f
	ignoreError? not and: [f none?], ifTrue: [self error: "illeal file " + f];
	filter notNil? ifTrue: [filter match: f name, ifFalse: [self!]];
	file? ifTrue: [f file? ifFalse: [self!]];
	directory? ifTrue: [f directory? ifFalse: [self!]];
	older notNil? and: [f mtime > older], ifTrue: [self!];
	newer notNil? and: [f mtime < newer], ifTrue: [self!];
	long? ifTrue:
		[Out
			put: (self typeChar: f),
			put: (f readable? ifTrue: ['r'] ifFalse: ['-']),
			put: (f writable? ifTrue: ['w'] ifFalse: ['-']),
			put: ' ',
			put: f size width: 11,
			put: ' ',
			put: f mtime,
			put: ' '];
	Out putLn: (fullPath? ifTrue: [f path] ifFalse: [f pathFrom: baseDir])
**Cmd.ls >> printFiles: file
	file directory?
		ifTrue:
			[file ->baseDir;
			recur? ifTrue: [file decendantFiles] ifFalse: [file childFiles],
				do: [:f self printFile: f]]
		ifFalse:
			[file parent ->baseDir;
			self printFile: file]
**Cmd.ls >> main: args
	self parseOption: args ->args;
	args empty? ifTrue: ["."] ifFalse: [args first], asFile ->:file;
	file directory? ifFalse:
		[RegExp new ->:re;
		Mulk.caseInsensitiveFileName? ifTrue: [re caseInsensitive];
		re compile: "^" + file name + "$" ->filter;
		file parent ->file];

	Array new ->:pipes;
	pipes addLast: [self printFiles: file];
	sortFilter notNil? ifTrue: [pipes addLast: sortFilter];
	multiColumn? ifTrue:
		[self assert: long? not & recur? not;
		pipes addLast: "multicol"];

	In pipe: pipes to: Out
