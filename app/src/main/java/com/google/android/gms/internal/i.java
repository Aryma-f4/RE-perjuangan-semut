package com.google.android.gms.internal;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.util.Log;

/* loaded from: classes.dex */
public class i implements DialogInterface.OnClickListener {
    private final Activity bm;
    private final int bn;
    private final Intent mIntent;

    public i(Activity activity, Intent intent, int i) {
        this.bm = activity;
        this.mIntent = intent;
        this.bn = i;
    }

    @Override // android.content.DialogInterface.OnClickListener
    public void onClick(DialogInterface dialog, int which) {
        try {
            if (this.mIntent != null) {
                this.bm.startActivityForResult(this.mIntent, this.bn);
            }
            dialog.dismiss();
        } catch (ActivityNotFoundException e) {
            Log.e("SettingsRedirect", "Can't redirect to app settings for Google Play services");
        }
    }
}
