program Lesson8;
(* $Id: mulk/pascal lesson8.pas 1505 2025-12-29 Mon 20:00:53 kt $ *)
var a,n,s:integer;
begin
  write('n='); readln(n);
  s:=0;
  for a:=1 to n do s:=s+a;
  writeln('1+...+',n,'=',s)
end.
