/*
    NumpadLayout class.
    $Id: mulk/android NumpadLayout.java 1536 2026-02-06 Fri 08:43:42 kt $
 */
package com.github.k_tokuok.mulk;

import java.util.ArrayList;
import java.util.List;

class NumpadLayout extends KeyboardLayout {
    private void addKey(int x, int y, char nch, String nlab) {
        addKey(x, y, nch, nlab, NCH, null, NCH, null, NCH, NCH, null);
    }

    List<Key> createKeys() {
        keys = new ArrayList<>();

        addKey(6, 0, '7', "7");
        addKey(7, 0, '8', "8");
        addKey(8, 0, '9', "9");
        addKey(9, 0, ctrl('h'), "Bs");
        addKey(6, 1, '4', "4");
        addKey(7, 1, '5', "5");
        addKey(8, 1, '6', "6");
        addKey(9, 1, '-', "-");
        addKey(6, 2, '1', "1");
        addKey(7, 2, '2', "2");
        addKey(8, 2, '3', "3");
        addKey(9, 2, '/', "/");
        addKey(6, 3, '0', "0");
        addKey(7, 3, '.', ".");
        addKey(8, 3, ',', ",");
        addKey(9, 3, ctrl('m'), "En");
        return keys;
    }
}
