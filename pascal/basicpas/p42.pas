program integerEquation(input,output);
(* $Id: mulk/pascal p42.pas 1528 2026-01-20 Tue 22:05:23 kt $ *)
const
  minX=0; maxX=50;
  minY=0; maxY=50;
var
  table:array[minX..maxX,minY..maxY] of integer;
  a,b,c,k,x,y:integer;
begin
  writeln('ax^2+bxy+cy^2=kの解を',minX:1,'<=x<=',maxX:1,',',minY:1,'<=y<=',
    maxY:1,'の範囲で求めます。');
  write('a,b,c(>=0)は?'); readln(a,b,c);
  
  for x:=minX to maxX do
    for y:=minY to maxY do table[x,y]:=a*sqr(x)+b*x*y+c*sqr(y);
  
  writeln('k>0を入力する限り解を求めます');
  write('k?'); readln(k);
  while k>0 do begin
    x:=minX; y:=maxY;
    while (x<=maxX) and (y>=minY) do begin
      if table[x,y]<k then x:=x+1
      else if table[x,y]=k then 
        begin
          writeln('x=',x:1,' y=',y:1);
          x:=x+1; y:=y-1;
        end
      else y:=y-1
    end;
    write('k?'); readln(k)
  end
end.
