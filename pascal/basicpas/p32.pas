program calendar(input,output);
(* $Id: mulk/pascal p32.pas 1525 2026-01-17 Sat 15:25:38 kt $ *)
var
  year: 1582..9999; month: 1..12;
  y: 1581..9998; m:3..14;
  firstDayOfWeek, dayOfWeek: 0..6;
  day: 1..31; lastDay: 28..31;
begin
  writeln('その月のカレンダを書きます。');
  write('年?'); readln(year);
  write('月?'); readln(month);
  if month<3 
    then begin y:=year-1; m:=month+12 end
    else begin y:=year; m:=month end;
  firstDayOfWeek:=(y+(y div 4)-(y div 100)+(y div 400)
    +((13*m+8) div 5)+1) mod 7;
  case month of
    3,5,7,8,10,12,1: lastDay:=31;
    4,6,9,11: lastDay:=30;
    2:
      if ((year mod 4=0) and not(year mod 100 = 0)) or (year mod 400=0)
      then lastDay:=29
      else lastDay:=28
  end;
  writeln;
  writeln(' ':10,'---',year:4,'/',month:2,'---');
  writeln('  SUM  MON  TUE  WED  THU  FRI  SAT');
  for dayOfWeek:=0 to firstDayOfWeek-1 do write(' ':5);
  for day:=1 to lastDay do
    begin
      write(day:5);
      if (day+firstDayOfWeek) mod 7=0 then writeln
    end;
  writeln
end.
