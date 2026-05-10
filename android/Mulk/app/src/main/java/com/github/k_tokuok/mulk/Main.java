/*
    Main class.
    $Id: mulk/android Main.java 1596 2026-05-08 Fri 15:42:46 kt $
 */
package com.github.k_tokuok.mulk;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.media.AudioAttributes;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.net.Uri;
import android.os.Environment;

import androidx.annotation.Keep;
import androidx.documentfile.provider.DocumentFile;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.CountDownLatch;
import java.util.zip.CRC32;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

class Main extends Thread {
    private final MainActivity mulkActivity;
    private final KeyboardView keyboardView;
    private final DisplayView displayView;

    Main(MainActivity cx, KeyboardView kv, DisplayView dv) {
        mulkActivity = cx;
        keyboardView = kv;
        displayView = dv;
    }

    private void waitForWakeup() {
        while (!(displayView.isReady && keyboardView.isReady)) {
            try {
                sleep(100);
            } catch (InterruptedException e) {
                //do nothing.
            }
        }
    }

    private int charx;
    private int chary;

    private void putString(String text) {
        charx = displayView.drawText(text, charx, chary, Color.RED);
        displayView.update();
    }

    private void putLn() {
        charx = 0;
        chary += 20;
    }

    /* xconsole */
    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void putChar(int ch) {
        if (ch == '\n') putLn();
        else putString(String.valueOf((char) ch));
    }

    /* dynamic methods */
    private String bytesToString(byte[] bytes) {
        return new String(bytes, StandardCharsets.UTF_8);
    }

    private byte[] stringToBytes(String s) {
        return s.getBytes(StandardCharsets.UTF_8);
    }

    static private final int BUFSIZE = 4096;

    /* imageFile */
    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void setImageFile(byte[] bytes) {
        mulkActivity.setImageFile(bytesToString(bytes));
    }

    /* keyboard */
    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int[] softwareKeyboardCustomize(int[] args) {
        return keyboardView.customize(args);
    }

    /* view */
    static private final int COORD_MAX = 0x3fff;

