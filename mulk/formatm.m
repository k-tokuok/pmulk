text formatting for MS-Word
$Id: mulk formatm.m 1615 2026-06-18 Thu 21:19:44 kt $
#ja MS-Wordテキスト整形

*[man]
**#en
.caption SYNOPSIS
	formatl [OPTION] [FILE]
.caption DESCRIPTION
Reads a document file in the "format" format from standard input and generates a document file for MS-Word.

If the FILE is omitted, the system will treat it as if "noname.docx" had been specified.
.caption OPTION
	t TEMPLATE -- Specifies the TEMPLATE file. If not specified, the system uses formatm.dotx from the system directory.
.caption SEE ALSO
.summary format
**#ja
.caption 書式
	formatm [OPTION] [FILE]
.caption 説明
標準入力よりformat形式の文書ファイルを読み込み、MS-Word用の文書ファイルを生成する。

出力ファイル名を省略するとnoname.docxが指定されたものと見做す。
.caption オプション
	t テンプレート -- テンプレートファイルを指定する。未指定時はシステムディレクトリのformatm.dotxを使用する。
.caption 関連項目
.summary format
.caption 制限事項
python処理系及びpywin32パッケージが必須。

*import.@
	Mulk import: "formato"

*->Cmd.formatm.prologue
# -*- coding: utf-8 -*-
import sys
import time
import win32com.client

word = None
doc = None

def get_word():
    try:
        return win32com.client.gencache.EnsureDispatch("Word.Application")
    except Exception as e:
        print(f"Word connection failed: {e}", file=sys.stderr)
        return None

def insertLineBreak():
    word.Selection.TypeParagraph()

def insertText(text, tm, rm):
    word.Selection.TypeText(text)
    insertLineBreak()
    if tm < rm:
        li = tm / 2.0
        fli = (tm - rm) / 2.0
    else:
        li = rm / 2.0
        fli = tm / 2.0
    
    para = doc.Paragraphs(doc.Paragraphs.Count - 1)
    para.Format.CharacterUnitLeftIndent = li
    para.Format.CharacterUnitFirstLineIndent = fli

def insertOutline(text, level):
    word.Selection.TypeText(text)
    word.Selection.Style = doc.Styles(getattr(win32com.client.constants,f"wdStyleHeading{level}"))
    insertLineBreak()

def insertRightAlign(text):
    word.Selection.TypeText(text)
    insertLineBreak()
    wdAlignParagraphRight = 2
    doc.Paragraphs(doc.Paragraphs.Count - 1).Format.Alignment = wdAlignParagraphRight

def insertCenterAlign(text):
    word.Selection.TypeText(text)
    insertLineBreak()
    wdAlignParagraphCenter = 1
    doc.Paragraphs(doc.Paragraphs.Count - 1).Format.Alignment = wdAlignParagraphCenter

def insertPageBreak():
    wdPageBreak = 7
    word.Selection.InsertBreak(wdPageBreak)

def insertIndex():
    doc.TablesOfContents.Add(word.Selection.Range)
    
word = get_word()
if not word:
    sys.exit(1)

word.Visible = True

*->Cmd.formatm.epilogue
word.Quit()
word = None
time.sleep(1)

*formatm tool.@
	Format.Office addSubclass: #Cmd.formatm
**Cmd.formatm >> init
	super init;
	"formatm.dotx" asSystemFile ->templateFile;
	"noname.docx" asFile ->docFile
**Cmd.formatm >> wpath: file
	StringWriter new ->:w;
	StringReader new init: file hostPath ->:r;
	[r getWideChar ->:ch, notNil?] whileTrue:
		[ch == '\\' ifTrue: ['/' ->ch];
		w put: ch];
	w asString!
**Cmd.formatm >> makeScript
	Out putLn: Cmd.formatm.prologue;
	Out putLn: "doc = word.Documents.Add(\"" + (self wpath: templateFile) 
		+ "\")";
	super process;
	index? ifTrue: [Out putLn: "doc.TablesOfContents(1).Update()"];
	Out putLn: "doc.SaveAs(\"" + (self wpath: docFile) + "\")";
	Out putLn: Cmd.formatm.epilogue
**Cmd.formatm >> main: args
	super main: args;
	In pipe: [self makeScript], pipe: "ctr = u | os -io python"
