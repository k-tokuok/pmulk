program fileInversion(input,output);
(* $Id: mulk/pascal p91.pas 1543 2026-02-21 Sat 20:57:29 kt $ *)
type
  dataType=integer;
  list=^listCell;
  listCell=record
    data: dataType;
    next: list
  end;
var
  head,p: list;
  
begin
  head:=nil;
  while not eof do begin
    new(p);
    readln(p^.data);
    p^.next:=head;
    head:=p
  end;
  
  while head<>nil do begin
    p:=head;
    head:=p^.next;
    writeln(p^.data)
  end
end.
