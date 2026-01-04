program Lesson14;
(* $Id: mulk/pascal lesson14.pas 1513 2026-01-03 Sat 20:59:52 kt $ *)
var a,b,d:integer;

  function gcd(a,b:integer):integer;
  var r:integer;
  begin
    if b>a then
      begin
        r:=a; a:=b; b:=r
      end;
    repeat
      r:=a mod b;
      a:=b;
      b:=r
    until b=0;
    gcd:=a
  end;
  
begin
  write('分子='); readln(a);
  write('分母='); readln(b);
  d:=gcd(a,b);
  a:=a div d; b:=b div d;
  writeln(a,'/',b)
end.
