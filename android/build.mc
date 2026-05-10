#
# build mulka0.zip
# $Id: mulk/android build.mc 1597 2026-05-09 Sat 20:45:35 kt $
#
os.path -s ../mulk ../dll
cat ../mulk/ip.c ../mulk/sint.c ../mulk/lpint.c ../mulk/os.c ../mulk/float.c ../mulk/fbarray.c Mulk/app/src/main/jni/xmain.c | grep ^DEFPR >mulkprim.wk
pp unix android ib caseInsensitiveFileName <../mulk/base.m | os -i mtoib 1.wk >2.wk
cat 1.wk 2.wk >ib.wk
pp unix android caseInsensitiveFileName <../mulk/base.m >base.wk
echo 'Mulk load: "base.wk", load: "savebase.m"' | os -i ib
rm -n mulka0
mkdir mulka0
cp base.mi mulka0
package -s ../mulk mulka0@ul mulka0
mkdir Mulk/app/src/main/assets
zip.c Mulk/app/src/main/assets/mulka0.zip mulka0
