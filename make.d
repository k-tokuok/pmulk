#
#	c source dependency.
#	$Id: mulk make.d 1092 2023-07-16 Sun 09:04:11 kt $
#
# following rules are generated automatically.
# !ls ?*.c | cdep $(objsuf)
addxc.$(objsuf): addxc.c std.h config.h u64.h
cfgfile.$(objsuf): cfgfile.c std.h config.h u64.h heap.h splay.h pf.h xbarray.h cfgfile.h
cm.$(objsuf): cm.c std.h config.h u64.h cm.h
coord.$(objsuf): coord.c std.h config.h u64.h coord.h
cqueue.$(objsuf): cqueue.c std.h config.h u64.h cqueue.h mem.h
csplit.$(objsuf): csplit.c std.h config.h u64.h csplit.h
dl.$(objsuf): dl.c std.h config.h u64.h mem.h om.h xarray.h prim.h xbarray.h
dos.$(objsuf): dos.c std.h config.h u64.h om.h xarray.h ip.h intr.h term.h coord.h cqueue.h xsleep.h
fbarray.$(objsuf): fbarray.c std.h config.h u64.h mem.h om.h xarray.h prim.h xbarray.h
float.$(objsuf): float.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
gc.$(objsuf): gc.c std.h config.h u64.h log.h om.h xarray.h ip.h gc.h omd.h
heap.$(objsuf): heap.c std.h config.h u64.h heap.h
ib.$(objsuf): ib.c std.h config.h u64.h splay.h heap.h xgetopt.h log.h mem.h xctype.h om.h xarray.h omd.h lex.h xbarray.h inst.h gc.h ip.h ibprim.wk
ibprim.$(objsuf): ibprim.c std.h config.h u64.h om.h xarray.h ibprim.wk
intrs.$(objsuf): intrs.c std.h config.h u64.h intr.h
intru.$(objsuf): intru.c std.h config.h u64.h intr.h om.h xarray.h ip.h
intrw.$(objsuf): intrw.c std.h config.h u64.h intr.h om.h xarray.h ip.h
ip.$(objsuf): ip.c std.h config.h u64.h mem.h om.h xarray.h ip.h gc.h inst.h prim.h xbarray.h intr.h heap.h splay.h csplit.h
ip1.$(objsuf): ip1.c std.h config.h u64.h mem.h om.h xarray.h ip.h gc.h inst.h prim.h xbarray.h intr.h heap.h splay.h
iqueue.$(objsuf): iqueue.c std.h config.h u64.h iqueue.h
ir.$(objsuf): ir.c std.h config.h u64.h mem.h heap.h pf.h xbarray.h om.h xarray.h ir.h
kidec.$(objsuf): kidec.c std.h config.h u64.h xbarray.h xarray.h csplit.h ki.h kidec.h heap.h pf.h
kidecw.$(objsuf): kidecw.c std.h config.h u64.h kidec.h heap.h kidecw.h
lex.$(objsuf): lex.c std.h config.h u64.h mem.h lex.h xbarray.h
lock.$(objsuf): lock.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
log.$(objsuf): log.c std.h config.h u64.h log.h
lpint.$(objsuf): lpint.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
lpintu64.$(objsuf): lpintu64.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
mtoib.$(objsuf): mtoib.c std.h config.h u64.h xbarray.h
mulk.$(objsuf): mulk.c std.h config.h u64.h xgetopt.h pf.h xbarray.h om.h xarray.h gc.h ir.h ip.h
mulkcm.$(objsuf): mulkcm.c std.h config.h u64.h xconsole.h mem.h cqueue.h cfgfile.h cm.h om.h xarray.h gc.h ir.h ip.h term.h coord.h intr.h xsleep.h
mulkprim.$(objsuf): mulkprim.c std.h config.h u64.h om.h xarray.h mulkprim.wk
mulks.$(objsuf): mulks.c std.h config.h u64.h pf.h xbarray.h om.h xarray.h gc.h ir.h ip.h mulks.wk
oauthlr.$(objsuf): oauthlr.c std.h config.h u64.h
om.$(objsuf): om.c std.h config.h u64.h mem.h heap.h om.h xarray.h
omd.$(objsuf): omd.c std.h config.h u64.h log.h xbarray.h om.h xarray.h
os.$(objsuf): os.c std.h config.h u64.h pf.h xbarray.h mem.h om.h xarray.h gc.h prim.h cm.h
pfcm.$(objsuf): pfcm.c std.h config.h u64.h mem.h cm.h pf.h xbarray.h
pfd.$(objsuf): pfd.c std.h config.h u64.h pf.h xbarray.h mem.h
pfu.$(objsuf): pfu.c std.h config.h u64.h pf.h xbarray.h
pfw.$(objsuf): pfw.c std.h config.h u64.h pf.h xbarray.h mem.h
pfwu64.$(objsuf): pfwu64.c std.h config.h u64.h pf.h xbarray.h ms.h
pp.$(objsuf): pp.c std.h config.h u64.h mem.h heap.h splay.h xbarray.h
prim.$(objsuf): prim.c std.h config.h u64.h mem.h om.h xarray.h gc.h prim.h xbarray.h
primlist.$(objsuf): primlist.c std.h config.h u64.h xbarray.h
sint.$(objsuf): sint.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
sleep.$(objsuf): sleep.c std.h config.h u64.h xsleep.h om.h xarray.h prim.h xbarray.h
splay.$(objsuf): splay.c std.h config.h u64.h heap.h splay.h
std.$(objsuf): std.c std.h config.h u64.h xconsole.h
term.$(objsuf): term.c std.h config.h u64.h term.h coord.h xwchar.h om.h xarray.h prim.h xbarray.h
terms.$(objsuf): terms.c term.h coord.h
termu.$(objsuf): termu.c std.h config.h u64.h term.h coord.h cqueue.h
termw.$(objsuf): termw.c std.h config.h u64.h cqueue.h term.h coord.h ki.h kidec.h heap.h kidecw.h om.h xarray.h ip.h prim.h xbarray.h
u64.$(objsuf): u64.c std.h config.h u64.h
u64t.$(objsuf): u64t.c std.h config.h u64.h
viewp.$(objsuf): viewp.c std.h config.h u64.h viewp.h view.h coord.h xwchar.h om.h xarray.h prim.h xbarray.h
views.$(objsuf): views.c std.h config.h u64.h iqueue.h xwchar.h viewp.h view.h coord.h intr.h ki.h kidec.h heap.h csplit.h om.h xarray.h ip.h
vieww.$(objsuf): vieww.c std.h config.h u64.h iqueue.h xwchar.h om.h xarray.h ip.h viewp.h view.h coord.h ki.h kidec.h heap.h kidecw.h csplit.h intr.h
viewx.$(objsuf): viewx.c std.h config.h u64.h mem.h iqueue.h viewp.h view.h coord.h xwchar.h intr.h ki.h om.h xarray.h ip.h
xarray.$(objsuf): xarray.c std.h config.h u64.h xarray.h
xbarray.$(objsuf): xbarray.c std.h config.h u64.h xbarray.h
xconsole.$(objsuf): xconsole.c std.h config.h u64.h mem.h
xctype.$(objsuf): xctype.c xctype.h
xgetopt.$(objsuf): xgetopt.c std.h config.h u64.h xgetopt.h
xsleeps.$(objsuf): xsleeps.c xsleep.h
xsleepu.$(objsuf): xsleepu.c std.h config.h u64.h xsleep.h intr.h om.h xarray.h ip.h
xsleepw.$(objsuf): xsleepw.c std.h config.h u64.h xsleep.h om.h xarray.h ip.h intr.h
xwchar.$(objsuf): xwchar.c std.h config.h u64.h xwchar.h mem.h
