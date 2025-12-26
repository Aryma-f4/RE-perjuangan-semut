package com.adobe.air;

import android.content.SharedPreferences;
import android.util.Base64;

/* loaded from: classes.dex */
class AndroidEncryptedLocalStore {
    private static final String LOG_TAG = "AndroidELS -------";

    AndroidEncryptedLocalStore() {
    }

    public boolean setItem(String str, String str2, byte[] bArr) throws OutOfMemoryError {
        String strEncodeToString = Base64.encodeToString(bArr, 0);
        SharedPreferences.Editor editorEdit = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getApplicationContext().getSharedPreferences(str, 0).edit();
        editorEdit.putString(str2, strEncodeToString);
        return editorEdit.commit();
    }

    public byte[] getItem(String str, String str2) throws OutOfMemoryError {
        String string = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getApplicationContext().getSharedPreferences(str, 0).getString(str2, null);
        if (string != null) {
            return Base64.decode(string, 0);
        }
        return null;
    }

    public boolean removeItem(String str, String str2) {
        SharedPreferences.Editor editorEdit = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getApplicationContext().getSharedPreferences(str, 0).edit();
        editorEdit.remove(str2);
        return editorEdit.commit();
    }

    public boolean reset(String str) {
        SharedPreferences.Editor editorEdit = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity().getApplicationContext().getSharedPreferences(str, 0).edit();
        editorEdit.clear();
        return editorEdit.commit();
    }
}
