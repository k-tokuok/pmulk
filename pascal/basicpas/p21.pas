program whatIsIt(input,output);
(* $Id: mulk/pascal p21.pas 1519 2026-01-12 Mon 18:19:22 kt $ *)
var a,b,c:integer;
begin
  writeln('100までの数を考えてください。');
  write('3で割った余りは?'); readln(a);
  write('5で割った余りは?'); readln(b);
  write('7で割った余りは?'); readln(c);
  writeln('その数は ',(70*a+21*b+15*c) mod 105:1,' ですね。')
end.
