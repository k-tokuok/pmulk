pseudo file system
$Id: mulk pfs.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja 疑似ファイルシステム

*[man]
**#en
.caption DESCRIPTION
Defines abstract classes for pseudo file systems.
**#ja
.caption 説明
擬似ファイルシステム用の抽象クラス群を定義する。

*File overwrite.
**@
	Mulk addGlobalVar: #File.mount, set: Dictionary new
**File >> relative: nameArg
	self assert: nameArg empty? not;
	nameArg = "." ifTrue: [self!];
	nameArg = ".." ifTrue: [parent!];
	
	self root?
		ifTrue:
			[File.mount at: nameArg ifAbsent: [self class]]
		ifFalse: [self class],
		new initParent: self name: nameArg!
		
*PseudoFile class.@
	File addSubclass: #PseudoFile
**PseudoFile >> chdir
	--just set File.current
	self assert: self directory?;
	self ->File.current
**PseudoFile >> openError: modeArg
	self error: self describe + " openMode: " + modeArg + " failed."

*PseudoFileStream class.@
	AbstractMemoryStream addSubclass: #PseudoFileStream
		instanceVars: "file update?"
**PseudoFileStream >> putByte: byteArg
	super putByte: byteArg;
	true ->update?
**PseudoFileStream >> write: bufArg from: fromArg size: sizeArg
	super write: bufArg from: fromArg size: sizeArg;
	true ->update?
