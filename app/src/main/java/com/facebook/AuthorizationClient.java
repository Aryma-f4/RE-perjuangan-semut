package com.facebook;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.text.TextUtils;
import android.webkit.CookieSyncManager;
import com.facebook.Request;
import com.facebook.RequestBatch;
import com.facebook.internal.AnalyticsEvents;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.PlatformServiceClient;
import com.facebook.internal.ServerProtocol;
import com.facebook.internal.Utility;
import com.facebook.model.GraphMultiResult;
import com.facebook.model.GraphObject;
import com.facebook.model.GraphObjectList;
import com.facebook.model.GraphUser;
import com.facebook.widget.FacebookDialog;
import com.facebook.widget.WebDialog;
import com.freshplanet.ane.AirFacebook.AirFacebookExtension;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
class AuthorizationClient implements Serializable {
    static final String EVENT_EXTRAS_APP_CALL_ID = "call_id";
    static final String EVENT_EXTRAS_DEFAULT_AUDIENCE = "default_audience";
    static final String EVENT_EXTRAS_IS_LEGACY = "is_legacy";
    static final String EVENT_EXTRAS_LOGIN_BEHAVIOR = "login_behavior";
    static final String EVENT_EXTRAS_MISSING_INTERNET_PERMISSION = "no_internet_permission";
    static final String EVENT_EXTRAS_NEW_PERMISSIONS = "new_permissions";
    static final String EVENT_EXTRAS_NOT_TRIED = "not_tried";
    static final String EVENT_EXTRAS_PERMISSIONS = "permissions";
    static final String EVENT_EXTRAS_PROTOCOL_VERSION = "protocol_version";
    static final String EVENT_EXTRAS_REQUEST_CODE = "request_code";
    static final String EVENT_EXTRAS_SERVICE_DISABLED = "service_disabled";
    static final String EVENT_EXTRAS_TRY_LEGACY = "try_legacy";
    static final String EVENT_EXTRAS_TRY_LOGIN_ACTIVITY = "try_login_activity";
    static final String EVENT_EXTRAS_WRITE_PRIVACY = "write_privacy";
    static final String EVENT_NAME_LOGIN_COMPLETE = "fb_mobile_login_complete";
    private static final String EVENT_NAME_LOGIN_METHOD_COMPLETE = "fb_mobile_login_method_complete";
    private static final String EVENT_NAME_LOGIN_METHOD_START = "fb_mobile_login_method_start";
    static final String EVENT_NAME_LOGIN_START = "fb_mobile_login_start";
    static final String EVENT_PARAM_AUTH_LOGGER_ID = "0_auth_logger_id";
    static final String EVENT_PARAM_ERROR_CODE = "4_error_code";
    static final String EVENT_PARAM_ERROR_MESSAGE = "5_error_message";
    static final String EVENT_PARAM_EXTRAS = "6_extras";
    static final String EVENT_PARAM_LOGIN_RESULT = "2_result";
    static final String EVENT_PARAM_METHOD = "3_method";
    private static final String EVENT_PARAM_METHOD_RESULT_SKIPPED = "skipped";
    static final String EVENT_PARAM_TIMESTAMP = "1_timestamp_ms";
    private static final String TAG = "Facebook-AuthorizationClient";
    private static final String WEB_VIEW_AUTH_HANDLER_STORE = "com.facebook.AuthorizationClient.WebViewAuthHandler.TOKEN_STORE_KEY";
    private static final String WEB_VIEW_AUTH_HANDLER_TOKEN_KEY = "TOKEN";
    private static final long serialVersionUID = 1;
    private transient AppEventsLogger appEventsLogger;
    transient BackgroundProcessingListener backgroundProcessingListener;
    transient boolean checkedInternetPermission;
    transient Context context;
    AuthHandler currentHandler;
    List<AuthHandler> handlersToTry;
    Map<String, String> loggingExtras;
    transient OnCompletedListener onCompletedListener;
    AuthorizationRequest pendingRequest;
    transient StartActivityDelegate startActivityDelegate;

    static class AuthDialogBuilder extends WebDialog.Builder {
        private static final String OAUTH_DIALOG = "oauth";
        static final String REDIRECT_URI = "fbconnect://success";
        private String e2e;

        public AuthDialogBuilder(Context context, String str, Bundle bundle) {
            super(context, str, OAUTH_DIALOG, bundle);
        }

        @Override // com.facebook.widget.WebDialog.Builder, com.facebook.widget.WebDialog.BuilderBase
        public WebDialog build() {
            Bundle parameters = getParameters();
            parameters.putString(ServerProtocol.DIALOG_PARAM_REDIRECT_URI, "fbconnect://success");
            parameters.putString("client_id", getApplicationId());
            parameters.putString("e2e", this.e2e);
            return new WebDialog(getContext(), OAUTH_DIALOG, parameters, getTheme(), getListener());
        }

        public AuthDialogBuilder setE2E(String str) {
            this.e2e = str;
            return this;
        }
    }

    abstract class AuthHandler implements Serializable {
        private static final long serialVersionUID = 1;
        Map<String, String> methodLoggingExtras;

        AuthHandler() {
        }

        protected void addLoggingExtra(String str, Object obj) {
            if (this.methodLoggingExtras == null) {
                this.methodLoggingExtras = new HashMap();
            }
            this.methodLoggingExtras.put(str, obj == null ? null : obj.toString());
        }

