/*
    DisplayView class.
    $Id: mulk/android DisplayView.java 1615 2026-06-18 Thu 21:19:44 kt $
 */
package com.github.k_tokuok.mulk;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.View;

import androidx.annotation.NonNull;

public class DisplayView extends View {
    volatile boolean isReady;
    Bitmap bitmap;
    Canvas canvas;
    Paint paint;
    Paint.FontMetrics fontMetrics;

    int updateInterval;
    int invalidCount;
    int invalidLeft, invalidTop, invalidRight, invalidBottom;

    int setFontSize(float size) {
        paint.setTypeface(Typeface.MONOSPACE);
        paint.setTextSize(TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, size, getResources().getDisplayMetrics()));
        fontMetrics = new Paint.FontMetrics();
        paint.getFontMetrics(fontMetrics);

        int fw = (int) (paint.measureText("a") + 1);
        int fh = (int) (fontMetrics.bottom - fontMetrics.top + 1);
        return Main.coord(fw, fh);
    }

    void initialize() {
        isReady = false;
        paint = new Paint();
        paint.setStyle(Paint.Style.FILL);
        setFontSize(16);
        updateInterval = 0;
        invalidCount = 0;
    }

    public DisplayView(Context context) {
        super(context);
        initialize();
    }

    public DisplayView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initialize();
    }

    public DisplayView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initialize();
    }

    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        if(w < h) return;
        if(!isReady) {
            bitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
            canvas = new Canvas(bitmap);
            isReady=true;
        }
    }

    protected void onDraw(@NonNull Canvas ca) {
        if (!isReady) return;
        ca.drawBitmap(bitmap, 0, 0, paint);
    }

    /* api from mulk */
    int acolor(int color) {
        return 0xff000000 | color;
    }

    void update() {
        if (invalidCount != 0) {
            postInvalidate(invalidLeft, invalidTop, invalidRight, invalidBottom);
            invalidCount = 0;
        }
    }

    void invalid(int l, int t, int r, int b) {
        if (invalidCount == 0) {
            invalidLeft = l;
            invalidTop = t;
            invalidRight = r;
            invalidBottom = b;
        } else {
            if (invalidLeft > l) invalidLeft = l;
            if (invalidTop > t) invalidTop = t;
            if (invalidRight < r) invalidRight = r;
            if (invalidBottom < b) invalidBottom = b;
        }
        invalidCount++;
        if (invalidCount >= updateInterval) update();
    }

    void fillRectangle(int l, int t, int w, int h, int color) {
        paint.setColor(acolor(color));
        canvas.drawRect(l, t, l + w, t + h, paint);
        invalid(l, t, l + w, t + h);
    }

    int drawText(String text, int x, int y, int color) {
        paint.setColor(acolor(color));
        y += (int) (-fontMetrics.top + 1);
        canvas.drawText(text, x, y, paint);
        int right = (int) (x + paint.measureText(text) + 1);
        invalid(x, (int) (y + fontMetrics.top), right, (int) (y + 1 + fontMetrics.bottom));
        return right;
    }

    void drawLine(int x0, int y0, int x1, int y1, int color) {
        paint.setColor(acolor(color));
        canvas.drawLine(x0, y0, x1, y1, paint);

        int left, right, top, bottom;
        if (x0 < x1) {
            left = x0;
            right = x1;
        } else {
            left = x1;
            right = x0;
        }
        if (y0 < y1) {
            top = y0;
            bottom = y1;
        } else {
            top = y1;
            bottom = y0;
        }
        invalid(left, top, right + 1, bottom + 1);
    }

    void drawPolygon(int[] pts, int color) {
        paint.setColor(acolor(color));
        Path path = new Path();
        path.moveTo(pts[0], pts[1]);
        int left = pts[0];
        int right = left;
        int top = pts[1];
        int bottom = top;
        for (int i = 2; i < pts.length; i += 2) {
            int x = pts[i];
            int y = pts[i + 1];
            path.lineTo(x, y);
            if (left > x) left = x;
            if (right < x) right = x;
            if (top > y) top = y;
            if (bottom < y) bottom = y;
        }
        canvas.drawPath(path, paint);
        invalid(left, top, right, bottom);
    }
}
