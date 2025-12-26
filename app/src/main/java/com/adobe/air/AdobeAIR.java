package com.adobe.air;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;

/* loaded from: classes.dex */
public class AdobeAIR extends Activity {
    private static final String PROPERTY_INITIAL_LAUNCH = "initialLaunch";
    private static final String TAG = "Adobe AIR";
    private AdobeAIRWebView mGameListingWebView = null;
    public String DYNAMIC_URL = "https://www.adobe.com/airgames/5/";
    private Context mCtx = null;

    @Override // android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        if (isWidgetShown()) {
            finish();
        }
        this.mCtx = this;
        if (isInitialLaunch()) {
            this.DYNAMIC_URL = AdobeAIRWebView.DYNAMIC_URL_CLOUDFRONT;
            updateSharedPrefForInitialLaunch();
        }
        this.mGameListingWebView = new AdobeAIRWebView(this.mCtx);
        this.mGameListingWebView.create();
        this.mGameListingWebView.loadUrl(this.DYNAMIC_URL);
        onNewIntent(getIntent());
    }

    private boolean isInitialLaunch() {
        return PreferenceManager.getDefaultSharedPreferences(getApplicationContext()).getBoolean(PROPERTY_INITIAL_LAUNCH, true);
    }

    private void updateSharedPrefForInitialLaunch() {
        SharedPreferences.Editor editorEdit = PreferenceManager.getDefaultSharedPreferences(getApplicationContext()).edit();
        editorEdit.putBoolean(PROPERTY_INITIAL_LAUNCH, false);
        editorEdit.commit();
    }

    @Override // android.app.Activity
    public void onResume() {
        super.onResume();
        if (isWidgetShown()) {
            finish();
        }
        if (this.mGameListingWebView.isOffline()) {
            this.mGameListingWebView.setOffline(false);
            this.mGameListingWebView.loadUrl(this.DYNAMIC_URL);
        }
    }

    /* JADX WARN: Removed duplicated region for block: B:15:0x0039  */
    @Override // android.app.Activity
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    public void onBackPressed() {
        /*
            r3 = this;
            r2 = 1
            int r0 = android.os.Build.VERSION.SDK_INT
            r1 = 12
            if (r0 < r1) goto L35
            com.adobe.air.AdobeAIRWebView r0 = r3.mGameListingWebView
            boolean r0 = r0.canGoBack()
            if (r0 == 0) goto L35
            com.adobe.air.AdobeAIRWebView r0 = r3.mGameListingWebView
            android.webkit.WebBackForwardList r0 = r0.copyBackForwardList()
            int r1 = r0.getCurrentIndex()
            if (r1 <= 0) goto L39
            int r1 = r1 - r2
            android.webkit.WebHistoryItem r0 = r0.getItemAtIndex(r1)
            java.lang.String r0 = r0.getUrl()
            java.lang.String r1 = r3.DYNAMIC_URL
            boolean r0 = r1.equals(r0)
            if (r0 == 0) goto L39
            r0 = 0
        L2d:
            if (r0 == 0) goto L35
            com.adobe.air.AdobeAIRWebView r0 = r3.mGameListingWebView
            r0.goBack()
        L34:
            return
        L35:
            super.onBackPressed()
            goto L34
        L39:
            r0 = r2
            goto L2d
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AdobeAIR.onBackPressed():void");
    }

    private boolean isWidgetShown() {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        return defaultSharedPreferences.getBoolean("widgetShown", false) || defaultSharedPreferences.getBoolean("featuredWidgetShown", false);
    }
}
