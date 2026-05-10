/*
    Key class.
    $Id: mulk/android Key.java 1536 2026-02-06 Fri 08:43:42 kt $
 */
package com.github.k_tokuok.mulk;

import android.graphics.RectF;

class Key {
    KeyboardView view;

    Key(KeyboardView keyboardViewArg) {
        view = keyboardViewArg;
    }

    RectF rect;

    void setRect(int leftArg, int topArg, int rightArg, int bottomArg) {
        rect = new RectF(leftArg, topArg, rightArg, bottomArg);
    }

    boolean isPress() {
        return rect.contains(view.touchX, view.touchY);
    }

    void draw() {
        view.drawRect(rect);
    }

    void drawPressed() {
        int savedColor = view.paint.getColor();
        int color;
        if (isPress()) color = view.keyPressedColor;
        else color = view.keyColor;
        view.paint.setColor(color);
        view.drawFillRect(rect);
        view.paint.setColor(savedColor);
    }

    void onDown() {
        view.invalidate();
    }

    void onMove() {
        if (isPress() != rect.contains(view.prevTouchX, view.prevTouchY)) {
            view.invalidate();
        }
    }

    void onUp() {
        view.invalidate();
        view.releaseCurrentKey();
    }
}
