program Histogram(input,output);
(* $Id: mulk/pascal p41.pas 1527 2026-01-18 Sun 20:52:36 kt $ *)
const
  scale1='区分 1    5   10   15   20   25';
  scale2='-----|----|----|----|----|----|';
  maxArray=50;
  maxMark=100;
  maxRank=10;
type
  mark=0..maxMark;
  markTable=array[1..maxArray] of mark;
  count=0..maxArray;
  rank=0..maxRank;
  countTable=array[rank] of count;
var
  x:markTable;
  n,i:count;
  d:integer;
  sum, sumSqr, average,variance:real;
  v:real;
  c:countTable;
  r:rank;
begin
  writeln('成績を順に入力(最後は負の数)してください。');
  n:=0; sum:=0; sumSqr:=0;
  write('成績[',n+1:1,']='); readln(d);
  while d>=0 do begin
    n:=n+1; x[n]:=d;
    sum:=sum+d; sumSqr:=sumSqr+sqr(d);
    write('成績[',n+1:1,']='); readln(d)
  end;
  average:=sum/n;
  variance:=sqrt((sumSqr-sqr(sum)/n)/(n-1));
  writeln;
  writeln('番号',' ':2,'素点',' ':2,'偏差値',' ':2,'評点');
  for i:=1 to n do begin
    write(i:4,x[i]:6);
    v:=(x[i]-average)/variance*10+50;
    write(v:8,' ':3);
    if v>=70 then writeln('A')
    else if v>=60 then writeln('B')
    else if v>=50 then writeln('C')
    else if v>=40 then writeln('D')
    else writeln('F')
  end;
  writeln('平均:',average:5,'+/-',variance:5);
  for r:=0 to maxRank do c[r]:=0;
  for i:=1 to n do begin
    r:=x[i] div 10;
    c[r]:=c[r]+1
  end;
  writeln; writeln(scale1); writeln(scale2);
  for r:=0 to maxRank do begin
    if r<maxRank then write(10*r:2,'-',10*r+9:2,'|')
    else write(maxMark:5,'|');
    for i:=1 to c[r] do write('*');
    writeln
  end;
  writeln(scale2)
end.
