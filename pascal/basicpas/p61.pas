program characterCounts(output,prd);
(* $Id: mulk/pascal p61.pas 1532 2026-01-30 Fri 20:58:38 kt $ *)
const
  maxcount=10000;
type
  index='a'..'z';
  count=0..maxcount;
var
  c:char;
  a:array[index] of count;
  line,total: count;
  
  function isLower(c:char):boolean;
  begin
    isLower:=('a'<=c) and (c<='z')
  end;

  function toLower(c:char):char;
  begin
    if ('A'<=c) and (c<='Z') then toLower:=chr(ord(c)-ord('A')+ord('a'))
    else toLower:=c
  end;
  
begin
  writeln('テキストフィルの中の文字を調べます。');
  for c:='a' to 'z' do a[c]:=0;
  line:=0; total:=0;
  while not eof(prd) do begin
    while not eoln(prd) do begin
      read(prd,c); c:=toLower(c);
      if isLower(c) then begin
        a[c]:=a[c]+1;
        total:=total+1
      end
    end;
    read(prd,c); line:=line+1
  end;
  writeln;
  writeln('    行数:',line:5);
  writeln('英字総数:',total:5);
  writeln;
  writeln('英字  個数      率(%)');
  for c:='a' to 'z' do writeln(c:4,' ',a[c]:5,' ',a[c]/total*100:10)
end.
