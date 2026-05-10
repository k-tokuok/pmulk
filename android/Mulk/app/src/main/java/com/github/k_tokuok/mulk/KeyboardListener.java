/*
    KeyboardListener class.
    $Id: mulk/android KeyboardListener.java 1442 2025-06-12 Thu 10:05:28 kt $
 */
package com.github.k_tokuok.mulk;

import android.view.View;

abstract class KeyboardListener implements View.OnKeyListener {
    KeyboardView view;

    KeyboardListener(KeyboardView viewArg) {
        view = viewArg;
        view.setOnKeyListener(this);
        view.setFocusableInTouchMode(true);
    }
}
