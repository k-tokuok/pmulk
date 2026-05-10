#
#	makefile for openwatcom/dos
#	$Id: mulk ow.mak 1590 2026-04-28 Tue 21:16:18 kt $
#
#	wmake -f ow.mak [setup=setup.m]
#
#	compiler defines __WATCOMC__ implicit
#
cc=wcl386
cflags=-c -we -dNDEBUG -ox
lflags=-l=dos4g
link=$(cc) $(lflags) -fe=$@ $<
ppflags=dos caseInsensitiveFileName
setup=setup.m

.c.obj:
	$(cc) $(cflags) $*.c

all: mulk.exe mulk.mi

ibprimsrc=sint.c lpint.c os.c float.c fbarray.c
mulkprimsrc=$(ibprimsrc) term.c
xc.lib: std.obj heap.obj xbarray.obj xctype.obj splay.obj xgetopt.obj log.obj &
	xarray.obj osd.obj pfd.obj cqueue.obj xwchar.obj coord.obj &
	om.obj omd.obj gc.obj prim.obj ir.obj lex.obj ip.obj &
	sint.obj lpint.obj os.obj float.obj fbarray.obj &
	term.obj
	for %i in ($<) do wlib xc.lib +-%i
	
primlist.exe: primlist.obj xc.lib
	$(link)

mulkprim.wk: ip.c $(mulkprimsrc) primlist.exe
	-primlist ip.c $(mulkprimsrc) >$@
mulk.exe: mulk.obj mulkprim.obj xc.lib
	$(link)
	
ibprim.wk: ip.c $(ibprimsrc) primlist.exe
	-primlist ip.c $(ibprimsrc) >$@
ib.exe: ib.obj ibprim.obj oss.obj xc.lib
	$(link)
pp.exe: pp.obj xc.lib
	$(link)
mtoib.exe: mtoib.obj xc.lib
	$(link)
ib.wk: pp.exe mtoib.exe base.m
	-pp ib $(ppflags) <base.m >1.wk
	-mtoib 2.wk <1.wk >3.wk
	copy 2.wk+3.wk ib.wk
base.wk: pp.exe base.m
	-pp $(ppflags) <base.m >base.wk
base.mi: ib.exe ib.wk base.wk mulkprim.wk
	copy << 1.wk
Mulk load: "base.wk", save: "base.mi"
<<
	-ib <1.wk
	
mulk.mi: mulk.exe base.mi setup.m
	copy << 1.wk
Mulk load: "$(setup)", save: "mulk.mi", quit
<<
	-mulk -ibase.mi <1.wk

clean:
	-del *.obj
	-del *.exe
	-del *.lib
	-del *.wk
	-del *.mi
	
objsuf=obj
!include make.d
