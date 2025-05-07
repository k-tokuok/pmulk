#
#	c source dependency.
#	$Id: mulk make.d 1414 2025-04-26 Sat 22:32:20 kt $
#
# following rules are generated automatically.
# !ls ?*.c | cdep $(objsuf)
addxc.$(objsuf): addxc.c std.h config.h u64.h
coord.$(objsuf): coord.c std.h config.h u64.h coord.h
cqueue.$(objsuf): cqueue.c std.h config.h u64.h cqueue.h mem.h
csplit.$(objsuf): csplit.c std.h config.h u64.h csplit.h
dl.$(objsuf): dl.c std.h config.h u64.h mem.h om.h xarray.h prim.h xbarray.h
fbarray.$(objsuf): fbarray.c std.h config.h u64.h mem.h om.h xarray.h prim.h xbarray.h
float.$(objsuf): float.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
gc.$(objsuf): gc.c std.h config.h u64.h log.h om.h xarray.h ip.h gc.h omd.h
heap.$(objsuf): heap.c std.h config.h u64.h heap.h
ib.$(objsuf): ib.c std.h config.h u64.h splay.h heap.h xgetopt.h log.h mem.h xctype.h om.h xarray.h omd.h lex.h xbarray.h inst.h gc.h ip.h ibprim.wk
ibprim.$(objsuf): ibprim.c std.h config.h u64.h om.h xarray.h ibprim.wk
ip.$(objsuf): ip.c std.h config.h u64.h mem.h om.h xarray.h os.h ip.h gc.h inst.h prim.h xbarray.h heap.h splay.h csplit.h
iqueue.$(objsuf): iqueue.c std.h config.h u64.h iqueue.h
ir.$(objsuf): ir.c std.h config.h u64.h mem.h heap.h pf.h xbarray.h om.h xarray.h ir.h
lex.$(objsuf): lex.c std.h config.h u64.h mem.h lex.h xbarray.h
log.$(objsuf): log.c std.h config.h u64.h log.h
lpint.$(objsuf): lpint.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
lpintu64.$(objsuf): lpintu64.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
mtoib.$(objsuf): mtoib.c std.h config.h u64.h xbarray.h
mulk.$(objsuf): mulk.c std.h config.h u64.h xgetopt.h pf.h xbarray.h om.h xarray.h gc.h ir.h ip.h
mulkprim.$(objsuf): mulkprim.c std.h config.h u64.h om.h xarray.h mulkprim.wk
mulks.$(objsuf): mulks.c std.h config.h u64.h pf.h xbarray.h om.h xarray.h gc.h ir.h ip.h mulks.wk
oauthlr.$(objsuf): oauthlr.c std.h config.h u64.h
om.$(objsuf): om.c std.h config.h u64.h mem.h heap.h om.h xarray.h
omd.$(objsuf): omd.c std.h config.h u64.h log.h xbarray.h om.h xarray.h
os.$(objsuf): os.c std.h config.h u64.h pf.h xbarray.h mem.h om.h xarray.h gc.h ip.h os.h prim.h
osd.$(objsuf): osd.c std.h config.h u64.h om.h xarray.h os.h ip.h term.h coord.h cqueue.h
oss.$(objsuf): oss.c std.h config.h u64.h os.h
osu.$(objsuf): osu.c std.h config.h u64.h om.h xarray.h os.h ip.h
osw.$(objsuf): osw.c std.h config.h u64.h om.h xarray.h os.h ip.h
pfd.$(objsuf): pfd.c std.h config.h u64.h pf.h xbarray.h mem.h
pfu.$(objsuf): pfu.c std.h config.h u64.h pf.h xbarray.h
pfw.$(objsuf): pfw.c std.h config.h u64.h pf.h xbarray.h mem.h om.h xarray.h ip.h
pfwa.$(objsuf): pfwa.c std.h config.h u64.h pf.h xbarray.h mem.h
pfwu64.$(objsuf): pfwu64.c std.h config.h u64.h pf.h xbarray.h ms.h
pp.$(objsuf): pp.c std.h config.h u64.h mem.h heap.h splay.h xbarray.h
prim.$(objsuf): prim.c std.h config.h u64.h mem.h om.h xarray.h gc.h prim.h xbarray.h
primlist.$(objsuf): primlist.c std.h config.h u64.h xbarray.h
sint.$(objsuf): sint.c std.h config.h u64.h om.h xarray.h prim.h xbarray.h
splay.$(objsuf): splay.c std.h config.h u64.h heap.h splay.h
std.$(objsuf): std.c std.h config.h u64.h xconsole.h
term.$(objsuf): term.c std.h config.h u64.h term.h coord.h xwchar.h om.h xarray.h prim.h xbarray.h
terms.$(objsuf): terms.c term.h coord.h
termu.$(objsuf): termu.c std.h config.h u64.h term.h coord.h cqueue.h
termw.$(objsuf): termw.c std.h config.h u64.h cqueue.h term.h coord.h om.h xarray.h ip.h
u64.$(objsuf): u64.c std.h config.h u64.h
u64t.$(objsuf): u64t.c std.h config.h u64.h
view.$(objsuf): view.c std.h config.h u64.h om.h xarray.h xwchar.h view.h coord.h prim.h xbarray.h
views.$(objsuf): views.c std.h config.h u64.h iqueue.h xwchar.h view.h coord.h vkey.h csplit.h om.h xarray.h ip.h
vieww.$(objsuf): vieww.c std.h config.h u64.h iqueue.h xwchar.h om.h xarray.h ip.h view.h coord.h vkey.h csplit.h
viewx.$(objsuf): viewx.c std.h config.h u64.h mem.h iqueue.h view.h coord.h xwchar.h om.h xarray.h ip.h
vkey.$(objsuf): vkey.c std.h config.h u64.h heap.h xbarray.h xarray.h csplit.h pf.h view.h coord.h vkey.h
xarray.$(objsuf): xarray.c std.h config.h u64.h xarray.h
xbarray.$(objsuf): xbarray.c std.h config.h u64.h xbarray.h
xconsole.$(objsuf): xconsole.c std.h config.h u64.h mem.h
xctype.$(objsuf): xctype.c xctype.h
xgetopt.$(objsuf): xgetopt.c std.h config.h u64.h xgetopt.h
xwchar.$(objsuf): xwchar.c std.h config.h u64.h xwchar.h mem.h
