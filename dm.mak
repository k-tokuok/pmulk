#
#	Makefile for Digital Mars C
#	$Id: mulk dm.mak 1318 2024-12-01 Sun 14:28:50 kt $
#
#	copy /y dm.mak+make.d make.wk
#	make -fmake.wk [setup=setup.m]
#
#	compiler defines __DMC__ implicit.
#

cc=dmc
uflags=-WA
cflags=$(uflags) -c -o -wx -w7 -DNDEBUG -DINTR_CHECK_P=1
lflags=$(uflags)
link=$(cc) $(lflags) -o$@ $** gdi32.lib
ppflags=windows caseInsensitiveFileName
setup=setup.m

.c.obj:
	$(cc) $(cflags) $<

all: mulk.exe mulk.mi

ibprimsrc=ip.c sint.c lpint.c os.c float.c fbarray.c
mulkprimsrc=$(ibprimsrc) codepage.c term.c dl.c view.c

xc.lib: std.obj heap.obj xbarray.obj xctype.obj splay.obj xgetopt.obj log.obj \
	xarray.obj pfw.obj cqueue.obj iqueue.obj xwchar.obj coord.obj \
	csplit.obj termw.obj vieww.obj \
	om.obj omd.obj gc.obj prim.obj ir.obj lex.obj \
	ip.obj sint.obj lpint.obj os.obj float.obj fbarray.obj \
	codepage.obj term.obj dl.obj view.obj vkey.obj
	lib -c $@ $**

primlist.exe: primlist.obj xc.lib
	$(link)

mulkprim.wk: $(mulkprimsrc) primlist.exe
	cmd /c ".\primlist $(mulkprimsrc) >$@"
mulk.exe: mulk.obj mulkprim.obj xc.lib
	$(link)

ibprim.wk: $(ibprimsrc) primlist.exe
	cmd /c ".\primlist $(ibprimsrc) >$@"
ib.exe: ib.obj ibprim.obj xc.lib
	$(link)
pp.exe: pp.obj xc.lib
	$(link)
mtoib.exe: mtoib.obj xc.lib
	$(link)
ib.wk: mtoib.exe pp.exe base.m
	cmd /c ".\pp ib $(ppflags) <base.m | .\mtoib 1.wk >2.wk"
	copy 1.wk+2.wk $@
base.wk: pp.exe base.m
	cmd /c ".\pp $(ppflags) <base.m >$@"
base.mi: ib.exe ib.wk base.wk mulkprim.wk
	.\ib "Mulk load: \"base.wk\", save: \"$@\""
mulk.mi: mulk.exe base.mi $(setup)
	.\mulk -ibase.mi "Mulk load: \"$(setup)\", save: \"$@\""

icmd.mi: mulk.exe base.mi setup.m
	.\mulk -ibase.mi "Mulk load: \"setup.m\", save: \"$@\""
test: mulk.exe icmd.mi unittest.m
	.\mulk -iicmd.mi unittest base.m

clean:
	del *.obj *.exe *.lib *.wk *.mi *.exe *.map

objsuf=obj
#concat make.d
