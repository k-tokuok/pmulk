/*
    KeyboardView class.
    $Id: mulk/android KeyboardView.java 1615 2026-06-18 Thu 21:19:44 kt $
 */

package com.github.k_tokuok.mulk;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;

import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.Semaphore;

public class KeyboardView extends View {
    MainActivity mulkActivity;
    Paint paint;
    volatile boolean isReady;

    int keyColor;
    int keyPressedColor;
    int keyPressedLabelColor;

    Semaphore sem;
    List<Integer> queue;
    int filter;

    static final int VEVENT_CHAR = 0;
    static final int VEVENT_PTRDOWN = 1;
    static final int VEVENT_PTRDRAG = 2;
    static final int VEVENT_PTRUP = 3;

    static final int VEVENT_OPR_OFF = 2;

    synchronized void addQueue(int val) {
        queue.add(val);
        sem.release();
    }

    void addQueueChar(char ch) {
        if (ch == 3) mulkActivity.ctrlc();
        addQueue(VEVENT_CHAR + (ch << VEVENT_OPR_OFF));
    }

    void addQueuePtr(int type, float x, float y) {
        int ix = (int) x;
        int iy = (int) y;
        addQueue(type + (Main.coord(ix, iy) << VEVENT_OPR_OFF));
    }

    synchronized boolean isQueueEmpty() {
        return queue.isEmpty();
    }

    int getEvent() {
        try {
            sem.acquire();
        } catch (InterruptedException e) {
            // do nothing.
        }
        int result;
        synchronized (this) {
            result = queue.get(0);
            queue.remove(0);
        }
        return result;
    }

    void setEventFilter(int value) {
        filter = value;
        layoutKeys();
        postInvalidate();
    }

    KeyboardListener keyboardListener;

    void setKeyboardListener() {
        if (mulkActivity.useKeymap()) {
            try {
                keyboardListener = new RealKeyboardListener(this, mulkActivity.getKeymapFile());
            } catch (Exception e) {
                keyboardListener = null;
            }
        }
        if (keyboardListener == null) keyboardListener = new GenericKeyboardListener(this);
    }

    void initialize(Context ctx) {
        isReady = false;
        mulkActivity = (MainActivity) ctx;
        paint = new Paint();

        keyColor = Color.argb(128, 0, 0, 255);
        keyPressedColor = Color.argb(128, 0, 255, 255);
        keyPressedLabelColor = Color.RED;

        sem = new Semaphore(0);
        queue = new LinkedList<>();
        filter = 0;
        setKeyboardListener();

        fullKeyboardLayout = new FullKeyboardLayout();
        numpadLayout = new NumpadLayout();

        shiftMode = CROSSSHIFT;
    }

    public KeyboardView(Context context) {
        super(context);
        initialize(context);
    }

