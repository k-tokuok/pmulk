program e(output);
(* $Id: mulk/pascal p53.pas 1531 2026-01-25 Sun 20:39:09 kt $ *)
const n=5; eps=1.0e-5;
var
  s,t: real;
  i: integer;
begin
  s:=1.0; t:=1.0; i:=0;
  while t>eps do begin
    t:=t/(i+1);
    s:=s+t;
    i:=i+1
  end;
  writeln('e=',s:n+3)
end.
