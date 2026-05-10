#
#	Android.mk
#	$Id: mulk/android Android.mk 1442 2025-06-12 Thu 10:05:28 kt $
#
LOCAL_PATH:=$(call my-dir)

include $(CLEAR_VARS)

mulk=$(LOCAL_PATH)/../../../../../../mulk

LOCAL_MODULE:=mulk
LOCAL_SRC_FILES:=xmain.c \
	$(mulk)/om.c $(mulk)/ir.c $(mulk)/gc.c $(mulk)/prim.c \
	$(mulk)/ip.c $(mulk)/sint.c $(mulk)/lpint.c $(mulk)/os.c \
	$(mulk)/float.c $(mulk)/fbarray.c \
	$(mulk)/std.c $(mulk)/xarray.c $(mulk)/heap.c $(mulk)/xbarray.c \
	$(mulk)/osu.c $(mulk)/pfu.c $(mulk)/log.c

LOCAL_C_INCLUDES:=$(LOCAL_PATH)/../../../../.. $(mulk)

include $(BUILD_SHARED_LIBRARY)
