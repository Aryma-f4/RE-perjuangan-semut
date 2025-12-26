package com.adobe.air;

import android.app.Activity;
import android.app.Application;
import android.app.Dialog;
import android.app.KeyguardManager;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.media.AudioManager;
import android.os.Build;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.ContextMenu;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SurfaceView;
import android.view.View;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import com.adobe.air.telephony.AndroidTelephonyManager;
import com.adobe.air.utils.Utils;
import com.adobe.flashplayer.HDMIUtils;
import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/* loaded from: classes.dex */
public class AndroidActivityWrapper {
    private static final String ADOBE_COM = "adobe.com";
    private static final int ASPECT_RATIO_ANY = 3;
    private static final int ASPECT_RATIO_LANDSCAPE = 2;
    private static final int ASPECT_RATIO_PORTRAIT = 1;
    public static final int IMAGE_PICKER_REQUEST_CODE = 2;
    private static final int INVOKE_EVENT_OPEN_URL = 1;
    private static final int INVOKE_EVENT_STANDARD = 0;
    private static final String LOG_TAG = "AndroidActivityWrapper";
    public static final int STILL_PICTURE_REQUEST_CODE = 3;
    public static final int VIDEO_CAPTURE_REQUEST_CODE = 4;
    public static final int WEBVIEW_UPLOAD_FILE_CHOOSER_CODE = 5;
    private static final String WWW_ADOBE_COM = "www.adobe.com";
    private KeyguardManager keyGuardManager;
    private Activity m_activity;
    private Application m_application;
    private Condition m_newActivityCondition;
    private Lock m_newActivityLock;
    private static boolean sApplicationLaunched = false;
    private static Entrypoints sEntryPoint = null;
    private static AndroidIdleState sIdleStateManager = null;
    private static AndroidTelephonyManager sAndroidTelephonyManager = null;
    private static AndroidActivityWrapper sActivityWrapper = null;
    private static boolean sRuntimeLibrariesLoaded = false;
    private static boolean sHasCaptiveRuntime = false;
    private static boolean sIsSwfPreviewMode = false;
    private static String sGamePreviewHost = "";
    private static boolean sDepthAndStencil = false;
    private ConfigDownloadListener mConfigDownloadListener = null;
    private List<ActivityResultCallback> mActivityResultListeners = null;
    private AIRWindowSurfaceView m_mainView = null;
    private SurfaceView m_videoView = null;
    private AndroidCameraView m_cameraView = null;
    private FrameLayout m_layout = null;
    private FlashEGL m_flashEGL = null;
    private String mXmlPath = null;
    private String mRootDir = null;
    private String mExtraArgs = null;
    private boolean mIsADL = false;
    private boolean mRGB565Override = false;
    private boolean mIsDebuggerMode = false;
    private int mHardKeyboardHidden = 2;
    private int mHardKeyboardType = 0;
    private boolean mShowDebuggerDialog = false;
    private boolean mDisplayWaitingDialog = false;
    private int debuggerPort = -1;
    private boolean mInvokeEventPendingFromOnCreate = false;
    private boolean mActivateEventPending = false;
    private List<StateChangeCallback> mActivityStateListeners = null;
    private List<InputEventCallback> mInputEventListeners = null;
    private boolean mFullScreenSetFromMetaData = false;
    private boolean mIsFullScreen = false;
    private boolean mContainsVideo = false;
    private String mLibCorePath = null;
    private Context m_runtimeContext = null;
    private RelativeLayout m_overlaysLayout = null;
    private OrientationManager mOrientationManager = null;
    private boolean mScreenOn = true;
    private DebuggerSettings mDebuggerSettings = new DebuggerSettings();
    private ActivityState mActivityState = ActivityState.STARTED;
    private List<SurfaceView> m_planes = null;
    private int m_planeCascadeStep = 0;
    private boolean m_planeBreakCascade = false;
    private boolean m_planeCascadeInit = false;
    private boolean m_skipKickCascade = true;

    interface ActivityResultCallback {
        void onActivityResult(int i, int i2, Intent intent);
    }

    public enum ActivityState {
        STARTED,
        RESTARTED,
        RESUMED,
        PAUSED,
        STOPPED,
        DESTROYED
    }

    private enum DebugMode {
        None,
        ConnectMode,
        ListenMode,
        ConflictMode
    }

    interface InputEventCallback {
        boolean onGenericMotionEvent(MotionEvent motionEvent);

        boolean onKeyEvent(KeyEvent keyEvent);
    }

    public static class PlaneID {
        public static final int PLANE_CAMERA = 5;
        public static final int PLANE_COUNT = 8;
        public static final int PLANE_FLASH = 3;
        public static final int PLANE_OVERLAY = 2;
        public static final int PLANE_STAGE3D = 6;
        public static final int PLANE_STAGETEXT = 1;
        public static final int PLANE_STAGEVIDEO = 7;
        public static final int PLANE_STAGEVIDEOAUTOMATIC = 4;
        public static final int PLANE_STAGEWEBVIEW = 0;
    }

    interface StateChangeCallback {
        void onActivityStateChanged(ActivityState activityState);

        void onConfigurationChanged(Configuration configuration);
    }

    private native void nativeActivateEvent();

    private native void nativeDeactivateEvent();

    private native void nativeLowMemoryEvent();

    private native void nativeOnFocusListener(boolean z);

    private native void nativeSendInvokeEventWithData(String str, String str2, int i);

    private native void nativeSetVisible(boolean z);

    public boolean isScreenOn() {
        return this.mScreenOn;
    }

    public boolean isScreenLocked() {
        return this.keyGuardManager.inKeyguardRestrictedInputMode();
    }

    public boolean isResumed() {
        return this.mActivityState == ActivityState.RESUMED;
    }

    public boolean isStarted() {
        return this.mActivityState == ActivityState.STARTED || this.mActivityState == ActivityState.RESTARTED;
    }

