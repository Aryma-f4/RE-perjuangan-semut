package com.codapayments.sdk.pay;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.media.TransportMediator;
import android.util.Log;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Toast;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.b.d;
import com.codapayments.sdk.c.f;

@SuppressLint({"SetJavaScriptEnabled"})
/* loaded from: classes.dex */
public class CodaWeb extends Activity {
    private WebView a;
    private CodaWebInterface b;
    private ProgressDialog c;
    private Intent d;
    private boolean e = true;
    private CodaSDK f;

    @Override // android.app.Activity
    public void onBackPressed() {
        Log.i(f.D, "OnBackPressed");
        Log.i(f.D, "OriginalUrl" + this.a.getOriginalUrl());
        String originalUrl = this.a.getOriginalUrl();
        if (originalUrl.contains("/airtime/m/start-txn") || originalUrl.contains("/airtime/m/input-msisdn") || originalUrl.contains("/airtime/m/terms-conditions")) {
            if (this.a.canGoBack()) {
                this.a.goBack();
            }
        } else {
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setTitle("Coda Validation");
            builder.setMessage("Do you want to cancel the transaction?");
            builder.setPositiveButton("Yes", new b(this));
            builder.setNegativeButton("No", new c(this));
            builder.create().show();
        }
    }

    @Override // android.app.Activity
    @SuppressLint({"NewApi"})
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        com.codapayments.sdk.c.a aVar = new com.codapayments.sdk.c.a(this);
        setContentView(aVar);
        this.a = aVar.a();
        this.d = getIntent();
        String stringExtra = this.d.getStringExtra("URL");
        this.f = (CodaSDK) d.a.remove(Long.valueOf(this.d.getLongExtra("txnId", 0L)));
        if (this.f != null) {
            this.f.a(this);
        }
        if (stringExtra == null) {
            Toast.makeText(this, "Unable continue the transaction!", 1).show();
            return;
        }
        try {
            this.b = new CodaWebInterface(this.f);
            WebSettings settings = this.a.getSettings();
            settings.setAppCacheEnabled(true);
            settings.setCacheMode(2);
            settings.setDomStorageEnabled(true);
            settings.setJavaScriptEnabled(true);
            this.a.setWebChromeClient(new WebChromeClient());
            settings.setLoadWithOverviewMode(true);
            settings.setUseWideViewPort(true);
            this.a.addJavascriptInterface(this.b, f.d);
            this.a.requestFocus(TransportMediator.KEYCODE_MEDIA_RECORD);
            this.a.setWebViewClient(new a(this));
            if (bundle != null) {
                this.a.restoreState(bundle);
            } else {
                this.a.loadUrl(stringExtra);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override // android.app.Activity
    protected void onDestroy() {
        super.onDestroy();
        Log.i(f.c, "onDestroy");
        try {
            if (this.c == null || !this.c.isShowing()) {
                return;
            }
            this.c.dismiss();
            this.c = null;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override // android.app.Activity
    protected void onPause() {
        super.onPause();
        try {
            Log.i(f.c, "onPause");
            if (this.c == null || !this.c.isShowing()) {
                return;
            }
            this.c.dismiss();
            this.c = null;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override // android.app.Activity
    protected void onRestart() {
        try {
            Log.i(f.c, "onRestart");
            super.onRestart();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override // android.app.Activity
    protected void onRestoreInstanceState(Bundle bundle) {
        super.onRestoreInstanceState(bundle);
        Log.i(f.c, "onRestoreInstanceState");
    }

    @Override // android.app.Activity
    protected void onSaveInstanceState(Bundle bundle) {
        try {
            Log.i(f.c, "onSaveInstanceState");
            this.a.saveState(bundle);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
