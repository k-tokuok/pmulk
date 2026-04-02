win32 api wrapper
$Id: mulk win32.m 1559 2026-03-20 Fri 21:53:31 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
A wrapper for the Win32 API.
It primarily provides functions related to GUI events.
**#ja
.caption 説明
Win32APIのwrapper。
主にGUIイベント関連の機能を提供する。

*import.@
	Mulk import: #("dl" "math");
	Mulk addGlobalVar: #Win32
*import api calls.@
	DL import: "kernel32" procs: #(
		#GetCurrentProcessId 0
		#SetConsoleTitleA 101
		#GetConsoleTitleA 102);
	DL import: "user32" procs: #(
		#FindWindowA 102
		#SetForegroundWindow 101
		#GetWindowRect 102
		#GetSystemMetrics 101
		#SendInput 103)
	
*Win32.Rect class.@
	DL.Struct addSubclass: #Win32.Rect
**Win32.Rect >> init
	super init;
	super init: 16
**Win32.Rect >> left
	Win32 pixelScale: (buffer i32At: 0)!
**Win32.Rect >> top
	Win32 pixelScale: (buffer i32At: 4)!
**Win32.Rect >> right
	Win32 pixelScale: (buffer i32At: 8)!
**Win32.Rect >> bottom
	Win32 pixelScale: (buffer i32At: 12)!
**Win32.Rect >> width
	self right - self left!
**Win32.Rect >> height
	self bottom - self top!
	
*Win32.Input class.@
	DL.Struct addSubclass: #Win32.Input
**Win32.Input >> init
	super init: 40

**mouse input.
***Win32.Input >> mouse: flagArg
	buffer i32At: 0 put: 0 {INPUT_MOUSE};
	buffer i32At: 20 put: flagArg
***Win32.Input >> moveX: xArg Y: yArg
	self mouse: 0x8001 {MOVE+ABSOLUTE};
	buffer i32At: 8 put: xArg;
	buffer i32At: 12 put: yArg
***Win32.Input >> ldown
	self mouse: 0x2
***Win32.Input >> lup
	self mouse: 0x4
	
**keyboard input.
***Win32.Input >> keybd: flagArg vk: vkArg
	buffer i32At: 0 put: 1 {INPUT_KEYBORD};
	buffer i16At: 8 put: vkArg;
	buffer i32At: 12 put: flagArg
***Win32.Input >> keydown: vkArg
	self keybd: 0 vk: vkArg
***Win32.Input >> keyup: vkArg
	self keybd: 2 {KEYUP} vk: vkArg

*Win32.class class.@
	Object addSubclass: #Win32.class instanceVars: "screenFactor vkDict"
**[man.c]
***#en
A class that defines Win32.

Win32 is a global object and must not be reconstructed.
***#ja
Win32を定義するクラス。

Win32はグローバルオブジェクトであり、再構築してはならない。

**Win32.class >> init
	100 ->screenFactor;
	Dictionary new ->vkDict;
	#(	#ctrl	0x11
		#down	0x28
		'V'		0x56
		) ->:table;
	0 until: table size by: 2, do:
		[:i vkDict at: (table at: i) put: (table at: i + 1)]
**Win32.class >> screenFactor: arg
	arg ->screenFactor
**Win32.class >> pixelScale: arg
	arg * screenFactor // 100!

**Win32.class >> foreground: hWnd
	DL call: #SetForegroundWindow with: hWnd
***[man.m]
****#en
Bring the window with hWnd to the front and give it focus.
****#ja
hWndのウィンドウを再前面に表示しフォーカスする。

**Win32.class >> getWindowRect: hWnd
	Win32.Rect new ->:result;
	DL call: #GetWindowRect with: hWnd with: result ->:st;
	st = 0 ifTrue: [self error: "Win32.class >> getWindowRect: failed"];
	result!
**Win32.class >> cxscreen
	self pixelScale: (DL call: #GetSystemMetrics with: 0 {SM_CXSCREEN})!
**Win32.class >> cyscreen
	self pixelScale: (DL call: #GetSystemMetrics with: 1 {SM_CYSCREEN})!
**Win32.class >> sendInput: inputArg
	DL call: #SendInput with: 1 with: inputArg with: 40
**Win32.class >> sleep
	0.1 sleep
	
**mouse input.
***Win32.class >> moveX: xArg Y: yArg
	self sendInput: 
		(Win32.Input new moveX: (xArg * 65535 / self cxscreen) asInteger
			Y: (yArg * 65535 / self cyscreen) asInteger)
****[man.m]
*****#en
Move the pointer of the pointing device to (xArg, yArg).
*****#ja
ポインティグデバイスのポインタを(xArg,yArg)に移動する。

***Win32.class >> clickX: xArg Y: yArg
	self moveX: xArg Y: yArg;
	self sleep;
	self sendInput: Win32.Input new ldown;
	self sleep;
	self sendInput: Win32.Input new lup;
	self sleep
****[man.m]
*****#en
Click at the (xArg, yArg) position on the screen.
*****#ja
画面上の(xArg,yArg)の位置でクリックする。

***Win32.class >> dragX: x0arg Y: y0arg X: x1arg Y: y1arg
	(x1arg - x0arg) sqr + (y1arg - y0arg) sqr, sqrt ->:len;
	x1arg - x0arg / len ->:dx;
	y1arg - y0arg / len ->:dy;
	
	self moveX: x0arg Y: y0arg;
	self sleep;
	self sendInput: Win32.Input new ldown;
	100 ->:t;
	[t < len] whileTrue:
		[self moveX: x0arg + (dx * t) Y: y0arg + (dy * t);
		self sleep;
		t + 100 ->t];
	self moveX: x1arg Y: y1arg;
	self sendInput: Win32.Input new lup;
	self sleep
****[man.m]
*****#en
Drag the pointer from (x0arg, y0arg) to (x1arg, y1arg).
*****#ja
ポインタを(x0arg,y0arg)から(x1arg,y1arg)までドラッグする。

**keyboard.
***Win32.class >> keyin: arg
	vkDict at: arg ->:vk;
	self sendInput: (Win32.Input new keydown: vk);
	self sendInput: (Win32.Input new keyup: vk)
****[man.m]
*****#en
Send the following key press event.
	#down -- Down arrow
*****#ja
次のキー入力イベントを送信する。
	#down -- 下矢印
	
***Win32.class >> ctrlv
	vkDict at: #ctrl ->:c;
	vkDict at: 'V' ->:v;
	self sendInput: (Win32.Input new keydown: c);
	self sendInput: (Win32.Input new keydown: v);
	self sendInput: (Win32.Input new keyup: v);
	self sendInput: (Win32.Input new keyup: c)
****[man.m]
*****#en
Send the ^v key event.
*****#ja
^vキーイベントを送信する。

**Win32.class >> consoleWindow
	FixedByteArray basicNew: 256 ->:oldname;
	DL call: #GetConsoleTitleA with: oldname with: oldname size;
	"mulk-" + (DL call: #GetCurrentProcessId) ->:name;
	DL call: #SetConsoleTitleA with: name;
	0.1 sleep;
	DL call: #FindWindowA with: 0 with: name ->:result;
	DL call: #SetConsoleTitleA with: oldname;
	result!	
***[man.m]
****#en
Returns the handle value of the current console window.
****#ja
現在のコンソールウィンドウのハンドル値を返す。

*@
	Win32.class new screenFactor: 125 ->Win32
