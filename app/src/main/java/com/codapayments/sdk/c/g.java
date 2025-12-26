package com.codapayments.sdk.c;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

/* loaded from: classes.dex */
public final class g {
    private static int b = 1;
    private static int c = 2;
    public static int a = 0;

    public static int a(Context context) {
        NetworkInfo activeNetworkInfo = ((ConnectivityManager) context.getSystemService("connectivity")).getActiveNetworkInfo();
        if (activeNetworkInfo != null) {
            if (activeNetworkInfo.getType() == 1) {
                return b;
            }
            if (activeNetworkInfo.getType() == 0) {
                return c;
            }
        }
        return 0;
    }
}
