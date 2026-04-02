program characterArrangement(input,output);
(* $Id: mulk/pascal p23.pas 1540 2026-02-11 Wed 21:09:07 kt $ *)
var a,b,c:char;
begin
  writeln('2つの文字の間にある文字を調べます。');
  write('最初の文字:'); readln(a);
  write('最後の文字:'); readln(b);
  for c:=a to b do writeln('''',c,'''(',ord(c):1,')')
end.
