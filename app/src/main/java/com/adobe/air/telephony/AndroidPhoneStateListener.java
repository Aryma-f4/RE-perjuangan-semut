package com.adobe.air.telephony;

import android.telephony.PhoneStateListener;

/* compiled from: AndroidTelephonyManager.java */
/* loaded from: classes.dex */
class AndroidPhoneStateListener extends PhoneStateListener {
    private native void nativeOnCallStateChanged(int i);

    AndroidPhoneStateListener() {
    }

    @Override // android.telephony.PhoneStateListener
    public void onCallStateChanged(int i, String str) {
        nativeOnCallStateChanged(toAIRCallState(i));
    }

    private int toAIRCallState(int i) {
        if ((i & 1) == 1) {
            return 1;
        }
        return (i & 2) == 2 ? 2 : 0;
    }
}
