/*
    realKeyboardListener class.
    $Id: mulk/android RealKeyboardListener.java 1442 2025-06-12 Thu 10:05:28 kt $
 */
package com.github.k_tokuok.mulk;

import android.view.KeyEvent;
import android.view.View;

import java.io.BufferedReader;
import java.io.FileReader;

class RealKeyboardListener extends KeyboardListener {
    static final char NCH = '\uffff';

    private final char[] normalChars;
    private final char[] shiftChars;
    private final char[] controlChars;
    private final boolean[] isLeft;

    private static final int MAX_KEYCODE = 128;

    static final int KEYMAP_LEFT_THUMB = -2;
    static final int KEYMAP_RIGHT_THUMB = -3;

    char strToChar(String s) {
        int ch = Integer.parseInt(s);
        if (ch < 0) return NCH;
        else return (char) ch;
    }

    RealKeyboardListener(KeyboardView viewArg, String keymapFile) throws Exception {
        super(viewArg);
        normalChars = new char[MAX_KEYCODE];
        shiftChars = new char[MAX_KEYCODE];
        controlChars = new char[MAX_KEYCODE];
        isLeft = new boolean[MAX_KEYCODE];

        for (int i = 0; i < MAX_KEYCODE; i++) {
            normalChars[i] = NCH;
            shiftChars[i] = NCH;
            controlChars[i] = NCH;
            isLeft[i] = false;
        }

        FileReader fr = new FileReader(keymapFile);
        BufferedReader br = new BufferedReader(fr);
        String ln;
        while ((ln = br.readLine()) != null) {
            if (ln.length() == 0) continue;
            if (ln.charAt(0) == ';') continue;
            String[] ar = ln.split(",");
            int code = Integer.parseInt(ar[2]);
            if (code == -1) continue;
            int ich = Integer.parseInt(ar[3]);
            if (ich == KEYMAP_LEFT_THUMB) leftThumbKey = code;
            else if (ich == KEYMAP_RIGHT_THUMB) rightThumbKey = code;
            else {
                if (ich < 0) normalChars[code] = NCH;
                else normalChars[code] = (char) ich;
                shiftChars[code] = strToChar(ar[4]);
                controlChars[code] = strToChar(ar[5]);
                isLeft[code] = Integer.parseInt(ar[6]) != 0;
            }
        }
        br.close();
        fr.close();
    }

    private static final int leftShiftKey = 42;
    private static final int rightShiftKey = 54;
    private static final int controlKey = 29;
    private static final int spaceKey = 57;
    int leftThumbKey; /* us keyboard? */
    int rightThumbKey;

    private boolean isLeftShiftKeyPressed;
    private boolean isRightShiftKeyPressed;
    private boolean isControlKeyPressed;
    private boolean isLeftThumbKeyPressed;
    private boolean isRightThumbKeyPressed;

    private boolean isSpacePressed;
    private boolean isSpaceShiftUsed;

    @Override
    public boolean onKey(View v, int keyCode, KeyEvent event) {
        int action = event.getAction();
        int code = event.getScanCode();

        if (!(0 <= code && code < MAX_KEYCODE)) return false;

        if (action == KeyEvent.ACTION_DOWN) {
            if (code == leftShiftKey) isLeftShiftKeyPressed = true;
            else if (code == rightShiftKey) isRightShiftKeyPressed = true;
            else if (code == controlKey) isControlKeyPressed = true;
            else if (code == leftThumbKey) isLeftThumbKeyPressed = true;
            else if (code == rightThumbKey) isRightThumbKeyPressed = true;
            else if (view.isSpaceShift() && code == spaceKey) {
                if (event.getRepeatCount() == 0) {
                    isSpacePressed = true;
                    isSpaceShiftUsed = false;
                }
            } else {
                char[] map = normalChars;
                if (isLeftShiftKeyPressed || isRightShiftKeyPressed) map = shiftChars;
                else if (isControlKeyPressed) map = controlChars;
                else if (isLeftThumbKeyPressed) {
                    if (view.isSpaceShift()) map = controlChars;
                    else {
                        if (isLeft[code]) map = controlChars;
                        else map = shiftChars;
                    }
                } else if (isRightThumbKeyPressed) {
                    if (view.isSpaceShift()) map = controlChars;
                    else {
                        if (isLeft[code]) map = shiftChars;
                        else map = controlChars;
                    }
                } else if (isSpacePressed) {
                    map = shiftChars;
                    isSpaceShiftUsed = true;
                }
                char ch = map[code];

                if (ch != NCH) view.addQueueChar(ch);
            }
            return true;
        } else if (action == KeyEvent.ACTION_UP) {
            if (code == leftShiftKey) isLeftShiftKeyPressed = false;
            else if (code == rightShiftKey) isRightShiftKeyPressed = false;
            else if (code == controlKey) isControlKeyPressed = false;
            else if (code == leftThumbKey) isLeftThumbKeyPressed = false;
            else if (code == rightThumbKey) isRightThumbKeyPressed = false;
            else if (view.isSpaceShift() && code == spaceKey) {
                if (event.getRepeatCount() == 0) {
                    isSpacePressed = false;
                    if (!isSpaceShiftUsed) {
                        if (isControlKeyPressed
                                || isLeftShiftKeyPressed || isRightShiftKeyPressed
                                || isLeftThumbKeyPressed || isRightThumbKeyPressed) {
                            view.addQueueChar((char) 0);
                        } else view.addQueueChar(' ');
                    }
                }
            }
            return true;
        }
        return false;
    }
}
