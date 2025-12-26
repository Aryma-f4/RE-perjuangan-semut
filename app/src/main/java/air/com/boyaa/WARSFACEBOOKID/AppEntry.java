package air.com.boyaa.WARSFACEBOOKID;

import android.R;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Process;
import android.support.v4.view.accessibility.AccessibilityEventCompat;
import android.util.AttributeSet;
import android.util.Log;
import android.view.ContextMenu;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import com.adobe.air.InstallOfferPingUtils;
import com.adobe.air.ResourceIdMap;
import dalvik.system.DexClassLoader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URISyntaxException;
import java.util.Date;

/* loaded from: classes.dex */
public class AppEntry extends Activity {
    private static final String LOG_TAG = "AppEntry";
    private static final String RESOURCE_BUTTON_EXIT = "string.button_exit";
    private static final String RESOURCE_BUTTON_INSTALL = "string.button_install";
    private static final String RESOURCE_CLASS = "air.com.boyaa.WARSFACEBOOKID.R";
    private static final String RESOURCE_TEXT_RUNTIME_REQUIRED = "string.text_runtime_required";
    private static final String RESOURCE_TITLE_ADOBE_AIR = "string.title_adobe_air";
    private static Class<?> sAndroidActivityWrapperClass;
    private static DexClassLoader sDloader;
    private static boolean sRuntimeClassesLoaded = false;
    private static Object sAndroidActivityWrapper = null;
    private static AppEntry sThis = null;
    private static String RUNTIME_PACKAGE_ID = "com.adobe.air";
    private static String AIR_PING_URL = "http://airdownload2.adobe.com/air?";

