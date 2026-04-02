program recurFibo(output);
(* $Id: mulk/pascal p75.pas 1541 2026-02-13 Fri 21:50:00 kt $ *)
var x:integer;

  function fibonacci(i:integer):integer;
  begin
    if i=0 then fibonacci:=0
    else if i=1 then fibonacci:=1
    else fibonacci:=fibonacci(i-1)+fibonacci(i-2)
  end;
  
begin
  for x:=0 to 20 do writeln('fib(',x,')=',fibonacci(x))
end.
