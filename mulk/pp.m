preprocessor
$Id: mulk pp.m 1593 2026-05-02 Sat 20:59:30 kt $
#ja プリプロセッサ

*[man]
**#en
.caption SYNOPSIS
	pp switches...
.caption DESCRIPTION
A preprocessor that allows you to control output on a line-by-line basis.

The following control statements can be used:

  	.if cond
  	.elseif cond
  	.else
  	.end -- Toggles the output of the range delimited by the conditions.

	.set switch -- Sets the switch.

Here,
  	cond = '~'? switch ('|' '~'? switch)*
  	switch = [a-zA-Z][a-zA-Z0-9]*

'~' denotes negation, and '|' denotes logical OR.**#ja
**#ja
.caption 書式
	pp switches...
.caption 説明
行単位で出力内容を制御出来るプリプロセッサ。

以下の制御行が使用出来る。

	.if cond
	.elseif cond
	.else
	.end -- 条件によって区切られた範囲の出力を切り替える。

	.set switch -- switchを設定する。

ここで、
	cond = '~'? switch ('|' '~'? switch)*
	switch = [a-zA-Z][a-zA-Z0-9]*

'~'は否定を、'|'は論理和を意味する。

*pp tool.@
	Object addSubclass: #Cmd.pp instanceVars: "ln reader cmds switches"
**Cmd.pp >> init
	Dictionary new ->cmds;
	cmds at: ".if" put: #if;
	cmds at: ".elseif" put: #elseif;
	cmds at: ".else" put: #else;
	cmds at: ".end" put: #end;
	cmds at: ".set" put: #set;

	Set new ->switches
**Cmd.pp >> getLn
	In getLn ->ln;
	ln nil? ifTrue: [#eof!];
	ln head?: '.', ifTrue:
		[AheadReader new init: ln ->reader;
		reader getToken ->:token;
		cmds includesKey?: token, ifTrue: [cmds at: token!]];
	#none!
**Cmd.pp >> lex
	reader skipSpace;
	reader nextChar ->:ch, nil? ifTrue: [ch!];
	ch = '~' | (ch = '|') ifTrue:
		[reader skipChar;
		ch!];
	ch alpha? ifTrue:
		[reader resetToken;
		[reader nextChar ->ch, notNil? and: [ch alnum?]] whileTrue: 
			[reader getChar];
		reader token!];
	self error: "illegal char " + ch		
**Cmd.pp >> switch?
	[self lex ->:tk, = '~' ->:not?, ifTrue: [self lex ->tk];
	self assert: (tk kindOf?: String);
	switches includes?: tk, <> not?, ifTrue: [true!];
	self lex = '|'] whileTrue;
	false!
**Cmd.pp >> skipLines
	[self getLn ->:st;
	st = #else | (st = #elseif) | (st = #end) ifTrue: [st!];
	st = #if ifTrue:
		[[self skipLines = #end] whileFalse;
		nil ->st];
	st = #eof ifTrue: [self error: "skipLines reaches eof"]] loop
**Cmd.pp >> cmdIf
	false ->:done?;
	self switch?
		ifTrue:
			[true ->done?;
			self doLines]
		ifFalse: [self skipLines] ->:st;

	[done? not & (st = #elseif)] whileTrue:
		[self switch?
			ifTrue:
				[true ->done?;
				self doLines]
			ifFalse: [self skipLines] ->st];

	done? not & (st = #else) ifTrue: [self doLines ->st];

	[st <> #end] whileTrue: [self skipLines ->st]
**Cmd.pp >> cmdSet
	switches add: reader getToken
**Cmd.pp >> doLines
	[self getLn ->:st;
	st = #if ifTrue: [self cmdIf; nil ->st];
	st = #set ifTrue: [self cmdSet; nil ->st];
	st = #none ifTrue: [Out putLn: ln; nil ->st];
	st notNil? ifTrue: [st!]] loop
**Cmd.pp >> main: args
	switches addAll: args;
	self doLines <> #eof ifTrue: [self error: "illegal control"]
