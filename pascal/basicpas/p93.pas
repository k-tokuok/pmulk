program integerSetOperation(input,output);
(* $Id: mulk/pascal p93.pas 1544 2026-02-22 Sun 21:09:09 kt $ *)
type
  dataType=integer;
  tree=^treeCell;
  treeCell=record
    data: dataType;
    left, right: tree
  end;
  
var
  root: tree;
  command: char; value: dataType;
  
  function search(d: dataType; t: tree):tree;
  begin
    if t=nil then search:=nil
    else if t^.data=d then search:=t
    else if t^.data>d then search:=search(d, t^.left)
    else search:=search(d,t^.right)
  end;
  
  procedure insert(d: dataType; var t: tree);
  begin
    if t=nil then
      begin
        new(t); t^.data:=d;
        t^.left:=nil; t^.right:=nil
      end
    else if t^.data=d then
    else if t^.data>d then insert(d,t^.left)
    else insert(d,t^.right)
  end;
  
  procedure delete(d: dataType; var t: tree);
  var temp: tree;
  
    procedure deleteMin(var r: tree);
    begin
      while r^.left<>nil do r:=r^.left;
      t^.data:=r^.data
      (* dispose r^.data, r *)
    end;
    
  begin
    if t=nil then
    else if t^.data=d then
      if (t^.left<>nil) and (t^.right<>nil) then deleteMin(t^.right)
      else
        begin
          temp:=t;
          if t^.left<>nil then t:=t^.left
          else t:=t^.right
          (* dispose temp *)
        end
    else if t^.data>d then delete(d,t^.left)
    else delete(d,t^.right)
  end;
  
  procedure writeSet(t:tree);
  begin
    if t=nil then
    else
      begin
        writeSet(t^.left);
        write(t^.data:1,' ');
        writeSet(t^.right)
      end
  end;
  
begin
  root:=nil;
  repeat
    write('>'); read(command);
    if (command='i') or (command='d') or (command='s') 
        or (command='w') then begin
      if command='w' then readln else readln(value);
      case command of
      'i': insert(value,root);
      'd': delete(value,root);
      's': if search(value,root)<>nil then writeln('found');
      'w': begin
        writeSet(root); writeln
        end
      end
    end
  until command='.'
end.  
      
      

