package com.codapayments.sdk.pay;

import android.app.Activity;
import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/* loaded from: classes.dex */
final class a extends WebViewClient {
    private /* synthetic */ CodaWeb a;

    a(CodaWeb codaWeb) {
        this.a = codaWeb;
    }

    @Override // android.webkit.WebViewClient
    public final void onPageFinished(WebView webView, String str) {
        if (this.a.c == null || !this.a.c.isShowing()) {
            return;
        }
        this.a.c.dismiss();
        this.a.c = null;
    }

    @Override // android.webkit.WebViewClient
    public final void onPageStarted(WebView webView, String str, Bitmap bitmap) {
        super.onPageStarted(webView, str, bitmap);
        if (this.a.c == null && !this.a.isFinishing()) {
            this.a.c = new ProgressDialog(this.a);
            if (this.a.e) {
                this.a.c.setMessage("Loading...");
            } else {
                this.a.c.setMessage("Processing...");
            }
            this.a.c.setCanceledOnTouchOutside(false);
            this.a.c.setCancelable(false);
            this.a.c.show();
        }
        this.a.e = false;
    }

    @Override // android.webkit.WebViewClient
    public final void onReceivedError(WebView webView, int i, String str, String str2) {
        com.codapayments.sdk.c.c.a((Activity) this.a, "Connection Error...", "Please try again in a few minutes. Contact support@codapayments.com or PulsaQ_ID on Yahoo Messenger for help. (Error: " + i + ")", "OK");
    }

    @Override // android.webkit.WebViewClient
    public final boolean shouldOverrideUrlLoading(WebView webView, String str) {
        return super.shouldOverrideUrlLoading(webView, str);
    }
}