    static int coord(int x, int y) {
        if (x < 0) x = 0;
        if (x > COORD_MAX) x = COORD_MAX;
        if (y < 0) y = 0;
        if (y > COORD_MAX) y = COORD_MAX;
        return (x << 14) | y;
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int viewGetSize() {
        return coord(displayView.getWidth(), displayView.getHeight());
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int viewSetFontSize(double size) {
        return displayView.setFontSize((float) size);
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void viewFillRectangle(int x, int y, int w, int h, int color) {
        displayView.fillRectangle(x, y, w, h, color);
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void viewDrawChar(int x, int y, long ch, int color) {
        String text;
        int len = 0;
        while (ch >= (1L << len * 8)) len++;
        byte[] buf = new byte[len];
        for (int i = 0; i < len; i++) buf[i] = (byte) ((ch >> ((len - 1 - i) * 8)) & 0xff);
        text = new String(buf, StandardCharsets.UTF_8);
        displayView.drawText(text, x, y, color);
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void viewDrawLine(int x0, int y0, int x1, int y1, int color) {
        displayView.drawLine(x0, y0, x1, y1, color);
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void viewDrawPolygon(int[] pts, int color) {
        displayView.drawPolygon(pts, color);
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void viewSetShiftMode(int mode) {
        keyboardView.setShiftMode(mode);
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void viewSetEventFilter(int filter) {
        keyboardView.setEventFilter(filter);
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int viewGetEvent() {
        displayView.update();
        return keyboardView.getEvent();
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int viewIsEventEmpty() {
        displayView.update();
        return keyboardView.isQueueEmpty() ? 1 : 0;
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int viewSetUpdateInterval(int val) {
        int result = displayView.updateInterval;
        displayView.updateInterval = val;
        return result;
    }

    /* ctra */
    private String codeSet(int code) throws Exception {
        switch (code) {
            case 'u':
                return "UTF-8";
            case 's':
                return "MS932";
            case 'e':
                return "EUC_JP";
            case 'U':
                return "UTF-16LE";
            default:
                throw new Exception();
        }
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int ctr(byte[] req, byte[] from, int fromLen, byte[] to) {
        try {
            String s = new String(from, 0, fromLen, codeSet(req[0]));
            byte[] conv = s.getBytes(codeSet(req[1]));
            System.arraycopy(conv, 0, to, 0, conv.length);
            return conv.length;
        } catch (Exception e) {
            return -1;
        }
    }

    /* hra */
    void copy(InputStream in, OutputStream out) throws Exception {
        byte[] buf = new byte[BUFSIZE];
        int sz;
        while ((sz = in.read(buf)) > 0) out.write(buf, 0, sz);
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int hra(byte[] methodBytes, byte[] urlBytes, byte[] headerBytes, byte[] dataFnBytes, byte[] outFnBytes, int timeout) {
        HttpURLConnection con = null;
        try {
            URL url = new URL(bytesToString(urlBytes));
            con = (HttpURLConnection) url.openConnection();
            con.setConnectTimeout(timeout * 1000);
            con.setRequestMethod(bytesToString(methodBytes));
            String[] headers = bytesToString(headerBytes).split("\n");
            if (headers.length >= 2) for (int i = 0; i < headers.length; i += 2) {
                con.setRequestProperty(headers[i], headers[i + 1]);
            }
            con.setDoOutput(dataFnBytes != null);
            con.setDoInput(outFnBytes != null);
            if (dataFnBytes != null) {
                FileInputStream fis = new FileInputStream(bytesToString(dataFnBytes));
                OutputStream os = con.getOutputStream();
                copy(fis, os);
                fis.close();
                os.close();
            }

            int st = con.getResponseCode();

            if (outFnBytes != null) {
                InputStream is;
                if (st == 200) is = con.getInputStream();
                else is = con.getErrorStream();
                if (is != null) {
                    FileOutputStream fos = new FileOutputStream(bytesToString(outFnBytes));
                    copy(is, fos);
                    is.close();
                    fos.close();
                }
            }
            return st;
        } catch (Exception e) {
            return 0;
        } finally {
            if (con != null) con.disconnect();
        }
    }

    /* saf -- storage access framework */
    String uriString;
    private CountDownLatch latch;

    private void initLatch() {
        latch = new CountDownLatch(1);
    }

    void countDownLatch() {
        latch.countDown();
    }

    private void waitLatch() {
        try {
            latch.await();
        } catch (InterruptedException e) {
            //do nothing
        }
    }

    @SuppressWarnings({"UnusedDeclaration"})
    @Keep
    byte[] safOpenDocumentTree() {
        try {
            initLatch();
            Intent i = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
            mulkActivity.startActivityForResult(i, MainActivity.OPEN_DOCUMENT_TREE);
            waitLatch();
            if (uriString == null) return null;
            return stringToBytes(uriString);
        } catch (Exception e) {
            return null;
        }
    }

    private List<DocumentFileEntry> documentFiles;

    private DocumentFileEntry findEntry(String path) {
        for (int i = 0; i < documentFiles.size(); i++) {
            DocumentFileEntry e = documentFiles.get(i);
            if (e.path.equals(path)) {
                documentFiles.remove(i);
                return e;
            }
        }
        return null;
    }

    private DocumentFile getDocumentFile(String uriString, String path) {
        if (documentFiles == null) documentFiles = new ArrayList<>();
        DocumentFileEntry e = findEntry(path);
        if (e == null) {
            if (path.isEmpty()) {
                Uri uri = Uri.parse(uriString);
                e = new DocumentFileEntry(path, DocumentFile.fromTreeUri(mulkActivity, uri));
            } else {
                int pos = path.lastIndexOf('/');
                String parent;
                String name;
                if (pos == -1) {
                    parent = "";
                    name = path;
                } else {
                    parent = path.substring(0, pos);
                    name = path.substring(pos + 1);
                }
                e = new DocumentFileEntry(path, getDocumentFile(uriString, parent).findFile(name));
            }
        }
        documentFiles.add(0, e);
        if (documentFiles.size() == 10) documentFiles.remove(9);
        return e.df;
    }

    private DocumentFile getDocumentFile(byte[] uriBytes, byte[] pathBytes) {
        return getDocumentFile(bytesToString(uriBytes), bytesToString(pathBytes));
    }

    /* see pf.h */
    static private final int PF_FILE = 2;
    static private final int PF_DIR = 4;
    static private final int PF_OTHER = 8;
    static private final int PF_READABLE = 16;
    static private final int PF_WRITABLE = 32;

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    byte[] safStat(byte[] uriBytes, byte[] pathBytes) {
        DocumentFile df = getDocumentFile(uriBytes, pathBytes);
        if (df == null) return null;
        byte mode;
        if (df.isFile()) mode = PF_FILE;
        else if (df.isDirectory()) mode = PF_DIR;
        else mode = PF_OTHER;
        if (df.canRead()) mode += PF_READABLE;
        if (df.canWrite()) mode += PF_WRITABLE;

        ByteBuffer buf = ByteBuffer.allocate(17);
        buf.order(ByteOrder.LITTLE_ENDIAN);
        buf.put(0, mode);
        buf.putLong(1, df.length());
        buf.putLong(9, df.lastModified());
        return buf.array();
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    byte[] safReaddir(byte[] uriBytes, byte[] pathBytes) {
        DocumentFile df = getDocumentFile(uriBytes, pathBytes);
        if (df == null) return null;
        StringBuilder sb = new StringBuilder();
        for (DocumentFile f : df.listFiles()) {
            sb.append(f.getName());
            sb.append('\n');
        }
        return stringToBytes(sb.toString());
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int safMkdir(byte[] uriBytes, byte[] pathBytes, byte[] nameBytes) {
        DocumentFile df = getDocumentFile(uriBytes, pathBytes);
        if (df == null) return 0;
        df = df.createDirectory(bytesToString(nameBytes));
        if (df == null) return 0;
        documentFiles.clear();
        return 1;
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int safRemove(byte[] uriBytes, byte[] pathBytes) {
        DocumentFile df = getDocumentFile(uriBytes, pathBytes);
        if (df == null) return 0;
        documentFiles.clear();
        if (df.delete()) return 1;
        else return 0;
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int safReadAll(byte[] uriBytes, byte[] pathBytes, byte[] buf) {
        try {
            DocumentFile df = getDocumentFile(uriBytes, pathBytes);
            if (df == null) return 0;
            InputStream is = mulkActivity.getContentResolver().openInputStream(df.getUri());
            int sz = (int) df.length();
            int rd = Objects.requireNonNull(is).read(buf, 0, sz);
            is.close();
            if (sz == rd) return 1;
            else return 0;
        } catch (Exception e) {
            return 0;
        }
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    int safWriteAll(byte[] uriBytes, byte[] pathBytes, byte[] nameBytes, byte[] buf, int size) {
        try {
            DocumentFile pdf = getDocumentFile(uriBytes, pathBytes);
            if (pdf == null) return 0;
            String name = bytesToString(nameBytes);
            DocumentFile df = pdf.findFile(name);
            if (df == null) {
                df = pdf.createFile("application/vnd.mulk", name);
                if (df == null) return 0;
                documentFiles.clear();
            }
            OutputStream os = mulkActivity.getContentResolver().openOutputStream(df.getUri());
            Objects.requireNonNull(os).write(buf, 0, size);
            os.close();
            return 1;
        } catch (Exception e) {
            return 0;
        }
    }

    /* sound */
    private AudioTrack audio;
    private static final int srate = 44100;

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void soundOpen() {
        int sz = AudioTrack.getMinBufferSize(srate, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
        AudioManager mg = (AudioManager) mulkActivity.getSystemService(Context.AUDIO_SERVICE);
        audio = new AudioTrack(
                new AudioAttributes.Builder().
                        setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).
                        setUsage(AudioAttributes.USAGE_MEDIA).
                        //setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED).
                                build(),
                new AudioFormat.Builder().
                        setSampleRate(srate).
                        setEncoding(AudioFormat.ENCODING_PCM_16BIT).
                        setChannelMask(AudioFormat.CHANNEL_OUT_MONO).build(),
                sz,
                AudioTrack.MODE_STREAM,
                Objects.requireNonNull(mg).generateAudioSessionId());
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void soundPlay(int freq, double sec) {
        long now = System.currentTimeMillis();
        int len = (int) (srate * sec);
        short[] buf = new short[len];
        int wlen2 = srate / freq / 2;
        for (int i = 0; i < len; i++) {
            if (i / wlen2 % 2 == 0) buf[i] = Short.MAX_VALUE;
            else buf[i] = Short.MIN_VALUE;
        }

        audio.play();
        audio.write(buf, 0, len);

        try {
            sleep(now + (int) (sec * 1000) - System.currentTimeMillis());
        } catch (InterruptedException ignored) {
        }
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void soundClose() {
        audio.release();
        audio = null;
    }

    /* dir */
    @SuppressWarnings("UnusedDeclaration")
    @Keep
    byte[] getFilesDir() {
        return stringToBytes(mulkActivity.getFilesDir().getAbsolutePath());
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    byte[] getExternalFilesDirs() {
        File[] files = mulkActivity.getExternalFilesDirs(null);
        if (files == null) return null;
        StringBuilder sb = new StringBuilder();
        for (File f : files) {
            sb.append(f.getAbsolutePath());
            sb.append('\n');
        }
        return stringToBytes(sb.toString());
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    byte[] getExternalStoragePublicDirectory() {
        return stringToBytes(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS).getAbsolutePath());
    }

    /* zip */
    @SuppressWarnings("UnusedDeclaration")
    @Keep
    byte[] zipCompress(byte[] src) {
        try {
            Deflater deflater = new Deflater(Deflater.DEFAULT_COMPRESSION, true);
            deflater.setInput(src);
            deflater.finish();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] buf = new byte[BUFSIZE];
            int sz;
            while ((sz = deflater.deflate(buf)) != 0) baos.write(buf, 0, sz);
            baos.close();
            if (baos.size() >= src.length) return null;
            else return baos.toByteArray();
        } catch (Exception e) {
            return null;
        }
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    long zipCrc32(byte[] src) {
        CRC32 crc32 = new CRC32();
        crc32.update(src);
        return crc32.getValue();
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    byte[] zipUncompress(byte[] src) {
        Inflater inflater = new Inflater(true);
        try {
            inflater.setInput(src);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] buf = new byte[BUFSIZE];
            int sz;
            while ((sz = inflater.inflate(buf)) != 0) baos.write(buf, 0, sz);
            baos.close();
            return baos.toByteArray();
        } catch (Exception e) {
            return null;
        }
    }

    /* clipboard */
    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void clipPut(byte[] bytes) {
        String s = bytesToString(bytes);
        mulkActivity.handler.post(() -> {
            ClipboardManager cm = (ClipboardManager) mulkActivity.getSystemService(Context.CLIPBOARD_SERVICE);
            ClipData cd = ClipData.newPlainText("label", bytesToString(bytes));
            cm.setPrimaryClip(cd);
        });
    }

    private byte[] clipBytes;

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    byte[] clipGet() {
        initLatch();
        mulkActivity.handler.post(() -> {
            ClipboardManager cm = (ClipboardManager) mulkActivity.getSystemService(Context.CLIPBOARD_SERVICE);
            ContentResolver cr = mulkActivity.getContentResolver();
            ClipData cd = cm.getPrimaryClip();
            if (cd != null) {
                ClipData.Item item = cd.getItemAt(0);
                clipBytes = stringToBytes(item.getText().toString());
            }
            countDownLatch();
        });
        waitLatch();
        return clipBytes;
    }

    @SuppressWarnings("UnusedDeclaration")
    @Keep
    void openUrl(byte[] urlBytes) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(bytesToString(urlBytes)));
        mulkActivity.startActivity(intent);
    }

    /**/
    native void xmain(String imageFile);

    public void run() {
        waitForWakeup();

        keyboardView.initKeyboard();

        charx = 0;
        chary = 0;

        xmain(mulkActivity.getImageFile());

        putString("!terminate mulk.");
    }

    public native void trap(int code);

    static {
        System.loadLibrary("mulk");
    }
}