    public static boolean isGingerbread() {
        return Build.VERSION.SDK_INT >= 9;
    }

    public static boolean isHoneycomb() {
        return Build.VERSION.SDK_INT >= 11;
    }

    public static boolean isIceCreamSandwich() {
        return Build.VERSION.SDK_INT >= 14;
    }

    public static boolean isJellybean() {
        return Build.VERSION.SDK_INT >= 16;
    }

    public static AndroidActivityWrapper CreateAndroidActivityWrapper(Activity activity) {
        return CreateAndroidActivityWrapper(activity, false);
    }

    public static AndroidActivityWrapper CreateAndroidActivityWrapper(Activity activity, Boolean bool) {
        sHasCaptiveRuntime = bool.booleanValue();
        if (bool.booleanValue()) {
            Utils.setRuntimePackageName(activity.getApplicationContext().getPackageName());
        } else {
            Utils.setRuntimePackageName("com.adobe.air");
        }
        if (sActivityWrapper == null) {
            sActivityWrapper = new AndroidActivityWrapper(activity);
        }
        return sActivityWrapper;
    }

    private AndroidActivityWrapper(Activity activity) {
        this.m_activity = null;
        this.m_application = null;
        this.m_newActivityLock = null;
        this.m_newActivityCondition = null;
        this.keyGuardManager = null;
        this.m_activity = activity;
        this.m_newActivityLock = new ReentrantLock();
        this.m_newActivityCondition = this.m_newActivityLock.newCondition();
        this.m_application = activity.getApplication();
        LoadRuntimeLibraries();
        this.keyGuardManager = (KeyguardManager) activity.getSystemService("keyguard");
    }

    public static AndroidActivityWrapper GetAndroidActivityWrapper() {
        return sActivityWrapper;
    }

    public static boolean GetHasCaptiveRuntime() {
        return sHasCaptiveRuntime;
    }

    public static boolean IsGamePreviewMode() {
        return sIsSwfPreviewMode;
    }

    public static boolean GetDepthAndStencilForGamePreview() {
        return sDepthAndStencil;
    }

    public static boolean ShouldShowGamePreviewWatermark() {
        Boolean boolValueOf = Boolean.valueOf(sIsSwfPreviewMode);
        if (boolValueOf.booleanValue() && (sGamePreviewHost.equalsIgnoreCase("www.adobe.com") || sGamePreviewHost.equalsIgnoreCase(ADOBE_COM))) {
            boolValueOf = false;
        }
        return boolValueOf.booleanValue();
    }

    public Activity getActivity() {
        return this.m_activity;
    }

    public void setSpeakerphoneOn(boolean z) {
        ((AudioManager) getActivity().getSystemService("audio")).setSpeakerphoneOn(z);
    }

    public boolean getSpeakerphoneOn() {
        return ((AudioManager) getActivity().getSystemService("audio")).isSpeakerphoneOn();
    }

    public void registerPlane(SurfaceView surfaceView, int i) {
        this.m_planes.set(i, surfaceView);
        planeBreakCascade();
    }

    public void unregisterPlane(int i) {
        this.m_planes.set(i, null);
        planeBreakCascade();
    }

    public void planeCleanCascade() {
        if (!this.m_planeCascadeInit) {
            this.m_planeCascadeInit = true;
            planeBreakCascade();
        }
    }

    public void planeBreakCascade() {
        int i = 0;
        for (int i2 = 0; i2 < 8; i2++) {
            if (this.m_planes.get(i2) != null) {
                i++;
            }
        }
        if (i > 1) {
            this.m_planeBreakCascade = true;
        }
    }

    private boolean planeRemovedSuccessfully(SurfaceView surfaceView) {
        if (surfaceView.getHolder().getSurface().isValid()) {
            return (Build.MODEL.equals("LT18i") || Build.MODEL.equals("LT15i") || Build.MODEL.equals("Arc")) && isIceCreamSandwich() && this.m_layout.indexOfChild(surfaceView) < 0;
        }
        return true;
    }

    public void planeKickCascade() {
        if (isHoneycomb() && this.m_skipKickCascade) {
            return;
        }
        if (!isJellybean() || !this.mContainsVideo) {
            planeCleanCascade();
            if (this.m_layout != null) {
                if (this.m_planeBreakCascade) {
                    for (int i = 0; i < 8; i++) {
                        if (this.m_planes.get(i) != null && this.m_layout.indexOfChild(this.m_planes.get(i)) >= 0) {
                            this.m_layout.removeView(this.m_planes.get(i));
                        }
                    }
                    this.m_planeBreakCascade = false;
                    int i2 = 0;
                    while (true) {
                        if (i2 >= 8) {
                            break;
                        }
                        if (this.m_planes.get(i2) == null || planeRemovedSuccessfully(this.m_planes.get(i2))) {
                            i2++;
                        } else {
                            this.m_planeBreakCascade = true;
                            break;
                        }
                    }
                    this.m_planeCascadeStep = 0;
                }
                if (this.m_planeCascadeStep == 0) {
                    planeStepCascade();
                    this.m_mainView.requestFocus();
                }
            }
        }
    }

    public void planeStepCascade() {
        this.m_skipKickCascade = false;
        if (this.m_layout != null && !this.m_planeBreakCascade) {
            while (this.m_planeCascadeStep < 8) {
                if (this.m_planes.get(this.m_planeCascadeStep) == null) {
                    this.m_planeCascadeStep++;
                } else {
                    if (this.m_layout.indexOfChild(this.m_planes.get(this.m_planeCascadeStep)) < 0) {
                        this.m_layout.addView(this.m_planes.get(this.m_planeCascadeStep), 0);
                    }
                    this.m_planeCascadeStep++;
                    return;
                }
            }
        }
    }

    public void ensureZOrder() {
        for (int i = 7; i >= 0; i--) {
            if (this.m_planes.get(i) != null && this.m_layout.indexOfChild(this.m_planes.get(i)) >= 0) {
                this.m_layout.bringChildToFront(this.m_planes.get(i));
            }
        }
    }

