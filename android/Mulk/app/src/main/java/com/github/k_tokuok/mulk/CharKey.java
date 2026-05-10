/*
    CharKey class.
    $Id: mulk/android CharKey.java 1442 2025-06-12 Thu 10:05:28 kt $
 */
package com.github.k_tokuok.mulk;

import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;

class CharKey extends Key {
    private final char nch;
    private final char uch;
    private final char dch;
    private final char lch;
    private final char rch;
    private final String nlab;
    private final String ulab;
    private final String dlab;
    private final String lrlab;

    CharKey(KeyboardView keyboardViewArg, char nchArg, String nlabArg, char uchArg, String ulabArg, char dchArg, String dlabArg, char lchArg, char rchArg, String lrlabArg) {
        super(keyboardViewArg);
        nch = nchArg;
        uch = uchArg;
        dch = dchArg;
        lch = lchArg;
        rch = rchArg;
        nlab = nlabArg;
        ulab = ulabArg;
        dlab = dlabArg;
        lrlab = lrlabArg;
    }

    RectF offsetRect(float dx, float dy) {
        RectF result = new RectF(rect);
        result.offset(dx, dy);
        return result;
    }

    float getTextWidth(String text) {
        Rect bounds = new Rect();
        view.paint.getTextBounds(text, 0, text.length(), bounds);
        return bounds.width();
    }

    void drawLabel() {
        Paint.FontMetrics fm = view.paint.getFontMetrics();

        float gap = rect.width() / 10;

        if (nlab != null) {
            view.drawText(nlab, rect.left + gap, rect.bottom - fm.bottom);
        }
        if (ulab != null) {
            view.drawText(ulab, rect.left + gap, rect.top - fm.top);
        }
        if (dlab != null) {
            view.drawText(dlab, rect.right - getTextWidth(dlab) - gap, rect.bottom - fm.bottom);
        }
        if (lrlab != null) {
            view.drawText(lrlab, rect.right - getTextWidth(lrlab) - gap, rect.top - fm.top);
        }
    }

    void draw() {
        super.draw();
        drawLabel();
    }

    RectF upRect() {
        return offsetRect(0, -rect.height());
    }

    RectF downRect() {
        return offsetRect(0, rect.height());
    }

    RectF leftRect() {
        return offsetRect(-rect.width(), 0);
    }

    RectF rightRect() {
        return offsetRect(rect.width(), 0);
    }

    void drawKey(RectF rectArg) {
        int color = view.keyColor;
        if (rectArg.contains(view.touchX, view.touchY)) color = view.keyPressedColor;
        view.paint.setColor(color);
        view.drawFillRect(rectArg);
    }

    void drawPressed() {
        int savedColor = view.paint.getColor();
        if (uch != KeyboardLayout.NCH) drawKey(upRect());
        if (dch != KeyboardLayout.NCH) drawKey(downRect());
        if (lch != KeyboardLayout.NCH) drawKey(leftRect());
        if (rch != KeyboardLayout.NCH) drawKey(rightRect());
        drawKey(rect);
        view.paint.setColor(view.keyPressedLabelColor);
        drawLabel();
        view.paint.setColor(savedColor);
    }

    char pressedChar(float x, float y) {
        if (uch != KeyboardLayout.NCH && upRect().contains(x, y)) return uch;
        if (dch != KeyboardLayout.NCH && downRect().contains(x, y)) return dch;
        if (lch != KeyboardLayout.NCH && leftRect().contains(x, y)) return lch;
        if (rch != KeyboardLayout.NCH && rightRect().contains(x, y)) return rch;
        if (rect.contains(x, y)) return nch;
        return KeyboardLayout.NCH;
    }

    void onMove() {
        if (pressedChar(view.touchX, view.touchY) != pressedChar(view.prevTouchX, view.prevTouchY)) {
            view.invalidate();
        }
    }

    void onUp() {
        super.onUp();
        char ch = pressedChar(view.touchX, view.touchY);
        if (ch != KeyboardLayout.NCH) view.addQueueChar(ch);
    }
}
