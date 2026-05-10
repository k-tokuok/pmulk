/*
    MenuKey class.
    $Id: mulk/android MenuKey.java 1442 2025-06-12 Thu 10:05:28 kt $
 */
package com.github.k_tokuok.mulk;

class MenuKey extends Key {
    MenuKey(KeyboardView keyboardViewArg) {
        super(keyboardViewArg);
    }

    void onUp() {
        super.onUp();
        if (isPress()) view.showMenu();
    }
}
