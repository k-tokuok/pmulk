/*
    SettingsActivity.
    $Id: mulk/android SettingsActivity.java 1442 2025-06-12 Thu 10:05:28 kt $
 */
package com.github.k_tokuok.mulk;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

public class SettingsActivity extends AppCompatActivity {
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getSupportFragmentManager()
                .beginTransaction()
                .replace(android.R.id.content, new SettingsFragment())
                .commit();
    }
}
