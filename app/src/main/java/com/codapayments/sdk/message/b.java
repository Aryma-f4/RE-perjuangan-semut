package com.codapayments.sdk.message;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import com.codapayments.sdk.c.f;

/* loaded from: classes.dex */
final class b extends BroadcastReceiver {
    private /* synthetic */ a a;

    b(a aVar) {
    }

    @Override // android.content.BroadcastReceiver
    public final void onReceive(Context context, Intent intent) {
        switch (getResultCode()) {
            case -1:
                Log.i(f.B, "Send SMS");
                break;
            case 1:
                Log.i(f.B, "Generic failure");
                break;
            case 2:
                Log.i(f.B, "Radio off");
                break;
            case 3:
                Log.i(f.B, "Null PDU");
                break;
            case 4:
                Log.i(f.B, "No service");
                break;
        }
    }
}
