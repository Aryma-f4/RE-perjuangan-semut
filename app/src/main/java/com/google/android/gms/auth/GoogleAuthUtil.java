package com.google.android.gms.auth;

import android.R;
import android.accounts.AccountManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.os.RemoteException;
import android.text.TextUtils;
import android.util.Log;
import com.facebook.internal.NativeProtocol;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.a;
import com.google.android.gms.internal.a;
import java.io.IOException;
import java.net.URISyntaxException;
import java.security.cert.CertificateException;

/* loaded from: classes.dex */
public final class GoogleAuthUtil {
    public static final String GOOGLE_ACCOUNT_TYPE = "com.google";
    public static final String KEY_ANDROID_PACKAGE_NAME;
    public static final String KEY_CALLER_UID;
    public static final String KEY_REQUEST_ACTIONS = "request_visible_actions";

    @Deprecated
    public static final String KEY_REQUEST_VISIBLE_ACTIVITIES = "request_visible_actions";
    public static final String KEY_SUPPRESS_PROGRESS_SCREEN = "suppressProgressScreen";
    private static final ComponentName u;
    private static final ComponentName v;
    private static final Intent w;
    private static final Intent x;

    static {
        KEY_CALLER_UID = Build.VERSION.SDK_INT >= 11 ? "callerUid" : "callerUid";
        KEY_ANDROID_PACKAGE_NAME = Build.VERSION.SDK_INT >= 14 ? "androidPackageName" : "androidPackageName";
        u = new ComponentName(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE, "com.google.android.gms.auth.GetToken");
        v = new ComponentName(GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_PACKAGE, "com.google.android.gms.recovery.RecoveryService");
        w = new Intent().setComponent(u);
        x = new Intent().setComponent(v);
    }

    private GoogleAuthUtil() {
    }

    private static String a(Context context, String str, String str2, Bundle bundle) throws Resources.NotFoundException, IOException, GoogleAuthException {
        int i;
        try {
            return getToken(context, str, str2, bundle == null ? new Bundle() : bundle);
        } catch (GooglePlayServicesAvailabilityException e) {
            PendingIntent errorPendingIntent = GooglePlayServicesUtil.getErrorPendingIntent(e.getConnectionStatusCode(), context, 0);
            Resources resources = context.getResources();
            Notification notification = new Notification(R.drawable.stat_sys_warning, resources.getString(com.google.android.gms.R.string.auth_client_play_services_err_notification_msg), System.currentTimeMillis());
            notification.flags |= 16;
            String packageName = context.getApplicationInfo().name;
            if (TextUtils.isEmpty(packageName)) {
                packageName = context.getPackageName();
            }
            String string = resources.getString(com.google.android.gms.R.string.auth_client_requested_by_msg, packageName);
            switch (e.getConnectionStatusCode()) {
                case 1:
                    i = com.google.android.gms.R.string.auth_client_needs_installation_title;
                    break;
                case 2:
                    i = com.google.android.gms.R.string.auth_client_needs_update_title;
                    break;
                case 3:
                    i = com.google.android.gms.R.string.auth_client_needs_enabling_title;
                    break;
                default:
                    i = com.google.android.gms.R.string.auth_client_using_bad_version_title;
                    break;
            }
            notification.setLatestEventInfo(context, resources.getString(i), string, errorPendingIntent);
            ((NotificationManager) context.getSystemService("notification")).notify(39789, notification);
            throw new UserRecoverableNotifiedException("User intervention required. Notification has been pushed.");
        } catch (UserRecoverableAuthException e2) {
            throw new UserRecoverableNotifiedException("User intervention required. Notification has been pushed.");
        }
    }

    private static void a(Context context) throws PackageManager.NameNotFoundException, GoogleAuthException, CertificateException {
        int iIsGooglePlayServicesAvailable = GooglePlayServicesUtil.isGooglePlayServicesAvailable(context);
        if (iIsGooglePlayServicesAvailable != 0) {
            Intent intentA = GooglePlayServicesUtil.a(context, iIsGooglePlayServicesAvailable, -1);
            String str = "GooglePlayServices not available due to error " + iIsGooglePlayServicesAvailable;
            Log.e("GoogleAuthUtil", str);
            if (intentA != null) {
                throw new GooglePlayServicesAvailabilityException(iIsGooglePlayServicesAvailable, "GooglePlayServicesNotAvailable", intentA);
            }
            throw new GoogleAuthException(str);
        }
    }

