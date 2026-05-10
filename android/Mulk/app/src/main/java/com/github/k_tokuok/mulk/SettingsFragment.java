/*
    SettingsFragment class.
    $Id: mulk/android SettingsFragment.java 1442 2025-06-12 Thu 10:05:28 kt $
 */
package com.github.k_tokuok.mulk;

import android.os.Bundle;
import androidx.preference.PreferenceFragmentCompat;

import com.github.k_tokuok.mulk.R;

public class SettingsFragment extends PreferenceFragmentCompat {
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        setPreferencesFromResource(R.xml.prefs, rootKey);
    }
}
