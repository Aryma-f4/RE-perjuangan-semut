package com.adobe.flashplayer;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;

/* loaded from: classes.dex */
public class HDMIUtils {
    private static final String EXTDISP_PUBLIC_STATE = "com.motorola.intent.action.externaldisplaystate";
    private static final String EXTDISP_STATUS_CONNECTION = "com.motorola.intent.action.EXTDISP_STATUS_CONNECTION";
    private static final String EXTDISP_STATUS_DISPLAY = "com.motorola.intent.action.EXTDISP_STATUS_DISPLAY";
    private static final String EXTDISP_STATUS_RESOLUTION = "com.motorola.intent.action.EXTDISP_STATUS_RESOLUTION";
    private static final String EXTRA_HDCP = "hdcp";
    private static final String EXTRA_HDMI = "hdmi";
    private static final String TAG = "HDMIUtils";
    private static final int TYPE_HDMI = 1;
    private static Object lock = new Object();
    private static HDMIUtils mSingleton = null;
    private HdmiServiceConnection mConnection = new HdmiServiceConnection();
    private Context mContext;
    private Binder mDeathWatcher;
    private HdmiBroadcastReceiver mExtConnectionReceiver;
    private boolean mHdcpOnOff;
    private boolean mHdmiConnection;
    private boolean mHdmiOnOff;
    private boolean mHdmiStatusKnown;

    private enum HDMIState {
        UNKNOWN(0),
        OFF(1),
        ON(2),
        HDCPON(3);

        public final int value;

        HDMIState(int i) {
            this.value = i;
        }
    }

    private HDMIUtils(Context context) {
        this.mHdmiStatusKnown = false;
        this.mHdmiOnOff = false;
        this.mHdcpOnOff = false;
        this.mHdmiConnection = false;
        this.mContext = null;
        this.mExtConnectionReceiver = null;
        this.mDeathWatcher = null;
        this.mContext = context;
        this.mHdmiStatusKnown = false;
        this.mHdcpOnOff = false;
        this.mHdmiOnOff = false;
        this.mHdmiConnection = false;
        this.mDeathWatcher = new Binder();
        this.mExtConnectionReceiver = new HdmiBroadcastReceiver();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(EXTDISP_PUBLIC_STATE);
        intentFilter.addAction(EXTDISP_STATUS_CONNECTION);
        intentFilter.addAction(EXTDISP_STATUS_DISPLAY);
        intentFilter.addAction(EXTDISP_STATUS_RESOLUTION);
        this.mContext.registerReceiver(this.mExtConnectionReceiver, intentFilter);
    }

    public static void initHelper(Context context) {
        if (mSingleton == null) {
            mSingleton = new HDMIUtils(context);
        }
    }

    public static void closeHelper() {
        if (mSingleton != null) {
            synchronized (lock) {
                if (mSingleton.mExtConnectionReceiver != null) {
                    mSingleton.mContext.unregisterReceiver(mSingleton.mExtConnectionReceiver);
                    mSingleton.mExtConnectionReceiver = null;
                }
                if (mSingleton.mConnection != null) {
                    mSingleton.mContext.unbindService(mSingleton.mConnection);
                    mSingleton.mConnection = null;
                }
                mSingleton.mDeathWatcher = null;
            }
            mSingleton.mHdmiStatusKnown = false;
            mSingleton = null;
        }
    }

    public boolean isConnected() {
        return this.mHdmiConnection;
    }

    public boolean isHDMIOn() {
        return this.mHdmiOnOff;
    }

    public boolean isHDCPOn() {
        return this.mHdcpOnOff;
    }

    public boolean isHdmiStatusKnown() {
        return this.mHdmiStatusKnown;
    }

    public static int getHDMIState(Context context) {
        initHelper(context);
        int i = HDMIState.UNKNOWN.value;
        if (!mSingleton.isHdmiStatusKnown()) {
            return HDMIState.UNKNOWN.value;
        }
        if (mSingleton.isHDCPOn()) {
            return HDMIState.HDCPON.value;
        }
        if (mSingleton.isHDMIOn()) {
            return HDMIState.ON.value;
        }
        return HDMIState.OFF.value;
    }

    class HdmiBroadcastReceiver extends BroadcastReceiver {
        HdmiBroadcastReceiver() {
        }

        @Override // android.content.BroadcastReceiver
        public void onReceive(Context context, Intent intent) {
            boolean z;
            boolean z2;
            String action = intent.getAction();
            Bundle extras = intent != null ? intent.getExtras() : null;
            if (action.equals(HDMIUtils.EXTDISP_STATUS_CONNECTION)) {
                if (extras != null && (z2 = extras.getBoolean(HDMIUtils.EXTRA_HDMI)) != HDMIUtils.this.mHdmiConnection) {
                    HDMIUtils.this.mHdmiConnection = z2;
                    HDMIUtils.this.mHdmiStatusKnown = true;
                    return;
                }
                return;
            }
            if (action.equals(HDMIUtils.EXTDISP_STATUS_DISPLAY)) {
                if (extras != null && (z = extras.getBoolean(HDMIUtils.EXTRA_HDMI)) != HDMIUtils.this.mHdmiOnOff) {
                    HDMIUtils.this.mHdmiOnOff = z;
                    HDMIUtils.this.mHdmiStatusKnown = true;
                    return;
                }
                return;
            }
            if (action.equals(HDMIUtils.EXTDISP_PUBLIC_STATE) && extras != null) {
                HDMIUtils.this.mHdmiOnOff = extras.getInt(HDMIUtils.EXTRA_HDMI) == 1;
                HDMIUtils.this.mHdcpOnOff = extras.getInt(HDMIUtils.EXTRA_HDCP) == 1;
                HDMIUtils.this.mHdmiStatusKnown = true;
            }
        }
    }

    class HdmiServiceConnection implements ServiceConnection {
        HdmiServiceConnection() {
        }

        @Override // android.content.ServiceConnection
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
        }

        @Override // android.content.ServiceConnection
        public void onServiceDisconnected(ComponentName componentName) {
            HDMIUtils.this.mHdmiStatusKnown = false;
        }
    }
}
