/*
    KeyboardLayout class.
    $Id: mulk/android KeyboardLayout.java 1536 2026-02-06 Fri 08:43:42 kt $
 */

package com.github.k_tokuok.mulk;

import java.util.List;

abstract class KeyboardLayout {
    KeyboardView view;

    static final char NCH = '\uffff';

    char ctrl(char ch) {
        return (char) (ch & 0x1f);
    }

    List<Key> keys;

    void addKey(int x, int y, int w, char nch, String nlab, char uch, String ulab, char dch, String dlab, char lch, char rch, String lrlab) {
        Key k = new CharKey(view, nch, nlab, uch, ulab, dch, dlab, lch, rch, lrlab);
        int l = view.keyboardLeft + x * view.keyWidth;
        int t = view.keyboardTop + view.keyHeight / 2 + y * view.keyHeight;
        k.setRect(l, t, l + view.keyWidth * w, t + view.keyHeight);
        keys.add(k);
    }

    void addKey(int x, int y, char nch, String nlab, char uch, String ulab, char dch, String dlab, char lch, char rch, String lrlab) {
        addKey(x, y, 1, nch, nlab, uch, ulab, dch, dlab, lch, rch, lrlab);
    }

    void init(KeyboardView viewArg) {
        view = viewArg;
    }
}
