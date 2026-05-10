/*
    FullKeyboardLayout class.
    $Id: mulk/android FullKeyboardLayout.java 1536 2026-02-06 Fri 08:43:42 kt $
 */
package com.github.k_tokuok.mulk;

import java.util.ArrayList;
import java.util.List;

class FullKeyboardLayout extends KeyboardLayout {
    List<Key> createKeys() {
        keys = new ArrayList<>();

        addKey(0, 0, 'q', "q", 'Q', null, '1', "1", NCH, ctrl('q'), "/^q");
        addKey(1, 0, 'w', "w", 'W', null, '2', "2", ctrl('w'), NCH, null);
        addKey(2, 0, 'e', "e", 'E', null, '3', "3", ctrl('e'), NCH, null);
        addKey(3, 0, 'r', "r", 'R', null, '4', "4", ctrl('r'), NCH, null);
        addKey(4, 0, 't', "t", 'T', null, '5', "5", ctrl('t'), '~', "/~");
        addKey(5, 0, 'y', "y", 'Y', null, '6', "6", ctrl('y'), NCH, null);
        addKey(6, 0, 'u', "u", 'U', null, '7', "7", ctrl('u'), NCH, null);
        addKey(7, 0, 'i', "i", 'I', null, '8', "8", ctrl('i'), NCH, "Tb");
        addKey(8, 0, 'o', "o", 'O', null, '9', "9", ctrl('o'), NCH, null);
        addKey(9, 0, 'p', "p", 'P', null, '0', "0", ctrl('p'), NCH, null);

        addKey(0, 1, 'a', "a", 'A', null, '!', "!", NCH, ctrl('a'), "/^a");
        addKey(1, 1, 's', "s", 'S', null, '\"', "\"", ctrl('s'), ' ', "/Sp");
        addKey(2, 1, 'd', "d", 'D', null, '#', "#", ctrl('d'), NCH, null);
        addKey(3, 1, 'f', "f", 'F', null, '$', "$", ctrl('f'), NCH, null);
        addKey(4, 1, 'g', "g", 'G', null, '%', "%", ctrl('g'), '`', "/`");
        addKey(5, 1, 'h', "h", 'H', null, '&', "&", ctrl('h'), NCH, "Bs");
        addKey(6, 1, 'j', "j", 'J', null, '\'', "'", ctrl('j'), NCH, null);
        addKey(7, 1, 'k', "k", 'K', null, '(', "(", ctrl('k'), '{', "/{");
        addKey(8, 1, 'l', "l", 'L', null, ')', ")", ctrl('l'), '}', "/}");
        addKey(9, 1, ';', ";", '+', "+", ':', ":", NCH, NCH, null);

        addKey(0, 2, 'z', "z", 'Z', null, '*', "*", NCH, ctrl('z'), "/^z");
        addKey(1, 2, 'x', "x", 'X', null, '-', "-", ctrl('x'), NCH, null);
        addKey(2, 2, 'c', "c", 'C', null, '=', "=", ctrl('c'), NCH, null);
        addKey(3, 2, 'v', "v", 'V', null, '@', "@", ctrl('v'), ctrl('@'), "/^@");
        addKey(4, 2, 'b', "b", 'B', null, '\\', "\\", ctrl('b'), ctrl('\\'), "/^\\");
        addKey(5, 2, 'n', "n", 'N', null, '^', "^", ctrl('n'), ctrl('^'), "/^^");
        addKey(6, 2, 'm', "m", 'M', null, '_', "_", ctrl('m'), ctrl('_'), "En/^_");
        addKey(7, 2, ',', ",", '<', "<", '[', "[", ctrl('['), NCH, "Es");
        addKey(8, 2, '.', ".", '>', ">", ']', "]", ctrl(']'), NCH, "^]");
        addKey(9, 2, '/', "/", '?', "?", '|', "|", NCH, NCH, null);

        addKey(3, 3,4, ' ', null, NCH, null, NCH, null, NCH, NCH, null);
        addKey(8, 3, ctrl('m'), "En", NCH, null, NCH, null, NCH, NCH, null);
        addKey(9, 3, ctrl('h'), "Bs", NCH, null, NCH, null, NCH, NCH, null);

        return keys;
    }
}
