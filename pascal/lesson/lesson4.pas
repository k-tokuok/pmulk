program Lesson4;
(* $Id: mulk/pascal lesson4.pas 1505 2025-12-29 Mon 20:00:53 kt $ *)
  var
    v,x:real;
    h,m:integer;
  function round(x:real):integer;
    begin
      round:=trunc(x+0.5)
    end;
begin
  write('時速?'); readln(v);
  write('距離(km)?'); readln(x);
  h:=trunc(x/v);
  m:=round((x/v-h)*60);
  writeln(h,'時間',m,'分')
end.
