package com.codapayments.sdk;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;
import com.codapayments.sdk.a.a.a;
import com.codapayments.sdk.b.d;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.c.g;
import com.codapayments.sdk.model.PayInfo;
import com.codapayments.sdk.model.c;
import java.io.Serializable;

/* loaded from: classes.dex */
public class CodaSDK implements Serializable {
    public static ProgressDialog a = null;
    private static final long b = -6780372747548916219L;
    private a c;
    private com.codapayments.sdk.model.a d;
    private com.codapayments.sdk.a.a e;
    private Context f;
    private Activity g;
    private Class h;
    private c i;

    private CodaSDK() {
    }

    private CodaSDK(Context context, Class cls) {
        this.h = cls;
        this.f = context;
    }

    private void a(Class cls) {
        this.h = cls;
    }

    public static CodaSDK getInstance(Context context, Class cls) {
        return new CodaSDK(context, cls);
    }

    public final com.codapayments.sdk.a.a a() {
        return this.e;
    }

    public final void a(Activity activity) {
        this.g = activity;
    }

    public final Context b() {
        return this.f;
    }

    public final Activity c() {
        return this.g;
    }

    public final Class d() {
        return this.h;
    }

    public void pay(PayInfo payInfo) {
        try {
            if (g.a(this.f) == 0) {
                Log.e(f.v, "Network Error: Please enable Wifi or Mobile Data to make purchase. ");
                com.codapayments.sdk.c.c.a(this.f, "Network Error", "Please enable Wifi or Mobile Data to make purchase.", "OK");
                return;
            }
            if (a == null) {
                ProgressDialog progressDialog = new ProgressDialog(this.f);
                a = progressDialog;
                progressDialog.setMessage("Initialising...");
                a.setCanceledOnTouchOutside(false);
                a.setCancelable(false);
                a.show();
            }
            if (this.e == null) {
                this.e = com.codapayments.sdk.a.a.a(payInfo.getEnvironment(), this);
            }
            if (this.d == null && this.c == null) {
                this.d = new com.codapayments.sdk.model.a();
                this.c = new a(this.f);
                this.d = this.c.r();
            }
            if (this.i == null) {
                this.i = new c();
                this.i.a(this.d);
                this.i.a(payInfo.getItems());
                this.i.a(payInfo.getOrderId());
                this.i.b(payInfo.getCurrency());
                this.i.c((short) 2);
                this.i.a(payInfo.getCountry());
            }
            d dVar = new d(payInfo.getApiKey(), this.i, this);
            AsyncTask.Status status = dVar.getStatus();
            dVar.getStatus();
            if (status == AsyncTask.Status.PENDING) {
                Log.i(f.v, "BEGINNING ASYNCTASK");
                dVar.execute(new String[0]);
                return;
            }
            AsyncTask.Status status2 = dVar.getStatus();
            dVar.getStatus();
            if (status2 == AsyncTask.Status.RUNNING) {
                Log.i(f.v, "RUNNING ASYNCTASK");
                Toast.makeText(this.f, "Your transaction on process..", 0).show();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
