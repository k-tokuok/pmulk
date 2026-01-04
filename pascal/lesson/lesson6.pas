program Lesson6;
(* $Id: mulk/pascal lesson6.pas 1505 2025-12-29 Mon 20:00:53 kt $ *)
var a,b,d,x1,x2:real;
begin
  writeln('x^2+ax+b=0');
  write('a='); readln(a);
  write('b='); readln(b);
  d:=a*a-4*b;
  if d>=0 then 
    begin
      x1:=(-a-sqrt(d))/2;
      x2:=(-a-sqrt(d))/2;
      writeln(x1);
      writeln(x2);
    end
  else writeln('実根はありません')
end.
