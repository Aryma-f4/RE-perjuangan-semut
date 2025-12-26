package com.codapayments.sdk.c;

import android.app.Activity;
import android.content.DialogInterface;

/* loaded from: classes.dex */
final class e implements DialogInterface.OnClickListener {
    private final /* synthetic */ Activity a;

    e(Activity activity) {
        this.a = activity;
    }

    @Override // android.content.DialogInterface.OnClickListener
    public final void onClick(DialogInterface dialogInterface, int i) {
        this.a.finish();
    }
}
