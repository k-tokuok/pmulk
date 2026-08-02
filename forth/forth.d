*1
forth.
$Id: mulk/forth forth.d 1625 2026-07-31 Fri 22:21:07 kt $

imagescr: 3 21
*2
( message )
illegal screen no
stack underflow
stack underflow
execution only
compilation only
definition not finished
interpret failed
use only when loading
conditionals not paired
*3
( primitive 1 )
0 _primitive sp@ ( -- a )
1 _primitive sp! ( a -- )
2 _primitive dup ( x -- x x : 6.1.1290 )
3 _primitive swap ( x1 x2 -- x2 x1 : 6.1.2260 )
4 _primitive drop ( x -- : 6.1.1260 )
5 _primitive rp! ( a -- )
6 _primitive r> ( -- x : 6.1.2060 )
7 _primitive >r ( x -- : 6.1.0580 )
8 _primitive r@ ( -- x : 6.1.2070 )
9 _primitive @ ( a -- x : 6.1.0650 )
10 _primitive ! ( x a -- : 6.1.0010 )
11 _primitive c@ ( a -- c : 6.1.0870 )
12 _primitive c! ( c a -- : 6.1.0850 )
13 _primitive um+ ( u u -- u cy )
14 _primitive xor ( x x -- x : 6.1.2490 )
*4
( primitive 2 )
15 _primitive and ( x x -- x : 6.1.0720 )
16 _primitive or ( x x -- x : 6.1.1980 )
17 _primitive execute ( cfa -- : 6.1.1370 )
18 _primitive exit ( -- : 6.1.1380 )
19 _primitive (:) ( -- )
20 _primitive (branch) ( -- )
21 _primitive (0branch) ( f -- )
22 _primitive (literal) ( -- x )
23 _primitive (constant) ( -- x )
24 _primitive (variable) ( -- a )
25 _primitive bye ( -- : 15.6.2.0830 )
26 _primitive emit ( c -- : 6.1.1320 )
27 _primitive key ( -- c : 6.1.1750 )
28 _primitive blk-read ( a u -- )
29 _primitive blk-write ( a u -- )
*5
( primitive 3 )
30 _primitive blk-count ( -- n )
*6
( constant )
0 constant 0
1 constant 1
2 constant 2
-1 constant -1
32 constant bl ( -- c : 6.1.0770 )
64 constant c/l
1024 constant blk-size
*7
( image parameter )
( 0 boot )
( 2 abort - interrupt handler )
4 constant memsize
6 constant sp0
8 constant rp0
10 constant hp0
12 constant dp0
14 constant dict0
*8
( variables )
10 variable base ( -- a : 6.1.0750 )
0 variable dp
0 variable >in ( -- a : 6.1.0560 )
0 variable blk ( -- a : 7.6.1.0790 )
0 variable context
0 variable current
0 variable state ( -- a : 6.1.2250 )
0 variable csp
-1 variable (error)
*9
( stack operations )
: rot ( x1 x2 x3 -- x2 x3 x1 : 6.1.2160 ) >r swap r> swap ;
: over ( x1 x2 -- x1 x2 x1 : 6.1.1990 ) >r dup r> swap ;
: nip ( x1 x2 -- x2 : 6.2.1930 ) swap drop ;
: 2drop ( x x -- : 6.1.0370 ) drop drop ;
: 2dup ( x1 x2 -- x1 x2 x1 x2 : 6.1.0380 ) over over ;
*10
( arithmetic/basic )
: + ( n n -- n : 6.1.0120 ) um+ drop ;
: cell+ ( a -- a : 6.1.0880 ) 2 + ;
: 1+ ( n -- n : 6.1.0290 ) 1 + ;
: 1- ( n -- n : 6.1.0300 ) -1 + ;
: invert ( x -- x : 6.1.1720 ) -1 xor ;
: negate ( n -- n : 6.1.1910 ) invert 1+ ;
: - ( n n -- n : 6.1.0160 ) negate + ;
: +! ( n a -- : 6.1.0130 ) dup >r @ + r> ! ;
: cells ( n -- n : 6.1.0890 ) dup + ;
*11
( arithmetic/compare )
: 0= ( x -- f : 6.1.0270 ) if 0 exit then -1 ;
: 0< ( n -- f : 6.1.0250 ) 32768 and 0= invert ;
: u< ( u -- f : 6.1.2340 ) 2dup xor 0< if nip 0< exit then - 0<
  ;
