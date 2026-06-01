Sqlite class
$Id: mulk sqlite.m 1447 2025-07-01 Tue 10:09:21 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Provide a function to handle Sqlite database.

The values handled in the database are mapped to Mulk objects as shown below.

	INTEGER	-- Integer
	FLOAT -- Float
	TEXT -- String
	BLOB -- FixedByteArray
	NULL -- nil
**#ja
.caption 説明
Sqliteデータベースを扱う機能を提供する。

データベースで扱う値は以下のようにMulkのオブジェクトにマッピングされる。

	INTEGER	-- Integer
	FLOAT -- Float
	TEXT -- String
	BLOB -- FixedByteArray
	NULL -- nil

*import.@
	Mulk import: "dl"
**import dll.@
	"libsqlite3.so.0" ->:lib; -- linux
	Mulk.hostOS = #windows ifTrue: ["sqlite3.dll" ->lib];
	Mulk.hostOS = #cygwin ifTrue: ["cygsqlite3-0.dll" ->lib];
	DL import: lib procs: #(
		#sqlite3_open 2 #sqlite3_close_v2 1 #sqlite3_exec 5
		#sqlite3_prepare_v2 5 #sqlite3_step 1 #sqlite3_finalize 1
		#sqlite3_column_type 2 #sqlite3_column_count 1
		#sqlite3_bind_int 3 #sqlite3_column_int 2
		#sqlite3_bind_double 21 #sqlite3_column_double 22
		#sqlite3_bind_text 5 #sqlite3_column_text 2
		#sqlite3_bind_blob 5 #sqlite3_column_bytes 2 #sqlite3_column_blob 2
		#sqlite3_bind_null 2)

*[test] Text.Sqlite class.@
	UnitTest addSubclass: #Test.Sqlite instanceVars: "db" ->testClass
**Test.Sqlite >> setup
	self createTempFile ->:dbfile;
	Sqlite new open: dbfile ->db;
	db exec: "create table test(code,obj)";
	db exec: "insert into test values(1,1)";
	db exec: "insert into test values(2,3.14)";
	db exec: "insert into test values(3,'text')";
	db exec: "insert into test values(4,x'010203')";
	db exec: "insert into test values(5,null)"
**Test.Sqlite >> teardown
	db close

*Sqlite.Stmt class.@
	Object addSubclass: #Sqlite.Stmt instanceVars: "stmt"
**[man.c]
***#en
The object that corresponds to the sql statement.

Build with Sqlite >> prepare:... method.
***#ja
sqlステートメントに対応するオブジェクト。

Sqlite >> prepare:...メソッドで構築する。

**Sqlite.Stmt >> init: stmtArg 
	stmtArg ->stmt

