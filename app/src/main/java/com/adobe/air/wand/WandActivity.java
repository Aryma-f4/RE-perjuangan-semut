package com.adobe.air.wand;

import android.app.Activity;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v7.appcompat.R;
import com.adobe.air.wand.connection.WandWebSocket;
import com.adobe.air.wand.view.WandView;

/* loaded from: classes.dex */
public class WandActivity extends Activity {
    private static final String LOG_TAG = "WandActivity";
    private WandWebSocket mWandWebSocket = null;
    private WandManager mWandManager = null;
    private boolean mHasResumed = false;

    @Override // android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        getWindow().setFormat(1);
        setContentView(R.layout.wand_main);
        initialize();
    }

    private void initialize() {
        try {
            this.mWandWebSocket = new WandWebSocket(this);
            this.mWandManager = new WandManager(this, (WandView) findViewById(R.id.wandView), this.mWandWebSocket);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void onResume() {
        super.onResume();
        this.mHasResumed = true;
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public void onWindowFocusChanged(boolean z) {
        super.onWindowFocusChanged(z);
        if (this.mHasResumed && z && this.mWandManager != null && !this.mWandManager.hasFocus()) {
            try {
                this.mWandManager.focus(true);
            } catch (Exception e) {
            }
        }
    }

    @Override // android.app.Activity
    public void onPause() {
        super.onPause();
        try {
            this.mHasResumed = false;
            this.mWandManager.focus(false);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void onDestroy() {
        super.onDestroy();
        try {
            terminate();
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.content.ComponentCallbacks
    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        if (this.mWandManager != null && this.mWandManager.hasFocus()) {
            try {
                this.mWandManager.onConfigurationChanged(configuration);
            } catch (Exception e) {
            }
        }
    }

    private void terminate() throws Exception {
        this.mWandManager.dispose();
        this.mWandManager = null;
        this.mWandWebSocket.dispose();
        this.mWandWebSocket = null;
    }
}
