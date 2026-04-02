program internalSort(input,output);
(* $Id: mulk/pascal p71.pas 1540 2026-02-11 Wed 21:09:07 kt $ *)
const maxIndex=10000;
type
  index=1..maxIndex;
  vector=array[index] of integer;
var
  a:vector;
  n:0..maxIndex;
  i:index;
  
  procedure swap(i,j:integer);
  var w:integer;
  begin
    w:=a[i]; a[i]:=a[j]; a[j]:=w
  end;
  
  procedure quickSort(left,right:index);
  var
    s:integer;
    l,r:integer;
  begin
    s:=a[(left+right) div 2];
    l:=left; r:=right;
    repeat
      while a[l]<s do l:=l+1;
      while a[r]>s do r:=r-1;
      if l<=r then begin
        swap(l,r);
        l:=l+1; r:=r-1
      end
    until l>r;
    if left<r then quickSort(left,r);
    if l<right then quickSort(l,right)
  end;
  
begin
  n:=0;
  while not eof do begin
    n:=n+1; readln(a[n])
  end;
  quickSort(1,n);
  for i:=1 to n do writeln(a[i])
end.
