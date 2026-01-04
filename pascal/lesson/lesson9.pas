program Lession9;
(* $Id: mulk/pascal lesson9.pas 1506 2025-12-30 Tue 21:11:19 kt $ *)
var a,b,c,n:integer;
begin
  write('n='); readln(n);
  for a:=1 to n do
    for b:=a to n do
      for c:=b to n do
        if a*a+b*b=c*c then writeln(a,b,c)
end.
