program angleOfTwoVectors(input,output);
(* $Id: mulk/pascal p51.pas 1530 2026-01-24 Sat 21:17:55 kt $ *)
const
  n=3;
  pi=3.14159265; d=180;
type vector=array[1..n] of real;
var
  x,y: vector;
  lx, ly, lxy, c, r: real;
  
  procedure readVector(var x: vector);
  var i: 1..n;
  begin
    for i:=1 to n do begin
      write('[', i:1, ']'); readln(x[i]);
    end
  end;
  
  procedure writeVector(x: vector);
  var i: 1..n;
    begin
    write('(');
    for i:=1 to n-1 do write(x[i]:10, ',');
    write(x[n]:10, ')')
  end;
  
  procedure innerProduct(x, y: vector; var lxy: real);
  var i: 1..n;
  begin
    lxy:=0;
    for i:=1 to n do lxy:=lxy+x[i]*y[i]
  end;
  
  procedure length(x: vector; var lx: real);
  begin
    innerProduct(x, x, lx); lx:=sqrt(lx)
  end;
  
begin
  writeln('2つのベクトルのなす角を計算します。');
  writeln('第1のベクトルを入力してください。');
  readVector(x);
  writeln('第2のベクトルを入力してください。');
  readVector(y);
  length(x, lx); length(y, ly); innerProduct(x, y, lxy);
  if lx*ly=0.0 then r:=pi/2.0
  else begin
    c:=lxy/(lx*ly);
    if c=-1.0 then r:=pi
    else r:=arctan(sqrt((1.0-c)/(1.0+c)))*2.0
  end;
  writeVector(x); writeln('と');
  writeVector(y); writeln('の');
  writeln('なす角は',r*d/pi:7,'度です。')
end.