    private static void a(Intent intent) throws URISyntaxException {
        if (intent == null) {
            throw new IllegalArgumentException("Callack cannot be null.");
        }
        try {
            Intent.parseUri(intent.toUri(1), 1);
        } catch (URISyntaxException e) {
            throw new IllegalArgumentException("Parameter callback contains invalid data. It must be serializable using toUri() and parseUri().");
        }
    }

    private static boolean a(String str) {
        return NativeProtocol.ERROR_NETWORK_ERROR.equals(str) || "ServiceUnavailable".equals(str) || "Timeout".equals(str);
    }

    private static void b(Context context) {
        Looper looperMyLooper = Looper.myLooper();
        if (looperMyLooper == null || looperMyLooper != context.getMainLooper()) {
            return;
        }
        IllegalStateException illegalStateException = new IllegalStateException("calling this from your main thread can lead to deadlock");
        Log.e("GoogleAuthUtil", "Calling this from your main thread can lead to deadlock and/or ANRs", illegalStateException);
        throw illegalStateException;
    }

    private static boolean b(String str) {
        return "BadAuthentication".equals(str) || "CaptchaRequired".equals(str) || "DeviceManagementRequiredOrSyncDisabled".equals(str) || "NeedPermission".equals(str) || "NeedsBrowser".equals(str) || "UserCancel".equals(str) || "AppDownloadRequired".equals(str);
    }

    public static String getToken(Context context, String accountName, String scope) throws IOException, GoogleAuthException {
        return getToken(context, accountName, scope, new Bundle());
    }

    public static String getToken(Context context, String accountName, String scope, Bundle extras) throws PackageManager.NameNotFoundException, GoogleAuthException, IOException, CertificateException {
        Context applicationContext = context.getApplicationContext();
        b(applicationContext);
        a(applicationContext);
        Bundle extras2 = extras == null ? new Bundle() : new Bundle(extras);
        if (!extras2.containsKey(KEY_ANDROID_PACKAGE_NAME)) {
            extras2.putString(KEY_ANDROID_PACKAGE_NAME, context.getPackageName());
        }
        a aVar = new a();
        try {
            if (!context.bindService(w, aVar, 1)) {
                throw new UserRecoverableAuthException("AppDownloadRequired", null);
            }
            try {
                Bundle bundleA = a.AbstractBinderC0006a.a(aVar.e()).a(accountName, scope, extras2);
                String string = bundleA.getString("authtoken");
                if (!TextUtils.isEmpty(string)) {
                    return string;
                }
                String string2 = bundleA.getString("Error");
                Intent intent = (Intent) bundleA.getParcelable("userRecoveryIntent");
                if (b(string2)) {
                    throw new UserRecoverableAuthException(string2, intent);
                }
                if (a(string2)) {
                    throw new IOException(string2);
                }
                throw new GoogleAuthException(string2);
            } catch (RemoteException e) {
                Log.i("GoogleAuthUtil", "GMS remote exception ", e);
                throw new IOException("remote exception");
            } catch (InterruptedException e2) {
                throw new GoogleAuthException("Interrupted");
            }
        } finally {
            context.unbindService(aVar);
        }
    }

    public static String getTokenWithNotification(Context context, String accountName, String scope, Bundle extras) throws IOException, GoogleAuthException {
        if (extras == null) {
            extras = new Bundle();
        }
        extras.putBoolean("handle_notification", true);
        return a(context, accountName, scope, extras);
    }

    public static String getTokenWithNotification(Context context, String accountName, String scope, Bundle extras, Intent callback) throws URISyntaxException, IOException, GoogleAuthException {
        a(callback);
        if (extras == null) {
            extras = new Bundle();
        }
        extras.putParcelable("callback_intent", callback);
        extras.putBoolean("handle_notification", true);
        return a(context, accountName, scope, extras);
    }

    public static String getTokenWithNotification(Context context, String accountName, String scope, Bundle extras, String authority, Bundle syncBundle) throws IOException, GoogleAuthException {
        if (TextUtils.isEmpty(authority)) {
            throw new IllegalArgumentException("Authority cannot be empty or null.");
        }
        if (extras == null) {
            extras = new Bundle();
        }
        if (syncBundle == null) {
            syncBundle = new Bundle();
        }
        ContentResolver.validateSyncExtrasBundle(syncBundle);
        extras.putString("authority", authority);
        extras.putBundle("sync_extras", syncBundle);
        extras.putBoolean("handle_notification", true);
        return a(context, accountName, scope, extras);
    }

    public static void invalidateToken(Context context, String token) {
        AccountManager.get(context).invalidateAuthToken(GOOGLE_ACCOUNT_TYPE, token);
    }
}
