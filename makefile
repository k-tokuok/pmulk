#
#	makefile for gnu toolchain.
#	$Id: mulk makefile 1318 2024-12-01 Sun 14:28:50 kt $
#
#	make hostos={cygwin,linux,macosx,minix,freebsd,netbsd,illumos,windows}
#		[dl=on|off] [term=on|off] [view=on|off|sdl] [xft=on|off] 
#		[setup=setup.m] [cross=|wine]
#		[debug=off|on] [ptr=p64|p32] [disableSendCommon=off|on]
#		[target=xxx sall]
#	The former is the default.
#

unixen=cygwin linux macosx minix freebsd netbsd illumos
supportos=$(unixen) windows

ifeq ($(filter $(supportos),$(hostos)),)
$(error illegal hostos)
endif

ifeq ($(hostos),minix)
ptr=p32
xft=off
endif

ifeq ($(hostos),macosx)
view=sdl
endif

dl?=on
term?=on
view?=on
xft?=on
setup?=setup.m
debug?=off
ptr?=p64
disableSendCommon?=off

ifeq ($(filter p32 p64,$(ptr)),)
$(error illegal ptr)
endif

.SUFFIXES: .c .o

toolprefix=
ccname=cc
cc=$(toolprefix)$(ccname)
ar=$(toolprefix)ar
strip=$(toolprefix)strip

uflags=-Wall -Werror
cflags=$(uflags) -c
lflags=$(uflags)
sflags=-s
dolink=$(cc) $(lflags) -o $@ $+ $(libs)

ifeq ($(debug),on)
uflags+=-g
else
cflags+=-O3 -DNDEBUG
dolink+=; $(strip) $(sflags) $@
endif

.c.o:
	$(cc) $(cflags) $<

ppflags=$(hostos)

ifeq ($(hostos),windows)
ccname=gcc
ifeq ($(ptr),p32)
toolprefix=i686-pc-mingw32-
cflags+=-DINTER_ISFINITE_P=1
else
toolprefix=x86_64-w64-mingw32-
endif
ppflags+=caseInsensitiveFileName
mulkprims+=codepage.c
xcobjs+=pfw.o
exe=.exe
termobjs+=termw.o
termprims+=termw.c
ifeq ($(cross),wine)
wine=wine
endif
endif

ifneq ($(filter $(unixen),$(hostos)),)
ppflags+=unix
xcobjs+=pfu.o
termobjs+=termu.o
endif

ifeq ($(hostos),cygwin)
ppflags+=caseInsensitiveFileName
termlibs+=-lncurses
xftcflags+=-I/usr/include/freetype2
endif

ifeq ($(hostos),linux)
dllibs+=-ldl
termlibs+=-lncurses
xftcflags+=-I/usr/include/freetype2
endif

ifeq ($(hostos),macosx)
ppflags+=caseInsensitiveFileName
sflags=
termlibs+=-lncurses
viewcflags+=-I/usr/X11/include
xftcflags+=-I/usr/X11/include/freetype2
viewlflags+=-L/usr/X11/lib
endif

ifeq ($(hostos),minix)
ccname=clang
termlibs+=-ltermcap
viewcflags+=-I/usr/pkg/X11R6/include
viewlflags+=-L/usr/pkg/X11R6/lib
endif

ifeq ($(hostos),freebsd)
cflags+=-Wno-error=unused-but-set-variable
libs+=-lm
termlibs=-lcurses
viewcflags+=-I/usr/local/include
xftcflags+=-I/usr/local/include/freetype2
viewlflags+=-L/usr/local/lib
endif

ifeq ($(hostos),netbsd)
termlibs=-lcurses
viewcflags+=-I/usr/X11R7/include
viewlflags+=-L/usr/X11R7/lib
xftcflags+=-I/usr/pkg/include/freetype2
endif

ifeq ($(hostos),illumos)
ccname=gcc
sflags=
termlibs=-lcurses
xftcflags=-I/usr/include/freetype2
endif

ifeq ($(dl),on)
libs+=$(dllibs)
mulkprims+=dl.c
endif

ifeq ($(term),on)
cflags+=$(termcflags)
libs+=$(termlibs)
xcobjs+=$(termobjs)
mulkprims+=term.c $(termprims)
endif

