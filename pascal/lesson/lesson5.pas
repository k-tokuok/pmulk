program Lesson5;
(* $Id: mulk/pascal lesson5.pas 1505 2025-12-29 Mon 20:00:53 kt $ *)

type string=array [1..20] of char;

function readstr(var s:string):integer;
var
  i:integer;
  ch:char;
begin
  i:=0;
  while not eoln(input) do
    begin
      i:=i+1;
      read(s[i])
    end;
  readstr:=i;
end;

procedure main;
var
  name:string;
  init:char;
  n:integer;
begin
  write('Your first name?'); 
  n:=readstr(name);
  init:=name[1];
  writeln('Length is ',n);
  writeln('Initial is ',init)
end;

begin
  main
end.
