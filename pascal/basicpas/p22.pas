program tableOfTrigonometricFunctions(input,output);
(* $Id: mulk/pascal p22.pas 1521 2026-01-13 Tue 06:01:14 kt $ *)
const
  pi=3.141592653;
  d=180;
var
  i:integer;
  x0,x1,delta:real;
  x,s,c:real;

begin
  writeln('sin(x), cos(x)の数表(度)を作ります。');
  write('xの下限?'); readln(x0);
  write('xの上限?'); readln(x1);
  write('刻み?'); readln(delta);
  writeln(' ':3,'x',' ':8,'sin',' ':12,'cos',' ':6,'sin^2+cos^2');
  for i:=0 to trunc((x1-x0)/delta) do 
    begin
      x:=x0+i*delta;
      s:=sin(x*pi/d);
      c:=cos(x*pi/d);
      writeln(x:5,s:15,c:15,sqr(s)+sqr(c):15)
    end
end.