: < ( n n -- f : 6.1.0480 ) 2dup xor 0< if drop 0< exit then -
  0< ;
: = ( x x -- f : 6.1.0530 ) xor 0= ;
*12
( arithmetic/multiply )
: um* ( u u -- ud : 6.1.2360 )
  0 swap 16
  begin dup
  while >r dup um+ >r >r dup um+ r> + r>
    if >r over um+ r> + then r> 1-
  repeat drop >r nip r> ;
: * ( n n -- 6.1.0090 ) um* drop ;
*13
( high memory )
_memsize memsize !
memsize @
64 cells - dup sp0 !
64 cells - dup rp0 !
c/l 1 + - dup constant tib ( -- a : 6.2.2290 )
blk-size 3 + - dup constant blk-cur
hp0 !

blk-cur cell+ constant blk-buf
*14
( block )
: blk-init ( -- ) 0 blk-cur ! 0 blk-buf blk-size + c! ;
: flush ( -- : 7.6.1.1559 ) blk-cur @ dup 0< if 32767 and
  dup blk-cur ! blk-buf swap blk-write exit then drop ;
: block ( u -- a : 7.6.1.0800 ) dup blk-cur @ 32767 and = if
  drop else flush dup blk-cur ! blk-buf swap blk-read then
  blk-buf ;
*15
( memory )
: count ( a -- a n : 6.1.0980 ) dup 1+ swap c@ ;
: move ( a a u -- : 6.1.1900 )
  >r 2dup u<
  if begin r> dup while 1- >r over r@ + c@ over r@ + c!
    repeat drop 2drop exit
  then r> over + >r begin dup r@ xor while >r dup c@ r@ c! 1+
    r> 1+
  repeat r> drop 2drop ;
: s= ( a n a n -- f )
  rot over xor if 2drop drop 0 exit then
  begin dup while 1- >r >r count r> count rot xor r> swap
    if 2drop drop 0 exit then
  repeat 2drop drop -1 ;
*16
( parse )
: endtoken? ( c c -- f ) over = if drop 1 exit then 0= ;
: enclose ( a c -- a n m ) over >r >r
  begin count r@ xor until 1-
  dup c@ 0= if 1 over
  else
    dup begin count r@ endtoken? until 1- ( a a2 )
    2dup swap - swap ( a n a2 )
    dup c@ if 1+ then
  then r> drop r> - ;
: here ( -- a : 6.1.1650 ) dp @ ;
: word ( c -- caddr : 6.1.2450 )
  blk @ dup if block else drop tib then
  >in @ + swap enclose >in +!
  dup here c! here 1+ swap move
  here ;
*17
( dictionary )
: latest ( -- a ) current @ @ ;
: find1 ( a top -- a 0 | cfa [1-imd,-1] )
  swap >r
  begin
    count 127 and 2dup r@ count s= if
      over 1- c@ 128 and if 1 else -1 then
      rot rot + cell+ cell+ r> drop swap exit then
    + @ dup 0= until r> swap ;
: find ( a -- a 0 | cfa [1-imd,-1] : 6.1.1540 )
  context @ @ find1
  dup 0= if
    context @ current @ xor if drop latest find1 then then ;
*18
( numeric input )
: digit? ( c -- n f ) base @ >r 48 ( [char] 0 ) - 9 over <
  if 39 - dup 10 < or then dup r> u< ;
: number? ( a -- n f ) 0 swap
  count over c@ 45 ( [char] - ) = dup >r if >r 1+ r> 1- then
  begin dup while 1- >r count digit?
    0= if r> r> 2drop 2drop 0 exit then
    swap >r swap base @ * + r> r> repeat
  2drop r> if negate then 1 ;
*19
( compiler/core )
: allot ( n -- : 6.1.0710 ) dp +! ;
: , ( n -- : 6.1.0150 ) here ! 2 allot ;
: [ ( -- : 6.1.2500 ) 0 state ! ; immediate
: ] ( -- : 6.1.2540 ) 1 state ! ;
: create ( -- : 6.1.1000 ) bl word 46 ( [char] . ) emit
  dup c@ 1+ allot latest , blk @ , current @ ! ;