ifeq ($(view),on)
cflags+=$(viewcflags)
lflags+=$(viewlflags)
mulkprims+=view.c
intrCheck=on

ifneq ($(filter $(unixen),$(hostos)),)
#in unixen, use x11
libs+=-lX11
xcobjs+=viewx.o
ifeq ($(xft),on)
cflags+=$(xftcflags) -DXFT_P=1
libs+=-lXft
endif
endif

ifeq ($(hostos),windows)
libs+=-lgdi32 -lws2_32
xcobjs+=vieww.o
endif

endif

ifeq ($(view),sdl)
xcobjs+=views.o
mulkprims+=view.c
libs+=-lSDL2 -lSDL2_ttf
intrCheck=on
endif

ifeq ($(intrCheck),on)
cflags+=-DINTR_CHECK_P=1
endif

ifeq ($(disableSendCommon),on)
ppflags+=disableSendCommon
endif

all: $(mulk) mulk.mi

ibprims=ip.c sint.c lpint.c os.c float.c fbarray.c
ibprim.wk: $(ibprims)
	cat $+ | grep ^DEFPR >$@

mulkprims_all=$(ibprims) $(mulkprims)
mulkprim.wk: $(mulkprims_all)
	cat $+ | grep ^DEFPR >$@

xc.a: std.o heap.o xbarray.o xctype.o splay.o xgetopt.o log.o xarray.o \
	cqueue.o iqueue.o xwchar.o coord.o csplit.o vkey.o \
	om.o omd.o gc.o prim.o ir.o lex.o \
	$(mulkprims_all:%.c=%.o) \
	$(xcobjs)
	rm -f $@
	$(ar) -r $@ $+

mulk=mulk$(exe)
$(mulk): mulk.o mulkprim.o xc.a
	$(dolink)

ib=ib$(exe)
$(ib): ib.o ibprim.o $(ibobjs) xc.a
	$(dolink)
pp=pp$(exe)
$(pp): pp.o xc.a
	$(dolink)
mtoib=mtoib$(exe)
$(mtoib): mtoib.o xc.a
	$(dolink)
ib.wk: $(pp) $(mtoib) base.m
	$(wine) ./$(pp) ib $(ppflags) <base.m >1.wk
	$(wine) ./$(mtoib) 2.wk <1.wk >3.wk
	cat 2.wk 3.wk >$@
base.wk: $(pp) base.m
	$(wine) ./$(pp) $(ppflags) <base.m >$@
base.mi: $(ib) ib.wk base.wk mulkprim.wk
	$(wine) ./$(ib) 'Mulk load: "base.wk", save: "$@"'
mulk.mi: $(mulk) base.mi $(setup)
	$(wine) ./$(mulk) -ibase.mi 'Mulk load: "$(setup)", save: "$@"'

ipp.o: ip.c
	$(cc) $(cflags) -DIP_PROFILE -o ipp.o ip.c
mulkp=mulkp$(exe)
$(mulkp): mulk.o ipp.o mulkprim.o xc.a
	$(dolink)

icmd.mi: $(mulk) base.mi setup.m
	$(wine) ./$(mulk) -ibase.mi 'Mulk load: "setup.m", save: "$@"'

test: $(mulk) icmd.mi unittest.m
	$(wine) ./$(mulk) -iicmd.mi unittest base.m

#standalone.
$(target).mi: $(mulk) base.mi s-$(target).m
	$(wine) ./$(mulk) -ibase.mi 'Mulk load: "s-$(target).m", save: "$@"'
mulks.wk: $(mulk) icmd.mi $(target).mi
	$(wine) ./$(mulk) -iicmd.mi "mkmulks <$(target).mi >$@"
targetexe=$(target)$(exe)
$(targetexe): mulks.o mulkprim.o xc.a
	$(dolink)
sall: $(targetexe)
sclean: clean
	rm -f $(targetexe)

#oauthlr.
oauthlr=oauthlr$(exe)
$(oauthlr): oauthlr.o xc.a
	$(dolink)
	
clean:
	rm -f *.o *.a *.wk *.mi
	rm -f $(mulk) $(ib) $(pp) $(mtoib) $(mulkp) $(oauthlr)

allclean: clean
	rm -f *.lck *.log *.mpi *.num
	
objsuf=o
include make.d
