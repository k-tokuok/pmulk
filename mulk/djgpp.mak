#
#	makefile for djgpp.
#	$Id: mulk djgpp.mak 1433 2025-06-03 Tue 21:15:38 kt $
#
#	make -fdjgpp.mak [setup=setup.m]
#
.SUFFIXES: .c .o

cc=gcc
uflags=-Wall -Werror -O3 -DNDEBUG
cflags=$(uflags) -c
lflags=$(uflags)
dolink=$(cc) $(lflags) -o $@ $+
dostrip=strip $@
ppflags=dos caseInsensitiveFileName
setup?=setup.m

.c.o:
	$(cc) $(cflags) $<

all: mulk.exe mulk.mi

addxc.exe: addxc.o
	$(dolink)
	
ibprimsrc=sint.c lpint.c os.c float.c fbarray.c
mulkprimsrc=$(ibprimsrc) term.c

xcobj=std.o heap.o xbarray.o xctype.o splay.o xgetopt.o log.o xarray.o pfd.o \
	osd.o cqueue.o xwchar.o coord.o \
	om.o omd.o gc.o prim.o ir.o lex.o ip.o \
	$(mulkprimsrc:%.c=%.o)
xc.a: $(xcobj) addxc.exe
	addxc $(xcobj)

primlist.exe: primlist.o xc.a
	$(dolink)
	
mulkprim.wk: ip.o $(mulkprimsrc) primlist.exe
	primlist ip.c $(mulkprimsrc) >$@
mulk.exe: mulk.o mulkprim.o xc.a
	$(dolink)
	$(dostrip)
	
ibprim.wk: ip.c $(ibprimsrc) primlist.exe
	primlist ip.c $(ibprimsrc) >$@
ib.exe: ib.o ibprim.o oss.o xc.a
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
	ib 'Mulk load: "base.wk", save: "$@"'
mulk.mi: mulk.exe base.mi
	mulk -ibase.mi 'Mulk load: "$(setup)", save: "$@"'

icmd.mi: mulk.exe base.mi setup.m
	mulk -ibase.mi 'Mulk load: "setup.m", save: "$@"'
test: mulk.exe icmd.mi unittest.m
	mulk -iicmd.mi unittest base.m

clean:
	del *.o
	del *.a
	del *.wk
	del *.mi
	del *.exe

objsuf=o
include make.d
