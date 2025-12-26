package com.codapayments.sdk.b;

import android.content.Intent;
import android.os.AsyncTask;
import android.util.Log;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.model.f;
import com.codapayments.sdk.model.g;
import com.codapayments.sdk.pay.CodaWeb;

/* loaded from: classes.dex */
public class c extends AsyncTask {
    private g a;
    private CodaSDK b;

    public c(g gVar, CodaSDK codaSDK) {
        this.a = gVar;
        this.b = codaSDK;
    }

    private String a() {
        try {
            com.codapayments.sdk.a.a aVarA = this.b.a();
            com.codapayments.sdk.model.d dVarB = aVarA.b();
            if (dVarB.h() == null || dVarB.h().length() <= 0) {
                return null;
            }
            for (String str : dVarB.h().split(",")) {
                if (this.a.a().equals(str)) {
                    f fVarA = aVarA.a(this.a);
                    if (fVarA.b() == 0) {
                        String strC = fVarA.c();
                        Log.i(c.class.getSimpleName(), "OTP Url : " + strC);
                        Intent intent = new Intent(this.b.b(), (Class<?>) CodaWeb.class);
                        intent.putExtra("URL", strC);
                        intent.putExtra("txnId", fVarA.a());
                        d.a.put(Long.valueOf(fVarA.a()), this.b);
                        this.b.b().startActivity(intent);
                    }
                }
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override // android.os.AsyncTask
    protected /* synthetic */ Object doInBackground(Object... objArr) {
        return a();
    }
}
