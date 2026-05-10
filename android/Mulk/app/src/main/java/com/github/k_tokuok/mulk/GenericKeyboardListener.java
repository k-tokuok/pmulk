/*
    GenericKeyboardListener class.
    $Id: mulk/android GenericKeyboardListener.java 1442 2025-06-12 Thu 10:05:28 kt $
 */
package com.github.k_tokuok.mulk;

import android.view.KeyEvent;
import android.view.View;

class GenericKeyboardListener extends KeyboardListener {
    GenericKeyboardListener(KeyboardView viewArg) {
        super(viewArg);
    }

    @Override
    public boolean onKey(View v, int keyCode, KeyEvent event) {
        if (event.getAction() == KeyEvent.ACTION_DOWN) {
            if (keyCode == KeyEvent.KEYCODE_BACK) return false;

            char ch;
            if (keyCode == KeyEvent.KEYCODE_DEL) ch = '\b';
            else if (keyCode == KeyEvent.KEYCODE_COMMA && event.isShiftPressed()) ch = '<';
            else if (keyCode == KeyEvent.KEYCODE_PERIOD && event.isShiftPressed()) ch = '>';
            else ch = (char) event.getUnicodeChar();
            if (ch != 0) {
                view.addQueueChar(ch);
                return true;
            }
        }
        return false;
    }
}
