program Lesson11;
(* $Id: mulk/pascal lesson11.pas 1507 2025-12-31 Wed 20:58:41 kt $ *)
var a,n,amax:integer;
begin
  write('2以上の整数を入力してください '); readln(n);
  amax:=trunc(sqrt(n));
  if n mod 2=0 then
    begin
      if n=2 then writeln(n,'は素数です。')
      else writeln(n,'は素数ではありません。')
    end
  else
    begin
      a:=3;
      while (n mod a<>0) and (a<=amax) do a:=a+2;
      if (n mod a = 0) and (n>a) then writeln(n,'は素数ではありません。')
      else writeln(n,'は素数です')
    end
end.
