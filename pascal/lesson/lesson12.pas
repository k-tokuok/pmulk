program Lesson12;
(* $Id: mulk/pascal lesson12.pas 1508 2026-01-01 Thu 21:32:38 kt $ *)
var a,b,r:integer;
begin
  write('a='); readln(a);
  write('b='); readln(b);
  if b>a then
    begin
      r:=a; a:=b; b:=r
    end;
  repeat
    r:=a mod b; a:=b; b:=r
  until b=0;
  writeln('最大公約数は',a)
end.
