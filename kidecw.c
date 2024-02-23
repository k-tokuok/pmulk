/*
	keyboard input decoder for windows.
	$Id: mulk kidecw.c 838 2022-02-20 Sun 20:39:25 kt $
*/

#include "std.h"
#include <windows.h>
#include "kidec.h"
#include "kidecw.h"

static int press_p(int code)
{
	return GetKeyState(code)&0x8000;
}

#ifdef __DMC__
#define VK_NONCONVERT 0x1d
#define VK_CONVERT 0x1c
#endif

int kidecw_press_check(int key)
{
	switch(key) {
	case KI_SHIFT: return press_p(VK_LSHIFT)||press_p(VK_RSHIFT);
	case KI_CTRL: return press_p(VK_LCONTROL)||press_p(VK_RCONTROL);
	case KI_CONVERT: return press_p(VK_CONVERT);
	case KI_NONCONVERT: return press_p(VK_NONCONVERT);
	default: return 0;
	}
}
