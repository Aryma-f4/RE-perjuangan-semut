package com.adobe.air;

import android.os.Bundle;
import android.os.Handler;
import android.os.ResultReceiver;

/* loaded from: classes.dex */
public class AndroidGcmResultReceiver extends ResultReceiver {
    private Receiver mReceiver;

    public interface Receiver {
        void onReceiveResult(int i, Bundle bundle);
    }

    public AndroidGcmResultReceiver(Handler handler) {
        super(handler);
        this.mReceiver = null;
    }

    public void setReceiver(Receiver receiver) {
        this.mReceiver = receiver;
    }

    @Override // android.os.ResultReceiver
    protected void onReceiveResult(int i, Bundle bundle) {
        if (this.mReceiver != null) {
            this.mReceiver.onReceiveResult(i, bundle);
        }
    }
}
