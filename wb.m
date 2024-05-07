text editor
$Id: mulk wb.m 1218 2024-04-20 Sat 06:51:50 kt $
#ja テキストエディタ

*[man]
**#en
.caption SYNOPSIS
	wb [OPTION]
.caption DESCRIPTION
wb (workbench) is a screen-based text editor.
.caption OPTION
	i -- Initialize and start.
	I FILE -- After initialization, load FILE and start it.
		If I option is not specified, load "wbi.m" in Mulk.workDirectory if exist.
		If "-" is specified as FILE, nothing is read.
	R -- Recover the contents of the previous session's buffer.
	r -- Resume an abnormally terminated session.
	d -- Do not catch exceptions raised in the editor.
.caption LIMITATION
Operable only under Console with screen control function.
.caption SEE ALSO
.summary sconsole

.right 3
Is your role the public
who decides which editor to use because people tell you to?
Or...!?
.index

**#ja
.caption 書式
	wb [OPTION]
.caption 説明
wb(ワークベンチ)は画面ベースのテキストエディタである。
.caption オプション
	i -- 初期化して起動する。
	I FILE -- 初期化後にFILEをロードして起動する。
		Iオプションを指定しない場合、Mulk.workDirectoryに"wbi.m"があればそれを読み込む。
		FILEとして"-"を指定すると何も読み込まない。
	R -- 前セッションのバッファの内容を復元する。
	r -- 異常終了したセッションを再開する。
	d -- エディタ内で発生した例外をキャッチしない。
.caption 制限事項
画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary sconsole
	
.right 2
君の役は人から言われて使うエディタを決める一般民衆か?
それとも……!?
.index

**Operation
***#en
All operations are performed from the keyboard.

Various functions can be performed with control characters entered with the ctrl key.
In the following description, ^x means input x while holding down ctrl.

The characters that can be used in the text and the input method are as follows.

	ASCII characters (Character code 0x20-0x7e) -- Input from keyboard normally.
	Line break -- Enter key or ^m.
	Tab -- Tab key or ^i.
	Other multibyte characters -- Use the input method on Mulk. Depending on the environment, the input method of the host system may be used.

