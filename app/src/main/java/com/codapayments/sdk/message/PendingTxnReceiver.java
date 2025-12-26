package com.codapayments.sdk.message;

import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import com.adobe.air.wand.view.CompanionView;
import com.codapayments.sdk.b.e;
import com.codapayments.sdk.c.f;

/* loaded from: classes.dex */
public class PendingTxnReceiver extends BroadcastReceiver {
    private Context a;

    private Context a() {
        return this.a;
    }

    private boolean b() {
        return ((ActivityManager) this.a.getSystemService("activity")).getRunningTasks(Integer.MAX_VALUE).get(0).topActivity.getPackageName().toString().equalsIgnoreCase(this.a.getPackageName().toString());
    }

    @Override // android.content.BroadcastReceiver
    public void onReceive(Context context, Intent intent) {
        this.a = context;
        if (((ActivityManager) this.a.getSystemService("activity")).getRunningTasks(Integer.MAX_VALUE).get(0).topActivity.getPackageName().toString().equalsIgnoreCase(this.a.getPackageName().toString())) {
            new e(context, intent).execute(new String[0]);
        } else {
            ((AlarmManager) context.getSystemService("alarm")).set(0, System.currentTimeMillis() + f.u, PendingIntent.getBroadcast(context, 0, intent, CompanionView.kTouchMetaStateSideButton1));
        }
    }
}
