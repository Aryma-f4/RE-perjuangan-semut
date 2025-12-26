package com.codapayments.sdk.pay;

import android.util.Log;
import android.webkit.JavascriptInterface;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.c.f;

/* loaded from: classes.dex */
public class CodaWebInterface {
    private CodaSDK a;

    public CodaWebInterface(CodaSDK codaSDK) {
        this.a = codaSDK;
    }

    @JavascriptInterface
    public void closeWebview() {
        try {
            Log.i(f.E, "closeWebview");
            new com.codapayments.sdk.b.b(this.a).execute(new String[0]);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @JavascriptInterface
    public void txnCompleted() {
        try {
            Log.i(f.E, "txnCompleted");
            new com.codapayments.sdk.b.a(this.a).execute(new String[0]);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
