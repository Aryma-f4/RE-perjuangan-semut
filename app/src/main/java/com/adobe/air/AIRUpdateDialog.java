package com.adobe.air;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.KeyEvent;
import com.adobe.air.AndroidLocale;

/* loaded from: classes.dex */
public class AIRUpdateDialog extends Activity {
    private AndroidActivityWrapper actWrapper;
    private static AIRUpdateDialog sThis = null;
    private static String AIR_PING_URL = "http://airdownload2.adobe.com/air?";
    private final String LOG_TAG = "AIRUpdateDialog";
    private AlertDialog alertDialog = null;
    private final String RUNTIME_PACKAGE_ID = "com.adobe.air";

    @Override // android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        sThis = this;
        this.actWrapper = AndroidActivityWrapper.CreateAndroidActivityWrapper(this, false);
        this.alertDialog = new AlertDialog.Builder(this).setTitle("Adobe® AIR®").setMessage(AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_RUNTIME_UPDATE_MESSAGE)).create();
        this.alertDialog.setButton(-1, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_UPDATE), new DialogInterface.OnClickListener() { // from class: com.adobe.air.AIRUpdateDialog.1
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                AIRUpdateDialog.this.actWrapper.LaunchMarketPlaceForAIR(AIRUpdateDialog.this.getIntent().getStringExtra("airDownloadURL"));
                InstallOfferPingUtils.PingAndExit(AIRUpdateDialog.sThis, AIRUpdateDialog.AIR_PING_URL, true, true, false);
            }
        });
        this.alertDialog.setButton(-2, AndroidLocale.GetLocalizedString(AndroidLocale.STRING_ID.IDA_CANCEL), new DialogInterface.OnClickListener() { // from class: com.adobe.air.AIRUpdateDialog.2
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialogInterface, int i) {
                InstallOfferPingUtils.PingAndExit(AIRUpdateDialog.sThis, AIRUpdateDialog.AIR_PING_URL, false, true, false);
            }
        });
        this.alertDialog.setOnKeyListener(new DialogInterface.OnKeyListener() { // from class: com.adobe.air.AIRUpdateDialog.3
            @Override // android.content.DialogInterface.OnKeyListener
            public boolean onKey(DialogInterface dialogInterface, int i, KeyEvent keyEvent) {
                if (i != 4 && i != 84) {
                    return false;
                }
                dialogInterface.cancel();
                InstallOfferPingUtils.PingAndExit(AIRUpdateDialog.sThis, AIRUpdateDialog.AIR_PING_URL, false, true, false);
                return true;
            }
        });
        this.alertDialog.setCancelable(true);
        this.alertDialog.show();
    }

    @Override // android.app.Activity
    public void onPause() {
        if (this.alertDialog != null) {
            this.alertDialog.cancel();
            this.alertDialog = null;
            finish();
        }
        super.onPause();
    }

    @Override // android.app.Activity
    public void onStop() {
        if (this.alertDialog != null) {
            this.alertDialog.cancel();
            this.alertDialog = null;
            finish();
        }
        super.onStop();
    }
}