    public KeyboardView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initialize(context);
    }

    List<Key> keys;
    boolean isNumpad;
    FullKeyboardLayout fullKeyboardLayout;
    NumpadLayout numpadLayout;

    int keyWidth;
    int keyHeight;

    int keyboardLeft;
    int keyboardTop;
    int menuTop; //for non software keyboard

    void layoutKeys() {
        keys = new ArrayList<>();

        boolean showKeyboard = mulkActivity.enableSoftwareKeyboard() && filter == 0;

        Key k = new MenuKey(this);
        int l = keyboardLeft + keyWidth * 9;
        int t;
        if (showKeyboard) t = keyboardTop;
        else t = menuTop;
        k.setRect(l, t, l + keyWidth, t + keyHeight / 2);
        keys.add(k);

        if (showKeyboard) {
            k = new NumpadKey(this);
            l = keyboardLeft + keyWidth * 8;
            t = keyboardTop;
            k.setRect(l, t, l + keyWidth, t + keyHeight / 2);
            keys.add(k);

            if (isNumpad) keys.addAll(numpadLayout.createKeys());
            else keys.addAll(fullKeyboardLayout.createKeys());

            paint.setTextSize(1);
            Paint.FontMetrics fm = new Paint.FontMetrics();
            paint.getFontMetrics(fm);
            float fh = fm.bottom - fm.top;
            paint.setTextSize(keyHeight / fh / 2.2f);
        }
    }

    void initKeyboard() {
        //call from mulk thread.
        int vw = getWidth();
        int vh = getHeight();
        keyWidth = keyHeight = Math.min(vw / 10, (int) (vh / 4.5));
        keyboardLeft = (vw - keyWidth * 10) / 2;
        keyboardTop = menuTop = (vh - (int) (keyHeight * 4.5)) / 2;

        fullKeyboardLayout.init(this);
        numpadLayout.init(this);

        layoutKeys();
        postInvalidate();
    }

    Key currentKey;
    Canvas canvas;

    void drawRect(RectF rectArg) {
        float l = rectArg.left;
        float t = rectArg.top;
        float r = rectArg.right - 1;
        float b = rectArg.bottom - 1;
        canvas.drawLine(l, t, r, t, paint);
        canvas.drawLine(r, t, r, b, paint);
        canvas.drawLine(r, b, l, b, paint);
        canvas.drawLine(l, b, l, t, paint);
    }

    void drawFillRect(RectF rectArg) {
        canvas.drawRect(rectArg, paint);
    }

    void drawText(String text, float x, float y) {
        canvas.drawText(text, x, y, paint);
    }

    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        if(w < h) return;
        if(!isReady) {
            isReady=true;
        }
    }

    protected void onDraw(@NonNull Canvas canvasArg) {
        if(!isReady) return;
        canvas = canvasArg;
        paint.setColor(keyColor);

        if (keys != null) {
            for (Key k : keys) {
                if (k != currentKey) k.draw();
            }
        }

        if (currentKey != null) {
            currentKey.drawPressed();
        }
        canvas = null;
    }

    float touchX;
    float touchY;
    float prevTouchX;
    float prevTouchY;

    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getActionMasked()) {
            case MotionEvent.ACTION_DOWN:
                touchX = event.getX();
                touchY = event.getY();
                if (filter != 0) {
                    addQueuePtr(VEVENT_PTRDOWN, touchX, touchY);
                }
                for (Key k : keys) {
                    if (k.isPress()) {
                        currentKey = k;
                        k.onDown();
                    }
                }
                break;
            case MotionEvent.ACTION_MOVE:
                prevTouchX = touchX;
                prevTouchY = touchY;
                touchX = event.getX();
                touchY = event.getY();
                if (filter != 0) addQueuePtr(VEVENT_PTRDRAG, touchX, touchY);
                if (currentKey != null) currentKey.onMove();
                break;
            case MotionEvent.ACTION_UP:
                touchX = event.getX();
                touchY = event.getY();
                if (filter != 0) addQueuePtr(VEVENT_PTRUP, touchX, touchY);
                performClick();
                if (currentKey != null) currentKey.onUp();
                break;
            case MotionEvent.ACTION_CANCEL:
                if (currentKey != null) {
                    releaseCurrentKey();
                    invalidate();
                }
                break;
        }
        return true;
    }

    public boolean performClick() {
        super.performClick();
        return true;
    }

    void releaseCurrentKey() {
        currentKey = null;
    }

    void showMenu() {
        mulkActivity.showMenu();
    }

    void numpadFlip() {
        isNumpad = !isNumpad;
        layoutKeys();
        invalidate();
    }

    /* interface from Main (other thread) */
    private int shiftMode;
    private static final int CROSSSHIFT = 0;
    private static final int SPACESHIFT = 1;

    void setShiftMode(int shiftModeArg) {
        shiftMode = shiftModeArg;
    }

    boolean isSpaceShift() {
        return shiftMode == SPACESHIFT;
    }

    int[] customize(int[] args) {
        int[] result = new int[8];
        result[0] = keyColor;
        result[1] = keyPressedColor;
        result[2] = keyPressedLabelColor;
        result[3] = keyboardLeft;
        result[4] = keyboardTop;
        result[5] = keyboardLeft + keyWidth * 10;
        result[6] = keyboardTop + (int) (keyHeight * 4.5);
        result[7] = menuTop;
        if (args != null) {
            keyColor = args[0];
            keyPressedColor = args[1];
            keyPressedLabelColor = args[2];
            keyboardLeft = args[3];
            keyboardTop = args[4];
            keyWidth = (args[5] - keyboardLeft) / 10;
            keyHeight = (int) ((args[6] - keyboardTop) / 4.5);
            menuTop = args[7];
            layoutKeys();
            postInvalidate();
        }
        return result;
    }
}
