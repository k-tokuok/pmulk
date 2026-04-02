program recurFibo(output);
(* $Id: mulk/pascal p76.pas 1541 2026-02-13 Fri 21:50:00 kt $ *)
var x:integer;

  function fibonacci(i:integer):integer;
  var a,b,w,n:integer;
  begin
    a:=0; b:=1; n:=0;
    while n<>i do begin
      w:=b;
      b:=a+b;
      a:=w;
      n:=n+1
    end;
    fibonacci:=a
  end;
  
begin
  for x:=0 to 20 do writeln('fib(',x,')=',fibonacci(x))
end.