        void cancel() {
        }

        abstract String getNameForLogging();

        boolean needsInternetPermission() {
            return false;
        }

        boolean needsRestart() {
            return false;
        }

        boolean onActivityResult(int i, int i2, Intent intent) {
            return false;
        }

        abstract boolean tryAuthorize(AuthorizationRequest authorizationRequest);
    }

    static class AuthorizationRequest implements Serializable {
        private static final long serialVersionUID = 1;
        private final String applicationId;
        private final String authId;
        private final SessionDefaultAudience defaultAudience;
        private boolean isLegacy;
        private final SessionLoginBehavior loginBehavior;
        private List<String> permissions;
        private final String previousAccessToken;
        private final int requestCode;
        private final transient StartActivityDelegate startActivityDelegate;

        AuthorizationRequest(SessionLoginBehavior sessionLoginBehavior, int i, boolean z, List<String> list, SessionDefaultAudience sessionDefaultAudience, String str, String str2, StartActivityDelegate startActivityDelegate, String str3) {
            this.isLegacy = false;
            this.loginBehavior = sessionLoginBehavior;
            this.requestCode = i;
            this.isLegacy = z;
            this.permissions = list;
            this.defaultAudience = sessionDefaultAudience;
            this.applicationId = str;
            this.previousAccessToken = str2;
            this.startActivityDelegate = startActivityDelegate;
            this.authId = str3;
        }

        String getApplicationId() {
            return this.applicationId;
        }

        String getAuthId() {
            return this.authId;
        }

        SessionDefaultAudience getDefaultAudience() {
            return this.defaultAudience;
        }

        SessionLoginBehavior getLoginBehavior() {
            return this.loginBehavior;
        }

        List<String> getPermissions() {
            return this.permissions;
        }

        String getPreviousAccessToken() {
            return this.previousAccessToken;
        }

        int getRequestCode() {
            return this.requestCode;
        }

        StartActivityDelegate getStartActivityDelegate() {
            return this.startActivityDelegate;
        }

        boolean isLegacy() {
            return this.isLegacy;
        }

        boolean needsNewTokenValidation() {
            return (this.previousAccessToken == null || this.isLegacy) ? false : true;
        }

        void setIsLegacy(boolean z) {
            this.isLegacy = z;
        }

        void setPermissions(List<String> list) {
            this.permissions = list;
        }
    }

    interface BackgroundProcessingListener {
        void onBackgroundProcessingStarted();

        void onBackgroundProcessingStopped();
    }

    class GetTokenAuthHandler extends AuthHandler {
        private static final long serialVersionUID = 1;
        private transient GetTokenClient getTokenClient;