    public Context getRuntimeContext() {
        return this.m_runtimeContext;
    }

    public Application getApplication() {
        return this.m_application;
    }

    public Context getApplicationContext() {
        return this.m_application;
    }

    public Context getDefaultContext() {
        return this.m_activity != null ? this.m_activity : this.m_application;
    }

    public int getDefaultIntentFlags() {
        return this.m_activity != null ? 0 : 268435456;
    }

    public RelativeLayout getOverlaysLayout(boolean z) {
        if (z && this.m_overlaysLayout == null) {
            this.m_overlaysLayout = new RelativeLayout(this.m_activity);
            this.m_layout.addView(this.m_overlaysLayout);
        }
        return this.m_overlaysLayout;
    }

    public void didRemoveOverlay() {
        if (this.m_overlaysLayout != null && this.m_overlaysLayout.getChildCount() == 0) {
            this.m_layout.removeView(this.m_overlaysLayout);
            this.m_overlaysLayout = null;
        }
    }

    public View getView() {
        return this.m_mainView;
    }

    public AndroidCameraView getCameraView() {
        return this.m_cameraView;
    }

    public boolean isApplicationLaunched() {
        return sApplicationLaunched;
    }

    public FlashEGL getEgl() {
        if (this.m_flashEGL == null) {
            this.m_flashEGL = FlashEGLFactory.CreateFlashEGL();
        }
        return this.m_flashEGL;
    }

    public boolean isSurfaceValid() {
        return this.m_mainView != null && this.m_mainView.isSurfaceValid();
    }

    public void SendIntentToRuntime(Class<?> cls, String str, String str2) {
        try {
            Intent intent = new Intent(this.m_runtimeContext, cls);
            intent.setAction(str);
            intent.addCategory(str2);
            this.m_activity.startActivity(intent);
        } catch (Exception e) {
        }
    }

    public void SendIntentToRuntime(Class<?> cls, String str, String str2, String str3, String str4) {
        try {
            Intent intent = new Intent(this.m_runtimeContext, cls);
            intent.setAction(str);
            intent.addCategory(str2);
            intent.putExtra(str3, str4);
            this.m_activity.startActivity(intent);
        } catch (Exception e) {
        }
    }

    public void StartDownloadConfigService() {
        Intent intent = new Intent();
        intent.setPackage(Utils.getRuntimePackageName());
        intent.setAction(AIRService.INTENT_DOWNLOAD_CONFIG);
        try {
            getApplicationContext().startService(intent);
        } catch (SecurityException e) {
        }
    }

    public void ShowImmediateUpdateDialog() {
        String str;
        String str2 = null;
        try {
            Bundle bundle = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (bundle == null) {
                str = null;
            } else {
                str = (String) bundle.get("airDownloadURL");
            }
            str2 = str;
        } catch (PackageManager.NameNotFoundException e) {
        }
        if (str2 != null) {
            SendIntentToRuntime(AIRUpdateDialog.class, "android.intent.action.MAIN", "AIRUpdateDialog", "airDownloadURL", str2);
        } else {
            SendIntentToRuntime(AIRUpdateDialog.class, "android.intent.action.MAIN", "AIRUpdateDialog");
        }
    }

    private void initializeAndroidAppVars(ApplicationInfo applicationInfo) {
        ApplicationFileManager.setAndroidPackageName(applicationInfo.packageName);
        ApplicationFileManager.setAndroidAPKPath(applicationInfo.sourceDir);
        ApplicationFileManager.processAndroidDataPath(this.m_application.getCacheDir().getAbsolutePath());
    }