**Sqlite.Stmt >> bind: index value: object
	object kindOf?: Integer, ifTrue:
		[DL call: #sqlite3_bind_int with: stmt with: index with: object!];
	object memberOf?: Float, ifTrue:
		[DL call: #sqlite3_bind_double with: stmt with: index with: object!];
	object memberOf?: String, ifTrue:
		[DL call: #sqlite3_bind_text with: stmt with: index with: object
			with: -1 with: 0!];
	object memberOf?: FixedByteArray, ifTrue:
		[DL call: #sqlite3_bind_blob with: stmt with: index with: object
			with: object size with: 0!];
	object nil? ifTrue: [DL call: #sqlite3_bind_null with: stmt with: index!];
	self assertFailed
***[man.m]
****#en
Bind the value indicated by '?' at index position in the statement to object.

index starts from 1.
****#ja
ステートメント中のindex番目の'?'で示される値をobjectに束縛する。

indexは1から数える。

**Sqlite.Stmt >> step
	DL call: #sqlite3_step with: stmt ->:rc;
	rc = 100 ifTrue: [#row!];
	rc = 101 ifTrue: [#done!];
	self error: "sqlite error with code " + rc
***[man.m]
****#en
Execute the statement.

#row is returned when a value is obtained by searching and #done is returned when the value ends normally.
All execution results can be obtained by calling it repeatedly until #done is returned.
****#ja
ステートメントを実行する。

検索等で値が得られた場合は#rowが、正常に終了した場合は#doneが返る。
#doneが返るまで繰り返し呼び出す事で、全ての実行結果が得られる。
***[test.m]
	db prepare: "select * from test" ->:st;
	0 ->:count;
	[st step ->:rc, = #row] whileTrue: [count + 1 ->count];
	self assert: rc = #done;
	st finalize;
	self assert: count = 5
	
**Sqlite.Stmt >> column: i
	DL call: #sqlite3_column_type with: stmt with: i ->:type;
	type = 1 {SQLITE_INTEGER} ifTrue:
		[DL call: #sqlite3_column_int with: stmt with: i!];
	type = 2 {SQLITE_FLOAT} ifTrue:
		[DL call: #sqlite3_column_double with: stmt with: i!];
	type = 3 {SQLITE3_TEXT} ifTrue:
		[DL loadString: (DL call: #sqlite3_column_text with: stmt with: i)!];
	type = 4 {SQLITE3_BLOB} ifTrue:
		[DL call: #sqlite3_column_bytes with: stmt with: i ->:len;
		FixedByteArray basicNew: len ->:fba;
		DL call: #sqlite3_column_blob with: stmt with: i ->:addr;
		len timesDo:
			[:off
			fba at: off put: (DL byteAt: addr + off)];
		fba!];
	type = 5 {SQLITE_NULL} ifTrue: [nil!];
	self assertFailed
***[man.m]
****#en
Gets the value of the i-th column of the statement execution result.
****#ja
ステートメントの実行結果のi番目のカラムの値を取得する。
***[test]
****Test.Sqlite >> selectObjForCode: n
	db prepare: "select obj from test where code=?" with: n ->:st;
	self assert: st step = #row;
	st column: 0 ->:result;
	self assert: st step = #done;
	st finalize;
	result!
***[test.m] int
	self assert: (self selectObjForCode: 1) = 1
***[test.m] float
	self assert: (self selectObjForCode: 2) = 3.14
***[test.m] text
	self assert: (self selectObjForCode: 3) = "text"
***[test.m] blob
	self assert: (self selectObjForCode: 4) describe = "aFixedByteArray(1 2 3)"
***[test.m] null
	self assert: (self selectObjForCode: 5) nil?

**Sqlite.Stmt >> columns
	DL call: #sqlite3_column_count with: stmt ->:count;
	Array new ->:result;
	count timesDo:
		[:i
		result addLast: (self column: i)];
	result!
***[man.m]
****#en
Returns an array of all columns of the statement execution result.
****#ja
ステートメントの実行結果の全てのカラムの配列を返す。
***[test.m]
	db prepare: "select * from test" ->:st;
	self assert: st step = #row;
	self assert: st columns size = 2;
	st finalize
	
**Sqlite.Stmt >> finalize
	DL call: #sqlite3_finalize with: stmt ->:rc;
	self assert: rc = 0
***[man.m]
****#ja
End statement execution and release reserved resources.
****#en
ステートメントの実行を終了し、確保しているリソースを開放する。

*Sqlite class.@
	Object addSubclass: #Sqlite instanceVars: "db"
**[man.c]
***#en
An object that corresponds to the database itself.
***#ja
データベース自体に対応するオブジェクト。

**Sqlite >> checkOk: rc
	rc <> 0 ifTrue: [self error: "sqlite error with code " + rc]

**Sqlite >> open: dbFile
	DL.IntPtrBuffer new ->:ptr;
	DL call: #sqlite3_open with: dbFile hostPath with: ptr ->:rc;
	self checkOk: rc;
	ptr value ->db
***[man.m]
****#en
Opens the database file for File dbFile.

Build an empty database if dbFile does not exist.
****#ja
File dbFileのデータベースファイルを開く。

dbFileが存在しない場合は空のデータベースを構築する。

**Sqlite >> close
	DL call: #sqlite3_close_v2 with: db ->:rc;
	self checkOk: rc
***[man.m]
****#en
Close the database and release the reserved resources.
****#ja
データベースを閉じ、確保しているリソースを開放する。

**Sqlite >> exec: sql
	DL call: #sqlite3_exec with: db with: sql with: #(0 0 0) ->:rc;
	self checkOk: rc
***[man.m]
****#en
Executes the sql statement of String sql.
****#ja
String sqlのsqlステートメントを実行する。

**Sqlite >> prepare: sql
	DL.IntPtrBuffer new ->:ptr;
	DL call: #sqlite3_prepare_v2 with: db with: sql with: -1 with: ptr with: 0
		->:rc;
	self checkOk: rc;
	Sqlite.Stmt new init: ptr value!	
***[man.m]
****#en
Construct Sqlite.Stmt object corresponding to the sql statement of String sql.
****#ja
String sqlのsqlステートメントに対応するSqlite.Stmtオブジェクトを構築する。

**Sqlite >> prepare: sql with: object
	self prepare: sql ->:stmt;
	stmt bind: 1 value: object;
	stmt!
***[man.m]
****#en
Construct Sqlite.Stmt object corresponding to the sql statement of String sql, and assign object to the part corresponding to the first '?' In the statement.
****#ja
String sqlのsqlステートメントに対応するSqlite.Stmtオブジェクトを構築し、ステートメント中の最初の?に対応する部位にobjectを割り当てる。
***[test]
****Test.Sqlite >> selectCodeForObj: o
	db prepare: "select code from test where obj=?" with: o ->:st;
	self assert: st step = #row;
	st column: 0 ->:result;
	self assert: st step = #done;
	st finalize;
	result!
***[test.m] int
	self assert: (self selectCodeForObj: 1) = 1
***[test.m] float
	self assert: (self selectCodeForObj: 3.14) = 2
***[test.m] text
	self assert: (self selectCodeForObj: "text") = 3
***[test.m] blob
	#[1 2 3] ->:fba;
	self assert: (self selectCodeForObj: fba) = 4
***[test.m] null
	db prepare: "insert into test values(6,?)" with: nil ->:st;
	self assert: (st step) = #done;
	st finalize;

	self assert: (self selectObjForCode: 6) nil?
