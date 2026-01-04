program Lesson10;
(* $Id: mulk/pascal lesson10.pas 1507 2025-12-31 Wed 20:58:41 kt $ *)
const n=10;
var 
  a:array[1..n] of integer;
  h,s,t,v:real;
  i,x:integer;
begin
  for i:=1 to n do readln(a[i]);
  s:=0;
  for i:=1 to n do s:=s+a[i];
  h:=s/n;
  t:=0;
  for i:=1 to n do t:=t+sqr(a[i]-h);
  v:=sqrt(t/n);
  writeln(h,v)
end.
