ascii code table
$Id: mulk asctable.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja ASCIIコード表

*[man]
**#en
.caption SYNOPSIS
	asctable [-8]
	asctable.ctrl -- Display a list of control characters.
.caption DESCRIPTION
Display the ASCII code table.
.caption OPTION
	8 -- Display 8-bit code range	
**#ja
.caption 書式
	asctable [-8]
	asctable.ctrl -- 制御文字一覧を表示する。
.caption 説明
ASCIIコード表を表示する。
.caption オブション
	8 -- 8bitのコード範囲を表示する
	
*asctable tool.@
	Mulk import: "optparse";
	Object addSubclass: #Cmd.asctable
**Cmd.asctable >> main: args
	OptionParser new init: "8" ->:op, parse: args ->args;
	op at: '8', ifTrue: [0xff] ifFalse: [0x7f] ->:end;
	Out putLn: "    0 1 2 3 4 5 6 7 8 9 a b c d e f";
	0 to: end, do:
		[:code
		code % 0x10 = 0 ifTrue:
			[Out put: code asHexString width: 2, put: "  "];
		code asChar ->:ch;
		Out put: (ch print? ifTrue: [ch] ifFalse: ['.']);
		Out put: (code % 0x10 = 0xf ifTrue: ['\n'] ifFalse: [' '])]
**->Cmd.asctable.ctrl
	DEC	HEX	CTR	ESC	SYM	
	--------------------------------
	0	00	^@	-	NUL
	1	01	^A	-	SOH
	2	02	^B	-	STX
	3	03	^C	-	ETX	interrupt
	4	04	^D	-	EOT	eof
	5	05	^E	-	ENQ
	6	06	^F	-	ACK
	7	07	^G	\a	BEL
	8	08	^H	\b	BS	backspace
	9	09	^I	\t	HT	tab
	10	0A	^J	\n	LF
	11	0B	^K	\v	VT
	12	0C	^L	\f	FF	form feed
	13	0D	^M	\r	CR	enter
	14	0E	^N	-	SO
	15	0F	^O	-	SI
	16	10	^P	-	DLE
	17	11	^Q	-	DC1	XON
	18	12	^R	-	DC2
	19	13	^S	-	DC3	XOFF
	20	14	^T	-	DC4
	21	15	^U	-	NAK
	22	16	^V	-	SYN
	23	17	^W	-	ETB
	24	18	^X	-	CAN
	25	19	^Y	-	EM
	26	1A	^Z	-	SUB
	27	1B	^[	\e	ESC	escape
	28	1C	^\	-	FS
	29	1D	^]	-	GS
	30	1E	^^	-	RS
	31	1F	^_	-	US
	127	7F	-	-	DEL	delete
**Cmd.asctable >> main.ctrl: args
	Out put: Cmd.asctable.ctrl
