/*
    MainActivity class.
    $Id: mulk/android MainActivity.java 1512 2026-01-03 Sat 13:02:28 kt $
 */
package com.github.k_tokuok.mulk;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.net.Uri;
import android.os.Bundle;

import androidx.preference.PreferenceManager;

import android.os.Looper;
import android.util.Log;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.os.Handler;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Objects;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class MainActivity extends Activity
        implements SharedPreferences.OnSharedPreferenceChangeListener, DialogInterface.OnClickListener {
    Main main;
    DisplayView displayView;
    KeyboardView keyboardView;
    Handler handler;

    void startMulk() {
        extractMulka0();

        keyboardView = new KeyboardView(this);
        displayView = new DisplayView(this);
        FrameLayout fl = new FrameLayout(this);
        fl.addView(displayView);
        fl.addView(keyboardView);
        setContentView(fl);

        handler = new Handler(Objects.requireNonNull(Looper.myLooper()));

        main = new Main(this, keyboardView, displayView);
        main.start();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        PreferenceManager.getDefaultSharedPreferences(this).registerOnSharedPreferenceChangeListener(this);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        startMulk();
    }

    void finishMulk() {
        if (main.getState() != Thread.State.TERMINATED) {
            main.trap(2); //TRAP_QUIT
            keyboardView.addQueueChar('\0');
        }
        try {
            main.join();
        } catch (InterruptedException e) {
            //do nothing
        }
    }

    void ctrlc() {
        main.trap(1); //TRAP_INTERRUPT
    }

    public void onClick(DialogInterface dialog, int which) {
        switch (which) {
            case 0:
                ctrlc();
                break;
            case 1:
                finishMulk();
                startMulk();
                break;
            case 2:
                startActivity(new Intent(this, SettingsActivity.class));
                break;
        }
    }

    public void showMenu() {
        final String[] items = {"^c", "reset", "prefs..."};
        AlertDialog.Builder ab = new AlertDialog.Builder(this);
        ab.setTitle("Menu");
        ab.setItems(items, this);
        ab.show();
    }

    /* preferences */
    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences,
                                          String key) {
        keyboardView.postInvalidate();
        keyboardView.setKeyboardListener();
        keyboardView.layoutKeys();
    }

    void setImageFile(String path) {
        SharedPreferences p = PreferenceManager.getDefaultSharedPreferences(this);
        SharedPreferences.Editor e = p.edit();
        e.putString("imageFile", path);
        e.apply();
    }

    String getImageFile() {
        return PreferenceManager.getDefaultSharedPreferences(this).getString("imageFile", "");
    }

    boolean useKeymap() {
        return PreferenceManager.getDefaultSharedPreferences(this).getBoolean("useKeymap", false);
    }

    String getKeymapFile() {
        return PreferenceManager.getDefaultSharedPreferences(this).getString("keymapFile", "");
    }

    boolean enableSoftwareKeyboard() {
        return PreferenceManager.getDefaultSharedPreferences(this).getBoolean("enableSoftwareKeyboard", true);
    }

    boolean isExtractMulka0() {
        return PreferenceManager.getDefaultSharedPreferences(this).getBoolean("extractMulka0", true);
    }

    void disableExtractMulka0() {
        SharedPreferences.Editor e = PreferenceManager.getDefaultSharedPreferences(this).edit();
        e.putBoolean("extractMulka0", false);
        e.apply();
    }

    /* extract assets/mulk0.zip */
    void extractMulka0() {
        if (!isExtractMulka0()) return;
        try {
            AssetManager am = getResources().getAssets();
            InputStream is = am.open("mulka0.zip");
            ZipInputStream zis = new ZipInputStream(is);
            ZipEntry ze;
            byte[] buf = new byte[4096];
            File mulka0Dir = new File(getFilesDir(), "mulka0");
            if (mulka0Dir.isDirectory()) {
                File[] files = mulka0Dir.listFiles();
                if (files != null) {
                    for (File f : files) {
                        if (!f.delete()) throw new Exception("File#delete() failed.");
                    }
                }
            } else if (!mulka0Dir.mkdir()) throw new Exception("File#mkdir() failed.");
            while ((ze = zis.getNextEntry()) != null) {
                File file = new File(mulka0Dir, ze.getName());
                FileOutputStream fos = new FileOutputStream(file);
                int size;
                while ((size = zis.read(buf)) != -1) fos.write(buf, 0, size);
                fos.close();
                zis.closeEntry();
            }
            zis.close();
            setImageFile((new File(mulka0Dir, "base.mi")).getAbsolutePath());
            disableExtractMulka0();
        } catch (Exception e) {
            Log.d("mulk", e.toString());
        }
    }

    /* storage access framework */
    static final int OPEN_DOCUMENT_TREE = 1;

    protected void onActivityResult(int requestCode, int resultCode, Intent resultData) {
        if (requestCode == OPEN_DOCUMENT_TREE) {
            if (resultCode == RESULT_OK) {
                Uri uri = resultData.getData();
                assert uri != null;
                getContentResolver().takePersistableUriPermission(uri,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                main.uriString = uri.toString();
            } else main.uriString = null;
            main.countDownLatch();
        }
    }
}
