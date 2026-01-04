program Lesson13;
(* $Id: mulk/pascal lesson13.pas 1509 2026-01-02 Fri 07:40:29 kt $ *)
type complex=array[1..2] of real;
var x,y,z:complex;

  procedure compmul(var c:complex; a,b:complex);
  begin
    c[1]:=a[1]*b[1]-a[2]*b[2];
    c[2]:=a[1]*b[2]+a[2]*b[1]
  end;
  
begin
  write('Re x='); readln(x[1]);
  write('Im x='); readln(x[2]);
  write('Re y='); readln(y[1]);
  write('Im y='); readln(y[2]);
  compmul(z,x,y);
  writeln('x*y=',z[1],'+',z[2],'i')
end.
