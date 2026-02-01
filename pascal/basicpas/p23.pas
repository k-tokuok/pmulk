program characterArrangement(input,output);
(* $Id: mulk/pascal p23.pas 1523 2026-01-14 Wed 05:53:08 kt $ *)
var a,b,c:char;
begin
  writeln('2つの文字の間にある文字を調べます。');
  write('二つの文字?'); read(a); read(b);
  for c:=a to b do writeln('''',c,'''(',ord(c):1,')')
end.