    /* JADX WARN: Removed duplicated region for block: B:21:0x0065  */
    /* JADX WARN: Removed duplicated region for block: B:26:0x0079  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    private void parseArgs(android.app.Activity r13, java.lang.String[] r14) {
        /*
            Method dump skipped, instructions count: 191
            To view this dump change 'Code comments level' option to 'DEBUG'
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidActivityWrapper.parseArgs(android.app.Activity, java.lang.String[]):void");
    }

    public void onCreate(Activity activity, String[] strArr) throws Exception {
        this.m_activity = activity;
        this.mActivityState = ActivityState.STARTED;
        parseArgs(activity, strArr);
        SignalNewActivityCreated();
        try {
            this.m_runtimeContext = this.m_activity.createPackageContext(Utils.getRuntimePackageName(), 4);
        } catch (Exception e) {
        }
        if (this.mIsDebuggerMode && !this.mIsADL && !sApplicationLaunched && !DeviceProfiling.checkAndInitiateProfiler(this.m_activity)) {
            checkForDebuggerAndLaunchDialog();
        } else {
            afterOnCreate();
        }
        this.mInvokeEventPendingFromOnCreate = true;
        this.mConfigDownloadListener = ConfigDownloadListener.GetConfigDownloadListener();
    }

    private void afterOnCreate() {
        Boolean bool;
        try {
            if (this.m_planes == null) {
                this.m_planes = new ArrayList(8);
                for (int i = 0; i < 8; i++) {
                    this.m_planes.add(i, null);
                }
            }
            Context applicationContext = getApplicationContext();
            this.m_layout = new FrameLayout(applicationContext);
            this.m_mainView = new AIRWindowSurfaceView(applicationContext, this);
            if (this.m_cameraView == null && this.m_runtimeContext.checkCallingOrSelfPermission("android.permission.CAMERA") == 0) {
                this.m_cameraView = new AndroidCameraView(applicationContext, this);
            }
            if (this.m_cameraView != null) {
                this.m_layout.addView(this.m_cameraView, 8, 16);
            }
            Bundle bundle = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (bundle != null && (bool = (Boolean) bundle.get("containsVideo")) != null && bool.booleanValue()) {
                this.mContainsVideo = bool.booleanValue();
                this.m_videoView = this.m_mainView.getVideoView();
                this.m_layout.addView(this.m_videoView, 0);
            }
            this.m_layout.addView(this.m_mainView);
            if (this.m_overlaysLayout != null) {
                this.m_layout.addView(this.m_overlaysLayout);
            }
            this.m_activity.setContentView(this.m_layout);
            if ((this.mIsADL || this.mShowDebuggerDialog) && this.m_activity != null && this.m_activity.getCurrentFocus() != this.m_mainView) {
                this.m_mainView.requestFocus();
                this.m_mainView.onWindowFocusChanged(true);
            }
            if (!this.mFullScreenSetFromMetaData) {
                setFullScreenFromMetaData();
            }
            this.mFullScreenSetFromMetaData = true;
            if (getIsFullScreen()) {
                this.m_mainView.setFullScreen();
            }
            this.mHardKeyboardHidden = this.m_activity.getResources().getConfiguration().hardKeyboardHidden;
            this.mHardKeyboardType = this.m_activity.getResources().getConfiguration().keyboard;
            this.mOrientationManager = OrientationManager.getOrientationManager();
            this.mOrientationManager.onActivityCreated(this.m_activity, this.m_mainView);
            callActivityStateListeners();
            HDMIUtils.initHelper(applicationContext);
        } catch (Exception e) {
        }
    }

    private void LaunchApplication(Activity activity, AIRWindowSurfaceView aIRWindowSurfaceView, String str, String str2, String str3, boolean z, boolean z2) {
        String str4;
        String str5;
        String str6;
        String str7;
        String str8;
        String str9;
        String str10;
        String str11;
        String str12;
        if (!sApplicationLaunched) {
            if (z) {
                try {
                    String stringExtra = activity.getIntent().getStringExtra("args");
                    if (stringExtra != null) {
                        String[] strArrSplit = stringExtra.split(" ");
                        String str13 = strArrSplit[0];
                        try {
                            String str14 = strArrSplit[1];
                            try {
                                String str15 = strArrSplit.length >= 2 ? strArrSplit[2] + " " : str3;
                                for (int i = 3; i < strArrSplit.length; i++) {
                                    try {
                                        str15 = str15 + strArrSplit[i] + " ";
                                    } catch (Exception e) {
                                        str7 = str15;
                                        str9 = str13;
                                        str8 = str14;
                                        str4 = str7;
                                        String str16 = str8;
                                        str6 = str9;
                                        str5 = str16;
                                        Context applicationContext = getApplicationContext();
                                        sEntryPoint = new Entrypoints();
                                        sEntryPoint.EntryMain(str6, str5, str4, Utils.getRuntimePackageName(), aIRWindowSurfaceView, activity.getApplication(), activity.getApplicationInfo(), applicationContext, this, z, z2);
                                        sIdleStateManager = AndroidIdleState.GetIdleStateManager(applicationContext);
                                        sApplicationLaunched = true;
                                    }
                                }
                                str10 = str15;
                                str12 = str13;
                                str11 = str14;
                            } catch (Exception e2) {
                                str7 = str3;
                                str9 = str13;
                                str8 = str14;
                            }
                        } catch (Exception e3) {
                            str7 = str3;
                            str9 = str13;
                            str8 = str2;
                        }
                    } else {
                        str10 = str3;
                        str11 = str2;
                        str12 = str;
                    }
                    str4 = str10;
                    String str17 = str11;
                    str6 = str12;
                    str5 = str17;
                } catch (Exception e4) {
                    str7 = str3;
                    str8 = str2;
                    str9 = str;
                }
            } else {
                try {
                    if (sIsSwfPreviewMode) {
                        try {
                            String dataString = activity.getIntent().getDataString();
                            if (dataString != null && dataString.indexOf("?") > 0) {
                                int i2 = -1;
                                for (String str18 : dataString.substring(dataString.indexOf("?") + 1).split("&")) {
                                    if (str18.substring(0, str18.indexOf("=")).equalsIgnoreCase("depthAndStencil")) {
                                        if (str18.substring(str18.indexOf("=") + 1).equalsIgnoreCase("true")) {
                                            sDepthAndStencil = true;
                                        } else {
                                            sDepthAndStencil = false;
                                        }
                                    } else if (str18.substring(0, str18.indexOf("=")).equalsIgnoreCase("autoorients")) {
                                        if (str18.substring(str18.indexOf("=") + 1).equalsIgnoreCase("true")) {
                                            setAutoOrients(true);
                                        } else {
                                            setAutoOrients(false);
                                        }
                                    } else if (str18.substring(0, str18.indexOf("=")).equalsIgnoreCase("aspectratio")) {
                                        String strSubstring = str18.substring(str18.indexOf("=") + 1);
                                        if (strSubstring.equalsIgnoreCase("portrait")) {
                                            i2 = 1;
                                        } else if (strSubstring.equalsIgnoreCase("landscape")) {
                                            i2 = 2;
                                        } else if (strSubstring.equalsIgnoreCase("any")) {
                                            i2 = 3;
                                        }
                                    }
                                }
                                if (i2 != -1) {
                                    setAspectRatio(i2);
                                }
                            }
                            str4 = str3;
                            str5 = str2;
                            str6 = str;
                        } catch (Exception e5) {
                            str4 = str3;
                            str5 = str2;
                            str6 = str;
                        }
                    } else {
                        str4 = str3;
                        str5 = str2;
                        str6 = str;
                    }
                } catch (Exception e6) {
                    return;
                }
            }
            Context applicationContext2 = getApplicationContext();
            sEntryPoint = new Entrypoints();
            sEntryPoint.EntryMain(str6, str5, str4, Utils.getRuntimePackageName(), aIRWindowSurfaceView, activity.getApplication(), activity.getApplicationInfo(), applicationContext2, this, z, z2);
            sIdleStateManager = AndroidIdleState.GetIdleStateManager(applicationContext2);
            sApplicationLaunched = true;
        }
    }

    private void setMainView(View view) {
        if (sApplicationLaunched && sEntryPoint != null && isResumed()) {
            try {
                sEntryPoint.setMainView(view);
            } catch (Exception e) {
            }
        }
    }

    public void initCallStateListener() {
        if (sAndroidTelephonyManager == null) {
            sAndroidTelephonyManager = AndroidTelephonyManager.CreateAndroidTelephonyManager(getApplicationContext());
            sAndroidTelephonyManager.listen(true);
        }
    }

    public void onPause() {
        this.mActivityState = ActivityState.PAUSED;
        callActivityStateListeners();
        if (this.m_mainView != null) {
            this.m_mainView.forceSoftKeyboardDown();
        }
        if (this.mOrientationManager != null) {
            this.mOrientationManager.onActivityPaused();
        }
        if (sIdleStateManager != null) {
            sIdleStateManager.releaseLock();
        }
        if (isApplicationLaunched()) {
            nativeOnFocusListener(false);
            nativeDeactivateEvent();
        }
        planeBreakCascade();
    }

    public void onResume() {
        this.mActivityState = ActivityState.RESUMED;
        callActivityStateListeners();
        if (this.mOrientationManager != null) {
            this.mOrientationManager.onActivityResumed();
        }
        if (sIdleStateManager != null) {
            sIdleStateManager.acquireLock();
        }
        if (isApplicationLaunched()) {
            nativeActivateEvent();
            nativeOnFocusListener(true);
        } else {
            this.mActivateEventPending = true;
        }
        this.m_skipKickCascade = true;
        planeBreakCascade();
    }

    public void onRestart() {
        this.mActivityState = ActivityState.RESTARTED;
        callActivityStateListeners();
        if (this.m_mainView != null) {
            this.m_mainView.HideSoftKeyboardOnWindowFocusChange();
        }
        SetVisible(true);
    }

    public void onStop() {
        this.mActivityState = ActivityState.STOPPED;
        callActivityStateListeners();
        SetVisible(false);
    }

    public void onDestroy() {
        this.mActivityState = ActivityState.DESTROYED;
        callActivityStateListeners();
        if (this.mOrientationManager != null) {
            this.mOrientationManager.onActivityDestroyed();
        }
        int i = 0;
        while (true) {
            int i2 = i;
            if (i2 >= 8) {
                break;
            }
            if (this.m_planes.get(i2) != null) {
                this.m_layout.removeView(this.m_planes.get(i2));
            }
            i = i2 + 1;
        }
        if (this.m_overlaysLayout != null) {
            this.m_layout.removeView(this.m_overlaysLayout);
        }
        this.m_activity = null;
        this.m_cameraView = null;
        this.m_mainView = null;
        this.m_layout = null;
        setMainView(null);
        HDMIUtils.closeHelper();
    }

    public void SendInvokeEvent() {
        Intent intent = this.m_activity.getIntent();
        String dataString = intent.getDataString();
        int i = 0;
        if (dataString != null) {
            i = 1;
        }
        nativeSendInvokeEventWithData(dataString, intent.getAction(), i);
    }

    public void onNewIntent(Intent intent) {
        this.m_activity.setIntent(intent);
        SendInvokeEvent();
    }

    public void onSurfaceInitialized() {
        setMainView(this.m_mainView);
        SetVisible(true);
        if (this.mDisplayWaitingDialog) {
            showDialogWaitingForConnection(this.debuggerPort);
            this.mDisplayWaitingDialog = false;
        }
        LaunchApplication(this.m_activity, this.m_mainView, this.mXmlPath, this.mRootDir, this.mExtraArgs, this.mIsADL, this.mIsDebuggerMode);
        if (this.mInvokeEventPendingFromOnCreate) {
            if (!this.mIsADL) {
                SendInvokeEvent();
            }
            this.mInvokeEventPendingFromOnCreate = false;
        }
        if (this.mActivateEventPending) {
            nativeActivateEvent();
            this.mActivateEventPending = false;
        }
        planeCleanCascade();
    }

    public void finish() {
        if (this.m_activity != null) {
            this.m_activity.finish();
        }
    }

    public void onSurfaceDestroyed() {
        SetVisible(false);
    }

    public void onScreenStateChanged(boolean z) {
        this.mScreenOn = z;
        SetVisible(z);
        if (z) {
            this.m_skipKickCascade = false;
            planeBreakCascade();
        }
    }

    private void SetVisible(boolean z) {
        if (z) {
            if (isSurfaceValid() && this.mScreenOn && this.mActivityState != ActivityState.STOPPED && this.mActivityState != ActivityState.DESTROYED) {
                nativeSetVisible(true);
                return;
            }
            return;
        }
        if (isApplicationLaunched()) {
            nativeSetVisible(false);
        }
    }

    public void onConfigurationChanged(Configuration configuration) {
        this.mHardKeyboardHidden = configuration.hardKeyboardHidden;
        this.mHardKeyboardType = configuration.keyboard;
        this.mOrientationManager.onConfigurationChanged(configuration);
        callActivityStateListeners(configuration);
    }

    public boolean dispatchKeyEvent(KeyEvent keyEvent, boolean z) {
        return callInputEventListeners(keyEvent);
    }

    public boolean dispatchGenericMotionEvent(MotionEvent motionEvent, boolean z) {
        return callInputEventListeners(motionEvent);
    }

    public void onLowMemory() {
        nativeLowMemoryEvent();
    }

    public int getOrientation() {
        return this.mOrientationManager.getOrientation();
    }

    public int getDeviceOrientation() {
        return this.mOrientationManager.getDeviceOrientation();
    }

    public void setOrientation(int i) {
        this.mOrientationManager.setOrientation(i);
    }

    public void setAspectRatio(int i) {
        this.mOrientationManager.setAspectRatio(i);
    }

    public void setAutoOrients(boolean z) {
        this.mOrientationManager.setAutoOrients(z);
    }

    public boolean getAutoOrients() {
        return this.mOrientationManager.getAutoOrients();
    }

    public int[] getSupportedOrientations() {
        return this.mOrientationManager.getSupportedOrientations();
    }

    public void onActivityResult(int i, int i2, Intent intent) {
        callActivityResultListeners(i, i2, intent);
    }

    public boolean isHardKeyboardHidden() {
        return this.mHardKeyboardHidden == 2;
    }

    public int getHardKeyboardType() {
        return this.mHardKeyboardType;
    }

    public boolean needsCompositingSurface() {
        return this.m_runtimeContext.checkCallingOrSelfPermission("android.permission.CAMERA") == 0;
    }

    public void setUseRGB565(Boolean bool) {
        this.mRGB565Override = bool.booleanValue();
    }

    public boolean useRGB565() {
        if (this.mIsADL) {
            return this.mRGB565Override;
        }
        ResourceFileManager resourceFileManager = new ResourceFileManager(this.m_activity);
        return !resourceFileManager.resExists(resourceFileManager.lookupResId(AndroidConstants.ANDROID_RESOURCE_RGBA8888));
    }

    public void BroadcastIntent(String str, String str2) {
        try {
            getDefaultContext().startActivity(Intent.parseUri(str2, 0).setAction(str).addFlags(getDefaultIntentFlags()));
        } catch (ActivityNotFoundException e) {
        } catch (URISyntaxException e2) {
        }
    }

    public void LaunchMarketPlaceForAIR(String str) {
        try {
            BroadcastIntent("android.intent.action.VIEW", str == null ? "market://details?id=" + Utils.getRuntimePackageName() : str);
        } catch (Exception e) {
        }
    }

    public String GetLibCorePath() {
        if (this.mLibCorePath == null) {
            this.mLibCorePath = Utils.GetLibCorePath(this.m_application);
        }
        return this.mLibCorePath;
    }

    private void LoadRuntimeLibraries() {
        if (!sRuntimeLibrariesLoaded) {
            try {
                System.load(Utils.GetLibSTLPath(this.m_application));
                System.load(GetLibCorePath());
                sRuntimeLibrariesLoaded = true;
            } catch (UnsatisfiedLinkError e) {
            }
        }
    }

    private void showDialogUnableToListenOnPort(int i) {
        new ListenErrorDialog(this.m_activity, i).createAndShowDialog();
    }

    /* JADX WARN: Removed duplicated region for block: B:29:0x0083  */
    /* JADX WARN: Removed duplicated region for block: B:32:0x008e  */
    /* JADX WARN: Removed duplicated region for block: B:66:0x00da  */
    /* JADX WARN: Removed duplicated region for block: B:67:0x00e0  */
    /* JADX WARN: Removed duplicated region for block: B:87:0x010f A[PHI: r1
  0x010f: PHI (r1v41 com.adobe.air.AndroidActivityWrapper$DebugMode) = (r1v1 com.adobe.air.AndroidActivityWrapper$DebugMode), (r1v3 com.adobe.air.AndroidActivityWrapper$DebugMode) binds: [B:5:0x001c, B:11:0x0049] A[DONT_GENERATE, DONT_INLINE]] */
    /* JADX WARN: Removed duplicated region for block: B:99:0x00d6 A[EXC_TOP_SPLITTER, SYNTHETIC] */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    private void checkForDebuggerAndLaunchDialog() throws java.lang.Exception {
        /*
            Method dump skipped, instructions count: 288
            To view this dump change 'Code comments level' option to 'DEBUG'
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidActivityWrapper.checkForDebuggerAndLaunchDialog():void");
    }

    private void showDialogforIpAddress(String str) {
        getApplicationContext();
        new RemoteDebuggerDialog(this.m_activity).createAndShowDialog(str);
    }

    private void closeDialogWaitingForConnection() {
        Context applicationContext = getApplicationContext();
        try {
            Intent intent = new Intent();
            intent.setAction("android.intent.action.MAIN");
            intent.addCategory("RemoteDebuggerListenerDialogClose");
            intent.putExtra("debuggerPort", this.debuggerPort);
            applicationContext.sendBroadcast(intent);
        } catch (Exception e) {
        }
    }

    private void showDialogWaitingForConnection(final int i) {
        getApplicationContext();
        if (sHasCaptiveRuntime) {
            new Thread(new Runnable() { // from class: com.adobe.air.AndroidActivityWrapper.1
                @Override // java.lang.Runnable
                public void run() throws InterruptedException, IOException {
                    try {
                        Thread.sleep(30000L);
                        new Socket(InetAddress.getLocalHost(), i).close();
                    } catch (Exception e) {
                    }
                }
            }).start();
            return;
        }
        try {
            Intent intent = new Intent(this.m_runtimeContext, (Class<?>) RemoteDebuggerListenerDialog.class);
            intent.setAction("android.intent.action.MAIN");
            intent.addCategory("RemoteDebuggerListenerDialog");
            intent.putExtra("debuggerPort", i);
            this.m_activity.startActivity(intent);
        } catch (Exception e) {
        }
    }

    public void gotResultFromDialog(boolean z, String str) {
        boolean zNativeConnectDebuggerSocket;
        if (z) {
            zNativeConnectDebuggerSocket = str.length() != 0 ? Utils.nativeConnectDebuggerSocket(str) : false;
            if (!zNativeConnectDebuggerSocket) {
                showDialogforIpAddress(str);
            } else {
                this.mDebuggerSettings.setHost(str);
                this.mDebuggerSettings.setListen(false);
                this.mShowDebuggerDialog = true;
            }
        } else {
            zNativeConnectDebuggerSocket = false;
        }
        if (zNativeConnectDebuggerSocket || !z) {
            afterOnCreate();
        }
    }

    public void addInputEventListner(InputEventCallback inputEventCallback) {
        if (this.mInputEventListeners == null) {
            this.mInputEventListeners = new ArrayList();
        }
        if (!this.mInputEventListeners.contains(inputEventCallback)) {
            this.mInputEventListeners.add(inputEventCallback);
        }
    }

    public void removeInputEventListner(InputEventCallback inputEventCallback) {
        if (this.mInputEventListeners != null) {
            this.mInputEventListeners.remove(inputEventCallback);
        }
    }

    /* JADX WARN: Removed duplicated region for block: B:12:0x0021  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    private boolean callInputEventListeners(android.view.KeyEvent r6) {
        /*
            r5 = this;
            r4 = 0
            java.util.List<com.adobe.air.AndroidActivityWrapper$InputEventCallback> r0 = r5.mInputEventListeners
            if (r0 != 0) goto L7
            r0 = r4
        L6:
            return r0
        L7:
            java.util.List<com.adobe.air.AndroidActivityWrapper$InputEventCallback> r0 = r5.mInputEventListeners     // Catch: java.lang.Exception -> L2a
            int r1 = r0.size()     // Catch: java.lang.Exception -> L2a
            r2 = r4
            r3 = r4
        Lf:
            if (r2 >= r1) goto L28
            if (r3 != 0) goto L21
            java.util.List<com.adobe.air.AndroidActivityWrapper$InputEventCallback> r0 = r5.mInputEventListeners     // Catch: java.lang.Exception -> L2d
            java.lang.Object r0 = r0.get(r2)     // Catch: java.lang.Exception -> L2d
            com.adobe.air.AndroidActivityWrapper$InputEventCallback r0 = (com.adobe.air.AndroidActivityWrapper.InputEventCallback) r0     // Catch: java.lang.Exception -> L2d
            boolean r0 = r0.onKeyEvent(r6)     // Catch: java.lang.Exception -> L2d
            if (r0 == 0) goto L26
        L21:
            r0 = 1
        L22:
            int r2 = r2 + 1
            r3 = r0
            goto Lf
        L26:
            r0 = r4
            goto L22
        L28:
            r0 = r3
            goto L6
        L2a:
            r0 = move-exception
            r0 = r4
            goto L6
        L2d:
            r0 = move-exception
            r0 = r3
            goto L6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidActivityWrapper.callInputEventListeners(android.view.KeyEvent):boolean");
    }

    /* JADX WARN: Removed duplicated region for block: B:12:0x0021  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    private boolean callInputEventListeners(android.view.MotionEvent r6) {
        /*
            r5 = this;
            r4 = 0
            java.util.List<com.adobe.air.AndroidActivityWrapper$InputEventCallback> r0 = r5.mInputEventListeners
            if (r0 != 0) goto L7
            r0 = r4
        L6:
            return r0
        L7:
            java.util.List<com.adobe.air.AndroidActivityWrapper$InputEventCallback> r0 = r5.mInputEventListeners     // Catch: java.lang.Exception -> L2a
            int r1 = r0.size()     // Catch: java.lang.Exception -> L2a
            r2 = r4
            r3 = r4
        Lf:
            if (r2 >= r1) goto L28
            if (r3 != 0) goto L21
            java.util.List<com.adobe.air.AndroidActivityWrapper$InputEventCallback> r0 = r5.mInputEventListeners     // Catch: java.lang.Exception -> L2d
            java.lang.Object r0 = r0.get(r2)     // Catch: java.lang.Exception -> L2d
            com.adobe.air.AndroidActivityWrapper$InputEventCallback r0 = (com.adobe.air.AndroidActivityWrapper.InputEventCallback) r0     // Catch: java.lang.Exception -> L2d
            boolean r0 = r0.onGenericMotionEvent(r6)     // Catch: java.lang.Exception -> L2d
            if (r0 == 0) goto L26
        L21:
            r0 = 1
        L22:
            int r2 = r2 + 1
            r3 = r0
            goto Lf
        L26:
            r0 = r4
            goto L22
        L28:
            r0 = r3
            goto L6
        L2a:
            r0 = move-exception
            r0 = r4
            goto L6
        L2d:
            r0 = move-exception
            r0 = r3
            goto L6
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidActivityWrapper.callInputEventListeners(android.view.MotionEvent):boolean");
    }

    public void addActivityStateChangeListner(StateChangeCallback stateChangeCallback) {
        if (this.mActivityStateListeners == null) {
            this.mActivityStateListeners = new ArrayList();
        }
        if (!this.mActivityStateListeners.contains(stateChangeCallback)) {
            this.mActivityStateListeners.add(stateChangeCallback);
        }
    }

    public void removeActivityStateChangeListner(StateChangeCallback stateChangeCallback) {
        if (this.mActivityStateListeners != null) {
            this.mActivityStateListeners.remove(stateChangeCallback);
        }
    }

    private void callActivityStateListeners() {
        if (this.mActivityStateListeners != null) {
            try {
                int size = this.mActivityStateListeners.size();
                for (int i = 0; i < size; i++) {
                    this.mActivityStateListeners.get(i).onActivityStateChanged(this.mActivityState);
                }
            } catch (Exception e) {
            }
        }
    }

    private void callActivityStateListeners(Configuration configuration) {
        if (this.mActivityStateListeners != null) {
            try {
                int size = this.mActivityStateListeners.size();
                for (int i = 0; i < size; i++) {
                    this.mActivityStateListeners.get(i).onConfigurationChanged(configuration);
                }
            } catch (Exception e) {
            }
        }
    }

    public void addActivityResultListener(ActivityResultCallback activityResultCallback) {
        if (this.mActivityResultListeners == null) {
            this.mActivityResultListeners = new ArrayList();
        }
        if (!this.mActivityResultListeners.contains(activityResultCallback)) {
            this.mActivityResultListeners.add(activityResultCallback);
        }
    }

    public void removeActivityResultListener(ActivityResultCallback activityResultCallback) {
        if (this.mActivityResultListeners != null) {
            this.mActivityResultListeners.remove(activityResultCallback);
        }
    }

    private void callActivityResultListeners(int i, int i2, Intent intent) {
        if (this.mActivityResultListeners != null) {
            try {
                int size = this.mActivityResultListeners.size();
                for (int i3 = 0; i3 < size; i3++) {
                    this.mActivityResultListeners.get(i3).onActivityResult(i, i2, intent);
                }
            } catch (Exception e) {
            }
        }
    }

    private void SignalNewActivityCreated() {
        this.m_newActivityLock.lock();
        this.m_newActivityCondition.signalAll();
        this.m_newActivityLock.unlock();
    }

    public Activity WaitForNewActivity() {
        this.m_newActivityLock.lock();
        try {
            if (this.m_activity == null) {
                this.m_newActivityCondition.await();
            }
        } catch (InterruptedException e) {
        } finally {
            this.m_newActivityLock.unlock();
        }
        return this.m_activity;
    }

    private void setFullScreenFromMetaData() {
        Boolean bool;
        try {
            Bundle bundle = this.m_activity.getPackageManager().getActivityInfo(this.m_activity.getComponentName(), 128).metaData;
            if (bundle != null && (bool = (Boolean) bundle.get("fullScreen")) != null && bool.booleanValue()) {
                this.m_mainView.setFullScreen();
            }
        } catch (PackageManager.NameNotFoundException e) {
        }
    }

    protected void setIsFullScreen(boolean z) {
        this.mIsFullScreen = z;
    }

    protected boolean getIsFullScreen() {
        return this.mIsFullScreen;
    }

    public String GetAppCacheDirectory() {
        return this.m_application.getCacheDir().getAbsolutePath();
    }

    public String GetAppDataDirectory() {
        return this.m_application.getApplicationInfo().dataDir;
    }

    public String GetRuntimeDataDirectory() {
        return this.m_runtimeContext.getApplicationInfo().dataDir + "/";
    }

    public void finishActivityFromChild(Activity activity, int i) {
    }

    public void finishFromChild(Activity activity) {
    }

    public void onAttachedToWindow() {
    }

    public void onBackPressed() {
    }

    public void onContentChanged() {
    }

    public boolean onContextItemSelected(MenuItem menuItem, boolean z) {
        return z;
    }

    public void onContextMenuClosed(Menu menu) {
    }

    public void onCreateContextMenu(ContextMenu contextMenu, View view, ContextMenu.ContextMenuInfo contextMenuInfo) {
    }

    public CharSequence onCreateDescription(CharSequence charSequence) {
        return charSequence;
    }

    public boolean onCreateOptionsMenu(Menu menu, boolean z) {
        return z;
    }

    public boolean onCreatePanelMenu(int i, Menu menu, boolean z) {
        return z;
    }

    public View onCreatePanelView(int i, View view) {
        return view;
    }

    public boolean onCreateThumbnail(Bitmap bitmap, Canvas canvas, boolean z) {
        return z;
    }

    public View onCreateView(String str, Context context, AttributeSet attributeSet, View view) {
        return view;
    }

    public void onDetachedFromWindow() {
    }

    public boolean onKeyDown(int i, KeyEvent keyEvent, boolean z) {
        return z;
    }

    public boolean onKeyLongPress(int i, KeyEvent keyEvent, boolean z) {
        return z;
    }

    public boolean onKeyMultiple(int i, int i2, KeyEvent keyEvent, boolean z) {
        return z;
    }

    public boolean onKeyUp(int i, KeyEvent keyEvent, boolean z) {
        return z;
    }

    public boolean onMenuItemSelected(int i, MenuItem menuItem, boolean z) {
        return z;
    }

    public boolean onMenuOpened(int i, Menu menu, boolean z) {
        return z;
    }

    public boolean onOptionsItemSelected(MenuItem menuItem, boolean z) {
        return z;
    }

    public void onOptionsMenuClosed(Menu menu) {
    }

    public void onPanelClosed(int i, Menu menu) {
    }

    public boolean onPrepareOptionsMenu(Menu menu, boolean z) {
        return z;
    }

    public boolean onPreparePanel(int i, View view, Menu menu, boolean z) {
        return z;
    }

    public Object onRetainNonConfigurationInstance(Object obj) {
        return obj;
    }

    public boolean onSearchRequested(boolean z) {
        return z;
    }

    public boolean onTouchEvent(MotionEvent motionEvent, boolean z) {
        return z;
    }

    public boolean onTrackballEvent(MotionEvent motionEvent, boolean z) {
        return z;
    }

    public void onUserInteraction() {
    }

    public void onWindowAttributesChanged(WindowManager.LayoutParams layoutParams) {
    }

    public void onWindowFocusChanged(boolean z) {
    }

    public void onApplyThemeResource(Resources.Theme theme, int i, boolean z) {
    }

    public void onChildTitleChanged(Activity activity, CharSequence charSequence) {
    }

    public Dialog onCreateDialog(int i, Bundle bundle, Dialog dialog) {
        return dialog;
    }

    public Dialog onCreateDialog(int i, Dialog dialog) {
        return dialog;
    }

    public void onPostCreate(Bundle bundle) {
    }

    public void onPostResume() {
    }

    public void onPrepareDialog(int i, Dialog dialog, Bundle bundle) {
    }

    public void onPrepareDialog(int i, Dialog dialog) {
    }

    public void onRestoreInstanceState(Bundle bundle) {
    }

    public void onSaveInstanceState(Bundle bundle) {
    }

    public void onTitleChanged(CharSequence charSequence, int i) {
    }

    public void onUserLeaveHint() {
    }

    public DebuggerSettings GetDebuggerSettings() {
        return this.mDebuggerSettings;
    }

    public void applyDownloadedConfig() {
        if (sEntryPoint != null) {
            sEntryPoint.EntryApplyDownloadedConfig();
        }
    }
}
