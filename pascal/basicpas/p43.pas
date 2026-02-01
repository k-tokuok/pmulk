program listPrimes(input,output);
(* $Id: mulk/pascal p43.pas 1529 2026-01-21 Wed 21:17:30 kt $ *)
const maxArray=1000;
type integerSet=array [2..maxArray] of boolean;
var
  candidates:integerSet;
  n,min,count,j:integer;
begin
  writeln('与えられた数n未満の素数を列挙します。');
  write('n(<',maxArray:1,')?'); readln(n);
  if n>=maxArray then writeln('数が大きすぎます。')
  else if n<=1 then writeln('素数はありません。')
  else begin
    for j:=2 to n do candidates[j]:=true;
    count:=0; min:=2;
    while min<>n do begin
      count:=count+1;
      write(min:5);
      if count mod 10=0 then writeln;      
      j:=min;
      while j<n do begin
        candidates[j]:=false;
        j:=j+min;
      end;
      repeat min:=min+1 until candidates[min]
    end;
    writeln
  end
end.
