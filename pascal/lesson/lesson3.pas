program Lesson3;
(* $Id: mulk/pascal lesson3.pas 1505 2025-12-29 Mon 20:00:53 kt $ *)
var a,b,wa,sa,seki,shou,amari:integer;
begin
  write('a='); readln(a);
  write('b='); readln(b);
  wa:=a+b;
  sa:=a-b;
  seki:=a*b;
  shou:=a div b;
  amari:=a mod b;
  writeln('a+b=',wa);
  writeln('a-b=',sa);
  writeln('a*b=',seki);
  writeln('a div b=',shou);
  writeln('a mod b=',amari)
end.
