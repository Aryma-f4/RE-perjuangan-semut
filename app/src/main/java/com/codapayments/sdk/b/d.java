package com.codapayments.sdk.b;

import android.content.Intent;
import android.os.AsyncTask;
import android.util.Log;
import com.adobe.air.wand.view.CompanionView;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.c.k;
import com.codapayments.sdk.pay.CodaWeb;
import java.util.HashMap;
import java.util.Map;

/* loaded from: classes.dex */
public final class d extends AsyncTask {
    public static Map a = new HashMap();
    private com.codapayments.sdk.model.c b;
    private com.codapayments.sdk.message.a c;
    private CodaSDK d;
    private String e;

    public d(String str, com.codapayments.sdk.model.c cVar, CodaSDK codaSDK) {
        this.b = cVar;
        this.d = codaSDK;
        this.e = str;
    }

    private String a() {
        com.codapayments.sdk.a.a aVarA = this.d.a();
        this.c = new com.codapayments.sdk.message.a(this.d.b());
        Log.i(f.H, "InitResult: " + aVarA.a(this.e, this.b).toString());
        return null;
    }

    private void a(String str) {
        super.onPostExecute(str);
        com.codapayments.sdk.model.d dVarB = this.d.a().b();
        if (dVarB.b() != 0) {
            com.codapayments.sdk.c.c.a(this.d.b(), dVarB.i(), dVarB.c(), "OK");
            return;
        }
        String strH = dVarB.h();
        String strG = dVarB.g();
        if (strH != null && strH.length() > 0 && strG != null && strG.length() > 0) {
            Log.i(f.H, "Sending SMS to " + strH);
            this.c.a(strH, strG);
            this.c.a();
            this.c.b();
            k.a(this.d.b().getContentResolver(), strH, strG);
        }
        if (CodaSDK.a != null && CodaSDK.a.isShowing()) {
            CodaSDK.a.dismiss();
            CodaSDK.a = null;
        }
        String strD = dVarB.d();
        Intent intent = new Intent(this.d.b(), (Class<?>) CodaWeb.class);
        intent.putExtra("URL", strD);
        intent.putExtra("txnId", dVarB.a());
        intent.addFlags(CompanionView.kTouchMetaStateIsEraser);
        intent.addFlags(268435456);
        a.put(Long.valueOf(dVarB.a()), this.d);
        this.d.b().startActivity(intent);
    }

    @Override // android.os.AsyncTask
    protected final /* synthetic */ Object doInBackground(Object... objArr) {
        com.codapayments.sdk.a.a aVarA = this.d.a();
        this.c = new com.codapayments.sdk.message.a(this.d.b());
        Log.i(f.H, "InitResult: " + aVarA.a(this.e, this.b).toString());
        return null;
    }

    @Override // android.os.AsyncTask
    protected final /* synthetic */ void onPostExecute(Object obj) {
        super.onPostExecute((String) obj);
        com.codapayments.sdk.model.d dVarB = this.d.a().b();
        if (dVarB.b() != 0) {
            com.codapayments.sdk.c.c.a(this.d.b(), dVarB.i(), dVarB.c(), "OK");
            return;
        }
        String strH = dVarB.h();
        String strG = dVarB.g();
        if (strH != null && strH.length() > 0 && strG != null && strG.length() > 0) {
            Log.i(f.H, "Sending SMS to " + strH);
            this.c.a(strH, strG);
            this.c.a();
            this.c.b();
            k.a(this.d.b().getContentResolver(), strH, strG);
        }
        if (CodaSDK.a != null && CodaSDK.a.isShowing()) {
            CodaSDK.a.dismiss();
            CodaSDK.a = null;
        }
        String strD = dVarB.d();
        Intent intent = new Intent(this.d.b(), (Class<?>) CodaWeb.class);
        intent.putExtra("URL", strD);
        intent.putExtra("txnId", dVarB.a());
        intent.addFlags(CompanionView.kTouchMetaStateIsEraser);
        intent.addFlags(268435456);
        a.put(Long.valueOf(dVarB.a()), this.d);
        this.d.b().startActivity(intent);
    }
}
