program e(output);
(* $Id: mulk/pascal p54.pas 1531 2026-01-25 Sun 20:39:09 kt $ *)
const
  base=10;
  maxDigit=9;
  n=50;
  nn=55;
type
  digit=0..maxDigit;
  position=-nn..0;
  fraction=array[position] of digit;
var 
  s,t: fraction;
  i: integer;

  procedure setf(var x: fraction; v:integer);
  var i: position;
  begin
    for i:=-nn to -1 do x[i]:=0;
    x[0]:=v;
  end;
  
  procedure divf(var x: fraction; v:integer);
  var i:position; r:integer;
  begin
    r:=0;
    for i:=0 downto -nn do begin
      r:=r*base+x[i];
      x[i]:=r div v;
      r:=r mod v
    end
  end;
  
  procedure addf(var x: fraction; var y: fraction);
  var i: position; c: integer;
  begin
    c:=0;
    for i:=-nn to 0 do begin
      c:=x[i]+y[i]+c;
      x[i]:=c mod base;
      c:=c div base
    end
  end;

  procedure writef(var x: fraction; p: position);
  var i: position;
  begin
    write(x[0]:1,'.');
    for i:=-1 downto p do write(chr(x[i]+ord('0')))
  end;
  
  function zerof(var x: fraction): position;
  var i: position;
  begin
    i:=0;
    while (i>-nn) and (x[i]=0) do i:=i-1;
    zerof:=i;
  end;
  
begin
  setf(s,1); setf(t,1); i:=0;
  while zerof(t)>-n do begin
    divf(t,i+1);
    addf(s,t);
    i:=i+1
  end;
  write('e='); writef(s,-n); writeln
end.
  
