set/refer system dictionary value
$Id: mulk set.m 1604 2026-05-23 Sat 21:30:16 kt $
#ja システム辞書の値を設定／参照する

*[man]
**#en
.caption SYNOPSIS
	set KEY [VALUE]
	set.home [HOME] -- Sets the HOME directory (~). If omitted, the OS's default directory is used.
.caption DESCRIPTION
Set the String VALUE for the element KEY in the system dictionary (Mulk).
If VALUE is omitted, the current value is displayed.
**#ja
.caption 書式
	set KEY [VALUE]
	set.home [HOME] -- ホームディレクトリ(~)を設定する。省略するとOSの標準的なディレクトリが設定される。
.caption 説明
システム辞書(Mulk)の要素KEYに値文字列VALUEを設定する。
VALUEを省略すると、現在の値を表示する。

*Cmd.set tool.@
	Object addSubclass: #Cmd.set 
**Cmd.set >> main: args
	args first asSymbol ->:key;
	Mulk at: key ifAbsent: [nil] ->:value;
	args size = 1 
		ifTrue: 
			[value kindOf?: GlobalVar, ifTrue: [value get ->value];
			Out putLn: value]
		ifFalse: 
			[args at: 1 ->:nvalue;
			value kindOf?: GlobalVar, 
				ifTrue: [value set: nvalue]
				ifFalse: [Mulk at: key put: nvalue]]
**Cmd.set >> main.home: args
	args empty? ifFalse: [args first asFile ->:home];
	Mulk.hostOSUnix? ifTrue: [OS getenv: "HOME", asFile ->home];
	Mulk.hostOS = #windows ifTrue:
		[OS fileFromHostPath: (OS getenv: "USERPROFILE") ->home];
	home notNil? ifTrue: [home ->File.home]