    private void BroadcastIntent(String action, String data) {
        try {
            startActivity(Intent.parseUri(data, 0).setAction(action).addFlags(268435456));
        } catch (ActivityNotFoundException e) {
        } catch (URISyntaxException e2) {
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void launchMarketPlaceForAIR() throws PackageManager.NameNotFoundException {
        String airDownloadURL = null;
        try {
            ActivityInfo info = getPackageManager().getActivityInfo(getComponentName(), 128);
            Bundle metadata = info.metaData;
            if (metadata != null) {
                airDownloadURL = (String) metadata.get("airDownloadURL");
            }
        } catch (PackageManager.NameNotFoundException e) {
        }
        String marketPlaceURL = airDownloadURL;
        if (marketPlaceURL == null) {
            marketPlaceURL = "market://details?id=" + RUNTIME_PACKAGE_ID;
        }
        try {
            BroadcastIntent("android.intent.action.VIEW", marketPlaceURL);
        } catch (Exception e2) {
        }
    }

    private boolean isRuntimeInstalled() throws PackageManager.NameNotFoundException {
        PackageManager pkgMgr = getPackageManager();
        try {
            pkgMgr.getPackageInfo(RUNTIME_PACKAGE_ID, 256);
            return true;
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    private boolean isRuntimeOnExternalStorage() throws PackageManager.NameNotFoundException {
        ApplicationInfo appInfo;
        PackageManager pkgMgr = getPackageManager();
        try {
            appInfo = pkgMgr.getApplicationInfo(RUNTIME_PACKAGE_ID, 8192);
        } catch (PackageManager.NameNotFoundException e) {
        }
        if ((appInfo.flags & AccessibilityEventCompat.TYPE_GESTURE_DETECTION_START) == 262144) {
            return true;
        }
        return false;
    }

    private void showDialog(int titleId, String text, int positiveButtonId, int negativeButtonId) {
        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);
        alertDialogBuilder.setTitle(titleId);
        alertDialogBuilder.setMessage(text);
        alertDialogBuilder.setPositiveButton(positiveButtonId, new DialogInterface.OnClickListener() { // from class: air.com.boyaa.WARSFACEBOOKID.AppEntry.1
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialog, int which) throws PackageManager.NameNotFoundException {
                AppEntry.this.launchMarketPlaceForAIR();
                InstallOfferPingUtils.PingAndExit(AppEntry.sThis, AppEntry.AIR_PING_URL, true, false, true);
            }
        });
        alertDialogBuilder.setNegativeButton(negativeButtonId, new DialogInterface.OnClickListener() { // from class: air.com.boyaa.WARSFACEBOOKID.AppEntry.2
            @Override // android.content.DialogInterface.OnClickListener
            public void onClick(DialogInterface dialog, int which) {
                InstallOfferPingUtils.PingAndExit(AppEntry.sThis, AppEntry.AIR_PING_URL, false, false, true);
            }
        });
        alertDialogBuilder.setOnCancelListener(new DialogInterface.OnCancelListener() { // from class: air.com.boyaa.WARSFACEBOOKID.AppEntry.3
            @Override // android.content.DialogInterface.OnCancelListener
            public void onCancel(DialogInterface dialog) {
                InstallOfferPingUtils.PingAndExit(AppEntry.sThis, AppEntry.AIR_PING_URL, false, false, true);
            }
        });
        alertDialogBuilder.show();
    }

    private void showRuntimeNotInstalledDialog() {
        ResourceIdMap r = new ResourceIdMap(RESOURCE_CLASS);
        String text = getString(r.getId(RESOURCE_TEXT_RUNTIME_REQUIRED)) + getString(r.getId("string.text_install_runtime"));
        showDialog(r.getId(RESOURCE_TITLE_ADOBE_AIR), text, r.getId(RESOURCE_BUTTON_INSTALL), r.getId(RESOURCE_BUTTON_EXIT));
    }

    private void showRuntimeOnExternalStorageDialog() {
        ResourceIdMap r = new ResourceIdMap(RESOURCE_CLASS);
        String text = getString(r.getId(RESOURCE_TEXT_RUNTIME_REQUIRED)) + getString(r.getId("string.text_runtime_on_external_storage"));
        showDialog(r.getId(RESOURCE_TITLE_ADOBE_AIR), text, r.getId(RESOURCE_BUTTON_INSTALL), r.getId(RESOURCE_BUTTON_EXIT));
    }

    @Override // android.app.Activity
    public void onCreate(Bundle savedInstanceState) throws NoSuchMethodException, SecurityException {
        super.onCreate(savedInstanceState);
        sThis = this;
        Date t = new Date();
        long millis = t.getTime();
        Log.i("StartupTime1", ":" + millis);
        boolean hasCaptiveRuntime = loadCaptiveRuntimeClasses();
        if (!hasCaptiveRuntime) {
            if (!sRuntimeClassesLoaded && !isRuntimeInstalled()) {
                if (isRuntimeOnExternalStorage()) {
                    showRuntimeOnExternalStorageDialog();
                    return;
                } else {
                    showRuntimeNotInstalledDialog();
                    return;
                }
            }
            loadSharedRuntimeDex();
        }
        if (sRuntimeClassesLoaded) {
            createActivityWrapper(hasCaptiveRuntime);
            InvokeWrapperOnCreate();
        } else if (hasCaptiveRuntime) {
            KillSelf();
        } else {
            launchAIRService();
        }
    }

    private void registerForNotifications() {
        Intent serviceIntent = new Intent("com.adobe.air.AndroidGcmRegistrationService");
        serviceIntent.setClassName(RUNTIME_PACKAGE_ID, "com.adobe.air.AndroidGcmRegistrationService");
        startService(serviceIntent);
    }

    private void launchAIRService() {
        try {
            Intent intent = new Intent("com.adobe.air.AIRServiceAction");
            intent.setClassName(RUNTIME_PACKAGE_ID, "com.adobe.air.AIRService");
            ServiceConnection conn = new ServiceConnection() { // from class: air.com.boyaa.WARSFACEBOOKID.AppEntry.4
                @Override // android.content.ServiceConnection
                public void onServiceConnected(ComponentName name, IBinder service) throws NoSuchMethodException, SecurityException {
                    AppEntry.this.unbindService(this);
                    AppEntry.this.loadSharedRuntimeDex();
                    AppEntry.this.createActivityWrapper(false);
                    if (AppEntry.sRuntimeClassesLoaded) {
                        AppEntry.this.InvokeWrapperOnCreate();
                    } else {
                        AppEntry.KillSelf();
                    }
                }

                @Override // android.content.ServiceConnection
                public void onServiceDisconnected(ComponentName name) {
                }
            };
            bindService(intent, conn, 1);
        } catch (Exception e) {
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void InvokeWrapperOnCreate() throws NoSuchMethodException, SecurityException {
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreate", Activity.class, String[].class);
            Boolean isADL = new Boolean(false);
            Boolean isDebuggerMode = new Boolean(false);
            String[] args = {"", "", "-nodebug", isADL.toString(), isDebuggerMode.toString()};
            InvokeMethod(method, this, args);
        } catch (Exception e) {
        }
    }

    private Object InvokeMethod(Method method, Object... args) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
        if (!sRuntimeClassesLoaded) {
            return null;
        }
        Object retval = null;
        try {
            if (args != null) {
                retval = method.invoke(sAndroidActivityWrapper, args);
            } else {
                retval = method.invoke(sAndroidActivityWrapper, new Object[0]);
            }
        } catch (Exception e) {
        }
        return retval;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static void KillSelf() {
        Process.killProcess(Process.myPid());
    }

    @Override // android.app.Activity
    public void onStart() {
        super.onStart();
    }

    @Override // android.app.Activity
    public void onRestart() throws NoSuchMethodException, SecurityException {
        super.onRestart();
        try {
            if (sRuntimeClassesLoaded) {
                Method method = sAndroidActivityWrapperClass.getMethod("onRestart", new Class[0]);
                InvokeMethod(method, new Object[0]);
            }
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void onPause() throws NoSuchMethodException, SecurityException {
        super.onPause();
        try {
            if (sRuntimeClassesLoaded) {
                Method method = sAndroidActivityWrapperClass.getMethod("onPause", new Class[0]);
                InvokeMethod(method, new Object[0]);
            }
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void onResume() throws NoSuchMethodException, SecurityException {
        super.onResume();
        try {
            if (sRuntimeClassesLoaded) {
                Method method = sAndroidActivityWrapperClass.getMethod("onResume", new Class[0]);
                InvokeMethod(method, new Object[0]);
            }
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void onStop() throws NoSuchMethodException, SecurityException {
        super.onStop();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onStop", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void onDestroy() throws NoSuchMethodException, SecurityException {
        super.onDestroy();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onDestroy", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
        sThis = null;
    }

    @Override // android.app.Activity, android.content.ComponentCallbacks
    public void onConfigurationChanged(Configuration newConfig) throws NoSuchMethodException, SecurityException {
        super.onConfigurationChanged(newConfig);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onConfigurationChanged", Configuration.class);
            InvokeMethod(method, newConfig);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public boolean dispatchKeyEvent(KeyEvent event) throws NoSuchMethodException, SecurityException {
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("dispatchKeyEvent", KeyEvent.class, Boolean.TYPE);
            InvokeMethod(method, event, false);
        } catch (Exception e) {
        }
        return 0 != 0 || super.dispatchKeyEvent(event);
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public boolean dispatchGenericMotionEvent(MotionEvent event) throws NoSuchMethodException, SecurityException {
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("dispatchGenericMotionEvent", MotionEvent.class, Boolean.TYPE);
            InvokeMethod(method, event, false);
        } catch (Exception e) {
        }
        return 0 != 0 || super.dispatchGenericMotionEvent(event);
    }

    @Override // android.app.Activity, android.content.ComponentCallbacks
    public void onLowMemory() throws NoSuchMethodException, SecurityException {
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onLowMemory", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onActivityResult(int requestCode, int resultCode, Intent data) throws NoSuchMethodException, SecurityException {
        try {
            if (sRuntimeClassesLoaded) {
                Method method = sAndroidActivityWrapperClass.getMethod("onActivityResult", Integer.TYPE, Integer.TYPE, Intent.class);
                InvokeMethod(method, Integer.valueOf(requestCode), Integer.valueOf(resultCode), data);
            }
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onNewIntent(Intent aIntent) throws NoSuchMethodException, SecurityException {
        super.onNewIntent(aIntent);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onNewIntent", Intent.class);
            InvokeMethod(method, aIntent);
        } catch (Exception e) {
        }
    }

    private boolean loadCaptiveRuntimeClasses() {
        boolean hasCaptiveRuntime = false;
        try {
            sAndroidActivityWrapperClass = Class.forName("com.adobe.air.AndroidActivityWrapper");
            hasCaptiveRuntime = true;
            if (sAndroidActivityWrapperClass != null) {
                sRuntimeClassesLoaded = true;
            }
        } catch (Exception e) {
        }
        return hasCaptiveRuntime;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void loadSharedRuntimeDex() {
        try {
            if (!sRuntimeClassesLoaded) {
                Context con = createPackageContext(RUNTIME_PACKAGE_ID, 3);
                sDloader = new DexClassLoader(RUNTIME_PACKAGE_ID, getFilesDir().getAbsolutePath(), null, con.getClassLoader());
                sAndroidActivityWrapperClass = sDloader.loadClass("com.adobe.air.AndroidActivityWrapper");
                if (sAndroidActivityWrapperClass != null) {
                    sRuntimeClassesLoaded = true;
                }
            }
        } catch (Exception e) {
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void createActivityWrapper(boolean hasCaptiveRuntime) throws NoSuchMethodException, SecurityException {
        try {
            if (hasCaptiveRuntime) {
                Method methodCreateAndroidActivityWrapper = sAndroidActivityWrapperClass.getMethod("CreateAndroidActivityWrapper", Activity.class, Boolean.class);
                sAndroidActivityWrapper = methodCreateAndroidActivityWrapper.invoke(null, this, Boolean.valueOf(hasCaptiveRuntime));
            } else {
                Method methodCreateAndroidActivityWrapper2 = sAndroidActivityWrapperClass.getMethod("CreateAndroidActivityWrapper", Activity.class);
                sAndroidActivityWrapper = methodCreateAndroidActivityWrapper2.invoke(null, this);
            }
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void finishActivityFromChild(Activity child, int requestCode) throws NoSuchMethodException, SecurityException {
        super.finishActivityFromChild(child, requestCode);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("finishActivityFromChild", Activity.class, Integer.TYPE);
            InvokeMethod(method, child, Integer.valueOf(requestCode));
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void finishFromChild(Activity child) throws NoSuchMethodException, SecurityException {
        super.finishFromChild(child);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("finishFromChild", Activity.class);
            InvokeMethod(method, child);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public void onAttachedToWindow() throws NoSuchMethodException, SecurityException {
        super.onAttachedToWindow();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onAttachedToWindow", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public void onBackPressed() throws NoSuchMethodException, SecurityException {
        super.onBackPressed();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onBackPressed", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public void onContentChanged() throws NoSuchMethodException, SecurityException {
        super.onContentChanged();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onContentChanged", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public boolean onContextItemSelected(MenuItem item) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onContextItemSelected(item);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onContextItemSelected", MenuItem.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, item, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public void onContextMenuClosed(Menu menu) throws NoSuchMethodException, SecurityException {
        super.onContextMenuClosed(menu);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onContextMenuClosed", Menu.class);
            InvokeMethod(method, menu);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.View.OnCreateContextMenuListener
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) throws NoSuchMethodException, SecurityException {
        super.onCreateContextMenu(menu, v, menuInfo);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreateContextMenu", ContextMenu.class, View.class, ContextMenu.ContextMenuInfo.class);
            InvokeMethod(method, menu, v, menuInfo);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public CharSequence onCreateDescription() throws NoSuchMethodException, SecurityException {
        CharSequence retval = super.onCreateDescription();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreateDescription", CharSequence.class);
            return (CharSequence) InvokeMethod(method, retval);
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public boolean onCreateOptionsMenu(Menu menu) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onCreateOptionsMenu(menu);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreateOptionsMenu", Menu.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, menu, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public boolean onCreatePanelMenu(int featureId, Menu menu) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onCreatePanelMenu(featureId, menu);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreatePanelMenu", Integer.TYPE, Menu.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Integer.valueOf(featureId), menu, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public View onCreatePanelView(int featureId) throws NoSuchMethodException, SecurityException {
        View retval = super.onCreatePanelView(featureId);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreatePanelView", Integer.TYPE, View.class);
            return (View) InvokeMethod(method, Integer.valueOf(featureId), retval);
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public boolean onCreateThumbnail(Bitmap outBitmap, Canvas canvas) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onCreateThumbnail(outBitmap, canvas);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreateThumbnail", Bitmap.class, Canvas.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, outBitmap, canvas, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.LayoutInflater.Factory
    public View onCreateView(String name, Context context, AttributeSet attrs) throws NoSuchMethodException, SecurityException {
        View retval = super.onCreateView(name, context, attrs);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreateView", String.class, Context.class, AttributeSet.class, View.class);
            return (View) InvokeMethod(method, name, context, attrs, retval);
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public void onDetachedFromWindow() throws NoSuchMethodException, SecurityException {
        super.onDetachedFromWindow();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onDetachedFromWindow", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.KeyEvent.Callback
    public boolean onKeyDown(int keyCode, KeyEvent event) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onKeyDown(keyCode, event);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onKeyDown", Integer.TYPE, KeyEvent.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Integer.valueOf(keyCode), event, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.KeyEvent.Callback
    public boolean onKeyLongPress(int keyCode, KeyEvent event) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onKeyLongPress(keyCode, event);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onKeyLongPress", Integer.TYPE, KeyEvent.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Integer.valueOf(keyCode), event, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.KeyEvent.Callback
    public boolean onKeyMultiple(int keyCode, int repeatCount, KeyEvent event) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onKeyMultiple(keyCode, repeatCount, event);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onKeyMultiple", Integer.TYPE, Integer.TYPE, KeyEvent.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Integer.valueOf(keyCode), Integer.valueOf(repeatCount), event, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.KeyEvent.Callback
    public boolean onKeyUp(int keyCode, KeyEvent event) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onKeyUp(keyCode, event);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onKeyUp", Integer.TYPE, KeyEvent.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Integer.valueOf(keyCode), event, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public boolean onMenuItemSelected(int featureId, MenuItem item) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onMenuItemSelected(featureId, item);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onMenuItemSelected", Integer.TYPE, MenuItem.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Integer.valueOf(featureId), item, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public boolean onMenuOpened(int featureId, Menu menu) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onMenuOpened(featureId, menu);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onMenuOpened", Integer.TYPE, Menu.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Integer.valueOf(featureId), menu, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public boolean onOptionsItemSelected(MenuItem item) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onOptionsItemSelected(item);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onOptionsItemSelected", MenuItem.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, item, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public void onOptionsMenuClosed(Menu menu) throws NoSuchMethodException, SecurityException {
        super.onOptionsMenuClosed(menu);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onOptionsMenuClosed", Menu.class);
            InvokeMethod(method, menu);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public void onPanelClosed(int featureId, Menu menu) throws NoSuchMethodException, SecurityException {
        super.onPanelClosed(featureId, menu);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onPanelClosed", Integer.TYPE, Menu.class);
            InvokeMethod(method, Integer.valueOf(featureId), menu);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    public boolean onPrepareOptionsMenu(Menu menu) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onPrepareOptionsMenu(menu);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onPrepareOptionsMenu", Menu.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, menu, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public boolean onPreparePanel(int featureId, View view, Menu menu) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onPreparePanel(featureId, view, menu);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onPreparePanel", Integer.TYPE, View.class, Menu.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Integer.valueOf(featureId), view, menu, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public Object onRetainNonConfigurationInstance() throws NoSuchMethodException, SecurityException {
        Object retval = super.onRetainNonConfigurationInstance();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onRetainNonConfigurationInstance", Object.class);
            return InvokeMethod(method, retval);
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public boolean onSearchRequested() throws NoSuchMethodException, SecurityException {
        boolean retval = super.onSearchRequested();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onSearchRequested", Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public boolean onTouchEvent(MotionEvent event) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onTouchEvent(event);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onTouchEvent", MotionEvent.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, event, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public boolean onTrackballEvent(MotionEvent event) throws NoSuchMethodException, SecurityException {
        boolean retval = super.onTrackballEvent(event);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onTrackballEvent", MotionEvent.class, Boolean.TYPE);
            return ((Boolean) InvokeMethod(method, event, Boolean.valueOf(retval))).booleanValue();
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    public void onUserInteraction() throws NoSuchMethodException, SecurityException {
        super.onUserInteraction();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onUserInteraction", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public void onWindowAttributesChanged(WindowManager.LayoutParams params) throws NoSuchMethodException, SecurityException {
        super.onWindowAttributesChanged(params);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onWindowAttributesChanged", WindowManager.LayoutParams.class);
            InvokeMethod(method, params);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.Window.Callback
    public void onWindowFocusChanged(boolean hasFocus) throws NoSuchMethodException, SecurityException {
        super.onWindowFocusChanged(hasFocus);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onWindowFocusChanged", Boolean.TYPE);
            InvokeMethod(method, Boolean.valueOf(hasFocus));
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity, android.view.ContextThemeWrapper
    protected void onApplyThemeResource(Resources.Theme theme, int resid, boolean first) throws NoSuchMethodException, SecurityException {
        super.onApplyThemeResource(theme, resid, first);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onApplyThemeResource", Resources.Theme.class, Integer.TYPE, Boolean.TYPE);
            InvokeMethod(method, theme, Integer.valueOf(resid), Boolean.valueOf(first));
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onChildTitleChanged(Activity childActivity, CharSequence title) throws NoSuchMethodException, SecurityException {
        super.onChildTitleChanged(childActivity, title);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onChildTitleChanged", Activity.class, CharSequence.class);
            InvokeMethod(method, childActivity, title);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected Dialog onCreateDialog(int id) throws NoSuchMethodException, SecurityException {
        Dialog retval = super.onCreateDialog(id);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreateDialog", Integer.TYPE, Dialog.class);
            return (Dialog) InvokeMethod(method, Integer.valueOf(id), retval);
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    protected Dialog onCreateDialog(int id, Bundle args) throws NoSuchMethodException, SecurityException {
        Dialog retval = super.onCreateDialog(id, args);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onCreateDialog", Integer.TYPE, Bundle.class, Dialog.class);
            return (Dialog) InvokeMethod(method, Integer.valueOf(id), args, retval);
        } catch (Exception e) {
            return retval;
        }
    }

    @Override // android.app.Activity
    protected void onPostCreate(Bundle savedInstanceState) throws NoSuchMethodException, SecurityException {
        super.onPostCreate(savedInstanceState);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onPostCreate", Bundle.class);
            InvokeMethod(method, savedInstanceState);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onPostResume() throws NoSuchMethodException, SecurityException {
        super.onPostResume();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onPostResume", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onPrepareDialog(int id, Dialog dialog) throws NoSuchMethodException, SecurityException {
        super.onPrepareDialog(id, dialog);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onPrepareDialog", R.id.class, Dialog.class);
            InvokeMethod(method, Integer.valueOf(id), dialog);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onPrepareDialog(int id, Dialog dialog, Bundle args) throws NoSuchMethodException, SecurityException {
        super.onPrepareDialog(id, dialog, args);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onPrepareDialog", R.id.class, Dialog.class, Bundle.class);
            InvokeMethod(method, Integer.valueOf(id), dialog, args);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onRestoreInstanceState(Bundle savedInstanceState) throws NoSuchMethodException, SecurityException {
        super.onRestoreInstanceState(savedInstanceState);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onRestoreInstanceState", Bundle.class);
            InvokeMethod(method, savedInstanceState);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onSaveInstanceState(Bundle outState) throws NoSuchMethodException, SecurityException {
        super.onSaveInstanceState(outState);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onSaveInstanceState", Bundle.class);
            InvokeMethod(method, outState);
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onTitleChanged(CharSequence title, int color) throws NoSuchMethodException, SecurityException {
        super.onTitleChanged(title, color);
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onTitleChanged", CharSequence.class, Integer.TYPE);
            InvokeMethod(method, title, Integer.valueOf(color));
        } catch (Exception e) {
        }
    }

    @Override // android.app.Activity
    protected void onUserLeaveHint() throws NoSuchMethodException, SecurityException {
        super.onUserLeaveHint();
        try {
            Method method = sAndroidActivityWrapperClass.getMethod("onUserLeaveHint", new Class[0]);
            InvokeMethod(method, new Object[0]);
        } catch (Exception e) {
        }
    }
}
