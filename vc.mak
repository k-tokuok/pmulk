#
#	Makefile for Visual-C
#	$Id: mulk vc.mak 1327 2024-12-08 Sun 11:38:07 kt $
#
#	nmake /fvc.mak [setup=setup.m]
#
#	compiler defines _MSC_VER implicit.
#

.SUFFIXES: .c .obj

!IFNDEF setup
setup=setup.m
!ENDIF

cc=cl
uflags=/O2 /W3 /WX /MD
cflags=$(uflags) /c /DNDEBUG /DINTR_CHECK_P=1
lflags=$(uflags)
link=$(cc) $(lflags) /Fe$@ $** user32.lib gdi32.lib

ppflags=windows caseInsensitiveFileName

.c.obj:
	$(cc) $(cflags) $<

all: mulk.exe mulk.mi

ibprimsrc=ip.c sint.c lpint.c os.c float.c fbarray.c
ibprim.wk: $(ibprimsrc)
	del 1.wk
	for %i in ($**) do type %i >>1.wk
	find "DEFPR" <1.wk >$@

mulkprimsrc=$(ibprimsrc) term.c dl.c view.c
mulkprim.wk: $(mulkprimsrc)
	del 1.wk
	for %i in ($**) do type %i >>1.wk
	find "DEFPR" <1.wk >$@

xc.lib: std.obj heap.obj xbarray.obj xctype.obj splay.obj xgetopt.obj log.obj \
	xarray.obj pfw.obj cqueue.obj iqueue.obj xwchar.obj coord.obj \
	csplit.obj termw.obj view.obj \
	om.obj omd.obj gc.obj prim.obj ir.obj lex.obj \
	ip.obj sint.obj lpint.obj os.obj float.obj fbarray.obj \
	term.obj dl.obj vieww.obj vkey.obj
	lib /out:$@ $**

mulk.exe: mulk.obj mulkprim.obj xc.lib
	$(link)

ib.exe: ib.obj ibprim.obj xc.lib
	$(link)
pp.exe: pp.obj xc.lib
	$(link)
mtoib.exe: mtoib.obj xc.lib
	$(link)
ib.wk: mtoib.exe pp.exe base.m
	.\pp ib $(ppflags) <base.m | .\mtoib 1.wk >2.wk
	copy 1.wk+2.wk $@
base.wk: pp.exe base.m
	.\pp $(ppflags) <base.m >$@
base.mi: ib.exe ib.wk base.wk mulkprim.wk
	.\ib "Mulk load: \"base.wk\", save: \"$@\""
mulk.mi: mulk.exe base.mi $(setup)
	.\mulk -ibase.mi "Mulk load: \"$(setup)\", save: \"$@\""
	
icmd.mi: mulk.exe base.mi setup.m
	.\mulk -ibase.mi "Mulk load: \"setup.m\", save: \"$@\""
test: mulk.exe icmd.mi unittest.m
	.\mulk -iicmd.mi unittest base.m

clean:
	del *.obj *.lib *.wk *.mi *.exe

objsuf=obj
!INCLUDE make.d
