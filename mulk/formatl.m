text formatting for LibreOffice
$Id: mulk formatl.m 1615 2026-06-18 Thu 21:19:44 kt $
#ja LibreOfficeテキスト整形

*[man]
**#en
.caption SYNOPSIS
	formatl [OPTION] [FILE]
.caption DESCRIPTION
Reads a document file in the "format" format from standard input and generates a document file for LibreOffice Writer.

If the FILE is omitted, the system will treat it as if "noname.odt" had been specified.
.caption OPTION
	t TEMPLATE -- Specifies the TEMPLATE file. If not specified, the system uses formatl.ott from the system directory.
.caption SEE ALSO
.summary format
**#ja
.caption 書式
	formatl [OPTION] [FILE]
.caption 説明
標準入力よりformat形式の文書ファイルを読み込み、LibreOffice Writer用の文書ファイルを生成する。

出力ファイル名を省略するとnoname.odtが指定されたものと見做す。
.caption オプション
	t テンプレート -- テンプレートファイルを指定する。未指定時はシステムディレクトリのformatl.ottを使用する。
.caption 関連項目
.summary format

*import.@
	Mulk import: "formato"

*->Cmd.formatl.prologue
# -*- coding: utf-8 -*-
import sys
import uno
from com.sun.star.beans import PropertyValue

desktop = None
dispatcher = None
frame = None
doc = None
toc = None
text = None
cursor = None

def get_desktop():
    local_context = uno.getComponentContext()
    resolver = local_context.getServiceManager().createInstanceWithContext(
        "com.sun.star.bridge.UnoUrlResolver", local_context
    )
    try:
        context = resolver.resolve("uno:socket,host=localhost,port=2002;urp;StarOffice.ComponentContext")
        return context.getServiceManager().createInstanceWithContext(
            "com.sun.star.frame.Desktop", context
        )
    except Exception as e:
        print("LibreOffice connection failed.", file=sys.stderr)
        return None

def exec_uno(command, args_list):
    pv_args = []
    for i in range(0, len(args_list), 2):
        pv = PropertyValue()
        pv.Name = args_list[i]
        pv.Value = args_list[i+1]
        pv_args.append(pv)
    dispatcher.executeDispatch(frame, f".uno:{command}", "", 0, tuple(pv_args))

def insertLineBreak():
    exec_uno("InsertPara", [])

def insertText(str, tm, rm):
    cursor.ParaStyleName = "Text body"
    cursor.ParaLeftMargin = int(rm * 185)
    cursor.ParaFirstLineIndent = int((tm - rm) * 185)
    text.insertString(cursor, str, False)
    insertLineBreak()

def insertTitle(str):
    cursor.ParaStyleName = "Title"
    text.insertString(cursor, str, False)
    insertLineBreak()
	
def insertCaption(str):
    cursor.ParaStyleName = "Heading"
    text.insertString(cursor, str, False)
    insertLineBreak()

def insertOutline(str, level):
    cursor.ParaStyleName = f"Heading {level}"
    text.insertString(cursor, str, False)
    insertLineBreak()

def paraAdjust(name):
    cursor.ParaAdjust=uno.Enum("com.sun.star.style.ParagraphAdjust",name)
    
def insertRightAlign(str):
    paraAdjust("RIGHT")
    text.insertString(cursor, str, False)
    insertLineBreak()
    paraAdjust("LEFT")

def insertCenterAlign(str):
    paraAdjust("CENTER")
    text.insertString(cursor, str, False)
    insertLineBreak()
    paraAdjust("LEFT")

def insertPageBreak():
    exec_uno("InsertBreak", ["Kind", 3])

def insertIndex():
    global toc
    try:
        toc = doc.createInstance("com.sun.star.text.ContentIndex")
        if not toc:
            print("Failed to create ContentIndex instance.", file=sys.stderr)
            return

        toc.setPropertyValue("CreateFromOutline", True)

        text.insertTextContent(cursor, toc, False)
        
    except Exception as e:
        print(f"Error inserting TOC: {e}", file=sys.stderr)

desktop = get_desktop()
if not desktop: sys.exit(1)
    
*formatl tool.@
	Format.Office addSubclass: #Cmd.formatl
**Cmd.formatl >> init
	super init;
	"formatl.ott" asSystemFile ->templateFile;
	"noname.odt" asFile ->docFile
**Cmd.formatl >> url: file
	StringWriter new ->:s;
	s put: "\"file:///";
	StringReader new init: file hostPath ->:r;
	[r getWideChar ->:ch, notNil?] whileTrue:
		[ch = '\\' ifTrue: ['/' ->ch];
		s put: ch];
	s put: '\"', asString!
**Cmd.formatl >> makeScript
	Out putLn: Cmd.formatl.prologue;
	Out putLn: "doc = desktop.loadComponentFromURL(" + (self url: templateFile)
		+ ", \"_blank\", 0, tuple())";
	Out putLn: "text = doc.getText()";
	Out putLn: "cursor = text.createTextCursor()";
	Out putLn: "controller = doc.getCurrentController()";
	Out putLn: "frame = controller.getFrame()";
	Out putLn: "dispatcher = uno.getComponentContext().getServiceManager().createInstance(\"com.sun.star.frame.DispatchHelper\")";

	self process;
	index? ifTrue: [Out putLn: "toc.update()"];

	Out putLn: "exec_uno(\"SaveAs\", [\"URL\", " + (self url: docFile) + ", \"FilterName\", \"writer8\"])";
	Out putLn: "doc.close(True)";
	Out putLn: "desktop.terminate()"
**Cmd.formatl >> writeTitle: buf
	Out put: "insertTitle(";
	self putString: buf;
	Out putLn: ")"
**Cmd.formatl >> writeCaption: buf
	Out put: "insertCaption(";
	self putString: buf;
	Out putLn: ")"
**Cmd.formatl >> main: args
	super main: args;

	Mulk.hostOS = #windows ifTrue:
		[OS fileFromHostPath: (OS getenv: "ProgramFiles"), 
			+ "LibreOffice/program" ->:progpath;
		"start \"soffice\" " + (progpath + "soffice") quotedHostPath 
			+ " --accept=\"socket,host=localhost,port=2002;urp;\"" ->:cmd;
		OS system: cmd;
		2 sleep;
		In pipe: [self makeScript], pipe: "ctr = u=", 
			pipe: "os -io " + (progpath + "python") quotedHostPath!];
			
	Mulk.hostOSUnix? ifTrue:
		["soffice --accept=\"socket,host=localhost,port=2002;urp;\" &" ->cmd;
		OS system: cmd;
		2 sleep;
		In pipe: [self makeScript], pipe: "os -io python3"!];
		
	self error: "unsupported"
