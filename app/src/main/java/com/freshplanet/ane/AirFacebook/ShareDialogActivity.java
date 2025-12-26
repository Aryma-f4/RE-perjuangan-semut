package com.freshplanet.ane.AirFacebook;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import com.facebook.Session;
import com.facebook.widget.FacebookDialog;

/* loaded from: classes.dex */
public class ShareDialogActivity extends Activity implements DialogFactory, FacebookDialog.Callback {
    public static String extraPrefix = "com.freshplanet.ane.AirFacebook.ShareDialogActivity";
    private String callback;
    private DialogLifecycleHelper dialogHelper;

    @Override // com.freshplanet.ane.AirFacebook.DialogFactory
    public FacebookDialog.PendingCall createDialog() {
        String stringExtra = getIntent().getStringExtra(extraPrefix + ".link");
        String stringExtra2 = getIntent().getStringExtra(extraPrefix + ".name");
        String stringExtra3 = getIntent().getStringExtra(extraPrefix + ".caption");
        String stringExtra4 = getIntent().getStringExtra(extraPrefix + ".description");
        String stringExtra5 = getIntent().getStringExtra(extraPrefix + ".pictureUrl");
        Session session = AirFacebookExtension.context.getSession();
        if (session == null) {
            AirFacebookExtension.log("ERROR - AirFacebook is not initialized");
            finish();
            return null;
        }
        FacebookDialog.ShareDialogBuilder shareDialogBuilder = new FacebookDialog.ShareDialogBuilder(this, session.getApplicationId());
        if (stringExtra != null) {
            shareDialogBuilder.setLink(stringExtra);
        }
        if (stringExtra2 != null) {
            shareDialogBuilder.setName(stringExtra2);
        }
        if (stringExtra3 != null) {
            shareDialogBuilder.setCaption(stringExtra3);
        }
        if (stringExtra4 != null) {
            shareDialogBuilder.setDescription(stringExtra4);
        }
        if (stringExtra5 != null) {
            shareDialogBuilder.setPicture(stringExtra5);
        }
        try {
            return shareDialogBuilder.build().present();
        } catch (Exception e) {
            e.printStackTrace();
            AirFacebookExtension.context.dispatchStatusEventAsync(this.callback, AirFacebookError.makeJsonError(e));
            finish();
            return null;
        }
    }

    @Override // android.app.Activity
    protected void onActivityResult(int i, int i2, Intent intent) {
        super.onActivityResult(i, i2, intent);
        this.dialogHelper.onActivityResult(i, i2, intent);
    }

    @Override // com.facebook.widget.FacebookDialog.Callback
    public void onComplete(FacebookDialog.PendingCall pendingCall, Bundle bundle) {
        AirFacebookExtension.context.dispatchStatusEventAsync(this.callback, "{ \"success\": \"true\" }");
        finish();
    }

    @Override // android.app.Activity
    protected void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        this.dialogHelper = new DialogLifecycleHelper(this, this, this);
        this.callback = getIntent().getStringExtra(extraPrefix + ".callback");
        this.dialogHelper.onCreate(bundle);
    }

    @Override // com.facebook.widget.FacebookDialog.Callback
    public void onError(FacebookDialog.PendingCall pendingCall, Exception exc, Bundle bundle) {
        exc.printStackTrace();
        AirFacebookExtension.context.dispatchStatusEventAsync(this.callback, AirFacebookError.makeJsonError(exc));
        finish();
    }

    @Override // android.app.Activity
    public void onSaveInstanceState(Bundle bundle) {
        super.onSaveInstanceState(bundle);
        this.dialogHelper.onSaveInstanceState(bundle);
    }
}
