package com.codapayments.sdk.c;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;

/* loaded from: classes.dex */
public final class c {
    public static void a(Activity activity, String str, String str2, String str3) {
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        builder.setTitle(str);
        builder.setMessage(str2);
        builder.setPositiveButton(str3, new e(activity));
        builder.create().show();
    }

    public static void a(Context context, String str, String str2, String str3) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle(str);
        builder.setMessage(str2);
        builder.setPositiveButton(str3, new d());
        builder.create().show();
    }
}
