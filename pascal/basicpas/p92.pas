program integerSetOperation(input,output);
(* $Id: mulk/pascal p92.pas 1544 2026-02-22 Sun 21:09:09 kt $ *)
type
  dataType=integer;
  list=^listCell;
  listCell=record
    data: dataType;
    next: list
  end;
var
  head, tail: list;
  command: char;
  value: dataType;
  
  procedure createSet;
  begin
    new(head); new(tail);
    head^.next:=tail;
    tail^.next:=nil
  end;

  function eq(a, b: dataType; c: list): boolean;
  begin eq:=(a=b) and (c<>tail) end;
  
  function neq(a, b: dataType; c: list): boolean;
  begin neq:=(a<>b) or (c=tail) end;
  
  function predessor(d: dataType; testEq: boolean): list;
  var 
    prev, curr: list;
    test: boolean;
  begin
    tail^.data:=d;
    prev:=head; curr:=prev^.next;
    while curr^.data<d do begin
      prev:=curr; curr:=prev^.next
    end;
    if testEq then test:=eq(curr^.data, d, curr)
    else test:=neq(curr^.data, d, curr);
    if test then predessor:=prev else predessor:=nil
  end;
  
  function search(d:dataType): boolean;
  begin search:=(predessor(d,true)<>nil) end;
  
  procedure insert(d:dataType);
  var pred, temp: list;
  begin
    pred:=predessor(d,false);
    if pred<>nil then begin
      new(temp);
      temp^.next:=pred^.next; pred^.next:=temp; 
      temp^.data:=d
    end
  end;
  
  procedure delete(d:dataType);
  var pred, temp: list;
  begin
    pred:=predessor(d,true);
    if pred<>nil then begin
      temp:=pred^.next; pred^.next:=temp^.next
      (* dispose temp *)
    end
  end;
  
  procedure writeSet;
  var current: list;
  begin
    current:=head^.next;
    while current<>tail do begin
      write(current^.data:1,' ');
      current:=current^.next
    end
  end;
  
begin
  createSet;
  repeat
    write('>'); read(command);
    if (command='i') or (command='d') or (command='s') 
        or (command='w') then begin
      if command='w' then readln else readln(value);
      case command of
      'i': insert(value);
      'd': delete(value);
      's': if search(value) then writeln('found');
      'w': begin
        writeSet; writeln
        end
      end
    end
  until command='.'
end.
