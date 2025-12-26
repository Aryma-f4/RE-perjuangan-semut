package com.adobe.air;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.SystemClock;
import com.adobe.air.AndroidActivityWrapper;

/* loaded from: classes.dex */
class ConfigDownloadListener {
    private static ConfigDownloadListener sListener = null;
    private static String LOG_TAG = "ConfigDownloadListener";
    private BroadcastReceiver mDownloadConfigRecv = new BroadcastReceiver() { // from class: com.adobe.air.ConfigDownloadListener.1
        private String LOG_TAG = "ConfigDownloadListenerBR";

        @Override // android.content.BroadcastReceiver
        public void onReceive(Context context, Intent intent) {
            AndroidActivityWrapper androidActivityWrapperGetAndroidActivityWrapper;
            if (intent.getAction().equals(AIRService.INTENT_CONFIG_DOWNLOADED)) {
                boolean z = false;
                if (isInitialStickyBroadcast()) {
                    Bundle extras = intent.getExtras();
                    if (extras != null) {
                        if (ConfigDownloadListener.this.lastPauseTime < extras.getLong(AIRService.EXTRA_DOWNLOAD_TIME)) {
                            z = true;
                        }
                    }
                } else {
                    z = true;
                }
                if (z && (androidActivityWrapperGetAndroidActivityWrapper = AndroidActivityWrapper.GetAndroidActivityWrapper()) != null) {
                    androidActivityWrapperGetAndroidActivityWrapper.applyDownloadedConfig();
                }
            }
        }
    };
    private AndroidActivityWrapper.StateChangeCallback mActivityStateCB = new AndroidActivityWrapper.StateChangeCallback() { // from class: com.adobe.air.ConfigDownloadListener.2
        @Override // com.adobe.air.AndroidActivityWrapper.StateChangeCallback
        public void onActivityStateChanged(AndroidActivityWrapper.ActivityState activityState) {
            Activity activity = AndroidActivityWrapper.GetAndroidActivityWrapper().getActivity();
            if (activityState == AndroidActivityWrapper.ActivityState.PAUSED) {
                activity.unregisterReceiver(ConfigDownloadListener.this.mDownloadConfigRecv);
                ConfigDownloadListener.this.lastPauseTime = SystemClock.uptimeMillis();
            } else if (activityState == AndroidActivityWrapper.ActivityState.RESUMED) {
                activity.registerReceiver(ConfigDownloadListener.this.mDownloadConfigRecv, new IntentFilter(AIRService.INTENT_CONFIG_DOWNLOADED));
            }
        }

        @Override // com.adobe.air.AndroidActivityWrapper.StateChangeCallback
        public void onConfigurationChanged(Configuration configuration) {
        }
    };
    private long lastPauseTime = SystemClock.uptimeMillis();

    private ConfigDownloadListener() {
        AndroidActivityWrapper.GetAndroidActivityWrapper().addActivityStateChangeListner(this.mActivityStateCB);
    }

    public static ConfigDownloadListener GetConfigDownloadListener() {
        if (sListener == null) {
            sListener = new ConfigDownloadListener();
        }
        return sListener;
    }
}
