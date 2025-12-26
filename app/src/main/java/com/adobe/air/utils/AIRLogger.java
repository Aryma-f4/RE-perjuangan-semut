package com.adobe.air.utils;

import android.util.Log;

/* loaded from: classes.dex */
public class AIRLogger {
    static boolean g_enableReleaseLogging = false;
    private static String mflag = Utils.GetExternalStorageDirectory() + "/.AIR/enable_logging";

    public static void Enable(boolean z) {
        g_enableReleaseLogging = z;
        Log.v("Release Logging: ", "enabled = " + g_enableReleaseLogging);
    }

    public static boolean isEnabled() {
        return g_enableReleaseLogging;
    }

    public static int d(String str, String str2, Throwable th) {
        if (g_enableReleaseLogging) {
            return Log.d(str, str2, th);
        }
        return 0;
    }

    public static int d(String str, String str2) {
        if (g_enableReleaseLogging) {
            return Log.d(str, str2);
        }
        return 0;
    }

    public static int e(String str, String str2) {
        if (g_enableReleaseLogging) {
            return Log.e(str, str2);
        }
        return 0;
    }

    public static int e(String str, String str2, Throwable th) {
        if (g_enableReleaseLogging) {
            return Log.e(str, str2, th);
        }
        return 0;
    }

    public static int i(String str, String str2, Throwable th) {
        if (g_enableReleaseLogging) {
            return Log.i(str, str2, th);
        }
        return 0;
    }

    public static int i(String str, String str2) {
        if (g_enableReleaseLogging) {
            return Log.i(str, str2);
        }
        return 0;
    }

    public static int v(String str, String str2, Throwable th) {
        if (g_enableReleaseLogging) {
            return Log.v(str, str2, th);
        }
        return 0;
    }

    public static int v(String str, String str2) {
        if (g_enableReleaseLogging) {
            return Log.v(str, str2);
        }
        return 0;
    }

    public static int w(String str, String str2) {
        if (g_enableReleaseLogging) {
            return Log.w(str, str2);
        }
        return 0;
    }

    public static int w(String str, Throwable th) {
        if (g_enableReleaseLogging) {
            return Log.w(str, th);
        }
        return 0;
    }

    public static int w(String str, String str2, Throwable th) {
        if (g_enableReleaseLogging) {
            return Log.w(str, str2, th);
        }
        return 0;
    }

    public static int println(int i, String str, String str2) {
        if (g_enableReleaseLogging) {
            return Log.println(i, str, str2);
        }
        return 0;
    }

    public static boolean isLoggable(String str, int i) {
        if (g_enableReleaseLogging) {
            return Log.isLoggable(str, i);
        }
        return false;
    }
}
