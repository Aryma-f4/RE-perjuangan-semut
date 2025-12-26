package com.facebook;

import android.content.ContentResolver;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import com.facebook.Request;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import com.facebook.model.GraphObject;
import java.net.HttpURLConnection;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.Executor;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public final class Settings {
    private static final String ANALYTICS_EVENT = "event";
    private static final String APP_EVENT_PREFERENCES = "com.facebook.sdk.appEventPreferences";
    private static final String ATTRIBUTION_ID_COLUMN_NAME = "aid";
    private static final String ATTRIBUTION_PREFERENCES = "com.facebook.sdk.attributionTracking";
    private static final String AUTO_PUBLISH = "auto_publish";
    private static final int DEFAULT_CORE_POOL_SIZE = 5;
    private static final int DEFAULT_KEEP_ALIVE = 1;
    private static final int DEFAULT_MAXIMUM_POOL_SIZE = 128;
    private static final String MOBILE_INSTALL_EVENT = "MOBILE_APP_INSTALL";
    private static final String PUBLISH_ACTIVITY_PATH = "%s/activities";
    private static volatile String appVersion;
    private static volatile Executor executor;
    private static volatile boolean shouldAutoPublishInstall;
    private static final String TAG = Settings.class.getCanonicalName();
    private static final HashSet<LoggingBehavior> loggingBehaviors = new HashSet<>(Arrays.asList(LoggingBehavior.DEVELOPER_ERRORS));
    private static final String FACEBOOK_COM = "facebook.com";
    private static volatile String facebookDomain = FACEBOOK_COM;
    private static final Object LOCK = new Object();
    private static final Uri ATTRIBUTION_ID_CONTENT_URI = Uri.parse("content://com.facebook.katana.provider.AttributionIdProvider");
    private static final BlockingQueue<Runnable> DEFAULT_WORK_QUEUE = new LinkedBlockingQueue(10);
    private static final ThreadFactory DEFAULT_THREAD_FACTORY = new ThreadFactory() { // from class: com.facebook.Settings.1
        private final AtomicInteger counter = new AtomicInteger(0);

        @Override // java.util.concurrent.ThreadFactory
        public Thread newThread(Runnable runnable) {
            return new Thread(runnable, "FacebookSdk #" + this.counter.incrementAndGet());
        }
    };

    public static final void addLoggingBehavior(LoggingBehavior loggingBehavior) {
        synchronized (loggingBehaviors) {
            loggingBehaviors.add(loggingBehavior);
        }
    }

    public static final void clearLoggingBehaviors() {
        synchronized (loggingBehaviors) {
            loggingBehaviors.clear();
        }
    }

    public static String getAppVersion() {
        return appVersion;
    }

    private static Executor getAsyncTaskExecutor() throws IllegalAccessException, IllegalArgumentException {
        try {
            try {
                Object obj = AsyncTask.class.getField("THREAD_POOL_EXECUTOR").get(null);
                if (obj != null && (obj instanceof Executor)) {
                    return (Executor) obj;
                }
                return null;
            } catch (IllegalAccessException e) {
                return null;
            }
        } catch (NoSuchFieldException e2) {
            return null;
        }
    }

    public static String getAttributionId(ContentResolver contentResolver) {
        try {
            Cursor cursorQuery = contentResolver.query(ATTRIBUTION_ID_CONTENT_URI, new String[]{"aid"}, null, null, null);
            if (cursorQuery == null || !cursorQuery.moveToFirst()) {
                return null;
            }
            String string = cursorQuery.getString(cursorQuery.getColumnIndex("aid"));
            cursorQuery.close();
            return string;
        } catch (Exception e) {
            Log.d(TAG, "Caught unexpected exception in getAttributionId(): " + e.toString());
            return null;
        }
    }

    public static Executor getExecutor() {
        synchronized (LOCK) {
            if (executor == null) {
                Executor asyncTaskExecutor = getAsyncTaskExecutor();
                if (asyncTaskExecutor == null) {
                    asyncTaskExecutor = new ThreadPoolExecutor(5, 128, 1L, TimeUnit.SECONDS, DEFAULT_WORK_QUEUE, DEFAULT_THREAD_FACTORY);
                }
                executor = asyncTaskExecutor;
            }
        }
        return executor;
    }

    public static String getFacebookDomain() {
        return facebookDomain;
    }

    public static boolean getLimitEventAndDataUsage(Context context) {
        return context.getSharedPreferences(APP_EVENT_PREFERENCES, 0).getBoolean("limitEventUsage", false);
    }

    public static final Set<LoggingBehavior> getLoggingBehaviors() {
        Set<LoggingBehavior> setUnmodifiableSet;
        synchronized (loggingBehaviors) {
            setUnmodifiableSet = Collections.unmodifiableSet(new HashSet(loggingBehaviors));
        }
        return setUnmodifiableSet;
    }

    public static String getMigrationBundle() {
        return FacebookSdkVersion.MIGRATION_BUNDLE;
    }

    public static String getSdkVersion() {
        return FacebookSdkVersion.BUILD;
    }

    @Deprecated
    public static boolean getShouldAutoPublishInstall() {
        return shouldAutoPublishInstall;
    }

    public static final boolean isLoggingBehaviorEnabled(LoggingBehavior loggingBehavior) {
        boolean zContains;
        synchronized (loggingBehaviors) {
            zContains = loggingBehaviors.contains(loggingBehavior);
        }
        return zContains;
    }

    @Deprecated
    public static boolean publishInstallAndWait(Context context, String str) {
        Response responsePublishInstallAndWaitForResponse = publishInstallAndWaitForResponse(context, str);
        return responsePublishInstallAndWaitForResponse != null && responsePublishInstallAndWaitForResponse.getError() == null;
    }

    @Deprecated
    public static Response publishInstallAndWaitForResponse(Context context, String str) {
        return publishInstallAndWaitForResponse(context, str, false);
    }

    static Response publishInstallAndWaitForResponse(Context context, String str, boolean z) {
        try {
            if (context == null || str == null) {
                throw new IllegalArgumentException("Both context and applicationId must be non-null");
            }
            String attributionId = getAttributionId(context.getContentResolver());
            SharedPreferences sharedPreferences = context.getSharedPreferences(ATTRIBUTION_PREFERENCES, 0);
            String str2 = str + "ping";
            String str3 = str + "json";
            long j = sharedPreferences.getLong(str2, 0L);
            String string = sharedPreferences.getString(str3, null);
            if (!z) {
                setShouldAutoPublishInstall(false);
            }
            GraphObject graphObjectCreate = GraphObject.Factory.create();
            graphObjectCreate.setProperty(ANALYTICS_EVENT, MOBILE_INSTALL_EVENT);
            Utility.setAppEventAttributionParameters(graphObjectCreate, attributionId, Utility.getHashedDeviceAndAppID(context, str), !getLimitEventAndDataUsage(context));
            graphObjectCreate.setProperty(AUTO_PUBLISH, Boolean.valueOf(z));
            graphObjectCreate.setProperty("application_package_name", context.getPackageName());
            Request requestNewPostRequest = Request.newPostRequest(null, String.format(PUBLISH_ACTIVITY_PATH, str), graphObjectCreate, null);
            if (j != 0) {
                GraphObject graphObjectCreate2 = null;
                if (string != null) {
                    try {
                        graphObjectCreate2 = GraphObject.Factory.create(new JSONObject(string));
                    } catch (JSONException e) {
                    }
                }
                return graphObjectCreate2 == null ? Response.createResponsesFromString("true", null, new RequestBatch(requestNewPostRequest), true).get(0) : new Response((Request) null, (HttpURLConnection) null, graphObjectCreate2, true);
            }
            if (attributionId == null) {
                throw new FacebookException("No attribution id returned from the Facebook application");
            }
            if (!Utility.queryAppSettings(str, false).supportsAttribution()) {
                throw new FacebookException("Install attribution has been disabled on the server.");
            }
            Response responseExecuteAndWait = requestNewPostRequest.executeAndWait();
            SharedPreferences.Editor editorEdit = sharedPreferences.edit();
            editorEdit.putLong(str2, System.currentTimeMillis());
            if (responseExecuteAndWait.getGraphObject() != null && responseExecuteAndWait.getGraphObject().getInnerJSONObject() != null) {
                editorEdit.putString(str3, responseExecuteAndWait.getGraphObject().getInnerJSONObject().toString());
            }
            editorEdit.commit();
            return responseExecuteAndWait;
        } catch (Exception e2) {
            Utility.logd("Facebook-publish", e2);
            return new Response(null, null, new FacebookRequestError(null, e2));
        }
    }

    @Deprecated
    public static void publishInstallAsync(Context context, String str) {
        publishInstallAsync(context, str, null);
    }

    @Deprecated
    public static void publishInstallAsync(Context context, final String str, final Request.Callback callback) {
        final Context applicationContext = context.getApplicationContext();
        getExecutor().execute(new Runnable() { // from class: com.facebook.Settings.2
            @Override // java.lang.Runnable
            public void run() {
                final Response responsePublishInstallAndWaitForResponse = Settings.publishInstallAndWaitForResponse(applicationContext, str);
                if (callback != null) {
                    new Handler(Looper.getMainLooper()).post(new Runnable() { // from class: com.facebook.Settings.2.1
                        @Override // java.lang.Runnable
                        public void run() {
                            callback.onCompleted(responsePublishInstallAndWaitForResponse);
                        }
                    });
                }
            }
        });
    }

    public static final void removeLoggingBehavior(LoggingBehavior loggingBehavior) {
        synchronized (loggingBehaviors) {
            loggingBehaviors.remove(loggingBehavior);
        }
    }

    public static void setAppVersion(String str) {
        appVersion = str;
    }

    public static void setExecutor(Executor executor2) {
        Validate.notNull(executor2, "executor");
        synchronized (LOCK) {
            executor = executor2;
        }
    }

    public static void setFacebookDomain(String str) {
        facebookDomain = str;
    }

    public static void setLimitEventAndDataUsage(Context context, boolean z) {
        SharedPreferences.Editor editorEdit = context.getSharedPreferences(APP_EVENT_PREFERENCES, 0).edit();
        editorEdit.putBoolean("limitEventUsage", z);
        editorEdit.commit();
    }

    @Deprecated
    public static void setShouldAutoPublishInstall(boolean z) {
        shouldAutoPublishInstall = z;
    }
}
