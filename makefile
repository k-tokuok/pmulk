#
#	makefile for gnu toolchain.
#	$Id: mulk makefile 1093 2023-07-16 Sun 21:45:01 kt $
#
#	make hostos={cygwin,linux,macosx,minix,freebsd,netbsd,illumos,windows}
#		[dl=on|off] [term=on|off] [view=on|off|sdl] [xft=on|off] 
#		[charset=utf8|sjis]
#		[setup=setup.m]
#		[debug=off|on] [ptr=p64|p32] [disableSendCommon=off|on]
#		[target=xxx sall]
#	The former is the default.
#	In cygwin or windows, use sjis as default charset.
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
dolink=$(cc) $(lflags) -o $@ $+

ifeq ($(debug),on)
uflags+=-g
else
cflags+=-O3 -DNDEBUG
dostrip=$(strip) $(sflags) $@
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
charset?=sjis
ppflags+=newlineCrlf caseInsensitiveFileName
extobj+=pfw.o xsleepw.o intrw.o kidecw.o
exe=.exe
termobj+=termw.o
termprim+=termw.c
endif

ifneq ($(filter $(unixen),$(hostos)),)
ppflags+=unix
extobj+=pfu.o xsleepu.o intru.o
termobj+=termu.o
endif

ifeq ($(hostos),cygwin)
ppflags+=newlineCrlf caseInsensitiveFileName
charset?=sjis
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
mulklibs+=-lm
iblibs+=-lm
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
mulklibs+=$(dllibs)
extprim+=dl.c
endif

ifeq ($(term),on)
cflags+=$(termcflags)
mulklibs+=$(termlibs)
extobj+=$(termobj)
extprim+=term.c $(termprim)
endif

ifeq ($(view),on)
cflags+=$(viewcflags)
lflags+=$(viewlflags)
extprim+=viewp.c
intrCheck=on

ifneq ($(filter $(unixen),$(hostos)),)
#in unixen, use x11
mulklibs+=-lX11
extobj+=viewx.o
ifeq ($(xft),on)
cflags+=$(xftcflags) -DXFT_P=1
mulklibs+=-lXft
endif
endif

ifeq ($(hostos),windows)
mulklibs+=-lgdi32
extobj+=vieww.o
oauthlrlib=-lws2_32
endif

endif

ifeq ($(view),sdl)
extobj+=views.o
extprim+=viewp.c
mulklibs+=-lSDL2 -lSDL2_ttf
intrCheck=on
endif

ifeq ($(intrCheck),on)
cflags+=-DINTR_CHECK_P=1
ibobj+=intrs.o
endif

ifeq ($(charset),sjis)
ibflags=-s
endif

ifeq ($(disableSendCommon),on)
ppflags+=disableSendCommon
endif

ppflags+=$(charset)

all: $(mulk) mulk.mi

ibprim=ip.c sint.c lpint.c os.c float.c fbarray.c
ibprim.wk: $(ibprim)
	cat $+ | grep ^DEFPRIM >$@

mulkprim=$(ibprim) lock.c sleep.c $(extprim)
mulkprim.wk: $(mulkprim)
	cat $+ | grep ^DEFPRIM >$@

xc.a: std.o heap.o xbarray.o xctype.o splay.o xgetopt.o log.o xarray.o \
	cqueue.o iqueue.o xwchar.o coord.o csplit.o kidec.o \
	om.o omd.o gc.o prim.o ir.o lex.o \
	$(mulkprim:%.c=%.o) \
	$(extobj)
	rm -f $@
	$(ar) -r $@ $+

mulk=mulk$(exe)
$(mulk): mulk.o mulkprim.o xc.a
	$(dolink) $(mulklibs)
	$(dostrip)

ib=ib$(exe)
$(ib): ib.o ibprim.o $(ibobj) xc.a
	$(dolink) $(iblibs)
pp=pp$(exe)
$(pp): pp.o xc.a
	$(dolink)
mtoib=mtoib$(exe)
$(mtoib): mtoib.o xc.a
	$(dolink)
ib.wk: $(pp) $(mtoib) base.m
	./$(pp) ib $(ppflags) <base.m >1.wk
	./$(mtoib) 2.wk <1.wk >3.wk
	cat 2.wk 3.wk >$@
base.wk: $(pp) base.m
	./$(pp) $(ppflags) <base.m >$@
base.mi: $(ib) ib.wk base.wk mulkprim.wk
	./$(ib) $(ibflags) 'Mulk load: "base.wk", save: "$@"'
mulk.mi: $(mulk) base.mi $(setup)
	./$(mulk) -ibase.mi 'Mulk load: "$(setup)", save: "$@"'

ipp.o: ip.c
	$(cc) $(cflags) -DIP_PROFILE -o ipp.o ip.c
mulkp=mulkp$(exe)
$(mulkp): mulk.o ipp.o mulkprim.o xc.a
	$(dolink) $(mulklibs)
	$(dostrip)

icmd.mi: $(mulk) base.mi setup.m
	./$(mulk) -ibase.mi 'Mulk load: "setup.m", save: "$@"'

test: $(mulk) icmd.mi unittest.m
	./$(mulk) -iicmd.mi unittest base.m

#standalone.
$(target).mi: $(mulk) base.mi s-$(target).m
	./$(mulk) -ibase.mi 'Mulk load: "s-$(target).m", save: "$@"'
mulks.wk: $(mulk) icmd.mi $(target).mi
	./$(mulk) -iicmd.mi "mkmulks <$(target).mi >$@"
targetexe=$(target)$(exe)
$(targetexe): mulks.o mulkprim.o xc.a
	$(dolink) $(mulklibs)
	$(dostrip)
sall: $(targetexe)
sclean: clean
	rm -f $(targetexe)

#oauthlr.
oauthlr=oauthlr$(exe)
$(oauthlr): oauthlr.o xc.a
	$(dolink) $(oauthlrlib)
	$(dostrip)
	
clean:
	rm -f *.o *.a *.wk *.mi
	rm -f $(mulk) $(ib) $(pp) $(mtoib)

allclean: clean
	rm -f *.lck *.log *.mpi *.num
	
objsuf=o
include make.d
