package com.adobe.air;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.WakefulBroadcastReceiver;

/* loaded from: classes.dex */
public class AndroidGcmBroadcastReceiver extends WakefulBroadcastReceiver {
    @Override // android.content.BroadcastReceiver
    public void onReceive(Context context, Intent intent) {
        startWakefulService(context, intent.setComponent(new ComponentName(context.getPackageName(), AndroidGcmIntentService.class.getName())));
        setResultCode(-1);
    }
}
