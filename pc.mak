#
#	Makefile for Pelles C.
#	$Id: mulk pc.mak 1092 2023-07-16 Sun 09:04:11 kt $
#
#	pomake -F pc.mak [setup=setup.m] [ptr=p32|p64]
#

.SUFFIXES: .c .obj
cc=cc
uflags=-Ze

!ifndef ptr
ptr=p32
!endif
!if "$(ptr)"=="p32"
topt=-Tx86-coff
tlib=$(PellesCDir)/lib/win
!else
topt=-Tx64-coff
tlib=$(PellesCDir)/lib/win64
!endif

cflags=$(uflags) -DNDEBUG -DINTR_CHECK_P=1 -O2 $(topt)
lflags=$(uflags)
link=$(cc) $(lflags) $** -LIBPATH:"$(tlib)" user32.lib gdi32.lib -OUT:$@

ppflags=windows sjis newlineCrlf caseInsensitiveFileName
ibflags=-s

!ifndef setup
setup=setup.m
!endif

all: mulk.exe mulk.mi

.c.obj:
	$(cc) $(cflags) -c $<

xc.lib: std.obj heap.obj xbarray.obj xctype.obj splay.obj xgetopt.obj log.obj \
	xarray.obj pfw.obj cqueue.obj iqueue.obj xsleepw.obj xwchar.obj coord.obj \
	csplit.obj kidec.obj kidecw.obj termw.obj vieww.obj \
	om.obj omd.obj gc.obj prim.obj ir.obj lex.obj \
	ip.obj sint.obj lpint.obj os.obj float.obj fbarray.obj intrw.obj \
	lock.obj sleep.obj term.obj dl.obj viewp.obj
	polib $** /OUT:xc.lib

primlist.exe: primlist.obj xc.lib
	$(link)

ibprimsrc=ip.c sint.c lpint.c os.c float.c fbarray.c
ibprim.wk: $(ibprimsrc) primlist.exe
	primlist $(ibprimsrc) >$@

ib.exe: ib.obj ibprim.obj intrs.obj xc.lib
	$(link)
pp.exe: pp.obj xc.lib
	$(link)
mtoib.exe: mtoib.obj xc.lib
	$(link)
ib.wk: mtoib.exe pp.exe base.m
	pp ib $(ppflags) <base.m | mtoib 1.wk >2.wk
	copy 1.wk+2.wk $@
base.wk: pp.exe base.m
	pp $(ppflags) <base.m >$@
base.mi: ib.exe ib.wk base.wk mulkprim.wk
	ib $(ibflags) "Mulk load: \"base.wk\", save: \"$@\""
mulk.mi: mulk.exe base.mi $(setup)
	mulk -ibase.mi "Mulk load: \"$(setup)\", save: \"$@\""

mulkprimsrc=$(ibprimsrc) lock.c sleep.c term.c termw.c dl.c viewp.c
mulkprim.wk: $(mulkprimsrc) primlist.exe
	primlist $(mulkprimsrc) >$@
	
mulk.exe: mulk.obj mulkprim.obj xc.lib
	$(link)

icmd.mi: mulk.exe base.mi setup.m
	mulk -ibase.mi "Mulk load: \"setup.m\", save: \"$@\""
test: mulk.exe icmd.mi unittest.m
	mulk -iicmd.mi unittest base.m

clean:
	del *.obj *.lib *.wk *.mi *.exe

objsuf=obj
!include make.d
