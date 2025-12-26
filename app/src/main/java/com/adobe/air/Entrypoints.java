package com.adobe.air;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import com.adobe.air.utils.Utils;
import java.io.File;

/* loaded from: classes.dex */
public class Entrypoints {
    static boolean mCallEntryMain;
    private static String mLibCorePath = null;
    private static customHandler mMainHandler = new customHandler();
    public static Context s_context;
    private static String s_packageName;

    public native void EntryDownloadConfigNative(Object obj, String str);

    public native void EntryMainWrapper(String str, String str2, String str3, String str4, Object obj, Object obj2, Object obj3, Object obj4, boolean z, boolean z2);

    public native void EntryStopRuntimeNative();

    public native void applyDownloadedConfig();

    public native void setMainViewOnCreate(AIRWindowSurfaceView aIRWindowSurfaceView);

    public static Handler getMainHandler() {
        return mMainHandler;
    }

    public static void registerCallback(int i, int i2, int i3, Handler handler) {
        Handler handler2 = handler == null ? mMainHandler : handler;
        Message messageObtain = Message.obtain();
        messageObtain.what = customHandler.TIME_OUT_MSG_ID;
        messageObtain.arg1 = i2;
        messageObtain.arg2 = i3;
        if (i > 0) {
            handler2.sendMessageDelayed(messageObtain, i);
        } else {
            handler2.sendMessage(messageObtain);
        }
    }

    public static boolean registerTouchCallback(int i, TouchEventData touchEventData, Handler handler) {
        Handler handler2 = handler == null ? mMainHandler : handler;
        Message messageObtain = Message.obtain();
        messageObtain.what = customHandler.TOUCH_MSG_ID;
        messageObtain.obj = touchEventData;
        if (i > 0) {
            handler2.sendMessageDelayed(messageObtain, i);
            return true;
        }
        handler2.sendMessage(messageObtain);
        return true;
    }

    public static boolean registerKeyCallback(int i, KeyEventData keyEventData, Handler handler) {
        Handler handler2 = handler == null ? mMainHandler : handler;
        Message messageObtain = Message.obtain();
        messageObtain.what = customHandler.KEY_MSG_ID;
        messageObtain.obj = keyEventData;
        if (i > 0) {
            handler2.sendMessageDelayed(messageObtain, i);
            return true;
        }
        handler2.sendMessage(messageObtain);
        return true;
    }

    public static void BroadcastIntent(String str, String str2) {
        AndroidActivityWrapper.GetAndroidActivityWrapper().BroadcastIntent(str, str2);
    }

    public void EntryMain(String str, String str2, String str3, String str4, Object obj, Object obj2, Object obj3, Object obj4, Object obj5, boolean z, boolean z2) {
        s_context = (Context) obj4;
        s_packageName = ((ApplicationInfo) obj3).packageName;
        if (!mCallEntryMain) {
            mCallEntryMain = true;
            if (str2.length() > 0 && str.length() > 0) {
                EntryMainWrapper(str, str2, str3, str4, obj, obj2, obj4, obj5, z, z2);
            }
        }
    }

    public String GetLibCorePath() {
        if (mLibCorePath == null) {
            mLibCorePath = Utils.GetLibCorePath(s_context);
        }
        return mLibCorePath;
    }

    public boolean EntryDownloadConfig(Object obj, String str) {
        s_context = (Context) obj;
        ApplicationInfo applicationInfo = s_context.getApplicationInfo();
        s_packageName = applicationInfo.packageName;
        ApplicationFileManager.setAndroidPackageName(s_packageName);
        ApplicationFileManager.setAndroidAPKPath(applicationInfo.sourceDir);
        File cacheDir = s_context.getCacheDir();
        if (cacheDir == null) {
            return false;
        }
        ApplicationFileManager.processAndroidDataPath(cacheDir.getAbsolutePath());
        System.load(Utils.GetLibSTLPath(s_context));
        System.load(GetLibCorePath());
        EntryDownloadConfigNative(obj, str);
        return true;
    }

    public void EntryApplyDownloadedConfig() {
        applyDownloadedConfig();
    }

    public void EntryStopRuntime() {
        System.load(GetLibCorePath());
        EntryStopRuntimeNative();
    }

    public void setMainView(View view) {
        setMainViewOnCreate((AIRWindowSurfaceView) view);
    }

    public static String getPackageName() {
        return s_packageName;
    }

    public static String getAppCacheDirectory() {
        return s_context.getCacheDir().getAbsolutePath();
    }

    public static String getRuntimeDataDirectory() {
        return s_context.getApplicationInfo().dataDir + "/";
    }
}
