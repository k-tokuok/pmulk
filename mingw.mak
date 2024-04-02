#
#	makefile for MinGW-w64 tool chain.
#	$Id: mulk mingw.mak 1198 2024-04-01 Mon 21:37:17 kt $
#	MinGW-w64:
#		https://www.mingw-w64.org/
#	binary releases:
#		https://github.com/niXman/mingw-builds-binaries/releases (gcc)
#		https://github.com/mstorsjo/llvm-mingw/releases (llvm)
#	
#	mingw32-make -fmingw.mak [setup=setup.m]
#
setup?=setup.m
cc=gcc
ar=ar
strip=strip

uflags=-Wall -Werror
cflags=$(uflags) -c -O3 -DNDEBUG -DINTR_CHECK_P=1
lflags=$(uflags)
dolink=$(cc) $(lflags) -o$@ $+
dostrip=$(strip) -s $@

.c.o:
	$(cc) $(cflags) $<

ppflags=windows caseInsensitiveFileName

all: mulk.exe mulk.mi 

ibprim=ip.c sint.c lpint.c os.c float.c fbarray.c
mulkprim=$(ibprim) codepage.c lock.c sleep.c dl.c term.c termw.c viewp.c

xc.a: std.o heap.o xbarray.o xctype.o splay.o xgetopt.o log.o xarray.o \
	cqueue.o iqueue.o xwchar.o coord.o \
	om.o omd.o gc.o prim.o ir.o lex.o \
	$(mulkprim:%.c=%.o) \
	pfw.o csplit.o kidec.o kidecw.o xsleepw.o vieww.o intrw.o
	-del xc.a
	$(ar) -r $@ $+

primlist.exe: primlist.o xc.a
	$(dolink)
	
mulkprim.wk: $(mulkprim) primlist.exe
	primlist $(mulkprim) >$@
mulk.exe: mulk.o mulkprim.o xc.a
	$(dolink) -lgdi32
	$(dostrip)
	
ibprim.wk: $(ibprim) primlist.exe
	primlist $(ibprim) >$@
ib.exe: ib.o ibprim.o intrs.o xc.a
	$(dolink)
pp.exe: pp.o xc.a
	$(dolink)
mtoib.exe: mtoib.o xc.a
	$(dolink)
ib.wk: mtoib.exe pp.exe base.m
	pp ib $(ppflags) <base.m >1.wk
	mtoib 2.wk <1.wk >3.wk
	copy 2.wk+3.wk ib.wk
base.wk: pp.exe base.m
	pp $(ppflags) <base.m >base.wk
base.mi: ib.exe ib.wk base.wk mulkprim.wk
	ib 'Mulk load: "base.wk", save: "base.mi"'
mulk.mi: mulk.exe base.mi $(setup)
	mulk -ibase.mi 'Mulk load: "$(setup)", save: "mulk.mi"'

icmd.mi: mulk.exe base.mi setup.m
	mulk -ibase.mi 'Mulk load: "setup.m", save: "$@"'
test: mulk.exe icmd.mi unittest.m
	mulk -iicmd.mi unittest base.m

clean:
	-del *.o
	-del *.a
	-del *.wk
	-del *.mi
	-del *.exe

objsuf=o
include make.d
