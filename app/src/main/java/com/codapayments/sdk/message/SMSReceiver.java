package com.codapayments.sdk.message;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.util.Log;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.model.d;
import com.codapayments.sdk.model.g;

/* loaded from: classes.dex */
public class SMSReceiver extends BroadcastReceiver {
    private String a;
    private String b;
    private g c = new g();
    private CodaSDK d;

    public SMSReceiver(CodaSDK codaSDK) {
        this.d = codaSDK;
    }

    @Override // android.content.BroadcastReceiver
    public void onReceive(Context context, Intent intent) {
        Bundle extras;
        d dVarB = this.d.a().b();
        if (dVarB == null || !dVarB.f() || (extras = intent.getExtras()) == null) {
            return;
        }
        Object[] objArr = (Object[]) extras.get("pdus");
        SmsMessage[] smsMessageArr = new SmsMessage[objArr.length];
        for (int i = 0; i < smsMessageArr.length; i++) {
            smsMessageArr[i] = SmsMessage.createFromPdu((byte[]) objArr[i]);
            this.a = smsMessageArr[i].getOriginatingAddress();
            this.b = smsMessageArr[i].getMessageBody().toString();
            this.c.a(this.a);
            this.c.b(this.b);
        }
        Log.i(f.C, "From : " + this.c.a());
        Log.i(f.C, "Message : " + this.c.b());
        new com.codapayments.sdk.b.c(this.c, this.d).execute(new String[0]);
    }
}
