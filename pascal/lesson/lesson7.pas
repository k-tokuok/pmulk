program Lesson7;
(* $Id: mulk/pascal lesson7.pas 1505 2025-12-29 Mon 20:00:53 kt $ *)
var mon:integer;
begin
  write('何月ですか?'); readln(mon);
  case mon of
  3, 4, 5: write('春です');
  6, 7, 8: write('夏です');
  9, 10, 11: write('秋です');
  12, 1, 2: write('冬です');
  end
end.