The following control characters correspond to each key.

	^h -- Backspace
	^[ -- Esc
***#ja 操作
操作は全てキーボードから行う。

ctrlキーと共に入力される制御文字で様々な機能を実行出来る。
以下の説明では^xはctrlを押しながらxを入力する事を意味する。

テキスト中に使用出来る文字と入力の仕方は以下の通り。

	ASCII文字(文字コード0x20-0x7e) -- 普通にキーボードから入力。
	改行 -- Enterもしくは^m。
	タブ -- Tabもしくは^i。
	その他のマルチバイト文字 -- Mulkのインプットメソッドを用いる。環境によってはホストシステムのインプットメソッドが使える場合もある。

以下の制御文字はそれぞれのキーに対応する。

	^h -- Backspace
	^[ -- Esc

**Buffer and cursor
***#en
The buffer is a characters being edited that is stored inside wb.

The cursor points to a point between characters in the buffer at the current editing position.

A part of the buffer including the cursor is displayed on the screen.
The cursor of the display terminal is displayed over the character immediately after the cursor position.

Moving the cursor from the current position to the beginning of the buffer is called "backward", and moving the cursor to the end of the buffer is called "forward".
***#ja バッファとカーソル
バッファはwb内部で保持している編集中の文字の列である。

カーソルは現在の編集位置でバッファ内の文字の間の一点を指し示している。

画面にはカーソルを含めたバッファの一部が表示される。
表示端末のカーソルはカーソル位置の直後の文字に重ねて表示される。

**Cursor movement
***#en
Moving the cursor to the end of the buffer is called "forward", and moving the cursor to the beginning is called "backward".

***#ja カーソル移動
カーソルをバッファの末尾側に移動させることを「前進」、先頭側に移動させる事を「後退」と呼ぶ。

***Character-by-character movement
****#en
Move the cursor forward or backward by one character.
	^n -- Move forward to the next character.
	^p -- Move backward to the previous character.
****#ja 文字単位の移動
カーソルを一文字分前後に移動させる。
	^n -- 次の文字へ前進。
	^p -- 前の文字へ後退。
	
***Line-by-line movement
****#en
Move the cursor based on the line.
	^z -- Move forward to the end of the line. If the cursor is already at the end of a line, it moves to the next line.
	^q -- Move backward to the beginning of the line. If the cursor is already at the beginning of a line, move to the previous line.
****#ja 行単位の移動
行を基準としたカーソル移動を行う。
	^z -- 行末へ前進させる。既に行末にあるなら次行に移動させる。
	^q -- 行頭へ後退させる。既に行頭にあるなら前行に移動させる。
	
***Leap
****#en
Leap searches forward / backward for the entered pattern and moves the cursor to the matched position in the buffer.

	^f -- Start forward leap.
	^b -- Start backward leap.
	^a -- Start forward leap and advance to the last pattern.
	
During the leap, the bottom line shows the relative position of the cursor to the leap start document, the leap orientation, and the pattern.
The relative position is indicated by '>' if it is in front of the start document and by '<' if it is behind it.
Do not display anything if it is in the start document.
The direction of the leap is indicated by '>' for forward and '<' for backward.

If the search reaches the end/start of the buffer, the search is continued without changing the direction from the start/end.

The following operations are valid during the leap.
	Text character -- Add characters to the pattern and search. If it does not match, ignore the input.
	^v -- Creates a pattern that is added to the pattern and matches other than the characters added next.
	^a -- Proceed to the next matching position in the current pattern. If the pattern is empty, use the pattern that matched immediately before.
	^f -- If the pattern is empty and you are leaping forward, move forward by one screen.
	^b -- If the pattern is empty and you are leaping backward, move backward by one screen.
	^g -- End the leap on the spot.
	^[ -- Return to the position where you started the leap and end the leap.
	^u -- Undo the last of the operations after the start of the leap.
	^r -- Redo undone operation.

For other operations, the corresponding function is executed after terminating the leap.
Some functions that require range specification target between the leap start position and the cursor.
When such a function is executed during non-leap, the line with the cursor is targeted.

****#ja リープ
リープは入力されたパターンを前方/後方に検索し、バッファ内でマッチした位置にカーソルを移動させる。

	^f -- 前進リープの開始。
	^b -- 後退リープの開始。
	^a -- 前進リープを開始し、直前のパターンまで前進。

リープ中、最下行にリープ開始ドキュメントに対するカーソルの相対位置、リープの向き、パターンが表示される。
相対位置は開始ドキュメントの前方なら'>'、後方なら'<'で示す。
開始ドキュメント内にある場合は何も表示しない。
リープの向きは前進なら'>'、後退なら'<'で示される。

検索によりバッファ末尾/先頭に到達した場合は先頭/末尾から向きを変えずに検索を続ける。

リープ中は以下の操作が有効となる。
	文字入力 -- パターンに文字を追加し、検索する。マッチしない場合は入力を無視する。
	^v -- パターンに追加され、その次に追加された文字以外にマッチするパターンを作り出す。
	^a -- 現在のパターンで次にマッチする位置に進める。パターンが空の場合は直前にマッチしたパターンを使う。
	^f -- パターンが空で前進リープ中なら1画面分前進する。
	^b -- パターンが空で後退リープ中なら1画面分後退する。
	^g -- その場でリープを終了する。
	^[ -- リープを始めた位置に戻ってリープを終了する。
	^u -- リープ開始後の操作の最後のものを取り消す。
	^r -- 取り消した繰作をやり直す。
それ以外の操作はリープを終了させた上で対応する機能を実行する。
範囲指定を必要とする一部の機能は、リープ開始位置からカーソルの間を対象とする。
そのような機能を非リープ中に実行するとカーソルのある行が対象となる。

**Edit
***#ja 編集
***Insert character
****#en
The entered character is inserted at the cursor position.
The cursor moves forward by one character.

When you enter a newline character, the indent on the new line is aligned with the previous line.
****#ja 文字の挿入
入力した文字はそのままカーソル位置に挿入される。
カーソルは一文字分前進する。

改行文字を入力すると、新たな行のインデントは前の行と揃えられる。

***Delete one character (^h)
****#en
Delete one character before the cursor.
****#ja 一文字削除 (^h)
カーソル直前の一文字を削除する。

***Range edit
****#en
Cut and copy the specified range and paste it at the cursor position.
	^e -- Cut (erase)
	^y -- Copy (yank)
	^w -- Paste (wedge)
When pasted during a leap, the range corresponding to the pattern after the cursor is deleted.

If the clipboard library (cliplib) is enabled, the host system's clipboard is used.
****#ja 範囲編集
指定の範囲の切り取り、複製、カーソル位置への貼り付けを行う。
	^e -- 切り取り (erase)
	^y -- 複製 (yank)
	^w -- 貼り付け (wedge)
リープ中に貼り付けを行うと、カーソル位置のパターンに対応する範囲が削除される。

クリップボードライブラリ(cliplib)が有効ならば、ホストシステムのクリップボードが用いられる。

***Undo/Redo
****#en
Undo an editing operation or redo an undone operation.
	^u -- Undo the last operation.
	^r -- Redo an undone operation.
****#ja 取り消し/やり直し
編集操作の取り消しや、取り消した操作のやり直しを行う。
	^u -- 最後の操作を取り消す。
	^r -- 取り消した操作をやり直す。

**Document
***#en
The line beginning with '||' is called the document marker, and the area between the markers is called the document.
The buffer is treated as multiple documents.
***#ja ドキュメント
行頭が||で始まる行をドキュメントマーカー、マーカーで挟まれた範囲をドキュメントと呼ぶ。
バッファは複数のドキュメントに区切って扱われる。

***Interactive document
****#en
Command interpreter (icmd) is running on the first document in the buffer, and a prompt is displayed at startup.

When you enter a series of characters ending with a line feed on a line with a prompt, the contents are sent to icmd and commands executed from icmd.
Enter "^c" (two characters '^' and 'c') as a line to send a ^c interrupt, and enter "^d" to send an EOF character.

****#ja インタラクティブドキュメント
バッファの先頭ドキュメントではコマンドインタプリタ(icmd)が動作しており、起動時はプロンプトを表示している。

プロンプトのある行で改行で終わる一連の文字列を入力すると、その内容がicmd及びicmdから実行したコマンドに送られる。
行として"^c"('^'と'c'の2文字)を入力すると^c割り込みが、"^d"を入力するとEOF文字がそれぞれ送られる。

***File synchronization (^d)
****#en
Synchronize the document with the cursor to the corresponding file.

.item
The file path corresponding to a document is indicated by a marker line <...> in the marker line.
If this is not the case, create an absolute path name from the contents of the marker line and add a <...> description is added.
If the content of the marker line starts with '*', no file synchronization is performed.

.item
If the document is empty and there is a file, read the file.

.item
If the document is not empty and has no files, write to the file.

.item
If the contents of the document and the file do not match, a message to that effect is displayed, and one of read (r), write (w), insert difference into buffer (d) or skip (s) from the file is selected.

If you specify the ctr code argument + ':' at the beginning of the file path, the character code and line feed code will be converted when reading and writing the file.
If the cursor is on an interactive document, synchronize all documents that have a file name and differ from the file.
****#ja ファイル同期 (^d)
カーソルのあるドキュメントと対応するファイルを一致させる。

.item
ドキュメントに対応するファイルパスはマーカー行の<..>で囲んだ形で示される。
これがない場合、マーカー行の内容から絶対パス名を作り<..>記述を追加する。
マーカー行の内容が'*'で始まる場合、ファイルとの同期は行わない。

.item
ドキュメントが空でファイルがある場合はファイルを読み込む。

.item
ドキュメントが空でなくファイルが無い場合はファイルへ書き込む。

.item
ドキュメントとファイルの内容が一致しない場合はその旨を表示し、ファイルから読み込む(r)、書き込む(w)、差分をバッファに挿入する(d)、そのままにする(s)の何れかを選択する。

ファイルパスの先頭にctrのコード引数+':'を指定すると、ファイルの読み書きの際文字コード、改行コードの変換を行う。
インタラクティブドキュメントにカーソルがある場合、ファイル名を持ち、ファイルと内容が異なる全てのドキュメントを同期する。

**Screen
***#ja 画面
***Redraw Screen (^v)
****#en
Redraw the screen.
Each time ^v is entered, the cursor position on the screen is switched to the beginning, end, or center.
****#ja 再描画 (^v)
画面を再描画する。
^vを入力する度に、画面上のカーソル位置を先頭、末尾、中央に切替える。

***Split screen
****#en
Divide the screen and refer to two places in the buffer at the same time.
	^s -- Screen split ON/OFF.
	^o -- Move the cursor to another split screen.
****#ja 分割
画面を分割してバッファ中の二箇所を同時に参照する。
	^s -- 画面分割のON/OFF。
	^o -- 分割した別画面へカーソルを移動する。

**Completion (^@, ^t)
***#en
Completing the contents in the middle of input from the contents before and after the cursor.

The next candidate will be displayed if you continue to complement.
***#ja 補完 (^@, ^t)
カーソルの前後の内容から入力途中の内容を補完する。

続けて補完を行うと次の候補が表示される。

**Quit (^[)
***#en
Quit wb.

Synchronize all documents that have a file name and differ from the file in content.
If wb is run again without exiting Mulk, it resumes from the previous state.

If wb terminates abnormally, it will try to resume with the r option if Mulk is running.
If Mulk itself has terminated, the next run of wb will try to restore the contents of the non-interactive document buffer.
Even if wb exited normally, you can restore the contents of the previous session's buffer with the R option.

***#ja 終了 (^[)
wbを終了する。

ファイル名を持ち、ファイルと内容が異なる全てのドキュメントを同期する。
Mulkを終了せずに再びwbを実行すると直前の状態から再開する。

wbが異常終了した場合、Mulkが実行中ならばrオプションで再開しようとする。
Mulk自体が終了している場合、次にwbを実行するとインタラクティブドキュメント以外のバッファの内容を復元しようとする。
wbが正常終了していてもRオプションで前回のセッションのバッファの内容を復元出来る。

**^x prefix
***#en
^x performs each function depending on the character that is entered in succession.
***#ja ^xプリフィックス (^x)
^xは続けて入力する文字によってそれぞれの機能を実行する。

***User Registration Key
****#en
The characters except '(', ')' and control characters can be used to register functions that are valid only for the duration of the session.
The user registration key is executed by typing ^x followed by the registered characters.
****#ja ユーザー登録キー
'(', ')'及び制御文字を除く文字に、セッションの間だけ有効な機能を登録することが出来る。
ユーザー登録キーは^xに続けて登録した文字を入力することで実行される。

****String (^x + ^y + KEY)
*****#en
Register the string in the specified range.
When executed, a string is inserted at the cursor position.
*****#ja 文字列 (^x + ^y + KEY)
指定範囲の文字列を登録する。
実行するとカーソル位置に文字列が挿入される。

****Tag (^x + ^t + KEY)
*****#en
Register the cursor position as a tag.

The tag is a mechanism that points to the same position regardless of editing, and when executed, the cursor is moved to the tag position.
When a tag is set or called, that tag becomes the current tag and is displayed in [] at the bottom line.
The current tag is valid as long as the cursor is in the document and follows its movement.
The current tag is saved when the document is synced and restored when the file is read.

The following tags have a special meaning.
	^o -- The cursor position on the other side's screen when the screen is split.
	^i -- Prompt location for interactive documents.
	^u -- The position before the last leap or tag jump. If you cancel the leap, the place you moved in the last leap.
	
These are automatically preached and updated and do not become current tags.
*****#ja タグ (^x + ^t + KEY)
カーソル位置をタグとして登録する。

タグは編集に関わらず同じ位置を指す仕組みで、実行するとカーソルをタグの位置に移動させる。
タグの設定や呼び出しを行うと、そのタグがカレントタグとなり最下行に[]で囲まれて表示される。
カレントタグはカーソルがドキュメント中にある限り有効で、その動きに追従する。
カレントタグはドキュメントを同期させる時に保存され、そのファイルを読み込む時に復元される。

次のタグには特殊な意味がある。
	^o -- 画面分割した際の相手側の画面のカーソル位置。
	^i -- インタラクティブドキュメントのプロンプトの位置。
	^u -- 直前のリープ/タグジャンプ前の位置。リープを取り消した場合は最後のリープで移動した場所。
これらは自動的に設定・更新されカレントタグにはならない。

****Macro
*****#en
Register the series of operations and execute them to reproduce the operations.

	^x + ( -- Start macro definition
	^x + ) + KEY -- End macro definition and registration to KEY.
.
During the definition, M is displayed at the beginning of the bottom line.

	^x + ^r + KEY -- Execute the key macro and display the prompt. If you enter ' ', it will be repeated. If you enter '1' to '9' and '0', 10 to 100 times repeated. If you enter anything else, it will end.
*****#ja マクロ
一連の繰作の内容を登録し、実行すると繰作を再現する。

	^x + ( -- マクロ定義開始
	^x + ) + KEY -- 定義終了・登録
	
定義中は最下行の先頭にMが表示される。

	^x + ^r + KEY -- KEYのマクロを実行しプロンプトを表示。' 'を入力するともう一度、'1'から'9'及び'0'を入力すると10回から100回繰り返す。それ以外を入力すると終了する。

***Execute/evaluate/load (^x + ^x)
****#en
If the beginning of the specified range is '!', the description after the second character is executed by 'cmd' command and the output is replaced with the specified range.

In the case of '@', the description after the second character is evaluated as Mulk's statement and the result is inserted.

In other cases, the specified range is read as a module.
The entire document is loaded during non-leap.
****#ja 実行/評価/読み込み (^x + ^x)
指定範囲の先頭が'!'の場合、二文字目以降の記述をcmdで実行し出力を指定範囲と置き換える。

'@'の場合は二文字目以降の記述をMulkのstatementとして評価し、結果を挿入する。

それ以外の場合は指定範囲をモジュールとして読み込む。
非リープ中はドキュメント全体が読み込まれる。

***Leap reverse (^x + ^z)
****#en
During the leap, the pattern is initialized while maintaining the cursor position, and the direction of the leap is reversed.
****#ja リープ反転 (^x + ^z)
リープ中、カーソル位置を保持したままパターンを初期化し、リープの向きを反転する。
***Leap string (^x + ^f + KEY)
****#en
Forward leap with the string assigned to the user registration key.
If executed during a leap, the string is added to the pattern.
****#ja 文字列リープ (^x + ^f + KEY)
ユーザー登録キーに割り当てた文字列で前進リープを行う。
リープ中に実行した場合、文字列をパターンに追加する。

***Goto Line (^x + ^g)
****#en
Moves to the line with the line number specified as the leap range.
****#ja 行移動 (^x + ^g)
リープ範囲として指定した行番号の行に移動する。

**Subcommand
***#en
The following are subcommands of wb, which can be executed from interactive documents, etc.
***#ja サブコマンド
以下はwbのサブコマンドでありインタラクティブドキュメント等から実行出来る。

***wb.d -- document
****#en
Display a list of documents and tags in the buffer.

The symbol before the document or tag indicates the synchronization status.
	= -- The file is synchronized and the contents match.
	* -- Synced but content does not match.
	Blank -- Not synced.
****#ja wb.d -- ドキュメント一覧
バッファ中のドキュメントとタグの一覧を表示する。

ドキュメント、タグの前の記号は同期状態を示している。
	= -- 同期されファイルと内容が一致している。
	* -- 同期済みだが内容は一致しない。
	空白 -- 同期されていない。

***wb.h [-f] -- history
****#en
Output the list of saved tags in the form of marker lines.

Output only the file with the f option.
****#ja wb.h [-f] -- 保存タグ一覧
保存したタグの一覧をマーカー行の形式で出力する。

fオプションでファイルのみを出力する。

***wb.rmh [FILE...] -- remove history
****#en
Remove the saved tag corresponding to FILE.

If FILE is omitted, the file list is acquired from the standard input.
****#ja wb.rmh [FILE...] -- 保存タグの削除
保存タグからFILEに対応したものを削除する。

FILEを省略すると標準入力からファイルリストを取得する。

***wb.w -- wedge
****#en
Outputs the contents held by range editing to the standard output.
****#ja wb.w -- 貼り付け
範囲編集で保持した内容を標準出力へ出力する。

***wb.x [KEY [KEY]] -- refer ^x
****#en
Output the contents of the user registration key.

If KEY is a string, output the string itself.
If KEY is a tag, output the contents of the document containing the tag.
If two tags are specified, the contents of the area enclosed by both tags are output.

If KEY is omitted, a list of user registration keys is output.
****#ja wb.x [KEY [KEY]] -- ユーザー登録キーの参照
ユーザー登録キーの内容を出力する。

KEYが文字列ならそれ自体を。
タグならタグを含むドキュメントの内容を出力する。
二つのタグを指定すると両タグで囲まれた範囲の内容を出力する。

KEYを省略するとユーザー登録キーの一覧を出力する。

*import.@
	Mulk import: #("wcarray" "console" "pi" "cliplib" "optparse" "tempfile")

*Wb.BufferReader class.@
	Object addSubclass: #Wb.BufferReader instanceVars:
		"buffer pos end addNewline?", features: #(Reader)
**Mulk.newline = #crlf >
***@
	Wb.BufferReader features: #(NewlineCrlfStream Reader)
**Wb.BufferReader >> init: bufferArg from: posArg until: endArg
	bufferArg ->buffer;
	posArg ->pos;
	endArg ->end;
	false ->addNewline?
**Wb.BufferReader >> addNewline
	true ->addNewline?
**Wb.BufferReader >> getByte
	pos = end ifTrue:
		[addNewline? ifTrue:
			[false ->addNewline?;
			'\n' code!];
		-1!];
	buffer byteAt: pos ->:result;
	pos + 1 ->pos;
	result!

*Wb.BytesStream class.@
	MemoryStream addSubclass: #Wb.BytesStream
**Mulk.newline = #crlf >
***@
	Wb.BytesStream features: #(NewlineCrlfStream)
	
*Wb.Buffer class.@
	Object addSubclass: #Wb.Buffer instanceVars:
		"elements gapStart gapEnd matchSize"
**Wb.Buffer >> init
	FixedByteArray basicNew: 4096 ->elements;
	0 ->gapStart;
	elements size ->gapEnd
**Wb.Buffer >> gapSize
	gapEnd - gapStart!
**Wb.Buffer >> size
	elements size - self gapSize!

**accessing.
***Wb.Buffer >> byteAt: pos
	pos >= gapStart ifTrue: [pos + self gapSize ->pos];
	elements at: pos!
***Wb.Buffer >> charAt: pos
	self byteAt: pos ->:code;
	code asChar!
***Wb.Buffer >> at: pos
	self charAt: pos ->:ch, mblead? ifTrue:
		[ch code ->:code;
		ch trailSize timesDo:
			[:i
			code << 8 | (self byteAt: pos + i + 1) ->code];
		code asWideChar ->ch];
	ch!
***Wb.Buffer >> next: pos
	self charAt: pos ->:ch;
	Mulk.newline = #crlf ifTrue:
		[ch = '\r' and: [self byteAt: pos + 1, = '\n' code],
			ifTrue: [pos + 1 ->pos]];
	ch mblead? ifTrue: [pos + ch trailSize ->pos];
	pos + 1!

***Mulk.charset = #sjis >
--SJIS multibyte size must be 2.
****Wb.Buffer >> sepr0?: pos
	pos = 0 ifTrue: [true!];
	self charAt: pos ->:ch;
	Mulk.newline = #crlf ifTrue:
		[ch = '\n' ifTrue: [false!]];
	ch mbtrail? ifTrue: [nil] ifFalse: [true]!
****Wb.Buffer >> sepr?: posArg
	self sepr0?: posArg ->:result, notNil? ifTrue: [result!];
	posArg - 1 ->:pos;
	[self sepr0?: pos ->result, nil?] whileTrue: [pos - 1 ->pos];
	result ifFalse: [pos + 1 ->pos]; 
	[pos < posArg] whileTrue: [self next: pos ->pos];
	pos = posArg!
****Wb.Buffer >> prev: pos
	pos - 1 ->pos;
	self sepr?: pos, ifFalse: [pos - 1 ->pos];
	pos!
	
***Mulk.charset = #utf8 >
****Wb.Buffer >> sepr?: pos
	self charAt: pos ->:ch;
	Mulk.newline = #crlf ifTrue:
		[ch = '\n' ifTrue: [false!]];
	ch mbtrail? not!
****Wb.Buffer >> prev: pos
	[pos - 1 ->pos;
	self sepr?: pos] whileFalse;
	pos!

**edit.
***Wb.Buffer >> reserveGap: require
	elements size ->:esize ->:nesize;
	self size ->:size;
	[nesize - size < require] whileTrue: [nesize * 2 ->nesize];
	nesize <> esize ifTrue:
		[FixedByteArray basicNew: nesize ->:nelements;
		nelements basicAt: 0 copyFrom: elements at: 0 size: gapStart;
		esize - gapEnd ->:trailsize;
		nelements basicAt: nesize - trailsize copyFrom: elements at: gapEnd
			size: trailsize;
		nelements ->elements;
		nesize - trailsize ->gapEnd]
***Wb.Buffer >> moveGap: pos
	pos = gapStart ifTrue: [self!];
	pos < gapStart
		ifTrue:
			[gapStart - pos ->:movesize;
			elements basicAt: gapEnd - movesize copyFrom: elements at: pos
				size: movesize;
			gapEnd - movesize ->gapEnd]
		ifFalse:
			[pos - gapStart ->movesize;
			elements basicAt: gapStart copyFrom: elements at: gapEnd
				size: movesize;
			gapEnd + movesize ->gapEnd];
	pos ->gapStart
***Wb.Buffer >> at: pos insert: bytes
	bytes size ->:size;
	self reserveGap: size;
	self moveGap: pos;
	elements basicAt: gapStart copyFrom: bytes at: 0 size: size;
	gapStart + size ->gapStart!
***Wb.Buffer >> at: pos remove: size
	self moveGap: pos;
	gapEnd + size ->gapEnd

**Wb.Buffer >> rangeFrom: pos until: en do: block
	pos = en ifTrue: [self!];
	self gapSize ->:gs;
	pos < en ifTrue:
		[en <= gapStart ifTrue: [block value: pos value: en value: 0!];
		pos < gapStart ifTrue:
			[block value: pos value: gapStart value: 0;
			block value: gapEnd value: en + gs value: gs!];
		block value: pos + gs value: en + gs value: gs!];
	pos < gapStart ifTrue: [block value: pos value: en value: 0!];
	en < (gapStart - 1) ifTrue:
		[block value: pos + gs value: gapEnd - 1 value: gs;
		block value: gapStart - 1 value: en value: 0!];
	block value: pos + gs value: en + gs value: gs

**search.
***Wb.Buffer >> newline
	Mulk.newline = #crlf ifTrue: ['\r'] ifFalse: ['\n']!
***Wb.Buffer >> findNewlineFrom: pos until: en
	Mulk.newline = #crlf ifTrue: ['\r' code] ifFalse: ['\n' code] ->:nl;
	self rangeFrom: pos until: en do:
		[:f :e :off
		elements indexOf: nl from: f until: e ->:result, notNil?
			ifTrue: [result - off!]];
	nil!
***Wb.Buffer >> lineHead: pos
	pos = 0 ifTrue: [0!];
	self findNewlineFrom: pos - 1 until: -1 ->pos, nil?
		ifTrue: [0] ifFalse: [self next: pos]!
***Wb.Buffer >> lineTail: pos
	self findNewlineFrom: pos until: self size!
***Wb.Buffer >> matchSize
	matchSize!
***Wb.Buffer >> find0: bytes size: sz from: pos until: en
	self rangeFrom: pos until: en do:
		[:f :e :off
		elements indexOf: bytes size: sz from: f until: e ->:result,
			notNil? ifTrue: [result - off!]];
	nil!
***Wb.Buffer >> matchVeto: mbuf at: mpos bufferAt: bpos
	mbuf size - mpos ->:sz;
	bpos + sz > self size ifTrue: [false!];
	sz timesDo:
		[:off
		mbuf at: mpos + off ->:mch;
		self byteAt: bpos + off ->:bch;
		off = 0
			ifTrue: [mch <> bch]
			ifFalse: [mch = bch], ifFalse: [false!]];
	true!
***Wb.Buffer >> find: bytes from: pos until: en
	bytes size ->:fixSize ->matchSize;
	bytes indexOf: '\cv' code ->:vpos, notNil? ifTrue:
		[vpos ->fixSize;
		matchSize - 1 ->matchSize];
	fixSize min: elements size - gapEnd ->:sentinelSize;
	self reserveGap: sentinelSize + 1;
	elements basicAt: gapStart copyFrom: elements at: gapEnd size: sentinelSize;
	elements at: gapStart + sentinelSize put: 0;
	
	en compareTo: pos ->:d;
	[pos <> en] whileTrue:
		[self find0: bytes size: fixSize from: pos until: en ->pos;
		pos nil? ifTrue: [nil!];
		self sepr?: pos,
			and: [vpos nil?
				or: [self matchVeto: bytes at: vpos + 1 bufferAt: pos + vpos]],
			ifTrue: [pos!];
		pos + d ->pos];
	nil!
***Wb.Buffer >> find: bytes before: pos
	self find: bytes from: pos until: -1!
***Wb.Buffer >> find: bytes after: pos
	self find: bytes from: pos until: self size!

**Wb.Buffer >> copyFrom: st until: en
	FixedByteArray basicNew: en - st ->:result;
	self rangeFrom: st until: en do:
		[:f :e :off
		result basicAt: f - st - off copyFrom: elements at: f size: e - f];
	result!
**Wb.Buffer >> readerFrom: st until: en
	Wb.BufferReader new init: self from: st until: en!
**Wb.Buffer >> stringFrom: st until: en
	self readerFrom: st until: en ->:rd;
	StringWriter new ->:wr;
	[rd getChar ->:ch, notNil?] whileTrue: [wr put: ch];
	wr asString!

**Wb.Buffer >> equalFrom: st until: en with: bytes
	self rangeFrom: st until: en do:
		[:f :e :off
		bytes basicAt: f - st - off unmatchIndexWith: elements at: f 
			size: e - f, nil? ifFalse: [false!]];
	true!
**Wb.Buffer >> writeFrom: st until: en toFile: fileArg
	fileArg writeDo:
		[:fs
		self rangeFrom: st until: en do:
			[:f :e :off
			fs write: elements from: f size: e - f]]
		
*Wb.Drawer class.@
	Object addSubclass: #Wb.Drawer instanceVars:
		"wb tabWidth top left width curX curY"
**Wb.Drawer >> init: wbArg top: topArg left: leftArg width: widthArg
	wbArg ->wb;
	topArg ->top;
	leftArg ->left;
	widthArg ->width;
	4 ->tabWidth
**Wb.Drawer >> width
	width!
**Wb.Drawer >> charWidth: ch
	ch = '\t'
		ifTrue: [tabWidth - (curX % tabWidth)]
		ifFalse: [ch width]!
**Wb.Drawer >> gotoCurXY
	Console gotoX: left + curX Y: top + curY
**Wb.Drawer >> drawChar0: ch
	self gotoCurXY;
	Console put: ch;
	curX + ch width ->curX
**Wb.Drawer >> drawSpaces: n 
	n timesRepeat: [self drawChar0: ' ']
**Wb.Drawer >> drawChar: ch
	self charWidth: ch ->:w;
	curX + w > width ifTrue: [false!];
	ch = '\t'
		ifTrue: [self drawSpaces: w]
		ifFalse: [self drawChar0: ch];
	true!

*Wb.Screen class.@
	Wb.Drawer addSubclass: #Wb.Screen instanceVars:
		"buffer height head leftEdges tail redrawHint redrawY"
**Wb.Screen >> init: wbArg top: topArg left: leftArg width: widthArg
		height: heightArg
	super init: wbArg top: topArg left: leftArg width: widthArg;
	wb buffer ->buffer;
	heightArg ->height;

	#init ->redrawHint;
	FixedArray basicNew: height ->leftEdges
**Wb.Screen >> width
	width!
**Wb.Screen >> height
	height!
**Wb.Screen >> firstLineLeftEdge
	head!
**Wb.Screen >> lastLineLeftEdge
	height - 1 to: 0, do:
		[:y
		leftEdges at: y ->:h, notNil? ifTrue: [h!]]
**Wb.Screen >> thruLine: pos
	0 ->curX;
	[buffer at: pos ->:ch, = buffer newline ifTrue: [buffer next: pos!];
	self charWidth: ch ->:w;
	curX + w ->curX, = width ifTrue: [buffer next: pos!];
	curX > width ifTrue: [pos!];
	buffer next: pos ->pos] loop
**Wb.Screen >> solveDisplayRange
	head ->:pos;
	buffer size ->:en;
	0 ->:y;
	leftEdges fill: nil;
	[pos < en & (y < height)] whileTrue:
		[leftEdges at: y put: pos;
		y + 1 ->y;
		self thruLine: pos ->pos];
	pos ->tail;
	#all ->redrawHint

**adjust by edit.
***Wb.Screen >> solveY: posArg
	height - 1 timesDo:
		[:y
		leftEdges at: y + 1 ->:h, nil? ifTrue: [y!];
		posArg < h ifTrue: [y!]];
	height - 1!
***Wb.Screen >> noTrailLineY?: y
	y + 1 < height ifTrue: [leftEdges at: y + 1 ->:pos];
	pos nil? ifTrue: [tail ->pos];
	buffer lineTail: (leftEdges at: y), < pos!
***Wb.Screen >> prepareSingleRedrawAt: posArg
	posArg between: head until: tail, ifFalse: [self!];
	self solveY: posArg ->:y;
	self noTrailLineY?: y, ifTrue: [y ->redrawY]
***Wb.Screen >> adjustFor: typeArg at: posArg size: sizeArg
	tail <= posArg ifTrue: [self!];
	typeArg = #insert
		ifTrue: [posArg < head]
		ifFalse: [posArg + sizeArg <= head],
	ifTrue:
		[wb adjustPos: head for: typeArg at: posArg size: sizeArg ->head;
		wb adjustPos: tail for: typeArg at: posArg size: sizeArg ->tail;
		height timesDo:
			[:y
			leftEdges at: y ->:pos, nil? ifTrue: [self!];
			wb adjustPos: pos for: typeArg at: posArg size: sizeArg ->pos;
			leftEdges at: y put: pos]!];
	wb adjustPos: head for: typeArg at: posArg size: sizeArg ->head;
	redrawHint ->:prevHint;
	self solveDisplayRange;
	prevHint = #none and: [redrawY notNil?],
		and: [self noTrailLineY?: redrawY],
		and: [typeArg = #insert or: [self solveY: posArg, = redrawY]],
		ifTrue: [#single ->redrawHint]

**locate cursor.
***Wb.Screen >> addLeftEdges: ring forLineTo: en
	buffer lineHead: en ->:pos;
	[pos <= en] whileTrue:
		[ring addNext: pos;
		ring next ->ring;
		self thruLine: pos ->pos]
***Wb.Screen >> leftEdgesRingBefore: pos lines: lines
	Ring new ->:ring;
	[ring size < lines] whileTrue:
		[self addLeftEdges: ring forLineTo: pos;
		ring first ->pos;
		pos = 0 ifTrue: [ring!];
		buffer prev: pos ->pos];
	ring!
***Wb.Screen >> updateDisplayRangeForPos: pos toLine: line
	line = 0
		ifTrue: [pos]
		ifFalse:
			[self leftEdgesRingBefore: pos lines: line + 1 ->:ring;
			ring size - line - 1 ->:excess, > 0 ifTrue:
				[excess timesRepeat: [ring removeFirst]];
			ring first] ->head;
	self solveDisplayRange
***Wb.Screen >> yOf: percent
	height * percent, asInteger!
***Wb.Screen >> centerY
	self yOf: 0.5!
***Wb.Screen >> updateDisplayRangeCentering
	self updateDisplayRangeForPos: self cursor toLine: self centerY
***Wb.Screen >> updateDisplayRangeHeading
	self updateDisplayRangeForPos: self cursor toLine: 1
***Wb.Screen >> updateDisplayRangeTailing
	self updateDisplayRangeForPos: self cursor toLine: height - 2
***Wb.Screen >> updateDisplayRangeForRedraw
	self solveCursorY ->:y;
	y = 1 ifTrue: [self updateDisplayRangeTailing!];
	y = (height - 2) ifTrue: [self updateDisplayRangeCentering!];
	self updateDisplayRangeHeading
***Wb.Screen >> updateDisplayRangeForLeap
	self validCursorPos? 
		and: [self solveCursorY between: (self yOf: 0.25) 
			and: (self yOf: 0.75)],
		ifFalse: [self updateDisplayRangeCentering]
	
**Wb.Screen >> drawLineFrom: pos
	[buffer at: pos ->:ch, = buffer newline ifTrue: [self!];
	self drawChar: ch, ifFalse: [self!];
	buffer next: pos ->pos] loop
**Wb.Screen >> drawLine: y
	0 ->curX;
	y ->curY;
	leftEdges at: y ->:pos, notNil? ifTrue: [self drawLineFrom: pos];
	self drawSpaces: width - curX
**Wb.Screen >> cursor
	wb cursorOf: self!
**Wb.Screen >> solveCursorY
	self solveY: self cursor!
**Wb.Screen >> validCursorPos?
	self cursor between: head until: tail, ifFalse: [false!];
	self solveCursorY ->:y;
	y = 0 & (head <> 0) ifTrue: [false!];
	y = (height - 1) ifTrue: [false!];
	true!
**Wb.Screen >> draw
	redrawHint = #init or: [self validCursorPos? not], ifTrue:
		[self updateDisplayRangeCentering];
	redrawHint = #all ifTrue: [height timesDo: [:y self drawLine: y]];
	redrawHint = #single ifTrue: [self drawLine: redrawY];
	#none ->redrawHint;
	nil ->redrawY
**Wb.Screen >> drawCursor
	self solveCursorY ->curY;
	0 ->curX;
	leftEdges at: curY ->:pos;
	self cursor ->:c;
	[pos < c] whileTrue:
		[curX + (self charWidth: (buffer at: pos)) ->curX;
		buffer next: pos ->pos];
	self gotoCurXY

*Wb.SpreadScreen class.@
	Wb.Screen addSubclass: #Wb.SpreadScreen instanceVars: "screenHeight"
**Wb.SpreadScreen >> init: wbArg top: topArg left: leftArg width: widthArg
		height: heightArg
	super init: wbArg top: topArg left: leftArg width: widthArg
		height: heightArg;
	heightArg // 2 ->screenHeight
**Wb.SpreadScreen >> gotoCurXY
	curX ->:x;
	curY ->:y;
	curY >= screenHeight ifTrue:
		[x + width + 1 ->x;
		y - screenHeight ->y];
	Console gotoX: left + x Y: top + y
**Wb.SpreadScreen >> centerY
	self yOf: 0.625!
**Wb.SpreadScreen >> updateDisplayRangeForLeap
	self validCursorPos? 
		and: [self solveCursorY between: (self yOf: 0.125) 
			and: (self yOf: 0.875)],
		ifFalse: [self updateDisplayRangeCentering]

*Wb.StatusBar class.@
	Wb.Drawer addSubclass: #Wb.StatusBar
**Wb.StatusBar >> draw: status
	0 ->curX ->curY;
	status notNil? ifTrue:
		[StringReader new init: status ->:rd;
		[rd getWideChar ->:ch, notNil?] whileTrue:
			[self drawChar: ch, ifFalse: [Console hit?!]]];
	curX ->:x;
	self drawSpaces: width - curX;
	Console hit?;
	x ->curX
**Wb.StatusBar >> query: prompt
	self draw: prompt;
	self gotoCurXY;
	wb fetch: true ->:result, = '\c[' ifTrue: [self error: "abort"];
	result! 
**Wb.StatusBar >> query: prompt in: acccpts
	[acccpts includes?: (self query: prompt ->:result)] whileFalse;
	result!
	
*subprocess.
**Wb.SubprocessConsole class.@
	AbstractConsole addSubclass: #Wb.SubprocessConsole
		instanceVars: "wb process receiveWriter sendString sendPos"
			+ " lastResponseTime",
		features: #(Reader Writer)
***Wb.SubprocessConsole >> init: wbArg process: processArg
	wbArg ->wb;
	processArg ->process;
	Wb.BytesStream new ->receiveWriter;
	self send: ""
***Wb.SubprocessConsole >> onActive
	OS time ->lastResponseTime
***Wb.SubprocessConsole >> send: sendArg
	sendArg ->sendString;
	0 ->sendPos
***Wb.SubprocessConsole >> receive
	receiveWriter seek: 0, contentBytes ->:result;
	receiveWriter reset;
	result!
***Wb.SubprocessConsole >> echobackLn
	receiveWriter putLn
***Wb.SubprocessConsole >> getByte
	sendString size = sendPos ifTrue:
		[process switchParent: true;
		OS time ->lastResponseTime];
	sendPos = 0 ifTrue:
		[sendString = "^c\n" ifTrue:
			[3 ->sendPos;
			process interrupt;
			'\n' code!];
		sendString = "^d\n" ifTrue:
			[3 ->sendPos;
			-1!]];
	sendString basicAt: sendPos ->:result;
	sendPos + 1 ->sendPos;
	result!
***Wb.SubprocessConsole >> putByte: byte
	byte = '\n' code ifTrue:
		[OS time <> lastResponseTime ifTrue:
			[process switchParent: false;
			OS time ->lastResponseTime]];
	receiveWriter putCharCode: byte

***console i/f.
****Wb.SubprocessConsole >> in
	self!
****Wb.SubprocessConsole >> out
	self!
****Wb.SubprocessConsole >> autoLineFeedIfLineFilled?
	true!
****Wb.SubprocessConsole >> height
	wb screen height - 1!
****Wb.SubprocessConsole >> width
	wb screen width!

**Wb.Subprocess class.@
	Process addSubclass: #Wb.Subprocess instanceVars: "running? waitInput?"
		+ " parent parentConsole parentIO"
		+ " childConsole childIO"
***Wb.Subprocess >> init: wbArg
	200 ->:gap;
	FixedArray basicNew: 1024 + gap ->frameStack;
	FixedArray basicNew: 1024 + gap ->contextStack;
	false ->running?;
	false ->waitInput?;
	Console ->parentConsole;
	self saveIO ->parentIO;
	Wb.SubprocessConsole new init: wbArg process: self ->childConsole;
	Array new addLast: childConsole in, addLast: childConsole in,
		addLast: childConsole out, addLast: childConsole out ->childIO

***accessing.
****Wb.Subprocess >> running?
	running?!
****Wb.Subprocess >> waitInput?
	waitInput?!
****Wb.Subprocess >> parentConsole
	parentConsole!
****Wb.Subprocess >> childConsole
	childConsole!

***Wb.Subprocess >> saveIO
	Array new addLast: In0, addLast: In, addLast: Out0, addLast: Out!
***Wb.Subprocess >> restoreIO: array
	array at: 0 ->In0;
	array at: 1 ->In;
	array at: 2 ->Out0;
	array at: 3 ->Out	
***Wb.Subprocess >> switchChildConsole
	childConsole ->Console;
	childConsole onActive;
	self restoreIO: childIO
***Wb.Subprocess >> switchParentConsole
	self saveIO ->childIO;
	parentConsole ->Console;
	self restoreIO: parentIO
***Wb.Subprocess >> switchParent: waitInputArg?
	waitInputArg? ->waitInput?;
	parent basicSwitch
***Wb.Subprocess >> start
	self switchChildConsole;
	self basicStart: #run:;
	self switchParentConsole
***Wb.Subprocess >> continue
	self switchChildConsole;
	self basicSwitch;
	self switchParentConsole
***Wb.Subprocess >> run: parentArg
	true ->running?;
	parentArg ->parent;
	self initExceptionHandlers interruptBlock: [self error: "interrupt"];
	[Cmd.icmd new mainLoop] finally:
		[Out putLn: "finish icmd";
		false ->running?;
		self switchParent: true]

*Wb.Operation class.@
	Object addSubclass: #Wb.Operation instanceVars: 
		"type pos contents tag mergeMode"
**Wb.Operation >> initType: typeArg pos: posArg contents: contentsArg
		tag: tagArg mergeMode: mergeModeArg
	typeArg ->type;
	posArg ->pos;
	contentsArg ->contents;
	tagArg ->tag;
	mergeModeArg ->mergeMode
**Wb.Operation >> type: reverse?
	reverse?
		ifTrue: [type = #insert ifTrue: [#remove] ifFalse: [#insert]]
		ifFalse: [type]!
**Wb.Operation >> pos
	pos!
**Wb.Operation >> contents
	contents!
**Wb.Operation >> tag
	tag!
**Wb.Operation >> mergeMode
	mergeMode!
**Wb.Operation >> merge: op
	type = #insert ifFalse: [false!];
	mergeMode >= 1 ifFalse: [false!];
	op type: false, = #insert ifFalse: [false!];
	op mergeMode = 2 ifFalse: [false!];
	pos + contents size = op pos ifFalse: [false!];
	
	FixedByteArray basicNew: contents size + op contents size ->:ncontents;
	ncontents basicAt: 0 copyFrom: contents at: 0 size: contents size;
	ncontents basicAt: contents size copyFrom: op contents at: 0
		size: op contents size;
	ncontents ->contents;
	true!
		
*Wb.Leap class.@
	Object addSubclass: #Wb.Leap instanceVars:
		"mode pos pattern firstLineLeftEdge"
**Wb.Leap >> init: leapArg
	leapArg mode ->mode;
	leapArg pos ->pos;
	leapArg pattern ->pattern
**Wb.Leap >> mode: modeArg
	modeArg ->mode
**Wb.Leap >> mode
	mode!
**Wb.Leap >> pos: posArg
	posArg ->pos
**Wb.Leap >> pos
	pos!
**Wb.Leap >> pattern: patternArg
	patternArg ->pattern
**Wb.Leap >> pattern
	pattern!
**Wb.Leap >> firstLineLeftEdge: firstLineLeftEdgeArg
	firstLineLeftEdgeArg ->firstLineLeftEdge
**Wb.Leap >> firstLineLeftEdge
	firstLineLeftEdge!

*Wb.History class.@
	Object addSubclass: #Wb.History instanceVars: "fullName offset tag"
**Wb.History >> init: fullNameArg tag: tagArg offset: offsetArg
	fullNameArg ->fullName;
	tagArg ->tag;
	offsetArg ->offset
**Wb.History >> fullName
	fullName!
**Wb.History >> offset
	offset!
**Wb.History >> tag
	tag!

*Wb.DummyConsole class.@
	AbstractConsole addSubclass: #Wb.DummyConsole instanceVars: "wb"
**Wb.DummyConsole >> init: wbArg
	wbArg ->wb
**Wb.DummyConsole >> width
	wb screen width!

*Wb.File class.@
	Object addSubclass: #Wb.File instanceVars: "wb file conv"
**Wb.File >> init: wbArg name: nameArg
	wbArg ->wb;
	nameArg indexOf: ':' ->:cpos, notNil? ifTrue:
		[nameArg copyUntil: cpos ->conv;
		nameArg copyFrom: cpos + 1 ->nameArg];
	nameArg asFile ->file
**Wb.File >> file
	file!
**Wb.File >> = wbfileArg
	file = wbfileArg file!
**Wb.File >> fullName
	file path ->:result;
	conv notNil? ifTrue: [conv + ':' +result ->result];
	result!
**Wb.File >> name
	file name!
**Wb.File >> readableFile?
	file readableFile?!
**Wb.File >> none?
	file none?!
	
**Wb.File >> contentBytes
	conv notNil? ifTrue: [file pipe: "ctr " + conv + " ==", contentBytes!];
	file contentBytes!
**Wb.File >> backup
	file none? ifTrue: [self!];
	Mulk.hostOS = #dos
		ifTrue:
			[file baseName + '.' + file suffix ->:fn;
			file suffix size = 3 ifTrue: [fn copyUntil: fn size - 1 ->fn]]
		ifFalse: [file name ->fn];
	file pipeTo: file parent + (fn + '~')
**Wb.File >> writeFocused
	conv notNil? ifTrue:
		[StringReader new init: wb focusedBytes, 
			pipe: "ctr " + conv to: file!];
	wb writeFocusedTo: file
**Wb.File >> equalFocused?
	conv notNil? ifTrue:
		[StringReader new init: wb focusedBytes, pipe: "ctr " + conv, 
			contentBytes ->:bytes;
			bytes size = file size 
				and: [bytes contentsEqual?: file contentBytes]!];
	wb equalFocusedWith: file!
**Wb.File >> fileDo: block
	conv notNil? ifTrue:
		[TempFile create ->:tmp;
		file pipe: "ctr " + conv + " ==" to: tmp;
		block value: tmp;
		tmp remove!];
	block value: file
	
*Wb.class class.@
	Mulk addTransientGlobalVar: #Wb;
	Object addSubclass: #Wb.class instanceVars:
		"width height buffer mode nextBackupTime"
		+ " screen alterScreen statusBar message drawSplitter?"
		+ " keyCodeDict cursor yank"
		+ " operatorRing operatorCount operatorMergeMode"
		+ " leapKeyCodeDict leapStartPos leapRing leapPrevPattern"
		+ " undoPosTag"
		+ " startPos endPos docMarker"
		+ " subprocess"
		+ " xDict currentTag alterTag"
		+ " abbrevPattern abbrevPos abbrevList abbrevType"
		+ " history"
		+ " macro macroRepeat"
**Wb.class >> bytes: string
	Wb.BytesStream new put: string, seek: 0, contentBytes!

**screen.
***Wb.class >> buffer
	buffer!
***Wb.class >> cursorOf: screenArg
	screen = screenArg ifTrue: [cursor] ifFalse: [xDict at: '\co']!
***Wb.class >> screen
	screen!
***Wb.class >> horizontalSplit?
	width < 161!
***Wb.class >> horizontalCenter
	height - 2 // 2!
***Wb.class >> verticalCenter
	width - 1 // 2!
***Wb.class >> setupScreen1
	self horizontalSplit?
		ifTrue:
			[Wb.Screen new init: self top: 0 left: 0
				width: width height: height - 1]
		ifFalse:
			[true ->drawSplitter?;
			Wb.SpreadScreen new init: self top: 0 left: 0
				width: self verticalCenter height: height - 1 * 2]
		->screen;
	nil ->alterScreen
***Wb.class >> drawHorizontalSplitter
	Console gotoX: 0 Y: self horizontalCenter, put: '-' times: width
***Wb.class >> drawVerticalSplitter
	screen kindOf?: Wb.SpreadScreen ->:perforate?;
	self verticalCenter ->:x;
	height - 1 timesDo:
		[:y
		y % 2 = 1 & perforate? ifTrue: [' '] ifFalse: ['|'] ->:ch;
		Console gotoX: x Y: y, put: ch]
***Wb.class >> drawSplitter
	self horizontalSplit?
		ifTrue: [alterScreen notNil? ifTrue: [self drawHorizontalSplitter]]
		ifFalse: [self drawVerticalSplitter]
***Wb.class >> setupScreen2
	self horizontalSplit?
		ifTrue:
			[self horizontalCenter ->:c;
			Wb.Screen new init: self top: c + 1 left: 0
				width: width height: height - 2 - c ->screen;
			Wb.Screen new init: self top: 0 left: 0
				width: width height: c ->alterScreen]
		ifFalse:
			[self verticalCenter ->c;
			Wb.Screen new init: self top: 0 left: c + 1
				width: c height: height - 1 ->screen;
			Wb.Screen new init: self top: 0 left: 0
				width: c height: height - 1 ->alterScreen];
	true ->drawSplitter?
***Wb.class >> redrawCommand
	screen updateDisplayRangeForRedraw;
	alterScreen notNil? ifTrue: [alterScreen solveDisplayRange];
	true ->drawSplitter?;
	Console clear
***Wb.class >> swapCursor
	cursor ->:c;
	xDict at: '\co' ->cursor;
	xDict at: '\co' put: c;
	currentTag ->:t;
	alterTag ->currentTag;
	t ->alterTag;
	cursor = self idocPromptPos ifTrue: [Console imAscii]
***Wb.class >> splitScreenCommand
	self swapCursor;
	alterScreen nil?
		ifTrue: [self setupScreen2]
		ifFalse: [self setupScreen1]
***Wb.class >> otherScreenCommand
	self swapCursor;
	alterScreen nil?
		ifTrue: [self setupScreen2]
		ifFalse:
			[alterScreen ->:s;
			screen ->alterScreen;
			s ->screen]
	
**status bar control.
***Wb.class >> message: messageArg
	message nil?
		ifTrue: [messageArg]
		ifFalse: [message + ", " + messageArg] ->message
***Wb.class >> drawStatusBar
	StringWriter new ->:wr;
	macro memberOf?: StringWriter, ifTrue: [wr put: "M"];
	currentTag notNil? ifTrue: [wr put: '[', put: currentTag, put: "] "];
	mode <> #insert ifTrue:
		[cursor < startPos ifTrue: [wr put: '<'];
		cursor >= endPos ifTrue: [wr put: '>'];
		wr put: (mode = #leapForward ifTrue: ['>'] ifFalse: ['<']);
		wr put: ' ';
		leapRing value pattern ->:pat, notNil? ifTrue:
			[pat describeOn: wr;
			wr put: ' ']];
	message notNil? ifTrue:
		[wr put: '(', put: message, put: ')';
		nil ->message];
	statusBar draw: wr asString
	
**editing.
***operate buffer.
****Wb.class >> idocPromptPos
	xDict at: '\ci'!
****Wb.class >> idocTail
	buffer lineTail: self idocPromptPos!
****Wb.class >> adjustPos: x for: typeArg at: posArg size: sizeArg
	x < posArg ifTrue: [x!];
	typeArg = #insert ifTrue: [x + sizeArg!];
	x < (posArg + sizeArg) ifTrue: [posArg!];
	x - sizeArg!
****Wb.class >> tagsAndPosesDo: blockArg
	xDict keysAndValuesDo:
		[:ch :pos
		pos kindOf?: Integer, ifTrue: [blockArg value: ch value: pos]]
****Wb.class >> adjustFor: typeArg at: posArg size: sizeArg 
		newline?: newlineArg?
	self tagsAndPosesDo:
		[:ch :pos
		ch = '\ci' and: [typeArg = #insert], and: [pos = posArg], 
				and: [newlineArg? not], ifFalse:
			[xDict at: ch put: (self adjustPos: pos for: typeArg at: posArg
				size: sizeArg)]];
	screen adjustFor: typeArg at: posArg size: sizeArg;
	alterScreen notNil? ifTrue:
		[alterScreen adjustFor: typeArg at: posArg size: sizeArg]
****Wb.class >> operate: op reverse: reverse?
	op type: reverse? ->:type;
	op pos ->:pos;
	op contents ->:contents;
	nextBackupTime nil? and: [self idocTail < pos], ifTrue:
		[OS time + 60 ->nextBackupTime];
	contents includes?: '\n' code ->:newline?, ifFalse:
		[screen prepareSingleRedrawAt: pos;
		alterScreen notNil? ifTrue: [alterScreen prepareSingleRedrawAt: pos]];
	type = #insert
		ifTrue: [buffer at: pos insert: contents ->cursor]
		ifFalse:
			[buffer at: pos remove: contents size;
			pos ->cursor];
	self adjustFor: type at: pos size: contents size newline?: newline?;
	op tag ->currentTag, notNil? ifTrue: [xDict at: currentTag put: cursor]
****Wb.class >> operateNew: type pos: pos contents: contents
	Wb.Operation new initType: type pos: pos contents: contents tag: currentTag
		mergeMode: operatorMergeMode ->:op;
	self operate: op reverse: false;
	[operatorRing next value nil?] whileFalse:
		[operatorRing next remove;
		operatorCount - 1 ->operatorCount];
	operatorRing value ->:prev, memberOf?: Wb.Operation, and: [prev merge: op],
		ifTrue: [self!];
	operatorRing addNext: op;
	operatorRing next ->operatorRing;
	operatorCount = 100
		ifTrue: [operatorRing next next remove]
		ifFalse: [operatorCount + 1 ->operatorCount]

***basic edit actions.
****Wb.class >> at: pos insert: bytes
	bytes size = 0 ifTrue: [self!];
	self operateNew: #insert pos: pos contents: bytes;
	operatorMergeMode = 1 ifTrue: [2 ->operatorMergeMode]
****Wb.class >> at: pos remove: size
	size = 0 ifTrue: [self!];
	pos + size ->:last;
	self idocTail between: pos until: last, ifTrue:
		[self error: "can't remove tag ^i"];
	last >= buffer size ifTrue: [self error: "can't remove last char"];
	self operateNew: #remove pos: pos contents:
		(buffer copyFrom: pos until: pos + size)
		
***Wb.class >> focusLine
	buffer lineHead: cursor ->startPos;
	buffer lineTail: cursor ->endPos
***Wb.class >> focusedBytes
	buffer copyFrom: startPos until: endPos!
	
***edit commands.
****Wb.class >> undoCommand
	operatorRing value ->:op, nil? ifTrue: [self!];
	operatorRing next value nil? ifTrue: [self keepUndoPos: cursor];
	self operate: op reverse: true;
	operatorRing prev ->operatorRing
****Wb.class >> redoCommand
	operatorRing next value ->:op, nil? ifTrue: [self!];
	self operate: op reverse: false;
	operatorRing next ->operatorRing
****Wb.class >> maxClipSize
	Mulk.hostOS = #android 
		ifTrue: [65536]
		ifFalse: [0xffffffff]!
****Wb.class >> yank: arg
	Clip notNil? ifTrue:
		[arg size < self maxClipSize
			ifTrue:
				[nil ->yank;
				Clip put: arg!]
			ifFalse: [Clip put: "__WB__"]];
	arg ->yank
****Wb.class >> yankCommand
	startPos nil? ifTrue: [self focusLine];
	self yank: self focusedBytes
****Wb.class >> eraseCommand
	startPos nil? 
		ifTrue:
			[self focusLine;
			buffer find: docMarker after: endPos ->:ed, notNil?
				and: [endPos = ed], 
				and: [buffer next: self idocTail, <> startPos] ->:last?;
			self yank: self focusedBytes;
			buffer next: endPos ->endPos;
			endPos - startPos ->:sz;
			last? ifTrue: [buffer prev: startPos ->startPos];
			self at: startPos remove: sz]
		ifFalse:
			[self yank: self focusedBytes;
			self at: startPos remove: endPos - startPos]
****Wb.class >> yank
	Clip notNil? ifTrue:
		[Wb.BytesStream new ->:wr;
		Clip copyTo: wr;
		wr seek: 0, contentBytes ->:result;
		result size = 6 and: [result makeStringFrom: 0 size: 6, = "__WB__"],
			ifFalse:
				[nil ->yank;
				result!]];
	yank nil? ifTrue: [self error: "yank failed"];
	yank!
****Wb.class >> wedgeCommand
	self at: cursor insert: self yank
****Wb.class >> enterCommand
	self subprocessEnter ifTrue: [self!];
	Wb.BytesStream new ->:wr;
	wr putLn;
	buffer lineHead: cursor ->:lh;
	[buffer at: lh ->:ch, = ' ' | (ch = '\t') & (lh < cursor)] whileTrue:
		[wr put: ch;
		lh + 1 ->lh];
	self at: cursor insert: (wr seek: 0, contentBytes)
****Wb.class >> insertCharCommand: ch
	self at: cursor insert: (self bytes: ch)
****Wb.class >> backspaceCommand
	cursor > 0 ifTrue:
		[buffer prev: cursor ->:prev;
		self at: prev remove: cursor - prev]

**cursor motion.
***Wb.class >> insideCurrentDoc?: posArg
	xDict at: currentTag ->:pos;
	pos < posArg
		ifTrue:
			[pos <> 0
				and: [buffer find: docMarker after: pos ->:docEnd, nil?],
				ifTrue: [true]
				ifFalse: [posArg <= docEnd]]
		ifFalse:
			[buffer find: docMarker before: pos - 1 ->:docStart, nil?
				ifTrue: [true]
				ifFalse: [posArg > docStart]]!
***Wb.class >> adjustCurrentTag
	currentTag nil? ifTrue: [self!];
	self insideCurrentDoc?: cursor,
		ifTrue: [xDict at: currentTag put: cursor]
		ifFalse: [nil ->currentTag]
***Wb.class >> keepUndoPos: posArg
	xDict at: '\xff' put: posArg;
	currentTag ->undoPosTag
***Wb.class >> leapFinish: adjustCurrentTag?
	self keepUndoPos: leapStartPos;
	#insert ->mode;
	adjustCurrentTag? ifTrue: [self adjustCurrentTag]
	
***simple motion.
****Wb.class >> nextCharCommand
	mode <> #insert ifTrue: [self leapFinish: false];
	cursor < (buffer prev: buffer size) ifTrue: [buffer next: cursor ->cursor];
	self adjustCurrentTag
****Wb.class >> prevCharCommand
	mode <> #insert ifTrue: [self leapFinish: false];
	cursor > 0 ifTrue: [buffer prev: cursor ->cursor];
	self adjustCurrentTag
****Wb.class >> nextLineCommand
	mode <> #insert ifTrue: [self leapFinish: false];
	buffer lineTail: cursor ->:pos;
	pos = cursor & (pos <> (buffer prev: buffer size)) ifTrue:
		[buffer next: pos ->pos;
		buffer lineTail: pos ->pos];
	pos ->cursor;
	self adjustCurrentTag
****Wb.class >> prevLineCommand
	mode <> #insert ifTrue: [self leapFinish: false];
	buffer lineHead: cursor ->:pos;
	pos = cursor & (pos <> 0) ifTrue:
		[buffer prev: pos ->pos;
		buffer lineHead: pos ->pos];
	pos ->cursor;
	self adjustCurrentTag
	
***leap.
****Wb.class >> leapUpdatePrevPattern: leapArg
	leapArg pattern ->:pat, notNil? ifTrue: [pat ->leapPrevPattern]
****Wb.class >> leapAdd: leapArg
	[leapRing next value notNil?] whileTrue: [leapRing next remove];
	leapArg pos: cursor;
	leapArg firstLineLeftEdge: screen firstLineLeftEdge;
	self leapUpdatePrevPattern: leapArg;
	leapRing addNext: leapArg;
	leapRing next ->leapRing
****Wb.class >> focusDocAt: pos
	buffer find: docMarker before: pos - 1 ->:st, nil? ifTrue:
		[0 ->startPos;
		buffer find: docMarker after: 0 ->:en, nil? ifTrue:
			[self error: "missing bottom mark"];
		buffer next: en ->endPos;
		#top!];
	buffer next: st ->startPos;
	buffer find: docMarker after: startPos ->en, nil? ifTrue: 
		[buffer size ->endPos;
		#bottom!];
	buffer next: en ->endPos;
	#doc!
****Wb.class >> leapStart: modeArg
	mode <> #insert ifTrue: [self leapFinish: true];
	Ring new ->leapRing;
	self focusDocAt: cursor;
	modeArg ->mode;
	cursor ->leapStartPos;
	self leapAdd: (Wb.Leap new mode: modeArg)

****Wb.class >> leapCopy
	Wb.Leap new init: leapRing value!

****Wb.class >> leapForward: leapArg disp: d
	self bytes: leapArg pattern ->:bytes;
	buffer find: bytes after: cursor + d ->:pos, notNil? ifTrue: [pos!];
	self message: "wrapped";
	buffer find: bytes from: 0 until: cursor!
****Wb.class >> leapBackward: leapArg disp: d
	self bytes: leapArg pattern ->:bytes;
	buffer find: bytes before: cursor - d ->:pos, notNil? ifTrue: [pos!];
	self message: "wrapped";
	buffer find: bytes from: buffer size - 1 until: cursor!
****Wb.class >> leap: leapArg disp: d
	self assert: leapArg pattern notNil?;
	mode = #leapForward
		ifTrue: [self leapForward: leapArg disp: d]
		ifFalse: [self leapBackward: leapArg disp: d] ->:pos;
	pos nil?
		ifTrue: ["not found" ->message {erase wrapped}]
		ifFalse:
			[pos ->cursor;
			screen updateDisplayRangeForLeap;
			self leapAdd: leapArg]
****Wb.class >> leapResume
	leapRing value ->:leap, pos ->cursor;
	leap mode ->mode;
	self leapUpdatePrevPattern: leap;
	leap firstLineLeftEdge ->:flle, <> screen firstLineLeftEdge ifTrue:
		[screen updateDisplayRangeForPos: flle toLine: 0]
****Wb.class >> focusLeapAndFinish
	mode = #insert ifTrue: [self!];
	leapStartPos < cursor
		ifTrue:
			[leapStartPos ->startPos;
			cursor ->endPos]
		ifFalse:
			[cursor ->startPos;
			leapStartPos ->endPos];
	self leapFinish: true

****leap mode commands and process.
*****Wb.class >> leapFinishCommand
	self leapFinish: true
*****Wb.class >> leapUndoCommand
	leapRing prev value notNil? ifTrue:
		[leapRing prev ->leapRing;
		self leapResume]
*****Wb.class >> leapRedoCommand
	leapRing next value notNil? ifTrue:
		[leapRing next ->leapRing;
		self leapResume]
*****Wb.class >> leapQuitCommand
	self keepUndoPos: cursor;
	leapStartPos ->cursor;
	#insert ->mode

*****Wb.class >> leapWedgeCommand
	buffer matchSize ->:remove;
	self leapFinish: true;
	self at: cursor remove: remove;
	self wedgeCommand
*****Wb.class >> leapAddPattern: ch
	leapRing value pattern ->:pat, nil?
		ifTrue:
			 [ch = '\cv' ifTrue: [self error: "set ^v to first"];
			 ch asString ->pat;
			 1 ->:d]
		ifFalse:
			[pat last = '\cv' & (ch kindOf?: WideChar) ifTrue:
				[self error: "set wide char after ^v"];
			pat + ch ->pat;
			0 ->d];
	self leapCopy ->:leap;
	leap pattern: pat;
	self leap: leap disp: d
*****Wb.class >> leapProcessChar: ch
	leapKeyCodeDict at: ch ifAbsent: [ch print? ifTrue: [#char] ifFalse: [nil]]
		->:code, nil? ifTrue: [false!];
	code = #char
		ifTrue: [self leapAddPattern: ch]
		ifFalse: [self perform: code];
	true!

****insert mode commands.
*****Wb.class >> leapForwardCommand
	mode = #leapForward and: [leapRing value pattern nil?], ifTrue:
		[screen lastLineLeftEdge ->cursor;
		screen updateDisplayRangeHeading;
		self leapAdd: (Wb.Leap new init: leapRing value)!];
	self leapStart: #leapForward
*****Wb.class >> leapBackwardCommand
	mode = #leapBackward and: [leapRing value pattern nil?], ifTrue:
		[screen firstLineLeftEdge ->cursor;
		screen updateDisplayRangeTailing;
		self leapAdd: (Wb.Leap new init: leapRing value)!];
	self leapStart: #leapBackward
*****Wb.class >> leapAgainCommand
	mode = #insert ifTrue:
		[self leapStart: #leapForward;
		leapPrevPattern notNil? ifTrue:
			[self leapCopy ->:leap, pattern: leapPrevPattern;
			self leap: leap disp: 1]!];
	self leapCopy ->leap;
	leap pattern nil? ifTrue:
		[leapPrevPattern nil? ifTrue: [self!];
		leap pattern: leapPrevPattern];
	self leap: leap disp: 1


**document management.
***Wb.class >> docHeader
	buffer stringFrom: startPos + 2 until: (buffer lineTail: startPos)!
***Wb.class >> docFile
	--note: document must be focused.
	self docHeader ->:hd;
	hd empty? or: [hd first = '*'], ifTrue: [nil!];
	hd indexOf: '<' ->:st, nil? ifTrue: [nil!];
	hd indexOf: '>' ->:en, nil? ifTrue: [nil!];
	st >= en ifTrue: [nil!];
	Wb.File new init: self name: (hd copyFrom: st + 1 until: en)!
***Wb.class >> insertDocFile
	self docHeader ->:hd;
	hd empty? or: [hd first = '*'], ifTrue: [nil!];
	Wb.File new init: self name: hd trim ->:result;
	" <" + result fullName + '>' ->:s;
	buffer lineTail: startPos ->:insPos;
	cursor ->:cpos;
	self at: insPos insert: (self bytes: s);
	endPos + s size ->endPos;
	cpos >= insPos ifTrue: [cpos + s size ->cpos];
	cpos ->cursor;
	result!
***Wb.class >> refocusContents
	buffer next: (buffer lineTail: startPos) ->startPos
***Wb.class >> keepFocusDo: block
	startPos ->:savedStart;
	endPos ->:savedEnd;
	block value;
	savedStart ->startPos;
	savedEnd ->endPos
***Wb.class >> multipleOpenCheck: wbfile
	endPos ->:currentEnd;
	self keepFocusDo:
		[self focusAllDocsDo:
			[self docFile = wbfile and: [endPos <> currentEnd],
				ifTrue: [self error: "multiple open: " + wbfile name]]]
***Wb.class >> focusedDocTags
	Array new ->:result;
	self tagsAndPosesDo:
		[:ch :pos
		pos between: startPos until: endPos, ifTrue:
			[result addLast: (Cons new car: ch cdr: pos)]];
	result sortBy: [:x :y x cdr < y cdr]!
***Wb.class >> backwardInFocus: pos
	pos >= endPos ifTrue: [endPos - 1 ->pos];
	buffer sepr?: pos, ifFalse: [buffer prev: pos ->pos];
	pos!
***Wb.class >> checkDocBytes: bytes
	bytes size ->:sz, = 0 ifTrue: [self!];
	bytes last <> '\n' code ifTrue: [self error: "missing last eol"];
	sz <> 1 and: [bytes at: sz - 2, = '\r' code], <> (Mulk.newline = #crlf) 
		ifTrue: [self error: "illegal eol type"]
***Wb.class >> readDoc: wbfile
	--must be contents marked.
	cursor ->:savedCursor;
	cursor between: startPos until: endPos ->:cursorInside?;
	self focusedDocTags ->:savedTags;
	wbfile contentBytes ->:bytes;
	self checkDocBytes: bytes;
	startPos <> endPos ifTrue: [self at: startPos remove: endPos - startPos];
	self at: startPos insert: bytes;
	startPos + bytes size ->endPos;
	cursorInside? ifTrue: [self backwardInFocus: savedCursor ->savedCursor];
	savedCursor ->cursor;
	savedTags do:
		[:cons
		xDict at: cons car put: (self backwardInFocus: cons cdr)];
	self message: "read " + wbfile name

***Wb.class >> writeFocusedTo: fileArg
	buffer writeFrom: startPos until: endPos toFile: fileArg
***Wb.class >> writeDoc: wbfile
	wbfile backup;
	wbfile writeFocused;
	self message: "write " + wbfile name
	
***Wb.class >> equalFocusedWith: fileArg
	fileArg size = (endPos - startPos) and:
		[buffer equalFrom: startPos until: endPos with: fileArg contentBytes]!
***Wb.class >> equalDoc?: wbfile
	wbfile equalFocused?!

***Wb.class >> diffDoc: wbfile
	Wb.BytesStream new ->:wr;
	wr putLn: "\n---";
	wbfile fileDo:
		[:f
		buffer readerFrom: startPos until: endPos,
			pipe: "diff -r " + f quotedPath to: wr];
	wr put: "---";
	self at: (buffer lineTail: cursor) insert: (wr seek: 0, contentBytes)

***history.
****Wb.class >> historyAt: wbfile
	history at: wbfile fullName ifAbsent: [nil]!
****Wb.class >> historyFile
	"wb.mpi" asWorkFile!
****Wb.class >> initHistory
	self historyFile ->:f, none?
		ifTrue: [Dictionary new]
		ifFalse: [f readObject] ->history
****Wb.class >> locateHistory: wbfile
	self historyAt: wbfile ->:fh, nil? ifTrue: [self!];
	self backwardInFocus: startPos + fh offset ->cursor;
	fh tag ->:tag;
	xDict includesKey?: tag,
		ifTrue: [self message: "tag " + tag describe + " already defined"]
		ifFalse:
			[tag ->currentTag;
			xDict at: tag put: cursor]
****Wb.class >> saveHistory
	self historyFile writeObject: history
****Wb.class >> updateHistory: wbfile tag: tag offset: offset
	self historyAt: wbfile ->:fh;
	fh notNil? and: [fh tag = tag], and: [fh offset = offset], ifTrue: [self!];
	wbfile fullName ->:fn;
	history at: fn put: (Wb.History new init: fn tag: tag offset: offset);
	self message: tag describe + " saved";
	self saveHistory
****Wb.class >> updateHistoryPosition: wbfile
	self historyAt: wbfile ->:fh, nil? ifTrue: [self!];
	xDict at: fh tag ifAbsent: [nil] ->:pos, kindOf?: Integer, 
		ifFalse: [self!];
	pos between: startPos until: endPos, ifFalse: [nil!];
	self updateHistory: wbfile tag: fh tag offset: pos - startPos
****Wb.class >> updateHistoryCurrentDoc: wbfile
	currentTag nil? ifTrue: [self updateHistoryPosition: wbfile!];
	cursor - startPos ->:off, < 0 ifTrue: [self!];
	self updateHistory: wbfile tag: currentTag offset: off

***Wb.class >> docCommandMain: wbfile
	self multipleOpenCheck: wbfile;
	self refocusContents;
	startPos = endPos ifTrue:
		[wbfile readableFile?
			ifTrue:
				[self readDoc: wbfile;
				self locateHistory: wbfile]
			ifFalse: [self message: wbfile name + " not exist"]!];
	self updateHistoryCurrentDoc: wbfile;
	wbfile none? ifTrue: [self writeDoc: wbfile!];
	self equalDoc?: wbfile, 
		ifTrue: [self message: wbfile name + " not changed"!];
	statusBar query: wbfile name + " changed (r/w/d/s)" in: "rwds" ->:ch;
	ch = 'r' ifTrue: [self readDoc: wbfile!];
	ch = 'w' ifTrue: [self writeDoc: wbfile!];
	ch = 'd' ifTrue: [self diffDoc: wbfile!]
***Wb.class >> docCommand
	self focusDocAt: cursor ->:pos, = #top, ifTrue: [self syncAllDocs!];
	pos <> #doc ifTrue: [self error: "not document"];
	self docFile ->:wbfile, nil? ->:insert?, ifTrue:
		[self insertDocFile ->wbfile, nil? ifTrue: 
			[self error: "file not specified"!]];
	[self docCommandMain: wbfile] on: Error do:
		[:e 
		insert? ifTrue: [self undoCommand];
		e signal]
***Wb.class >> focusAllDocsDo: block
	0 ->endPos;
	[endPos ->startPos;
	buffer find: docMarker after: startPos ->:pos, nil? ifTrue: 
		[buffer size ->endPos;
		block value!];
	buffer next: pos ->endPos;
	block value] loop
***Wb.class >> syncFocusedDoc
	self docFile ->:wbfile, nil? ifTrue: [self!];
	self refocusContents;
	self updateHistoryPosition: wbfile;
	wbfile none? or: [self equalDoc?: wbfile, not], ifFalse: [self!];
	statusBar query: wbfile name + " changed (r/w/s)?" in: "rws" ->:ch;
	ch = 'r' ifTrue: [self readDoc: wbfile!];
	ch = 'w' ifTrue: [self writeDoc: wbfile!]
***Wb.class >> syncAllDocs
	self focusAllDocsDo: [self syncFocusedDoc]

**abbrevCommand.
***#en
****Wb.class >> abbrevPatternType: ch
	ch alnum? or: [ch = '_'], ifTrue: [#ascii!];
	nil!
***#ja
****Wb.class >> abbrevPatternType: ch
	ch alnum? or: [ch = '_'], ifTrue: [#ascii!];
	ch between: 'ぁ' and: 'ん', ifTrue: [#hiragana!];
	ch between: 'ァ' and: 'ヶ', or: [ch = 'ー'], ifTrue: [#katakana!];
	ch = '々' ifTrue: [#kanji!];
	Mulk.charset = #sjis ifTrue: [ch >= '亜' ifTrue: [#kanji!]];
	Mulk.charset = #utf8 ifTrue:
		[--CJK Unified Ideographs or Extension A.
		ch code ->:code, between: 0xe4b880 and: 0xe9bfaa,
			or: [code between: 0xe39080 and: 0xe4b6b5], ifTrue: [#kanji!]];
	nil!
***Wb.class >> abbrevComplementType: ch
	self abbrevPatternType: ch ->:result, notNil? ifTrue: [result!];
	ch = '?' or: [ch = ':'], or: [ch = '.'], or: [ch = '-'], ifTrue: [#ascii!];
	nil!

***Wb.class >> abbrevPatternTypeAt: pos
	self abbrevPatternType: (buffer at: pos)!
***Wb.class >> abbrevComplementTypeAt: pos
	self abbrevComplementType: (buffer at: pos)!
***Wb.class >> abbrevAddListFrom: st until: en
	st >= en ifTrue: [false!];
	buffer copyFrom: st until: en ->:bytes;
	abbrevList anySatisfy?: [:b bytes contentsEqual?: b], ifTrue: [false!];
	abbrevList addLast: bytes;
	true!
***Wb.class >> abbrevSubprocessValid?
	abbrevPos + abbrevPattern size ->:st;
	self abbrevAddListFrom: st until: (buffer lineTail: st)!
***Wb.class >> abbrevValid?
	abbrevType = #subprocess ifTrue: [self abbrevSubprocessValid?!];
	abbrevType <> #kanji and:
		[abbrevType = (self abbrevPatternTypeAt: (buffer prev: abbrevPos))],
		ifTrue: [false!];
	abbrevPos + abbrevPattern size ->:st ->:en;
	[self abbrevComplementTypeAt: en, = abbrevType] whileTrue:
		[buffer next: en ->en];
	[buffer prev: en ->:prev;
	buffer at: prev, = '.'] whileTrue: [prev ->en];
	self abbrevAddListFrom: st until: en!
***Wb.class >> abbrevSearchBefore?
	[buffer find: abbrevPattern before: abbrevPos - 1 ->abbrevPos, nil?
		ifTrue: [false!];
	self abbrevValid?] whileFalse;
	true!
***Wb.class >> abbrevSearch?
	abbrevPos < cursor ifTrue:
		[self abbrevSearchBefore? ifTrue: [true!];
		cursor ->abbrevPos];
	[buffer find: abbrevPattern after: abbrevPos + 1 ->abbrevPos, nil?
		ifTrue: [false!];
	self abbrevValid?] whileFalse;
	true!
***Wb.class >> abbrevStart?
	cursor ->:pos;
	pos = 0 ifTrue: [false!];
	pos = self idocPromptPos ifTrue:
		[#subprocess ->abbrevType;
		buffer prev: (buffer lineHead: pos) ->abbrevPos;
		buffer copyFrom: abbrevPos until: cursor ->abbrevPattern;
		true!];
	buffer prev: pos ->pos;
	self abbrevPatternTypeAt: pos ->abbrevType, nil? ifTrue: [false!];
	abbrevType <> #kanji ifTrue:
		[[buffer prev: pos ->:prev;
		self abbrevPatternTypeAt: prev, = abbrevType] whileTrue: [prev ->pos]];
	buffer copyFrom: pos until: cursor ->abbrevPattern;
	pos ->abbrevPos;
	true!
***Wb.class >> abbrevCommand
	abbrevPattern nil?
		ifTrue:
			[self abbrevStart?
				ifTrue: [Array new ->abbrevList]
				ifFalse: [self!]]
		ifFalse: [self undoCommand];
	self abbrevSearch?
		ifTrue: [self at: cursor insert: abbrevList last]
		ifFalse: [nil ->abbrevPattern]

**Wb.class >> quitCommand
	self syncAllDocs;
	#quit ->mode

**xCommand.
***Wb.class >> xDict
	xDict!
	
***user registration key.
****Wb.class >> querySetXtr: prompt
	statusBar query: prompt ->:result;
	result between: ' ' and: '~', not | (result = '(') | (result = ')') 
		ifTrue: [self error: "unregistable char " + result describe];
	result!
****Wb.class >> invalidateActiveTag: ch
	currentTag = ch ifTrue: [nil ->currentTag];
	alterTag = ch ifTrue: [nil ->alterTag]
****Wb.class >> stringRegistCommand
	self focusLeapAndFinish;
	startPos nil? ifTrue: [self focusLine];
	self querySetXtr: "^x^y" ->:ch;
	self invalidateActiveTag: ch;
	xDict at: ch put: self focusedBytes
****Wb.class >> tagRegistCommand
	self focusLeapAndFinish;
	self querySetXtr: "^x^t" ->:ch;
	ch ->currentTag;
	xDict at: ch put: cursor

****macro.
*****Wb.class >> registeringMacroCheck
	macro notNil? ifTrue:
		[nil ->macro;
		self error: "registering macro"]
*****Wb.class >> macroRegistStartCommand
	self registeringMacroCheck;
	StringWriter new ->macro
*****Wb.class >> macroRegistEndCommand
	macro nil? ifTrue: [self error: "unregistering macro"];
	macro asString ->:s;
	s copyUntil: s size - 2 ->s; -- remove ^x)
	nil ->macro;
	self querySetXtr: "^x)" ->:ch;
	xDict at: ch put: s;
	self invalidateActiveTag: ch
*****Wb.class >> startMacro: macroArg
	self registeringMacroCheck;
	1 ->operatorMergeMode;
	StringReader new init: macroArg ->macro
*****Wb.class >> macroRepeatCommand
	statusBar query: "^x^r" ->:ch;
	xDict at: ch ->:value;
	value memberOf?: String, ifFalse: [self error: "not macro"];
	self startMacro: value;
	1 ->macroRepeat

***execCommand.
****Wb.class >> execEval
	buffer readerFrom: startPos + 1 until: endPos ->:rd;
	Wb.BytesStream new ->:wr;
	In pipe:
		[
			[self evalReader: rd ->:result, <> self
				ifTrue: [Out put: ' ', put: result describe]
			] on: Error do:
				[:e Out put: ' ', put: e message]
		] to: wr;
	wr seek: 0, contentBytes ->:bytes, size <> 0 
		ifTrue: [self at: endPos insert: bytes]
****Wb.class >> execCmd
	buffer stringFrom: startPos until: endPos ->:str;
	str includes?: '\n', ifTrue: [self error: "require single line"];
	self at: startPos remove: endPos - startPos;
	Console ->:savedConsole;
	Wb.DummyConsole new init: self ->Console;
	[str copyFrom: 1, pipeTo: (Wb.BytesStream new ->:rd)] finally:
		[savedConsole ->Console];
	rd seek: 0, contentBytes ->:bytes;
	bytes size ->:sz, <> 0 and: [bytes at: sz - 1, = '\n' code], ifTrue:
		[sz - (Mulk.newline = #crlf ifTrue: [2] ifFalse: [1]) ->sz;
		bytes copyUntil: sz ->bytes];
	self at: cursor insert: bytes
****Wb.class >> errorInsertPos: ex
	ex memberOf?: MethodCompiler.Error, ifFalse: [startPos!];
	ex file notNil? ifTrue: [startPos!];
	buffer lineHead: startPos ->:cadet;
	ex lineNo - 1 timesRepeat:
		[buffer next: (buffer lineTail: cadet) ->:pos;
		pos >= endPos ifTrue: [cadet!];
		pos ->cadet];
	cadet!
****Wb.class >> execCommand
	self focusLeapAndFinish;
	statusBar draw: "*BUSY*";
	startPos nil? ->:noMark?, ifTrue: [self focusLine];
	buffer at: startPos ->:ch, = '@' ifTrue: [self execEval!];
	ch = '!' ifTrue: [self execCmd!];
	--load command.
	startPos ->:spos;
	endPos ->:epos;
	self focusDocAt: startPos, <> #doc ifTrue: [self error: "not document"];
	self docFile ->:wbfile;
	self refocusContents;
	wbfile notNil? ifTrue:
		[self updateHistoryCurrentDoc: wbfile;
		wbfile none? or: [self equalDoc?: wbfile, not], 
			ifTrue: [self writeDoc: wbfile]
			ifFalse: [self message: wbfile name + " not changed"]];
	noMark? ifFalse:
		[spos ->startPos;
		epos ->endPos];
	buffer readerFrom: startPos until: endPos ->:rd;
	rd addNewline;
	[Loader new loadReader: rd] on: Error
		do:
			[:ex
			self at: (self errorInsertPos: ex)
				insert: (self bytes: "---" + ex message + '\n')];
	self message: "loaded"

***Wb.class >> undoPosCommand
	xDict at: '\xff' ->:pos;
	undoPosTag ->:tag;
	self keepUndoPos: cursor;
	pos ->cursor;
	tag ->currentTag

***leap reverse.
****Wb.Leap >> reverse
	mode = #leapForward ifTrue: [#leapBackward] ifFalse: [#leapForward] ->mode
****Wb.class >> leapReverseCommand
	mode = #insert ifTrue: [self!];
	self leapCopy ->:leap, pattern: nil, reverse;
	leap mode ->mode;
	self leapAdd: leap

***Wb.class >> leapStringCommand
	mode = #insert ifTrue: [self leapForwardCommand];
	statusBar query: "^x^f" ->:ch;
	xDict at: ch ->:value;
	value memberOf?: FixedByteArray, ifFalse: [self error: "not string"];
	self leapCopy ->:leap;
	leap pattern: (value makeStringFrom: 0 size: value size);
	self leap: leap disp: 1
	
***Wb.class >> gotoLineCommand
	mode = #insert ifTrue: [self error: "mark digits"];
	self focusLeapAndFinish;
	buffer stringFrom: startPos until: endPos, asInteger ->:n;
	self at: startPos remove: endPos - startPos;
	self focusDocAt: cursor, <> #doc ifTrue: [self error: "not in document"];
	startPos ->:pos;
	n timesRepeat:
		[buffer lineTail: pos ->pos;
		buffer next: pos ->pos;
		pos >= endPos ifTrue: [self error: "end of ducment"]];
	pos ->cursor

***Wb.class >> xCommand
	statusBar query: "^x" ->:ch;
	xDict at: ch ->:value;
	value memberOf?: Symbol, ifTrue: [self perform: value!];
	value memberOf?: String, ifTrue:
		[self startMacro: value;
		-1 ->macroRepeat!];
	self focusLeapAndFinish;
	value kindOf?: Integer, ifTrue:
		[self keepUndoPos: cursor;
		ch print? ifTrue: [ch] ifFalse: [nil] ->currentTag;
		ch = '\ci' ifTrue: [Console imAscii];
		value ->cursor!];
	value memberOf?: FixedByteArray, ifTrue: [self at: cursor insert: value!]

**buffer backup and session.
***Wb.class >> sessionId
	Mulk at: #Wb.sessionId ifAbsent: ["wb"]!
***Wb.class >> backupFile
	self sessionId + ".bak", asWorkFile!
***Wb.class >> runFile
	self sessionId + ".run", asWorkFile!
***Wb.class >> run?
	self runFile readableFile?!
***Wb.class >> run: flagArg
	flagArg <> self run? ifTrue:
		[flagArg 
			ifTrue: [self runFile openWrite close] 
			ifFalse: [self runFile remove]]
***Wb.class >> focusBackupDocs
	buffer next: self idocTail ->startPos;
	buffer next: (buffer find: docMarker before: buffer size - 1) ->endPos
***Wb.class >> backup
	nil ->nextBackupTime;
	self keepFocusDo:
		[self focusBackupDocs;
		self run: (startPos <> endPos ->:doBackup?);
		doBackup? ifTrue:
			[buffer writeFrom: startPos until: endPos toFile: self backupFile]]
***Wb.class >> backupRecover
	self backupFile ->:bf, readableFile? ifTrue:
		[buffer at: (buffer next: self idocTail) insert: bf contentBytes];
	self focusAllDocsDo:
		[self docFile ->:wbfile;
		wbfile notNil? and: [self historyAt: wbfile ->:fh, notNil?], ifTrue:
			[self refocusContents;
			xDict at: fh tag put: startPos + fh offset]]

**subprocess.
***Wb.class >> subprocessReceive
	1 ->operatorMergeMode;
	[self at: cursor insert: subprocess childConsole receive;
	screen updateDisplayRangeTailing;
	subprocess waitInput?] whileFalse:
		[screen draw;
		subprocess continue];
	0 ->operatorMergeMode;
	xDict at: '\ci' put: cursor;	
	subprocess running? ifFalse: [nil ->subprocess]
***Wb.class >> subprocessStart
	xDict at: '\ci' put: cursor;
	Wb.Subprocess new init: self ->subprocess;
	subprocess start;
	self subprocessReceive
***Wb.class >> subprocessEnter
	subprocess nil? ifTrue: [false!];
	self idocPromptPos ->:st;
	buffer lineTail: st ->:en;
	cursor between: st and: en, ifFalse: [false!];
	en ->cursor;
	buffer stringFrom: st until: en ->:s;
	subprocess childConsole send: s + '\n';
	subprocess childConsole echobackLn;
	statusBar draw: "*BUSY*";
	subprocess continue;
	self subprocessReceive;
	true!

**Wb.class >> init: opArg
	Console width ->width;
	Console height ->height;
	Wb.Buffer new ->buffer;
	buffer at: 0 insert: (self bytes: "||TOP\n\n||BOTTOM\n");
	self setupScreen1;
	Wb.StatusBar new init: self top: height - 1 left: 0 width: width - 1 
		->statusBar;
	nil ->message;
	0 ->operatorMergeMode;
	Ring new ->operatorRing;
	0 ->operatorCount;
	Dictionary new ->keyCodeDict;
	Dictionary new ->leapKeyCodeDict;
	#(	'\c@'	#abbrevCommand			nil
		'\ca'	#leapAgainCommand		#leapAgainCommand
		'\cb'	#leapBackwardCommand	#leapBackwardCommand
		--'\cc'	interrupt				
		'\cd'	#docCommand				nil
		'\ce'	#eraseCommand			nil
		'\cf'	#leapForwardCommand		#leapForwardCommand
		'\cg'	nil						#leapFinishCommand
		'\ch'	#backspaceCommand		nil
		'\ci'	#char					#char --tab
		'\n'	#enterCommand			#char --lf/jim hiragana
		--'\ck'	jim katakana
		--'\cl' jim latin
		--'\cm' enter convert to ^j
		'\cn'	#nextCharCommand		#nextCharCommand
		'\co'	#otherScreenCommand		nil
		'\cp'	#prevCharCommand		#prevCharCommand
		'\cq'	#prevLineCommand		#prevLineCommand
		'\cr'	#redoCommand			#leapRedoCommand
		'\cs'	#splitScreenCommand		nil
		'\ct'	#abbrevCommand			nil
		'\cu'	#undoCommand			#leapUndoCommand
		'\cv'	#redrawCommand			#char --leap veto
		'\cw'	#wedgeCommand			#leapWedgeCommand
		'\cx'	#xCommand				#xCommand
		'\cy'	#yankCommand			nil
		'\cz'	#nextLineCommand		#nextLineCommand
		'\c['	#quitCommand			#leapQuitCommand
		) ->:ar;
	0 until: ar size by: 3, do:
		[:i
		ar at: i ->:ch;
		ar at: i + 1 ->:code, notNil? ifTrue: [keyCodeDict at: ch put: code];
		ar at: i + 2 ->code, notNil? ifTrue:
			[leapKeyCodeDict at: ch put: code]];
	self bytes: "\n||" ->docMarker;
	Dictionary new ->xDict;
	#(	'\cx'	#execCommand
		'\ct'	#tagRegistCommand
		'\cu'	#undoPosCommand
		'\cy'	#stringRegistCommand
		'('		#macroRegistStartCommand
		')'		#macroRegistEndCommand
		'\cr'	#macroRepeatCommand
		
		'\cz'	#leapReverseCommand
		'\cf'	#leapStringCommand
		'\cg'	#gotoLineCommand
		) ->ar;
	0 until: ar size by: 2, do:
		[:i2
		xDict at: (ar at: i2) put: (ar at: i2 + 1)];
	self initHistory;
	buffer next: (buffer lineTail: 0) ->cursor;
	xDict at: '\co' put: cursor;
	screen updateDisplayRangeCentering; -- for subprocess inserts prompt.
	self subprocessStart;
	self ->Wb;
	-- option
	opArg at: 'I' ->:opt, nil? 
		ifTrue: ["wbi.m" asWorkFile]
		ifFalse:
			[opt = "-" ifTrue: [nil] ifFalse: [opt asFile]] ->:iFile;
	iFile notNil? and: [iFile readableFile?], ifTrue: [Mulk loadFile: iFile];
	opArg at: 'R', or: [self run?], ifTrue: [self backupRecover];
	#quit ->mode

**Wb.class >> macroAgain?
	macroRepeat = -1 ifTrue: [false!];
	macroRepeat - 1 ->macroRepeat, <> 0 ifTrue: [true!];
	statusBar draw: "again(sp/0-9/other)?";
	screen drawCursor;
	Console rawFetch ->:ch;
	self drawStatusBar;
	screen drawCursor;
	ch = ' ' ifTrue:
		[1 ->macroRepeat;
		true!];
	ch digit? ifTrue:
		[ch = '0' ifTrue: [100] ifFalse: [ch asDecimalValue * 10] 
			->macroRepeat;
		true!];
	false!
**Wb.class >> fetch: raw?
	macro kindOf?: StringReader, ifTrue:
		[macro getWideChar ->:result, nil? ifTrue:
			[self macroAgain?
				ifTrue:
					[1 ->operatorMergeMode;
					macro seek: 0;
					macro getWideChar ->result]
				ifFalse:
					[nil ->macro;
					0 ->operatorMergeMode]]];
	result nil? ifTrue:
		[raw? 
			ifTrue: [Console rawFetch]
			ifFalse: [Console fetch] ->result];
	macro kindOf?: StringWriter, ifTrue: [macro put: result];
	result!
**Wb.class >> processChar: ch -- ch can be WideChar
	mode = #insert
		ifTrue: [nil ->startPos]
		ifFalse:
			[self leapProcessChar: ch,
				ifTrue: [self!]
				ifFalse: [self focusLeapAndFinish]];
	keyCodeDict at: ch ifAbsent: [ch print? ifTrue: [#char] ifFalse: [nil]]
		->:code;
	code <> #abbrevCommand ifTrue: [nil ->abbrevPattern];
	code = #char ifTrue: [self insertCharCommand: ch!];
	code notNil? ifTrue: [self perform: code]
**Wb.class >> mainLoop: opArg
	opArg at: 'd' ->:debug?;
	opArg at: 'r', ifTrue: [#quit ->mode];
	mode <> #quit ifTrue: [self error: "wb is running"];
	self focusBackupDocs;
	self run: startPos <> endPos;
	true ->drawSplitter?;
	#insert ->mode;
	screen solveDisplayRange;
	alterScreen notNil? ifTrue: [alterScreen solveDisplayRange];
	Console clear;

	[mode <> #quit] whileTrue:
		[drawSplitter? ifTrue: 
			[self drawSplitter;
			false ->drawSplitter?];
		self drawStatusBar;
		alterScreen notNil? ifTrue: [alterScreen draw];
		screen draw;
		screen drawCursor;
		self fetch: false ->:ch;
		ch = '\r' ifTrue: ['\n' ->ch]; -- CR -> insert newline.
		debug?
			ifTrue: [self processChar: ch]
			ifFalse:
				[[self processChar: ch] on: Error do:
					[:e
					statusBar draw: e message;
					statusBar gotoCurXY;
					Console rawFetch]];
		nextBackupTime notNil? 
			and: [ch = '\cd' or: [mode = #quit], 
				or: [OS time > nextBackupTime]], 
			ifTrue: [self backup]];
	Console gotoX: 0 Y: height - 1, imAscii;
	Out putLn;
	self run: false

**subcommands.
***wb.d.
****Wb.class >> markOfTag: cons file: wbfile
	wbfile nil?
		or: [self historyAt: wbfile ->:fh, nil?],
		or: [fh tag <> cons car], 
		ifTrue: [' '!];
	cons cdr < 0 ifTrue: ['?'!];
	cons cdr = fh offset ifTrue: ['='!];
	'*'!
****Wb.class >> main.d: args
	self focusAllDocsDo:
		[self docHeader ->:hd;
		hd = "" ifTrue: ["(noname)" ->hd];
		self docFile ->:wbfile;
		startPos ->:markerTop;
		self refocusContents;
		startPos ->:docTop;
		wbfile nil?
			ifTrue: [Out put: "  "]
			ifFalse:
				[wbfile none? or: [self equalDoc?: wbfile, not],
					ifTrue: [Out put: "* "]
					ifFalse: [Out put: "= "]];
		Out putLn: hd;
		markerTop ->startPos;
		self focusedDocTags
			select: [:cons cons car print?],
			do:
				[:cons2
				cons2 cdr: cons2 cdr - docTop;
				Out put: "\t",
					put: (self markOfTag: cons2 file: wbfile),
					put: ' ',
					put: cons2 car describe,
					put: ' ',
					put: cons2 cdr,
					putLn]]

***Wb.class >> main.h: args
	OptionParser new init: "f" ->:op, parse: args ->args;
	op at: 'f' ->:file?;
	history do:
		[:fh
		file? 
			ifTrue: [Out put: fh fullName]
			ifFalse:
				[Out put: fh tag, put: " <", put: fh fullName, put: "> "];
		Out putLn]
		
***Wb.class >> main.rmh: args
	args empty? ifTrue: [In contentLines] ifFalse: [args], do: 
		[:fn 
		Wb.File new init: self name: fn ->:wbfile;
		history removeAt: wbfile fullName];
	self saveHistory
	
***wb.x.
****Wb.class >> stringSummary: value
	Out put: '"';
	LimitableStringWriter new ->:wr;
	StringReader new init: value ->:rd;
	[[rd getWideChar ->:ch, notNil?] whileTrue: [ch printEscapedOn: wr]]
	on: LimitableStringWriterOverrun
	do:
		[:e
		wr limit: 512;
		wr put: "..."];
	Out put: wr asString, put: '"'
****Wb.class >> macroSummary: value
	Out put: "M " + value describe
****Wb.class >> tagSummary: value
	self focusDocAt: value ->:type, = #top, ifTrue: [Out put: "TOP"!];
	type = #bottom ifTrue: [Out put: "BOTTOM"!];
	type = #doc ifTrue: [Out put: self docHeader]
****Wb.class >> xList
	xDict keysAndValuesDo:
		[:ch :value
		ch print? & (value memberOf?: Symbol) not ifTrue:
			[Out put: ch, put: ' ';
			value kindOf?: Integer,
				ifTrue: [self tagSummary: value]
				ifFalse:
					[value memberOf?: FixedByteArray,
						ifTrue: [self stringSummary: value]
						ifFalse: [self macroSummary: value]];
			Out putLn]]
****Wb.class >> tagOf: tagName
	xDict at: tagName first ->:result, kindOf?: Integer, ifFalse:
		[self error: "illegal tag " + tagName];
	result!
****Wb.class >> putBytes: arg
	Wb.BytesStream new write: arg, seek: 0, pipe: "cat" to: Out
****Wb.class >> main.x: args
	args empty? ifTrue: [self xList!];
	
	args size = 1
		ifTrue:
			[xDict at: args first first ->:first, kindOf?: FixedByteArray,
					ifTrue: [self putBytes: first!];
			self focusDocAt: (self tagOf: args first), = #bottom
				ifTrue: [self error: "tag point to bottom"];
			self refocusContents;
			buffer readerFrom: startPos until: endPos]
		ifFalse:
			[buffer readerFrom: (self tagOf: args first) 
				until: (self tagOf: (args at: 1))],
		pipe: "cat" to: Out

***Wb.class >> main.w: args
	self putBytes: self yank
	
*wb tool.@
	Object addSubclass: #Cmd.wb
**Cmd.wb >> main: args
	OptionParser new init: "iI:Rdr" ->:op, parse: args ->args;
	(op at: 'i') | (op at: 'I', notNil?) | (op at: 'R') ifTrue: [nil ->Wb];
	Wb nil? ifTrue: [Wb.class new init: op];
	Wb mainLoop: op
	
**Cmd.wb >> main.d: args
	Wb main.d: args
**Cmd.wb >> main.h: args
	Wb main.h: args
**Cmd.wb >> main.rmh: args
	Wb main.rmh: args
**Cmd.wb >> main.x: args
	Wb main.x: args
**Cmd.wb >> main.w: args
	Wb main.w: args
