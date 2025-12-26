package com.facebook;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.PlatformServiceClient;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class AppLinkData {
    private static final String APPLINK_BRIDGE_ARGS_KEY = "bridge_args";
    private static final String APPLINK_METHOD_ARGS_KEY = "method_args";
    private static final String APPLINK_VERSION_KEY = "version";
    public static final String ARGUMENTS_TAPTIME_KEY = "com.facebook.platform.APPLINK_TAP_TIME_UTC";
    private static final String BRIDGE_ARGS_METHOD_KEY = "method";
    private static final String BUNDLE_APPLINK_ARGS_KEY = "com.facebook.platform.APPLINK_ARGS";
    private static final String METHOD_ARGS_REF_KEY = "ref";
    private static final String METHOD_ARGS_TARGET_URL_KEY = "target_url";
    private static final String TAG = AppLinkData.class.getCanonicalName();
    private JSONObject arguments;
    private String[] ref;
    private Uri targetUri;
    private String version;

    public interface CompletionHandler {
        void onDeferredAppLinkDataFetched(AppLinkData appLinkData);
    }

    static final class DeferredAppLinkDataClient extends PlatformServiceClient {
        DeferredAppLinkDataClient(Context context, String str) {
            super(context, NativeProtocol.MESSAGE_GET_INSTALL_DATA_REQUEST, NativeProtocol.MESSAGE_GET_INSTALL_DATA_REPLY, NativeProtocol.PROTOCOL_VERSION_20130618, str);
        }

        @Override // com.facebook.internal.PlatformServiceClient
        protected void populateRequestBundle(Bundle bundle) {
            bundle.putString(NativeProtocol.EXTRA_GET_INSTALL_DATA_PACKAGE, getContext().getPackageName());
        }
    }

    private AppLinkData() {
    }

    public static AppLinkData createFromActivity(Activity activity) throws JSONException {
        Validate.notNull(activity, "activity");
        Intent intent = activity.getIntent();
        if (intent == null) {
            return null;
        }
        AppLinkData appLinkDataCreateFromJson = createFromJson(intent.getStringExtra(BUNDLE_APPLINK_ARGS_KEY));
        return appLinkDataCreateFromJson == null ? createFromUri(intent.getData()) : appLinkDataCreateFromJson;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static AppLinkData createFromJson(String str) throws JSONException {
        String string;
        if (str == null) {
            return null;
        }
        try {
            JSONObject jSONObject = new JSONObject(str);
            String string2 = jSONObject.getString("version");
            if (jSONObject.getJSONObject(APPLINK_BRIDGE_ARGS_KEY).getString(BRIDGE_ARGS_METHOD_KEY).equals("applink") && string2.equals("2")) {
                AppLinkData appLinkData = new AppLinkData();
                appLinkData.version = string2;
                appLinkData.arguments = jSONObject.getJSONObject(APPLINK_METHOD_ARGS_KEY);
                if (appLinkData.arguments.has(METHOD_ARGS_REF_KEY) && (string = appLinkData.arguments.getString(METHOD_ARGS_REF_KEY)) != null) {
                    appLinkData.ref = string.split(",");
                }
                if (appLinkData.arguments.has(METHOD_ARGS_TARGET_URL_KEY)) {
                    appLinkData.targetUri = Uri.parse(appLinkData.arguments.getString(METHOD_ARGS_TARGET_URL_KEY));
                }
                return appLinkData;
            }
        } catch (JSONException e) {
            Log.d(TAG, "Unable to parse AppLink JSON");
        }
        return null;
    }

    private static AppLinkData createFromUri(Uri uri) {
        if (uri == null) {
        }
        return null;
    }

    public static void fetchDeferredAppLinkData(Context context, CompletionHandler completionHandler) {
        fetchDeferredAppLinkData(context, null, completionHandler);
    }

    public static void fetchDeferredAppLinkData(Context context, String str, final CompletionHandler completionHandler) {
        Validate.notNull(context, "context");
        Validate.notNull(completionHandler, "completionHandler");
        String metadataApplicationId = str == null ? Utility.getMetadataApplicationId(context) : str;
        Validate.notNull(metadataApplicationId, "applicationId");
        DeferredAppLinkDataClient deferredAppLinkDataClient = new DeferredAppLinkDataClient(context, metadataApplicationId);
        deferredAppLinkDataClient.setCompletedListener(new PlatformServiceClient.CompletedListener() { // from class: com.facebook.AppLinkData.1
            @Override // com.facebook.internal.PlatformServiceClient.CompletedListener
            public void completed(Bundle bundle) throws JSONException {
                AppLinkData appLinkDataCreateFromJson = null;
                if (bundle != null) {
                    String string = bundle.getString(AppLinkData.BUNDLE_APPLINK_ARGS_KEY);
                    long j = bundle.getLong(AppLinkData.ARGUMENTS_TAPTIME_KEY, -1L);
                    appLinkDataCreateFromJson = AppLinkData.createFromJson(string);
                    if (j != -1) {
                        try {
                            appLinkDataCreateFromJson.getArguments().put(AppLinkData.ARGUMENTS_TAPTIME_KEY, j);
                        } catch (JSONException e) {
                            Log.d(AppLinkData.TAG, "Unable to put tap time in AppLinkData.arguments");
                        }
                    }
                }
                completionHandler.onDeferredAppLinkDataFetched(appLinkDataCreateFromJson);
            }
        });
        if (deferredAppLinkDataClient.start()) {
            return;
        }
        new Handler(Looper.getMainLooper()).post(new Runnable() { // from class: com.facebook.AppLinkData.2
            @Override // java.lang.Runnable
            public void run() {
                completionHandler.onDeferredAppLinkDataFetched(null);
            }
        });
    }

    public JSONObject getArguments() {
        return this.arguments;
    }

    public String[] getRef() {
        return this.ref;
    }

    public Uri getTargetUri() {
        return this.targetUri;
    }
}
