package com.adobe.air;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.webkit.WebBackForwardList;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/* loaded from: classes.dex */
public class AdobeAIRWebView {
    public static final String ADOBE_GAME_SHOWCASE = "gaming.adobe.com";
    public static final String ADOBE_HOST = "www.adobe.com";
    public static final String CLOUDFRONT_HOST = "dh8vjmvwgc27o.cloudfront.net";
    public static final String DYNAMIC_URL_CLOUDFRONT = "https://www.adobe.com/airgames/4/";
    public static final String GAMESPACE_HOST = "gamespace.adobe.com";
    public static final String GOOGLE_PLAY_HOST = "play.google.com";
    public static final String STATIC_URL = "file:///android_res/raw/startga.html";
    private Context mCurrentContext;
    private WebView mWebView = null;
    private WebView mAuxWebView = null;
    private WebView mHiddenWebView = null;
    private boolean mOffline = false;
    private boolean mFirstLoad = true;

    public AdobeAIRWebView(Context context) {
        this.mCurrentContext = null;
        this.mCurrentContext = context;
    }

    public void create() {
        WebViewClient webViewClient = new WebViewClient() { // from class: com.adobe.air.AdobeAIRWebView.1
            @Override // android.webkit.WebViewClient
            public boolean shouldOverrideUrlLoading(WebView webView, String str) {
                Uri uri;
                boolean z;
                if (str != null && (uri = Uri.parse(str)) != null && uri.getScheme() != null) {
                    try {
                        if (uri.getHost() == null || !(uri.getScheme().equalsIgnoreCase("http") || uri.getScheme().equalsIgnoreCase("https"))) {
                            z = true;
                        } else {
                            if (str.equals(AdobeAIRWebView.DYNAMIC_URL_CLOUDFRONT) || uri.getHost().equalsIgnoreCase(AdobeAIRWebView.GAMESPACE_HOST) || uri.getHost().equalsIgnoreCase(AdobeAIRWebView.CLOUDFRONT_HOST)) {
                                return false;
                            }
                            z = uri.getHost().equalsIgnoreCase(AdobeAIRWebView.ADOBE_HOST) || uri.getHost().equalsIgnoreCase(AdobeAIRWebView.GOOGLE_PLAY_HOST) || uri.getHost().equalsIgnoreCase(AdobeAIRWebView.ADOBE_GAME_SHOWCASE);
                        }
                        if (z) {
                            ((Activity) AdobeAIRWebView.this.mCurrentContext).startActivity(new Intent("android.intent.action.VIEW", uri));
                        } else {
                            AdobeAIRWebView.this.mAuxWebView.loadUrl(str);
                        }
                    } catch (Exception e) {
                    }
                }
                return true;
            }

            @Override // android.webkit.WebViewClient
            public void onPageFinished(WebView webView, String str) {
                if (AdobeAIRWebView.this.mFirstLoad && !str.equals(AdobeAIRWebView.DYNAMIC_URL_CLOUDFRONT)) {
                    AdobeAIRWebView.this.mFirstLoad = false;
                    ((Activity) AdobeAIRWebView.this.mCurrentContext).setRequestedOrientation(2);
                    ((Activity) AdobeAIRWebView.this.mCurrentContext).setContentView(AdobeAIRWebView.this.mWebView);
                }
            }

            @Override // android.webkit.WebViewClient
            public void onReceivedError(WebView webView, int i, String str, String str2) {
                AdobeAIRWebView.this.mOffline = true;
                AdobeAIRWebView.this.mWebView.loadUrl(AdobeAIRWebView.STATIC_URL);
            }
        };
        this.mWebView = new WebView(this.mCurrentContext);
        this.mWebView.setScrollBarStyle(0);
        this.mWebView.setWebViewClient(webViewClient);
        this.mWebView.getSettings().setJavaScriptEnabled(true);
        this.mWebView.getSettings().setBuiltInZoomControls(true);
        this.mWebView.getSettings().setDomStorageEnabled(true);
        this.mWebView.getSettings().setDatabaseEnabled(true);
        this.mWebView.getSettings().setDatabasePath(this.mCurrentContext.getApplicationContext().getFilesDir().getPath() + "/databases/");
        this.mAuxWebView = new WebView(this.mCurrentContext);
        this.mAuxWebView.getSettings().setJavaScriptEnabled(true);
        this.mAuxWebView.getSettings().setDomStorageEnabled(true);
        this.mAuxWebView.getSettings().setDatabaseEnabled(true);
        this.mAuxWebView.getSettings().setDatabasePath(this.mCurrentContext.getApplicationContext().getFilesDir().getPath() + "/databases/");
        createAnalyticsWebView();
    }

    public void createAnalyticsWebView() {
        this.mHiddenWebView = new WebView(this.mCurrentContext);
        this.mHiddenWebView.getSettings().setJavaScriptEnabled(true);
        this.mHiddenWebView.getSettings().setDomStorageEnabled(true);
        this.mHiddenWebView.getSettings().setDatabaseEnabled(true);
        this.mHiddenWebView.getSettings().setDatabasePath(this.mCurrentContext.getApplicationContext().getFilesDir().getPath() + "/databases/");
        this.mHiddenWebView.setWebViewClient(new WebViewClient() { // from class: com.adobe.air.AdobeAIRWebView.2
            @Override // android.webkit.WebViewClient
            public boolean shouldOverrideUrlLoading(WebView webView, String str) {
                return false;
            }
        });
    }

    public void loadUrl(String str) {
        this.mWebView.loadUrl(str);
    }

    public void loadAnalyticsUrl(String str) {
        this.mHiddenWebView.loadUrl(str);
    }

    public boolean canGoBack() {
        return this.mWebView.canGoBack();
    }

    public void goBack() {
        this.mWebView.goBack();
    }

    public WebBackForwardList copyBackForwardList() {
        return this.mWebView.copyBackForwardList();
    }

    public String getUrl() {
        return this.mWebView.getUrl();
    }

    public boolean isOffline() {
        return this.mOffline;
    }

    public void setOffline(boolean z) {
        this.mOffline = z;
    }
}
