/*
    DocumentFileEntry class.
    $Id: mulk/android DocumentFileEntry.java 1442 2025-06-12 Thu 10:05:28 kt $
 */
package com.github.k_tokuok.mulk;

import androidx.documentfile.provider.DocumentFile;

class DocumentFileEntry {
    String path;
    DocumentFile df;

    DocumentFileEntry(String pathArg, DocumentFile dfArg) {
        path = pathArg;
        df = dfArg;
    }
}
