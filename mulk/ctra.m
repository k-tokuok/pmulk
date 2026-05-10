CodeTranslator.a class
$Id: mulk ctra.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Android implementation of CodeTranslator class.
.caption SEE ALSO
.summary ctrlib
**#ja
.caption 説明
CodeTranslator classのAndroid実装。
.caption 関連項目
.summary ctrlib

*CodeTranslator.a class.@
	Android method: #ctr signature: "ISSIB";
	CodeTranslator addSubclass: #CodeTranslator.a instanceVars: "fromTo"
**CodeTranslator.a >> init: fromToArg
	fromToArg ->fromTo
**CodeTranslator.a >> translate: bufArg from: fromArg size: sizeArg
	self reserve: sizeArg;
	fromArg <> 0 ifTrue: 
		[bufArg copyFrom: fromArg until: fromArg + sizeArg ->bufArg];
	Android call: #ctr with: fromTo with: bufArg with: sizeArg with: resultBuf!