        GetTokenAuthHandler() {
            super();
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        void cancel() {
            if (this.getTokenClient != null) {
                this.getTokenClient.cancel();
                this.getTokenClient = null;
            }
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        String getNameForLogging() {
            return "get_token";
        }

        void getTokenCompleted(AuthorizationRequest authorizationRequest, Bundle bundle) throws NumberFormatException {
            this.getTokenClient = null;
            AuthorizationClient.this.notifyBackgroundProcessingStop();
            if (bundle != null) {
                ArrayList<String> stringArrayList = bundle.getStringArrayList(NativeProtocol.EXTRA_PERMISSIONS);
                List<String> permissions = authorizationRequest.getPermissions();
                if (stringArrayList != null && (permissions == null || stringArrayList.containsAll(permissions))) {
                    AuthorizationClient.this.completeAndValidate(Result.createTokenResult(AuthorizationClient.this.pendingRequest, AccessToken.createFromNativeLogin(bundle, AccessTokenSource.FACEBOOK_APPLICATION_SERVICE)));
                    return;
                }
                ArrayList arrayList = new ArrayList();
                for (String str : permissions) {
                    if (!stringArrayList.contains(str)) {
                        arrayList.add(str);
                    }
                }
                if (!arrayList.isEmpty()) {
                    addLoggingExtra(AuthorizationClient.EVENT_EXTRAS_NEW_PERMISSIONS, TextUtils.join(",", arrayList));
                }
                authorizationRequest.setPermissions(arrayList);
            }
            AuthorizationClient.this.tryNextHandler();
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean needsRestart() {
            return this.getTokenClient == null;
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean tryAuthorize(final AuthorizationRequest authorizationRequest) {
            this.getTokenClient = new GetTokenClient(AuthorizationClient.this.context, authorizationRequest.getApplicationId());
            if (!this.getTokenClient.start()) {
                return false;
            }
            AuthorizationClient.this.notifyBackgroundProcessingStart();
            this.getTokenClient.setCompletedListener(new PlatformServiceClient.CompletedListener() { // from class: com.facebook.AuthorizationClient.GetTokenAuthHandler.1
                @Override // com.facebook.internal.PlatformServiceClient.CompletedListener
                public void completed(Bundle bundle) throws NumberFormatException {
                    GetTokenAuthHandler.this.getTokenCompleted(authorizationRequest, bundle);
                }
            });
            return true;
        }
    }

    abstract class KatanaAuthHandler extends AuthHandler {
        private static final long serialVersionUID = 1;

        KatanaAuthHandler() {
            super();
        }

        protected boolean tryIntent(Intent intent, int i) {
            if (intent == null) {
                return false;
            }
            try {
                AuthorizationClient.this.getStartActivityDelegate().startActivityForResult(intent, i);
                return true;
            } catch (ActivityNotFoundException e) {
                return false;
            }
        }
    }

    class KatanaLoginDialogAuthHandler extends KatanaAuthHandler {
        private static final long serialVersionUID = 1;
        private String applicationId;
        private String callId;

        KatanaLoginDialogAuthHandler() {
            super();
        }

        private Result createCancelOrErrorResult(AuthorizationRequest authorizationRequest, Intent intent) throws JSONException {
            String string;
            Bundle extras = intent.getExtras();
            String string2 = extras.getString(NativeProtocol.STATUS_ERROR_TYPE);
            if (NativeProtocol.ERROR_USER_CANCELED.equals(string2) || NativeProtocol.ERROR_PERMISSION_DENIED.equals(string2)) {
                return Result.createCancelResult(authorizationRequest, intent.getStringExtra(NativeProtocol.STATUS_ERROR_DESCRIPTION));
            }
            String string3 = extras.getString(NativeProtocol.STATUS_ERROR_JSON);
            if (string3 != null) {
                try {
                    string = new JSONObject(string3).getString("error_code");
                } catch (JSONException e) {
                    string = null;
                }
            } else {
                string = null;
            }
            return Result.createErrorResult(authorizationRequest, string2, intent.getStringExtra(NativeProtocol.STATUS_ERROR_DESCRIPTION), string);
        }

        private Result handleResultOk(Intent intent) {
            Bundle extras = intent.getExtras();
            String string = extras.getString(NativeProtocol.STATUS_ERROR_TYPE);
            if (string == null) {
                return Result.createTokenResult(AuthorizationClient.this.pendingRequest, AccessToken.createFromNativeLogin(extras, AccessTokenSource.FACEBOOK_APPLICATION_NATIVE));
            }
            if (!NativeProtocol.ERROR_SERVICE_DISABLED.equals(string)) {
                return createCancelOrErrorResult(AuthorizationClient.this.pendingRequest, intent);
            }
            addLoggingExtra("service_disabled", AppEventsConstants.EVENT_PARAM_VALUE_YES);
            return null;
        }

        private void logEvent(String str, String str2, String str3) {
            if (str3 != null) {
                AppEventsLogger appEventsLoggerNewLogger = AppEventsLogger.newLogger(AuthorizationClient.this.context, this.applicationId);
                Bundle bundle = new Bundle();
                bundle.putString("app_id", this.applicationId);
                bundle.putString(AnalyticsEvents.PARAMETER_ACTION_ID, str3);
                bundle.putLong(str2, System.currentTimeMillis());
                appEventsLoggerNewLogger.logSdkEvent(str, null, bundle);
            }
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        String getNameForLogging() {
            return "katana_login_dialog";
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean onActivityResult(int i, int i2, Intent intent) {
            logEvent(AnalyticsEvents.EVENT_NATIVE_LOGIN_DIALOG_COMPLETE, AnalyticsEvents.PARAMETER_NATIVE_LOGIN_DIALOG_COMPLETE_TIME, this.callId);
            Result resultCreateCancelResult = intent == null ? Result.createCancelResult(AuthorizationClient.this.pendingRequest, "Operation canceled") : NativeProtocol.isServiceDisabledResult20121101(intent) ? null : i2 == 0 ? createCancelOrErrorResult(AuthorizationClient.this.pendingRequest, intent) : i2 != -1 ? Result.createErrorResult(AuthorizationClient.this.pendingRequest, "Unexpected resultCode from authorization.", null) : handleResultOk(intent);
            if (resultCreateCancelResult != null) {
                AuthorizationClient.this.completeAndValidate(resultCreateCancelResult);
                return true;
            }
            AuthorizationClient.this.tryNextHandler();
            return true;
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean tryAuthorize(AuthorizationRequest authorizationRequest) {
            this.applicationId = authorizationRequest.getApplicationId();
            Intent intentCreateLoginDialog20121101Intent = NativeProtocol.createLoginDialog20121101Intent(AuthorizationClient.this.context, authorizationRequest.getApplicationId(), new ArrayList(authorizationRequest.getPermissions()), authorizationRequest.getDefaultAudience().getNativeProtocolAudience());
            if (intentCreateLoginDialog20121101Intent == null) {
                return false;
            }
            this.callId = intentCreateLoginDialog20121101Intent.getStringExtra(NativeProtocol.EXTRA_PROTOCOL_CALL_ID);
            addLoggingExtra(AuthorizationClient.EVENT_EXTRAS_APP_CALL_ID, this.callId);
            addLoggingExtra(AuthorizationClient.EVENT_EXTRAS_PROTOCOL_VERSION, Integer.valueOf(intentCreateLoginDialog20121101Intent.getIntExtra(NativeProtocol.EXTRA_PROTOCOL_VERSION, 0)));
            addLoggingExtra(AuthorizationClient.EVENT_EXTRAS_PERMISSIONS, TextUtils.join(",", intentCreateLoginDialog20121101Intent.getStringArrayListExtra(NativeProtocol.EXTRA_PERMISSIONS)));
            addLoggingExtra(AuthorizationClient.EVENT_EXTRAS_WRITE_PRIVACY, intentCreateLoginDialog20121101Intent.getStringExtra(NativeProtocol.EXTRA_WRITE_PRIVACY));
            logEvent(AnalyticsEvents.EVENT_NATIVE_LOGIN_DIALOG_START, AnalyticsEvents.PARAMETER_NATIVE_LOGIN_DIALOG_START_TIME, this.callId);
            return tryIntent(intentCreateLoginDialog20121101Intent, authorizationRequest.getRequestCode());
        }
    }

    class KatanaProxyAuthHandler extends KatanaAuthHandler {
        private static final long serialVersionUID = 1;
        private String applicationId;

        KatanaProxyAuthHandler() {
            super();
        }

        private Result handleResultOk(Intent intent) {
            Bundle extras = intent.getExtras();
            String string = extras.getString("error");
            if (string == null) {
                string = extras.getString("error_type");
            }
            String string2 = extras.getString("error_code");
            String string3 = extras.getString("error_message");
            if (string3 == null) {
                string3 = extras.getString("error_description");
            }
            String string4 = extras.getString("e2e");
            if (!Utility.isNullOrEmpty(string4)) {
                AuthorizationClient.this.logWebLoginCompleted(this.applicationId, string4);
            }
            if (string == null && string2 == null && string3 == null) {
                return Result.createTokenResult(AuthorizationClient.this.pendingRequest, AccessToken.createFromWebBundle(AuthorizationClient.this.pendingRequest.getPermissions(), extras, AccessTokenSource.FACEBOOK_APPLICATION_WEB));
            }
            if (ServerProtocol.errorsProxyAuthDisabled.contains(string)) {
                return null;
            }
            return ServerProtocol.errorsUserCanceled.contains(string) ? Result.createCancelResult(AuthorizationClient.this.pendingRequest, null) : Result.createErrorResult(AuthorizationClient.this.pendingRequest, string, string3, string2);
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        String getNameForLogging() {
            return "katana_proxy_auth";
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean onActivityResult(int i, int i2, Intent intent) {
            Result resultCreateCancelResult = intent == null ? Result.createCancelResult(AuthorizationClient.this.pendingRequest, "Operation canceled") : i2 == 0 ? Result.createCancelResult(AuthorizationClient.this.pendingRequest, intent.getStringExtra("error")) : i2 != -1 ? Result.createErrorResult(AuthorizationClient.this.pendingRequest, "Unexpected resultCode from authorization.", null) : handleResultOk(intent);
            if (resultCreateCancelResult != null) {
                AuthorizationClient.this.completeAndValidate(resultCreateCancelResult);
                return true;
            }
            AuthorizationClient.this.tryNextHandler();
            return true;
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean tryAuthorize(AuthorizationRequest authorizationRequest) throws JSONException {
            this.applicationId = authorizationRequest.getApplicationId();
            String e2e = AuthorizationClient.getE2E();
            Intent intentCreateProxyAuthIntent = NativeProtocol.createProxyAuthIntent(AuthorizationClient.this.context, authorizationRequest.getApplicationId(), authorizationRequest.getPermissions(), e2e);
            addLoggingExtra("e2e", e2e);
            return tryIntent(intentCreateProxyAuthIntent, authorizationRequest.getRequestCode());
        }
    }

    interface OnCompletedListener {
        void onCompleted(Result result);
    }

    static class Result implements Serializable {
        private static final long serialVersionUID = 1;
        final Code code;
        final String errorCode;
        final String errorMessage;
        Map<String, String> loggingExtras;
        final AuthorizationRequest request;
        final AccessToken token;

        enum Code {
            SUCCESS("success"),
            CANCEL(FacebookDialog.COMPLETION_GESTURE_CANCEL),
            ERROR("error");

            private final String loggingValue;

            Code(String str) {
                this.loggingValue = str;
            }

            String getLoggingValue() {
                return this.loggingValue;
            }
        }

        private Result(AuthorizationRequest authorizationRequest, Code code, AccessToken accessToken, String str, String str2) {
            this.request = authorizationRequest;
            this.token = accessToken;
            this.errorMessage = str;
            this.code = code;
            this.errorCode = str2;
        }

        static Result createCancelResult(AuthorizationRequest authorizationRequest, String str) {
            return new Result(authorizationRequest, Code.CANCEL, null, str, null);
        }

        static Result createErrorResult(AuthorizationRequest authorizationRequest, String str, String str2) {
            return createErrorResult(authorizationRequest, str, str2, null);
        }

        static Result createErrorResult(AuthorizationRequest authorizationRequest, String str, String str2, String str3) {
            return new Result(authorizationRequest, Code.ERROR, null, TextUtils.join(": ", Utility.asListNoNulls(str, str2)), str3);
        }

        static Result createTokenResult(AuthorizationRequest authorizationRequest, AccessToken accessToken) {
            return new Result(authorizationRequest, Code.SUCCESS, accessToken, null, null);
        }
    }

    interface StartActivityDelegate {
        Activity getActivityContext();

        void startActivityForResult(Intent intent, int i);
    }

    class WebViewAuthHandler extends AuthHandler {
        private static final long serialVersionUID = 1;
        private String applicationId;
        private String e2e;
        private transient WebDialog loginDialog;

        WebViewAuthHandler() {
            super();
        }

        private String loadCookieToken() {
            return AuthorizationClient.this.getStartActivityDelegate().getActivityContext().getSharedPreferences(AuthorizationClient.WEB_VIEW_AUTH_HANDLER_STORE, 0).getString(AuthorizationClient.WEB_VIEW_AUTH_HANDLER_TOKEN_KEY, "");
        }

        private void saveCookieToken(String str) {
            SharedPreferences.Editor editorEdit = AuthorizationClient.this.getStartActivityDelegate().getActivityContext().getSharedPreferences(AuthorizationClient.WEB_VIEW_AUTH_HANDLER_STORE, 0).edit();
            editorEdit.putString(AuthorizationClient.WEB_VIEW_AUTH_HANDLER_TOKEN_KEY, str);
            if (editorEdit.commit()) {
                return;
            }
            Utility.logd(AuthorizationClient.TAG, "Could not update saved web view auth handler token.");
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        void cancel() {
            if (this.loginDialog != null) {
                this.loginDialog.dismiss();
                this.loginDialog = null;
            }
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        String getNameForLogging() {
            return "web_view";
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean needsInternetPermission() {
            return true;
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean needsRestart() {
            return true;
        }

        void onWebDialogComplete(AuthorizationRequest authorizationRequest, Bundle bundle, FacebookException facebookException) throws NumberFormatException {
            String str;
            Result resultCreateErrorResult;
            if (bundle != null) {
                if (bundle.containsKey("e2e")) {
                    this.e2e = bundle.getString("e2e");
                }
                AccessToken accessTokenCreateFromWebBundle = AccessToken.createFromWebBundle(authorizationRequest.getPermissions(), bundle, AccessTokenSource.WEB_VIEW);
                Result resultCreateTokenResult = Result.createTokenResult(AuthorizationClient.this.pendingRequest, accessTokenCreateFromWebBundle);
                CookieSyncManager.createInstance(AuthorizationClient.this.context).sync();
                saveCookieToken(accessTokenCreateFromWebBundle.getToken());
                resultCreateErrorResult = resultCreateTokenResult;
            } else if (facebookException instanceof FacebookOperationCanceledException) {
                resultCreateErrorResult = Result.createCancelResult(AuthorizationClient.this.pendingRequest, "User canceled log in.");
            } else {
                this.e2e = null;
                String message = facebookException.getMessage();
                if (facebookException instanceof FacebookServiceException) {
                    FacebookRequestError requestError = ((FacebookServiceException) facebookException).getRequestError();
                    str = String.format("%d", Integer.valueOf(requestError.getErrorCode()));
                    message = requestError.toString();
                } else {
                    str = null;
                }
                resultCreateErrorResult = Result.createErrorResult(AuthorizationClient.this.pendingRequest, null, message, str);
            }
            if (!Utility.isNullOrEmpty(this.e2e)) {
                AuthorizationClient.this.logWebLoginCompleted(this.applicationId, this.e2e);
            }
            AuthorizationClient.this.completeAndValidate(resultCreateErrorResult);
        }

        @Override // com.facebook.AuthorizationClient.AuthHandler
        boolean tryAuthorize(final AuthorizationRequest authorizationRequest) {
            this.applicationId = authorizationRequest.getApplicationId();
            Bundle bundle = new Bundle();
            if (!Utility.isNullOrEmpty(authorizationRequest.getPermissions())) {
                String strJoin = TextUtils.join(",", authorizationRequest.getPermissions());
                bundle.putString("scope", strJoin);
                addLoggingExtra("scope", strJoin);
            }
            String previousAccessToken = authorizationRequest.getPreviousAccessToken();
            if (Utility.isNullOrEmpty(previousAccessToken) || !previousAccessToken.equals(loadCookieToken())) {
                Utility.clearFacebookCookies(AuthorizationClient.this.context);
                addLoggingExtra("access_token", AppEventsConstants.EVENT_PARAM_VALUE_NO);
            } else {
                bundle.putString("access_token", previousAccessToken);
                addLoggingExtra("access_token", AppEventsConstants.EVENT_PARAM_VALUE_YES);
            }
            WebDialog.OnCompleteListener onCompleteListener = new WebDialog.OnCompleteListener() { // from class: com.facebook.AuthorizationClient.WebViewAuthHandler.1
                @Override // com.facebook.widget.WebDialog.OnCompleteListener
                public void onComplete(Bundle bundle2, FacebookException facebookException) throws NumberFormatException {
                    WebViewAuthHandler.this.onWebDialogComplete(authorizationRequest, bundle2, facebookException);
                }
            };
            this.e2e = AuthorizationClient.getE2E();
            addLoggingExtra("e2e", this.e2e);
            this.loginDialog = new AuthDialogBuilder(AuthorizationClient.this.getStartActivityDelegate().getActivityContext(), this.applicationId, bundle).setE2E(this.e2e).setOnCompleteListener(onCompleteListener).build();
            this.loginDialog.show();
            return true;
        }
    }

    AuthorizationClient() {
    }

    private void addLoggingExtra(String str, String str2, boolean z) {
        if (this.loggingExtras == null) {
            this.loggingExtras = new HashMap();
        }
        this.loggingExtras.put(str, (this.loggingExtras.containsKey(str) && z) ? this.loggingExtras.get(str) + "," + str2 : str2);
    }

    private void completeWithFailure() {
        complete(Result.createErrorResult(this.pendingRequest, "Login attempt failed.", null));
    }

    private AppEventsLogger getAppEventsLogger() {
        if (this.appEventsLogger == null || this.appEventsLogger.getApplicationId() != this.pendingRequest.getApplicationId()) {
            this.appEventsLogger = AppEventsLogger.newLogger(this.context, this.pendingRequest.getApplicationId());
        }
        return this.appEventsLogger;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static String getE2E() throws JSONException {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("init", System.currentTimeMillis());
        } catch (JSONException e) {
        }
        return jSONObject.toString();
    }

    private List<AuthHandler> getHandlerTypes(AuthorizationRequest authorizationRequest) {
        ArrayList arrayList = new ArrayList();
        SessionLoginBehavior loginBehavior = authorizationRequest.getLoginBehavior();
        if (loginBehavior.allowsKatanaAuth()) {
            if (!authorizationRequest.isLegacy()) {
                arrayList.add(new GetTokenAuthHandler());
                arrayList.add(new KatanaLoginDialogAuthHandler());
            }
            arrayList.add(new KatanaProxyAuthHandler());
        }
        if (loginBehavior.allowsWebViewAuth()) {
            arrayList.add(new WebViewAuthHandler());
        }
        return arrayList;
    }

    private void logAuthorizationMethodComplete(String str, Result result, Map<String, String> map) {
        logAuthorizationMethodComplete(str, result.code.getLoggingValue(), result.errorMessage, result.errorCode, map);
    }

    private void logAuthorizationMethodComplete(String str, String str2, String str3, String str4, Map<String, String> map) {
        Bundle bundleNewAuthorizationLoggingBundle;
        if (this.pendingRequest == null) {
            bundleNewAuthorizationLoggingBundle = newAuthorizationLoggingBundle("");
            bundleNewAuthorizationLoggingBundle.putString(EVENT_PARAM_LOGIN_RESULT, Result.Code.ERROR.getLoggingValue());
            bundleNewAuthorizationLoggingBundle.putString(EVENT_PARAM_ERROR_MESSAGE, "Unexpected call to logAuthorizationMethodComplete with null pendingRequest.");
        } else {
            bundleNewAuthorizationLoggingBundle = newAuthorizationLoggingBundle(this.pendingRequest.getAuthId());
            if (str2 != null) {
                bundleNewAuthorizationLoggingBundle.putString(EVENT_PARAM_LOGIN_RESULT, str2);
            }
            if (str3 != null) {
                bundleNewAuthorizationLoggingBundle.putString(EVENT_PARAM_ERROR_MESSAGE, str3);
            }
            if (str4 != null) {
                bundleNewAuthorizationLoggingBundle.putString(EVENT_PARAM_ERROR_CODE, str4);
            }
            if (map != null && !map.isEmpty()) {
                bundleNewAuthorizationLoggingBundle.putString(EVENT_PARAM_EXTRAS, new JSONObject(map).toString());
            }
        }
        bundleNewAuthorizationLoggingBundle.putString(EVENT_PARAM_METHOD, str);
        bundleNewAuthorizationLoggingBundle.putLong(EVENT_PARAM_TIMESTAMP, System.currentTimeMillis());
        getAppEventsLogger().logSdkEvent(EVENT_NAME_LOGIN_METHOD_COMPLETE, null, bundleNewAuthorizationLoggingBundle);
    }

    private void logAuthorizationMethodStart(String str) {
        Bundle bundleNewAuthorizationLoggingBundle = newAuthorizationLoggingBundle(this.pendingRequest.getAuthId());
        bundleNewAuthorizationLoggingBundle.putLong(EVENT_PARAM_TIMESTAMP, System.currentTimeMillis());
        bundleNewAuthorizationLoggingBundle.putString(EVENT_PARAM_METHOD, str);
        getAppEventsLogger().logSdkEvent(EVENT_NAME_LOGIN_METHOD_START, null, bundleNewAuthorizationLoggingBundle);
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void logWebLoginCompleted(String str, String str2) {
        AppEventsLogger appEventsLoggerNewLogger = AppEventsLogger.newLogger(this.context, str);
        Bundle bundle = new Bundle();
        bundle.putString(AnalyticsEvents.PARAMETER_WEB_LOGIN_E2E, str2);
        bundle.putLong(AnalyticsEvents.PARAMETER_WEB_LOGIN_SWITCHBACK_TIME, System.currentTimeMillis());
        bundle.putString("app_id", str);
        appEventsLoggerNewLogger.logSdkEvent(AnalyticsEvents.EVENT_WEB_LOGIN_COMPLETE, null, bundle);
    }

    static Bundle newAuthorizationLoggingBundle(String str) {
        Bundle bundle = new Bundle();
        bundle.putLong(EVENT_PARAM_TIMESTAMP, System.currentTimeMillis());
        bundle.putString(EVENT_PARAM_AUTH_LOGGER_ID, str);
        bundle.putString(EVENT_PARAM_METHOD, "");
        bundle.putString(EVENT_PARAM_LOGIN_RESULT, "");
        bundle.putString(EVENT_PARAM_ERROR_MESSAGE, "");
        bundle.putString(EVENT_PARAM_ERROR_CODE, "");
        bundle.putString(EVENT_PARAM_EXTRAS, "");
        return bundle;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void notifyBackgroundProcessingStart() {
        if (this.backgroundProcessingListener != null) {
            this.backgroundProcessingListener.onBackgroundProcessingStarted();
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void notifyBackgroundProcessingStop() {
        if (this.backgroundProcessingListener != null) {
            this.backgroundProcessingListener.onBackgroundProcessingStopped();
        }
    }

    private void notifyOnCompleteListener(Result result) {
        if (this.onCompletedListener != null) {
            this.onCompletedListener.onCompleted(result);
        }
    }

    void authorize(AuthorizationRequest authorizationRequest) {
        if (authorizationRequest == null) {
            return;
        }
        if (this.pendingRequest != null) {
            throw new FacebookException("Attempted to authorize while a request is pending.");
        }
        if (!authorizationRequest.needsNewTokenValidation() || checkInternetPermission()) {
            this.pendingRequest = authorizationRequest;
            this.handlersToTry = getHandlerTypes(authorizationRequest);
            tryNextHandler();
        }
    }

    void cancelCurrentHandler() {
        if (this.currentHandler != null) {
            this.currentHandler.cancel();
        }
    }

    boolean checkInternetPermission() {
        if (this.checkedInternetPermission) {
            return true;
        }
        if (checkPermission("android.permission.INTERNET") == 0) {
            this.checkedInternetPermission = true;
            return true;
        }
        complete(Result.createErrorResult(this.pendingRequest, this.context.getString(AirFacebookExtension.getResourceId("string.com_facebook_internet_permission_error_title")), this.context.getString(AirFacebookExtension.getResourceId("string.com_facebook_internet_permission_error_message"))));
        return false;
    }

    int checkPermission(String str) {
        return this.context.checkCallingOrSelfPermission(str);
    }

    void complete(Result result) {
        if (this.currentHandler != null) {
            logAuthorizationMethodComplete(this.currentHandler.getNameForLogging(), result, this.currentHandler.methodLoggingExtras);
        }
        if (this.loggingExtras != null) {
            result.loggingExtras = this.loggingExtras;
        }
        this.handlersToTry = null;
        this.currentHandler = null;
        this.pendingRequest = null;
        this.loggingExtras = null;
        notifyOnCompleteListener(result);
    }

    void completeAndValidate(Result result) {
        if (result.token == null || !this.pendingRequest.needsNewTokenValidation()) {
            complete(result);
        } else {
            validateSameFbidAndFinish(result);
        }
    }

    void continueAuth() {
        if (this.pendingRequest == null || this.currentHandler == null) {
            throw new FacebookException("Attempted to continue authorization without a pending request.");
        }
        if (this.currentHandler.needsRestart()) {
            this.currentHandler.cancel();
            tryCurrentHandler();
        }
    }

    Request createGetPermissionsRequest(String str) {
        Bundle bundle = new Bundle();
        bundle.putString("fields", "id");
        bundle.putString("access_token", str);
        return new Request(null, "me/permissions", bundle, HttpMethod.GET, null);
    }

    Request createGetProfileIdRequest(String str) {
        Bundle bundle = new Bundle();
        bundle.putString("fields", "id");
        bundle.putString("access_token", str);
        return new Request(null, "me", bundle, HttpMethod.GET, null);
    }

    RequestBatch createReauthValidationBatch(final Result result) {
        final ArrayList arrayList = new ArrayList();
        final ArrayList arrayList2 = new ArrayList();
        String token = result.token.getToken();
        Request.Callback callback = new Request.Callback() { // from class: com.facebook.AuthorizationClient.3
            @Override // com.facebook.Request.Callback
            public void onCompleted(Response response) {
                try {
                    GraphUser graphUser = (GraphUser) response.getGraphObjectAs(GraphUser.class);
                    if (graphUser != null) {
                        arrayList.add(graphUser.getId());
                    }
                } catch (Exception e) {
                }
            }
        };
        String previousAccessToken = this.pendingRequest.getPreviousAccessToken();
        Request requestCreateGetProfileIdRequest = createGetProfileIdRequest(previousAccessToken);
        requestCreateGetProfileIdRequest.setCallback(callback);
        Request requestCreateGetProfileIdRequest2 = createGetProfileIdRequest(token);
        requestCreateGetProfileIdRequest2.setCallback(callback);
        Request requestCreateGetPermissionsRequest = createGetPermissionsRequest(previousAccessToken);
        requestCreateGetPermissionsRequest.setCallback(new Request.Callback() { // from class: com.facebook.AuthorizationClient.4
            @Override // com.facebook.Request.Callback
            public void onCompleted(Response response) {
                GraphObjectList<GraphObject> data;
                try {
                    GraphMultiResult graphMultiResult = (GraphMultiResult) response.getGraphObjectAs(GraphMultiResult.class);
                    if (graphMultiResult == null || (data = graphMultiResult.getData()) == null || data.size() != 1) {
                        return;
                    }
                    arrayList2.addAll(data.get(0).asMap().keySet());
                } catch (Exception e) {
                }
            }
        });
        RequestBatch requestBatch = new RequestBatch(requestCreateGetProfileIdRequest, requestCreateGetProfileIdRequest2, requestCreateGetPermissionsRequest);
        requestBatch.setBatchApplicationId(this.pendingRequest.getApplicationId());
        requestBatch.addCallback(new RequestBatch.Callback() { // from class: com.facebook.AuthorizationClient.5
            @Override // com.facebook.RequestBatch.Callback
            public void onBatchCompleted(RequestBatch requestBatch2) {
                Result resultCreateErrorResult;
                try {
                    if (arrayList.size() != 2 || arrayList.get(0) == null || arrayList.get(1) == null || !((String) arrayList.get(0)).equals(arrayList.get(1))) {
                        resultCreateErrorResult = Result.createErrorResult(AuthorizationClient.this.pendingRequest, "User logged in as different Facebook user.", null);
                    } else {
                        resultCreateErrorResult = Result.createTokenResult(AuthorizationClient.this.pendingRequest, AccessToken.createFromTokenWithRefreshedPermissions(result.token, arrayList2));
                    }
                    AuthorizationClient.this.complete(resultCreateErrorResult);
                } catch (Exception e) {
                    AuthorizationClient.this.complete(Result.createErrorResult(AuthorizationClient.this.pendingRequest, "Caught exception", e.getMessage()));
                } finally {
                    AuthorizationClient.this.notifyBackgroundProcessingStop();
                }
            }
        });
        return requestBatch;
    }

    BackgroundProcessingListener getBackgroundProcessingListener() {
        return this.backgroundProcessingListener;
    }

    boolean getInProgress() {
        return (this.pendingRequest == null || this.currentHandler == null) ? false : true;
    }

    OnCompletedListener getOnCompletedListener() {
        return this.onCompletedListener;
    }

    StartActivityDelegate getStartActivityDelegate() {
        if (this.startActivityDelegate != null) {
            return this.startActivityDelegate;
        }
        if (this.pendingRequest != null) {
            return new StartActivityDelegate() { // from class: com.facebook.AuthorizationClient.2
                @Override // com.facebook.AuthorizationClient.StartActivityDelegate
                public Activity getActivityContext() {
                    return AuthorizationClient.this.pendingRequest.getStartActivityDelegate().getActivityContext();
                }

                @Override // com.facebook.AuthorizationClient.StartActivityDelegate
                public void startActivityForResult(Intent intent, int i) {
                    AuthorizationClient.this.pendingRequest.getStartActivityDelegate().startActivityForResult(intent, i);
                }
            };
        }
        return null;
    }

    boolean onActivityResult(int i, int i2, Intent intent) {
        if (i == this.pendingRequest.getRequestCode()) {
            return this.currentHandler.onActivityResult(i, i2, intent);
        }
        return false;
    }

    void setBackgroundProcessingListener(BackgroundProcessingListener backgroundProcessingListener) {
        this.backgroundProcessingListener = backgroundProcessingListener;
    }

    void setContext(final Activity activity) {
        this.context = activity;
        this.startActivityDelegate = new StartActivityDelegate() { // from class: com.facebook.AuthorizationClient.1
            @Override // com.facebook.AuthorizationClient.StartActivityDelegate
            public Activity getActivityContext() {
                return activity;
            }

            @Override // com.facebook.AuthorizationClient.StartActivityDelegate
            public void startActivityForResult(Intent intent, int i) {
                activity.startActivityForResult(intent, i);
            }
        };
    }

    void setContext(Context context) {
        this.context = context;
        this.startActivityDelegate = null;
    }

    void setOnCompletedListener(OnCompletedListener onCompletedListener) {
        this.onCompletedListener = onCompletedListener;
    }

    void startOrContinueAuth(AuthorizationRequest authorizationRequest) {
        if (getInProgress()) {
            continueAuth();
        } else {
            authorize(authorizationRequest);
        }
    }

    boolean tryCurrentHandler() {
        if (this.currentHandler.needsInternetPermission() && !checkInternetPermission()) {
            addLoggingExtra(EVENT_EXTRAS_MISSING_INTERNET_PERMISSION, AppEventsConstants.EVENT_PARAM_VALUE_YES, false);
            return false;
        }
        boolean zTryAuthorize = this.currentHandler.tryAuthorize(this.pendingRequest);
        if (zTryAuthorize) {
            logAuthorizationMethodStart(this.currentHandler.getNameForLogging());
            return zTryAuthorize;
        }
        addLoggingExtra(EVENT_EXTRAS_NOT_TRIED, this.currentHandler.getNameForLogging(), true);
        return zTryAuthorize;
    }

    void tryNextHandler() {
        if (this.currentHandler != null) {
            logAuthorizationMethodComplete(this.currentHandler.getNameForLogging(), EVENT_PARAM_METHOD_RESULT_SKIPPED, null, null, this.currentHandler.methodLoggingExtras);
        }
        while (this.handlersToTry != null && !this.handlersToTry.isEmpty()) {
            this.currentHandler = this.handlersToTry.remove(0);
            if (tryCurrentHandler()) {
                return;
            }
        }
        if (this.pendingRequest != null) {
            completeWithFailure();
        }
    }

    void validateSameFbidAndFinish(Result result) {
        if (result.token == null) {
            throw new FacebookException("Can't validate without a token");
        }
        RequestBatch requestBatchCreateReauthValidationBatch = createReauthValidationBatch(result);
        notifyBackgroundProcessingStart();
        requestBatchCreateReauthValidationBatch.executeAsync();
    }
}
