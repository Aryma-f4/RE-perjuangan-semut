package com.codapayments.sdk.b;

import android.os.AsyncTask;
import android.util.Log;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.interfaces.PaymentResultHandler;
import com.codapayments.sdk.model.PayResult;

/* loaded from: classes.dex */
public final class a extends AsyncTask {
    private com.codapayments.sdk.model.e a;
    private CodaSDK b;

    public a(CodaSDK codaSDK) {
        this.b = codaSDK;
    }

    private String a() {
        com.codapayments.sdk.a.a aVarA = this.b.a();
        com.codapayments.sdk.model.d dVarB = aVarA.b();
        long jA = dVarB.a();
        String strE = dVarB.e();
        Log.i(f.F, "CodaSDK Transaction Id : " + String.valueOf(jA));
        Log.i(f.F, "CodaSDK Encrypted Keyyyyyy : " + strE);
        this.a = aVarA.a(jA, strE);
        return null;
    }

    private void a(String str) {
        super.onPostExecute(str);
        PayResult payResultC = this.a.c();
        Log.i(f.F, "PayResult : " + payResultC.toString());
        try {
            ((PaymentResultHandler) this.b.d().newInstance()).handleResult(payResultC);
        } catch (IllegalAccessException e) {
            Log.e(f.J, e + " Interpreter class must have a no-arg constructor.");
        } catch (InstantiationException e2) {
            Log.e(f.J, e2 + " Interpreter class must be concrete.");
        }
    }

    @Override // android.os.AsyncTask
    protected final /* synthetic */ Object doInBackground(Object... objArr) {
        com.codapayments.sdk.a.a aVarA = this.b.a();
        com.codapayments.sdk.model.d dVarB = aVarA.b();
        long jA = dVarB.a();
        String strE = dVarB.e();
        Log.i(f.F, "CodaSDK Transaction Id : " + String.valueOf(jA));
        Log.i(f.F, "CodaSDK Encrypted Keyyyyyy : " + strE);
        this.a = aVarA.a(jA, strE);
        return null;
    }

    @Override // android.os.AsyncTask
    protected final /* synthetic */ void onPostExecute(Object obj) {
        super.onPostExecute((String) obj);
        PayResult payResultC = this.a.c();
        Log.i(f.F, "PayResult : " + payResultC.toString());
        try {
            ((PaymentResultHandler) this.b.d().newInstance()).handleResult(payResultC);
        } catch (IllegalAccessException e) {
            Log.e(f.J, e + " Interpreter class must have a no-arg constructor.");
        } catch (InstantiationException e2) {
            Log.e(f.J, e2 + " Interpreter class must be concrete.");
        }
    }
}
