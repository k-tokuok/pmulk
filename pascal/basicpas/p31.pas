program averageAndVariance(input,output);
(* $Id: mulk/pascal p31.pas 1524 2026-01-15 Thu 20:36:24 kt $ *)
var
  n:integer;
  weight,sum,sumSqr:real;
begin
  writeln('体重を順に入力してください(最後に0を入力すること)。');
  n:=0; sum:=0; sumSqr:=0;
  write('体重>'); readln(weight);
  while weight>0 do 
    begin
      n:=n+1;
      sum:=sum+weight; sumSqr:=sumSqr+sqr(weight);
      write('体重>'); readln(weight)
    end;
  writeln('    平均:',sum/n:10);
  writeln('標準偏差:',sqrt((sumSqr-sqr(sum)/n)/(n-1)):10)
end.
