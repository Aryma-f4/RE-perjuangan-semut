package com.freshplanet.ane.AirFacebook;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import com.facebook.FacebookException;
import com.facebook.Session;
import com.facebook.widget.WebDialog;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/* loaded from: classes.dex */
public class WebDialogActivity extends Activity implements WebDialog.OnCompleteListener {
    public static String extraPrefix = "com.freshplanet.ane.AirFacebook.WebDialogActivity";
    private String callback;
    private WebDialog dialog = null;
    private String method;

    protected String bundleSetToURLEncoded(Bundle bundle) {
        StringBuilder sb = new StringBuilder();
        String[] strArr = (String[]) bundle.keySet().toArray(new String[0]);
        for (int i = 0; i < strArr.length; i++) {
            if (i > 0) {
                sb.append("&");
            }
            try {
                sb.append(strArr[i]).append("=").append(URLEncoder.encode(bundle.get(strArr[i]).toString(), "utf-8"));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();
    }

    @Override // android.app.Activity
    protected void onActivityResult(int i, int i2, Intent intent) {
        AirFacebookExtension.log("DialogActivity.onActivityResult");
        finish();
    }

    @Override // com.facebook.widget.WebDialog.OnCompleteListener
    public void onComplete(Bundle bundle, FacebookException facebookException) throws IllegalStateException, IllegalArgumentException {
        AirFacebookExtensionContext airFacebookExtensionContext = AirFacebookExtension.context;
        AirFacebookExtension.log("INFO - DialogActivity.onComplete");
        if (airFacebookExtensionContext != null && this.callback != null) {
            if (facebookException != null) {
                AirFacebookExtension.log("DialogActivity.onComplete, error " + facebookException.getMessage());
                airFacebookExtensionContext.dispatchStatusEventAsync(this.callback, AirFacebookError.makeJsonError(facebookException.getMessage()));
                finish();
                return;
            }
            String str = null;
            if (this.method.equalsIgnoreCase("feed")) {
                String string = bundle.getString("post_id");
                if (string != null) {
                    str = "{ \"params\": \"" + string + "\" }";
                }
            } else if (this.method.equalsIgnoreCase("apprequests") && bundle.getString("request") != null) {
                str = "{ \"params\": \"" + bundleSetToURLEncoded(bundle) + "\" }";
            }
            if (str == null) {
                str = "{ \"cancel\": true }";
            }
            AirFacebookExtension.log("DialogActivity.onComplete, postMessage " + str);
            airFacebookExtensionContext.dispatchStatusEventAsync(this.callback, str);
        }
        finish();
    }

    @Override // android.app.Activity
    protected void onCreate(Bundle bundle) {
        AirFacebookExtension.log("WebDialogActivity.onCreate");
        super.onCreate(bundle);
        this.method = getIntent().getStringExtra(extraPrefix + ".method");
        Bundle bundleExtra = getIntent().getBundleExtra(extraPrefix + ".parameters");
        this.callback = getIntent().getStringExtra(extraPrefix + ".callback");
        Session session = AirFacebookExtension.context.getSession();
        if (session == null) {
            AirFacebookExtension.context.dispatchStatusEventAsync(this.callback, AirFacebookError.makeJsonError(AirFacebookError.NOT_INITIALIZED));
            AirFacebookExtension.log("ERROR - AirFacebook is not initialized");
            finish();
            return;
        }
        requestWindowFeature(3);
        setContentView(AirFacebookExtension.getResourceId("layout.com_facebook_login_activity_layout"));
        if (session.isOpened()) {
            this.dialog = new WebDialog.Builder(this, AirFacebookExtension.context.getSession(), this.method, bundleExtra).setOnCompleteListener(this).build();
        } else {
            this.dialog = new WebDialog.Builder(this, session.getApplicationId(), this.method, bundleExtra).setOnCompleteListener(this).build();
        }
        this.dialog.getWindow().setFlags(1024, 1024);
        this.dialog.show();
    }
}
