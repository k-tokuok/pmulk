i $Id: mulk/pascal pcom.p4 1442 2025-06-12 Thu 10:05:28 kt $
l3
 ent 1 l4
 ent 2 l5
 ldoi 160
 ldci 0
 grti
 fjp l6
 ldoi 28
i10
 ldci 6
 lda 1 6
 csp wri
 lca' ****  '
 ldci 9
 ldci 7
 lda 1 6
 csp wrs
 ldci 0
 stri 0 10
i20
 ldci 1
 stri 0 9
 ldci 1
 stri 0 5
 ldoi 160
 stri 0 11
l7
 lodi 0 5
 lodi 0 11
 leqi
 fjp l8
i30
 lao 161
 lodi 0 5
 chki 1 10
 deci 1
 ixa 2
 stra 0 12
 loda 0 12
 indi 0
 stri 0 8
 loda 0 12
i40
 indi 1
 stri 0 7
 lodi 0 8
 lodi 0 10
 equi
 fjp l9
 ldcc ','
 ldci 1
 lda 1 6
 csp wrc
i50
 ujp l10
l9
l11
 lodi 0 9
 lodi 0 8
 lesi
 fjp l12
 ldcc ' '
 ldci 1
 lda 1 6
 csp wrc
 lodi 0 9
i60
 ldci 1
 adi
 stri 0 9
 ujp l11
l12
 ldcc '^'
 ldci 1
 lda 1 6
 csp wrc
 lodi 0 8
 stri 0 10
l10
i70
 lodi 0 7
 ldci 10
 lesi
 fjp l13
 ldci 1
 stri 0 6
 ujp l14
l13
 lodi 0 7
 ldci 100
 lesi
i80
 fjp l15
 ldci 2
 stri 0 6
 ujp l16
l15
 ldci 3
 stri 0 6
l16
l14
 lodi 0 7
 lodi 0 6
 lda 1 6
 csp wri
i90
 lodi 0 9
 lodi 0 6
 adi
 ldci 1
 adi
 stri 0 9
 lodi 0 5
 inci 1
 stri 0 5
 ujp l7
l8
i100
 lda 1 6
 csp wln
 ldci 0
 chki 0 10
 sroi 160
l6
 ldoi 28
 ldci 1
 adi
 sroi 28
 ldob 31
i110
 lao 5
 eof
 not
 and
 fjp l17
 ldoi 28
 ldci 6
 lda 1 6
 csp wri
 lca'  '
i120
 ldci 2
 ldci 2
 lda 1 6
 csp wrs
 ldob 33
 fjp l18
 ldoi 27
 ldci 7
 lda 1 6
 csp wri
i130
 ujp l19
l18
 ldoi 26
 ldci 7
 lda 1 6
 csp wri
l19
 ldcc ' '
 ldci 1
 lda 1 6
 csp wrc
l17
 ldci 0
i140
 sroi 25
 retp
l4=13
l5=9
l20
 ent 1 l21
 ent 2 l22
 ldoi 35
 ldci 1
 adi
 sroi 35
 ldoi 160
 ldci 9
i150
 geqi
 fjp l23
 lao 161
 ldci 10
 chki 1 10
 deci 1
 ixa 2
 inca 1
 ldci 255
 chki 1 400
i160
 stoi
 ldci 10
 chki 0 10
 sroi 160
 ujp l24
l23
 ldoi 160
 ldci 1
 adi
 chki 0 10
 sroi 160
i170
 lao 161
 ldoi 160
 chki 1 10
 deci 1
 ixa 2
 inca 1
 lodi 0 5
 chki 1 400
 stoi
l24
 lao 161
i180
 ldoi 160
 chki 1 10
 deci 1
 ixa 2
 ldoi 25
 stoi
 retp
l21=6
l22=7
l29
 ent 1 l30
 ent 2 l31
 ldob 24
i190
 fjp l32
 mst 2
 cup 0 l3
l32
 lao 5
 eof
 not
 fjp l33
 lao 5
 csp eln
 chkb 0 1
i200
 srob 24
 lao 23
 lda 2 5
 csp rdc
 ldob 31
 fjp l34
 ldoc 23
 ldci 1
 lda 2 6
 csp wrc
l34
i210
 ldoi 25
 ldci 1
 adi
 sroi 25
 ujp l35
l33
 lca'   *** eof '
 ldci 11
 ldci 11
 lda 2 6
 csp wrs
i220
 lca'encountered'
 ldci 11
 ldci 11
 lda 2 6
 csp wrs
 lda 2 6
 csp wln
 ldcb 0
 chkb 0 1
 strb 1 264
l35
i230
 retp
l30=5
l31=9
l36
 ent 1 l37
 ent 2 l38
l39
 mst 1
 cup 0 l29
 ldoc 23
 ldcc '*'
 neqc
 fjp l40
 ldoc 23
i240
 ldcc 't'
 equc
 fjp l41
 mst 1
 cup 0 l29
 ldoc 23
 ldcc '+'
 equc
 chkb 0 1
 srob 29
i250
 ujp l42
l41
 ldoc 23
 ldcc 'l'
 equc
 fjp l43
 mst 1
 cup 0 l29
 ldoc 23
 ldcc '+'
 equc
i260
 chkb 0 1
 srob 31
 ldob 31
 not
 fjp l44
 lda 2 6
 csp wln
l44
 ujp l45
l43
 ldoc 23
 ldcc 'd'
i270
 equc
 fjp l46
 mst 1
 cup 0 l29
 ldoc 23
 ldcc '+'
 equc
 chkb 0 1
 srob 34
 ujp l47
l46
i280
 ldoc 23
 ldcc 'c'
 equc
 fjp l48
 mst 1
 cup 0 l29
 ldoc 23
 ldcc '+'
 equc
 chkb 0 1
i290
 srob 30
l48
l47
l45
l42
 mst 1
 cup 0 l29
l40
 ldoc 23
 ldcc ','
 neqc
 fjp l39
 retp
l37=5
l38=7
l25
 ent 1 l49
 ent 2 l50
l26
l51
l52
i300
 ldoc 23
 ldcc ' '
 equc
 ldoc 23
 ldcc ' '
 equc
 ior
 ldob 24
 not
 and
i310
 fjp l53
 mst 0
 cup 0 l29
 ujp l52
l53
 ldob 24
 chkb 0 1
 strb 0 264
 lodb 0 264
 fjp l54
 mst 0
i320
 cup 0 l29
l54
 lodb 0 264
 not
 fjp l51
 lao 194
 ldoc 23
 ordc
 chki 0 255
 ixa 1
 indi 0
i330
 ldci 3
 equi
 fjp l55
 ldci 47
 chki 0 47
 sroi 9
 ldci 15
 chki 0 15
 sroi 10
 mst 1
i340
 ldci 399
 cup 1 l20
 mst 0
 cup 0 l29
 ujp l56
l55
 lao 194
 ldoc 23
 ordc
 chki 0 255
 ixa 1
i350
 indi 0
 ordi
 ujp l57
l59
 ldci 0
 stri 0 5
l60
 lodi 0 5
 ldci 8
 lesi
 fjp l61
 lodi 0 5
i360
 ldci 1
 adi
 stri 0 5
 lao 14
 lodi 0 5
 chki 1 8
 deci 1
 ixa 1
 ldoc 23
 chkc 0 255
i370
 stoc
l61
 mst 0
 cup 0 l29
 lao 194
 ldoc 23
 ordc
 chki 0 255
 ixa 1
 indi 0
 ordi
i380
 ldc( 2 3 4 5 6 7 8 9 10)
 inn
 fjp l60
 lodi 0 5
 ldoi 22
 geqi
 fjp l62
 lodi 0 5
 chki 1 8
 sroi 22
i390
 ujp l63
l62
l64
 lao 14
 ldoi 22
 chki 1 8
 deci 1
 ixa 1
 ldcc ' '
 chkc 0 255
 stoc
 ldoi 22
i400
 ldci 1
 sbi
 chki 1 8
 sroi 22
 ldoi 22
 lodi 0 5
 equi
 fjp l64
l63
 lao 730
 lodi 0 5
i410
 chki 1 9
 deci 1
 ixa 1
 indi 0
 stri 0 6
 lao 730
 lodi 0 5
 ldci 1
 adi
 chki 1 9
i420
 deci 1
 ixa 1
 indi 0
 ldci 1
 sbi
 stri 0 265
l65
 lodi 0 6
 lodi 0 265
 leqi
 fjp l66
i430
 lao 450
 lodi 0 6
 chki 1 35
 deci 1
 ixa 8
 lao 14
 equm 8
 fjp l67
 lao 739
 lodi 0 6
i440
 chki 1 35
 deci 1
 ixa 1
 indi 0
 chki 0 47
 sroi 9
 lao 1030
 lodi 0 6
 chki 1 35
 deci 1
i450
 ixa 1
 indi 0
 chki 0 15
 sroi 10
 ujp l27
l67
 lodi 0 6
 inci 1
 stri 0 6
 ujp l65
l66
 ldci 0
i460
 chki 0 47
 sroi 9
 ldci 15
 chki 0 15
 sroi 10
l27
 ujp l58
l68
 ldci 15
 chki 0 15
 sroi 10
 ldci 0
i470
 stri 0 6
l69
 lodi 0 6
 ldci 1
 adi
 stri 0 6
 lodi 0 6
 ldoi 2277
 leqi
 fjp l70
 lda 0 7
i480
 lodi 0 6
 chki 1 128
 deci 1
 ixa 1
 ldoc 23
 chkc 0 255
 stoc
l70
 mst 0
 cup 0 l29
 lao 194
i490
 ldoc 23
 ordc
 chki 0 255
 ixa 1
 indi 0
 ldci 1
 neqi
 fjp l69
 ldoc 23
 ldcc '.'
i500
 equc
 ldoc 5
 ldcc '.'
 neqc
 and
 ldoc 23
 ldcc 'e'
 equc
 ior
 fjp l71
i510
 lodi 0 6
 stri 0 5
 ldoc 23
 ldcc '.'
 equc
 fjp l72
 lodi 0 5
 ldci 1
 adi
 stri 0 5
i520
 lodi 0 5
 ldoi 2277
 leqi
 fjp l73
 lda 0 7
 lodi 0 5
 chki 1 128
 deci 1
 ixa 1
 ldoc 23
i530
 chkc 0 255
 stoc
l73
 mst 0
 cup 0 l29
 lao 194
 ldoc 23
 ordc
 chki 0 255
 ixa 1
 indi 0
i540
 ldci 1
 neqi
 fjp l74
 mst 1
 ldci 201
 cup 1 l20
 ujp l75
l74
l76
 lodi 0 5
 ldci 1
 adi
i550
 stri 0 5
 lodi 0 5
 ldoi 2277
 leqi
 fjp l77
 lda 0 7
 lodi 0 5
 chki 1 128
 deci 1
 ixa 1
i560
 ldoc 23
 chkc 0 255
 stoc
l77
 mst 0
 cup 0 l29
 lao 194
 ldoc 23
 ordc
 chki 0 255
 ixa 1
i570
 indi 0
 ldci 1
 neqi
 fjp l76
l75
l72
 ldoc 23
 ldcc 'e'
 equc
 fjp l78
 lodi 0 5
 ldci 1
i580
 adi
 stri 0 5
 lodi 0 5
 ldoi 2277
 leqi
 fjp l79
 lda 0 7
 lodi 0 5
 chki 1 128
 deci 1
i590
 ixa 1
 ldoc 23
 chkc 0 255
 stoc
l79
 mst 0
 cup 0 l29
 ldoc 23
 ldcc '+'
 equc
 ldoc 23
i600
 ldcc '-'
 equc
 ior
 fjp l80
 lodi 0 5
 ldci 1
 adi
 stri 0 5
 lodi 0 5
 ldoi 2277
i610
 leqi
 fjp l81
 lda 0 7
 lodi 0 5
 chki 1 128
 deci 1
 ixa 1
 ldoc 23
 chkc 0 255
 stoc
l81
i620
 mst 0
 cup 0 l29
l80
 lao 194
 ldoc 23
 ordc
 chki 0 255
 ixa 1
 indi 0
 ldci 1
 neqi
i630
 fjp l82
 mst 1
 ldci 201
 cup 1 l20
 ujp l83
l82
l84
 lodi 0 5
 ldci 1
 adi
 stri 0 5
 lodi 0 5
i640
 ldoi 2277
 leqi
 fjp l85
 lda 0 7
 lodi 0 5
 chki 1 128
 deci 1
 ixa 1
 ldoc 23
 chkc 0 255
i650
 stoc
l85
 mst 0
 cup 0 l29
 lao 194
 ldoc 23
 ordc
 chki 0 255
 ixa 1
 indi 0
 ldci 1
i660
 neqi
 fjp l84
l83
l78
 lda 0 263
 ldci 129
 csp new
 ldci 2
 chki 0 47
 sroi 9
 loda 0 263
 chka 1 1073741823
i670
 ldci 0
 chki 0 2
 stoi
 loda 0 263
 chka 1 1073741823
 stra 0 265
 ldci 1
 stri 0 6
 ldci 128
 stri 0 266
l86
i680
 lodi 0 6
 lodi 0 266
 leqi
 fjp l87
 loda 0 265
 inca 1
 lodi 0 6
 chki 1 128
 deci 1
 ixa 1
i690
 ldcc ' '
 chkc 0 255
 stoc
 lodi 0 6
 inci 1
 stri 0 6
 ujp l86
l87
 lodi 0 5
 ldoi 2277
 leqi
i700
 fjp l88
 ldci 2
 stri 0 6
 lodi 0 5
 ldci 1
 adi
 stri 0 266
l89
 lodi 0 6
 lodi 0 266
 leqi
i710
 fjp l90
 loda 0 265
 inca 1
 lodi 0 6
 chki 1 128
 deci 1
 ixa 1
 lda 0 7
 lodi 0 6
 ldci 1
i720
 sbi
 chki 1 128
 deci 1
 ixa 1
 indc 0
 chkc 0 255
 stoc
 lodi 0 6
 inci 1
 stri 0 6
i730
 ujp l89
l90
 ujp l91
l88
 mst 1
 ldci 203
 cup 1 l20
 loda 0 265
 inca 1
 ldci 2
 chki 1 128
 deci 1
i740
 ixa 1
 ldcc '0'
 chkc 0 255
 stoc
 loda 0 265
 inca 1
 ldci 3
 chki 1 128
 deci 1
 ixa 1
i750
 ldcc '.'
 chkc 0 255
 stoc
 loda 0 265
 inca 1
 ldci 4
 chki 1 128
 deci 1
 ixa 1
 ldcc '0'
i760
 chkc 0 255
 stoc
l91
 loda 0 263
 chka 0 1073741823
 sroa 12
 ujp l92
l71
l28
 lodi 0 6
 ldoi 2277
 grti
 fjp l93
i770
 mst 1
 ldci 203
 cup 1 l20
 ldci 0
 sroi 12
 ujp l94
l93
 ldci 0
 sroi 12
 ldci 1
 stri 0 5
i780
 lodi 0 6
 stri 0 265
l95
 lodi 0 5
 lodi 0 265
 leqi
 fjp l96
 ldoi 12
 ldoi 2278
 leqi
 fjp l97
i790
 ldoi 12
 ldci 10
 mpi
 lao 2021
 lda 0 7
 lodi 0 5
 chki 1 128
 deci 1
 ixa 1
 indc 0
i800
 ordc
 chki 0 255
 ixa 1
 indi 0
 adi
 sroi 12
 ujp l98
l97
 mst 1
 ldci 203
 cup 1 l20
i810
 ldci 0
 sroi 12
l98
 lodi 0 5
 inci 1
 stri 0 5
 ujp l95
l96
 ldci 1
 chki 0 47
 sroi 9
l94
l92
 ujp l58
l99
i820
 ldci 0
 sroi 13
 ldci 3
 chki 0 47
 sroi 9
 ldci 15
 chki 0 15
 sroi 10
l100
l101
 mst 0
 cup 0 l29
i830
 ldoi 13
 ldci 1
 adi
 sroi 13
 ldoi 13
 ldci 128
 leqi
 fjp l102
 lda 0 135
 ldoi 13
i840
 chki 1 128
 deci 1
 ixa 1
 ldoc 23
 chkc 0 255
 stoc
l102
 ldob 24
 ldoc 23
 ldcc '''
 equc
i850
 ior
 fjp l101
 ldob 24
 fjp l103
 mst 1
 ldci 202
 cup 1 l20
 ujp l104
l103
 mst 0
 cup 0 l29
l104
i860
 ldoc 23
 ldcc '''
 neqc
 fjp l100
 ldoi 13
 ldci 1
 sbi
 sroi 13
 ldoi 13
 ldci 0
i870
 equi
 fjp l105
 mst 1
 ldci 205
 cup 1 l20
 ujp l106
l105
 ldoi 13
 ldci 1
 equi
 fjp l107
i880
 lda 0 135
 ldci 1
 chki 1 128
 deci 1
 ixa 1
 indc 0
 ordc
 sroi 12
 ujp l108
l107
 lda 0 263
i890
 ldci 130
 csp new
 loda 0 263
 chka 1 1073741823
 ldci 2
 chki 0 2
 stoi
 ldoi 13
 ldci 128
 grti
i900
 fjp l109
 mst 1
 ldci 399
 cup 1 l20
 ldci 128
 sroi 13
l109
 loda 0 263
 chka 1 1073741823
 stra 0 265
 loda 0 265
i910
 inca 1
 ldoi 13
 chki 0 128
 stoi
 ldci 1
 stri 0 6
 ldoi 13
 stri 0 266
l110
 lodi 0 6
 lodi 0 266
i920
 leqi
 fjp l111
 loda 0 265
 inca 2
 lodi 0 6
 chki 1 128
 deci 1
 ixa 1
 lda 0 135
 lodi 0 6
i930
 chki 1 128
 deci 1
 ixa 1
 indc 0
 chkc 0 255
 stoc
 lodi 0 6
 inci 1
 stri 0 6
 ujp l110
l111
i940
 loda 0 263
 chka 0 1073741823
 sroa 12
l108
l106
 ujp l58
l112
 ldci 15
 chki 0 15
 sroi 10
 mst 0
 cup 0 l29
 ldoc 23
i950
 ldcc '='
 equc
 fjp l113
 ldci 17
 chki 0 47
 sroi 9
 mst 0
 cup 0 l29
 ujp l114
l113
 ldci 16
i960
 chki 0 47
 sroi 9
l114
 ujp l58
l115
 ldci 15
 chki 0 15
 sroi 10
 mst 0
 cup 0 l29
 ldoc 23
 ldcc '.'
i970
 equc
 fjp l116
 ldci 16
 chki 0 47
 sroi 9
 mst 0
 cup 0 l29
 ujp l117
l116
 ldci 14
 chki 0 47
i980
 sroi 9
l117
 ujp l58
l118
 mst 0
 cup 0 l29
 ldci 7
 chki 0 47
 sroi 9
 ldoc 23
 ldcc '='
 equc
i990
 fjp l119
 ldci 9
 chki 0 15
 sroi 10
 mst 0
 cup 0 l29
 ujp l120
l119
 ldoc 23
 ldcc '>'
 equc
i1000
 fjp l121
 ldci 12
 chki 0 15
 sroi 10
 mst 0
 cup 0 l29
 ujp l122
l121
 ldci 8
 chki 0 15
 sroi 10
l122
l120
i1010
 ujp l58
l123
 mst 0
 cup 0 l29
 ldci 7
 chki 0 47
 sroi 9
 ldoc 23
 ldcc '='
 equc
 fjp l124
i1020
 ldci 10
 chki 0 15
 sroi 10
 mst 0
 cup 0 l29
 ujp l125
l124
 ldci 11
 chki 0 15
 sroi 10
l125
 ujp l58
l126
i1030
 mst 0
 cup 0 l29
 ldoc 23
 ldcc '*'
 equc
 fjp l127
 mst 0
 cup 0 l29
 ldoc 23
 ldcc '$'
i1040
 equc
 fjp l128
 mst 0
 cup 0 l36
l128
l129
l130
 ldoc 23
 ldcc '*'
 neqc
 lao 5
 eof
 not
i1050
 and
 fjp l131
 mst 0
 cup 0 l29
 ujp l130
l131
 mst 0
 cup 0 l29
 ldoc 23
 ldcc ')'
 equc
i1060
 lao 5
 eof
 ior
 fjp l129
 mst 0
 cup 0 l29
 ujp l26
l127
 ldci 8
 chki 0 47
 sroi 9
i1070
 ldci 15
 chki 0 15
 sroi 10
 ujp l58
l132
 lao 774
 ldoc 23
 ordc
 chki 0 255
 ixa 1
 indi 0
i1080
 chki 0 47
 sroi 9
 lao 1065
 ldoc 23
 ordc
 chki 0 255
 ixa 1
 indi 0
 chki 0 15
 sroi 10
i1090
 mst 0
 cup 0 l29
 ujp l58
l133
 ldci 47
 chki 0 47
 sroi 9
 ujp l58
l57
 chki 0 10
 ldci 0
 sbi
i1100
 xjp l134
l134
 ujp l59
 ujp l68
 ujp l132
 ujc
 ujp l99
 ujp l112
 ujp l115
 ujp l118
 ujp l123
i1110
 ujp l126
 ujp l133
l58
l56
 retp
l49=267
l50=18
l135
 ent 1 l136
 ent 2 l137
 lda 0 6
 loda 0 5
 chka 1 1073741823
 mov 8
 lao 55
i1120
 ldoi 53
 chki 0 20
 ixa 5
 inda 0
 chka 0 1073741823
 stra 0 15
 loda 0 15
 ldcn
 equa
 fjp l138
i1130
 lao 55
 ldoi 53
 chki 0 20
 ixa 5
 loda 0 5
 chka 0 1073741823
 stoa
 ujp l139
l138
l140
 loda 0 15
 chka 0 1073741823
i1140
 stra 0 14
 loda 0 15
 chka 1 1073741823
 lda 0 6
 equm 8
 fjp l141
 mst 1
 ldci 101
 cup 1 l20
 loda 0 15
i1150
 chka 1 1073741823
 inda 8
 chka 0 1073741823
 stra 0 15
 ldcb 0
 chkb 0 1
 strb 0 16
 ujp l142
l141
 loda 0 15
 chka 1 1073741823
i1160
 lda 0 6
 lesm 8
 fjp l143
 loda 0 15
 chka 1 1073741823
 inda 8
 chka 0 1073741823
 stra 0 15
 ldcb 0
 chkb 0 1
i1170
 strb 0 16
 ujp l144
l143
 loda 0 15
 chka 1 1073741823
 inda 9
 chka 0 1073741823
 stra 0 15
 ldcb 1
 chkb 0 1
 strb 0 16
l144
l142
i1180
 loda 0 15
 ldcn
 equa
 fjp l140
 lodb 0 16
 fjp l145
 loda 0 14
 chka 1 1073741823
 inca 9
 loda 0 5
i1190
 chka 0 1073741823
 stoa
 ujp l146
l145
 loda 0 14
 chka 1 1073741823
 inca 8
 loda 0 5
 chka 0 1073741823
 stoa
l146
l139
 loda 0 5
i1200
 chka 1 1073741823
 inca 9
 ldcn
 chka 0 1073741823
 stoa
 loda 0 5
 chka 1 1073741823
 inca 8
 ldcn
 chka 0 1073741823
i1210
 stoa
 retp
l136=17
l137=8
l147
 ent 1 l149
 ent 2 l150
l151
 loda 0 5
 ldcn
 neqa
 fjp l152
 loda 0 5
 chka 1 1073741823
i1220
 lao 14
 equm 8
 fjp l153
 ujp l148
 ujp l154
l153
 loda 0 5
 chka 1 1073741823
 lao 14
 lesm 8
 fjp l155
i1230
 loda 0 5
 chka 1 1073741823
 inda 8
 chka 0 1073741823
 stra 0 5
 ujp l156
l155
 loda 0 5
 chka 1 1073741823
 inda 9
 chka 0 1073741823
i1240
 stra 0 5
l156
l154
 ujp l151
l152
l148
 loda 0 6
 loda 0 5
 chka 0 1073741823
 stoa
 retp
l149=7
l150=7
l157
 ent 1 l159
 ent 2 l160
 ldoi 53
i1250
 sroi 54
 ldci 0
 stri 0 8
l161
 ldoi 54
 lodi 0 8
 geqi
 fjp l162
 lao 55
 ldoi 54
 chki 0 20
i1260
 ixa 5
 inda 0
 chka 0 1073741823
 stra 0 7
l163
 loda 0 7
 ldcn
 neqa
 fjp l164
 loda 0 7
 chka 1 1073741823
i1270
 lao 14
 equm 8
 fjp l165
 loda 0 7
 chka 1 1073741823
 indi 12
 ordi
 lods 0 5
 inn
 fjp l166
i1280
 ujp l158
 ujp l167
l166
 ldob 32
 fjp l168
 mst 1
 ldci 103
 cup 1 l20
l168
 loda 0 7
 chka 1 1073741823
 inda 8
i1290
 chka 0 1073741823
 stra 0 7
l167
 ujp l169
l165
 loda 0 7
 chka 1 1073741823
 lao 14
 lesm 8
 fjp l170
 loda 0 7
 chka 1 1073741823
i1300
 inda 8
 chka 0 1073741823
 stra 0 7
 ujp l171
l170
 loda 0 7
 chka 1 1073741823
 inda 9
 chka 0 1073741823
 stra 0 7
l171
l169
 ujp l163
l164
i1310
 ldoi 54
 deci 1
 sroi 54
 ujp l161
l162
 ldob 32
 fjp l172
 mst 1
 ldci 104
 cup 1 l20
 ldci 0
i1320
 ordi
 lods 0 5
 inn
 fjp l173
 ldoa 49
 chka 0 1073741823
 stra 0 7
 ujp l174
l173
 ldci 2
 ordi
i1330
 lods 0 5
 inn
 fjp l175
 ldoa 47
 chka 0 1073741823
 stra 0 7
 ujp l176
l175
 ldci 3
 ordi
 lods 0 5
i1340
 inn
 fjp l177
 ldoa 46
 chka 0 1073741823
 stra 0 7
 ujp l178
l177
 ldci 1
 ordi
 lods 0 5
 inn
i1350
 fjp l179
 ldoa 48
 chka 0 1073741823
 stra 0 7
 ujp l180
l179
 ldci 4
 ordi
 lods 0 5
 inn
 fjp l181
i1360
 ldoa 45
 chka 0 1073741823
 stra 0 7
 ujp l182
l181
 ldoa 44
 chka 0 1073741823
 stra 0 7
l182
l180
l178
l176
l174
l172
l158
 loda 0 6
 loda 0 7
 chka 0 1073741823
i1370
 stoa
 retp
l159=9
l160=9
l183
 ent 1 l184
 ent 2 l185
 loda 0 6
 ldci 0
 stoi
 loda 0 7
 ldci 0
 stoi
i1380
 loda 0 5
 ldcn
 neqa
 fjp l186
 loda 0 5
 chka 1 1073741823
 stra 0 8
 loda 0 8
 indi 2
 ldci 1
i1390
 equi
 fjp l187
 loda 0 6
 loda 0 8
 indi 7
 stoi
 loda 0 7
 loda 0 8
 indi 5
 stoi
i1400
 ujp l188
l187
 loda 0 5
 ldoa 39
 equa
 fjp l189
 loda 0 6
 ldci 0
 stoi
 loda 0 7
 ldci 255
i1410
 stoi
 ujp l190
l189
 loda 0 8
 inda 4
 ldcn
 neqa
 fjp l191
 loda 0 7
 loda 0 8
 inda 4
i1420
 chka 1 1073741823
 indi 14
 stoi
l191
l190
l188
l186
 retp
l184=9
l185=7
l192
 ent 1 l193
 ent 2 l194
 ldci 1
 stri 0 0
 loda 0 5
 ldcn
i1430
 neqa
 fjp l195
 loda 0 5
 chka 1 1073741823
 stra 0 6
 loda 0 6
 indi 2
 ordi
 ujp l196
l198
 loda 0 5
i1440
 ldoa 41
 equa
 fjp l199
 ldci 1
 stri 0 0
 ujp l200
l199
 loda 0 5
 ldoa 38
 equa
 fjp l201
i1450
 ldci 1
 stri 0 0
 ujp l202
l201
 loda 0 6
 indi 3
 ldci 1
 equi
 fjp l203
 ldci 1
 stri 0 0
i1460
 ujp l204
l203
 loda 0 5
 ldoa 39
 equa
 fjp l205
 ldci 1
 stri 0 0
 ujp l206
l205
 loda 0 5
 ldoa 40
i1470
 equa
 fjp l207
 ldci 1
 stri 0 0
 ujp l208
l207
 ldci 1
 stri 0 0
l208
l206
l204
l202
l200
 ujp l197
l209
 mst 1
 loda 0 6
i1480
 inda 3
 cup 1 l192
 stri 0 0
 ujp l197
l210
 ldci 1
 stri 0 0
 ujp l197
l211
 ldci 1
 stri 0 0
 ujp l197
l212
i1490
 ldci 1
 stri 0 0
 ujp l197
l213
 mst 1
 loda 0 6
 inda 4
 cup 1 l192
 stri 0 0
 ujp l197
l214
 ldci 1
i1500
 stri 0 0
 ujp l197
l215
 mst 1
 ldci 501
 cup 1 l20
 ujp l197
l196
 chki 0 8
 ldci 0
 sbi
 xjp l216
l216
i1510
 ujp l198
 ujp l209
 ujp l210
 ujp l211
 ujp l213
 ujp l214
 ujp l212
 ujp l215
 ujp l215
l197
l195
 reti
l193=7
l194=8
l217
i1520
 ent 1 l218
 ent 2 l219
 mst 1
 loda 0 5
 cup 1 l192
 stri 0 8
 loda 0 6
 indi 0
 ldci 1
 sbi
i1530
 stri 0 7
 loda 0 6
 lodi 0 7
 lodi 0 8
 adi
 lodi 0 8
 lodi 0 7
 adi
 lodi 0 8
 mod
i1540
 sbi
 chki 0 1073741823
 stoi
 retp
l218=9
l219=9
l223
 ent 1 l224
 ent 2 l225
 loda 0 5
 ldcn
 neqa
 fjp l226
i1550
 loda 0 5
 chka 1 1073741823
 stra 0 6
 loda 0 6
 ldcb 1
 chkb 0 1
 stob
 loda 0 6
 indi 2
 ordi
i1560
 ujp l227
l229
 ujp l228
l230
 mst 1
 loda 0 6
 inda 3
 cup 1 l223
 ujp l228
l231
 ujp l228
l232
 mst 1
 loda 0 6
i1570
 inda 3
 cup 1 l223
 ujp l228
l233
 mst 1
 loda 0 6
 inda 4
 cup 1 l223
 mst 1
 loda 0 6
 inda 3
i1580
 cup 1 l223
 ujp l228
l234
 mst 1
 loda 0 6
 inda 3
 cup 1 l222
 mst 1
 loda 0 6
 inda 4
 cup 1 l223
i1590
 ujp l228
l235
 mst 1
 loda 0 6
 inda 3
 cup 1 l223
 ujp l228
l236
 mst 1
 loda 0 6
 inda 4
 cup 1 l223
i1600
 ujp l228
l237
 mst 1
 loda 0 6
 inda 4
 cup 1 l223
 mst 1
 loda 0 6
 inda 3
 cup 1 l223
 ujp l228
l227
i1610
 chki 0 8
 ldci 0
 sbi
 xjp l238
l238
 ujp l229
 ujp l230
 ujp l231
 ujp l232
 ujp l233
 ujp l234
i1620
 ujp l235
 ujp l236
 ujp l237
l228
l226
 retp
l224=7
l225=17
l222
 ent 1 l239
 ent 2 l240
 loda 0 5
 ldcn
 neqa
 fjp l241
i1630
 loda 0 5
 chka 1 1073741823
 stra 0 6
 mst 1
 loda 0 6
 inda 9
 cup 1 l222
 mst 1
 loda 0 6
 inda 8
i1640
 cup 1 l222
 mst 1
 loda 0 6
 inda 10
 cup 1 l223
l241
 retp
l239=7
l240=8
l221
 ent 1 l242
 ent 2 l243
 ldoi 53
 stri 0 5
i1650
 lodi 1 6
 stri 0 6
l244
 lodi 0 5
 lodi 0 6
 geqi
 fjp l245
 mst 0
 lao 55
 lodi 0 5
 chki 0 20
i1660
 ixa 5
 inda 0
 cup 1 l222
 lodi 0 5
 deci 1
 stri 0 5
 ujp l244
l245
 retp
l242=7
l243=7
l247
 ent 1 l248
 ent 2 l249
i1670
 loda 0 5
 ldcn
 neqa
 fjp l250
 loda 0 5
 chka 1 1073741823
 stra 0 6
 loda 0 6
 indb 0
 fjp l251
i1680
 loda 0 6
 ldcb 0
 chkb 0 1
 stob
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 5
 orda
i1690
 ldci 6
 lda 2 6
 csp wri
 loda 0 6
 indi 1
 ldci 10
 lda 2 6
 csp wri
 loda 0 6
 indi 2
i1700
 ordi
 ujp l252
l254
 lca'scalar'
 ldci 10
 ldci 6
 lda 2 6
 csp wrs
 loda 0 6
 indi 3
 ldci 0
i1710
 equi
 fjp l255
 lca'standard'
 ldci 10
 ldci 8
 lda 2 6
 csp wrs
 ujp l256
l255
 lca'declared'
 ldci 10
i1720
 ldci 8
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
 inda 4
 orda
i1730
 ldci 6
 lda 2 6
 csp wri
l256
 lda 2 6
 csp wln
 ujp l253
l257
 lca'subrange'
 ldci 10
 ldci 8
 lda 2 6
i1740
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
 inda 3
 orda
 ldci 6
 lda 2 6
i1750
 csp wri
 loda 0 6
 inda 3
 ldoa 40
 neqa
 fjp l258
 loda 0 6
 indi 7
 ldci 10
 lda 2 6
i1760
 csp wri
 loda 0 6
 indi 5
 ldci 10
 lda 2 6
 csp wri
 ujp l259
l258
 loda 0 6
 inda 7
 ldcn
i1770
 neqa
 loda 0 6
 inda 5
 ldcn
 neqa
 and
 fjp l260
 ldcc ' '
 ldci 1
 lda 2 6
i1780
 csp wrc
 loda 0 6
 inda 7
 chka 1 1073741823
 inca 1
 ldci 9
 ldci 128
 lda 2 6
 csp wrs
 ldcc ' '
i1790
 ldci 1
 lda 2 6
 csp wrc
 loda 0 6
 inda 5
 chka 1 1073741823
 inca 1
 ldci 9
 ldci 128
 lda 2 6
i1800
 csp wrs
l260
l259
 lda 2 6
 csp wln
 mst 1
 loda 0 6
 inda 3
 cup 1 l247
 ujp l253
l261
 lca'pointer'
 ldci 10
i1810
 ldci 7
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
 inda 3
 orda
i1820
 ldci 6
 lda 2 6
 csp wri
 lda 2 6
 csp wln
 ujp l253
l262
 lca'set'
 ldci 10
 ldci 3
 lda 2 6
i1830
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
 inda 3
 orda
 ldci 6
 lda 2 6
i1840
 csp wri
 lda 2 6
 csp wln
 mst 1
 loda 0 6
 inda 3
 cup 1 l247
 ujp l253
l263
 lca'array'
 ldci 10
i1850
 ldci 5
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
 inda 4
 orda
i1860
 ldci 6
 lda 2 6
 csp wri
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
 inda 3
 orda
i1870
 ldci 6
 lda 2 6
 csp wri
 lda 2 6
 csp wln
 mst 1
 loda 0 6
 inda 4
 cup 1 l247
 mst 1
i1880
 loda 0 6
 inda 3
 cup 1 l247
 ujp l253
l264
 lca'record'
 ldci 10
 ldci 6
 lda 2 6
 csp wrs
 ldcc ' '
i1890
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
 inda 3
 orda
 ldci 6
 lda 2 6
 csp wri
 ldcc ' '
i1900
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
 inda 4
 orda
 ldci 6
 lda 2 6
 csp wri
 lda 2 6
i1910
 csp wln
 mst 1
 loda 0 6
 inda 3
 cup 1 l246
 mst 1
 loda 0 6
 inda 4
 cup 1 l247
 ujp l253
l265
i1920
 lca'file'
 ldci 10
 ldci 4
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
i1930
 inda 3
 orda
 ldci 6
 lda 2 6
 csp wri
 mst 1
 loda 0 6
 inda 3
 cup 1 l247
 ujp l253
l266
i1940
 lca'tagfld'
 ldci 10
 ldci 6
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
i1950
 inda 3
 orda
 ldci 6
 lda 2 6
 csp wri
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 6
i1960
 inda 4
 orda
 ldci 6
 lda 2 6
 csp wri
 lda 2 6
 csp wln
 mst 1
 loda 0 6
 inda 4
i1970
 cup 1 l247
 ujp l253
l267
 lca'variant'
 ldci 10
 ldci 7
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
i1980
 csp wrc
 loda 0 6
 inda 4
 orda
 ldci 6
 lda 2 6
 csp wri
 ldcc ' '
 ldci 4
 lda 2 6
i1990
 csp wrc
 loda 0 6
 inda 3
 orda
 ldci 6
 lda 2 6
 csp wri
 loda 0 6
 indi 6
 ldci 10
i2000
 lda 2 6
 csp wri
 lda 2 6
 csp wln
 mst 1
 loda 0 6
 inda 4
 cup 1 l247
 mst 1
 loda 0 6
i2010
 inda 3
 cup 1 l247
 ujp l253
l252
 chki 0 8
 ldci 0
 sbi
 xjp l268
l268
 ujp l254
 ujp l257
 ujp l261
i2020
 ujp l262
 ujp l263
 ujp l264
 ujp l265
 ujp l266
 ujp l267
l253
l251
l250
 retp
l248=7
l249=18
l246
 ent 1 l269
 ent 2 l270
 loda 0 5
i2030
 ldcn
 neqa
 fjp l271
 loda 0 5
 chka 1 1073741823
 stra 0 7
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
i2040
 loda 0 5
 orda
 ldci 6
 lda 2 6
 csp wri
 ldcc ' '
 ldci 1
 lda 2 6
 csp wrc
 loda 0 7
i2050
 ldci 9
 ldci 8
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 7
 inda 9
i2060
 orda
 ldci 6
 lda 2 6
 csp wri
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 7
 inda 8
i2070
 orda
 ldci 6
 lda 2 6
 csp wri
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 7
 inda 10
i2080
 orda
 ldci 6
 lda 2 6
 csp wri
 loda 0 7
 indi 12
 ordi
 ujp l272
l274
 lca'type'
 ldci 10
i2090
 ldci 4
 lda 2 6
 csp wrs
 ujp l273
l275
 lca'constant'
 ldci 10
 ldci 8
 lda 2 6
 csp wrs
 ldcc ' '
i2100
 ldci 4
 lda 2 6
 csp wrc
 loda 0 7
 inda 11
 orda
 ldci 6
 lda 2 6
 csp wri
 loda 0 7
i2110
 inda 10
 ldcn
 neqa
 fjp l276
 loda 0 7
 inda 10
 ldoa 40
 equa
 fjp l277
 loda 0 7
i2120
 inda 14
 ldcn
 neqa
 fjp l278
 ldcc ' '
 ldci 1
 lda 2 6
 csp wrc
 loda 0 7
 inda 14
i2130
 chka 1 1073741823
 inca 1
 ldci 9
 ldci 128
 lda 2 6
 csp wrs
l278
 ujp l279
l277
 loda 0 7
 inda 10
 chka 1 1073741823
i2140
 indi 2
 ldci 4
 equi
 fjp l280
 loda 0 7
 inda 14
 ldcn
 neqa
 fjp l281
 ldcc ' '
i2150
 ldci 1
 lda 2 6
 csp wrc
 loda 0 7
 inda 14
 chka 1 1073741823
 stra 0 8
 ldci 1
 stri 0 6
 loda 0 8
i2160
 indi 1
 stri 0 9
l282
 lodi 0 6
 lodi 0 9
 leqi
 fjp l283
 loda 0 8
 inca 2
 lodi 0 6
 chki 1 128
i2170
 deci 1
 ixa 1
 indc 0
 ldci 1
 lda 2 6
 csp wrc
 lodi 0 6
 inci 1
 stri 0 6
 ujp l282
l283
l281
i2180
 ujp l284
l280
 loda 0 7
 indi 14
 ldci 10
 lda 2 6
 csp wri
l284
l279
l276
 ujp l273
l285
 lca'variable'
 ldci 10
 ldci 8
i2190
 lda 2 6
 csp wrs
 loda 0 7
 indi 13
 ldci 0
 equi
 fjp l286
 lca'actual'
 ldci 10
 ldci 6
i2200
 lda 2 6
 csp wrs
 ujp l287
l286
 lca'formal'
 ldci 10
 ldci 6
 lda 2 6
 csp wrs
l287
 ldcc ' '
 ldci 4
i2210
 lda 2 6
 csp wrc
 loda 0 7
 inda 11
 orda
 ldci 6
 lda 2 6
 csp wri
 loda 0 7
 indi 14
i2220
 ldci 10
 lda 2 6
 csp wri
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 7
 indi 15
 ldci 6
i2230
 lda 2 6
 csp wri
 ujp l273
l288
 lca'field'
 ldci 10
 ldci 5
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
i2240
 lda 2 6
 csp wrc
 loda 0 7
 inda 11
 orda
 ldci 6
 lda 2 6
 csp wri
 ldcc ' '
 ldci 4
i2250
 lda 2 6
 csp wrc
 loda 0 7
 indi 13
 ldci 6
 lda 2 6
 csp wri
 ujp l273
l289
 loda 0 7
 indi 12
i2260
 ldci 4
 equi
 fjp l290
 lca'procedure'
 ldci 10
 ldci 9
 lda 2 6
 csp wrs
 ujp l291
l290
 lca'function'
i2270
 ldci 10
 ldci 8
 lda 2 6
 csp wrs
l291
 loda 0 7
 indi 13
 ldci 0
 equi
 fjp l292
 lca'standard'
i2280
 ldci 10
 ldci 8
 lda 2 6
 csp wrs
 loda 0 7
 indi 14
 ldci 10
 lda 2 6
 csp wri
 ujp l293
l292
i2290
 lca'declared'
 ldci 10
 ldci 8
 lda 2 6
 csp wrs
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 7
i2300
 inda 11
 orda
 ldci 6
 lda 2 6
 csp wri
 loda 0 7
 indi 14
 ldci 10
 lda 2 6
 csp wri
i2310
 ldcc ' '
 ldci 4
 lda 2 6
 csp wrc
 loda 0 7
 indi 15
 ldci 6
 lda 2 6
 csp wri
 loda 0 7
i2320
 indi 16
 ldci 0
 equi
 fjp l294
 lca'actual'
 ldci 10
 ldci 6
 lda 2 6
 csp wrs
 loda 0 7
i2330
 indb 18
 fjp l295
 lca'forward'
 ldci 10
 ldci 7
 lda 2 6
 csp wrs
 ujp l296
l295
 lca'notforward'
 ldci 10
i2340
 ldci 10
 lda 2 6
 csp wrs
l296
 loda 0 7
 indb 17
 fjp l297
 lca'extern'
 ldci 10
 ldci 6
 lda 2 6
i2350
 csp wrs
 ujp l298
l297
 lca'not extern'
 ldci 10
 ldci 10
 lda 2 6
 csp wrs
l298
 ujp l299
l294
 lca'formal'
 ldci 10
i2360
 ldci 6
 lda 2 6
 csp wrs
l299
l293
 ujp l273
l272
 chki 0 5
 ldci 0
 sbi
 xjp l300
l300
 ujp l274
 ujp l275
i2370
 ujp l285
 ujp l288
 ujp l289
 ujp l289
l273
 lda 2 6
 csp wln
 mst 1
 loda 0 7
 inda 9
 cup 1 l246
i2380
 mst 1
 loda 0 7
 inda 8
 cup 1 l246
 mst 1
 loda 0 7
 inda 10
 cup 1 l247
l271
 retp
l269=10
l270=10
l220
 ent 1 l301
i2390
 ent 2 l302
 lda 1 6
 csp wln
 lda 1 6
 csp wln
 lda 1 6
 csp wln
 lodb 0 5
 fjp l303
 ldci 0
i2400
 chki 0 20
 stri 0 6
 ujp l304
l303
 ldoi 53
 chki 0 20
 stri 0 6
 lca' local'
 ldci 6
 ldci 6
 lda 1 6
i2410
 csp wrs
l304
 lca' tables '
 ldci 8
 ldci 8
 lda 1 6
 csp wrs
 lda 1 6
 csp wln
 lda 1 6
 csp wln
i2420
 mst 0
 cup 0 l221
 ldoi 53
 stri 0 7
 lodi 0 6
 stri 0 8
l305
 lodi 0 7
 lodi 0 8
 geqi
 fjp l306
i2430
 mst 0
 lao 55
 lodi 0 7
 chki 0 20
 ixa 5
 inda 0
 cup 1 l246
 lodi 0 7
 deci 1
 stri 0 7
i2440
 ujp l305
l306
 lda 1 6
 csp wln
 ldob 24
 not
 fjp l307
 ldcc ' '
 ldoi 25
 ldci 16
 adi
i2450
 lda 1 6
 csp wrc
l307
 retp
l301=9
l302=9
l308
 ent 1 l309
 ent 2 l310
 ldoi 2279
 ldci 1
 adi
 sroi 2279
 loda 0 5
i2460
 ldoi 2279
 stoi
 retp
l309=6
l310=7
l312
 ent 1 l313
 ent 2 l314
 lao 5
 eof
 not
 fjp l315
l316
 ldoi 9
i2470
 ordi
 lods 0 5
 inn
 not
 lao 5
 eof
 not
 and
 fjp l317
 mst 2
i2480
 cup 0 l25
 ujp l316
l317
 ldoi 9
 ordi
 lods 0 5
 inn
 not
 fjp l318
 mst 2
 cup 0 l25
l318
l315
i2490
 retp
l313=6
l314=7
l319
 ent 1 l320
 ent 2 l321
 ldcn
 chka 0 1073741823
 stra 0 8
 loda 0 7
 inca 1
 ldci 0
 stoi
i2500
 ldoi 9
 ordi
 ldos 193
 inn
 not
 fjp l322
 mst 2
 ldci 50
 cup 1 l20
 mst 1
i2510
 lods 0 5
 ldos 193
 uni
 cup 1 l312
l322
 ldoi 9
 ordi
 ldos 193
 inn
 fjp l323
 ldoi 9
i2520
 ldci 3
 equi
 fjp l324
 ldoi 13
 ldci 1
 equi
 fjp l325
 ldoa 39
 chka 0 1073741823
 stra 0 8
i2530
 ujp l326
l325
 lda 0 8
 ldci 5
 csp new
 loda 0 8
 chka 1 1073741823
 stra 0 13
 loda 0 13
 inca 4
 ldoa 39
i2540
 chka 0 1073741823
 stoa
 loda 0 13
 inca 3
 ldcn
 chka 0 1073741823
 stoa
 loda 0 13
 inca 1
 ldoi 13
i2550
 ldci 1
 mpi
 chki 0 1073741823
 stoi
 loda 0 13
 inca 2
 ldci 4
 chki 0 8
 stoi
l326
 loda 0 7
i2560
 lao 11
 mov 2
 mst 2
 cup 0 l25
 ujp l327
l324
 ldci 0
 chki 0 2
 stri 0 10
 ldoi 9
 ldci 6
i2570
 equi
 ldoi 10
 ordi
 ldc( 5 6)
 inn
 and
 fjp l328
 ldoi 10
 ldci 5
 equi
i2580
 fjp l329
 ldci 1
 chki 0 2
 stri 0 10
 ujp l330
l329
 ldci 2
 chki 0 2
 stri 0 10
l330
 mst 2
 cup 0 l25
l328
i2590
 ldoi 9
 ldci 0
 equi
 fjp l331
 mst 2
 ldc( 1)
 lda 0 9
 cup 2 l157
 loda 0 9
 chka 1 1073741823
i2600
 stra 0 13
 loda 0 13
 inda 10
 chka 0 1073741823
 stra 0 8
 loda 0 7
 loda 0 13
 inca 13
 mov 2
 lodi 0 10
i2610
 ldci 0
 neqi
 fjp l332
 loda 0 8
 ldoa 41
 equa
 fjp l333
 lodi 0 10
 ldci 2
 equi
i2620
 fjp l334
 loda 0 7
 inca 1
 loda 0 7
 indi 1
 ngi
 stoi
l334
 ujp l335
l333
 loda 0 8
 ldoa 40
i2630
 equa
 fjp l336
 lodi 0 10
 ldci 2
 equi
 fjp l337
 lda 0 11
 ldci 129
 csp new
 loda 0 7
i2640
 inda 1
 chka 1 1073741823
 inca 1
 ldci 1
 chki 1 128
 deci 1
 ixa 1
 indc 0
 ldcc '-'
 equc
i2650
 fjp l338
 loda 0 11
 chka 1 1073741823
 inca 1
 ldci 1
 chki 1 128
 deci 1
 ixa 1
 ldcc '+'
 chkc 0 255
i2660
 stoc
 ujp l339
l338
 loda 0 11
 chka 1 1073741823
 inca 1
 ldci 1
 chki 1 128
 deci 1
 ixa 1
 ldcc '-'
i2670
 chkc 0 255
 stoc
l339
 ldci 2
 stri 0 12
 ldci 128
 stri 0 13
l340
 lodi 0 12
 lodi 0 13
 leqi
 fjp l341
i2680
 loda 0 11
 chka 1 1073741823
 inca 1
 lodi 0 12
 chki 1 128
 deci 1
 ixa 1
 loda 0 7
 inda 1
 chka 1 1073741823
i2690
 inca 1
 lodi 0 12
 chki 1 128
 deci 1
 ixa 1
 indc 0
 chkc 0 255
 stoc
 lodi 0 12
 inci 1
i2700
 stri 0 12
 ujp l340
l341
 loda 0 7
 inca 1
 loda 0 11
 chka 0 1073741823
 stoa
l337
 ujp l342
l336
 mst 2
 ldci 105
i2710
 cup 1 l20
l342
l335
l332
 mst 2
 cup 0 l25
 ujp l343
l331
 ldoi 9
 ldci 1
 equi
 fjp l344
 lodi 0 10
 ldci 2
i2720
 equi
 fjp l345
 ldoi 12
 ngi
 sroi 12
l345
 ldoa 41
 chka 0 1073741823
 stra 0 8
 loda 0 7
 lao 11
i2730
 mov 2
 mst 2
 cup 0 l25
 ujp l346
l344
 ldoi 9
 ldci 2
 equi
 fjp l347
 lodi 0 10
 ldci 2
i2740
 equi
 fjp l348
 ldoa 12
 chka 1 1073741823
 inca 1
 ldci 1
 chki 1 128
 deci 1
 ixa 1
 ldcc '-'
i2750
 chkc 0 255
 stoc
l348
 ldoa 40
 chka 0 1073741823
 stra 0 8
 loda 0 7
 lao 11
 mov 2
 mst 2
 cup 0 l25
i2760
 ujp l349
l347
 mst 2
 ldci 106
 cup 1 l20
 mst 1
 lods 0 5
 cup 1 l312
l349
l346
l343
l327
 ldoi 9
 ordi
 lods 0 5
i2770
 inn
 not
 fjp l350
 mst 2
 ldci 6
 cup 1 l20
 mst 1
 lods 0 5
 cup 1 l312
l350
l323
 loda 0 6
i2780
 loda 0 8
 chka 0 1073741823
 stoa
 retp
l320=14
l321=16
l351
 ent 1 l352
 ent 2 l353
 loda 0 5
 ldcn
 equa
 loda 0 6
i2790
 ldcn
 equa
 ior
 fjp l354
 ldcb 1
 chkb 0 1
 strb 0 0
 ujp l355
l354
 mst 2
 loda 0 5
i2800
 lda 0 10
 lda 0 8
 cup 3 l183
 mst 2
 loda 0 6
 lda 0 9
 lda 0 7
 cup 3 l183
 lodi 0 10
 lodi 0 9
i2810
 equi
 lodi 0 8
 lodi 0 7
 equi
 and
 chkb 0 1
 strb 0 0
l355
 retb
l352=11
l353=14
l356
 ent 1 l357
 ent 2 l358
i2820
 loda 0 5
 loda 0 6
 equa
 fjp l359
 ldcb 1
 chkb 0 1
 strb 0 0
 ujp l360
l359
 loda 0 5
 ldcn
i2830
 neqa
 loda 0 6
 ldcn
 neqa
 and
 fjp l361
 loda 0 5
 chka 1 1073741823
 indi 2
 loda 0 6
i2840
 chka 1 1073741823
 indi 2
 equi
 fjp l362
 loda 0 5
 chka 1 1073741823
 indi 2
 ordi
 ujp l363
l365
 ldcb 0
i2850
 chkb 0 1
 strb 0 0
 ujp l364
l366
 mst 1
 loda 0 5
 chka 1 1073741823
 inda 3
 loda 0 6
 chka 1 1073741823
 inda 3
i2860
 cup 2 l356
 chkb 0 1
 strb 0 0
 ujp l364
l367
 ldcb 0
 chkb 0 1
 strb 0 9
 ldoa 51
 chka 0 1073741823
 stra 0 11
i2870
 ldoa 51
 chka 0 1073741823
 stra 0 10
l368
 loda 0 11
 ldcn
 neqa
 fjp l369
 loda 0 11
 chka 1 1073741823
 stra 0 12
i2880
 loda 0 12
 inda 1
 loda 0 5
 chka 1 1073741823
 inda 3
 equa
 loda 0 12
 inda 0
 loda 0 6
 chka 1 1073741823
i2890
 inda 3
 equa
 and
 fjp l370
 ldcb 1
 chkb 0 1
 strb 0 9
l370
 loda 0 12
 inda 2
 chka 0 1073741823
i2900
 stra 0 11
 ujp l368
l369
 lodb 0 9
 not
 fjp l371
 lda 0 11
 ldci 3
 csp new
 loda 0 11
 chka 1 1073741823
i2910
 stra 0 12
 loda 0 12
 inca 1
 loda 0 5
 chka 1 1073741823
 inda 3
 chka 0 1073741823
 stoa
 loda 0 12
 loda 0 6
i2920
 chka 1 1073741823
 inda 3
 chka 0 1073741823
 stoa
 loda 0 12
 inca 2
 ldoa 51
 chka 0 1073741823
 stoa
 loda 0 11
i2930
 chka 0 1073741823
 sroa 51
 mst 1
 loda 0 5
 chka 1 1073741823
 inda 3
 loda 0 6
 chka 1 1073741823
 inda 3
 cup 2 l356
i2940
 chkb 0 1
 strb 0 9
l371
 lodb 0 9
 chkb 0 1
 strb 0 0
 loda 0 10
 chka 0 1073741823
 sroa 51
 ujp l364
l372
 mst 1
i2950
 loda 0 5
 chka 1 1073741823
 inda 3
 loda 0 6
 chka 1 1073741823
 inda 3
 cup 2 l356
 chkb 0 1
 strb 0 0
 ujp l364
l373
i2960
 mst 1
 loda 0 5
 chka 1 1073741823
 inda 4
 loda 0 6
 chka 1 1073741823
 inda 4
 cup 2 l356
 mst 1
 loda 0 5
i2970
 chka 1 1073741823
 inda 3
 loda 0 6
 chka 1 1073741823
 inda 3
 cup 2 l356
 and
 chkb 0 1
 strb 0 9
 lodb 0 9
i2980
 loda 0 5
 chka 1 1073741823
 indi 1
 loda 0 6
 chka 1 1073741823
 indi 1
 equi
 and
 mst 1
 loda 0 5
i2990
 chka 1 1073741823
 inda 3
 loda 0 6
 chka 1 1073741823
 inda 3
 cup 2 l351
 and
 chkb 0 1
 strb 0 0
 ujp l364
l374
i3000
 loda 0 5
 chka 1 1073741823
 inda 3
 chka 0 1073741823
 stra 0 8
 loda 0 6
 chka 1 1073741823
 inda 3
 chka 0 1073741823
 stra 0 7
i3010
 ldcb 1
 chkb 0 1
 strb 0 9
l375
 loda 0 8
 ldcn
 neqa
 loda 0 7
 ldcn
 neqa
 and
i3020
 fjp l376
 lodb 0 9
 mst 1
 loda 0 8
 chka 1 1073741823
 inda 10
 loda 0 7
 chka 1 1073741823
 inda 10
 cup 2 l356
i3030
 and
 chkb 0 1
 strb 0 9
 loda 0 8
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 8
 loda 0 7
 chka 1 1073741823
i3040
 inda 11
 chka 0 1073741823
 stra 0 7
 ujp l375
l376
 lodb 0 9
 loda 0 8
 ldcn
 equa
 and
 loda 0 7
i3050
 ldcn
 equa
 and
 loda 0 5
 chka 1 1073741823
 inda 4
 ldcn
 equa
 and
 loda 0 6
i3060
 chka 1 1073741823
 inda 4
 ldcn
 equa
 and
 chkb 0 1
 strb 0 0
 ujp l364
l377
 mst 1
 loda 0 5
i3070
 chka 1 1073741823
 inda 3
 loda 0 6
 chka 1 1073741823
 inda 3
 cup 2 l356
 chkb 0 1
 strb 0 0
 ujp l364
l363
 chki 0 6
i3080
 ldci 0
 sbi
 xjp l378
l378
 ujp l365
 ujp l366
 ujp l367
 ujp l372
 ujp l373
 ujp l374
 ujp l377
l364
i3090
 ujp l379
l362
 loda 0 5
 chka 1 1073741823
 indi 2
 ldci 1
 equi
 fjp l380
 mst 1
 loda 0 5
 chka 1 1073741823
i3100
 inda 3
 loda 0 6
 cup 2 l356
 chkb 0 1
 strb 0 0
 ujp l381
l380
 loda 0 6
 chka 1 1073741823
 indi 2
 ldci 1
i3110
 equi
 fjp l382
 mst 1
 loda 0 5
 loda 0 6
 chka 1 1073741823
 inda 3
 cup 2 l356
 chkb 0 1
 strb 0 0
i3120
 ujp l383
l382
 ldcb 0
 chkb 0 1
 strb 0 0
l383
l381
l379
 ujp l384
l361
 ldcb 1
 chkb 0 1
 strb 0 0
l384
l360
 retb
l357=13
l358=16
l385
 ent 1 l386
i3130
 ent 2 l387
 ldcb 0
 chkb 0 1
 strb 0 0
 loda 0 5
 ldcn
 neqa
 fjp l388
 loda 0 5
 chka 1 1073741823
i3140
 indi 2
 ldci 4
 equi
 fjp l389
 mst 1
 loda 0 5
 chka 1 1073741823
 inda 4
 ldoa 39
 cup 2 l356
i3150
 fjp l390
 ldcb 1
 chkb 0 1
 strb 0 0
l390
l389
l388
 retb
l386=6
l387=7
l392
 ent 1 l393
 ent 2 l394
 loda 0 7
 ldci 1
 chki 0 1073741823
i3160
 stoi
 ldoi 9
 ordi
 ldos 192
 inn
 not
 fjp l395
 mst 3
 ldci 1
 cup 1 l20
i3170
 mst 2
 lods 0 5
 ldos 192
 uni
 cup 1 l312
l395
 ldoi 9
 ordi
 ldos 192
 inn
 fjp l396
i3180
 ldoi 9
 ldci 8
 equi
 fjp l397
 ldoi 53
 chki 0 20
 stri 0 12
l398
 lao 55
 ldoi 53
 chki 0 20
i3190
 ixa 5
 indi 2
 ldci 0
 neqi
 fjp l399
 ldoi 53
 ldci 1
 sbi
 chki 0 20
 sroi 53
i3200
 ujp l398
l399
 lda 0 9
 ldci 5
 csp new
 loda 0 9
 chka 1 1073741823
 stra 0 16
 loda 0 16
 inca 1
 ldci 1
i3210
 chki 0 1073741823
 stoi
 loda 0 16
 inca 2
 ldci 0
 chki 0 8
 stoi
 loda 0 16
 inca 3
 ldci 1
i3220
 chki 0 1
 stoi
 ldcn
 chka 0 1073741823
 stra 0 10
 ldci 0
 stri 0 13
l400
 mst 3
 cup 0 l25
 ldoi 9
i3230
 ldci 0
 equi
 fjp l401
 lda 0 11
 ldci 15
 csp new
 loda 0 11
 chka 1 1073741823
 stra 0 16
 loda 0 16
i3240
 lao 14
 mov 8
 loda 0 16
 inca 10
 loda 0 9
 chka 0 1073741823
 stoa
 loda 0 16
 inca 11
 loda 0 10
i3250
 chka 0 1073741823
 stoa
 loda 0 16
 inca 14
 lodi 0 13
 stoi
 loda 0 16
 inca 12
 ldci 1
 chki 0 5
i3260
 stoi
 mst 3
 loda 0 11
 cup 1 l135
 lodi 0 13
 ldci 1
 adi
 stri 0 13
 loda 0 11
 chka 0 1073741823
i3270
 stra 0 10
 mst 3
 cup 0 l25
 ujp l402
l401
 mst 3
 ldci 2
 cup 1 l20
l402
 ldoi 9
 ordi
 lods 0 5
i3280
 ldc( 9 12)
 uni
 inn
 not
 fjp l403
 mst 3
 ldci 6
 cup 1 l20
 mst 2
 lods 0 5
i3290
 ldc( 9 12)
 uni
 cup 1 l312
l403
 ldoi 9
 ldci 12
 neqi
 fjp l400
 loda 0 9
 chka 1 1073741823
 inca 4
i3300
 loda 0 10
 chka 0 1073741823
 stoa
 lodi 0 12
 chki 0 20
 sroi 53
 ldoi 9
 ldci 9
 equi
 fjp l404
i3310
 mst 3
 cup 0 l25
 ujp l405
l404
 mst 3
 ldci 4
 cup 1 l20
l405
 ujp l406
l397
 ldoi 9
 ldci 0
 equi
i3320
 fjp l407
 mst 3
 ldc( 0 1)
 lda 0 11
 cup 2 l157
 mst 3
 cup 0 l25
 loda 0 11
 chka 1 1073741823
 indi 12
i3330
 ldci 1
 equi
 fjp l408
 lda 0 9
 ldci 8
 csp new
 loda 0 9
 chka 1 1073741823
 stra 0 16
 loda 0 11
i3340
 chka 1 1073741823
 stra 0 17
 loda 0 16
 inca 3
 loda 0 17
 inda 10
 chka 0 1073741823
 stoa
 loda 0 16
 inca 2
i3350
 ldci 1
 chki 0 8
 stoi
 mst 2
 loda 0 16
 inda 3
 cup 1 l385
 fjp l409
 mst 3
 ldci 148
i3360
 cup 1 l20
 loda 0 16
 inca 3
 ldcn
 chka 0 1073741823
 stoa
l409
 loda 0 16
 inca 6
 loda 0 17
 inca 13
i3370
 mov 2
 loda 0 16
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
 ldoi 9
 ldci 16
 equi
 fjp l410
i3380
 mst 3
 cup 0 l25
 ujp l411
l410
 mst 3
 ldci 5
 cup 1 l20
l411
 mst 2
 lods 0 5
 lda 0 8
 lda 0 14
i3390
 cup 3 l319
 loda 0 9
 chka 1 1073741823
 inca 4
 lda 0 14
 mov 2
 loda 0 9
 chka 1 1073741823
 inda 3
 loda 0 8
i3400
 neqa
 fjp l412
 mst 3
 ldci 107
 cup 1 l20
l412
 ujp l413
l408
 loda 0 11
 chka 1 1073741823
 inda 10
 chka 0 1073741823
i3410
 stra 0 9
 loda 0 9
 ldcn
 neqa
 fjp l414
 loda 0 7
 loda 0 9
 chka 1 1073741823
 indi 1
 chki 0 1073741823
i3420
 stoi
l414
l413
 ujp l415
l407
 lda 0 9
 ldci 8
 csp new
 loda 0 9
 chka 1 1073741823
 inca 2
 ldci 1
 chki 0 8
i3430
 stoi
 mst 2
 lods 0 5
 ldc( 16)
 uni
 lda 0 8
 lda 0 14
 cup 3 l319
 mst 2
 loda 0 8
i3440
 cup 1 l385
 fjp l416
 mst 3
 ldci 148
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 8
l416
 loda 0 9
 chka 1 1073741823
i3450
 stra 0 16
 loda 0 16
 inca 3
 loda 0 8
 chka 0 1073741823
 stoa
 loda 0 16
 inca 6
 lda 0 14
 mov 2
i3460
 loda 0 16
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
 ldoi 9
 ldci 16
 equi
 fjp l417
 mst 3
i3470
 cup 0 l25
 ujp l418
l417
 mst 3
 ldci 5
 cup 1 l20
l418
 mst 2
 lods 0 5
 lda 0 8
 lda 0 14
 cup 3 l319
i3480
 loda 0 9
 chka 1 1073741823
 inca 4
 lda 0 14
 mov 2
 loda 0 9
 chka 1 1073741823
 inda 3
 loda 0 8
 neqa
i3490
 fjp l419
 mst 3
 ldci 107
 cup 1 l20
l419
l415
 loda 0 9
 ldcn
 neqa
 fjp l420
 loda 0 9
 chka 1 1073741823
i3500
 stra 0 16
 loda 0 16
 indi 2
 ldci 1
 equi
 fjp l421
 loda 0 16
 inda 3
 ldcn
 neqa
i3510
 fjp l422
 loda 0 16
 inda 3
 ldoa 40
 equa
 fjp l423
 mst 3
 ldci 399
 cup 1 l20
 ujp l424
l423
i3520
 loda 0 16
 indi 7
 loda 0 16
 indi 5
 grti
 fjp l425
 mst 3
 ldci 102
 cup 1 l20
l425
l424
l422
l421
l420
l406
 loda 0 6
i3530
 loda 0 9
 chka 0 1073741823
 stoa
 ldoi 9
 ordi
 lods 0 5
 inn
 not
 fjp l426
 mst 3
i3540
 ldci 6
 cup 1 l20
 mst 2
 lods 0 5
 cup 1 l312
l426
 ujp l427
l396
 loda 0 6
 ldcn
 chka 0 1073741823
 stoa
l427
i3550
 retp
l393=18
l394=35
l428
 ent 1 l429
 ent 2 l430
 ldcn
 chka 0 1073741823
 stra 0 7
 ldcn
 chka 0 1073741823
 stra 0 15
 ldoi 9
i3560
 ordi
 lods 0 5
 ldc( 0 33)
 uni
 inn
 not
 fjp l431
 mst 3
 ldci 19
 cup 1 l20
i3570
 mst 2
 lods 0 5
 ldc( 0 33)
 uni
 cup 1 l312
l431
l432
 ldoi 9
 ldci 0
 equi
 fjp l433
 loda 0 7
i3580
 chka 0 1073741823
 stra 0 8
l434
 ldoi 9
 ldci 0
 equi
 fjp l435
 lda 0 10
 ldci 14
 csp new
 loda 0 10
i3590
 chka 1 1073741823
 stra 0 21
 loda 0 21
 lao 14
 mov 8
 loda 0 21
 inca 10
 ldcn
 chka 0 1073741823
 stoa
i3600
 loda 0 21
 inca 11
 loda 0 8
 chka 0 1073741823
 stoa
 loda 0 21
 inca 12
 ldci 3
 chki 0 5
 stoi
i3610
 loda 0 10
 chka 0 1073741823
 stra 0 8
 mst 3
 loda 0 10
 cup 1 l135
 mst 3
 cup 0 l25
 ujp l436
l435
 mst 3
i3620
 ldci 2
 cup 1 l20
l436
 ldoi 9
 ordi
 ldc( 12 16)
 inn
 not
 fjp l437
 mst 3
 ldci 6
i3630
 cup 1 l20
 mst 2
 lods 0 5
 ldc( 12 13 16 33)
 uni
 cup 1 l312
l437
 ldoi 9
 ldci 12
 neqi
 chkb 0 1
i3640
 strb 2 9
 lodb 2 9
 not
 fjp l438
 mst 3
 cup 0 l25
l438
 lodb 2 9
 fjp l434
 ldoi 9
 ldci 16
i3650
 equi
 fjp l439
 mst 3
 cup 0 l25
 ujp l440
l439
 mst 3
 ldci 5
 cup 1 l20
l440
 mst 2
 lods 0 5
i3660
 ldc( 13 33)
 uni
 lda 0 15
 lda 0 16
 cup 3 l391
l441
 loda 0 8
 loda 0 7
 neqa
 fjp l442
 loda 0 8
i3670
 chka 1 1073741823
 stra 0 21
 mst 3
 loda 0 15
 lda 1 13
 cup 2 l217
 loda 0 21
 inca 10
 loda 0 15
 chka 0 1073741823
i3680
 stoa
 loda 0 21
 inca 13
 lodi 1 13
 chki 0 1073741823
 stoi
 loda 0 21
 inda 11
 chka 0 1073741823
 stra 0 8
i3690
 lodi 1 13
 lodi 0 16
 adi
 chki 0 1073741823
 stri 1 13
 ujp l441
l442
 loda 0 10
 chka 0 1073741823
 stra 0 7
l443
 ldoi 9
i3700
 ldci 13
 equi
 fjp l444
 mst 3
 cup 0 l25
 ldoi 9
 ordi
 lods 0 5
 ldc( 0 13 33)
 uni
i3710
 inn
 not
 fjp l445
 mst 3
 ldci 19
 cup 1 l20
 mst 2
 lods 0 5
 ldc( 0 33)
 uni
i3720
 cup 1 l312
l445
 ujp l443
l444
 ujp l432
l433
 ldcn
 chka 0 1073741823
 stra 0 8
l446
 loda 0 7
 ldcn
 neqa
 fjp l447
i3730
 loda 0 7
 chka 1 1073741823
 stra 0 21
 loda 0 21
 inda 11
 chka 0 1073741823
 stra 0 10
 loda 0 21
 inca 11
 loda 0 8
i3740
 chka 0 1073741823
 stoa
 loda 0 7
 chka 0 1073741823
 stra 0 8
 loda 0 10
 chka 0 1073741823
 stra 0 7
 ujp l446
l447
 ldoi 9
i3750
 ldci 33
 equi
 fjp l448
 lda 0 15
 ldci 5
 csp new
 loda 0 15
 chka 1 1073741823
 stra 0 21
 loda 0 21
i3760
 inca 3
 ldcn
 chka 0 1073741823
 stoa
 loda 0 21
 inca 4
 ldcn
 chka 0 1073741823
 stoa
 loda 0 21
i3770
 inca 2
 ldci 7
 chki 0 8
 stoi
 loda 0 6
 loda 0 15
 chka 0 1073741823
 stoa
 mst 3
 cup 0 l25
i3780
 ldoi 9
 ldci 0
 equi
 fjp l449
 lda 0 10
 ldci 14
 csp new
 loda 0 10
 chka 1 1073741823
 stra 0 21
i3790
 loda 0 21
 lao 14
 mov 8
 loda 0 21
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 21
 inca 12
i3800
 ldci 3
 chki 0 5
 stoi
 loda 0 21
 inca 11
 ldcn
 chka 0 1073741823
 stoa
 loda 0 21
 inca 13
i3810
 lodi 1 13
 chki 0 1073741823
 stoi
 mst 3
 loda 0 10
 cup 1 l135
 mst 3
 cup 0 l25
 ldoi 9
 ldci 16
i3820
 equi
 fjp l450
 mst 3
 cup 0 l25
 ujp l451
l450
 mst 3
 ldci 5
 cup 1 l20
l451
 ldoi 9
 ldci 0
i3830
 equi
 fjp l452
 mst 3
 ldc( 0)
 lda 0 9
 cup 2 l157
 loda 0 9
 chka 1 1073741823
 inda 10
 chka 0 1073741823
i3840
 stra 0 14
 loda 0 14
 ldcn
 neqa
 fjp l453
 mst 3
 loda 0 14
 lda 1 13
 cup 2 l217
 loda 0 10
i3850
 chka 1 1073741823
 inca 13
 lodi 1 13
 chki 0 1073741823
 stoi
 lodi 1 13
 loda 0 14
 chka 1 1073741823
 indi 1
 adi
i3860
 chki 0 1073741823
 stri 1 13
 loda 0 14
 chka 1 1073741823
 indi 2
 ldci 1
 leqi
 mst 2
 loda 0 14
 cup 1 l385
i3870
 ior
 fjp l454
 mst 2
 ldoa 40
 loda 0 14
 cup 2 l356
 fjp l455
 mst 3
 ldci 109
 cup 1 l20
i3880
 ujp l456
l455
 mst 2
 loda 0 14
 cup 1 l385
 fjp l457
 mst 3
 ldci 399
 cup 1 l20
l457
l456
 loda 0 10
 chka 1 1073741823
i3890
 inca 10
 loda 0 14
 chka 0 1073741823
 stoa
 loda 0 15
 chka 1 1073741823
 inca 3
 loda 0 10
 chka 0 1073741823
 stoa
i3900
 ujp l458
l454
 mst 3
 ldci 110
 cup 1 l20
l458
l453
 mst 3
 cup 0 l25
 ujp l459
l452
 mst 3
 ldci 2
 cup 1 l20
i3910
 mst 2
 lods 0 5
 ldc( 8 42)
 uni
 cup 1 l312
l459
 ujp l460
l449
 mst 3
 ldci 2
 cup 1 l20
 mst 2
i3920
 lods 0 5
 ldc( 8 42)
 uni
 cup 1 l312
l460
 loda 0 15
 chka 1 1073741823
 inca 1
 lodi 1 13
 chki 0 1073741823
 stoi
i3930
 ldoi 9
 ldci 42
 equi
 fjp l461
 mst 3
 cup 0 l25
 ujp l462
l461
 mst 3
 ldci 8
 cup 1 l20
l462
i3940
 ldcn
 chka 0 1073741823
 stra 0 14
 lodi 1 13
 chki 0 1073741823
 stri 0 18
 lodi 1 13
 chki 0 1073741823
 stri 0 17
l463
 ldcn
i3950
 chka 0 1073741823
 stra 0 13
 ldoi 9
 ordi
 lods 0 5
 ldc( 13)
 uni
 inn
 not
 fjp l464
l465
i3960
 mst 2
 lods 0 5
 ldc( 8 12 16)
 uni
 lda 0 12
 lda 0 19
 cup 3 l319
 loda 0 15
 chka 1 1073741823
 inda 3
i3970
 ldcn
 neqa
 fjp l466
 mst 2
 loda 0 15
 chka 1 1073741823
 inda 3
 chka 1 1073741823
 inda 10
 loda 0 12
i3980
 cup 2 l356
 not
 fjp l467
 mst 3
 ldci 111
 cup 1 l20
l467
l466
 lda 0 12
 ldci 7
 csp new
 loda 0 12
i3990
 chka 1 1073741823
 stra 0 21
 loda 0 21
 inca 4
 loda 0 14
 chka 0 1073741823
 stoa
 loda 0 21
 inca 3
 loda 0 13
i4000
 chka 0 1073741823
 stoa
 loda 0 21
 inca 5
 lda 0 19
 mov 2
 loda 0 21
 inca 2
 ldci 8
 chki 0 8
i4010
 stoi
 loda 0 14
 chka 0 1073741823
 stra 0 11
l468
 loda 0 11
 ldcn
 neqa
 fjp l469
 loda 0 11
 chka 1 1073741823
i4020
 stra 0 21
 loda 0 21
 indi 6
 lodi 0 20
 equi
 fjp l470
 mst 3
 ldci 178
 cup 1 l20
l470
 loda 0 21
i4030
 inda 4
 chka 0 1073741823
 stra 0 11
 ujp l468
l469
 loda 0 12
 chka 0 1073741823
 stra 0 14
 loda 0 12
 chka 0 1073741823
 stra 0 13
i4040
 ldoi 9
 ldci 12
 neqi
 chkb 0 1
 strb 2 9
 lodb 2 9
 not
 fjp l471
 mst 3
 cup 0 l25
l471
i4050
 lodb 2 9
 fjp l465
 ldoi 9
 ldci 16
 equi
 fjp l472
 mst 3
 cup 0 l25
 ujp l473
l472
 mst 3
i4060
 ldci 5
 cup 1 l20
l473
 ldoi 9
 ldci 8
 equi
 fjp l474
 mst 3
 cup 0 l25
 ujp l475
l474
 mst 3
i4070
 ldci 9
 cup 1 l20
l475
 mst 1
 lods 0 5
 ldc( 9 13)
 uni
 lda 0 13
 cup 2 l428
 lodi 1 13
 lodi 0 17
i4080
 grti
 fjp l476
 lodi 1 13
 chki 0 1073741823
 stri 0 17
l476
l477
 loda 0 12
 ldcn
 neqa
 fjp l478
 loda 0 12
i4090
 chka 1 1073741823
 inda 3
 chka 0 1073741823
 stra 0 11
 loda 0 12
 chka 1 1073741823
 inca 3
 loda 0 13
 chka 0 1073741823
 stoa
i4100
 loda 0 12
 chka 1 1073741823
 inca 1
 lodi 1 13
 chki 0 1073741823
 stoi
 loda 0 11
 chka 0 1073741823
 stra 0 12
 ujp l477
l478
i4110
 ldoi 9
 ldci 9
 equi
 fjp l479
 mst 3
 cup 0 l25
 ldoi 9
 ordi
 lods 0 5
 ldc( 13)
i4120
 uni
 inn
 not
 fjp l480
 mst 3
 ldci 6
 cup 1 l20
 mst 2
 lods 0 5
 ldc( 13)
i4130
 uni
 cup 1 l312
l480
 ujp l481
l479
 mst 3
 ldci 4
 cup 1 l20
l481
l464
 ldoi 9
 ldci 13
 neqi
 chkb 0 1
i4140
 strb 2 9
 lodb 2 9
 not
 fjp l482
 lodi 0 18
 chki 0 1073741823
 stri 1 13
 mst 3
 cup 0 l25
l482
 lodb 2 9
i4150
 fjp l463
 lodi 0 17
 chki 0 1073741823
 stri 1 13
 loda 0 15
 chka 1 1073741823
 inca 4
 loda 0 14
 chka 0 1073741823
 stoa
i4160
 ujp l483
l448
 loda 0 6
 ldcn
 chka 0 1073741823
 stoa
l483
 retp
l429=22
l430=49
l391
 ent 1 l484
 ent 2 l485
 ldoi 9
 ordi
i4170
 ldos 191
 inn
 not
 fjp l486
 mst 2
 ldci 10
 cup 1 l20
 mst 1
 lods 0 5
 ldos 191
i4180
 uni
 cup 1 l312
l486
 ldoi 9
 ordi
 ldos 191
 inn
 fjp l487
 ldoi 9
 ordi
 ldos 192
i4190
 inn
 fjp l488
 mst 0
 lods 0 5
 loda 0 6
 loda 0 7
 cup 3 l392
 ujp l489
l488
 ldoi 9
 ldci 15
i4200
 equi
 fjp l490
 lda 0 10
 ldci 4
 csp new
 loda 0 6
 loda 0 10
 chka 0 1073741823
 stoa
 loda 0 10
i4210
 chka 1 1073741823
 stra 0 17
 loda 0 17
 inca 3
 ldcn
 chka 0 1073741823
 stoa
 loda 0 17
 inca 1
 ldci 1
i4220
 chki 0 1073741823
 stoi
 loda 0 17
 inca 2
 ldci 2
 chki 0 8
 stoi
 mst 2
 cup 0 l25
 ldoi 9
i4230
 ldci 0
 equi
 fjp l491
 ldcb 0
 chkb 0 1
 srob 32
 mst 2
 ldc( 0)
 lda 0 12
 cup 2 l157
i4240
 ldcb 1
 chkb 0 1
 srob 32
 loda 0 12
 ldcn
 equa
 fjp l492
 lda 0 12
 ldci 13
 csp new
i4250
 loda 0 12
 chka 1 1073741823
 stra 0 17
 loda 0 17
 lao 14
 mov 8
 loda 0 17
 inca 10
 loda 0 10
 chka 0 1073741823
i4260
 stoa
 loda 0 17
 inca 11
 ldoa 43
 chka 0 1073741823
 stoa
 loda 0 17
 inca 12
 ldci 0
 chki 0 5
i4270
 stoi
 loda 0 12
 chka 0 1073741823
 sroa 43
 ujp l493
l492
 loda 0 12
 chka 1 1073741823
 inda 10
 ldcn
 neqa
i4280
 fjp l494
 loda 0 12
 chka 1 1073741823
 inda 10
 chka 1 1073741823
 indi 2
 ldci 6
 equi
 fjp l495
 mst 2
i4290
 ldci 108
 cup 1 l20
 ujp l496
l495
 loda 0 10
 chka 1 1073741823
 inca 3
 loda 0 12
 chka 1 1073741823
 inda 10
 chka 0 1073741823
i4300
 stoa
l496
l494
l493
 mst 2
 cup 0 l25
 ujp l497
l491
 mst 2
 ldci 2
 cup 1 l20
l497
 ujp l498
l490
 ldoi 9
 ldci 26
i4310
 equi
 fjp l499
 mst 2
 cup 0 l25
 ldoi 9
 ordi
 ldos 186
 inn
 not
 fjp l500
i4320
 mst 2
 ldci 10
 cup 1 l20
 mst 1
 lods 0 5
 ldos 186
 uni
 cup 1 l312
l500
l499
 ldoi 9
 ldci 27
i4330
 equi
 fjp l501
 mst 2
 cup 0 l25
 ldoi 9
 ldci 10
 equi
 fjp l502
 mst 2
 cup 0 l25
i4340
 ujp l503
l502
 mst 2
 ldci 11
 cup 1 l20
l503
 ldcn
 chka 0 1073741823
 stra 0 9
l504
 lda 0 10
 ldci 5
 csp new
i4350
 loda 0 10
 chka 1 1073741823
 stra 0 17
 loda 0 17
 inca 4
 loda 0 9
 chka 0 1073741823
 stoa
 loda 0 17
 inca 3
i4360
 ldcn
 chka 0 1073741823
 stoa
 loda 0 17
 inca 2
 ldci 4
 chki 0 8
 stoi
 loda 0 10
 chka 0 1073741823
i4370
 stra 0 9
 mst 0
 lods 0 5
 ldc( 11 12 42)
 uni
 lda 0 8
 lda 0 14
 cup 3 l392
 loda 0 9
 chka 1 1073741823
i4380
 inca 1
 lodi 0 14
 chki 0 1073741823
 stoi
 loda 0 8
 ldcn
 neqa
 fjp l505
 loda 0 8
 chka 1 1073741823
i4390
 indi 2
 ldci 1
 leqi
 fjp l506
 loda 0 8
 ldoa 40
 equa
 fjp l507
 mst 2
 ldci 109
i4400
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 8
 ujp l508
l507
 loda 0 8
 ldoa 41
 equa
 fjp l509
 mst 2
i4410
 ldci 149
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 8
l509
l508
 loda 0 10
 chka 1 1073741823
 inca 3
 loda 0 8
 chka 0 1073741823
i4420
 stoa
 ujp l510
l506
 mst 2
 ldci 113
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 8
l510
l505
 ldoi 9
 ldci 12
i4430
 neqi
 chkb 0 1
 strb 1 9
 lodb 1 9
 not
 fjp l511
 mst 2
 cup 0 l25
l511
 lodb 1 9
 fjp l504
i4440
 ldoi 9
 ldci 11
 equi
 fjp l512
 mst 2
 cup 0 l25
 ujp l513
l512
 mst 2
 ldci 12
 cup 1 l20
l513
i4450
 ldoi 9
 ldci 42
 equi
 fjp l514
 mst 2
 cup 0 l25
 ujp l515
l514
 mst 2
 ldci 8
 cup 1 l20
l515
i4460
 mst 1
 lods 0 5
 lda 0 10
 lda 0 14
 cup 3 l391
l516
 loda 0 9
 chka 1 1073741823
 stra 0 17
 loda 0 17
 inda 4
i4470
 chka 0 1073741823
 stra 0 8
 loda 0 17
 inca 4
 loda 0 10
 chka 0 1073741823
 stoa
 loda 0 17
 inda 3
 ldcn
i4480
 neqa
 fjp l517
 mst 2
 loda 0 17
 inda 3
 lda 0 16
 lda 0 15
 cup 3 l183
 mst 2
 loda 0 10
i4490
 lda 0 14
 cup 2 l217
 lodi 0 14
 lodi 0 15
 lodi 0 16
 sbi
 ldci 1
 adi
 mpi
 chki 0 1073741823
i4500
 stri 0 14
 loda 0 17
 inca 1
 lodi 0 14
 chki 0 1073741823
 stoi
l517
 loda 0 9
 chka 0 1073741823
 stra 0 10
 loda 0 8
i4510
 chka 0 1073741823
 stra 0 9
 loda 0 9
 ldcn
 equa
 fjp l516
 ujp l518
l501
 ldoi 9
 ldci 28
 equi
i4520
 fjp l519
 mst 2
 cup 0 l25
 ldoi 53
 chki 0 20
 stri 0 11
 ldoi 53
 ldci 20
 lesi
 fjp l520
i4530
 ldoi 53
 ldci 1
 adi
 chki 0 20
 sroi 53
 lao 55
 ldoi 53
 chki 0 20
 ixa 5
 stra 0 17
i4540
 loda 0 17
 ldcn
 chka 0 1073741823
 stoa
 loda 0 17
 inca 1
 ldcn
 chka 0 1073741823
 stoa
 loda 0 17
i4550
 inca 2
 ldci 3
 chki 0 3
 stoi
 ujp l521
l520
 mst 2
 ldci 250
 cup 1 l20
l521
 ldci 0
 chki 0 1073741823
i4560
 stri 0 13
 mst 0
 lods 0 5
 ldc( 13)
 dif
 ldc( 39)
 uni
 lda 0 9
 cup 2 l428
 lda 0 10
i4570
 ldci 5
 csp new
 loda 0 10
 chka 1 1073741823
 stra 0 17
 loda 0 17
 inca 3
 lao 55
 ldoi 53
 chki 0 20
i4580
 ixa 5
 inda 0
 chka 0 1073741823
 stoa
 loda 0 17
 inca 4
 loda 0 9
 chka 0 1073741823
 stoa
 loda 0 17
i4590
 inca 1
 lodi 0 13
 chki 0 1073741823
 stoi
 loda 0 17
 inca 2
 ldci 5
 chki 0 8
 stoi
 lodi 0 11
i4600
 chki 0 20
 sroi 53
 ldoi 9
 ldci 39
 equi
 fjp l522
 mst 2
 cup 0 l25
 ujp l523
l522
 mst 2
i4610
 ldci 13
 cup 1 l20
l523
 ujp l524
l519
 ldoi 9
 ldci 25
 equi
 fjp l525
 mst 2
 cup 0 l25
 ldoi 9
i4620
 ldci 42
 equi
 fjp l526
 mst 2
 cup 0 l25
 ujp l527
l526
 mst 2
 ldci 8
 cup 1 l20
l527
 mst 0
i4630
 lods 0 5
 lda 0 9
 lda 0 14
 cup 3 l392
 loda 0 9
 ldcn
 neqa
 fjp l528
 loda 0 9
 chka 1 1073741823
i4640
 indi 2
 ldci 1
 grti
 fjp l529
 mst 2
 ldci 115
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 9
i4650
 ujp l530
l529
 loda 0 9
 ldoa 40
 equa
 fjp l531
 mst 2
 ldci 114
 cup 1 l20
 ldcn
 chka 0 1073741823
i4660
 stra 0 9
 ujp l532
l531
 loda 0 9
 ldoa 41
 equa
 fjp l533
 mst 2
 ldci 169
 cup 1 l20
 ldcn
i4670
 chka 0 1073741823
 stra 0 9
 ujp l534
l533
 mst 2
 loda 0 9
 lda 0 16
 lda 0 15
 cup 3 l183
 lodi 0 16
 ldci 0
i4680
 lesi
 lodi 0 15
 ldci 47
 grti
 ior
 fjp l535
 mst 2
 ldci 169
 cup 1 l20
l535
l534
l532
l530
l528
 lda 0 10
i4690
 ldci 4
 csp new
 loda 0 10
 chka 1 1073741823
 stra 0 17
 loda 0 17
 inca 3
 loda 0 9
 chka 0 1073741823
 stoa
i4700
 loda 0 17
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
 loda 0 17
 inca 2
 ldci 3
 chki 0 8
 stoi
i4710
 ujp l536
l525
 ldoi 9
 ldci 29
 equi
 fjp l537
 mst 2
 cup 0 l25
 mst 2
 ldci 399
 cup 1 l20
i4720
 mst 1
 lods 0 5
 cup 1 l312
 ldcn
 chka 0 1073741823
 stra 0 10
l537
l536
l524
l518
 loda 0 6
 loda 0 10
 chka 0 1073741823
 stoa
l498
l489
i4730
 ldoi 9
 ordi
 lods 0 5
 inn
 not
 fjp l538
 mst 2
 ldci 6
 cup 1 l20
 mst 1
i4740
 lods 0 5
 cup 1 l312
l538
 ujp l539
l487
 loda 0 6
 ldcn
 chka 0 1073741823
 stoa
l539
 loda 0 6
 inda 0
 ldcn
i4750
 equa
 fjp l540
 loda 0 7
 ldci 1
 chki 0 1073741823
 stoi
 ujp l541
l540
 loda 0 7
 loda 0 6
 inda 0
i4760
 chka 1 1073741823
 indi 1
 chki 0 1073741823
 stoi
l541
 retp
l484=18
l485=54
l542
 ent 1 l543
 ent 2 l544
l545
 ldoi 9
 ldci 1
 equi
i4770
 fjp l546
 lao 55
 ldoi 53
 chki 0 20
 ixa 5
 stra 0 8
 loda 0 8
 inda 1
 chka 0 1073741823
 stra 0 5
i4780
 ldcb 0
 chkb 0 1
 strb 0 6
l547
 loda 0 5
 ldcn
 neqa
 lodb 0 6
 not
 and
 fjp l548
i4790
 loda 0 5
 chka 1 1073741823
 indi 3
 ldoi 12
 neqi
 fjp l549
 loda 0 5
 chka 1 1073741823
 inda 0
 chka 0 1073741823
i4800
 stra 0 5
 ujp l550
l549
 ldcb 1
 chkb 0 1
 strb 0 6
 mst 2
 ldci 166
 cup 1 l20
l550
 ujp l547
l548
 lodb 0 6
i4810
 not
 fjp l551
 lda 0 5
 ldci 4
 csp new
 loda 0 5
 chka 1 1073741823
 stra 0 9
 loda 0 9
 inca 3
i4820
 ldoi 12
 stoi
 mst 2
 lda 0 7
 cup 1 l308
 loda 0 9
 inca 1
 ldcb 0
 chkb 0 1
 stob
i4830
 loda 0 9
 loda 0 8
 inda 1
 chka 0 1073741823
 stoa
 loda 0 9
 inca 2
 lodi 0 7
 stoi
 loda 0 8
i4840
 inca 1
 loda 0 5
 chka 0 1073741823
 stoa
l551
 mst 2
 cup 0 l25
 ujp l552
l546
 mst 2
 ldci 15
 cup 1 l20
l552
i4850
 ldoi 9
 ordi
 lods 1 5
 ldc( 12 13)
 uni
 inn
 not
 fjp l553
 mst 2
 ldci 6
i4860
 cup 1 l20
 mst 1
 lods 1 5
 ldc( 12 13)
 uni
 cup 1 l312
l553
 ldoi 9
 ldci 12
 neqi
 chkb 0 1
i4870
 strb 1 9
 lodb 1 9
 not
 fjp l554
 mst 2
 cup 0 l25
l554
 lodb 1 9
 fjp l545
 ldoi 9
 ldci 13
i4880
 equi
 fjp l555
 mst 2
 cup 0 l25
 ujp l556
l555
 mst 2
 ldci 14
 cup 1 l20
l556
 retp
l543=10
l544=12
l557
 ent 1 l558
i4890
 ent 2 l559
 ldoi 9
 ldci 0
 neqi
 fjp l560
 mst 2
 ldci 2
 cup 1 l20
 mst 1
 lods 1 5
i4900
 ldc( 0)
 uni
 cup 1 l312
l560
l561
 ldoi 9
 ldci 0
 equi
 fjp l562
 lda 0 5
 ldci 15
 csp new
i4910
 loda 0 5
 chka 1 1073741823
 stra 0 9
 loda 0 9
 lao 14
 mov 8
 loda 0 9
 inca 10
 ldcn
 chka 0 1073741823
i4920
 stoa
 loda 0 9
 inca 11
 ldcn
 chka 0 1073741823
 stoa
 loda 0 9
 inca 12
 ldci 1
 chki 0 5
i4930
 stoi
 mst 2
 cup 0 l25
 ldoi 9
 ldci 7
 equi
 ldoi 10
 ldci 13
 equi
 and
i4940
 fjp l563
 mst 2
 cup 0 l25
 ujp l564
l563
 mst 2
 ldci 16
 cup 1 l20
l564
 mst 1
 lods 1 5
 ldc( 13)
i4950
 uni
 lda 0 6
 lda 0 7
 cup 3 l319
 mst 2
 loda 0 5
 cup 1 l135
 loda 0 5
 chka 1 1073741823
 inca 10
i4960
 loda 0 6
 chka 0 1073741823
 stoa
 loda 0 5
 chka 1 1073741823
 inca 13
 lda 0 7
 mov 2
 ldoi 9
 ldci 13
i4970
 equi
 fjp l565
 mst 2
 cup 0 l25
 ldoi 9
 ordi
 lods 1 5
 ldc( 0)
 uni
 inn
i4980
 not
 fjp l566
 mst 2
 ldci 6
 cup 1 l20
 mst 1
 lods 1 5
 ldc( 0)
 uni
 cup 1 l312
l566
i4990
 ujp l567
l565
 mst 2
 ldci 14
 cup 1 l20
l567
 ujp l561
l562
 retp
l558=10
l559=15
l568
 ent 1 l569
 ent 2 l570
 ldoi 9
 ldci 0
i5000
 neqi
 fjp l571
 mst 2
 ldci 2
 cup 1 l20
 mst 1
 lods 1 5
 ldc( 0)
 uni
 cup 1 l312
l571
l572
i5010
 ldoi 9
 ldci 0
 equi
 fjp l573
 lda 0 7
 ldci 13
 csp new
 loda 0 7
 chka 1 1073741823
 stra 0 10
i5020
 loda 0 10
 lao 14
 mov 8
 loda 0 10
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 10
 inca 12
i5030
 ldci 0
 chki 0 5
 stoi
 mst 2
 cup 0 l25
 ldoi 9
 ldci 7
 equi
 ldoi 10
 ldci 13
i5040
 equi
 and
 fjp l574
 mst 2
 cup 0 l25
 ujp l575
l574
 mst 2
 ldci 16
 cup 1 l20
l575
 mst 1
i5050
 lods 1 5
 ldc( 13)
 uni
 lda 0 8
 lda 0 9
 cup 3 l391
 mst 2
 loda 0 7
 cup 1 l135
 loda 0 7
i5060
 chka 1 1073741823
 inca 10
 loda 0 8
 chka 0 1073741823
 stoa
 ldoa 43
 chka 0 1073741823
 stra 0 6
l576
 loda 0 6
 ldcn
i5070
 neqa
 fjp l577
 loda 0 6
 chka 1 1073741823
 loda 0 7
 chka 1 1073741823
 equm 8
 fjp l578
 loda 0 6
 chka 1 1073741823
i5080
 inda 10
 chka 1 1073741823
 inca 3
 loda 0 7
 chka 1 1073741823
 inda 10
 chka 0 1073741823
 stoa
 loda 0 6
 ldoa 43
i5090
 neqa
 fjp l579
 loda 0 5
 chka 1 1073741823
 inca 11
 loda 0 6
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stoa
i5100
 ujp l580
l579
 loda 0 6
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 sroa 43
l580
 ujp l581
l578
 loda 0 6
 chka 0 1073741823
 stra 0 5
l581
i5110
 loda 0 6
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 6
 ujp l576
l577
 ldoi 9
 ldci 13
 equi
 fjp l582
i5120
 mst 2
 cup 0 l25
 ldoi 9
 ordi
 lods 1 5
 ldc( 0)
 uni
 inn
 not
 fjp l583
i5130
 mst 2
 ldci 6
 cup 1 l20
 mst 1
 lods 1 5
 ldc( 0)
 uni
 cup 1 l312
l583
 ujp l584
l582
 mst 2
i5140
 ldci 14
 cup 1 l20
l584
 ujp l572
l573
 ldoa 43
 ldcn
 neqa
 fjp l585
 mst 2
 ldci 117
 cup 1 l20
i5150
 lda 2 6
 csp wln
l586
 lca' type-id '
 ldci 9
 ldci 9
 lda 2 6
 csp wrs
 ldoa 43
 chka 1 1073741823
 ldci 8
i5160
 ldci 8
 lda 2 6
 csp wrs
 lda 2 6
 csp wln
 ldoa 43
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 sroa 43
i5170
 ldoa 43
 ldcn
 equa
 fjp l586
 ldob 24
 not
 fjp l587
 ldcc ' '
 ldoi 25
 ldci 16
i5180
 adi
 lda 2 6
 csp wrc
l587
l585
 retp
l569=11
l570=20
l588
 ent 1 l589
 ent 2 l590
 ldcn
 chka 0 1073741823
 stra 0 5
l591
l592
 ldoi 9
i5190
 ldci 0
 equi
 fjp l593
 lda 0 6
 ldci 16
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 9
 loda 0 9
i5200
 lao 14
 mov 8
 loda 0 9
 inca 11
 loda 0 5
 chka 0 1073741823
 stoa
 loda 0 9
 inca 12
 ldci 2
i5210
 chki 0 5
 stoi
 loda 0 9
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 9
 inca 13
 ldci 0
i5220
 chki 0 1
 stoi
 loda 0 9
 inca 14
 ldoi 52
 chki 0 10
 stoi
 mst 2
 loda 0 6
 cup 1 l135
i5230
 loda 0 6
 chka 0 1073741823
 stra 0 5
 mst 2
 cup 0 l25
 ujp l594
l593
 mst 2
 ldci 2
 cup 1 l20
l594
 ldoi 9
i5240
 ordi
 lods 1 5
 ldc( 12 16)
 uni
 ldos 186
 uni
 inn
 not
 fjp l595
 mst 2
i5250
 ldci 6
 cup 1 l20
 mst 1
 lods 1 5
 ldc( 12 13 16)
 uni
 ldos 186
 uni
 cup 1 l312
l595
 ldoi 9
i5260
 ldci 12
 neqi
 chkb 0 1
 strb 1 9
 lodb 1 9
 not
 fjp l596
 mst 2
 cup 0 l25
l596
 lodb 1 9
i5270
 fjp l592
 ldoi 9
 ldci 16
 equi
 fjp l597
 mst 2
 cup 0 l25
 ujp l598
l597
 mst 2
 ldci 5
i5280
 cup 1 l20
l598
 mst 1
 lods 1 5
 ldc( 13)
 uni
 ldos 186
 uni
 lda 0 7
 lda 0 8
 cup 3 l391
l599
i5290
 loda 0 5
 ldcn
 neqa
 fjp l600
 loda 0 5
 chka 1 1073741823
 stra 0 9
 mst 2
 loda 0 7
 lao 27
i5300
 cup 2 l217
 loda 0 9
 inca 10
 loda 0 7
 chka 0 1073741823
 stoa
 loda 0 9
 inca 15
 ldoi 27
 chki 0 1073741823
i5310
 stoi
 ldoi 27
 lodi 0 8
 adi
 chki 0 1073741823
 sroi 27
 loda 0 9
 inda 11
 chka 0 1073741823
 stra 0 5
i5320
 ujp l599
l600
 ldoi 9
 ldci 13
 equi
 fjp l601
 mst 2
 cup 0 l25
 ldoi 9
 ordi
 lods 1 5
i5330
 ldc( 0)
 uni
 inn
 not
 fjp l602
 mst 2
 ldci 6
 cup 1 l20
 mst 1
 lods 1 5
i5340
 ldc( 0)
 uni
 cup 1 l312
l602
 ujp l603
l601
 mst 2
 ldci 14
 cup 1 l20
l603
 ldoi 9
 ldci 0
 neqi
i5350
 ldoi 9
 ordi
 ldos 186
 inn
 not
 and
 fjp l591
 ldoa 43
 ldcn
 neqa
i5360
 fjp l604
 mst 2
 ldci 117
 cup 1 l20
 lda 2 6
 csp wln
l605
 lca' type-id '
 ldci 9
 ldci 9
 lda 2 6
i5370
 csp wrs
 ldoa 43
 chka 1 1073741823
 ldci 8
 ldci 8
 lda 2 6
 csp wrs
 lda 2 6
 csp wln
 ldoa 43
i5380
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 sroa 43
 ldoa 43
 ldcn
 equa
 fjp l605
 ldob 24
 not
i5390
 fjp l606
 ldcc ' '
 ldoi 25
 ldci 16
 adi
 lda 2 6
 csp wrc
l606
l604
 retp
l589=10
l590=23
l608
 ent 1 l609
 ent 2 l610
i5400
 ldcn
 chka 0 1073741823
 stra 0 9
 ldoi 9
 ordi
 lods 0 5
 ldc( 8)
 uni
 inn
 not
i5410
 fjp l611
 mst 3
 ldci 7
 cup 1 l20
 mst 2
 lods 2 5
 lods 0 5
 uni
 ldc( 8)
 uni
i5420
 cup 1 l312
l611
 ldoi 9
 ldci 8
 equi
 fjp l612
 lodb 1 10
 fjp l613
 mst 3
 ldci 119
 cup 1 l20
l613
i5430
 mst 3
 cup 0 l25
 ldoi 9
 ordi
 ldc( 0 21 22 24)
 inn
 not
 fjp l614
 mst 3
 ldci 7
i5440
 cup 1 l20
 mst 2
 lods 2 5
 ldc( 0 9)
 uni
 cup 1 l312
l614
l615
 ldoi 9
 ordi
 ldc( 0 21 22 24)
 inn
i5450
 fjp l616
 ldoi 9
 ldci 24
 equi
 fjp l617
 mst 3
 ldci 399
 cup 1 l20
l618
 mst 3
 cup 0 l25
i5460
 ldoi 9
 ldci 0
 equi
 fjp l619
 lda 0 10
 ldci 17
 csp new
 loda 0 10
 chka 1 1073741823
 stra 0 16
i5470
 loda 0 16
 lao 14
 mov 8
 loda 0 16
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 16
 inca 11
i5480
 loda 0 9
 chka 0 1073741823
 stoa
 loda 0 16
 inca 14
 ldoi 52
 chki 0 10
 stoi
 loda 0 16
 inca 12
i5490
 ldci 4
 chki 0 5
 stoi
 loda 0 16
 inca 13
 ldci 1
 chki 0 1
 stoi
 loda 0 16
 inca 16
i5500
 ldci 1
 chki 0 1
 stoi
 mst 3
 loda 0 10
 cup 1 l135
 loda 0 10
 chka 0 1073741823
 stra 0 9
 mst 3
i5510
 ldoa 42
 lao 27
 cup 2 l217
 mst 3
 cup 0 l25
 ujp l620
l619
 mst 3
 ldci 2
 cup 1 l20
l620
 ldoi 9
i5520
 ordi
 lods 2 5
 ldc( 9 12 13)
 uni
 inn
 not
 fjp l621
 mst 3
 ldci 7
 cup 1 l20
i5530
 mst 2
 lods 2 5
 ldc( 9 12 13)
 uni
 cup 1 l312
l621
 ldoi 9
 ldci 12
 neqi
 fjp l618
 ujp l622
l617
i5540
 ldoi 9
 ldci 22
 equi
 fjp l623
 mst 3
 ldci 399
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 8
l624
i5550
 mst 3
 cup 0 l25
 ldoi 9
 ldci 0
 equi
 fjp l625
 lda 0 10
 ldci 17
 csp new
 loda 0 10
i5560
 chka 1 1073741823
 stra 0 16
 loda 0 16
 lao 14
 mov 8
 loda 0 16
 inca 10
 ldcn
 chka 0 1073741823
 stoa
i5570
 loda 0 16
 inca 11
 loda 0 8
 chka 0 1073741823
 stoa
 loda 0 16
 inca 14
 ldoi 52
 chki 0 10
 stoi
i5580
 loda 0 16
 inca 12
 ldci 5
 chki 0 5
 stoi
 loda 0 16
 inca 13
 ldci 1
 chki 0 1
 stoi
i5590
 loda 0 16
 inca 16
 ldci 1
 chki 0 1
 stoi
 mst 3
 loda 0 10
 cup 1 l135
 loda 0 10
 chka 0 1073741823
i5600
 stra 0 8
 mst 3
 ldoa 42
 lao 27
 cup 2 l217
 mst 3
 cup 0 l25
l625
 ldoi 9
 ordi
 ldc( 12 16)
i5610
 lods 2 5
 uni
 inn
 not
 fjp l626
 mst 3
 ldci 7
 cup 1 l20
 mst 2
 lods 2 5
i5620
 ldc( 9 12 13)
 uni
 cup 1 l312
l626
 ldoi 9
 ldci 12
 neqi
 fjp l624
 ldoi 9
 ldci 16
 equi
i5630
 fjp l627
 mst 3
 cup 0 l25
 ldoi 9
 ldci 0
 equi
 fjp l628
 mst 3
 ldc( 0)
 lda 0 10
i5640
 cup 2 l157
 loda 0 10
 chka 1 1073741823
 inda 10
 chka 0 1073741823
 stra 0 11
 loda 0 11
 ldcn
 neqa
 fjp l629
i5650
 loda 0 11
 chka 1 1073741823
 indi 2
 ordi
 ldc( 0 1 2)
 inn
 not
 fjp l630
 mst 3
 ldci 120
i5660
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 11
l630
l629
 loda 0 8
 chka 0 1073741823
 stra 0 7
l631
 loda 0 8
 ldcn
 neqa
i5670
 fjp l632
 loda 0 8
 chka 1 1073741823
 inca 10
 loda 0 11
 chka 0 1073741823
 stoa
 loda 0 8
 chka 0 1073741823
 stra 0 10
i5680
 loda 0 8
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 8
 ujp l631
l632
 loda 0 10
 chka 1 1073741823
 inca 11
 loda 0 9
i5690
 chka 0 1073741823
 stoa
 loda 0 7
 chka 0 1073741823
 stra 0 9
 mst 3
 cup 0 l25
 ujp l633
l628
 mst 3
 ldci 2
i5700
 cup 1 l20
l633
 ldoi 9
 ordi
 lods 2 5
 ldc( 9 13)
 uni
 inn
 not
 fjp l634
 mst 3
i5710
 ldci 7
 cup 1 l20
 mst 2
 lods 2 5
 ldc( 9 13)
 uni
 cup 1 l312
l634
 ujp l635
l627
 mst 3
 ldci 5
i5720
 cup 1 l20
l635
 ujp l636
l623
 ldoi 9
 ldci 21
 equi
 fjp l637
 ldci 1
 chki 0 1
 stri 0 12
 mst 3
i5730
 cup 0 l25
 ujp l638
l637
 ldci 0
 chki 0 1
 stri 0 12
l638
 ldcn
 chka 0 1073741823
 stra 0 8
 ldci 0
 stri 0 15
l639
i5740
 ldoi 9
 ldci 0
 equi
 fjp l640
 lda 0 10
 ldci 16
 csp new
 loda 0 10
 chka 1 1073741823
 stra 0 16
i5750
 loda 0 16
 lao 14
 mov 8
 loda 0 16
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 16
 inca 12
i5760
 ldci 2
 chki 0 5
 stoi
 loda 0 16
 inca 13
 lodi 0 12
 chki 0 1
 stoi
 loda 0 16
 inca 11
i5770
 loda 0 8
 chka 0 1073741823
 stoa
 loda 0 16
 inca 14
 ldoi 52
 chki 0 10
 stoi
 mst 3
 loda 0 10
i5780
 cup 1 l135
 loda 0 10
 chka 0 1073741823
 stra 0 8
 lodi 0 15
 ldci 1
 adi
 stri 0 15
 mst 3
 cup 0 l25
l640
i5790
 ldoi 9
 ordi
 ldc( 12 16)
 lods 2 5
 uni
 inn
 not
 fjp l641
 mst 3
 ldci 7
i5800
 cup 1 l20
 mst 2
 lods 2 5
 ldc( 9 12 13)
 uni
 cup 1 l312
l641
 ldoi 9
 ldci 12
 neqi
 chkb 0 1
i5810
 strb 2 9
 lodb 2 9
 not
 fjp l642
 mst 3
 cup 0 l25
l642
 lodb 2 9
 fjp l639
 ldoi 9
 ldci 16
i5820
 equi
 fjp l643
 mst 3
 cup 0 l25
 ldoi 9
 ldci 0
 equi
 fjp l644
 mst 3
 ldc( 0)
i5830
 lda 0 10
 cup 2 l157
 loda 0 10
 chka 1 1073741823
 inda 10
 chka 0 1073741823
 stra 0 11
 ldci 1
 chki 0 1073741823
 stri 0 13
i5840
 loda 0 11
 ldcn
 neqa
 fjp l645
 lodi 0 12
 ldci 0
 equi
 fjp l646
 loda 0 11
 chka 1 1073741823
i5850
 indi 2
 ldci 3
 leqi
 fjp l647
 loda 0 11
 chka 1 1073741823
 indi 1
 chki 0 1073741823
 stri 0 13
 ujp l648
l647
i5860
 loda 0 11
 chka 1 1073741823
 indi 2
 ldci 6
 equi
 fjp l649
 mst 3
 ldci 121
 cup 1 l20
l649
l648
l646
l645
 mst 3
i5870
 ldoa 42
 lda 0 13
 cup 2 l217
 loda 0 8
 chka 0 1073741823
 stra 0 7
 mst 3
 ldoa 42
 lao 27
 cup 2 l217
i5880
 ldoi 27
 lodi 0 15
 lodi 0 13
 mpi
 adi
 chki 0 1073741823
 sroi 27
 ldoi 27
 chki 0 1073741823
 stri 0 14
l650
i5890
 loda 0 8
 ldcn
 neqa
 fjp l651
 loda 0 8
 chka 0 1073741823
 stra 0 10
 loda 0 8
 chka 1 1073741823
 stra 0 16
i5900
 loda 0 16
 inca 10
 loda 0 11
 chka 0 1073741823
 stoa
 lodi 0 14
 lodi 0 13
 sbi
 chki 0 1073741823
 stri 0 14
i5910
 loda 0 16
 inca 15
 lodi 0 14
 chki 0 1073741823
 stoi
 loda 0 8
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 8
i5920
 ujp l650
l651
 loda 0 10
 chka 1 1073741823
 inca 11
 loda 0 9
 chka 0 1073741823
 stoa
 loda 0 7
 chka 0 1073741823
 stra 0 9
i5930
 mst 3
 cup 0 l25
 ujp l652
l644
 mst 3
 ldci 2
 cup 1 l20
l652
 ldoi 9
 ordi
 lods 2 5
 ldc( 9 13)
i5940
 uni
 inn
 not
 fjp l653
 mst 3
 ldci 7
 cup 1 l20
 mst 2
 lods 2 5
 ldc( 9 13)
i5950
 uni
 cup 1 l312
l653
 ujp l654
l643
 mst 3
 ldci 5
 cup 1 l20
l654
l636
l622
 ldoi 9
 ldci 13
 equi
 fjp l655
i5960
 mst 3
 cup 0 l25
 ldoi 9
 ordi
 lods 2 5
 ldc( 0 21 22 24)
 uni
 inn
 not
 fjp l656
i5970
 mst 3
 ldci 7
 cup 1 l20
 mst 2
 lods 2 5
 ldc( 0 9)
 uni
 cup 1 l312
l656
l655
 ujp l615
l616
 ldoi 9
i5980
 ldci 9
 equi
 fjp l657
 mst 3
 cup 0 l25
 ldoi 9
 ordi
 lods 0 5
 lods 2 5
 uni
i5990
 inn
 not
 fjp l658
 mst 3
 ldci 6
 cup 1 l20
 mst 2
 lods 0 5
 lods 2 5
 uni
i6000
 cup 1 l312
l658
 ujp l659
l657
 mst 3
 ldci 4
 cup 1 l20
l659
 ldcn
 chka 0 1073741823
 stra 0 7
l660
 loda 0 9
 ldcn
i6010
 neqa
 fjp l661
 loda 0 9
 chka 1 1073741823
 stra 0 16
 loda 0 16
 inda 11
 chka 0 1073741823
 stra 0 8
 loda 0 16
i6020
 inca 11
 loda 0 7
 chka 0 1073741823
 stoa
 loda 0 16
 indi 12
 ldci 2
 equi
 fjp l662
 loda 0 16
i6030
 inda 10
 ldcn
 neqa
 fjp l663
 loda 0 16
 indi 13
 ldci 0
 equi
 loda 0 16
 inda 10
i6040
 chka 1 1073741823
 indi 2
 ldci 3
 grti
 and
 fjp l664
 mst 3
 loda 0 16
 inda 10
 lao 27
i6050
 cup 2 l217
 loda 0 16
 inca 15
 ldoi 27
 chki 0 1073741823
 stoi
 ldoi 27
 loda 0 16
 inda 10
 chka 1 1073741823
i6060
 indi 1
 adi
 chki 0 1073741823
 sroi 27
l664
l663
l662
 loda 0 9
 chka 0 1073741823
 stra 0 7
 loda 0 8
 chka 0 1073741823
 stra 0 9
i6070
 ujp l660
l661
 loda 0 6
 loda 0 7
 chka 0 1073741823
 stoa
 ujp l665
l612
 loda 0 6
 ldcn
 chka 0 1073741823
 stoa
l665
i6080
 retp
l609=17
l610=53
l607
 ent 1 l666
 ent 2 l667
 ldoi 27
 chki 0 1073741823
 stri 0 13
 ldci 5
 chki 0 1073741823
 sroi 27
 ldcb 0
i6090
 chkb 0 1
 strb 0 10
 ldoi 9
 ldci 0
 equi
 fjp l668
 mst 2
 lao 55
 ldoi 53
 chki 0 20
i6100
 ixa 5
 inda 0
 lda 0 8
 cup 2 l147
 loda 0 8
 ldcn
 neqa
 fjp l669
 loda 0 8
 chka 1 1073741823
i6110
 indi 12
 ldci 4
 equi
 fjp l670
 loda 0 8
 chka 1 1073741823
 indb 18
 lodi 0 5
 ldci 24
 equi
i6120
 and
 loda 0 8
 chka 1 1073741823
 indi 16
 ldci 0
 equi
 and
 chkb 0 1
 strb 0 10
 ujp l671
l670
i6130
 loda 0 8
 chka 1 1073741823
 indi 12
 ldci 5
 equi
 fjp l672
 loda 0 8
 chka 1 1073741823
 indb 18
 lodi 0 5
i6140
 ldci 22
 equi
 and
 loda 0 8
 chka 1 1073741823
 indi 16
 ldci 0
 equi
 and
 chkb 0 1
i6150
 strb 0 10
 ujp l673
l672
 ldcb 0
 chkb 0 1
 strb 0 10
l673
l671
 lodb 0 10
 not
 fjp l674
 mst 2
 ldci 160
i6160
 cup 1 l20
l674
l669
 lodb 0 10
 not
 fjp l675
 lodi 0 5
 ldci 24
 equi
 fjp l676
 lda 0 8
 ldci 19
i6170
 csp new
 ujp l677
l676
 lda 0 8
 ldci 19
 csp new
l677
 loda 0 8
 chka 1 1073741823
 stra 0 16
 loda 0 16
 lao 14
i6180
 mov 8
 loda 0 16
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 16
 inca 17
 ldcb 0
 chkb 0 1
i6190
 stob
 loda 0 16
 inca 14
 ldoi 52
 chki 0 10
 stoi
 mst 2
 lda 0 14
 cup 1 l308
 loda 0 16
i6200
 inca 13
 ldci 1
 chki 0 1
 stoi
 loda 0 16
 inca 16
 ldci 0
 chki 0 1
 stoi
 loda 0 16
i6210
 inca 15
 lodi 0 14
 stoi
 lodi 0 5
 ldci 24
 equi
 fjp l678
 loda 0 16
 inca 12
 ldci 4
i6220
 chki 0 5
 stoi
 ujp l679
l678
 loda 0 16
 inca 12
 ldci 5
 chki 0 5
 stoi
l679
 mst 2
 loda 0 8
i6230
 cup 1 l135
 ujp l680
l675
 loda 0 8
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 7
l681
 loda 0 7
 ldcn
 neqa
i6240
 fjp l682
 loda 0 7
 chka 1 1073741823
 stra 0 16
 loda 0 16
 indi 12
 ldci 2
 equi
 fjp l683
 loda 0 16
i6250
 inda 10
 ldcn
 neqa
 fjp l684
 loda 0 16
 indi 15
 loda 0 16
 inda 10
 chka 1 1073741823
 indi 1
i6260
 adi
 chki 0 1073741823
 stri 0 12
 lodi 0 12
 ldoi 27
 grti
 fjp l685
 lodi 0 12
 chki 0 1073741823
 sroi 27
l685
l684
l683
i6270
 loda 0 7
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 7
 ujp l681
l682
l680
 mst 2
 cup 0 l25
 ujp l686
l668
 mst 2
i6280
 ldci 2
 cup 1 l20
 ldoa 44
 chka 0 1073741823
 stra 0 8
l686
 ldoi 52
 chki 0 10
 stri 0 6
 ldoi 53
 chki 0 20
i6290
 stri 0 11
 ldoi 52
 ldci 10
 lesi
 fjp l687
 ldoi 52
 ldci 1
 adi
 chki 0 10
 sroi 52
i6300
 ujp l688
l687
 mst 2
 ldci 251
 cup 1 l20
l688
 ldoi 53
 ldci 20
 lesi
 fjp l689
 ldoi 53
 ldci 1
i6310
 adi
 chki 0 20
 sroi 53
 lao 55
 ldoi 53
 chki 0 20
 ixa 5
 stra 0 16
 lodb 0 10
 fjp l690
i6320
 loda 0 16
 loda 0 8
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stoa
 ujp l691
l690
 loda 0 16
 ldcn
 chka 0 1073741823
i6330
 stoa
l691
 loda 0 16
 inca 1
 ldcn
 chka 0 1073741823
 stoa
 loda 0 16
 inca 2
 ldci 0
 chki 0 3
i6340
 stoi
 ujp l692
l689
 mst 2
 ldci 250
 cup 1 l20
l692
 lodi 0 5
 ldci 24
 equi
 fjp l693
 mst 0
i6350
 ldc( 13)
 lda 0 7
 cup 2 l608
 lodb 0 10
 not
 fjp l694
 loda 0 8
 chka 1 1073741823
 inca 11
 loda 0 7
i6360
 chka 0 1073741823
 stoa
l694
 ujp l695
l693
 mst 0
 ldc( 13 16)
 lda 0 7
 cup 2 l608
 lodb 0 10
 not
 fjp l696
i6370
 loda 0 8
 chka 1 1073741823
 inca 11
 loda 0 7
 chka 0 1073741823
 stoa
l696
 ldoi 9
 ldci 16
 equi
 fjp l697
i6380
 mst 2
 cup 0 l25
 ldoi 9
 ldci 0
 equi
 fjp l698
 lodb 0 10
 fjp l699
 mst 2
 ldci 122
i6390
 cup 1 l20
l699
 mst 2
 ldc( 0)
 lda 0 7
 cup 2 l157
 loda 0 7
 chka 1 1073741823
 inda 10
 chka 0 1073741823
 stra 0 9
i6400
 loda 0 8
 chka 1 1073741823
 inca 10
 loda 0 9
 chka 0 1073741823
 stoa
 loda 0 9
 ldcn
 neqa
 fjp l700
i6410
 loda 0 9
 chka 1 1073741823
 indi 2
 ordi
 ldc( 0 1 2)
 inn
 not
 fjp l701
 mst 2
 ldci 120
i6420
 cup 1 l20
 loda 0 8
 chka 1 1073741823
 inca 10
 ldcn
 chka 0 1073741823
 stoa
l701
l700
 mst 2
 cup 0 l25
 ujp l702
l698
i6430
 mst 2
 ldci 2
 cup 1 l20
 mst 1
 lods 1 5
 ldc( 13)
 uni
 cup 1 l312
l702
 ujp l703
l697
 lodb 0 10
i6440
 not
 fjp l704
 mst 2
 ldci 123
 cup 1 l20
l704
l703
l695
 ldoi 9
 ldci 13
 equi
 fjp l705
 mst 2
i6450
 cup 0 l25
 ujp l706
l705
 mst 2
 ldci 14
 cup 1 l20
l706
 ldoi 9
 ldci 30
 equi
 fjp l707
 lodb 0 10
i6460
 fjp l708
 mst 2
 ldci 161
 cup 1 l20
 ujp l709
l708
 loda 0 8
 chka 1 1073741823
 inca 18
 ldcb 1
 chkb 0 1
i6470
 stob
l709
 mst 2
 cup 0 l25
 ldoi 9
 ldci 13
 equi
 fjp l710
 mst 2
 cup 0 l25
 ujp l711
l710
i6480
 mst 2
 ldci 14
 cup 1 l20
l711
 ldoi 9
 ordi
 lods 1 5
 inn
 not
 fjp l712
 mst 2
i6490
 ldci 6
 cup 1 l20
 mst 1
 lods 1 5
 cup 1 l312
l712
 ujp l713
l707
 loda 0 8
 chka 1 1073741823
 inca 18
 ldcb 0
i6500
 chkb 0 1
 stob
 lda 0 15
 csp sav
l714
 mst 2
 lods 1 5
 ldci 13
 chki 0 47
 loda 0 8
 cup 3 l311
i6510
 ldoi 9
 ldci 13
 equi
 fjp l715
 ldob 29
 fjp l716
 mst 2
 ldcb 0
 chkb 0 1
 cup 1 l220
l716
i6520
 mst 2
 cup 0 l25
 ldoi 9
 ordi
 ldc( 22 24 31)
 inn
 not
 fjp l717
 mst 2
 ldci 6
i6530
 cup 1 l20
 mst 1
 lods 1 5
 cup 1 l312
l717
 ujp l718
l715
 mst 2
 ldci 14
 cup 1 l20
l718
 ldoi 9
 ordi
i6540
 ldc( 22 24 31)
 inn
 lao 5
 eof
 ior
 fjp l714
 loda 0 15
 csp rst
l713
 lodi 0 6
 chki 0 10
i6550
 sroi 52
 lodi 0 11
 chki 0 20
 sroi 53
 lodi 0 13
 chki 0 1073741823
 sroi 27
 retp
l666=17
l667=38
l720
 ent 1 l721
 ent 2 l722
i6560
 lodi 1 84
 lao 1937
 lodi 0 5
 chki 0 60
 ixa 1
 indi 0
 ldci 1
 mpi
 adi
 stri 1 84
i6570
 lodi 1 84
 lodi 1 83
 grti
 fjp l723
 lodi 1 84
 stri 1 83
l723
 retp
l721=6
l722=8
l724
 ent 1 l725
 ent 2 l726
 ldoi 26
i6580
 ldci 10
 mod
 ldci 0
 equi
 fjp l727
 ldcc 'i'
 ldci 1
 lda 3 8
 csp wrc
 ldoi 26
i6590
 ldci 1
 lda 3 8
 csp wri
 lda 3 8
 csp wln
l727
 retp
l725=5
l726=8
l728
 ent 1 l729
 ent 2 l730
 ldob 30
 fjp l731
i6600
 mst 1
 cup 0 l724
 lao 1601
 lodi 0 5
 chki 0 60
 ixa 4
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
i6610
 lda 3 8
 csp wln
l731
 ldoi 26
 ldci 1
 adi
 chki 0 1073741823
 sroi 26
 mst 1
 lodi 0 5
 cup 1 l720
i6620
 retp
l729=6
l730=9
l732
 ent 1 l733
 ent 2 l734
 ldob 30
 fjp l735
 mst 1
 cup 0 l724
 lao 1601
 lodi 0 5
 chki 0 60
i6630
 ixa 4
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
 lodi 0 5
 ldci 30
 equi
 fjp l736
 lao 1845
i6640
 lodi 0 6
 chki 1 23
 deci 1
 ixa 4
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
 lda 3 8
 csp wln
i6650
 lodi 1 84
 lao 1998
 lodi 0 6
 chki 1 23
 deci 1
 ixa 1
 indi 0
 ldci 1
 mpi
 adi
i6660
 stri 1 84
 lodi 1 84
 lodi 1 83
 grti
 fjp l737
 lodi 1 84
 stri 1 83
l737
 ujp l738
l736
 lodi 0 5
 ldci 38
i6670
 equi
 fjp l739
 ldcc '''
 ldci 1
 lda 3 8
 csp wrc
 lda 1 15
 lodi 0 6
 chki 1 65
 deci 1
i6680
 ixa 1
 inda 0
 chka 1 1073741823
 stra 0 8
 ldci 1
 stri 0 7
 loda 0 8
 indi 1
 stri 0 9
l740
 lodi 0 7
i6690
 lodi 0 9
 leqi
 fjp l741
 loda 0 8
 inca 2
 lodi 0 7
 chki 1 128
 deci 1
 ixa 1
 indc 0
i6700
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 7
 inci 1
 stri 0 7
 ujp l740
l741
 ldcc '''
 ldci 1
 lda 3 8
i6710
 csp wrc
 lda 3 8
 csp wln
 ujp l742
l739
 lodi 0 5
 ldci 42
 equi
 fjp l743
 lodi 0 6
 chr
i6720
 ldci 1
 lda 3 8
 csp wrc
 lda 3 8
 csp wln
 ujp l744
l743
 ldcc ' '
 ldci 1
 lda 3 8
 csp wrc
i6730
 lodi 0 6
 ldci 1
 lda 3 8
 csp wri
 lda 3 8
 csp wln
l744
l742
 mst 1
 lodi 0 5
 cup 1 l720
l738
l735
 ldoi 26
i6740
 ldci 1
 adi
 chki 0 1073741823
 sroi 26
 retp
l733=10
l734=9
l745
 ent 1 l746
 ent 2 l747
 ldob 30
 fjp l748
 mst 1
i6750
 cup 0 l724
 lao 1601
 lodi 0 5
 chki 0 60
 ixa 4
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
 lodi 0 5
i6760
 ujp l749
l751
 ldcc ' '
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 6
 ldci 1
 lda 3 8
 csp wri
 ldcc ' '
i6770
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 7
 ldci 1
 lda 3 8
 csp wri
 lda 3 8
 csp wln
 ujp l750
l752
i6780
 lodi 0 6
 chr
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 6
 chr
 ldcc 'm'
 equc
 fjp l753
i6790
 ldcc ' '
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 7
 ldci 1
 lda 3 8
 csp wri
l753
 lda 3 8
 csp wln
i6800
 ujp l750
l754
 lodi 0 6
 ujp l755
l757
 lca'i '
 ldci 2
 ldci 2
 lda 3 8
 csp wrs
 lodi 0 7
 ldci 1
i6810
 lda 3 8
 csp wri
 lda 3 8
 csp wln
 ujp l756
l758
 lca'r '
 ldci 2
 ldci 2
 lda 3 8
 csp wrs
i6820
 lda 1 15
 lodi 0 7
 chki 1 65
 deci 1
 ixa 1
 inda 0
 chka 1 1073741823
 stra 0 9
 ldci 1
 stri 0 8
i6830
 ldci 128
 stri 0 10
l759
 lodi 0 8
 lodi 0 10
 leqi
 fjp l760
 loda 0 9
 inca 1
 lodi 0 8
 chki 1 128
i6840
 deci 1
 ixa 1
 indc 0
 ldcc ' '
 neqc
 fjp l761
 loda 0 9
 inca 1
 lodi 0 8
 chki 1 128
i6850
 deci 1
 ixa 1
 indc 0
 ldci 1
 lda 3 8
 csp wrc
l761
 lodi 0 8
 inci 1
 stri 0 8
 ujp l759
l760
i6860
 lda 3 8
 csp wln
 ujp l756
l762
 lca'b '
 ldci 2
 ldci 2
 lda 3 8
 csp wrs
 lodi 0 7
 ldci 1
i6870
 lda 3 8
 csp wri
 lda 3 8
 csp wln
 ujp l756
l763
 ldcc 'n'
 ldci 1
 lda 3 8
 csp wrc
 lda 3 8
i6880
 csp wln
 ujp l756
l764
 lca'c ''
 ldci 3
 ldci 3
 lda 3 8
 csp wrs
 lodi 0 7
 chr
 ldci 1
i6890
 lda 3 8
 csp wrc
 ldcc '''
 ldci 1
 lda 3 8
 csp wrc
 lda 3 8
 csp wln
 ujp l756
l765
 ldcc '('
i6900
 ldci 1
 lda 3 8
 csp wrc
 lda 1 15
 lodi 0 7
 chki 1 65
 deci 1
 ixa 1
 inda 0
 chka 1 1073741823
i6910
 stra 0 9
 ldci 0
 stri 0 8
 ldci 47
 stri 0 10
l766
 lodi 0 8
 lodi 0 10
 leqi
 fjp l767
 lodi 0 8
i6920
 loda 0 9
 inds 1
 inn
 fjp l768
 ldcc ' '
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 8
 ldci 1
i6930
 lda 3 8
 csp wri
l768
 lodi 0 8
 inci 1
 stri 0 8
 ujp l766
l767
 ldcc ')'
 ldci 1
 lda 3 8
 csp wrc
i6940
 lda 3 8
 csp wln
 ujp l756
l755
 chki 1 6
 ldci 1
 sbi
 xjp l769
l769
 ujp l757
 ujp l758
 ujp l762
i6950
 ujp l763
 ujp l765
 ujp l764
l756
 ujp l750
l749
 chki 45 56
 ldci 45
 sbi
 xjp l770
l770
 ujp l751
 ujc
i6960
 ujp l752
 ujp l752
 ujp l752
 ujp l751
 ujp l754
 ujp l752
 ujp l752
 ujp l751
 ujp l752
 ujp l751
l750
l748
i6970
 ldoi 26
 ldci 1
 adi
 chki 0 1073741823
 sroi 26
 mst 1
 lodi 0 5
 cup 1 l720
 retp
l746=11
l747=11
l771
 ent 1 l772
i6980
 ent 2 l773
 loda 0 5
 ldcn
 neqa
 fjp l774
 loda 0 5
 chka 1 1073741823
 stra 0 6
 loda 0 6
 indi 2
i6990
 ordi
 ujp l775
l777
 loda 0 5
 ldoa 41
 equa
 fjp l778
 ldcc 'i'
 ldci 1
 lda 3 8
 csp wrc
i7000
 ujp l779
l778
 loda 0 5
 ldoa 38
 equa
 fjp l780
 ldcc 'b'
 ldci 1
 lda 3 8
 csp wrc
 ujp l781
l780
i7010
 loda 0 5
 ldoa 39
 equa
 fjp l782
 ldcc 'c'
 ldci 1
 lda 3 8
 csp wrc
 ujp l783
l782
 loda 0 6
i7020
 indi 3
 ldci 1
 equi
 fjp l784
 ldcc 'i'
 ldci 1
 lda 3 8
 csp wrc
 ujp l785
l784
 ldcc 'r'
i7030
 ldci 1
 lda 3 8
 csp wrc
l785
l783
l781
l779
 ujp l776
l786
 mst 1
 loda 0 6
 inda 3
 cup 1 l771
 ujp l776
l787
 ldcc 'a'
i7040
 ldci 1
 lda 3 8
 csp wrc
 ujp l776
l788
 ldcc 's'
 ldci 1
 lda 3 8
 csp wrc
 ujp l776
l789
 ldcc 'm'
i7050
 ldci 1
 lda 3 8
 csp wrc
 ujp l776
l790
 mst 3
 ldci 500
 cup 1 l20
 ujp l776
l775
 chki 0 8
 ldci 0
i7060
 sbi
 xjp l791
l791
 ujp l777
 ujp l786
 ujp l787
 ujp l788
 ujp l789
 ujp l789
 ujp l790
 ujp l790
i7070
 ujp l790
l776
l774
 retp
l772=7
l773=10
l792
 ent 1 l793
 ent 2 l794
 ldob 30
 fjp l795
 mst 1
 cup 0 l724
 lao 1601
 lodi 0 5
i7080
 chki 0 60
 ixa 4
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
 mst 1
 loda 0 6
 cup 1 l771
 lda 3 8
i7090
 csp wln
l795
 ldoi 26
 ldci 1
 adi
 chki 0 1073741823
 sroi 26
 mst 1
 lodi 0 5
 cup 1 l720
 retp
l793=7
l794=9
l796
i7100
 ent 1 l797
 ent 2 l798
 ldob 30
 fjp l799
 mst 1
 cup 0 l724
 lao 1601
 lodi 0 5
 chki 0 60
 ixa 4
i7110
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
 mst 1
 loda 0 7
 cup 1 l771
 ldcc ' '
 ldci 1
 lda 3 8
i7120
 csp wrc
 lodi 0 6
 ldci 1
 lda 3 8
 csp wri
 lda 3 8
 csp wln
l799
 ldoi 26
 ldci 1
 adi
i7130
 chki 0 1073741823
 sroi 26
 mst 1
 lodi 0 5
 cup 1 l720
 retp
l797=8
l798=9
l800
 ent 1 l801
 ent 2 l802
 ldob 30
 fjp l803
i7140
 mst 1
 cup 0 l724
 lao 1601
 lodi 0 5
 chki 0 60
 ixa 4
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
i7150
 mst 1
 loda 0 8
 cup 1 l771
 ldcc ' '
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 6
 ldci 1
 lda 3 8
i7160
 csp wri
 ldcc ' '
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 7
 ldci 1
 lda 3 8
 csp wri
 lda 3 8
i7170
 csp wln
l803
 ldoi 26
 ldci 1
 adi
 chki 0 1073741823
 sroi 26
 mst 1
 lodi 0 5
 cup 1 l720
 retp
l801=9
l802=9
l804
i7180
 ent 1 l805
 ent 2 l806
 ldoa 181
 ldcn
 neqa
 fjp l807
 ldoi 182
 ordi
 ujp l808
l810
 ldoa 181
i7190
 chka 1 1073741823
 indi 2
 ldci 0
 equi
 ldoa 181
 ldoa 40
 neqa
 and
 fjp l811
 ldoa 181
i7200
 ldoa 38
 equa
 fjp l812
 mst 1
 ldci 51
 chki 0 63
 ldci 3
 ldoi 184
 cup 3 l745
 ujp l813
l812
i7210
 ldoa 181
 ldoa 39
 equa
 fjp l814
 mst 1
 ldci 51
 chki 0 63
 ldci 6
 ldoi 184
 cup 3 l745
i7220
 ujp l815
l814
 mst 1
 ldci 51
 chki 0 63
 ldci 1
 ldoi 184
 cup 3 l745
l815
l813
 ujp l816
l811
 ldoa 181
 ldoa 37
i7230
 equa
 fjp l817
 mst 1
 ldci 51
 chki 0 63
 ldci 4
 ldci 0
 cup 3 l745
 ujp l818
l817
 lodi 1 80
i7240
 ldci 65
 geqi
 fjp l819
 mst 3
 ldci 254
 cup 1 l20
 ujp l820
l819
 lodi 1 80
 ldci 1
 adi
i7250
 chki 0 65
 stri 1 80
 lda 1 15
 lodi 1 80
 chki 1 65
 deci 1
 ixa 1
 ldoa 184
 chka 0 1073741823
 stoa
i7260
 ldoa 181
 ldoa 40
 equa
 fjp l821
 mst 1
 ldci 51
 chki 0 63
 ldci 2
 lodi 1 80
 cup 3 l745
i7270
 ujp l822
l821
 mst 1
 ldci 51
 chki 0 63
 ldci 5
 lodi 1 80
 cup 3 l745
l822
l820
l818
l816
 ujp l809
l823
 ldoi 183
 ordi
i7280
 ujp l824
l826
 ldoi 184
 ldci 1
 leqi
 fjp l827
 mst 1
 ldci 39
 chki 0 63
 ldoi 185
 ldoa 181
i7290
 cup 3 l796
 ujp l828
l827
 mst 1
 ldci 54
 chki 0 63
 ldoi 52
 ldoi 184
 sbi
 ldoi 185
 ldoa 181
i7300
 cup 4 l800
l828
 ujp l825
l829
 mst 1
 ldci 35
 chki 0 63
 ldoi 184
 ldoa 181
 cup 3 l796
 ujp l825
l830
 mst 3
i7310
 ldci 400
 cup 1 l20
 ujp l825
l824
 chki 0 2
 ldci 0
 sbi
 xjp l831
l831
 ujp l826
 ujp l829
 ujp l830
l825
i7320
 ujp l809
l832
 ujp l809
l808
 chki 0 2
 ldci 0
 sbi
 xjp l833
l833
 ujp l810
 ujp l823
 ujp l832
l809
 ldci 2
i7330
 chki 0 2
 sroi 182
l807
 retp
l805=5
l806=38
l834
 ent 1 l835
 ent 2 l836
 loda 0 5
 stra 0 6
 loda 0 6
 inda 0
 ldcn
i7340
 neqa
 fjp l837
 loda 0 6
 indi 2
 ordi
 ujp l838
l840
 loda 0 6
 indi 3
 ldci 1
 leqi
i7350
 fjp l841
 mst 1
 ldci 43
 chki 0 63
 loda 0 6
 indi 4
 loda 0 6
 inda 0
 cup 3 l796
 ujp l842
l841
i7360
 mst 1
 ldci 56
 chki 0 63
 ldoi 52
 loda 0 6
 indi 3
 sbi
 loda 0 6
 indi 4
 loda 0 6
i7370
 inda 0
 cup 4 l800
l842
 ujp l839
l843
 loda 0 6
 indi 3
 ldci 0
 neqi
 fjp l844
 mst 3
 ldci 400
i7380
 cup 1 l20
 ujp l845
l844
 mst 1
 ldci 26
 chki 0 63
 loda 0 6
 inda 0
 cup 2 l792
l845
 ujp l839
l846
 mst 3
i7390
 ldci 400
 cup 1 l20
 ujp l839
l838
 chki 0 2
 ldci 0
 sbi
 xjp l847
l847
 ujp l840
 ujp l843
 ujp l846
l839
l837
i7400
 retp
l835=7
l836=18
l848
 ent 1 l849
 ent 2 l850
 ldoa 181
 ldcn
 neqa
 fjp l851
 ldoi 182
 ordi
 ujp l852
l854
i7410
 mst 2
 ldoa 181
 cup 1 l385
 fjp l855
 lodi 1 80
 ldci 65
 geqi
 fjp l856
 mst 3
 ldci 254
i7420
 cup 1 l20
 ujp l857
l856
 lodi 1 80
 ldci 1
 adi
 chki 0 65
 stri 1 80
 lda 1 15
 lodi 1 80
 chki 1 65
i7430
 deci 1
 ixa 1
 ldoa 184
 chka 0 1073741823
 stoa
 mst 1
 ldci 38
 chki 0 63
 lodi 1 80
 cup 2 l732
l857
i7440
 ujp l858
l855
 mst 3
 ldci 400
 cup 1 l20
l858
 ujp l853
l859
 ldoi 183
 ordi
 ujp l860
l862
 ldoi 184
 ldci 1
i7450
 leqi
 fjp l863
 mst 1
 ldci 37
 chki 0 63
 ldoi 185
 cup 2 l732
 ujp l864
l863
 mst 1
 ldci 50
i7460
 chki 0 63
 ldoi 52
 ldoi 184
 sbi
 ldoi 185
 cup 3 l745
l864
 ujp l861
l865
 ldoi 184
 ldci 0
 neqi
i7470
 fjp l866
 mst 1
 ldci 34
 chki 0 63
 ldoi 184
 ldoa 37
 cup 3 l796
l866
 ujp l861
l867
 mst 3
 ldci 400
i7480
 cup 1 l20
 ujp l861
l860
 chki 0 2
 ldci 0
 sbi
 xjp l868
l868
 ujp l862
 ujp l865
 ujp l867
l861
 ujp l853
l869
i7490
 mst 3
 ldci 400
 cup 1 l20
 ujp l853
l852
 chki 0 2
 ldci 0
 sbi
 xjp l870
l870
 ujp l854
 ujp l859
i7500
 ujp l869
l853
 ldci 1
 chki 0 2
 sroi 182
 ldci 1
 chki 0 2
 sroi 183
 ldci 0
 chki 0 1073741823
 sroi 184
l851
i7510
 retp
l849=5
l850=21
l871
 ent 1 l872
 ent 2 l873
 mst 1
 cup 0 l804
 ldoa 181
 ldcn
 neqa
 fjp l874
 ldoa 181
i7520
 ldoa 38
 neqa
 fjp l875
 mst 3
 ldci 144
 cup 1 l20
l875
l874
 ldob 30
 fjp l876
 mst 1
 cup 0 l724
i7530
 lao 1601
 ldci 33
 chki 0 60
 ixa 4
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
 lca' l'
 ldci 2
i7540
 ldci 2
 lda 3 8
 csp wrs
 lodi 0 5
 ldci 1
 lda 3 8
 csp wri
 lda 3 8
 csp wln
l876
 ldoi 26
i7550
 ldci 1
 adi
 chki 0 1073741823
 sroi 26
 mst 1
 ldci 33
 cup 1 l720
 retp
l872=6
l873=10
l877
 ent 1 l878
 ent 2 l879
i7560
 ldob 30
 fjp l880
 mst 1
 cup 0 l724
 lao 1601
 lodi 0 5
 chki 0 60
 ixa 4
 ldci 4
 ldci 4
i7570
 lda 3 8
 csp wrs
 lca' l'
 ldci 2
 ldci 2
 lda 3 8
 csp wrs
 lodi 0 6
 ldci 1
 lda 3 8
i7580
 csp wri
 lda 3 8
 csp wln
l880
 ldoi 26
 ldci 1
 adi
 chki 0 1073741823
 sroi 26
 mst 1
 lodi 0 5
i7590
 cup 1 l720
 retp
l878=7
l879=9
l881
 ent 1 l882
 ent 2 l883
 ldob 30
 fjp l884
 mst 1
 cup 0 l724
 lao 1601
 lodi 0 5
i7600
 chki 0 60
 ixa 4
 ldci 4
 ldci 4
 lda 3 8
 csp wrs
 ldcc ' '
 ldci 1
 lda 3 8
 csp wrc
i7610
 lodi 0 6
 ldci 1
 lda 3 8
 csp wri
 lca' l'
 ldci 2
 ldci 2
 lda 3 8
 csp wrs
 lodi 0 7
i7620
 ldci 1
 lda 3 8
 csp wri
 lda 3 8
 csp wln
l884
 ldoi 26
 ldci 1
 adi
 chki 0 1073741823
 sroi 26
i7630
 mst 1
 lodi 0 5
 cup 1 l720
 retp
l882=8
l883=9
l885
 ent 1 l886
 ent 2 l887
 loda 0 5
 ldcn
 neqa
 fjp l888
i7640
 loda 0 5
 ldoa 41
 neqa
 fjp l889
 loda 0 5
 ldoa 40
 neqa
 fjp l890
 loda 0 5
 chka 1 1073741823
i7650
 indi 2
 ldci 1
 leqi
 fjp l891
 mst 3
 loda 0 5
 lda 0 7
 lda 0 6
 cup 3 l183
 mst 1
i7660
 ldci 45
 chki 0 63
 lodi 0 7
 lodi 0 6
 loda 0 5
 cup 4 l800
l891
l890
l889
l888
 retp
l886=8
l887=12
l892
 ent 1 l893
 ent 2 l894
 ldob 30
i7670
 fjp l895
 ldcc 'l'
 ldci 1
 lda 3 8
 csp wrc
 lodi 0 5
 ldci 1
 lda 3 8
 csp wri
 lda 3 8
i7680
 csp wln
l895
 retp
l893=6
l894=8
l899
 ent 1 l900
 ent 2 l901
 loda 0 6
 chka 1 1073741823
 stra 0 16
 loda 0 16
 inda 10
 chka 0 1073741823
i7690
 sroa 181
 ldci 1
 chki 0 2
 sroi 182
 loda 0 16
 indi 12
 ordi
 ujp l902
l904
 loda 0 16
 indi 13
i7700
 ldci 0
 equi
 fjp l905
 ldci 0
 chki 0 2
 sroi 183
 loda 0 16
 indi 14
 chki 0 10
 sroi 184
i7710
 loda 0 16
 indi 15
 chki 0 1073741823
 sroi 185
 ujp l906
l905
 mst 2
 ldci 54
 chki 0 63
 ldoi 52
 loda 0 16
i7720
 indi 14
 sbi
 loda 0 16
 indi 15
 ldoa 37
 cup 4 l800
 ldci 1
 chki 0 2
 sroi 183
 ldci 0
i7730
 chki 0 1073741823
 sroi 184
l906
 ujp l903
l907
 lao 55
 ldoi 54
 chki 0 20
 ixa 5
 stra 0 17
 loda 0 17
 indi 2
i7740
 ldci 1
 equi
 fjp l908
 ldci 0
 chki 0 2
 sroi 183
 loda 0 17
 indi 3
 chki 0 10
 sroi 184
i7750
 loda 0 17
 indi 4
 loda 0 16
 indi 13
 adi
 chki 0 1073741823
 sroi 185
 ujp l909
l908
 ldoi 52
 ldci 1
i7760
 equi
 fjp l910
 mst 2
 ldci 39
 chki 0 63
 loda 0 17
 indi 3
 ldoa 37
 cup 3 l796
 ujp l911
l910
i7770
 mst 2
 ldci 54
 chki 0 63
 ldci 0
 loda 0 17
 indi 3
 ldoa 37
 cup 4 l800
l911
 ldci 1
 chki 0 2
i7780
 sroi 183
 loda 0 16
 indi 13
 chki 0 1073741823
 sroi 184
l909
 ujp l903
l912
 loda 0 16
 indi 13
 ldci 0
 equi
i7790
 fjp l913
 mst 4
 ldci 150
 cup 1 l20
 ldcn
 chka 0 1073741823
 sroa 181
 ujp l914
l913
 loda 0 16
 indi 16
i7800
 ldci 1
 equi
 fjp l915
 mst 4
 ldci 151
 cup 1 l20
 ujp l916
l915
 loda 0 16
 indi 14
 ldci 1
i7810
 adi
 ldoi 52
 neqi
 loda 3 7
 loda 0 6
 neqa
 ior
 fjp l917
 mst 4
 ldci 177
i7820
 cup 1 l20
l917
l916
 ldci 0
 chki 0 2
 sroi 183
 loda 0 16
 indi 14
 ldci 1
 adi
 chki 0 10
 sroi 184
i7830
 ldci 0
 chki 0 1073741823
 sroi 185
l914
 ujp l903
l902
 chki 2 5
 ldci 2
 sbi
 xjp l918
l918
 ujp l904
 ujp l907
i7840
 ujc
 ujp l912
l903
 ldoi 9
 ordi
 ldos 189
 lods 0 5
 uni
 inn
 not
 fjp l919
i7850
 mst 4
 ldci 59
 cup 1 l20
 mst 3
 ldos 189
 lods 0 5
 uni
 cup 1 l312
l919
l920
 ldoi 9
 ordi
i7860
 ldos 189
 inn
 fjp l921
 ldoi 9
 ldci 10
 equi
 fjp l922
l923
 lda 0 7
 lao 181
 mov 5
i7870
 loda 0 7
 ldcn
 neqa
 fjp l924
 loda 0 7
 chka 1 1073741823
 indi 2
 ldci 4
 neqi
 fjp l925
i7880
 mst 4
 ldci 138
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 7
l925
l924
 mst 2
 cup 0 l848
 mst 4
 cup 0 l25
i7890
 mst 1
 lods 0 5
 ldc( 11 12)
 uni
 cup 1 l898
 mst 2
 cup 0 l804
 ldoa 181
 ldcn
 neqa
i7900
 fjp l926
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 0
 neqi
 fjp l927
 mst 4
 ldci 113
 cup 1 l20
i7910
 ujp l928
l927
 mst 3
 ldoa 181
 ldoa 41
 cup 2 l356
 not
 fjp l929
 mst 2
 ldci 58
 chki 0 63
i7920
 ldoa 181
 cup 2 l792
l929
l928
l926
 loda 0 7
 ldcn
 neqa
 fjp l930
 loda 0 7
 chka 1 1073741823
 stra 0 16
 mst 3
i7930
 loda 0 16
 inda 3
 ldoa 181
 cup 2 l356
 fjp l931
 loda 0 16
 inda 3
 ldcn
 neqa
 fjp l932
i7940
 mst 4
 loda 0 16
 inda 3
 lda 0 15
 lda 0 14
 cup 3 l183
 ldob 34
 fjp l933
 mst 2
 ldci 45
i7950
 chki 0 63
 lodi 0 15
 lodi 0 14
 ldoa 41
 cup 4 l800
l933
 lodi 0 15
 ldci 0
 grti
 fjp l934
 mst 2
i7960
 ldci 31
 chki 0 63
 lodi 0 15
 ldoa 41
 cup 3 l796
 ujp l935
l934
 lodi 0 15
 ldci 0
 lesi
 fjp l936
i7970
 mst 2
 ldci 34
 chki 0 63
 lodi 0 15
 ngi
 ldoa 41
 cup 3 l796
l936
l935
l932
 ujp l937
l931
 mst 4
 ldci 139
i7980
 cup 1 l20
l937
 loda 0 16
 inda 4
 chka 0 1073741823
 sroa 181
 ldci 1
 chki 0 2
 sroi 182
 ldci 1
 chki 0 2
i7990
 sroi 183
 ldci 0
 chki 0 1073741823
 sroi 184
 ldoa 181
 ldcn
 neqa
 fjp l938
 ldoa 181
 chka 1 1073741823
i8000
 indi 1
 chki 0 1073741823
 stri 0 13
 mst 4
 ldoa 181
 lda 0 13
 cup 2 l217
 mst 2
 ldci 36
 chki 0 63
i8010
 lodi 0 13
 cup 2 l732
l938
l930
 ldoi 9
 ldci 12
 neqi
 fjp l923
 ldoi 9
 ldci 11
 equi
 fjp l939
i8020
 mst 4
 cup 0 l25
 ujp l940
l939
 mst 4
 ldci 12
 cup 1 l20
l940
 ujp l941
l922
 ldoi 9
 ldci 14
 equi
i8030
 fjp l942
 ldoa 181
 ldcn
 neqa
 fjp l943
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 5
 neqi
i8040
 fjp l944
 mst 4
 ldci 140
 cup 1 l20
 ldcn
 chka 0 1073741823
 sroa 181
l944
l943
 mst 4
 cup 0 l25
 ldoi 9
i8050
 ldci 0
 equi
 fjp l945
 ldoa 181
 ldcn
 neqa
 fjp l946
 mst 4
 ldoa 181
 chka 1 1073741823
i8060
 inda 3
 lda 0 12
 cup 2 l147
 loda 0 12
 ldcn
 equa
 fjp l947
 mst 4
 ldci 152
 cup 1 l20
i8070
 ldcn
 chka 0 1073741823
 sroa 181
 ujp l948
l947
 loda 0 12
 chka 1 1073741823
 stra 0 16
 loda 0 16
 inda 10
 chka 0 1073741823
i8080
 sroa 181
 ldoi 183
 ordi
 ujp l949
l951
 ldoi 185
 loda 0 16
 indi 13
 adi
 chki 0 1073741823
 sroi 185
i8090
 ujp l950
l952
 ldoi 184
 loda 0 16
 indi 13
 adi
 chki 0 1073741823
 sroi 184
 ujp l950
l953
 mst 4
 ldci 400
i8100
 cup 1 l20
 ujp l950
l949
 chki 0 2
 ldci 0
 sbi
 xjp l954
l954
 ujp l951
 ujp l952
 ujp l953
l950
l948
l946
 mst 4
i8110
 cup 0 l25
 ujp l955
l945
 mst 4
 ldci 2
 cup 1 l20
l955
 ujp l956
l942
 ldoa 181
 ldcn
 neqa
 fjp l957
i8120
 ldoa 181
 chka 1 1073741823
 stra 0 16
 loda 0 16
 indi 2
 ldci 2
 equi
 fjp l958
 mst 2
 cup 0 l804
i8130
 loda 0 16
 inda 3
 chka 0 1073741823
 sroa 181
 ldob 34
 fjp l959
 mst 2
 ldci 45
 chki 0 63
 ldci 1
i8140
 ldci 1073741823
 ldoa 37
 cup 4 l800
l959
 ldci 1
 chki 0 2
 sroi 182
 ldci 1
 chki 0 2
 sroi 183
 ldci 0
i8150
 chki 0 1073741823
 sroi 184
 ujp l960
l958
 loda 0 16
 indi 2
 ldci 6
 equi
 fjp l961
 loda 0 16
 inda 3
i8160
 chka 0 1073741823
 sroa 181
 ujp l962
l961
 mst 4
 ldci 141
 cup 1 l20
l962
l960
l957
 mst 4
 cup 0 l25
l956
l941
 ldoi 9
 ordi
i8170
 lods 0 5
 ldos 189
 uni
 inn
 not
 fjp l963
 mst 4
 ldci 6
 cup 1 l20
 mst 3
i8180
 lods 0 5
 ldos 189
 uni
 cup 1 l312
l963
 ujp l920
l921
 retp
l900=18
l901=61
l965
 ent 1 l966
 ent 2 l967
 ldoi 9
 ldci 0
i8190
 equi
 fjp l968
 mst 5
 ldc( 2 3)
 lda 0 6
 cup 2 l157
 mst 5
 cup 0 l25
 ujp l969
l968
 mst 5
i8200
 ldci 2
 cup 1 l20
 ldoa 47
 chka 0 1073741823
 stra 0 6
l969
 mst 2
 lods 0 5
 loda 0 6
 cup 2 l899
 retp
l966=7
l967=10
l970
i8210
 ent 1 l971
 ent 2 l972
 mst 1
 lods 1 5
 ldc( 9)
 uni
 cup 1 l965
 mst 3
 cup 0 l848
 ldoa 181
i8220
 ldcn
 neqa
 fjp l973
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 6
 neqi
 fjp l974
 mst 5
i8230
 ldci 116
 cup 1 l20
l974
l973
 lodi 1 7
 ldci 2
 leqi
 fjp l975
 mst 3
 ldci 30
 chki 0 63
 lodi 1 7
i8240
 cup 2 l732
 ujp l976
l975
 mst 5
 ldci 399
 cup 1 l20
l976
 retp
l971=5
l972=10
l977
 ent 1 l978
 ent 2 l979
 ldci 1
 chki 0 10
i8250
 stri 0 5
 ldci 5
 chki 0 1073741823
 stri 0 6
 ldoi 9
 ldci 8
 equi
 fjp l980
 mst 5
 cup 0 l25
i8260
 mst 1
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l965
 ldoa 181
 chka 0 1073741823
 stra 0 7
 ldcb 0
 chkb 0 1
i8270
 strb 4 9
 loda 0 7
 ldcn
 neqa
 fjp l981
 loda 0 7
 chka 1 1073741823
 indi 2
 ldci 6
 equi
i8280
 fjp l982
 loda 0 7
 chka 1 1073741823
 stra 0 8
 loda 0 8
 inda 3
 ldoa 39
 equa
 fjp l983
 ldoi 184
i8290
 chki 0 10
 stri 0 5
 ldoi 185
 chki 0 1073741823
 stri 0 6
 ujp l984
l983
 mst 5
 ldci 399
 cup 1 l20
l984
 ldoi 9
i8300
 ldci 9
 equi
 fjp l985
 lodi 1 7
 ldci 5
 equi
 fjp l986
 mst 5
 ldci 116
 cup 1 l20
l986
i8310
 ldcb 1
 chkb 0 1
 strb 4 9
 ujp l987
l985
 ldoi 9
 ldci 12
 neqi
 fjp l988
 mst 5
 ldci 116
i8320
 cup 1 l20
 mst 4
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l312
l988
l987
 ldoi 9
 ldci 12
 equi
 fjp l989
i8330
 mst 5
 cup 0 l25
 mst 1
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l965
 ujp l990
l989
 ldcb 1
 chkb 0 1
i8340
 strb 4 9
l990
l982
l981
 lodb 4 9
 not
 fjp l991
l992
 mst 3
 cup 0 l848
 mst 3
 ldci 50
 chki 0 63
 ldoi 52
i8350
 lodi 0 5
 sbi
 lodi 0 6
 cup 3 l745
 ldoa 181
 ldcn
 neqa
 fjp l993
 ldoa 181
 chka 1 1073741823
i8360
 indi 2
 ldci 1
 leqi
 fjp l994
 mst 4
 ldoa 41
 ldoa 181
 cup 2 l356
 fjp l995
 mst 3
i8370
 ldci 30
 chki 0 63
 ldci 3
 cup 2 l732
 ujp l996
l995
 mst 4
 ldoa 40
 ldoa 181
 cup 2 l356
 fjp l997
i8380
 mst 3
 ldci 30
 chki 0 63
 ldci 4
 cup 2 l732
 ujp l998
l997
 mst 4
 ldoa 39
 ldoa 181
 cup 2 l356
i8390
 fjp l999
 mst 3
 ldci 30
 chki 0 63
 ldci 5
 cup 2 l732
 ujp l1000
l999
 mst 5
 ldci 399
 cup 1 l20
l1000
l998
l996
i8400
 ujp l1001
l994
 mst 5
 ldci 116
 cup 1 l20
l1001
l993
 ldoi 9
 ldci 12
 neqi
 chkb 0 1
 strb 4 9
 lodb 4 9
i8410
 not
 fjp l1002
 mst 5
 cup 0 l25
 mst 1
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l965
l1002
 lodb 4 9
i8420
 fjp l992
l991
 ldoi 9
 ldci 9
 equi
 fjp l1003
 mst 5
 cup 0 l25
 ujp l1004
l1003
 mst 5
 ldci 4
i8430
 cup 1 l20
l1004
 ujp l1005
l980
 lodi 1 7
 ldci 5
 equi
 fjp l1006
 mst 5
 ldci 116
 cup 1 l20
l1006
l1005
 lodi 1 7
i8440
 ldci 11
 equi
 fjp l1007
 mst 3
 ldci 50
 chki 0 63
 ldoi 52
 lodi 0 5
 sbi
 lodi 0 6
i8450
 cup 3 l745
 mst 3
 ldci 30
 chki 0 63
 ldci 21
 cup 2 l732
l1007
 retp
l978=9
l979=33
l1008
 ent 1 l1009
 ent 2 l1010
 lodi 1 7
i8460
 chki 1 15
 stri 0 7
 ldci 1
 chki 0 10
 stri 0 8
 ldci 5
 ldci 1
 adi
 chki 0 1073741823
 stri 0 10
i8470
 ldoi 9
 ldci 8
 equi
 fjp l1011
 mst 5
 cup 0 l25
 mst 2
 lods 1 5
 ldc( 9 12 16)
 uni
i8480
 cup 1 l898
 ldoa 181
 chka 0 1073741823
 stra 0 5
 ldcb 0
 chkb 0 1
 strb 4 9
 loda 0 5
 ldcn
 neqa
i8490
 fjp l1012
 loda 0 5
 chka 1 1073741823
 indi 2
 ldci 6
 equi
 fjp l1013
 loda 0 5
 chka 1 1073741823
 stra 0 11
i8500
 loda 0 11
 inda 3
 ldoa 39
 equa
 fjp l1014
 ldoi 184
 chki 0 10
 stri 0 8
 ldoi 185
 chki 0 1073741823
i8510
 stri 0 10
 ujp l1015
l1014
 mst 5
 ldci 399
 cup 1 l20
l1015
 ldoi 9
 ldci 9
 equi
 fjp l1016
 lodi 0 7
i8520
 ldci 6
 equi
 fjp l1017
 mst 5
 ldci 116
 cup 1 l20
l1017
 ldcb 1
 chkb 0 1
 strb 4 9
 ujp l1018
l1016
i8530
 ldoi 9
 ldci 12
 neqi
 fjp l1019
 mst 5
 ldci 116
 cup 1 l20
 mst 4
 lods 1 5
 ldc( 9 12)
i8540
 uni
 cup 1 l312
l1019
l1018
 ldoi 9
 ldci 12
 equi
 fjp l1020
 mst 5
 cup 0 l25
 mst 2
 lods 1 5
i8550
 ldc( 9 12 16)
 uni
 cup 1 l898
 ujp l1021
l1020
 ldcb 1
 chkb 0 1
 strb 4 9
l1021
l1013
l1012
 lodb 4 9
 not
 fjp l1022
l1023
i8560
 ldoa 181
 chka 0 1073741823
 stra 0 5
 loda 0 5
 ldcn
 neqa
 fjp l1024
 loda 0 5
 chka 1 1073741823
 indi 2
i8570
 ldci 1
 leqi
 fjp l1025
 mst 3
 cup 0 l804
 ujp l1026
l1025
 mst 3
 cup 0 l848
l1026
l1024
 ldoi 9
 ldci 16
i8580
 equi
 fjp l1027
 mst 5
 cup 0 l25
 mst 2
 lods 1 5
 ldc( 9 12 16)
 uni
 cup 1 l898
 ldoa 181
i8590
 ldcn
 neqa
 fjp l1028
 ldoa 181
 ldoa 41
 neqa
 fjp l1029
 mst 5
 ldci 116
 cup 1 l20
l1029
l1028
i8600
 mst 3
 cup 0 l804
 ldcb 0
 chkb 0 1
 strb 0 6
 ujp l1030
l1027
 ldcb 1
 chkb 0 1
 strb 0 6
l1030
 ldoi 9
i8610
 ldci 16
 equi
 fjp l1031
 mst 5
 cup 0 l25
 mst 2
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l898
i8620
 ldoa 181
 ldcn
 neqa
 fjp l1032
 ldoa 181
 ldoa 41
 neqa
 fjp l1033
 mst 5
 ldci 116
i8630
 cup 1 l20
l1033
l1032
 loda 0 5
 ldoa 40
 neqa
 fjp l1034
 mst 5
 ldci 124
 cup 1 l20
l1034
 mst 3
 cup 0 l804
i8640
 mst 5
 ldci 399
 cup 1 l20
 ujp l1035
l1031
 loda 0 5
 ldoa 41
 equa
 fjp l1036
 lodb 0 6
 fjp l1037
i8650
 mst 3
 ldci 51
 chki 0 63
 ldci 1
 ldci 10
 cup 3 l745
l1037
 mst 3
 ldci 50
 chki 0 63
 ldoi 52
i8660
 lodi 0 8
 sbi
 lodi 0 10
 cup 3 l745
 mst 3
 ldci 30
 chki 0 63
 ldci 6
 cup 2 l732
 ujp l1038
l1036
i8670
 loda 0 5
 ldoa 40
 equa
 fjp l1039
 lodb 0 6
 fjp l1040
 mst 3
 ldci 51
 chki 0 63
 ldci 1
i8680
 ldci 20
 cup 3 l745
l1040
 mst 3
 ldci 50
 chki 0 63
 ldoi 52
 lodi 0 8
 sbi
 lodi 0 10
 cup 3 l745
i8690
 mst 3
 ldci 30
 chki 0 63
 ldci 8
 cup 2 l732
 ujp l1041
l1039
 loda 0 5
 ldoa 39
 equa
 fjp l1042
i8700
 lodb 0 6
 fjp l1043
 mst 3
 ldci 51
 chki 0 63
 ldci 1
 ldci 1
 cup 3 l745
l1043
 mst 3
 ldci 50
i8710
 chki 0 63
 ldoi 52
 lodi 0 8
 sbi
 lodi 0 10
 cup 3 l745
 mst 3
 ldci 30
 chki 0 63
 ldci 9
i8720
 cup 2 l732
 ujp l1044
l1042
 loda 0 5
 ldcn
 neqa
 fjp l1045
 loda 0 5
 chka 1 1073741823
 indi 2
 ldci 0
i8730
 equi
 fjp l1046
 mst 5
 ldci 399
 cup 1 l20
 ujp l1047
l1046
 mst 4
 loda 0 5
 cup 1 l385
 fjp l1048
i8740
 loda 0 5
 chka 1 1073741823
 indi 1
 ldci 1
 dvi
 chki 0 1073741823
 stri 0 9
 lodb 0 6
 fjp l1049
 mst 3
i8750
 ldci 51
 chki 0 63
 ldci 1
 lodi 0 9
 cup 3 l745
l1049
 mst 3
 ldci 51
 chki 0 63
 ldci 1
 lodi 0 9
i8760
 cup 3 l745
 mst 3
 ldci 50
 chki 0 63
 ldoi 52
 lodi 0 8
 sbi
 lodi 0 10
 cup 3 l745
 mst 3
i8770
 ldci 30
 chki 0 63
 ldci 10
 cup 2 l732
 ujp l1050
l1048
 mst 5
 ldci 116
 cup 1 l20
l1050
l1047
l1045
l1044
l1041
l1038
l1035
 ldoi 9
 ldci 12
i8780
 neqi
 chkb 0 1
 strb 4 9
 lodb 4 9
 not
 fjp l1051
 mst 5
 cup 0 l25
 mst 2
 lods 1 5
i8790
 ldc( 9 12 16)
 uni
 cup 1 l898
l1051
 lodb 4 9
 fjp l1023
l1022
 ldoi 9
 ldci 9
 equi
 fjp l1052
 mst 5
i8800
 cup 0 l25
 ujp l1053
l1052
 mst 5
 ldci 4
 cup 1 l20
l1053
 ujp l1054
l1011
 lodi 1 7
 ldci 6
 equi
 fjp l1055
i8810
 mst 5
 ldci 116
 cup 1 l20
l1055
l1054
 lodi 0 7
 ldci 12
 equi
 fjp l1056
 mst 3
 ldci 50
 chki 0 63
i8820
 ldoi 52
 lodi 0 8
 sbi
 lodi 0 10
 cup 3 l745
 mst 3
 ldci 30
 chki 0 63
 ldci 22
 cup 2 l732
l1056
i8830
 retp
l1009=12
l1010=62
l1057
 ent 1 l1058
 ent 2 l1059
 mst 5
 ldci 399
 cup 1 l20
 mst 1
 lods 1 5
 ldc( 9 12)
 uni
i8840
 cup 1 l965
 ldcn
 chka 0 1073741823
 stra 0 6
 ldcn
 chka 0 1073741823
 stra 0 5
 ldoa 181
 ldcn
 neqa
i8850
 fjp l1060
 ldoa 181
 chka 1 1073741823
 stra 0 7
 loda 0 7
 indi 2
 ldci 4
 equi
 fjp l1061
 loda 0 7
i8860
 inda 3
 chka 0 1073741823
 stra 0 6
 loda 0 7
 inda 4
 chka 0 1073741823
 stra 0 5
 ujp l1062
l1061
 mst 5
 ldci 116
i8870
 cup 1 l20
l1062
l1060
 ldoi 9
 ldci 12
 equi
 fjp l1063
 mst 5
 cup 0 l25
 ujp l1064
l1063
 mst 5
 ldci 20
i8880
 cup 1 l20
l1064
 mst 2
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l898
 ldoa 181
 ldcn
 neqa
 fjp l1065
i8890
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 0
 neqi
 fjp l1066
 mst 5
 ldci 116
 cup 1 l20
 ujp l1067
l1066
i8900
 mst 4
 loda 0 6
 ldoa 181
 cup 2 l356
 not
 fjp l1068
 mst 5
 ldci 116
 cup 1 l20
l1068
l1067
l1065
 ldoi 9
i8910
 ldci 12
 equi
 fjp l1069
 mst 5
 cup 0 l25
 ujp l1070
l1069
 mst 5
 ldci 20
 cup 1 l20
l1070
 mst 1
i8920
 lods 1 5
 ldc( 9)
 uni
 cup 1 l965
 ldoa 181
 ldcn
 neqa
 fjp l1071
 ldoa 181
 chka 1 1073741823
i8930
 stra 0 7
 loda 0 7
 indi 2
 ldci 4
 equi
 fjp l1072
 mst 4
 loda 0 7
 inda 4
 loda 0 5
i8940
 cup 2 l356
 not
 mst 4
 loda 0 7
 inda 3
 loda 0 6
 cup 2 l356
 not
 ior
 fjp l1073
i8950
 mst 5
 ldci 116
 cup 1 l20
l1073
 ujp l1074
l1072
 mst 5
 ldci 116
 cup 1 l20
l1074
l1071
 retp
l1058=8
l1059=19
l1075
 ent 1 l1076
 ent 2 l1077
i8960
 mst 5
 ldci 399
 cup 1 l20
 mst 1
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l965
 ldcn
 chka 0 1073741823
i8970
 stra 0 6
 ldcn
 chka 0 1073741823
 stra 0 5
 ldoa 181
 ldcn
 neqa
 fjp l1078
 ldoa 181
 chka 1 1073741823
i8980
 stra 0 7
 loda 0 7
 indi 2
 ldci 4
 equi
 fjp l1079
 loda 0 7
 inda 3
 chka 0 1073741823
 stra 0 6
i8990
 loda 0 7
 inda 4
 chka 0 1073741823
 stra 0 5
 ujp l1080
l1079
 mst 5
 ldci 116
 cup 1 l20
l1080
l1078
 ldoi 9
 ldci 12
i9000
 equi
 fjp l1081
 mst 5
 cup 0 l25
 ujp l1082
l1081
 mst 5
 ldci 20
 cup 1 l20
l1082
 mst 1
 lods 1 5
i9010
 ldc( 9 12)
 uni
 cup 1 l965
 ldoa 181
 ldcn
 neqa
 fjp l1083
 ldoa 181
 chka 1 1073741823
 stra 0 7
i9020
 loda 0 7
 indi 2
 ldci 4
 equi
 fjp l1084
 mst 4
 loda 0 7
 inda 4
 loda 0 5
 cup 2 l356
i9030
 not
 mst 4
 loda 0 7
 inda 3
 loda 0 6
 cup 2 l356
 not
 ior
 fjp l1085
 mst 5
i9040
 ldci 116
 cup 1 l20
l1085
 ujp l1086
l1084
 mst 5
 ldci 116
 cup 1 l20
l1086
l1083
 ldoi 9
 ldci 12
 equi
 fjp l1087
i9050
 mst 5
 cup 0 l25
 ujp l1088
l1087
 mst 5
 ldci 20
 cup 1 l20
l1088
 mst 2
 lods 1 5
 ldc( 9)
 uni
i9060
 cup 1 l898
 ldoa 181
 ldcn
 neqa
 fjp l1089
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 0
 neqi
i9070
 fjp l1090
 mst 5
 ldci 116
 cup 1 l20
 ujp l1091
l1090
 mst 4
 loda 0 6
 ldoa 181
 cup 2 l356
 not
i9080
 fjp l1092
 mst 5
 ldci 116
 cup 1 l20
l1092
l1091
l1089
 retp
l1076=8
l1077=19
l1093
 ent 1 l1095
 ent 2 l1096
 mst 1
 lods 1 5
 ldc( 9 12)
i9090
 uni
 cup 1 l965
 mst 3
 cup 0 l848
 ldcn
 chka 0 1073741823
 stra 0 6
 ldci 0
 stri 0 7
 ldci 0
i9100
 chki 0 1073741823
 stri 0 8
 ldoa 181
 ldcn
 neqa
 fjp l1097
 ldoa 181
 chka 1 1073741823
 stra 0 11
 loda 0 11
i9110
 indi 2
 ldci 2
 equi
 fjp l1098
 loda 0 11
 inda 3
 ldcn
 neqa
 fjp l1099
 loda 0 11
i9120
 inda 3
 chka 1 1073741823
 indi 1
 chki 0 1073741823
 stri 0 8
 loda 0 11
 inda 3
 chka 1 1073741823
 indi 2
 ldci 5
i9130
 equi
 fjp l1100
 loda 0 11
 inda 3
 chka 1 1073741823
 inda 4
 chka 0 1073741823
 stra 0 6
l1100
l1099
 ujp l1101
l1098
 mst 5
i9140
 ldci 116
 cup 1 l20
l1101
l1097
l1102
 ldoi 9
 ldci 12
 equi
 fjp l1103
 mst 5
 cup 0 l25
 mst 4
 lods 1 5
i9150
 ldc( 9 12)
 uni
 lda 0 5
 lda 0 9
 cup 3 l319
 lodi 0 7
 ldci 1
 adi
 stri 0 7
 loda 0 6
i9160
 ldcn
 equa
 fjp l1104
 mst 5
 ldci 158
 cup 1 l20
 ujp l1105
l1104
 loda 0 6
 chka 1 1073741823
 indi 2
i9170
 ldci 7
 neqi
 fjp l1106
 mst 5
 ldci 162
 cup 1 l20
 ujp l1107
l1106
 loda 0 6
 chka 1 1073741823
 inda 3
i9180
 ldcn
 neqa
 fjp l1108
 mst 4
 loda 0 5
 cup 1 l385
 loda 0 5
 ldoa 40
 equa
 ior
i9190
 fjp l1109
 mst 5
 ldci 159
 cup 1 l20
 ujp l1110
l1109
 mst 4
 loda 0 6
 chka 1 1073741823
 inda 3
 chka 1 1073741823
i9200
 inda 10
 loda 0 5
 cup 2 l356
 fjp l1111
 loda 0 6
 chka 1 1073741823
 inda 4
 chka 0 1073741823
 stra 0 5
l1112
 loda 0 5
i9210
 ldcn
 neqa
 fjp l1113
 loda 0 5
 chka 1 1073741823
 stra 0 11
 loda 0 11
 indi 6
 lodi 0 10
 equi
i9220
 fjp l1114
 loda 0 11
 indi 1
 chki 0 1073741823
 stri 0 8
 loda 0 11
 inda 3
 chka 0 1073741823
 stra 0 6
 ujp l1094
i9230
 ujp l1115
l1114
 loda 0 11
 inda 4
 chka 0 1073741823
 stra 0 5
l1115
 ujp l1112
l1113
 loda 0 6
 chka 1 1073741823
 indi 1
 chki 0 1073741823
i9240
 stri 0 8
 ldcn
 chka 0 1073741823
 stra 0 6
 ujp l1116
l1111
 mst 5
 ldci 116
 cup 1 l20
l1116
l1110
l1108
l1107
l1105
l1094
 ujp l1102
l1103
 mst 3
i9250
 ldci 51
 chki 0 63
 ldci 1
 lodi 0 8
 cup 3 l745
 mst 3
 ldci 30
 chki 0 63
 ldci 12
 cup 2 l732
i9260
 retp
l1095=12
l1096=20
l1117
 ent 1 l1118
 ent 2 l1119
 mst 1
 lods 1 5
 ldc( 9)
 uni
 cup 1 l965
 ldoa 181
 ldcn
i9270
 neqa
 fjp l1120
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 2
 equi
 fjp l1121
 mst 3
 cup 0 l848
i9280
 mst 3
 ldci 30
 chki 0 63
 ldci 23
 cup 2 l732
 ujp l1122
l1121
 mst 5
 ldci 116
 cup 1 l20
l1122
l1120
 retp
l1118=5
l1119=9
l1123
i9290
 ent 1 l1124
 ent 2 l1125
 mst 1
 lods 1 5
 ldc( 9)
 uni
 cup 1 l965
 ldoa 181
 ldcn
 neqa
i9300
 fjp l1126
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 2
 equi
 fjp l1127
 mst 3
 cup 0 l804
 mst 3
i9310
 ldci 30
 chki 0 63
 ldci 13
 cup 2 l732
 ujp l1128
l1127
 mst 5
 ldci 116
 cup 1 l20
l1128
l1126
 retp
l1124=5
l1125=9
l1129
 ent 1 l1130
i9320
 ent 2 l1131
 ldoa 181
 ldcn
 neqa
 fjp l1132
 ldoa 181
 ldoa 41
 equa
 fjp l1133
 mst 3
i9330
 ldci 0
 chki 0 63
 cup 1 l728
 ujp l1134
l1133
 ldoa 181
 ldoa 40
 equa
 fjp l1135
 mst 3
 ldci 1
i9340
 chki 0 63
 cup 1 l728
 ujp l1136
l1135
 mst 5
 ldci 125
 cup 1 l20
 ldoa 41
 chka 0 1073741823
 sroa 181
l1136
l1134
l1132
 retp
l1130=5
l1131=9
l1137
i9350
 ent 1 l1138
 ent 2 l1139
 ldoa 181
 ldcn
 neqa
 fjp l1140
 ldoa 181
 ldoa 41
 equa
 fjp l1141
i9360
 mst 3
 ldci 24
 chki 0 63
 cup 1 l728
 ujp l1142
l1141
 ldoa 181
 ldoa 40
 equa
 fjp l1143
 mst 3
i9370
 ldci 25
 chki 0 63
 cup 1 l728
 ujp l1144
l1143
 mst 5
 ldci 125
 cup 1 l20
 ldoa 41
 chka 0 1073741823
 sroa 181
l1144
l1142
l1140
i9380
 retp
l1138=5
l1139=9
l1145
 ent 1 l1146
 ent 2 l1147
 ldoa 181
 ldcn
 neqa
 fjp l1148
 ldoa 181
 ldoa 40
 neqa
i9390
 fjp l1149
 mst 5
 ldci 125
 cup 1 l20
l1149
l1148
 mst 3
 ldci 27
 chki 0 63
 cup 1 l728
 ldoa 41
 chka 0 1073741823
i9400
 sroa 181
 retp
l1146=5
l1147=8
l1150
 ent 1 l1151
 ent 2 l1152
 ldoa 181
 ldcn
 neqa
 fjp l1153
 ldoa 181
 ldoa 41
i9410
 neqa
 fjp l1154
 mst 5
 ldci 125
 cup 1 l20
l1154
l1153
 mst 3
 ldci 20
 chki 0 63
 cup 1 l728
 ldoa 38
i9420
 chka 0 1073741823
 sroa 181
 retp
l1151=5
l1152=8
l1155
 ent 1 l1156
 ent 2 l1157
 ldoa 181
 ldcn
 neqa
 fjp l1158
 ldoa 181
i9430
 chka 1 1073741823
 indi 2
 ldci 3
 geqi
 fjp l1159
 mst 5
 ldci 125
 cup 1 l20
l1159
l1158
 mst 3
 ldci 58
i9440
 chki 0 63
 ldoa 181
 cup 2 l792
 ldoa 41
 chka 0 1073741823
 sroa 181
 retp
l1156=5
l1157=9
l1160
 ent 1 l1161
 ent 2 l1162
 ldoa 181
i9450
 ldcn
 neqa
 fjp l1163
 ldoa 181
 ldoa 41
 neqa
 fjp l1164
 mst 5
 ldci 125
 cup 1 l20
l1164
l1163
i9460
 mst 3
 ldci 59
 chki 0 63
 cup 1 l728
 ldoa 39
 chka 0 1073741823
 sroa 181
 retp
l1161=5
l1162=8
l1165
 ent 1 l1166
 ent 2 l1167
i9470
 ldoa 181
 ldcn
 neqa
 fjp l1168
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 0
 neqi
 fjp l1169
i9480
 mst 5
 ldci 125
 cup 1 l20
l1169
l1168
 lodi 1 7
 ldci 7
 equi
 fjp l1170
 mst 3
 ldci 31
 chki 0 63
i9490
 ldci 1
 ldoa 181
 cup 3 l796
 ujp l1171
l1170
 mst 3
 ldci 34
 chki 0 63
 ldci 1
 ldoa 181
 cup 3 l796
l1171
i9500
 retp
l1166=5
l1167=12
l1172
 ent 1 l1173
 ent 2 l1174
 ldoi 9
 ldci 8
 equi
 fjp l1175
 mst 5
 cup 0 l25
 mst 1
i9510
 lods 1 5
 ldc( 9)
 uni
 cup 1 l965
 ldoi 9
 ldci 9
 equi
 fjp l1176
 mst 5
 cup 0 l25
i9520
 ujp l1177
l1176
 mst 5
 ldci 4
 cup 1 l20
l1177
 ujp l1178
l1175
 ldoa 36
 chka 0 1073741823
 sroa 181
 ldci 1
 chki 0 2
i9530
 sroi 182
 ldci 0
 chki 0 2
 sroi 183
 ldci 1
 chki 0 10
 sroi 184
 ldci 5
 chki 0 1073741823
 sroi 185
l1178
i9540
 mst 3
 cup 0 l848
 ldoa 181
 ldcn
 neqa
 fjp l1179
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 6
i9550
 neqi
 fjp l1180
 mst 5
 ldci 125
 cup 1 l20
l1180
l1179
 lodi 1 7
 ldci 9
 equi
 fjp l1181
 mst 3
i9560
 ldci 8
 chki 0 63
 cup 1 l728
 ujp l1182
l1181
 mst 3
 ldci 30
 chki 0 63
 ldci 14
 cup 2 l732
l1182
 ldoa 38
i9570
 chka 0 1073741823
 sroa 181
 retp
l1173=5
l1174=12
l1183
 ent 1 l1184
 ent 2 l1185
 ldci 0
 chki 0 1073741823
 stri 0 11
 loda 1 6
 chka 1 1073741823
i9580
 stra 0 12
 loda 0 12
 inda 11
 chka 0 1073741823
 stra 0 6
 loda 0 12
 indi 16
 chki 0 1
 stri 0 8
 loda 0 12
i9590
 indb 17
 not
 fjp l1186
 mst 3
 ldci 41
 chki 0 63
 ldoi 52
 loda 0 12
 indi 14
 sbi
i9600
 cup 2 l732
l1186
 ldoi 9
 ldci 8
 equi
 fjp l1187
 ldoi 27
 chki 0 1073741823
 stri 0 10
l1188
 ldcb 0
 chkb 0 1
i9610
 strb 0 9
 lodi 0 8
 ldci 0
 equi
 fjp l1189
 loda 0 6
 ldcn
 equa
 fjp l1190
 mst 5
i9620
 ldci 126
 cup 1 l20
 ujp l1191
l1190
 loda 0 6
 chka 1 1073741823
 indi 12
 ordi
 ldc( 4 5)
 inn
 chkb 0 1
i9630
 strb 0 9
l1191
 ujp l1192
l1189
 mst 5
 ldci 399
 cup 1 l20
l1192
 mst 5
 cup 0 l25
 lodb 0 9
 fjp l1193
 mst 5
i9640
 ldci 399
 cup 1 l20
 ldoi 9
 ldci 0
 neqi
 fjp l1194
 mst 5
 ldci 2
 cup 1 l20
 mst 4
i9650
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l312
 ujp l1195
l1194
 loda 0 6
 chka 1 1073741823
 indi 12
 ldci 4
 equi
i9660
 fjp l1196
 mst 5
 ldc( 4)
 lda 0 5
 cup 2 l157
 ujp l1197
l1196
 mst 5
 ldc( 5)
 lda 0 5
 cup 2 l157
i9670
 mst 4
 loda 0 5
 chka 1 1073741823
 inda 10
 loda 0 6
 chka 1 1073741823
 inda 10
 cup 2 l356
 not
 fjp l1198
i9680
 mst 5
 ldci 128
 cup 1 l20
l1198
l1197
 mst 5
 cup 0 l25
 ldoi 9
 ordi
 lods 1 5
 ldc( 9 12)
 uni
i9690
 inn
 not
 fjp l1199
 mst 5
 ldci 6
 cup 1 l20
 mst 4
 lods 1 5
 ldc( 9 12)
 uni
i9700
 cup 1 l312
l1199
l1195
 ujp l1200
l1193
 mst 2
 lods 1 5
 ldc( 9 12)
 uni
 cup 1 l898
 ldoa 181
 ldcn
 neqa
i9710
 fjp l1201
 lodi 0 8
 ldci 0
 equi
 fjp l1202
 loda 0 6
 ldcn
 neqa
 fjp l1203
 loda 0 6
i9720
 chka 1 1073741823
 inda 10
 chka 0 1073741823
 stra 0 7
 loda 0 7
 ldcn
 neqa
 fjp l1204
 loda 0 6
 chka 1 1073741823
i9730
 indi 13
 ldci 0
 equi
 fjp l1205
 loda 0 7
 chka 1 1073741823
 indi 2
 ldci 3
 leqi
 fjp l1206
i9740
 mst 3
 cup 0 l804
 ldob 34
 fjp l1207
 mst 3
 loda 0 7
 cup 1 l885
l1207
 mst 4
 ldoa 40
 loda 0 7
i9750
 cup 2 l356
 ldoa 181
 ldoa 41
 equa
 and
 fjp l1208
 mst 3
 ldci 10
 chki 0 63
 cup 1 l728
i9760
 ldoa 40
 chka 0 1073741823
 sroa 181
l1208
 lodi 0 11
 loda 0 7
 chka 1 1073741823
 indi 1
 adi
 chki 0 1073741823
 stri 0 11
i9770
 mst 5
 ldoa 42
 lda 0 11
 cup 2 l217
 ujp l1209
l1206
 mst 3
 cup 0 l848
 lodi 0 11
 ldci 1
 adi
i9780
 chki 0 1073741823
 stri 0 11
 mst 5
 ldoa 42
 lda 0 11
 cup 2 l217
l1209
 ujp l1210
l1205
 ldoi 182
 ldci 1
 equi
i9790
 fjp l1211
 mst 3
 cup 0 l848
 lodi 0 11
 ldci 1
 adi
 chki 0 1073741823
 stri 0 11
 mst 5
 ldoa 42
i9800
 lda 0 11
 cup 2 l217
 ujp l1212
l1211
 mst 5
 ldci 154
 cup 1 l20
l1212
l1210
 mst 4
 loda 0 7
 ldoa 181
 cup 2 l356
i9810
 not
 fjp l1213
 mst 5
 ldci 142
 cup 1 l20
l1213
l1204
l1203
 ujp l1214
l1202
l1214
l1201
l1200
 lodi 0 8
 ldci 0
 equi
 loda 0 6
i9820
 ldcn
 neqa
 and
 fjp l1215
 loda 0 6
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 6
l1215
 ldoi 9
i9830
 ldci 12
 neqi
 fjp l1188
 lodi 0 10
 chki 0 1073741823
 sroi 27
 ldoi 9
 ldci 9
 equi
 fjp l1216
i9840
 mst 5
 cup 0 l25
 ujp l1217
l1216
 mst 5
 ldci 4
 cup 1 l20
l1217
l1187
 lodi 0 8
 ldci 0
 equi
 fjp l1218
i9850
 loda 0 6
 ldcn
 neqa
 fjp l1219
 mst 5
 ldci 126
 cup 1 l20
l1219
 loda 1 6
 chka 1 1073741823
 stra 0 12
i9860
 loda 0 12
 indb 17
 fjp l1220
 mst 3
 ldci 30
 chki 0 63
 loda 0 12
 indi 15
 cup 2 l732
 ujp l1221
l1220
i9870
 mst 3
 ldci 46
 chki 0 63
 lodi 0 11
 loda 0 12
 indi 15
 cup 3 l881
l1221
l1218
 loda 1 6
 chka 1 1073741823
 inda 10
i9880
 chka 0 1073741823
 sroa 181
 retp
l1184=13
l1185=41
l964
 ent 1 l1222
 ent 2 l1223
 loda 0 6
 chka 1 1073741823
 indi 13
 ldci 0
 equi
i9890
 fjp l1224
 loda 0 6
 chka 1 1073741823
 indi 14
 chki 1 15
 stri 0 7
 loda 0 6
 chka 1 1073741823
 indi 12
 ldci 4
i9900
 equi
 fjp l1225
 lodi 0 7
 ldc( 5 6 11 12)
 inn
 not
 fjp l1226
 ldoi 9
 ldci 8
 equi
i9910
 fjp l1227
 mst 4
 cup 0 l25
 ujp l1228
l1227
 mst 4
 ldci 9
 cup 1 l20
l1228
l1226
 lodi 0 7
 ujp l1229
l1231
 mst 0
i9920
 cup 0 l970
 ujp l1230
l1232
 mst 0
 cup 0 l977
 ujp l1230
l1233
 mst 0
 cup 0 l1008
 ujp l1230
l1234
 mst 0
 cup 0 l1057
i9930
 ujp l1230
l1235
 mst 0
 cup 0 l1075
 ujp l1230
l1236
 mst 0
 cup 0 l1093
 ujp l1230
l1237
 mst 0
 cup 0 l1123
 ujp l1230
l1238
i9940
 mst 0
 cup 0 l1117
 ujp l1230
l1229
 chki 1 13
 ldci 1
 sbi
 xjp l1239
l1239
 ujp l1231
 ujp l1231
 ujp l1231
i9950
 ujp l1231
 ujp l1232
 ujp l1233
 ujp l1234
 ujp l1235
 ujp l1236
 ujp l1237
 ujp l1232
 ujp l1233
 ujp l1238
l1230
i9960
 lodi 0 7
 ldc( 5 6 11 12)
 inn
 not
 fjp l1240
 ldoi 9
 ldci 9
 equi
 fjp l1241
 mst 4
i9970
 cup 0 l25
 ujp l1242
l1241
 mst 4
 ldci 4
 cup 1 l20
l1242
l1240
 ujp l1243
l1225
 lodi 0 7
 ldci 8
 leqi
 fjp l1244
i9980
 ldoi 9
 ldci 8
 equi
 fjp l1245
 mst 4
 cup 0 l25
 ujp l1246
l1245
 mst 4
 ldci 9
 cup 1 l20
l1246
i9990
 mst 1
 lods 0 5
 ldc( 9)
 uni
 cup 1 l898
 mst 2
 cup 0 l804
l1244
 lodi 0 7
 ujp l1247
l1249
 mst 0
i10000
 cup 0 l1129
 ujp l1248
l1250
 mst 0
 cup 0 l1137
 ujp l1248
l1251
 mst 0
 cup 0 l1145
 ujp l1248
l1252
 mst 0
 cup 0 l1150
i10010
 ujp l1248
l1253
 mst 0
 cup 0 l1155
 ujp l1248
l1254
 mst 0
 cup 0 l1160
 ujp l1248
l1255
 mst 0
 cup 0 l1165
 ujp l1248
l1256
i10020
 mst 0
 cup 0 l1172
 ujp l1248
l1247
 chki 1 10
 ldci 1
 sbi
 xjp l1257
l1257
 ujp l1249
 ujp l1250
 ujp l1251
i10030
 ujp l1252
 ujp l1253
 ujp l1254
 ujp l1255
 ujp l1255
 ujp l1256
 ujp l1256
l1248
 lodi 0 7
 ldci 8
 leqi
i10040
 fjp l1258
 ldoi 9
 ldci 9
 equi
 fjp l1259
 mst 4
 cup 0 l25
 ujp l1260
l1259
 mst 4
 ldci 4
i10050
 cup 1 l20
l1260
l1258
l1243
 ujp l1261
l1224
 mst 0
 cup 0 l1183
l1261
 retp
l1222=8
l1223=11
l1264
 ent 1 l1265
 ent 2 l1266
 ldoi 9
 ordi
 ldos 188
i10060
 inn
 not
 fjp l1267
 mst 7
 ldci 58
 cup 1 l20
 mst 6
 lods 0 5
 ldos 188
 uni
i10070
 cup 1 l312
 ldcn
 chka 0 1073741823
 sroa 181
l1267
l1268
 ldoi 9
 ordi
 ldos 188
 inn
 fjp l1269
 ldoi 9
i10080
 ordi
 ujp l1270
l1272
 mst 7
 ldc( 1 2 3 5)
 lda 0 6
 cup 2 l157
 mst 7
 cup 0 l25
 loda 0 6
 chka 1 1073741823
i10090
 indi 12
 ldci 5
 equi
 fjp l1273
 mst 4
 lods 0 5
 loda 0 6
 cup 2 l964
 ldci 2
 chki 0 2
i10100
 sroi 182
 ldoa 181
 ldcn
 neqa
 fjp l1274
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 1
 equi
i10110
 fjp l1275
 ldoa 181
 chka 1 1073741823
 inda 3
 chka 0 1073741823
 sroa 181
l1275
l1274
 ujp l1276
l1273
 loda 0 6
 chka 1 1073741823
 indi 12
i10120
 ldci 1
 equi
 fjp l1277
 loda 0 6
 chka 1 1073741823
 stra 0 11
 loda 0 11
 inda 10
 chka 0 1073741823
 sroa 181
i10130
 ldci 0
 chki 0 2
 sroi 182
 lao 183
 loda 0 11
 inca 13
 mov 2
 ujp l1278
l1277
 mst 4
 lods 0 5
i10140
 loda 0 6
 cup 2 l899
 ldoa 181
 ldcn
 neqa
 fjp l1279
 ldoa 181
 chka 1 1073741823
 stra 0 11
 loda 0 11
i10150
 indi 2
 ldci 1
 equi
 fjp l1280
 loda 0 11
 inda 3
 chka 0 1073741823
 sroa 181
l1280
l1279
l1278
l1276
 ujp l1271
l1281
 ldoa 41
i10160
 chka 0 1073741823
 sroa 181
 ldci 0
 chki 0 2
 sroi 182
 lao 183
 lao 11
 mov 2
 mst 7
 cup 0 l25
i10170
 ujp l1271
l1282
 ldoa 40
 chka 0 1073741823
 sroa 181
 ldci 0
 chki 0 2
 sroi 182
 lao 183
 lao 11
 mov 2
i10180
 mst 7
 cup 0 l25
 ujp l1271
l1283
 ldoi 13
 ldci 1
 equi
 fjp l1284
 ldoa 39
 chka 0 1073741823
 sroa 181
i10190
 ujp l1285
l1284
 lda 0 10
 ldci 5
 csp new
 loda 0 10
 chka 1 1073741823
 stra 0 11
 loda 0 11
 inca 4
 ldoa 39
i10200
 chka 0 1073741823
 stoa
 loda 0 11
 inca 2
 ldci 4
 chki 0 8
 stoi
 loda 0 11
 inca 3
 ldcn
i10210
 chka 0 1073741823
 stoa
 loda 0 11
 inca 1
 ldoi 13
 ldci 1
 mpi
 chki 0 1073741823
 stoi
 loda 0 10
i10220
 chka 0 1073741823
 sroa 181
l1285
 ldci 0
 chki 0 2
 sroi 182
 lao 183
 lao 11
 mov 2
 mst 7
 cup 0 l25
i10230
 ujp l1271
l1286
 mst 7
 cup 0 l25
 mst 4
 lods 0 5
 ldc( 9)
 uni
 cup 1 l898
 ldoi 9
 ldci 9
i10240
 equi
 fjp l1287
 mst 7
 cup 0 l25
 ujp l1288
l1287
 mst 7
 ldci 4
 cup 1 l20
l1288
 ujp l1271
l1289
 mst 7
i10250
 cup 0 l25
 mst 1
 lods 0 5
 cup 1 l1264
 mst 5
 cup 0 l804
 mst 5
 ldci 19
 chki 0 63
 cup 1 l728
i10260
 ldoa 181
 ldcn
 neqa
 fjp l1290
 ldoa 181
 ldoa 38
 neqa
 fjp l1291
 mst 7
 ldci 135
i10270
 cup 1 l20
 ldcn
 chka 0 1073741823
 sroa 181
l1291
l1290
 ujp l1271
l1292
 mst 7
 cup 0 l25
 ldc()
 strs 0 9
 ldcb 0
i10280
 chkb 0 1
 strb 0 8
 lda 0 10
 ldci 4
 csp new
 loda 0 10
 chka 1 1073741823
 stra 0 11
 loda 0 11
 inca 3
i10290
 ldcn
 chka 0 1073741823
 stoa
 loda 0 11
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
 loda 0 11
 inca 2
i10300
 ldci 3
 chki 0 8
 stoi
 ldoi 9
 ldci 11
 equi
 fjp l1293
 loda 0 10
 chka 0 1073741823
 sroa 181
i10310
 ldci 0
 chki 0 2
 sroi 182
 mst 7
 cup 0 l25
 ujp l1294
l1293
l1295
 mst 4
 lods 0 5
 ldc( 11 12)
 uni
i10320
 cup 1 l898
 ldoa 181
 ldcn
 neqa
 fjp l1296
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 0
 neqi
i10330
 fjp l1297
 mst 7
 ldci 136
 cup 1 l20
 ldcn
 chka 0 1073741823
 sroa 181
 ujp l1298
l1297
 mst 6
 loda 0 10
i10340
 chka 1 1073741823
 inda 3
 ldoa 181
 cup 2 l356
 fjp l1299
 ldoi 182
 ldci 0
 equi
 fjp l1300
 ldoi 184
i10350
 ldci 0
 lesi
 ldoi 184
 ldci 47
 grti
 ior
 fjp l1301
 mst 7
 ldci 304
 cup 1 l20
i10360
 ujp l1302
l1301
 lods 0 9
 ldoi 184
 sgs
 uni
 strs 0 9
l1302
 ujp l1303
l1300
 mst 5
 cup 0 l804
 mst 6
i10370
 ldoa 181
 ldoa 41
 cup 2 l356
 not
 fjp l1304
 mst 5
 ldci 58
 chki 0 63
 ldoa 181
 cup 2 l792
l1304
i10380
 mst 5
 ldci 23
 chki 0 63
 cup 1 l728
 lodb 0 8
 fjp l1305
 mst 5
 ldci 28
 chki 0 63
 cup 1 l728
i10390
 ujp l1306
l1305
 ldcb 1
 chkb 0 1
 strb 0 8
l1306
l1303
 loda 0 10
 chka 1 1073741823
 inca 3
 ldoa 181
 chka 0 1073741823
 stoa
i10400
 loda 0 10
 chka 0 1073741823
 sroa 181
 ujp l1307
l1299
 mst 7
 ldci 137
 cup 1 l20
l1307
l1298
l1296
 ldoi 9
 ldci 12
 neqi
i10410
 chkb 0 1
 strb 6 9
 lodb 6 9
 not
 fjp l1308
 mst 7
 cup 0 l25
l1308
 lodb 6 9
 fjp l1295
 ldoi 9
i10420
 ldci 11
 equi
 fjp l1309
 mst 7
 cup 0 l25
 ujp l1310
l1309
 mst 7
 ldci 12
 cup 1 l20
l1310
l1294
 lodb 0 8
i10430
 fjp l1311
 lods 0 9
 ldc()
 neqs
 fjp l1312
 lda 0 7
 ldci 2
 csp new
 loda 0 7
 chka 1 1073741823
i10440
 inca 1
 lods 0 9
 stos
 loda 0 7
 chka 1 1073741823
 ldci 1
 chki 0 2
 stoi
 lodi 5 80
 ldci 65
i10450
 equi
 fjp l1313
 mst 7
 ldci 254
 cup 1 l20
 ujp l1314
l1313
 lodi 5 80
 ldci 1
 adi
 chki 0 65
i10460
 stri 5 80
 lda 5 15
 lodi 5 80
 chki 1 65
 deci 1
 ixa 1
 loda 0 7
 chka 0 1073741823
 stoa
 mst 5
i10470
 ldci 51
 chki 0 63
 ldci 5
 lodi 5 80
 cup 3 l745
 mst 5
 ldci 28
 chki 0 63
 cup 1 l728
 ldci 2
i10480
 chki 0 2
 sroi 182
l1314
l1312
 ujp l1315
l1311
 lda 0 7
 ldci 2
 csp new
 loda 0 7
 chka 1 1073741823
 inca 1
 lods 0 9
i10490
 stos
 loda 0 7
 chka 1 1073741823
 ldci 1
 chki 0 2
 stoi
 loda 0 7
 chka 0 1073741823
 sroa 184
l1315
 ujp l1271
l1270
i10500
 chki 0 10
 ldci 0
 sbi
 xjp l1316
l1316
 ujp l1272
 ujp l1281
 ujp l1282
 ujp l1283
 ujp l1289
 ujc
i10510
 ujc
 ujc
 ujp l1286
 ujc
 ujp l1292
l1271
 ldoi 9
 ordi
 lods 0 5
 inn
 not
i10520
 fjp l1317
 mst 7
 ldci 6
 cup 1 l20
 mst 6
 lods 0 5
 ldos 188
 uni
 cup 1 l312
l1317
 ujp l1268
l1269
i10530
 retp
l1265=12
l1266=37
l1263
 ent 1 l1318
 ent 2 l1319
 mst 0
 lods 0 5
 ldc( 5)
 uni
 cup 1 l1264
l1320
 ldoi 9
 ldci 5
i10540
 equi
 fjp l1321
 mst 4
 cup 0 l804
 lda 0 6
 lao 181
 mov 5
 ldoi 10
 chki 0 15
 stri 0 11
i10550
 mst 6
 cup 0 l25
 mst 0
 lods 0 5
 ldc( 5)
 uni
 cup 1 l1264
 mst 4
 cup 0 l804
 loda 0 6
i10560
 ldcn
 neqa
 ldoa 181
 ldcn
 neqa
 and
 fjp l1322
 lodi 0 11
 ordi
 ujp l1323
l1325
i10570
 loda 0 6
 ldoa 41
 equa
 ldoa 181
 ldoa 41
 equa
 and
 fjp l1326
 mst 4
 ldci 15
i10580
 chki 0 63
 cup 1 l728
 ujp l1327
l1326
 loda 0 6
 ldoa 41
 equa
 fjp l1328
 mst 4
 ldci 9
 chki 0 63
i10590
 cup 1 l728
 ldoa 40
 chka 0 1073741823
 stra 0 6
 ujp l1329
l1328
 ldoa 181
 ldoa 41
 equa
 fjp l1330
 mst 4
i10600
 ldci 10
 chki 0 63
 cup 1 l728
 ldoa 40
 chka 0 1073741823
 sroa 181
l1330
l1329
 loda 0 6
 ldoa 40
 equa
 ldoa 181
i10610
 ldoa 40
 equa
 and
 fjp l1331
 mst 4
 ldci 16
 chki 0 63
 cup 1 l728
 ujp l1332
l1331
 loda 0 6
i10620
 chka 1 1073741823
 indi 2
 ldci 3
 equi
 mst 5
 loda 0 6
 ldoa 181
 cup 2 l356
 and
 fjp l1333
i10630
 mst 4
 ldci 12
 chki 0 63
 cup 1 l728
 ujp l1334
l1333
 mst 6
 ldci 134
 cup 1 l20
 ldcn
 chka 0 1073741823
i10640
 sroa 181
l1334
l1332
l1327
 ujp l1324
l1335
 ldoa 181
 ldoa 41
 equa
 fjp l1336
 mst 4
 ldci 10
 chki 0 63
 cup 1 l728
i10650
 ldoa 40
 chka 0 1073741823
 sroa 181
l1336
 loda 0 6
 ldoa 41
 equa
 fjp l1337
 mst 4
 ldci 9
 chki 0 63
i10660
 cup 1 l728
 ldoa 40
 chka 0 1073741823
 stra 0 6
l1337
 loda 0 6
 ldoa 40
 equa
 ldoa 181
 ldoa 40
 equa
i10670
 and
 fjp l1338
 mst 4
 ldci 7
 chki 0 63
 cup 1 l728
 ujp l1339
l1338
 mst 6
 ldci 134
 cup 1 l20
i10680
 ldcn
 chka 0 1073741823
 sroa 181
l1339
 ujp l1324
l1340
 loda 0 6
 ldoa 41
 equa
 ldoa 181
 ldoa 41
 equa
i10690
 and
 fjp l1341
 mst 4
 ldci 6
 chki 0 63
 cup 1 l728
 ujp l1342
l1341
 mst 6
 ldci 134
 cup 1 l20
i10700
 ldcn
 chka 0 1073741823
 sroa 181
l1342
 ujp l1324
l1343
 loda 0 6
 ldoa 41
 equa
 ldoa 181
 ldoa 41
 equa
i10710
 and
 fjp l1344
 mst 4
 ldci 14
 chki 0 63
 cup 1 l728
 ujp l1345
l1344
 mst 6
 ldci 134
 cup 1 l20
i10720
 ldcn
 chka 0 1073741823
 sroa 181
l1345
 ujp l1324
l1346
 loda 0 6
 ldoa 38
 equa
 ldoa 181
 ldoa 38
 equa
i10730
 and
 fjp l1347
 mst 4
 ldci 4
 chki 0 63
 cup 1 l728
 ujp l1348
l1347
 mst 6
 ldci 134
 cup 1 l20
i10740
 ldcn
 chka 0 1073741823
 sroa 181
l1348
 ujp l1324
l1323
 chki 0 4
 ldci 0
 sbi
 xjp l1349
l1349
 ujp l1325
 ujp l1335
i10750
 ujp l1346
 ujp l1340
 ujp l1343
l1324
 ujp l1350
l1322
 ldcn
 chka 0 1073741823
 sroa 181
l1350
 ujp l1320
l1321
 retp
l1318=12
l1319=26
l1262
 ent 1 l1351
i10760
 ent 2 l1352
 ldcb 0
 chkb 0 1
 strb 0 12
 ldoi 9
 ldci 6
 equi
 ldoi 10
 ordi
 ldc( 5 6)
i10770
 inn
 and
 fjp l1353
 ldoi 10
 ldci 6
 equi
 chkb 0 1
 strb 0 12
 mst 5
 cup 0 l25
l1353
i10780
 mst 0
 lods 0 5
 ldc( 6)
 uni
 cup 1 l1263
 lodb 0 12
 fjp l1354
 mst 3
 cup 0 l804
 ldoa 181
i10790
 ldoa 41
 equa
 fjp l1355
 mst 3
 ldci 17
 chki 0 63
 cup 1 l728
 ujp l1356
l1355
 ldoa 181
 ldoa 40
i10800
 equa
 fjp l1357
 mst 3
 ldci 18
 chki 0 63
 cup 1 l728
 ujp l1358
l1357
 mst 5
 ldci 134
 cup 1 l20
i10810
 ldcn
 chka 0 1073741823
 sroa 181
l1358
l1356
l1354
l1359
 ldoi 9
 ldci 6
 equi
 fjp l1360
 mst 3
 cup 0 l804
 lda 0 6
i10820
 lao 181
 mov 5
 ldoi 10
 chki 0 15
 stri 0 11
 mst 5
 cup 0 l25
 mst 0
 lods 0 5
 ldc( 6)
i10830
 uni
 cup 1 l1263
 mst 3
 cup 0 l804
 loda 0 6
 ldcn
 neqa
 ldoa 181
 ldcn
 neqa
i10840
 and
 fjp l1361
 lodi 0 11
 ordi
 ujp l1362
l1364
 loda 0 6
 ldoa 41
 equa
 ldoa 181
 ldoa 41
i10850
 equa
 and
 fjp l1365
 mst 3
 ldci 2
 chki 0 63
 cup 1 l728
 ujp l1366
l1365
 loda 0 6
 ldoa 41
i10860
 equa
 fjp l1367
 mst 3
 ldci 9
 chki 0 63
 cup 1 l728
 ldoa 40
 chka 0 1073741823
 stra 0 6
 ujp l1368
l1367
i10870
 ldoa 181
 ldoa 41
 equa
 fjp l1369
 mst 3
 ldci 10
 chki 0 63
 cup 1 l728
 ldoa 40
 chka 0 1073741823
i10880
 sroa 181
l1369
l1368
 loda 0 6
 ldoa 40
 equa
 ldoa 181
 ldoa 40
 equa
 and
 fjp l1370
 mst 3
i10890
 ldci 3
 chki 0 63
 cup 1 l728
 ujp l1371
l1370
 loda 0 6
 chka 1 1073741823
 indi 2
 ldci 3
 equi
 mst 4
i10900
 loda 0 6
 ldoa 181
 cup 2 l356
 and
 fjp l1372
 mst 3
 ldci 28
 chki 0 63
 cup 1 l728
 ujp l1373
l1372
i10910
 mst 5
 ldci 134
 cup 1 l20
 ldcn
 chka 0 1073741823
 sroa 181
l1373
l1371
l1366
 ujp l1363
l1374
 loda 0 6
 ldoa 41
 equa
i10920
 ldoa 181
 ldoa 41
 equa
 and
 fjp l1375
 mst 3
 ldci 21
 chki 0 63
 cup 1 l728
 ujp l1376
l1375
i10930
 loda 0 6
 ldoa 41
 equa
 fjp l1377
 mst 3
 ldci 9
 chki 0 63
 cup 1 l728
 ldoa 40
 chka 0 1073741823
i10940
 stra 0 6
 ujp l1378
l1377
 ldoa 181
 ldoa 41
 equa
 fjp l1379
 mst 3
 ldci 10
 chki 0 63
 cup 1 l728
i10950
 ldoa 40
 chka 0 1073741823
 sroa 181
l1379
l1378
 loda 0 6
 ldoa 40
 equa
 ldoa 181
 ldoa 40
 equa
 and
i10960
 fjp l1380
 mst 3
 ldci 22
 chki 0 63
 cup 1 l728
 ujp l1381
l1380
 loda 0 6
 chka 1 1073741823
 indi 2
 ldci 3
i10970
 equi
 mst 4
 loda 0 6
 ldoa 181
 cup 2 l356
 and
 fjp l1382
 mst 3
 ldci 5
 chki 0 63
i10980
 cup 1 l728
 ujp l1383
l1382
 mst 5
 ldci 134
 cup 1 l20
 ldcn
 chka 0 1073741823
 sroa 181
l1383
l1381
l1376
 ujp l1363
l1384
 loda 0 6
i10990
 ldoa 38
 equa
 ldoa 181
 ldoa 38
 equa
 and
 fjp l1385
 mst 3
 ldci 13
 chki 0 63
i11000
 cup 1 l728
 ujp l1386
l1385
 mst 5
 ldci 134
 cup 1 l20
 ldcn
 chka 0 1073741823
 sroa 181
l1386
 ujp l1363
l1362
 chki 5 7
i11010
 ldci 5
 sbi
 xjp l1387
l1387
 ujp l1364
 ujp l1374
 ujp l1384
l1363
 ujp l1388
l1361
 ldcn
 chka 0 1073741823
 sroa 181
l1388
i11020
 ujp l1359
l1360
 retp
l1351=13
l1352=28
l898
 ent 1 l1389
 ent 2 l1390
 mst 0
 lods 0 5
 ldc( 7)
 uni
 cup 1 l1262
 ldoi 9
i11030
 ldci 7
 equi
 fjp l1391
 ldoa 181
 ldcn
 neqa
 fjp l1392
 ldoa 181
 chka 1 1073741823
 indi 2
i11040
 ldci 3
 leqi
 fjp l1393
 mst 2
 cup 0 l804
 ujp l1394
l1393
 mst 2
 cup 0 l848
l1394
l1392
 lda 0 6
 lao 181
i11050
 mov 5
 ldoi 10
 chki 0 15
 stri 0 11
 lodi 0 11
 ldci 14
 equi
 fjp l1395
 mst 3
 ldoa 181
i11060
 ldoa 41
 cup 2 l356
 not
 fjp l1396
 mst 2
 ldci 58
 chki 0 63
 ldoa 181
 cup 2 l792
l1396
l1395
 mst 4
i11070
 cup 0 l25
 mst 0
 lods 0 5
 cup 1 l1262
 ldoa 181
 ldcn
 neqa
 fjp l1397
 ldoa 181
 chka 1 1073741823
i11080
 indi 2
 ldci 3
 leqi
 fjp l1398
 mst 2
 cup 0 l804
 ujp l1399
l1398
 mst 2
 cup 0 l848
l1399
l1397
 loda 0 6
i11090
 ldcn
 neqa
 ldoa 181
 ldcn
 neqa
 and
 fjp l1400
 lodi 0 11
 ldci 14
 equi
i11100
 fjp l1401
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 3
 equi
 fjp l1402
 mst 3
 loda 0 6
 ldoa 181
i11110
 chka 1 1073741823
 inda 3
 cup 2 l356
 fjp l1403
 mst 2
 ldci 11
 chki 0 63
 cup 1 l728
 ujp l1404
l1403
 mst 4
i11120
 ldci 129
 cup 1 l20
 ldcn
 chka 0 1073741823
 sroa 181
l1404
 ujp l1405
l1402
 mst 4
 ldci 130
 cup 1 l20
 ldcn
i11130
 chka 0 1073741823
 sroa 181
l1405
 ujp l1406
l1401
 loda 0 6
 ldoa 181
 neqa
 fjp l1407
 loda 0 6
 ldoa 41
 equa
i11140
 fjp l1408
 mst 2
 ldci 9
 chki 0 63
 cup 1 l728
 ldoa 40
 chka 0 1073741823
 stra 0 6
 ujp l1409
l1408
 ldoa 181
i11150
 ldoa 41
 equa
 fjp l1410
 mst 2
 ldci 10
 chki 0 63
 cup 1 l728
 ldoa 40
 chka 0 1073741823
 sroa 181
l1410
l1409
l1407
i11160
 mst 3
 loda 0 6
 ldoa 181
 cup 2 l356
 fjp l1411
 loda 0 6
 chka 1 1073741823
 indi 1
 chki 0 1073741823
 stri 0 13
i11170
 loda 0 6
 chka 1 1073741823
 indi 2
 ordi
 ujp l1412
l1414
 loda 0 6
 ldoa 40
 equa
 fjp l1415
 ldcc 'r'
i11180
 chkc 0 255
 strc 0 12
 ujp l1416
l1415
 loda 0 6
 ldoa 38
 equa
 fjp l1417
 ldcc 'b'
 chkc 0 255
 strc 0 12
i11190
 ujp l1418
l1417
 loda 0 6
 ldoa 39
 equa
 fjp l1419
 ldcc 'c'
 chkc 0 255
 strc 0 12
 ujp l1420
l1419
 ldcc 'i'
i11200
 chkc 0 255
 strc 0 12
l1420
l1418
l1416
 ujp l1413
l1421
 lodi 0 11
 ordi
 ldc( 8 9 10 11)
 inn
 fjp l1422
 mst 4
 ldci 131
i11210
 cup 1 l20
l1422
 ldcc 'a'
 chkc 0 255
 strc 0 12
 ujp l1413
l1423
 lodi 0 11
 ordi
 ldc( 8 11)
 inn
 fjp l1424
i11220
 mst 4
 ldci 132
 cup 1 l20
l1424
 ldcc 's'
 chkc 0 255
 strc 0 12
 ujp l1413
l1425
 mst 3
 loda 0 6
 cup 1 l385
i11230
 not
 fjp l1426
 mst 4
 ldci 134
 cup 1 l20
l1426
 ldcc 'm'
 chkc 0 255
 strc 0 12
 ujp l1413
l1427
 mst 4
i11240
 ldci 134
 cup 1 l20
 ldcc 'm'
 chkc 0 255
 strc 0 12
 ujp l1413
l1428
 mst 4
 ldci 133
 cup 1 l20
 ldcc 'f'
i11250
 chkc 0 255
 strc 0 12
 ujp l1413
l1412
 chki 0 6
 ldci 0
 sbi
 xjp l1429
l1429
 ujp l1414
 ujc
 ujp l1421
i11260
 ujp l1423
 ujp l1425
 ujp l1427
 ujp l1428
l1413
 lodi 0 11
 ordi
 ujp l1430
l1432
 mst 2
 ldci 53
 chki 0 63
i11270
 lodc 0 12
 ordc
 lodi 0 13
 cup 3 l745
 ujp l1431
l1433
 mst 2
 ldci 52
 chki 0 63
 lodc 0 12
 ordc
i11280
 lodi 0 13
 cup 3 l745
 ujp l1431
l1434
 mst 2
 ldci 49
 chki 0 63
 lodc 0 12
 ordc
 lodi 0 13
 cup 3 l745
i11290
 ujp l1431
l1435
 mst 2
 ldci 48
 chki 0 63
 lodc 0 12
 ordc
 lodi 0 13
 cup 3 l745
 ujp l1431
l1436
 mst 2
i11300
 ldci 55
 chki 0 63
 lodc 0 12
 ordc
 lodi 0 13
 cup 3 l745
 ujp l1431
l1437
 mst 2
 ldci 47
 chki 0 63
i11310
 lodc 0 12
 ordc
 lodi 0 13
 cup 3 l745
 ujp l1431
l1430
 chki 8 13
 ldci 8
 sbi
 xjp l1438
l1438
 ujp l1432
i11320
 ujp l1433
 ujp l1435
 ujp l1434
 ujp l1436
 ujp l1437
l1431
 ujp l1439
l1411
 mst 4
 ldci 129
 cup 1 l20
l1439
l1406
l1400
 ldoa 38
i11330
 chka 0 1073741823
 sroa 181
 ldci 2
 chki 0 2
 sroi 182
l1391
 retp
l1389=14
l1390=42
l1440
 ent 1 l1441
 ent 2 l1442
 mst 1
 lods 1 5
i11340
 ldc( 17)
 uni
 loda 0 5
 cup 2 l899
 ldoi 9
 ldci 17
 equi
 fjp l1443
 ldoa 181
 ldcn
i11350
 neqa
 fjp l1444
 ldoi 183
 ldci 0
 neqi
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 3
 grti
i11360
 ior
 fjp l1445
 mst 2
 cup 0 l848
l1445
l1444
 lda 0 6
 lao 181
 mov 5
 mst 4
 cup 0 l25
 mst 1
i11370
 lods 1 5
 cup 1 l898
 ldoa 181
 ldcn
 neqa
 fjp l1446
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 3
i11380
 leqi
 fjp l1447
 mst 2
 cup 0 l804
 ujp l1448
l1447
 mst 2
 cup 0 l848
l1448
l1446
 loda 0 6
 ldcn
 neqa
i11390
 ldoa 181
 ldcn
 neqa
 and
 fjp l1449
 mst 3
 ldoa 40
 loda 0 6
 cup 2 l356
 ldoa 181
i11400
 ldoa 41
 equa
 and
 fjp l1450
 mst 2
 ldci 10
 chki 0 63
 cup 1 l728
 ldoa 40
 chka 0 1073741823
i11410
 sroa 181
l1450
 mst 3
 loda 0 6
 ldoa 181
 cup 2 l356
 fjp l1451
 loda 0 6
 chka 1 1073741823
 indi 2
 ordi
i11420
 ujp l1452
l1454
 ldob 34
 fjp l1455
 mst 2
 loda 0 6
 cup 1 l885
l1455
 mst 2
 lda 0 6
 cup 1 l834
 ujp l1453
l1456
i11430
 ldob 34
 fjp l1457
 mst 2
 ldci 45
 chki 0 63
 ldci 0
 ldci 1073741823
 ldoa 37
 cup 4 l800
l1457
 mst 2
i11440
 lda 0 6
 cup 1 l834
 ujp l1453
l1458
 mst 2
 lda 0 6
 cup 1 l834
 ujp l1453
l1459
 mst 2
 ldci 40
 chki 0 63
i11450
 loda 0 6
 chka 1 1073741823
 indi 1
 cup 2 l732
 ujp l1453
l1460
 mst 4
 ldci 146
 cup 1 l20
 ujp l1453
l1452
 chki 0 6
i11460
 ldci 0
 sbi
 xjp l1461
l1461
 ujp l1454
 ujp l1454
 ujp l1456
 ujp l1458
 ujp l1459
 ujp l1459
 ujp l1460
l1453
i11470
 ujp l1462
l1451
 mst 4
 ldci 129
 cup 1 l20
l1462
l1449
 ujp l1463
l1443
 mst 4
 ldci 51
 cup 1 l20
l1463
 retp
l1441=11
l1442=24
l1464
 ent 1 l1465
i11480
 ent 2 l1466
 ldoi 9
 ldci 1
 equi
 fjp l1467
 ldcb 0
 chkb 0 1
 strb 0 6
 ldoi 53
 chki 0 20
i11490
 stri 0 8
l1468
 lao 55
 lodi 0 8
 chki 0 20
 ixa 5
 indi 2
 ldci 0
 neqi
 fjp l1469
 lodi 0 8
i11500
 ldci 1
 sbi
 chki 0 20
 stri 0 8
 ujp l1468
l1469
 lodi 0 8
 chki 0 20
 stri 0 7
l1470
 lao 55
 lodi 0 8
i11510
 chki 0 20
 ixa 5
 inda 1
 chka 0 1073741823
 stra 0 5
l1471
 loda 0 5
 ldcn
 neqa
 lodb 0 6
 not
i11520
 and
 fjp l1472
 loda 0 5
 chka 1 1073741823
 stra 0 9
 loda 0 9
 indi 3
 ldoi 12
 equi
 fjp l1473
i11530
 ldcb 1
 chkb 0 1
 strb 0 6
 lodi 0 8
 lodi 0 7
 equi
 fjp l1474
 mst 2
 ldci 57
 chki 0 63
i11540
 loda 0 9
 indi 2
 cup 2 l877
 ujp l1475
l1474
 mst 4
 ldci 399
 cup 1 l20
l1475
 ujp l1476
l1473
 loda 0 9
 inda 0
i11550
 chka 0 1073741823
 stra 0 5
l1476
 ujp l1471
l1472
 lodi 0 8
 ldci 1
 sbi
 chki 0 20
 stri 0 8
 lodb 0 6
 lodi 0 8
i11560
 ldci 0
 equi
 ior
 fjp l1470
 lodb 0 6
 not
 fjp l1477
 mst 4
 ldci 167
 cup 1 l20
l1477
i11570
 mst 4
 cup 0 l25
 ujp l1478
l1467
 mst 4
 ldci 15
 cup 1 l20
l1478
 retp
l1465=10
l1466=11
l1479
 ent 1 l1480
 ent 2 l1481
l1482
l1483
 mst 2
i11580
 lods 1 5
 ldc( 13 39)
 uni
 cup 1 l896
 ldoi 9
 ordi
 ldos 187
 inn
 not
 fjp l1483
i11590
 ldoi 9
 ldci 13
 neqi
 chkb 0 1
 strb 3 9
 lodb 3 9
 not
 fjp l1484
 mst 4
 cup 0 l25
l1484
i11600
 lodb 3 9
 fjp l1482
 ldoi 9
 ldci 39
 equi
 fjp l1485
 mst 4
 cup 0 l25
 ujp l1486
l1485
 mst 4
i11610
 ldci 13
 cup 1 l20
l1486
 retp
l1480=5
l1481=8
l1487
 ent 1 l1488
 ent 2 l1489
 mst 1
 lods 1 5
 ldc( 46)
 uni
 cup 1 l898
i11620
 mst 4
 lda 0 6
 cup 1 l308
 mst 2
 lodi 0 6
 cup 1 l871
 ldoi 9
 ldci 46
 equi
 fjp l1490
i11630
 mst 4
 cup 0 l25
 ujp l1491
l1490
 mst 4
 ldci 52
 cup 1 l20
l1491
 mst 2
 lods 1 5
 ldc( 40)
 uni
i11640
 cup 1 l896
 ldoi 9
 ldci 40
 equi
 fjp l1492
 mst 4
 lda 0 5
 cup 1 l308
 mst 2
 ldci 57
i11650
 chki 0 63
 lodi 0 5
 cup 2 l877
 mst 2
 lodi 0 6
 cup 1 l892
 mst 4
 cup 0 l25
 mst 2
 lods 1 5
i11660
 cup 1 l896
 mst 2
 lodi 0 5
 cup 1 l892
 ujp l1493
l1492
 mst 2
 lodi 0 6
 cup 1 l892
l1493
 retp
l1488=7
l1489=17
l1494
 ent 1 l1496
i11670
 ent 2 l1497
 mst 1
 lods 1 5
 ldc( 12 16 42)
 uni
 cup 1 l898
 mst 2
 cup 0 l804
 mst 4
 lda 0 16
i11680
 cup 1 l308
 ldoa 181
 chka 0 1073741823
 stra 0 6
 loda 0 6
 ldcn
 neqa
 fjp l1498
 loda 0 6
 chka 1 1073741823
i11690
 indi 2
 ldci 0
 neqi
 loda 0 6
 ldoa 40
 equa
 ior
 fjp l1499
 mst 4
 ldci 144
i11700
 cup 1 l20
 ldcn
 chka 0 1073741823
 stra 0 6
 ujp l1500
l1499
 mst 3
 loda 0 6
 ldoa 41
 cup 2 l356
 not
i11710
 fjp l1501
 mst 2
 ldci 58
 chki 0 63
 loda 0 6
 cup 2 l792
l1501
l1500
l1498
 mst 2
 ldci 57
 chki 0 63
 lodi 0 16
i11720
 cup 2 l877
 ldoi 9
 ldci 42
 equi
 fjp l1502
 mst 4
 cup 0 l25
 ujp l1503
l1502
 mst 4
 ldci 8
i11730
 cup 1 l20
l1503
 ldcn
 chka 0 1073741823
 stra 0 10
 mst 4
 lda 0 17
 cup 1 l308
l1504
 ldcn
 chka 0 1073741823
 stra 0 7
i11740
 mst 4
 lda 0 15
 cup 1 l308
 ldoi 9
 ordi
 ldc( 13 39)
 inn
 not
 fjp l1505
l1506
 mst 3
i11750
 lods 1 5
 ldc( 12 16)
 uni
 lda 0 5
 lda 0 11
 cup 3 l319
 loda 0 6
 ldcn
 neqa
 fjp l1507
i11760
 mst 3
 loda 0 6
 loda 0 5
 cup 2 l356
 fjp l1508
 loda 0 10
 chka 0 1073741823
 stra 0 9
 ldcn
 chka 0 1073741823
i11770
 stra 0 8
l1509
 loda 0 9
 ldcn
 neqa
 fjp l1510
 loda 0 9
 chka 1 1073741823
 stra 0 18
 loda 0 18
 indi 2
i11780
 lodi 0 12
 leqi
 fjp l1511
 loda 0 18
 indi 2
 lodi 0 12
 equi
 fjp l1512
 mst 4
 ldci 156
i11790
 cup 1 l20
l1512
 ujp l1495
l1511
 loda 0 9
 chka 0 1073741823
 stra 0 8
 loda 0 18
 inda 0
 chka 0 1073741823
 stra 0 9
 ujp l1509
l1510
l1495
i11800
 lda 0 7
 ldci 3
 csp new
 loda 0 7
 chka 1 1073741823
 stra 0 18
 loda 0 18
 loda 0 9
 chka 0 1073741823
 stoa
i11810
 loda 0 18
 inca 2
 lodi 0 12
 stoi
 loda 0 18
 inca 1
 lodi 0 15
 stoi
 loda 0 8
 ldcn
i11820
 equa
 fjp l1513
 loda 0 7
 chka 0 1073741823
 stra 0 10
 ujp l1514
l1513
 loda 0 8
 chka 1 1073741823
 loda 0 7
 chka 0 1073741823
i11830
 stoa
l1514
 ujp l1515
l1508
 mst 4
 ldci 147
 cup 1 l20
l1515
l1507
 ldoi 9
 ldci 12
 neqi
 chkb 0 1
 strb 3 9
i11840
 lodb 3 9
 not
 fjp l1516
 mst 4
 cup 0 l25
l1516
 lodb 3 9
 fjp l1506
 ldoi 9
 ldci 16
 equi
i11850
 fjp l1517
 mst 4
 cup 0 l25
 ujp l1518
l1517
 mst 4
 ldci 5
 cup 1 l20
l1518
 mst 2
 lodi 0 15
 cup 1 l892
l1519
i11860
 mst 2
 lods 1 5
 ldc( 13)
 uni
 cup 1 l896
 ldoi 9
 ordi
 ldos 187
 inn
 not
i11870
 fjp l1519
 loda 0 7
 ldcn
 neqa
 fjp l1520
 mst 2
 ldci 57
 chki 0 63
 lodi 0 17
 cup 2 l877
l1520
l1505
i11880
 ldoi 9
 ldci 13
 neqi
 chkb 0 1
 strb 3 9
 lodb 3 9
 not
 fjp l1521
 mst 4
 cup 0 l25
l1521
i11890
 lodb 3 9
 fjp l1504
 mst 2
 lodi 0 16
 cup 1 l892
 loda 0 10
 ldcn
 neqa
 fjp l1522
 loda 0 10
i11900
 chka 1 1073741823
 indi 2
 stri 0 13
 loda 0 10
 chka 0 1073741823
 stra 0 9
 ldcn
 chka 0 1073741823
 stra 0 10
l1523
 loda 0 9
i11910
 chka 1 1073741823
 inda 0
 chka 0 1073741823
 stra 0 8
 loda 0 9
 chka 1 1073741823
 loda 0 10
 chka 0 1073741823
 stoa
 loda 0 9
i11920
 chka 0 1073741823
 stra 0 10
 loda 0 8
 chka 0 1073741823
 stra 0 9
 loda 0 9
 ldcn
 equa
 fjp l1523
 loda 0 10
i11930
 chka 1 1073741823
 indi 2
 stri 0 14
 lodi 0 13
 lodi 0 14
 sbi
 ldci 1000
 lesi
 fjp l1524
 mst 2
i11940
 ldci 45
 chki 0 63
 lodi 0 14
 lodi 0 13
 ldoa 41
 cup 4 l800
 mst 2
 ldci 51
 chki 0 63
 ldci 1
i11950
 lodi 0 14
 cup 3 l745
 mst 2
 ldci 21
 chki 0 63
 cup 1 l728
 mst 4
 lda 0 16
 cup 1 l308
 mst 2
i11960
 ldci 44
 chki 0 63
 lodi 0 16
 cup 2 l877
 mst 2
 lodi 0 16
 cup 1 l892
l1525
 loda 0 10
 chka 1 1073741823
 stra 0 18
l1526
i11970
 loda 0 18
 indi 2
 lodi 0 14
 grti
 fjp l1527
 mst 2
 ldci 60
 chki 0 63
 cup 1 l728
 lodi 0 14
i11980
 ldci 1
 adi
 stri 0 14
 ujp l1526
l1527
 mst 2
 ldci 57
 chki 0 63
 loda 0 18
 indi 1
 cup 2 l877
i11990
 loda 0 18
 inda 0
 chka 0 1073741823
 stra 0 10
 lodi 0 14
 ldci 1
 adi
 stri 0 14
 loda 0 10
 ldcn
i12000
 equa
 fjp l1525
 mst 2
 lodi 0 17
 cup 1 l892
 ujp l1528
l1524
 mst 4
 ldci 157
 cup 1 l20
l1528
l1522
 ldoi 9
i12010
 ldci 39
 equi
 fjp l1529
 mst 4
 cup 0 l25
 ujp l1530
l1529
 mst 4
 ldci 13
 cup 1 l20
l1530
 retp
l1496=19
l1497=47
l1531
i12020
 ent 1 l1532
 ent 2 l1533
 mst 4
 lda 0 5
 cup 1 l308
 mst 2
 lodi 0 5
 cup 1 l892
l1534
 mst 2
 lods 1 5
i12030
 ldc( 13 41)
 uni
 cup 1 l896
 ldoi 9
 ordi
 ldos 187
 inn
 fjp l1535
 mst 4
 ldci 14
i12040
 cup 1 l20
l1535
 ldoi 9
 ordi
 ldos 187
 inn
 not
 fjp l1534
l1536
 ldoi 9
 ldci 13
 equi
i12050
 fjp l1537
 mst 4
 cup 0 l25
l1538
 mst 2
 lods 1 5
 ldc( 13 41)
 uni
 cup 1 l896
 ldoi 9
 ordi
i12060
 ldos 187
 inn
 fjp l1539
 mst 4
 ldci 14
 cup 1 l20
l1539
 ldoi 9
 ordi
 ldos 187
 inn
i12070
 not
 fjp l1538
 ujp l1536
l1537
 ldoi 9
 ldci 41
 equi
 fjp l1540
 mst 4
 cup 0 l25
 mst 1
i12080
 lods 1 5
 cup 1 l898
 mst 2
 lodi 0 5
 cup 1 l871
 ujp l1541
l1540
 mst 4
 ldci 53
 cup 1 l20
l1541
 retp
l1532=6
l1533=14
l1542
i12090
 ent 1 l1543
 ent 2 l1544
 mst 4
 lda 0 6
 cup 1 l308
 mst 2
 lodi 0 6
 cup 1 l892
 mst 1
 lods 1 5
i12100
 ldc( 43)
 uni
 cup 1 l898
 mst 4
 lda 0 5
 cup 1 l308
 mst 2
 lodi 0 5
 cup 1 l871
 ldoi 9
i12110
 ldci 43
 equi
 fjp l1545
 mst 4
 cup 0 l25
 ujp l1546
l1545
 mst 4
 ldci 54
 cup 1 l20
l1546
 mst 2
i12120
 lods 1 5
 cup 1 l896
 mst 2
 ldci 57
 chki 0 63
 lodi 0 6
 cup 2 l877
 mst 2
 lodi 0 5
 cup 1 l892
i12130
 retp
l1543=7
l1544=15
l1547
 ent 1 l1548
 ent 2 l1549
 ldoi 27
 chki 0 1073741823
 stri 0 13
 ldcn
 chka 0 1073741823
 stra 0 5
 ldci 1
i12140
 chki 0 2
 stri 0 6
 ldci 0
 chki 0 2
 stri 0 7
 ldoi 52
 chki 0 10
 stri 0 8
 ldci 0
 chki 0 1073741823
i12150
 stri 0 9
 ldoi 9
 ldci 0
 equi
 fjp l1550
 mst 4
 ldc( 2)
 lda 1 6
 cup 2 l157
 loda 1 6
i12160
 chka 1 1073741823
 stra 0 14
 loda 0 14
 inda 10
 chka 0 1073741823
 stra 0 5
 ldci 1
 chki 0 2
 stri 0 6
 loda 0 14
i12170
 indi 13
 ldci 0
 equi
 fjp l1551
 ldci 0
 chki 0 2
 stri 0 7
 loda 0 14
 indi 14
 chki 0 10
i12180
 stri 0 8
 loda 0 14
 indi 15
 chki 0 1073741823
 stri 0 9
 ujp l1552
l1551
 mst 4
 ldci 155
 cup 1 l20
 ldcn
i12190
 chka 0 1073741823
 stra 0 5
l1552
 loda 0 5
 ldcn
 neqa
 fjp l1553
 loda 0 5
 chka 1 1073741823
 indi 2
 ldci 1
i12200
 grti
 mst 3
 ldoa 40
 loda 0 5
 cup 2 l356
 ior
 fjp l1554
 mst 4
 ldci 143
 cup 1 l20
i12210
 ldcn
 chka 0 1073741823
 stra 0 5
l1554
l1553
 mst 4
 cup 0 l25
 ujp l1555
l1550
 mst 4
 ldci 2
 cup 1 l20
 mst 3
i12220
 lods 1 5
 ldc( 17 43 44 45)
 uni
 cup 1 l312
l1555
 ldoi 9
 ldci 17
 equi
 fjp l1556
 mst 4
 cup 0 l25
i12230
 mst 1
 lods 1 5
 ldc( 43 44 45)
 uni
 cup 1 l898
 ldoa 181
 ldcn
 neqa
 fjp l1557
 ldoa 181
i12240
 chka 1 1073741823
 indi 2
 ldci 0
 neqi
 fjp l1558
 mst 4
 ldci 144
 cup 1 l20
 ujp l1559
l1558
 mst 3
i12250
 loda 0 5
 ldoa 181
 cup 2 l356
 fjp l1560
 mst 2
 cup 0 l804
 mst 2
 lda 0 5
 cup 1 l834
 ujp l1561
l1560
i12260
 mst 4
 ldci 145
 cup 1 l20
l1561
l1559
l1557
 ujp l1562
l1556
 mst 4
 ldci 51
 cup 1 l20
 mst 3
 lods 1 5
 ldc( 43 44 45)
i12270
 uni
 cup 1 l312
l1562
 ldoi 9
 ordi
 ldc( 44 45)
 inn
 fjp l1563
 ldoi 9
 chki 0 47
 stri 0 10
i12280
 mst 4
 cup 0 l25
 mst 1
 lods 1 5
 ldc( 43)
 uni
 cup 1 l898
 ldoa 181
 ldcn
 neqa
i12290
 fjp l1564
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 0
 neqi
 fjp l1565
 mst 4
 ldci 144
 cup 1 l20
i12300
 ujp l1566
l1565
 mst 3
 loda 0 5
 ldoa 181
 cup 2 l356
 fjp l1567
 mst 2
 cup 0 l804
 mst 3
 loda 0 5
i12310
 ldoa 41
 cup 2 l356
 not
 fjp l1568
 mst 2
 ldci 58
 chki 0 63
 ldoa 181
 cup 2 l792
l1568
 mst 4
i12320
 ldoa 41
 lao 27
 cup 2 l217
 mst 2
 ldci 56
 chki 0 63
 ldci 0
 ldoi 27
 ldoa 41
 cup 4 l800
i12330
 mst 4
 lda 0 11
 cup 1 l308
 mst 2
 lodi 0 11
 cup 1 l892
 lao 181
 lda 0 5
 mov 5
 mst 2
i12340
 cup 0 l804
 mst 3
 ldoa 181
 ldoa 41
 cup 2 l356
 not
 fjp l1569
 mst 2
 ldci 58
 chki 0 63
i12350
 ldoa 181
 cup 2 l792
l1569
 mst 2
 ldci 54
 chki 0 63
 ldci 0
 ldoi 27
 ldoa 41
 cup 4 l800
 ldoi 27
i12360
 ldci 1
 adi
 chki 0 1073741823
 sroi 27
 ldoi 27
 lodi 2 87
 grti
 fjp l1570
 ldoi 27
 chki 0 1073741823
i12370
 stri 2 87
l1570
 lodi 0 10
 ldci 44
 equi
 fjp l1571
 mst 2
 ldci 52
 chki 0 63
 ldcc 'i'
 ordc
i12380
 ldci 1
 cup 3 l745
 ujp l1572
l1571
 mst 2
 ldci 48
 chki 0 63
 ldcc 'i'
 ordc
 ldci 1
 cup 3 l745
l1572
i12390
 ujp l1573
l1567
 mst 4
 ldci 145
 cup 1 l20
l1573
l1566
l1564
 ujp l1574
l1563
 mst 4
 ldci 55
 cup 1 l20
 mst 3
 lods 1 5
i12400
 ldc( 43)
 uni
 cup 1 l312
l1574
 mst 4
 lda 0 12
 cup 1 l308
 mst 2
 ldci 33
 chki 0 63
 lodi 0 12
i12410
 cup 2 l877
 ldoi 9
 ldci 43
 equi
 fjp l1575
 mst 4
 cup 0 l25
 ujp l1576
l1575
 mst 4
 ldci 54
i12420
 cup 1 l20
l1576
 mst 2
 lods 1 5
 cup 1 l896
 lao 181
 lda 0 5
 mov 5
 mst 2
 cup 0 l804
 lodi 0 10
i12430
 ldci 44
 equi
 fjp l1577
 mst 2
 ldci 34
 chki 0 63
 ldci 1
 ldoa 181
 cup 3 l796
 ujp l1578
l1577
i12440
 mst 2
 ldci 31
 chki 0 63
 ldci 1
 ldoa 181
 cup 3 l796
l1578
 mst 2
 lda 0 5
 cup 1 l834
 mst 2
i12450
 ldci 57
 chki 0 63
 lodi 0 11
 cup 2 l877
 mst 2
 lodi 0 12
 cup 1 l892
 lodi 0 13
 chki 0 1073741823
 sroi 27
i12460
 retp
l1548=15
l1549=65
l1579
 ent 1 l1580
 ent 2 l1581
 ldci 0
 chki 0 20
 stri 0 6
 ldoi 27
 chki 0 1073741823
 stri 0 7
l1582
 ldoi 9
i12470
 ldci 0
 equi
 fjp l1583
 mst 4
 ldc( 2 3)
 lda 0 5
 cup 2 l157
 mst 4
 cup 0 l25
 ujp l1584
l1583
i12480
 mst 4
 ldci 2
 cup 1 l20
 ldoa 47
 chka 0 1073741823
 stra 0 5
l1584
 mst 1
 lods 1 5
 ldc( 12 43)
 uni
i12490
 loda 0 5
 cup 2 l899
 ldoa 181
 ldcn
 neqa
 fjp l1585
 ldoa 181
 chka 1 1073741823
 indi 2
 ldci 5
i12500
 equi
 fjp l1586
 ldoi 53
 ldci 20
 lesi
 fjp l1587
 ldoi 53
 ldci 1
 adi
 chki 0 20
i12510
 sroi 53
 lodi 0 6
 ldci 1
 adi
 chki 0 20
 stri 0 6
 lao 55
 ldoi 53
 chki 0 20
 ixa 5
i12520
 stra 0 8
 loda 0 8
 ldoa 181
 chka 1 1073741823
 inda 3
 chka 0 1073741823
 stoa
 loda 0 8
 inca 1
 ldcn
i12530
 chka 0 1073741823
 stoa
 ldoi 183
 ldci 0
 equi
 fjp l1588
 lao 55
 ldoi 53
 chki 0 20
 ixa 5
i12540
 stra 0 8
 loda 0 8
 inca 2
 ldci 1
 chki 0 3
 stoi
 loda 0 8
 inca 3
 ldoi 184
 chki 0 10
i12550
 stoi
 loda 0 8
 inca 4
 ldoi 185
 chki 0 1073741823
 stoi
 ujp l1589
l1588
 mst 2
 cup 0 l848
 mst 4
i12560
 ldoa 37
 lao 27
 cup 2 l217
 mst 2
 ldci 56
 chki 0 63
 ldci 0
 ldoi 27
 ldoa 37
 cup 4 l800
i12570
 lao 55
 ldoi 53
 chki 0 20
 ixa 5
 stra 0 8
 loda 0 8
 inca 2
 ldci 2
 chki 0 3
 stoi
i12580
 loda 0 8
 inca 3
 ldoi 27
 chki 0 1073741823
 stoi
 ldoi 27
 ldci 1
 adi
 chki 0 1073741823
 sroi 27
i12590
 ldoi 27
 lodi 2 87
 grti
 fjp l1590
 ldoi 27
 chki 0 1073741823
 stri 2 87
l1590
l1589
 ujp l1591
l1587
 mst 4
 ldci 250
i12600
 cup 1 l20
l1591
 ujp l1592
l1586
 mst 4
 ldci 140
 cup 1 l20
l1592
l1585
 ldoi 9
 ldci 12
 neqi
 chkb 0 1
 strb 3 9
i12610
 lodb 3 9
 not
 fjp l1593
 mst 4
 cup 0 l25
l1593
 lodb 3 9
 fjp l1582
 ldoi 9
 ldci 43
 equi
i12620
 fjp l1594
 mst 4
 cup 0 l25
 ujp l1595
l1594
 mst 4
 ldci 54
 cup 1 l20
l1595
 mst 2
 lods 1 5
 cup 1 l896
i12630
 ldoi 53
 lodi 0 6
 sbi
 chki 0 20
 sroi 53
 lodi 0 7
 chki 0 1073741823
 sroi 27
 retp
l1580=9
l1581=22
l896
 ent 1 l1596
i12640
 ent 2 l1597
 ldoi 9
 ldci 1
 equi
 fjp l1598
 lao 55
 ldoi 52
 chki 0 20
 ixa 5
 inda 1
i12650
 chka 0 1073741823
 stra 0 7
l1599
 loda 0 7
 ldcn
 neqa
 fjp l1600
 loda 0 7
 chka 1 1073741823
 stra 0 8
 loda 0 8
i12660
 indi 3
 ldoi 12
 equi
 fjp l1601
 loda 0 8
 indb 1
 fjp l1602
 mst 3
 ldci 165
 cup 1 l20
l1602
i12670
 mst 1
 loda 0 8
 indi 2
 cup 1 l892
 loda 0 8
 inca 1
 ldcb 1
 chkb 0 1
 stob
 ujp l897
i12680
 ujp l1603
l1601
 loda 0 8
 inda 0
 chka 0 1073741823
 stra 0 7
l1603
 ujp l1599
l1600
 mst 3
 ldci 167
 cup 1 l20
l897
 mst 3
i12690
 cup 0 l25
 ldoi 9
 ldci 16
 equi
 fjp l1604
 mst 3
 cup 0 l25
 ujp l1605
l1604
 mst 3
 ldci 5
i12700
 cup 1 l20
l1605
l1598
 ldoi 9
 ordi
 lods 0 5
 ldc( 0)
 uni
 inn
 not
 fjp l1606
 mst 3
i12710
 ldci 6
 cup 1 l20
 mst 2
 lods 0 5
 cup 1 l312
l1606
 ldoi 9
 ordi
 ldos 187
 ldc( 0)
 uni
i12720
 inn
 fjp l1607
 ldoi 9
 ordi
 ujp l1608
l1610
 mst 3
 ldc( 2 3 4 5)
 lda 0 6
 cup 2 l157
 mst 3
i12730
 cup 0 l25
 loda 0 6
 chka 1 1073741823
 indi 12
 ldci 4
 equi
 fjp l1611
 mst 0
 lods 0 5
 loda 0 6
i12740
 cup 2 l964
 ujp l1612
l1611
 mst 0
 loda 0 6
 cup 1 l1440
l1612
 ujp l1609
l1613
 mst 3
 cup 0 l25
 mst 0
 cup 0 l1479
i12750
 ujp l1609
l1614
 mst 3
 cup 0 l25
 mst 0
 cup 0 l1464
 ujp l1609
l1615
 mst 3
 cup 0 l25
 mst 0
 cup 0 l1487
i12760
 ujp l1609
l1616
 mst 3
 cup 0 l25
 mst 0
 cup 0 l1494
 ujp l1609
l1617
 mst 3
 cup 0 l25
 mst 0
 cup 0 l1542
i12770
 ujp l1609
l1618
 mst 3
 cup 0 l25
 mst 0
 cup 0 l1531
 ujp l1609
l1619
 mst 3
 cup 0 l25
 mst 0
 cup 0 l1547
i12780
 ujp l1609
l1620
 mst 3
 cup 0 l25
 mst 0
 cup 0 l1579
 ujp l1609
l1608
 chki 0 38
 ldci 0
 sbi
 xjp l1621
l1621
i12790
 ujp l1610
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
i12800
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
i12810
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
 ujc
i12820
 ujc
 ujp l1613
 ujp l1615
 ujp l1616
 ujp l1618
 ujp l1617
 ujp l1619
 ujp l1620
 ujp l1614
l1609
 ldoi 9
i12830
 ordi
 ldc( 13 39 40 41)
 inn
 not
 fjp l1622
 mst 3
 ldci 6
 cup 1 l20
 mst 2
 lods 0 5
i12840
 cup 1 l312
l1622
l1607
 retp
l1596=9
l1597=18
l719
 ent 1 l1623
 ent 2 l1624
 loda 1 7
 ldcn
 neqa
 fjp l1625
 loda 1 7
 chka 1 1073741823
i12850
 indi 15
 stri 0 82
 ujp l1626
l1625
 mst 2
 lda 0 82
 cup 1 l308
l1626
 ldci 0
 chki 0 65
 stri 0 80
 ldci 5
i12860
 stri 0 84
 ldci 5
 stri 0 83
 mst 0
 lodi 0 82
 cup 1 l892
 mst 2
 lda 0 81
 cup 1 l308
 mst 2
i12870
 lda 0 85
 cup 1 l308
 mst 0
 ldci 32
 chki 0 63
 ldci 1
 lodi 0 81
 cup 3 l881
 mst 0
 ldci 32
i12880
 chki 0 63
 ldci 2
 lodi 0 85
 cup 3 l881
 loda 1 7
 ldcn
 neqa
 fjp l1627
 ldci 5
 chki 0 1073741823
i12890
 stri 0 86
 loda 1 7
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 88
l1628
 loda 0 88
 ldcn
 neqa
 fjp l1629
i12900
 loda 0 88
 chka 1 1073741823
 stra 0 90
 mst 2
 ldoa 42
 lda 0 86
 cup 2 l217
 loda 0 90
 indi 12
 ldci 2
i12910
 equi
 fjp l1630
 loda 0 90
 inda 10
 ldcn
 neqa
 fjp l1631
 loda 0 90
 inda 10
 chka 1 1073741823
i12920
 indi 2
 ldci 3
 grti
 fjp l1632
 loda 0 90
 indi 13
 ldci 0
 equi
 fjp l1633
 mst 0
i12930
 ldci 50
 chki 0 63
 ldci 0
 loda 0 90
 indi 15
 cup 3 l745
 mst 0
 ldci 54
 chki 0 63
 ldci 0
i12940
 lodi 0 86
 ldoa 37
 cup 4 l800
 mst 0
 ldci 40
 chki 0 63
 loda 0 90
 inda 10
 chka 1 1073741823
 indi 1
i12950
 cup 2 l732
l1633
 lodi 0 86
 ldci 1
 adi
 chki 0 1073741823
 stri 0 86
 ujp l1634
l1632
 lodi 0 86
 loda 0 90
 inda 10
i12960
 chka 1 1073741823
 indi 1
 adi
 chki 0 1073741823
 stri 0 86
l1634
l1631
l1630
 loda 0 88
 chka 1 1073741823
 inda 11
 chka 0 1073741823
 stra 0 88
i12970
 ujp l1628
l1629
l1627
 ldoi 27
 chki 0 1073741823
 stri 0 87
l1635
l1636
 mst 0
 lods 0 5
 ldc( 13 39)
 uni
 cup 1 l896
 ldoi 9
i12980
 ordi
 ldos 187
 inn
 not
 fjp l1636
 ldoi 9
 ldci 13
 neqi
 chkb 0 1
 strb 1 9
i12990
 lodb 1 9
 not
 fjp l1637
 mst 2
 cup 0 l25
l1637
 lodb 1 9
 fjp l1635
 ldoi 9
 ldci 39
 equi
i13000
 fjp l1638
 mst 2
 cup 0 l25
 ujp l1639
l1638
 mst 2
 ldci 13
 cup 1 l20
l1639
 lao 55
 ldoi 53
 chki 0 20
i13010
 ixa 5
 inda 1
 chka 0 1073741823
 stra 0 89
l1640
 loda 0 89
 ldcn
 neqa
 fjp l1641
 loda 0 89
 chka 1 1073741823
i13020
 stra 0 90
 loda 0 90
 indb 1
 not
 fjp l1642
 mst 2
 ldci 168
 cup 1 l20
 lda 2 6
 csp wln
i13030
 lca' label '
 ldci 7
 ldci 7
 lda 2 6
 csp wrs
 loda 0 90
 indi 3
 ldci 10
 lda 2 6
 csp wri
i13040
 lda 2 6
 csp wln
 ldcc ' '
 ldoi 25
 ldci 16
 adi
 lda 2 6
 csp wrc
l1642
 loda 0 90
 inda 0
i13050
 chka 0 1073741823
 stra 0 89
 ujp l1640
l1641
 loda 1 7
 ldcn
 neqa
 fjp l1643
 loda 1 7
 chka 1 1073741823
 inda 10
i13060
 ldcn
 equa
 fjp l1644
 mst 0
 ldci 42
 chki 0 63
 ldcc 'p'
 ordc
 cup 2 l732
 ujp l1645
l1644
i13070
 mst 0
 ldci 42
 chki 0 63
 loda 1 7
 chka 1 1073741823
 inda 10
 cup 2 l792
l1645
 mst 2
 ldoa 42
 lda 0 87
i13080
 cup 2 l217
 ldob 30
 fjp l1646
 ldcc 'l'
 ldci 1
 lda 2 8
 csp wrc
 lodi 0 81
 ldci 1
 lda 2 8
i13090
 csp wri
 ldcc '='
 ldci 1
 lda 2 8
 csp wrc
 lodi 0 87
 ldci 1
 lda 2 8
 csp wri
 lda 2 8
i13100
 csp wln
 ldcc 'l'
 ldci 1
 lda 2 8
 csp wrc
 lodi 0 85
 ldci 1
 lda 2 8
 csp wri
 ldcc '='
i13110
 ldci 1
 lda 2 8
 csp wrc
 lodi 0 83
 ldci 1
 lda 2 8
 csp wri
 lda 2 8
 csp wln
l1646
 ujp l1647
l1643
i13120
 mst 0
 ldci 42
 chki 0 63
 ldcc 'p'
 ordc
 cup 2 l732
 mst 2
 ldoa 42
 lda 0 87
 cup 2 l217
i13130
 ldob 30
 fjp l1648
 ldcc 'l'
 ldci 1
 lda 2 8
 csp wrc
 lodi 0 81
 ldci 1
 lda 2 8
 csp wri
i13140
 ldcc '='
 ldci 1
 lda 2 8
 csp wrc
 lodi 0 87
 ldci 1
 lda 2 8
 csp wri
 lda 2 8
 csp wln
i13150
 ldcc 'l'
 ldci 1
 lda 2 8
 csp wrc
 lodi 0 85
 ldci 1
 lda 2 8
 csp wri
 ldcc '='
 ldci 1
i13160
 lda 2 8
 csp wrc
 lodi 0 83
 ldci 1
 lda 2 8
 csp wri
 lda 2 8
 csp wln
 ldcc 'q'
 ldci 1
i13170
 lda 2 8
 csp wrc
 lda 2 8
 csp wln
l1648
 ldci 0
 chki 0 1073741823
 sroi 26
 mst 0
 ldci 41
 chki 0 63
i13180
 ldci 0
 cup 2 l732
 mst 0
 ldci 46
 chki 0 63
 ldci 0
 lodi 0 82
 cup 3 l881
 mst 0
 ldci 29
i13190
 chki 0 63
 cup 1 l728
 ldob 30
 fjp l1649
 ldcc 'q'
 ldci 1
 lda 2 8
 csp wrc
 lda 2 8
 csp wln
l1649
i13200
 lda 0 7
 lao 14
 mov 8
l1650
 ldoa 50
 ldcn
 neqa
 fjp l1651
 ldoa 50
 chka 1 1073741823
 stra 0 90
i13210
 loda 0 90
 lca'input   '
 equm 8
 loda 0 90
 lca'output  '
 equm 8
 ior
 loda 0 90
 lca'prd     '
 equm 8
i13220
 ior
 loda 0 90
 lca'prr     '
 equm 8
 ior
 not
 fjp l1652
 lao 14
 loda 0 90
 mov 8
i13230
 mst 2
 ldc( 2)
 lda 0 6
 cup 2 l157
 loda 0 6
 chka 1 1073741823
 inda 10
 ldcn
 neqa
 fjp l1653
i13240
 loda 0 6
 chka 1 1073741823
 inda 10
 chka 1 1073741823
 indi 2
 ldci 6
 neqi
 fjp l1654
 lda 2 6
 csp wln
i13250
 ldcc ' '
 ldci 8
 lda 2 6
 csp wrc
 lca'undeclared '
 ldci 11
 ldci 11
 lda 2 6
 csp wrs
 lca'external '
i13260
 ldci 9
 ldci 9
 lda 2 6
 csp wrs
 lca'file'
 ldci 4
 ldci 4
 lda 2 6
 csp wrs
 ldoa 50
i13270
 chka 1 1073741823
 ldci 8
 ldci 8
 lda 2 6
 csp wrs
 lda 2 6
 csp wln
 ldcc ' '
 ldoi 25
 ldci 16
i13280
 adi
 lda 2 6
 csp wrc
l1654
l1653
l1652
 ldoa 50
 chka 1 1073741823
 inda 8
 chka 0 1073741823
 sroa 50
 ujp l1650
l1651
 lao 14
i13290
 lda 0 7
 mov 8
 ldob 29
 fjp l1655
 lda 2 6
 csp wln
 mst 2
 ldcb 1
 chkb 0 1
 cup 1 l220
l1655
l1647
i13300
 retp
l1623=91
l1624=51
l311
 ent 1 l1656
 ent 2 l1657
 ldcb 1
 chkb 0 1
 srob 33
l1658
 ldoi 9
 ldci 18
 equi
 fjp l1659
i13310
 mst 1
 cup 0 l25
 mst 0
 cup 0 l542
l1659
 ldoi 9
 ldci 19
 equi
 fjp l1660
 mst 1
 cup 0 l25
i13320
 mst 0
 cup 0 l557
l1660
 ldoi 9
 ldci 20
 equi
 fjp l1661
 mst 1
 cup 0 l25
 mst 0
 cup 0 l568
l1661
i13330
 ldoi 9
 ldci 21
 equi
 fjp l1662
 mst 1
 cup 0 l25
 mst 0
 cup 0 l588
l1662
l1663
 ldoi 9
 ordi
i13340
 ldc( 22 24)
 inn
 fjp l1664
 ldoi 9
 chki 0 47
 stri 0 8
 mst 1
 cup 0 l25
 mst 0
 lodi 0 8
i13350
 chki 0 47
 cup 1 l607
 ujp l1663
l1664
 ldoi 9
 ldci 31
 neqi
 fjp l1665
 mst 1
 ldci 18
 cup 1 l20
i13360
 mst 0
 lods 0 5
 cup 1 l312
l1665
 ldoi 9
 ordi
 ldos 187
 inn
 lao 5
 eof
 ior
i13370
 fjp l1658
 ldcb 0
 chkb 0 1
 srob 33
 ldoi 9
 ldci 31
 equi
 fjp l1666
 mst 1
 cup 0 l25
i13380
 ujp l1667
l1666
 mst 1
 ldci 17
 cup 1 l20
l1667
l1668
 mst 0
 lods 0 5
 ldc( 33)
 uni
 cup 1 l719
 ldoi 9
i13390
 lodi 0 6
 neqi
 fjp l1669
 mst 1
 ldci 6
 cup 1 l20
 mst 0
 lods 0 5
 cup 1 l312
l1669
 ldoi 9
i13400
 lodi 0 6
 equi
 ldoi 9
 ordi
 ldos 190
 inn
 ior
 lao 5
 eof
 ior
i13410
 fjp l1668
 retp
l1656=10
l1657=15
l1670
 ent 1 l1671
 ent 2 l1672
 ldoi 9
 ldci 23
 equi
 fjp l1673
 mst 1
 cup 0 l25
i13420
 ldoi 9
 ldci 0
 neqi
 fjp l1674
 mst 1
 ldci 2
 cup 1 l20
l1674
 mst 1
 cup 0 l25
 ldoi 9
i13430
 ordi
 ldc( 8 13)
 inn
 not
 fjp l1675
 mst 1
 ldci 14
 cup 1 l20
l1675
 ldoi 9
 ldci 8
i13440
 equi
 fjp l1676
l1677
 mst 1
 cup 0 l25
 ldoi 9
 ldci 0
 equi
 fjp l1678
 lda 0 6
 ldci 9
i13450
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 7
 loda 0 7
 lao 14
 mov 8
 loda 0 7
 inca 8
 ldoa 50
i13460
 chka 0 1073741823
 stoa
 loda 0 6
 chka 0 1073741823
 sroa 50
 mst 1
 cup 0 l25
 ldoi 9
 ordi
 ldc( 9 12)
i13470
 inn
 not
 fjp l1679
 mst 1
 ldci 20
 cup 1 l20
l1679
 ujp l1680
l1678
 mst 1
 ldci 2
 cup 1 l20
l1680
i13480
 ldoi 9
 ldci 12
 neqi
 fjp l1677
 ldoi 9
 ldci 9
 neqi
 fjp l1681
 mst 1
 ldci 4
i13490
 cup 1 l20
l1681
 mst 1
 cup 0 l25
l1676
 ldoi 9
 ldci 13
 neqi
 fjp l1682
 mst 1
 ldci 14
 cup 1 l20
i13500
 ujp l1683
l1682
 mst 1
 cup 0 l25
l1683
l1673
l1684
 mst 1
 lods 0 5
 ldci 14
 chki 0 47
 ldcn
 cup 3 l311
 ldoi 9
i13510
 ldci 14
 neqi
 fjp l1685
 mst 1
 ldci 21
 cup 1 l20
l1685
 ldoi 9
 ldci 14
 equi
 lao 5
i13520
 eof
 ior
 fjp l1684
 ldob 31
 fjp l1686
 lda 1 6
 csp wln
l1686
 ldoi 160
 ldci 0
 neqi
i13530
 fjp l1687
 ldcb 0
 chkb 0 1
 srob 31
 mst 1
 cup 0 l3
l1687
 retp
l1671=8
l1672=17
l1688
 ent 1 l1689
 ent 2 l1690
 lao 1321
i13540
 ldci 1
 chki 1 35
 deci 1
 ixa 8
 lca'false   '
 mov 8
 lao 1321
 ldci 2
 chki 1 35
 deci 1
i13550
 ixa 8
 lca'true    '
 mov 8
 lao 1321
 ldci 3
 chki 1 35
 deci 1
 ixa 8
 lca'input   '
 mov 8
i13560
 lao 1321
 ldci 4
 chki 1 35
 deci 1
 ixa 8
 lca'output  '
 mov 8
 lao 1321
 ldci 5
 chki 1 35
i13570
 deci 1
 ixa 8
 lca'get     '
 mov 8
 lao 1321
 ldci 6
 chki 1 35
 deci 1
 ixa 8
 lca'put     '
i13580
 mov 8
 lao 1321
 ldci 7
 chki 1 35
 deci 1
 ixa 8
 lca'reset   '
 mov 8
 lao 1321
 ldci 8
i13590
 chki 1 35
 deci 1
 ixa 8
 lca'rewrite '
 mov 8
 lao 1321
 ldci 9
 chki 1 35
 deci 1
 ixa 8
i13600
 lca'read    '
 mov 8
 lao 1321
 ldci 10
 chki 1 35
 deci 1
 ixa 8
 lca'write   '
 mov 8
 lao 1321
i13610
 ldci 11
 chki 1 35
 deci 1
 ixa 8
 lca'pack    '
 mov 8
 lao 1321
 ldci 12
 chki 1 35
 deci 1
i13620
 ixa 8
 lca'unpack  '
 mov 8
 lao 1321
 ldci 13
 chki 1 35
 deci 1
 ixa 8
 lca'new     '
 mov 8
i13630
 lao 1321
 ldci 14
 chki 1 35
 deci 1
 ixa 8
 lca'release '
 mov 8
 lao 1321
 ldci 15
 chki 1 35
i13640
 deci 1
 ixa 8
 lca'readln  '
 mov 8
 lao 1321
 ldci 16
 chki 1 35
 deci 1
 ixa 8
 lca'writeln '
i13650
 mov 8
 lao 1321
 ldci 17
 chki 1 35
 deci 1
 ixa 8
 lca'abs     '
 mov 8
 lao 1321
 ldci 18
i13660
 chki 1 35
 deci 1
 ixa 8
 lca'sqr     '
 mov 8
 lao 1321
 ldci 19
 chki 1 35
 deci 1
 ixa 8
i13670
 lca'trunc   '
 mov 8
 lao 1321
 ldci 20
 chki 1 35
 deci 1
 ixa 8
 lca'odd     '
 mov 8
 lao 1321
i13680
 ldci 21
 chki 1 35
 deci 1
 ixa 8
 lca'ord     '
 mov 8
 lao 1321
 ldci 22
 chki 1 35
 deci 1
i13690
 ixa 8
 lca'chr     '
 mov 8
 lao 1321
 ldci 23
 chki 1 35
 deci 1
 ixa 8
 lca'pred    '
 mov 8
i13700
 lao 1321
 ldci 24
 chki 1 35
 deci 1
 ixa 8
 lca'succ    '
 mov 8
 lao 1321
 ldci 25
 chki 1 35
i13710
 deci 1
 ixa 8
 lca'eof     '
 mov 8
 lao 1321
 ldci 26
 chki 1 35
 deci 1
 ixa 8
 lca'eoln    '
i13720
 mov 8
 lao 1321
 ldci 27
 chki 1 35
 deci 1
 ixa 8
 lca'sin     '
 mov 8
 lao 1321
 ldci 28
i13730
 chki 1 35
 deci 1
 ixa 8
 lca'cos     '
 mov 8
 lao 1321
 ldci 29
 chki 1 35
 deci 1
 ixa 8
i13740
 lca'exp     '
 mov 8
 lao 1321
 ldci 30
 chki 1 35
 deci 1
 ixa 8
 lca'sqrt    '
 mov 8
 lao 1321
i13750
 ldci 31
 chki 1 35
 deci 1
 ixa 8
 lca'ln      '
 mov 8
 lao 1321
 ldci 32
 chki 1 35
 deci 1
i13760
 ixa 8
 lca'arctan  '
 mov 8
 lao 1321
 ldci 33
 chki 1 35
 deci 1
 ixa 8
 lca'prd     '
 mov 8
i13770
 lao 1321
 ldci 34
 chki 1 35
 deci 1
 ixa 8
 lca'prr     '
 mov 8
 lao 1321
 ldci 35
 chki 1 35
i13780
 deci 1
 ixa 8
 lca'mark    '
 mov 8
 retp
l1689=5
l1690=7
l1691
 ent 1 l1692
 ent 2 l1693
 lao 41
 ldci 4
 csp new
i13790
 ldoa 41
 chka 1 1073741823
 stra 0 5
 loda 0 5
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
 loda 0 5
 inca 2
i13800
 ldci 0
 chki 0 8
 stoi
 loda 0 5
 inca 3
 ldci 0
 chki 0 1
 stoi
 lao 40
 ldci 4
i13810
 csp new
 ldoa 40
 chka 1 1073741823
 stra 0 5
 loda 0 5
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
 loda 0 5
i13820
 inca 2
 ldci 0
 chki 0 8
 stoi
 loda 0 5
 inca 3
 ldci 0
 chki 0 1
 stoi
 lao 39
i13830
 ldci 4
 csp new
 ldoa 39
 chka 1 1073741823
 stra 0 5
 loda 0 5
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
i13840
 loda 0 5
 inca 2
 ldci 0
 chki 0 8
 stoi
 loda 0 5
 inca 3
 ldci 0
 chki 0 1
 stoi
i13850
 lao 38
 ldci 5
 csp new
 ldoa 38
 chka 1 1073741823
 stra 0 5
 loda 0 5
 inca 1
 ldci 1
 chki 0 1073741823
i13860
 stoi
 loda 0 5
 inca 2
 ldci 0
 chki 0 8
 stoi
 loda 0 5
 inca 3
 ldci 1
 chki 0 1
i13870
 stoi
 lao 37
 ldci 4
 csp new
 ldoa 37
 chka 1 1073741823
 stra 0 5
 loda 0 5
 inca 3
 ldcn
i13880
 chka 0 1073741823
 stoa
 loda 0 5
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
 loda 0 5
 inca 2
 ldci 2
i13890
 chki 0 8
 stoi
 lao 42
 ldci 4
 csp new
 ldoa 42
 chka 1 1073741823
 stra 0 5
 loda 0 5
 inca 1
i13900
 ldci 1
 chki 0 1073741823
 stoi
 loda 0 5
 inca 2
 ldci 0
 chki 0 8
 stoi
 loda 0 5
 inca 3
i13910
 ldci 0
 chki 0 1
 stoi
 lao 36
 ldci 4
 csp new
 ldoa 36
 chka 1 1073741823
 stra 0 5
 loda 0 5
i13920
 inca 3
 ldoa 39
 chka 0 1073741823
 stoa
 loda 0 5
 inca 1
 ldci 1
 chki 0 1073741823
 stoi
 loda 0 5
i13930
 inca 2
 ldci 6
 chki 0 8
 stoi
 retp
l1692=6
l1693=7
l1694
 ent 1 l1695
 ent 2 l1696
 lda 0 6
 ldci 13
 csp new
i13940
 loda 0 6
 chka 1 1073741823
 stra 0 8
 loda 0 8
 lca'integer '
 mov 8
 loda 0 8
 inca 10
 ldoa 41
 chka 0 1073741823
i13950
 stoa
 loda 0 8
 inca 12
 ldci 0
 chki 0 5
 stoi
 mst 1
 loda 0 6
 cup 1 l135
 lda 0 6
i13960
 ldci 13
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 8
 loda 0 8
 lca'real    '
 mov 8
 loda 0 8
 inca 10
i13970
 ldoa 40
 chka 0 1073741823
 stoa
 loda 0 8
 inca 12
 ldci 0
 chki 0 5
 stoi
 mst 1
 loda 0 6
i13980
 cup 1 l135
 lda 0 6
 ldci 13
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 8
 loda 0 8
 lca'char    '
 mov 8
i13990
 loda 0 8
 inca 10
 ldoa 39
 chka 0 1073741823
 stoa
 loda 0 8
 inca 12
 ldci 0
 chki 0 5
 stoi
i14000
 mst 1
 loda 0 6
 cup 1 l135
 lda 0 6
 ldci 13
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 8
 loda 0 8
i14010
 lca'boolean '
 mov 8
 loda 0 8
 inca 10
 ldoa 38
 chka 0 1073741823
 stoa
 loda 0 8
 inca 12
 ldci 0
i14020
 chki 0 5
 stoi
 mst 1
 loda 0 6
 cup 1 l135
 ldcn
 chka 0 1073741823
 stra 0 5
 ldci 1
 stri 0 7
i14030
 ldci 2
 stri 0 8
l1697
 lodi 0 7
 lodi 0 8
 leqi
 fjp l1698
 lda 0 6
 ldci 15
 csp new
 loda 0 6
i14040
 chka 1 1073741823
 stra 0 9
 loda 0 9
 lao 1321
 lodi 0 7
 chki 1 35
 deci 1
 ixa 8
 mov 8
 loda 0 9
i14050
 inca 10
 ldoa 38
 chka 0 1073741823
 stoa
 loda 0 9
 inca 11
 loda 0 5
 chka 0 1073741823
 stoa
 loda 0 9
i14060
 inca 14
 lodi 0 7
 ldci 1
 sbi
 stoi
 loda 0 9
 inca 12
 ldci 1
 chki 0 5
 stoi
i14070
 mst 1
 loda 0 6
 cup 1 l135
 loda 0 6
 chka 0 1073741823
 stra 0 5
 lodi 0 7
 inci 1
 stri 0 7
 ujp l1697
l1698
i14080
 ldoa 38
 chka 1 1073741823
 inca 4
 loda 0 6
 chka 0 1073741823
 stoa
 lda 0 6
 ldci 15
 csp new
 loda 0 6
i14090
 chka 1 1073741823
 stra 0 8
 loda 0 8
 lca'nil     '
 mov 8
 loda 0 8
 inca 10
 ldoa 37
 chka 0 1073741823
 stoa
i14100
 loda 0 8
 inca 11
 ldcn
 chka 0 1073741823
 stoa
 loda 0 8
 inca 14
 ldci 0
 stoi
 loda 0 8
i14110
 inca 12
 ldci 1
 chki 0 5
 stoi
 mst 1
 loda 0 6
 cup 1 l135
 ldci 3
 stri 0 7
 ldci 4
i14120
 stri 0 8
l1699
 lodi 0 7
 lodi 0 8
 leqi
 fjp l1700
 lda 0 6
 ldci 16
 csp new
 loda 0 6
 chka 1 1073741823
i14130
 stra 0 9
 loda 0 9
 lao 1321
 lodi 0 7
 chki 1 35
 deci 1
 ixa 8
 mov 8
 loda 0 9
 inca 10
i14140
 ldoa 36
 chka 0 1073741823
 stoa
 loda 0 9
 inca 12
 ldci 2
 chki 0 5
 stoi
 loda 0 9
 inca 13
i14150
 ldci 0
 chki 0 1
 stoi
 loda 0 9
 inca 11
 ldcn
 chka 0 1073741823
 stoa
 loda 0 9
 inca 14
i14160
 ldci 1
 chki 0 10
 stoi
 loda 0 9
 inca 15
 ldci 5
 lodi 0 7
 ldci 3
 sbi
 ldci 1
i14170
 mpi
 adi
 chki 0 1073741823
 stoi
 mst 1
 loda 0 6
 cup 1 l135
 lodi 0 7
 inci 1
 stri 0 7
i14180
 ujp l1699
l1700
 ldci 33
 stri 0 7
 ldci 34
 stri 0 8
l1701
 lodi 0 7
 lodi 0 8
 leqi
 fjp l1702
 lda 0 6
i14190
 ldci 16
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 9
 loda 0 9
 lao 1321
 lodi 0 7
 chki 1 35
 deci 1
i14200
 ixa 8
 mov 8
 loda 0 9
 inca 10
 ldoa 36
 chka 0 1073741823
 stoa
 loda 0 9
 inca 12
 ldci 2
i14210
 chki 0 5
 stoi
 loda 0 9
 inca 13
 ldci 0
 chki 0 1
 stoi
 loda 0 9
 inca 11
 ldcn
i14220
 chka 0 1073741823
 stoa
 loda 0 9
 inca 14
 ldci 1
 chki 0 10
 stoi
 loda 0 9
 inca 15
 ldci 5
i14230
 lodi 0 7
 ldci 31
 sbi
 ldci 1
 mpi
 adi
 chki 0 1073741823
 stoi
 mst 1
 loda 0 6
i14240
 cup 1 l135
 lodi 0 7
 inci 1
 stri 0 7
 ujp l1701
l1702
 ldci 5
 stri 0 7
 ldci 16
 stri 0 8
l1703
 lodi 0 7
i14250
 lodi 0 8
 leqi
 fjp l1704
 lda 0 6
 ldci 15
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 9
 loda 0 9
i14260
 lao 1321
 lodi 0 7
 chki 1 35
 deci 1
 ixa 8
 mov 8
 loda 0 9
 inca 10
 ldcn
 chka 0 1073741823
i14270
 stoa
 loda 0 9
 inca 11
 ldcn
 chka 0 1073741823
 stoa
 loda 0 9
 inca 14
 lodi 0 7
 ldci 4
i14280
 sbi
 chki 1 15
 stoi
 loda 0 9
 inca 12
 ldci 4
 chki 0 5
 stoi
 loda 0 9
 inca 13
i14290
 ldci 0
 chki 0 1
 stoi
 mst 1
 loda 0 6
 cup 1 l135
 lodi 0 7
 inci 1
 stri 0 7
 ujp l1703
l1704
i14300
 lda 0 6
 ldci 15
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 8
 loda 0 8
 lao 1321
 ldci 35
 chki 1 35
i14310
 deci 1
 ixa 8
 mov 8
 loda 0 8
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 8
 inca 11
i14320
 ldcn
 chka 0 1073741823
 stoa
 loda 0 8
 inca 14
 ldci 13
 chki 1 15
 stoi
 loda 0 8
 inca 12
i14330
 ldci 4
 chki 0 5
 stoi
 loda 0 8
 inca 13
 ldci 0
 chki 0 1
 stoi
 mst 1
 loda 0 6
i14340
 cup 1 l135
 ldci 17
 stri 0 7
 ldci 26
 stri 0 8
l1705
 lodi 0 7
 lodi 0 8
 leqi
 fjp l1706
 lda 0 6
i14350
 ldci 15
 csp new
 loda 0 6
 chka 1 1073741823
 stra 0 9
 loda 0 9
 lao 1321
 lodi 0 7
 chki 1 35
 deci 1
i14360
 ixa 8
 mov 8
 loda 0 9
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 9
 inca 11
 ldcn
i14370
 chka 0 1073741823
 stoa
 loda 0 9
 inca 14
 lodi 0 7
 ldci 16
 sbi
 chki 1 15
 stoi
 loda 0 9
i14380
 inca 12
 ldci 5
 chki 0 5
 stoi
 loda 0 9
 inca 13
 ldci 0
 chki 0 1
 stoi
 mst 1
i14390
 loda 0 6
 cup 1 l135
 lodi 0 7
 inci 1
 stri 0 7
 ujp l1705
l1706
 lda 0 6
 ldci 16
 csp new
 loda 0 6
i14400
 chka 1 1073741823
 stra 0 8
 loda 0 8
 lca'        '
 mov 8
 loda 0 8
 inca 10
 ldoa 40
 chka 0 1073741823
 stoa
i14410
 loda 0 8
 inca 12
 ldci 2
 chki 0 5
 stoi
 loda 0 8
 inca 13
 ldci 0
 chki 0 1
 stoi
i14420
 loda 0 8
 inca 11
 ldcn
 chka 0 1073741823
 stoa
 loda 0 8
 inca 14
 ldci 1
 chki 0 10
 stoi
i14430
 loda 0 8
 inca 15
 ldci 0
 chki 0 1073741823
 stoi
 ldci 27
 stri 0 7
 ldci 32
 stri 0 8
l1707
 lodi 0 7
i14440
 lodi 0 8
 leqi
 fjp l1708
 lda 0 5
 ldci 19
 csp new
 loda 0 5
 chka 1 1073741823
 stra 0 9
 loda 0 9
i14450
 lao 1321
 lodi 0 7
 chki 1 35
 deci 1
 ixa 8
 mov 8
 loda 0 9
 inca 10
 ldoa 40
 chka 0 1073741823
i14460
 stoa
 loda 0 9
 inca 11
 loda 0 6
 chka 0 1073741823
 stoa
 loda 0 9
 inca 18
 ldcb 0
 chkb 0 1
i14470
 stob
 loda 0 9
 inca 17
 ldcb 1
 chkb 0 1
 stob
 loda 0 9
 inca 14
 ldci 0
 chki 0 10
i14480
 stoi
 loda 0 9
 inca 15
 lodi 0 7
 ldci 12
 sbi
 stoi
 loda 0 9
 inca 12
 ldci 5
i14490
 chki 0 5
 stoi
 loda 0 9
 inca 13
 ldci 1
 chki 0 1
 stoi
 loda 0 9
 inca 16
 ldci 0
i14500
 chki 0 1
 stoi
 mst 1
 loda 0 5
 cup 1 l135
 lodi 0 7
 inci 1
 stri 0 7
 ujp l1707
l1708
 retp
l1695=10
l1696=19
l1709
i14510
 ent 1 l1710
 ent 2 l1711
 lao 49
 ldci 13
 csp new
 ldoa 49
 chka 1 1073741823
 stra 0 5
 loda 0 5
 lca'        '
i14520
 mov 8
 loda 0 5
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 5
 inca 12
 ldci 0
 chki 0 5
i14530
 stoi
 lao 48
 ldci 15
 csp new
 ldoa 48
 chka 1 1073741823
 stra 0 5
 loda 0 5
 lca'        '
 mov 8
i14540
 loda 0 5
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 5
 inca 11
 ldcn
 chka 0 1073741823
 stoa
i14550
 loda 0 5
 inca 14
 ldci 0
 stoi
 loda 0 5
 inca 12
 ldci 1
 chki 0 5
 stoi
 lao 47
i14560
 ldci 16
 csp new
 ldoa 47
 chka 1 1073741823
 stra 0 5
 loda 0 5
 lca'        '
 mov 8
 loda 0 5
 inca 10
i14570
 ldcn
 chka 0 1073741823
 stoa
 loda 0 5
 inca 13
 ldci 0
 chki 0 1
 stoi
 loda 0 5
 inca 11
i14580
 ldcn
 chka 0 1073741823
 stoa
 loda 0 5
 inca 14
 ldci 0
 chki 0 10
 stoi
 loda 0 5
 inca 15
i14590
 ldci 0
 chki 0 1073741823
 stoi
 loda 0 5
 inca 12
 ldci 2
 chki 0 5
 stoi
 lao 46
 ldci 14
i14600
 csp new
 ldoa 46
 chka 1 1073741823
 stra 0 5
 loda 0 5
 lca'        '
 mov 8
 loda 0 5
 inca 10
 ldcn
i14610
 chka 0 1073741823
 stoa
 loda 0 5
 inca 11
 ldcn
 chka 0 1073741823
 stoa
 loda 0 5
 inca 13
 ldci 0
i14620
 chki 0 1073741823
 stoi
 loda 0 5
 inca 12
 ldci 3
 chki 0 5
 stoi
 lao 45
 ldci 19
 csp new
i14630
 ldoa 45
 chka 1 1073741823
 stra 0 5
 loda 0 5
 lca'        '
 mov 8
 loda 0 5
 inca 10
 ldcn
 chka 0 1073741823
i14640
 stoa
 loda 0 5
 inca 18
 ldcb 0
 chkb 0 1
 stob
 loda 0 5
 inca 11
 ldcn
 chka 0 1073741823
i14650
 stoa
 loda 0 5
 inca 17
 ldcb 0
 chkb 0 1
 stob
 loda 0 5
 inca 14
 ldci 0
 chki 0 10
i14660
 stoi
 mst 1
 loda 0 5
 inca 15
 cup 1 l308
 loda 0 5
 inca 12
 ldci 4
 chki 0 5
 stoi
i14670
 loda 0 5
 inca 13
 ldci 1
 chki 0 1
 stoi
 loda 0 5
 inca 16
 ldci 0
 chki 0 1
 stoi
i14680
 lao 44
 ldci 19
 csp new
 ldoa 44
 chka 1 1073741823
 stra 0 5
 loda 0 5
 lca'        '
 mov 8
 loda 0 5
i14690
 inca 10
 ldcn
 chka 0 1073741823
 stoa
 loda 0 5
 inca 11
 ldcn
 chka 0 1073741823
 stoa
 loda 0 5
i14700
 inca 18
 ldcb 0
 chkb 0 1
 stob
 loda 0 5
 inca 17
 ldcb 0
 chkb 0 1
 stob
 loda 0 5
i14710
 inca 14
 ldci 0
 chki 0 10
 stoi
 mst 1
 loda 0 5
 inca 15
 cup 1 l308
 loda 0 5
 inca 12
i14720
 ldci 5
 chki 0 5
 stoi
 loda 0 5
 inca 13
 ldci 1
 chki 0 1
 stoi
 loda 0 5
 inca 16
i14730
 ldci 0
 chki 0 1
 stoi
 retp
l1710=6
l1711=9
l1712
 ent 1 l1713
 ent 2 l1714
 ldcn
 chka 0 1073741823
 sroa 43
 ldcb 0
i14740
 chkb 0 1
 srob 29
 ldcb 1
 chkb 0 1
 srob 31
 ldcb 1
 chkb 0 1
 srob 30
 ldcb 1
 chkb 0 1
i14750
 srob 34
 ldci 0
 sroi 35
 ldcb 1
 chkb 0 1
 srob 33
 ldcb 1
 chkb 0 1
 srob 32
 ldci 0
i14760
 chki 0 10
 sroi 160
 ldci 0
 sroi 2279
 ldci 8
 chki 1 8
 sroi 22
 ldcn
 chka 0 1073741823
 sroa 50
i14770
 ldci 5
 ldci 4
 ldci 1
 mpi
 adi
 chki 0 1073741823
 sroi 27
 ldci 3
 chki 0 1073741823
 sroi 26
i14780
 ldcb 1
 chkb 0 1
 srob 24
 ldci 0
 sroi 28
 ldcc ' '
 chkc 0 255
 sroc 23
 ldci 0
 sroi 25
i14790
 ldcn
 chka 0 1073741823
 sroa 51
 ldci 1073741823
 ldci 10
 dvi
 sroi 2278
 ldci 128
 ldci 1
 sbi
i14800
 sroi 2277
 retp
l1713=5
l1714=8
l1715
 ent 1 l1716
 ent 2 l1717
 ldc( 0 1 2 3 6)
 sros 193
 ldc( 8)
 ldos 193
 uni
 sros 192
i14810
 ldc( 15 25 26 27 28 29)
 ldos 192
 uni
 sros 191
 ldc( 25 27 28 29)
 sros 186
 ldc( 18 19 20 21 22 24 31)
 sros 190
 ldc( 10 14 15)
 sros 189
i14820
 ldc( 0 1 2 3 4 8 10)
 sros 188
 ldc( 31 32 33 34 35 36 37 38)
 sros 187
 retp
l1716=5
l1717=7
l1719
 ent 1 l1720
 ent 2 l1721
 lao 450
 ldci 1
 chki 1 35
i14830
 deci 1
 ixa 8
 lca'if      '
 mov 8
 lao 450
 ldci 2
 chki 1 35
 deci 1
 ixa 8
 lca'do      '
i14840
 mov 8
 lao 450
 ldci 3
 chki 1 35
 deci 1
 ixa 8
 lca'of      '
 mov 8
 lao 450
 ldci 4
i14850
 chki 1 35
 deci 1
 ixa 8
 lca'to      '
 mov 8
 lao 450
 ldci 5
 chki 1 35
 deci 1
 ixa 8
i14860
 lca'in      '
 mov 8
 lao 450
 ldci 6
 chki 1 35
 deci 1
 ixa 8
 lca'or      '
 mov 8
 lao 450
i14870
 ldci 7
 chki 1 35
 deci 1
 ixa 8
 lca'end     '
 mov 8
 lao 450
 ldci 8
 chki 1 35
 deci 1
i14880
 ixa 8
 lca'for     '
 mov 8
 lao 450
 ldci 9
 chki 1 35
 deci 1
 ixa 8
 lca'var     '
 mov 8
i14890
 lao 450
 ldci 10
 chki 1 35
 deci 1
 ixa 8
 lca'div     '
 mov 8
 lao 450
 ldci 11
 chki 1 35
i14900
 deci 1
 ixa 8
 lca'mod     '
 mov 8
 lao 450
 ldci 12
 chki 1 35
 deci 1
 ixa 8
 lca'set     '
i14910
 mov 8
 lao 450
 ldci 13
 chki 1 35
 deci 1
 ixa 8
 lca'and     '
 mov 8
 lao 450
 ldci 14
i14920
 chki 1 35
 deci 1
 ixa 8
 lca'not     '
 mov 8
 lao 450
 ldci 15
 chki 1 35
 deci 1
 ixa 8
i14930
 lca'then    '
 mov 8
 lao 450
 ldci 16
 chki 1 35
 deci 1
 ixa 8
 lca'else    '
 mov 8
 lao 450
i14940
 ldci 17
 chki 1 35
 deci 1
 ixa 8
 lca'with    '
 mov 8
 lao 450
 ldci 18
 chki 1 35
 deci 1
i14950
 ixa 8
 lca'goto    '
 mov 8
 lao 450
 ldci 19
 chki 1 35
 deci 1
 ixa 8
 lca'case    '
 mov 8
i14960
 lao 450
 ldci 20
 chki 1 35
 deci 1
 ixa 8
 lca'type    '
 mov 8
 lao 450
 ldci 21
 chki 1 35
i14970
 deci 1
 ixa 8
 lca'file    '
 mov 8
 lao 450
 ldci 22
 chki 1 35
 deci 1
 ixa 8
 lca'begin   '
i14980
 mov 8
 lao 450
 ldci 23
 chki 1 35
 deci 1
 ixa 8
 lca'until   '
 mov 8
 lao 450
 ldci 24
i14990
 chki 1 35
 deci 1
 ixa 8
 lca'while   '
 mov 8
 lao 450
 ldci 25
 chki 1 35
 deci 1
 ixa 8
i15000
 lca'array   '
 mov 8
 lao 450
 ldci 26
 chki 1 35
 deci 1
 ixa 8
 lca'const   '
 mov 8
 lao 450
i15010
 ldci 27
 chki 1 35
 deci 1
 ixa 8
 lca'label   '
 mov 8
 lao 450
 ldci 28
 chki 1 35
 deci 1
i15020
 ixa 8
 lca'repeat  '
 mov 8
 lao 450
 ldci 29
 chki 1 35
 deci 1
 ixa 8
 lca'record  '
 mov 8
i15030
 lao 450
 ldci 30
 chki 1 35
 deci 1
 ixa 8
 lca'downto  '
 mov 8
 lao 450
 ldci 31
 chki 1 35
i15040
 deci 1
 ixa 8
 lca'packed  '
 mov 8
 lao 450
 ldci 32
 chki 1 35
 deci 1
 ixa 8
 lca'forward '
i15050
 mov 8
 lao 450
 ldci 33
 chki 1 35
 deci 1
 ixa 8
 lca'program '
 mov 8
 lao 450
 ldci 34
i15060
 chki 1 35
 deci 1
 ixa 8
 lca'function'
 mov 8
 lao 450
 ldci 35
 chki 1 35
 deci 1
 ixa 8
i15070
 lca'procedur'
 mov 8
 lao 730
 ldci 1
 chki 1 9
 deci 1
 ixa 1
 ldci 1
 chki 1 36
 stoi
i15080
 lao 730
 ldci 2
 chki 1 9
 deci 1
 ixa 1
 ldci 1
 chki 1 36
 stoi
 lao 730
 ldci 3
i15090
 chki 1 9
 deci 1
 ixa 1
 ldci 7
 chki 1 36
 stoi
 lao 730
 ldci 4
 chki 1 9
 deci 1
i15100
 ixa 1
 ldci 15
 chki 1 36
 stoi
 lao 730
 ldci 5
 chki 1 9
 deci 1
 ixa 1
 ldci 22
i15110
 chki 1 36
 stoi
 lao 730
 ldci 6
 chki 1 9
 deci 1
 ixa 1
 ldci 28
 chki 1 36
 stoi
i15120
 lao 730
 ldci 7
 chki 1 9
 deci 1
 ixa 1
 ldci 32
 chki 1 36
 stoi
 lao 730
 ldci 8
i15130
 chki 1 9
 deci 1
 ixa 1
 ldci 34
 chki 1 36
 stoi
 lao 730
 ldci 9
 chki 1 9
 deci 1
i15140
 ixa 1
 ldci 36
 chki 1 36
 stoi
 retp
l1720=5
l1721=7
l1722
 ent 1 l1723
 ent 2 l1724
 lao 739
 ldci 1
 chki 1 35
i15150
 deci 1
 ixa 1
 ldci 32
 chki 0 47
 stoi
 lao 739
 ldci 2
 chki 1 35
 deci 1
 ixa 1
i15160
 ldci 43
 chki 0 47
 stoi
 lao 739
 ldci 3
 chki 1 35
 deci 1
 ixa 1
 ldci 42
 chki 0 47
i15170
 stoi
 lao 739
 ldci 4
 chki 1 35
 deci 1
 ixa 1
 ldci 44
 chki 0 47
 stoi
 lao 739
i15180
 ldci 5
 chki 1 35
 deci 1
 ixa 1
 ldci 7
 chki 0 47
 stoi
 lao 739
 ldci 6
 chki 1 35
i15190
 deci 1
 ixa 1
 ldci 6
 chki 0 47
 stoi
 lao 739
 ldci 7
 chki 1 35
 deci 1
 ixa 1
i15200
 ldci 39
 chki 0 47
 stoi
 lao 739
 ldci 8
 chki 1 35
 deci 1
 ixa 1
 ldci 36
 chki 0 47
i15210
 stoi
 lao 739
 ldci 9
 chki 1 35
 deci 1
 ixa 1
 ldci 21
 chki 0 47
 stoi
 lao 739
i15220
 ldci 10
 chki 1 35
 deci 1
 ixa 1
 ldci 5
 chki 0 47
 stoi
 lao 739
 ldci 11
 chki 1 35
i15230
 deci 1
 ixa 1
 ldci 5
 chki 0 47
 stoi
 lao 739
 ldci 12
 chki 1 35
 deci 1
 ixa 1
i15240
 ldci 25
 chki 0 47
 stoi
 lao 739
 ldci 13
 chki 1 35
 deci 1
 ixa 1
 ldci 5
 chki 0 47
i15250
 stoi
 lao 739
 ldci 14
 chki 1 35
 deci 1
 ixa 1
 ldci 4
 chki 0 47
 stoi
 lao 739
i15260
 ldci 15
 chki 1 35
 deci 1
 ixa 1
 ldci 46
 chki 0 47
 stoi
 lao 739
 ldci 16
 chki 1 35
i15270
 deci 1
 ixa 1
 ldci 40
 chki 0 47
 stoi
 lao 739
 ldci 17
 chki 1 35
 deci 1
 ixa 1
i15280
 ldci 37
 chki 0 47
 stoi
 lao 739
 ldci 18
 chki 1 35
 deci 1
 ixa 1
 ldci 38
 chki 0 47
i15290
 stoi
 lao 739
 ldci 19
 chki 1 35
 deci 1
 ixa 1
 ldci 33
 chki 0 47
 stoi
 lao 739
i15300
 ldci 20
 chki 1 35
 deci 1
 ixa 1
 ldci 20
 chki 0 47
 stoi
 lao 739
 ldci 21
 chki 1 35
i15310
 deci 1
 ixa 1
 ldci 29
 chki 0 47
 stoi
 lao 739
 ldci 22
 chki 1 35
 deci 1
 ixa 1
i15320
 ldci 31
 chki 0 47
 stoi
 lao 739
 ldci 23
 chki 1 35
 deci 1
 ixa 1
 ldci 41
 chki 0 47
i15330
 stoi
 lao 739
 ldci 24
 chki 1 35
 deci 1
 ixa 1
 ldci 35
 chki 0 47
 stoi
 lao 739
i15340
 ldci 25
 chki 1 35
 deci 1
 ixa 1
 ldci 27
 chki 0 47
 stoi
 lao 739
 ldci 26
 chki 1 35
i15350
 deci 1
 ixa 1
 ldci 19
 chki 0 47
 stoi
 lao 739
 ldci 27
 chki 1 35
 deci 1
 ixa 1
i15360
 ldci 18
 chki 0 47
 stoi
 lao 739
 ldci 28
 chki 1 35
 deci 1
 ixa 1
 ldci 34
 chki 0 47
i15370
 stoi
 lao 739
 ldci 29
 chki 1 35
 deci 1
 ixa 1
 ldci 28
 chki 0 47
 stoi
 lao 739
i15380
 ldci 30
 chki 1 35
 deci 1
 ixa 1
 ldci 45
 chki 0 47
 stoi
 lao 739
 ldci 31
 chki 1 35
i15390
 deci 1
 ixa 1
 ldci 26
 chki 0 47
 stoi
 lao 739
 ldci 32
 chki 1 35
 deci 1
 ixa 1
i15400
 ldci 30
 chki 0 47
 stoi
 lao 739
 ldci 33
 chki 1 35
 deci 1
 ixa 1
 ldci 23
 chki 0 47
i15410
 stoi
 lao 739
 ldci 34
 chki 1 35
 deci 1
 ixa 1
 ldci 22
 chki 0 47
 stoi
 lao 739
i15420
 ldci 35
 chki 1 35
 deci 1
 ixa 1
 ldci 24
 chki 0 47
 stoi
 lao 774
 ldcc '+'
 ordc
i15430
 chki 0 255
 ixa 1
 ldci 6
 chki 0 47
 stoi
 lao 774
 ldcc '-'
 ordc
 chki 0 255
 ixa 1
i15440
 ldci 6
 chki 0 47
 stoi
 lao 774
 ldcc '*'
 ordc
 chki 0 255
 ixa 1
 ldci 5
 chki 0 47
i15450
 stoi
 lao 774
 ldcc '/'
 ordc
 chki 0 255
 ixa 1
 ldci 5
 chki 0 47
 stoi
 lao 774
i15460
 ldcc '('
 ordc
 chki 0 255
 ixa 1
 ldci 8
 chki 0 47
 stoi
 lao 774
 ldcc ')'
 ordc
i15470
 chki 0 255
 ixa 1
 ldci 9
 chki 0 47
 stoi
 lao 774
 ldcc '$'
 ordc
 chki 0 255
 ixa 1
i15480
 ldci 47
 chki 0 47
 stoi
 lao 774
 ldcc '='
 ordc
 chki 0 255
 ixa 1
 ldci 7
 chki 0 47
i15490
 stoi
 lao 774
 ldcc ' '
 ordc
 chki 0 255
 ixa 1
 ldci 47
 chki 0 47
 stoi
 lao 774
i15500
 ldcc ','
 ordc
 chki 0 255
 ixa 1
 ldci 12
 chki 0 47
 stoi
 lao 774
 ldcc '.'
 ordc
i15510
 chki 0 255
 ixa 1
 ldci 14
 chki 0 47
 stoi
 lao 774
 ldcc '''
 ordc
 chki 0 255
 ixa 1
i15520
 ldci 47
 chki 0 47
 stoi
 lao 774
 ldcc '['
 ordc
 chki 0 255
 ixa 1
 ldci 10
 chki 0 47
i15530
 stoi
 lao 774
 ldcc ']'
 ordc
 chki 0 255
 ixa 1
 ldci 11
 chki 0 47
 stoi
 lao 774
i15540
 ldcc ':'
 ordc
 chki 0 255
 ixa 1
 ldci 16
 chki 0 47
 stoi
 lao 774
 ldcc '^'
 ordc
i15550
 chki 0 255
 ixa 1
 ldci 15
 chki 0 47
 stoi
 lao 774
 ldcc '<'
 ordc
 chki 0 255
 ixa 1
i15560
 ldci 7
 chki 0 47
 stoi
 lao 774
 ldcc '>'
 ordc
 chki 0 255
 ixa 1
 ldci 7
 chki 0 47
i15570
 stoi
 lao 774
 ldcc ';'
 ordc
 chki 0 255
 ixa 1
 ldci 13
 chki 0 47
 stoi
 retp
l1723=5
l1724=7
l1725
i15580
 ent 1 l1726
 ent 2 l1727
 ldci 1
 stri 0 5
 ldci 35
 stri 0 6
l1728
 lodi 0 5
 lodi 0 6
 leqi
 fjp l1729
i15590
 lao 1030
 lodi 0 5
 chki 1 35
 deci 1
 ixa 1
 ldci 15
 chki 0 15
 stoi
 lodi 0 5
 inci 1
i15600
 stri 0 5
 ujp l1728
l1729
 lao 1030
 ldci 5
 chki 1 35
 deci 1
 ixa 1
 ldci 14
 chki 0 15
 stoi
i15610
 lao 1030
 ldci 10
 chki 1 35
 deci 1
 ixa 1
 ldci 3
 chki 0 15
 stoi
 lao 1030
 ldci 11
i15620
 chki 1 35
 deci 1
 ixa 1
 ldci 4
 chki 0 15
 stoi
 lao 1030
 ldci 6
 chki 1 35
 deci 1
i15630
 ixa 1
 ldci 7
 chki 0 15
 stoi
 lao 1030
 ldci 13
 chki 1 35
 deci 1
 ixa 1
 ldci 2
i15640
 chki 0 15
 stoi
 ldci 0
 stri 0 5
 ldci 255
 stri 0 6
l1730
 lodi 0 5
 lodi 0 6
 leqi
 fjp l1731
i15650
 lao 1065
 lodi 0 5
 chr
 ordc
 chki 0 255
 ixa 1
 ldci 15
 chki 0 15
 stoi
 lodi 0 5
i15660
 inci 1
 stri 0 5
 ujp l1730
l1731
 lao 1065
 ldcc '+'
 ordc
 chki 0 255
 ixa 1
 ldci 5
 chki 0 15
i15670
 stoi
 lao 1065
 ldcc '-'
 ordc
 chki 0 255
 ixa 1
 ldci 6
 chki 0 15
 stoi
 lao 1065
i15680
 ldcc '*'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 15
 stoi
 lao 1065
 ldcc '/'
 ordc
i15690
 chki 0 255
 ixa 1
 ldci 1
 chki 0 15
 stoi
 lao 1065
 ldcc '='
 ordc
 chki 0 255
 ixa 1
i15700
 ldci 13
 chki 0 15
 stoi
 lao 1065
 ldcc '<'
 ordc
 chki 0 255
 ixa 1
 ldci 8
 chki 0 15
i15710
 stoi
 lao 1065
 ldcc '>'
 ordc
 chki 0 255
 ixa 1
 ldci 11
 chki 0 15
 stoi
 retp
l1726=7
l1727=7
l1732
i15720
 ent 1 l1733
 ent 2 l1734
 lao 1845
 ldci 1
 chki 1 23
 deci 1
 ixa 4
 lca' get'
 mov 4
 lao 1845
i15730
 ldci 2
 chki 1 23
 deci 1
 ixa 4
 lca' put'
 mov 4
 lao 1845
 ldci 3
 chki 1 23
 deci 1
i15740
 ixa 4
 lca' rdi'
 mov 4
 lao 1845
 ldci 4
 chki 1 23
 deci 1
 ixa 4
 lca' rdr'
 mov 4
i15750
 lao 1845
 ldci 5
 chki 1 23
 deci 1
 ixa 4
 lca' rdc'
 mov 4
 lao 1845
 ldci 6
 chki 1 23
i15760
 deci 1
 ixa 4
 lca' wri'
 mov 4
 lao 1845
 ldci 7
 chki 1 23
 deci 1
 ixa 4
 lca' wro'
i15770
 mov 4
 lao 1845
 ldci 8
 chki 1 23
 deci 1
 ixa 4
 lca' wrr'
 mov 4
 lao 1845
 ldci 9
i15780
 chki 1 23
 deci 1
 ixa 4
 lca' wrc'
 mov 4
 lao 1845
 ldci 10
 chki 1 23
 deci 1
 ixa 4
i15790
 lca' wrs'
 mov 4
 lao 1845
 ldci 11
 chki 1 23
 deci 1
 ixa 4
 lca' pak'
 mov 4
 lao 1845
i15800
 ldci 12
 chki 1 23
 deci 1
 ixa 4
 lca' new'
 mov 4
 lao 1845
 ldci 13
 chki 1 23
 deci 1
i15810
 ixa 4
 lca' rst'
 mov 4
 lao 1845
 ldci 14
 chki 1 23
 deci 1
 ixa 4
 lca' eln'
 mov 4
i15820
 lao 1845
 ldci 15
 chki 1 23
 deci 1
 ixa 4
 lca' sin'
 mov 4
 lao 1845
 ldci 16
 chki 1 23
i15830
 deci 1
 ixa 4
 lca' cos'
 mov 4
 lao 1845
 ldci 17
 chki 1 23
 deci 1
 ixa 4
 lca' exp'
i15840
 mov 4
 lao 1845
 ldci 18
 chki 1 23
 deci 1
 ixa 4
 lca' sqt'
 mov 4
 lao 1845
 ldci 19
i15850
 chki 1 23
 deci 1
 ixa 4
 lca' log'
 mov 4
 lao 1845
 ldci 20
 chki 1 23
 deci 1
 ixa 4
i15860
 lca' atn'
 mov 4
 lao 1845
 ldci 21
 chki 1 23
 deci 1
 ixa 4
 lca' rln'
 mov 4
 lao 1845
i15870
 ldci 22
 chki 1 23
 deci 1
 ixa 4
 lca' wln'
 mov 4
 lao 1845
 ldci 23
 chki 1 23
 deci 1
i15880
 ixa 4
 lca' sav'
 mov 4
 retp
l1733=5
l1734=7
l1735
 ent 1 l1736
 ent 2 l1737
 lao 1601
 ldci 0
 chki 0 60
 ixa 4
i15890
 lca' abi'
 mov 4
 lao 1601
 ldci 1
 chki 0 60
 ixa 4
 lca' abr'
 mov 4
 lao 1601
 ldci 2
i15900
 chki 0 60
 ixa 4
 lca' adi'
 mov 4
 lao 1601
 ldci 3
 chki 0 60
 ixa 4
 lca' adr'
 mov 4
i15910
 lao 1601
 ldci 4
 chki 0 60
 ixa 4
 lca' and'
 mov 4
 lao 1601
 ldci 5
 chki 0 60
 ixa 4
i15920
 lca' dif'
 mov 4
 lao 1601
 ldci 6
 chki 0 60
 ixa 4
 lca' dvi'
 mov 4
 lao 1601
 ldci 7
i15930
 chki 0 60
 ixa 4
 lca' dvr'
 mov 4
 lao 1601
 ldci 8
 chki 0 60
 ixa 4
 lca' eof'
 mov 4
i15940
 lao 1601
 ldci 9
 chki 0 60
 ixa 4
 lca' flo'
 mov 4
 lao 1601
 ldci 10
 chki 0 60
 ixa 4
i15950
 lca' flt'
 mov 4
 lao 1601
 ldci 11
 chki 0 60
 ixa 4
 lca' inn'
 mov 4
 lao 1601
 ldci 12
i15960
 chki 0 60
 ixa 4
 lca' int'
 mov 4
 lao 1601
 ldci 13
 chki 0 60
 ixa 4
 lca' ior'
 mov 4
i15970
 lao 1601
 ldci 14
 chki 0 60
 ixa 4
 lca' mod'
 mov 4
 lao 1601
 ldci 15
 chki 0 60
 ixa 4
i15980
 lca' mpi'
 mov 4
 lao 1601
 ldci 16
 chki 0 60
 ixa 4
 lca' mpr'
 mov 4
 lao 1601
 ldci 17
i15990
 chki 0 60
 ixa 4
 lca' ngi'
 mov 4
 lao 1601
 ldci 18
 chki 0 60
 ixa 4
 lca' ngr'
 mov 4
i16000
 lao 1601
 ldci 19
 chki 0 60
 ixa 4
 lca' not'
 mov 4
 lao 1601
 ldci 20
 chki 0 60
 ixa 4
i16010
 lca' odd'
 mov 4
 lao 1601
 ldci 21
 chki 0 60
 ixa 4
 lca' sbi'
 mov 4
 lao 1601
 ldci 22
i16020
 chki 0 60
 ixa 4
 lca' sbr'
 mov 4
 lao 1601
 ldci 23
 chki 0 60
 ixa 4
 lca' sgs'
 mov 4
i16030
 lao 1601
 ldci 24
 chki 0 60
 ixa 4
 lca' sqi'
 mov 4
 lao 1601
 ldci 25
 chki 0 60
 ixa 4
i16040
 lca' sqr'
 mov 4
 lao 1601
 ldci 26
 chki 0 60
 ixa 4
 lca' sto'
 mov 4
 lao 1601
 ldci 27
i16050
 chki 0 60
 ixa 4
 lca' trc'
 mov 4
 lao 1601
 ldci 28
 chki 0 60
 ixa 4
 lca' uni'
 mov 4
i16060
 lao 1601
 ldci 29
 chki 0 60
 ixa 4
 lca' stp'
 mov 4
 lao 1601
 ldci 30
 chki 0 60
 ixa 4
i16070
 lca' csp'
 mov 4
 lao 1601
 ldci 31
 chki 0 60
 ixa 4
 lca' dec'
 mov 4
 lao 1601
 ldci 32
i16080
 chki 0 60
 ixa 4
 lca' ent'
 mov 4
 lao 1601
 ldci 33
 chki 0 60
 ixa 4
 lca' fjp'
 mov 4
i16090
 lao 1601
 ldci 34
 chki 0 60
 ixa 4
 lca' inc'
 mov 4
 lao 1601
 ldci 35
 chki 0 60
 ixa 4
i16100
 lca' ind'
 mov 4
 lao 1601
 ldci 36
 chki 0 60
 ixa 4
 lca' ixa'
 mov 4
 lao 1601
 ldci 37
i16110
 chki 0 60
 ixa 4
 lca' lao'
 mov 4
 lao 1601
 ldci 38
 chki 0 60
 ixa 4
 lca' lca'
 mov 4
i16120
 lao 1601
 ldci 39
 chki 0 60
 ixa 4
 lca' ldo'
 mov 4
 lao 1601
 ldci 40
 chki 0 60
 ixa 4
i16130
 lca' mov'
 mov 4
 lao 1601
 ldci 41
 chki 0 60
 ixa 4
 lca' mst'
 mov 4
 lao 1601
 ldci 42
i16140
 chki 0 60
 ixa 4
 lca' ret'
 mov 4
 lao 1601
 ldci 43
 chki 0 60
 ixa 4
 lca' sro'
 mov 4
i16150
 lao 1601
 ldci 44
 chki 0 60
 ixa 4
 lca' xjp'
 mov 4
 lao 1601
 ldci 45
 chki 0 60
 ixa 4
i16160
 lca' chk'
 mov 4
 lao 1601
 ldci 46
 chki 0 60
 ixa 4
 lca' cup'
 mov 4
 lao 1601
 ldci 47
i16170
 chki 0 60
 ixa 4
 lca' equ'
 mov 4
 lao 1601
 ldci 48
 chki 0 60
 ixa 4
 lca' geq'
 mov 4
i16180
 lao 1601
 ldci 49
 chki 0 60
 ixa 4
 lca' grt'
 mov 4
 lao 1601
 ldci 50
 chki 0 60
 ixa 4
i16190
 lca' lda'
 mov 4
 lao 1601
 ldci 51
 chki 0 60
 ixa 4
 lca' ldc'
 mov 4
 lao 1601
 ldci 52
i16200
 chki 0 60
 ixa 4
 lca' leq'
 mov 4
 lao 1601
 ldci 53
 chki 0 60
 ixa 4
 lca' les'
 mov 4
i16210
 lao 1601
 ldci 54
 chki 0 60
 ixa 4
 lca' lod'
 mov 4
 lao 1601
 ldci 55
 chki 0 60
 ixa 4
i16220
 lca' neq'
 mov 4
 lao 1601
 ldci 56
 chki 0 60
 ixa 4
 lca' str'
 mov 4
 lao 1601
 ldci 57
i16230
 chki 0 60
 ixa 4
 lca' ujp'
 mov 4
 lao 1601
 ldci 58
 chki 0 60
 ixa 4
 lca' ord'
 mov 4
i16240
 lao 1601
 ldci 59
 chki 0 60
 ixa 4
 lca' chr'
 mov 4
 lao 1601
 ldci 60
 chki 0 60
 ixa 4
i16250
 lca' ujc'
 mov 4
 retp
l1736=5
l1737=7
l1738
 ent 1 l1739
 ent 2 l1740
 ldci 0
 stri 0 5
 ldci 255
 stri 0 6
l1741
 lodi 0 5
i16260
 lodi 0 6
 leqi
 fjp l1742
 lao 194
 lodi 0 5
 chr
 ordc
 chki 0 255
 ixa 1
 ldci 3
i16270
 chki 0 10
 stoi
 lodi 0 5
 inci 1
 stri 0 5
 ujp l1741
l1742
 lao 194
 ldcc 'a'
 ordc
 chki 0 255
i16280
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'b'
 ordc
 chki 0 255
 ixa 1
 ldci 0
i16290
 chki 0 10
 stoi
 lao 194
 ldcc 'c'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
i16300
 lao 194
 ldcc 'd'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'e'
i16310
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'f'
 ordc
 chki 0 255
i16320
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'g'
 ordc
 chki 0 255
 ixa 1
 ldci 0
i16330
 chki 0 10
 stoi
 lao 194
 ldcc 'h'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
i16340
 lao 194
 ldcc 'i'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'j'
i16350
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'k'
 ordc
 chki 0 255
i16360
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'l'
 ordc
 chki 0 255
 ixa 1
 ldci 0
i16370
 chki 0 10
 stoi
 lao 194
 ldcc 'm'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
i16380
 lao 194
 ldcc 'n'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'o'
i16390
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'p'
 ordc
 chki 0 255
i16400
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'q'
 ordc
 chki 0 255
 ixa 1
 ldci 0
i16410
 chki 0 10
 stoi
 lao 194
 ldcc 'r'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
i16420
 lao 194
 ldcc 's'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 't'
i16430
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'u'
 ordc
 chki 0 255
i16440
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'v'
 ordc
 chki 0 255
 ixa 1
 ldci 0
i16450
 chki 0 10
 stoi
 lao 194
 ldcc 'w'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
i16460
 lao 194
 ldcc 'x'
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'y'
i16470
 ordc
 chki 0 255
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc 'z'
 ordc
 chki 0 255
i16480
 ixa 1
 ldci 0
 chki 0 10
 stoi
 lao 194
 ldcc '0'
 ordc
 chki 0 255
 ixa 1
 ldci 1
i16490
 chki 0 10
 stoi
 lao 194
 ldcc '1'
 ordc
 chki 0 255
 ixa 1
 ldci 1
 chki 0 10
 stoi
i16500
 lao 194
 ldcc '2'
 ordc
 chki 0 255
 ixa 1
 ldci 1
 chki 0 10
 stoi
 lao 194
 ldcc '3'
i16510
 ordc
 chki 0 255
 ixa 1
 ldci 1
 chki 0 10
 stoi
 lao 194
 ldcc '4'
 ordc
 chki 0 255
i16520
 ixa 1
 ldci 1
 chki 0 10
 stoi
 lao 194
 ldcc '5'
 ordc
 chki 0 255
 ixa 1
 ldci 1
i16530
 chki 0 10
 stoi
 lao 194
 ldcc '6'
 ordc
 chki 0 255
 ixa 1
 ldci 1
 chki 0 10
 stoi
i16540
 lao 194
 ldcc '7'
 ordc
 chki 0 255
 ixa 1
 ldci 1
 chki 0 10
 stoi
 lao 194
 ldcc '8'
i16550
 ordc
 chki 0 255
 ixa 1
 ldci 1
 chki 0 10
 stoi
 lao 194
 ldcc '9'
 ordc
 chki 0 255
i16560
 ixa 1
 ldci 1
 chki 0 10
 stoi
 lao 194
 ldcc '+'
 ordc
 chki 0 255
 ixa 1
 ldci 2
i16570
 chki 0 10
 stoi
 lao 194
 ldcc '-'
 ordc
 chki 0 255
 ixa 1
 ldci 2
 chki 0 10
 stoi
i16580
 lao 194
 ldcc '*'
 ordc
 chki 0 255
 ixa 1
 ldci 2
 chki 0 10
 stoi
 lao 194
 ldcc '/'
i16590
 ordc
 chki 0 255
 ixa 1
 ldci 2
 chki 0 10
 stoi
 lao 194
 ldcc '('
 ordc
 chki 0 255
i16600
 ixa 1
 ldci 9
 chki 0 10
 stoi
 lao 194
 ldcc ')'
 ordc
 chki 0 255
 ixa 1
 ldci 2
i16610
 chki 0 10
 stoi
 lao 194
 ldcc '$'
 ordc
 chki 0 255
 ixa 1
 ldci 2
 chki 0 10
 stoi
i16620
 lao 194
 ldcc '='
 ordc
 chki 0 255
 ixa 1
 ldci 2
 chki 0 10
 stoi
 lao 194
 ldcc ' '
i16630
 ordc
 chki 0 255
 ixa 1
 ldci 10
 chki 0 10
 stoi
 lao 194
 ldcc ','
 ordc
 chki 0 255
i16640
 ixa 1
 ldci 2
 chki 0 10
 stoi
 lao 194
 ldcc '.'
 ordc
 chki 0 255
 ixa 1
 ldci 6
i16650
 chki 0 10
 stoi
 lao 194
 ldcc '''
 ordc
 chki 0 255
 ixa 1
 ldci 4
 chki 0 10
 stoi
i16660
 lao 194
 ldcc '['
 ordc
 chki 0 255
 ixa 1
 ldci 2
 chki 0 10
 stoi
 lao 194
 ldcc ']'
i16670
 ordc
 chki 0 255
 ixa 1
 ldci 2
 chki 0 10
 stoi
 lao 194
 ldcc ':'
 ordc
 chki 0 255
i16680
 ixa 1
 ldci 5
 chki 0 10
 stoi
 lao 194
 ldcc '^'
 ordc
 chki 0 255
 ixa 1
 ldci 2
i16690
 chki 0 10
 stoi
 lao 194
 ldcc ';'
 ordc
 chki 0 255
 ixa 1
 ldci 2
 chki 0 10
 stoi
i16700
 lao 194
 ldcc '<'
 ordc
 chki 0 255
 ixa 1
 ldci 7
 chki 0 10
 stoi
 lao 194
 ldcc '>'
i16710
 ordc
 chki 0 255
 ixa 1
 ldci 8
 chki 0 10
 stoi
 lao 2021
 ldcc '0'
 ordc
 chki 0 255
i16720
 ixa 1
 ldci 0
 stoi
 lao 2021
 ldcc '1'
 ordc
 chki 0 255
 ixa 1
 ldci 1
 stoi
i16730
 lao 2021
 ldcc '2'
 ordc
 chki 0 255
 ixa 1
 ldci 2
 stoi
 lao 2021
 ldcc '3'
 ordc
i16740
 chki 0 255
 ixa 1
 ldci 3
 stoi
 lao 2021
 ldcc '4'
 ordc
 chki 0 255
 ixa 1
 ldci 4
i16750
 stoi
 lao 2021
 ldcc '5'
 ordc
 chki 0 255
 ixa 1
 ldci 5
 stoi
 lao 2021
 ldcc '6'
i16760
 ordc
 chki 0 255
 ixa 1
 ldci 6
 stoi
 lao 2021
 ldcc '7'
 ordc
 chki 0 255
 ixa 1
i16770
 ldci 7
 stoi
 lao 2021
 ldcc '8'
 ordc
 chki 0 255
 ixa 1
 ldci 8
 stoi
 lao 2021
i16780
 ldcc '9'
 ordc
 chki 0 255
 ixa 1
 ldci 9
 stoi
 retp
l1739=7
l1740=7
l1743
 ent 1 l1744
 ent 2 l1745
 lao 1937
i16790
 ldci 0
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 1
 chki 0 60
 ixa 1
i16800
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 2
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
i16810
 stoi
 lao 1937
 ldci 3
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
i16820
 ldci 4
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 5
 chki 0 60
i16830
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 6
 chki 0 60
 ixa 1
 ldci 1
i16840
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 7
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
i16850
 stoi
 lao 1937
 ldci 8
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 9
i16860
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 10
 chki 0 60
 ixa 1
 ldci 0
i16870
 chki -4 4
 stoi
 lao 1937
 ldci 11
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
i16880
 lao 1937
 ldci 12
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 13
i16890
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 14
 chki 0 60
 ixa 1
i16900
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 15
 chki 0 60
 ixa 1
 ldci 1
 ngi
i16910
 chki -4 4
 stoi
 lao 1937
 ldci 16
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
i16920
 lao 1937
 ldci 17
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 18
 chki 0 60
i16930
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 19
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
i16940
 stoi
 lao 1937
 ldci 20
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 21
i16950
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 22
 chki 0 60
 ixa 1
i16960
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 23
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
i16970
 stoi
 lao 1937
 ldci 24
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 25
i16980
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 26
 chki 0 60
 ixa 1
 ldci 2
i16990
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 27
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
i17000
 lao 1937
 ldci 28
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 29
i17010
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 30
 chki 0 60
 ixa 1
 ldci 0
i17020
 chki -4 4
 stoi
 lao 1937
 ldci 31
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
i17030
 ldci 32
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 33
 chki 0 60
 ixa 1
i17040
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 34
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
i17050
 stoi
 lao 1937
 ldci 35
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 36
i17060
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 37
 chki 0 60
 ixa 1
i17070
 ldci 1
 chki -4 4
 stoi
 lao 1937
 ldci 38
 chki 0 60
 ixa 1
 ldci 1
 chki -4 4
 stoi
i17080
 lao 1937
 ldci 39
 chki 0 60
 ixa 1
 ldci 1
 chki -4 4
 stoi
 lao 1937
 ldci 40
 chki 0 60
i17090
 ixa 1
 ldci 2
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 41
 chki 0 60
 ixa 1
 ldci 0
i17100
 chki -4 4
 stoi
 lao 1937
 ldci 42
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
i17110
 ldci 43
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 44
 chki 0 60
i17120
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 45
 chki 0 60
 ixa 1
 ldci 0
i17130
 chki -4 4
 stoi
 lao 1937
 ldci 46
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
i17140
 ldci 47
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 48
 chki 0 60
i17150
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 49
 chki 0 60
 ixa 1
 ldci 1
i17160
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 50
 chki 0 60
 ixa 1
 ldci 1
 chki -4 4
 stoi
i17170
 lao 1937
 ldci 51
 chki 0 60
 ixa 1
 ldci 1
 chki -4 4
 stoi
 lao 1937
 ldci 52
 chki 0 60
i17180
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 53
 chki 0 60
 ixa 1
 ldci 1
i17190
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 54
 chki 0 60
 ixa 1
 ldci 1
 chki -4 4
 stoi
i17200
 lao 1937
 ldci 55
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 56
i17210
 chki 0 60
 ixa 1
 ldci 1
 ngi
 chki -4 4
 stoi
 lao 1937
 ldci 57
 chki 0 60
 ixa 1
i17220
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 58
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
i17230
 lao 1937
 ldci 59
 chki 0 60
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1937
 ldci 60
 chki 0 60
i17240
 ixa 1
 ldci 0
 chki -4 4
 stoi
 lao 1998
 ldci 1
 chki 1 23
 deci 1
 ixa 1
 ldci 1
i17250
 ngi
 chki -7 7
 stoi
 lao 1998
 ldci 2
 chki 1 23
 deci 1
 ixa 1
 ldci 1
 ngi
i17260
 chki -7 7
 stoi
 lao 1998
 ldci 3
 chki 1 23
 deci 1
 ixa 1
 ldci 2
 ngi
 chki -7 7
i17270
 stoi
 lao 1998
 ldci 4
 chki 1 23
 deci 1
 ixa 1
 ldci 2
 ngi
 chki -7 7
 stoi
i17280
 lao 1998
 ldci 5
 chki 1 23
 deci 1
 ixa 1
 ldci 2
 ngi
 chki -7 7
 stoi
 lao 1998
i17290
 ldci 6
 chki 1 23
 deci 1
 ixa 1
 ldci 3
 ngi
 chki -7 7
 stoi
 lao 1998
 ldci 7
i17300
 chki 1 23
 deci 1
 ixa 1
 ldci 3
 ngi
 chki -7 7
 stoi
 lao 1998
 ldci 8
 chki 1 23
i17310
 deci 1
 ixa 1
 ldci 3
 ngi
 chki -7 7
 stoi
 lao 1998
 ldci 9
 chki 1 23
 deci 1
i17320
 ixa 1
 ldci 3
 ngi
 chki -7 7
 stoi
 lao 1998
 ldci 10
 chki 1 23
 deci 1
 ixa 1
i17330
 ldci 4
 ngi
 chki -7 7
 stoi
 lao 1998
 ldci 11
 chki 1 23
 deci 1
 ixa 1
 ldci 0
i17340
 chki -7 7
 stoi
 lao 1998
 ldci 12
 chki 1 23
 deci 1
 ixa 1
 ldci 2
 ngi
 chki -7 7
i17350
 stoi
 lao 1998
 ldci 13
 chki 1 23
 deci 1
 ixa 1
 ldci 1
 ngi
 chki -7 7
 stoi
i17360
 lao 1998
 ldci 14
 chki 1 23
 deci 1
 ixa 1
 ldci 0
 chki -7 7
 stoi
 lao 1998
 ldci 15
i17370
 chki 1 23
 deci 1
 ixa 1
 ldci 0
 chki -7 7
 stoi
 lao 1998
 ldci 16
 chki 1 23
 deci 1
i17380
 ixa 1
 ldci 0
 chki -7 7
 stoi
 lao 1998
 ldci 17
 chki 1 23
 deci 1
 ixa 1
 ldci 0
i17390
 chki -7 7
 stoi
 lao 1998
 ldci 18
 chki 1 23
 deci 1
 ixa 1
 ldci 0
 chki -7 7
 stoi
i17400
 lao 1998
 ldci 19
 chki 1 23
 deci 1
 ixa 1
 ldci 0
 chki -7 7
 stoi
 lao 1998
 ldci 20
i17410
 chki 1 23
 deci 1
 ixa 1
 ldci 0
 chki -7 7
 stoi
 lao 1998
 ldci 21
 chki 1 23
 deci 1
i17420
 ixa 1
 ldci 1
 ngi
 chki -7 7
 stoi
 lao 1998
 ldci 22
 chki 1 23
 deci 1
 ixa 1
i17430
 ldci 1
 ngi
 chki -7 7
 stoi
 lao 1998
 ldci 23
 chki 1 23
 deci 1
 ixa 1
 ldci 1
i17440
 ngi
 chki -7 7
 stoi
 retp
l1744=5
l1745=7
l1718
 ent 1 l1746
 ent 2 l1747
 mst 0
 cup 0 l1719
 mst 0
 cup 0 l1722
i17450
 mst 0
 cup 0 l1725
 mst 0
 cup 0 l1735
 mst 0
 cup 0 l1732
 mst 0
 cup 0 l1738
 mst 0
 cup 0 l1743
i17460
 retp
l1746=5
l1747=5
l1748
 ent 1 l1749
 ent 2 l1750
 mst 0
 cup 0 l1712
 mst 0
 cup 0 l1715
 mst 0
 cup 0 l1718
 ldci 0
i17470
 chki 0 10
 sroi 52
 ldci 0
 chki 0 20
 sroi 53
 lao 55
 ldci 0
 chki 0 20
 ixa 5
 stra 0 2280
i17480
 ldoa 2280
 ldcn
 chka 0 1073741823
 stoa
 ldoa 2280
 inca 1
 ldcn
 chka 0 1073741823
 stoa
 ldoa 2280
i17490
 inca 2
 ldci 0
 chki 0 3
 stoi
 mst 0
 cup 0 l1691
 mst 0
 cup 0 l1688
 mst 0
 cup 0 l1694
i17500
 mst 0
 cup 0 l1709
 ldci 1
 chki 0 20
 sroi 53
 ldci 1
 chki 0 10
 sroi 52
 lao 55
 ldci 1
i17510
 chki 0 20
 ixa 5
 stra 0 2280
 ldoa 2280
 ldcn
 chka 0 1073741823
 stoa
 ldoa 2280
 inca 1
 ldcn
i17520
 chka 0 1073741823
 stoa
 ldoa 2280
 inca 2
 ldci 0
 chki 0 3
 stoi
 mst 0
 cup 0 l25
 mst 0
i17530
 ldos 190
 ldos 187
 uni
 ldc( 33)
 dif
 cup 1 l1670
 ldoi 35
 ldci 0
 neqi
 fjp l1751
i17540
 ldcc '!'
 ldci 1
 lda 0 6
 csp wrc
 ldoi 35
 ldci 0
 lda 0 6
 csp wri
 lca' errors'
 ldci 7
i17550
 ldci 7
 lda 0 6
 csp wrs
 lda 0 6
 csp wln
l1751
 retp
l1749=2281
l1750=10
q
i0
 mst 0
 cup 0 l1748
 stp
q
