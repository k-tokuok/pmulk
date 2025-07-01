calendar
$Id: mulk cal.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja カレンダー

*[man]
**#en
.caption SYNOPSIS
	cal [[YEAR] MONTH]
.caption DESCRIPTION
Display the calendar for the specified year and month.

If the year and month are omitted, it is considered that the current year and month are specified.
**#ja
.caption 書式
	cal [[YEAR] MONTH]
.caption 説明
指定年月のカレンダーを表示する。

年、月を省略すると現在の年、月が指定されたものと見做す。

*cal tool.@
	Object addSubclass: #Cmd.cal
**Cmd.cal >> main: args
	DateAndTime new initNow ->:dt;
	dt year ->:year;
	dt month ->:month;

	args size = 1 ifTrue: [args at: 0, asInteger ->month];

	args size = 2 ifTrue:
		[args at: 0, asInteger ->year;
		args at: 1, asInteger ->month];

	DateAndTime new initYear: year month: month day: 1 ->dt;

	Out putLn: (dt asString copyUntil: 7);
	Out putLn: "Su Mo Tu We Th Fr Sa";

	dt dayWeek ->:dw;
	Out putSpaces: dw * 3;
	1 to: dt monthDay, do:
		[:d
		Out put: d width: 2, put: ' ';
		dw + 1 ->dw;
		dw = 7 ifTrue: [Out putLn; 0 ->dw]];
	Out putLn
