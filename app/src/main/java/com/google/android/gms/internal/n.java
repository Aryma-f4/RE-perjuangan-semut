package com.google.android.gms.internal;

import android.util.Log;

/* loaded from: classes.dex */
public final class n {
    private final String bX;

    public n(String str) {
        this.bX = (String) s.d(str);
    }

    public void a(String str, String str2) {
        if (l(3)) {
            Log.d(str, str2);
        }
    }

    public void a(String str, String str2, Throwable th) {
        if (l(6)) {
            Log.e(str, str2, th);
        }
    }

    public void b(String str, String str2) {
        if (l(5)) {
            Log.w(str, str2);
        }
    }

    public void c(String str, String str2) {
        if (l(6)) {
            Log.e(str, str2);
        }
    }

    public void d(String str, String str2) {
        if (l(4)) {
        }
    }

    public boolean l(int i) {
        return Log.isLoggable(this.bX, i);
    }
}
