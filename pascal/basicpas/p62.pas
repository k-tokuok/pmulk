program wordCounts(output,prd);
(* $Id: mulk/pascal p62.pas 1532 2026-01-30 Fri 20:58:38 kt $ *)
const 
  maxPosition=16;
  maxWord=1000;
  maxCount=1000;
type
  position=1..maxPosition;
  word=array [position] of char;
  index=0..maxWord;
  table=array [index] of word;
  indexList=array[index] of index;
  count=0..maxCount;
var
  c: char;
  key: word;
  words: table; 
  w,i: index;
  counts: array [index] of count;
  ind: indexList;

  function isLetter(c:char):boolean;
  begin
    isLetter:=(('a'<=c) and (c<='z')) or (('A'<=c) and (c<='Z'))
  end;

  procedure readWord(var key: word);
  var 
    spell: word;
    p: position;
  begin
    p:=1; spell[p]:=c;
    read(prd,c);
    while isLetter(c) do begin
      p:=p+1; spell[p]:=c;
      read(prd,c)
    end;
    while p<>maxPosition do begin
      p:=p+1; spell[p]:=' '
    end;
    key:=spell;
  end;

  procedure enterWord(key: word);
  var i:index;
  begin
    words[0]:=key; i:=w;
    while words[i]<>key do i:=i-1;
    if 0<i then counts[i]:=counts[i]+1
    else begin
      w:=w+1;
      words[w]:=key;
      counts[w]:=1
    end
  end;

  procedure sort(var words:table; n:index; var ind:indexList);
  var 
    i,j: index;
    key: word;
  begin
    for i:=1 to n do ind[i]:=i;
    for i:=2 to n do begin
      key:=words[i]; ind[0]:=i; j:=i-1;
      while key<words[ind[j]] do begin
        ind[j+1]:=ind[j]; j:=j-1
      end;
      ind[j+1]:=i
    end
  end;

begin
  writeln('Word counts.');
  w:=0;
  while not eof(prd) do begin
    read(prd,c);
    if isLetter(c) then begin
      readWord(key); enterWord(key)
    end
  end;
  sort(words,w,ind);
  for i:=1 to w do writeln(words[ind[i]],counts[ind[i]]:5);
end.