: ?error ( f n -- ) swap if (error) @ execute then drop ;
: ?exec ( -- ) state @ 3 ?error ;
: : ( -- : 6.1.0450 )
  ?exec sp@ csp ! create ] (literal) (:) cell+ , ;
: ?comp ( -- ) state @ 0= 4 ?error ;
: compile ( -- ) ?comp r> dup cell+ >r @ , ;
: ?csp ( -- ) sp@ csp @ xor 5 ?error ;
: ; ( -- : 6.1.0460 )
  ?csp compile exit [compile] [ ; immediate
*20
( text interpreter )
: ?stack ( -- ) sp@ sp0 @ < 1 ?error sp@ memsize @ swap < 2
  ?error ;
: interpret ( -- ) begin bl word find
  dup if state @ + if execute else , then
  else drop number? 0= 6 ?error
    state @ if compile (literal) , then
  then ?stack again ;
: ?block ( n -- ) dup 1 < 0 ?error dup blk-count swap < 0
  ?error ;
: load ( n -- : 7.6.1.1790 ) ?block
  blk @ >r blk ! >in @ >r 0 >in ! interpret r> >in ! r> blk ! ;
: ( ( -- : 6.1.0080)
  41 ( close-paren ) word drop ; immediate
: _ ( -- ) blk @ if ?exec then r> drop ; immediate
0 _dict 1+ c!
*21
( build image )
blk-init
dict0 dup context ! current !
_dict current @ !
_dp dp !
22 load
latest dup dict0 ! _dict!
dp @ dp0 !
' cold ' abort 0 dp0 @ _save
bye
*22
( utility )
: immediate ( -- : 6.1.1710 ) latest dup c@ 128 or swap c! ;
: decimal ( -- : 6.1.1170 ) 10 base ! ;
: hex ( -- : 6.2.1660 ) 16 base ! ;
: char ( -- c : 6.1.0895 ) bl word count drop c@ ;
: [char] ( -- : 6.1.2520 ) char compile (literal) , ; immediate
: ?loading ( -- ) blk @ 0= 7 ?error ;
: --> ( -- ) ?loading 0 >in ! 1 blk +! ; immediate
: ' ( -- a : 6.1.0070 ) bl word find 0= 6 ?error ;
: [compile] ( -- : 6.2.2530 ) ?comp ' , ; immediate
: ['] ( -- a : 6.1.2510 ) ' compile (literal) , ; immediate
: c, ( c -- : 6.1.0860 ) here c! 1 allot ;
-->
*23
( compiler/definitions )
: constant ( x -- : 6.1.0950 ) ?exec create
  (literal) [ ' (constant) cell+ , ] , , ;
: variable ( x -- : 6.1.2410 ) ?exec create
  (literal) [ ' (variable) cell+ , ] , , ;
: (does) ( -- a ) r> dup cell+ swap @ >r ;
: <builds ( -- ) create (literal) [ ' (:) cell+ , ] ,
  (literal) (does) , 0 , ;
: does> ( -- : 6.1.1250 ) r> latest count 127 and + 4 cells + !
  ;
: vocabulary ( -- ) <builds latest , does> context ! ;
: definitions ( -- : 16.6.1.1180 ) context @ current ! ;
vocabulary forth ( -- : 16.6.2.1590 )
forth definitions
-->
*24
( compiler/control )
: ?pairs ( n n -- ) xor 8 ?error ;
: if ( f -- : 6.1.1700 ) compile (0branch) here 0 , 2 ;
  immediate
: then ( -- : 6.1.2270 ) 2 ?pairs here swap ! ; immediate
: else ( -- : 6.1.1310 ) 2 ?pairs compile (branch) here
  0 , swap 2 [compile] then 2 ; immediate
: begin ( -- : 6.1.0760 ) ?comp here 1 ; immediate
: again ( -- : 6.2.0700 ) 1 ?pairs compile (branch) ,
  ; immediate
: until ( f -- : 6.1.2390 ) 1 ?pairs compile (0branch) ,
  ; immediate
: while ( f -- a 3 : 6.1.2430 ) [compile] if 2 + ; immediate
: repeat ( -- : 6.1.2140 ) >r >r [compile] again r> r> 2 -
  [compile] then ; immediate -->
*25
( arithmetic/ext 1 )
: max ( n n -- n : 6.1.1870 ) 2dup < if swap then drop ;
: min ( n n -- n : 6.1.1880 ) 2dup < 0= if swap then drop ;
: abs ( n -- n : 6.1.0690 ) dup 0< if negate then ;

: dnegate ( d -- d : 8.6.1.1230 ) invert >r invert 1 um+ r> + ;
: dabs ( d -- ud : 8.6.1.1160 ) dup 0< if dnegate then ;
: s>d ( n -- d : 6.1.2170 ) dup 0< ;
-->
*26
( arithmetic/ext 2 )
: um/mod ( ud u -- umod udiv : 6.1.2370 ) 2dup u<
  if negate 16
    begin dup
    while >r >r dup um+ >r >r dup um+ r> +
      dup r> r@ swap >r um+ r> or
      if >r drop 1+ r> else drop then
      r> r> 1-
    repeat 2drop swap exit then
  drop 2drop -1 dup ;
: fm/mod ( d n -- nmod ndiv : 6.1.1561 )
  dup 0< dup >r if negate >r dnegate r> then
  >r dup 0< if r@ + then r> um/mod r> if >r negate r> then ;
-->
*27
( arithmetic/ext 3 )
: /mod ( n n -- nmod ndiv : 6.1.0240 ) over 0< swap fm/mod ;
: mod ( n n -- n : 6.1.1890 ) /mod drop ;
: / ( n n -- n : 6.1.0230 ) /mod nip ;
: m* ( n n -- d : 6.1.1810 ) 2dup xor >r abs swap abs um* r>
  0< if dnegate then ;
: */mod ( n n n -- n n : 6.1.0110 ) >r m* r> fm/mod ;
: */ ( n n -- n : 6.1.0100 ) */mod nip ;
-->
*28
( terminal oriented )
: space ( -- : 6.1.2220 ) bl emit ;

( linux: 45 load --> )
: cr ( -- : 6.1.0990 ) 10 emit ;
: backspace ( -- ) 8 emit ;
: ?backspace ( ch -- b ) 8 = ;
-->
*29
( string output )
: type ( a n -- : 6.1.2310 )
  over + swap begin 2dup xor while count emit repeat 2drop ;
: (.") ( -- ) r> count 2dup + >r type ;
: emits ( n c -- ) swap 0 max begin dup while over emit 1-
  repeat 2drop ;
: spaces ( n --- : 6.1.2230 ) bl emits ;
: ." ( -- : 6.1.0190 ) [char] " state @ if compile (.") word c@
  1+ allot else word count type then ; immediate
: (line) ( line scr -- a n ) block swap c/l * + c/l ;
: -trailing ( a n -- a n : 17.6.1.0170 ) begin dup while 1-
  2dup + c@ bl xor if 1+ exit then repeat ;
: .line ( line scr -- ) (line) -trailing type ;
: message ( n -- ) 1+ 2 .line ; -->
*30
( numeric output )
0 variable hld
: pad ( -- a : 6.2.2000 ) here 68 + ;
: <# ( -- : 6.1.0490 ) pad hld ! ;
: digit ( u -- c ) 9 over < 39 and + [char] 0 + ;
: hold ( c -- : 6.1.1670 ) hld @ 1- dup hld ! c! ;
: # ( ud -- ud : 6.1.0030 )
  0 base @ um/mod >r base @ um/mod swap digit hold r> ;
: #s ( ud -- ud : 6.1.0050 ) begin # 2dup or 0= until ;
: #> ( d -- a u : 6.1.0040 ) 2drop hld @ pad over - ;
: sign ( n -- : 6.1.2210 ) 0< if [char] - hold then ;
: d.r ( d n -- : 8.6.1.1070 )
  >r dup >r dabs <# #s r> sign #> r> over - spaces type ;
: d. ( d -- : 8.6.1.1060 ) 0 d.r space ;
: . ( n -- : 6.1.0180 ) s>d d. ;
: .r ( n n -- : 6.2.0210 ) >r s>d r> d.r ; -->
*31
( keyboard input )
: accept ( a u -- u : 6.1.0695 )
  over + over begin key dup 13 xor
  while
    dup ?backspace if
      drop >r over r@ < dup if backspace then r> +
    else
      >r 2dup xor if r@ over c! 1+ r@ emit then r> drop
    then
  repeat drop nip swap - ;
: query ( -- : 6.2.2060 ) 0 >in ! tib c/l accept tib + 0 swap c!
  ;
-->
*32
( interpreter control )
: quit ( -- : 6.1.2050 ) 0 blk ! [compile] [
  begin rp0 @ rp! cr query space interpret state @ 0= if ." ok"
  then again ;
: abort ( -- : 6.1.0680 ) sp0 @ sp! decimal ." -abort" quit ;
: cold ( -- ) blk-init forth definitions dict0 @ context @ !
  dp0 @ dp ! abort ;
: error ( n -- )
  here count type ." ?" message sp0 @ sp! abort ;
' error (error) !
-->
*33
( programming utility )
: .s ( -- : 15.6.1.0220 ) sp@ sp0 @ begin 2dup xor
  while dup @ . cell+ repeat 2drop ; immediate
: words ( -- : 15.6.1.2465 ) context @ @
  begin count 127 and 2dup type space + @ dup 0= until drop ;
: forget ( -- : 15.6.2.1580 ) bl word >r dict0 @ latest
  begin 2dup < while count 127 and 2dup r@ count s=
    if r> drop over 1- dp ! + @ current @ ! drop exit then
    + @ repeat 6 error ;
-->
*34
( block utility )
: view ( n -- ) ?block cr ." SCR#" dup . cr
  0 begin dup 16 < while dup 3 .r space 2dup swap .line cr 1+
  repeat 2drop ;
: index ( f t -- ) cr 1+ swap
  begin 2dup xor while ?block dup 3 .r space dup 0 swap .line cr
  1+ repeat 2drop ;
: see ( -- : 15.6.1.2194 ) ' 2 - @ view ;
: update ( -- : 7.6.1.2400 ) blk-cur @ 32768 or blk-cur ! ;
0 variable scr ( -- a : 7.6.2.2190 )
: list ( n -- : 7.6.2.1770 ) dup view scr ! ;
*35
( random )
0 variable seed
: (rand) ( -- n ) seed @ 259 * 3 + 32767 and dup seed ! ;
: random ( n -- n ) (rand) 32767 */ ;
*36
( for loop )
: (for) ( n -- ) dup if 1- r> cell+ swap >r else drop r> @ then
  >r ;
: (next) ( -- n ) r> @ r> swap >r ;
: for ( n -- ) compile (for) here 0 , 4 ; immediate
: next ( -- ) 4 ?pairs compile (next) dup 2 - , here swap
  ! ; immediate
: break r> r> drop 0 >r >r ;
*37
( do loop )
: (do) ( n n -- ) r> rot rot swap >r >r >r ;
: (loop) ( -- ) r> r> 1+ dup r@ <
  if >r @ else drop r> drop cell+ then >r ;
: do ( n n -- : 6.1.1240 ) compile (do) here 5 ; immediate
: loop ( -- : 6.1.1800 ) 5 ?pairs compile (loop) , ; immediate
: i ( -- n : 6.1.1680 ) r> r@ swap >r ;
: (+loop) ( n -- ) r> r> rot dup rot + dup r@ < rot 0< xor
  if >r @ else drop r> drop cell+ then >r ;
: +loop ( n -- : 6.1.0140 ) 5 ?pairs compile (+loop) , ;
  immediate
: j ( -- n : 6.1.1720 ) r> r> r> r@ swap >r swap >r swap >r ;
*38
( editor 1 )
vocabulary editor editor definitions
: line ( n -- a ) dup -16 and if ." illegal line" drop quit then
  scr @ (line) drop ;
0 variable r#
: #locate ( -- pos line ) r# @ c/l /mod ;
: #lead ( -- a pos ) #locate line swap ;
: #lag ( -- a n ) #lead dup >r + c/l r> - ;
: blanks ( a n -- ) for bl over c! 1+ next drop ;
: text ( c -- ) here c/l 1+ blanks word
  dup 1+ c@ 0= if bl here 1+ c! then pad c/l 1+ move ;
: -move ( a line -- ) line c/l move update ;
: find-buf ( -- a )pad c/l + 2 + ;
: insert-buf ( -- a ) find-buf c/l + 2 + ;
: buf-move ( a -- ) pad swap c/l 1+ move ; -->
*39
( editor 2 )
: >line# ( -- l ) #locate swap drop ;
: (r) ( -- ) >line# insert-buf 1+ swap -move ;
: 1line ( -- f ) #lag >r 0 r@ find-buf c@ - 0 max for
  over find-buf count dup rot rot s= if 1+ break
  else swap 1+ swap then next
  if r> drop #lag drop - find-buf c@ + 1
  else drop r> 0 then swap r# +! ;
: (top) ( -- ) 0 r# ! ;
: seek-error ( -- ) (top) find-buf count type
  ."  not found" quit ;
: (seek) ( -- ) begin 1023 r# @ < if seek-error then 1line
  until ;
: (f) ( -- ) [char] ^ text find-buf buf-move (seek) ;
: (delete) ( n -- ) >r #lag + r@ - #lag r@ negate r# +!
  #lead + swap move r> blanks update ; -->
*40
( editor 3 )
: (e) ( -- ) find-buf c@ (delete) ;
: (kill) ( n -- ) line c/l blanks update ;
: (spread) ( -- ) >line# dup 15 over - for dup r@ + dup line
  swap 1+ -move next drop (kill) ;
-->
*41
( editor 4 commands )
: l ( -- : list screen ) scr @ view ;
: c ( -- : print current line ) cr #lead type [char] ^ emit #lag
  type #locate . drop ;
: t ( n -- : go top of line n ) c/l * r# ! c ;
: x ( -- : kill current line ) 15 >line# - for
  15 r@ - dup line swap 1- -move next 15 (kill) ;
: p ( -- :xxx^ overwrite current line to xxx ) [char] ^ text
  insert-buf buf-move (r) ;
: u ( -- :xxx^ insert xxx to next line ) c/l r# +! (spread) p ;
: i ( -- :xxx^ insert xxx at cursor ) [char] ^ text insert-buf
  buf-move insert-buf count #lag rot over min >r r@ r# +! r@ -
  >r dup here r@ move here #lead + r> move
  r> move update c ;
: f ( -- :xxx^ find xxx from cursor ) (f) c ;
: e ( -- : erase last find ) (e) c ; -->
*42
( editor 5 commands )
: d ( -- :xxx^ find xxx and delete ) (f) e ;
: r ( -- :xxx^ replace last find to xxx ) (e) i ;

: wipe ( -- : clear current screen ) scr @ block blk-size blanks
  update ;
: new ( -- : make new screen ) flush blk-count 1+ dup scr !
  blk-cur ! wipe flush ;
: copy ( n m -- : copy screen n to m ) >r block r> blk-cur !
  update flush ;

forth definitions editor
: 10words ( -- ) context @ @ 10
  for count 127 and 2dup type space + @ next drop ;
*43
( viewer )
forth definitions
vocabulary viewer viewer definitions
: scr+ ( n -- ) scr @ + 1 max blk-count min scr ! ;
: v ( -- ) scr @ view ;
: n ( -- ) 1 scr+ v ;
: p ( -- ) -1 scr+ v ;
: g ( n -- ) list ;
: i ( -- ) scr @ dup >r 10 - 1 max r> 10 + blk-count min index
  ;
: f ( -- ) 20 scr+ i ;
: b ( -- ) -20 scr+ i ;
forth definitions viewer
*44
( for raw console device -- see 28. )
: cr 13 emit 10 emit ;
: backspace 8 emit space 8 emit ;
: ?backspace dup 8 = swap 127 = or ;
*45
( for linux terminal -- see 28. )
: cr 10 emit ;
: backspace 8 emit ;
: ?backspace dup 8 = swap 127 = or ;
