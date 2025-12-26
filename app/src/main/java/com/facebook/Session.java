package com.facebook;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.support.v4.app.Fragment;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;
import com.facebook.AuthorizationClient;
import com.facebook.internal.NativeProtocol;
import com.facebook.internal.SessionAuthorizationType;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InvalidObjectException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class Session implements Serializable {
    public static final String ACTION_ACTIVE_SESSION_CLOSED = "com.facebook.sdk.ACTIVE_SESSION_CLOSED";
    public static final String ACTION_ACTIVE_SESSION_OPENED = "com.facebook.sdk.ACTIVE_SESSION_OPENED";
    public static final String ACTION_ACTIVE_SESSION_SET = "com.facebook.sdk.ACTIVE_SESSION_SET";
    public static final String ACTION_ACTIVE_SESSION_UNSET = "com.facebook.sdk.ACTIVE_SESSION_UNSET";
    public static final String APPLICATION_ID_PROPERTY = "com.facebook.sdk.ApplicationId";
    private static final String AUTH_BUNDLE_SAVE_KEY = "com.facebook.sdk.Session.authBundleKey";
    public static final int DEFAULT_AUTHORIZE_ACTIVITY_CODE = 64206;
    private static final String MANAGE_PERMISSION_PREFIX = "manage";
    private static final String PUBLISH_PERMISSION_PREFIX = "publish";
    private static final String SESSION_BUNDLE_SAVE_KEY = "com.facebook.sdk.Session.saveSessionKey";
    private static final int TOKEN_EXTEND_RETRY_SECONDS = 3600;
    private static final int TOKEN_EXTEND_THRESHOLD_SECONDS = 86400;
    public static final String WEB_VIEW_ERROR_CODE_KEY = "com.facebook.sdk.WebViewErrorCode";
    public static final String WEB_VIEW_FAILING_URL_KEY = "com.facebook.sdk.FailingUrl";
    private static Session activeSession = null;
    private static final long serialVersionUID = 1;
    private static volatile Context staticContext;
    private AppEventsLogger appEventsLogger;
    private String applicationId;
    private volatile Bundle authorizationBundle;
    private AuthorizationClient authorizationClient;
    private AutoPublishAsyncTask autoPublishAsyncTask;
    private final List<StatusCallback> callbacks;
    private volatile TokenRefreshRequest currentTokenRefreshRequest;
    private Handler handler;
    private Date lastAttemptedTokenExtendDate;
    private final Object lock;
    private AuthorizationRequest pendingAuthorizationRequest;
    private SessionState state;
    private TokenCachingStrategy tokenCachingStrategy;
    private AccessToken tokenInfo;
    public static final String TAG = Session.class.getCanonicalName();
    private static final Object STATIC_LOCK = new Object();
    private static final Set<String> OTHER_PUBLISH_PERMISSIONS = new HashSet<String>() { // from class: com.facebook.Session.1
        {
            add("ads_management");
            add("create_event");
            add("rsvp_event");
        }
    };

    public static class AuthorizationRequest implements Serializable {
        private static final long serialVersionUID = 1;
        private String applicationId;
        private final String authId;
        private SessionDefaultAudience defaultAudience;
        private boolean isLegacy;
        private final Map<String, String> loggingExtras;
        private SessionLoginBehavior loginBehavior;
        private List<String> permissions;
        private int requestCode;
        private final StartActivityDelegate startActivityDelegate;
        private StatusCallback statusCallback;
        private String validateSameFbidAsToken;

        private static class AuthRequestSerializationProxyV1 implements Serializable {
            private static final long serialVersionUID = -8748347685113614927L;
            private final String applicationId;
            private final String defaultAudience;
            private boolean isLegacy;
            private final SessionLoginBehavior loginBehavior;
            private final List<String> permissions;
            private final int requestCode;
            private final String validateSameFbidAsToken;

            private AuthRequestSerializationProxyV1(SessionLoginBehavior sessionLoginBehavior, int i, List<String> list, String str, boolean z, String str2, String str3) {
                this.loginBehavior = sessionLoginBehavior;
                this.requestCode = i;
                this.permissions = list;
                this.defaultAudience = str;
                this.isLegacy = z;
                this.applicationId = str2;
                this.validateSameFbidAsToken = str3;
            }

            private Object readResolve() {
                return new AuthorizationRequest(this.loginBehavior, this.requestCode, this.permissions, this.defaultAudience, this.isLegacy, this.applicationId, this.validateSameFbidAsToken);
            }
        }

        AuthorizationRequest(final Activity activity) {
            this.loginBehavior = SessionLoginBehavior.SSO_WITH_FALLBACK;
            this.requestCode = Session.DEFAULT_AUTHORIZE_ACTIVITY_CODE;
            this.isLegacy = false;
            this.permissions = Collections.emptyList();
            this.defaultAudience = SessionDefaultAudience.FRIENDS;
            this.authId = UUID.randomUUID().toString();
            this.loggingExtras = new HashMap();
            this.startActivityDelegate = new StartActivityDelegate() { // from class: com.facebook.Session.AuthorizationRequest.1
                @Override // com.facebook.Session.StartActivityDelegate
                public Activity getActivityContext() {
                    return activity;
                }

                @Override // com.facebook.Session.StartActivityDelegate
                public void startActivityForResult(Intent intent, int i) {
                    activity.startActivityForResult(intent, i);
                }
            };
        }

        AuthorizationRequest(final Fragment fragment) {
            this.loginBehavior = SessionLoginBehavior.SSO_WITH_FALLBACK;
            this.requestCode = Session.DEFAULT_AUTHORIZE_ACTIVITY_CODE;
            this.isLegacy = false;
            this.permissions = Collections.emptyList();
            this.defaultAudience = SessionDefaultAudience.FRIENDS;
            this.authId = UUID.randomUUID().toString();
            this.loggingExtras = new HashMap();
            this.startActivityDelegate = new StartActivityDelegate() { // from class: com.facebook.Session.AuthorizationRequest.2
                @Override // com.facebook.Session.StartActivityDelegate
                public Activity getActivityContext() {
                    return fragment.getActivity();
                }

                @Override // com.facebook.Session.StartActivityDelegate
                public void startActivityForResult(Intent intent, int i) {
                    fragment.startActivityForResult(intent, i);
                }
            };
        }

        private AuthorizationRequest(SessionLoginBehavior sessionLoginBehavior, int i, List<String> list, String str, boolean z, String str2, String str3) {
            this.loginBehavior = SessionLoginBehavior.SSO_WITH_FALLBACK;
            this.requestCode = Session.DEFAULT_AUTHORIZE_ACTIVITY_CODE;
            this.isLegacy = false;
            this.permissions = Collections.emptyList();
            this.defaultAudience = SessionDefaultAudience.FRIENDS;
            this.authId = UUID.randomUUID().toString();
            this.loggingExtras = new HashMap();
            this.startActivityDelegate = new StartActivityDelegate() { // from class: com.facebook.Session.AuthorizationRequest.3
                @Override // com.facebook.Session.StartActivityDelegate
                public Activity getActivityContext() {
                    throw new UnsupportedOperationException("Cannot create an AuthorizationRequest without a valid Activity or Fragment");
                }

                @Override // com.facebook.Session.StartActivityDelegate
                public void startActivityForResult(Intent intent, int i2) {
                    throw new UnsupportedOperationException("Cannot create an AuthorizationRequest without a valid Activity or Fragment");
                }
            };
            this.loginBehavior = sessionLoginBehavior;
            this.requestCode = i;
            this.permissions = list;
            this.defaultAudience = SessionDefaultAudience.valueOf(str);
            this.isLegacy = z;
            this.applicationId = str2;
            this.validateSameFbidAsToken = str3;
        }

        private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
            throw new InvalidObjectException("Cannot readObject, serialization proxy required");
        }

        String getApplicationId() {
            return this.applicationId;
        }

        String getAuthId() {
            return this.authId;
        }

        AuthorizationClient.AuthorizationRequest getAuthorizationClientRequest() {
            return new AuthorizationClient.AuthorizationRequest(this.loginBehavior, this.requestCode, this.isLegacy, this.permissions, this.defaultAudience, this.applicationId, this.validateSameFbidAsToken, new AuthorizationClient.StartActivityDelegate() { // from class: com.facebook.Session.AuthorizationRequest.4
                @Override // com.facebook.AuthorizationClient.StartActivityDelegate
                public Activity getActivityContext() {
                    return AuthorizationRequest.this.startActivityDelegate.getActivityContext();
                }

                @Override // com.facebook.AuthorizationClient.StartActivityDelegate
                public void startActivityForResult(Intent intent, int i) {
                    AuthorizationRequest.this.startActivityDelegate.startActivityForResult(intent, i);
                }
            }, this.authId);
        }

        StatusCallback getCallback() {
            return this.statusCallback;
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

        int getRequestCode() {
            return this.requestCode;
        }

        StartActivityDelegate getStartActivityDelegate() {
            return this.startActivityDelegate;
        }

        String getValidateSameFbidAsToken() {
            return this.validateSameFbidAsToken;
        }

        boolean isLegacy() {
            return this.isLegacy;
        }

        void setApplicationId(String str) {
            this.applicationId = str;
        }

        AuthorizationRequest setCallback(StatusCallback statusCallback) {
            this.statusCallback = statusCallback;
            return this;
        }

        AuthorizationRequest setDefaultAudience(SessionDefaultAudience sessionDefaultAudience) {
            if (sessionDefaultAudience != null) {
                this.defaultAudience = sessionDefaultAudience;
            }
            return this;
        }

        public void setIsLegacy(boolean z) {
            this.isLegacy = z;
        }

        AuthorizationRequest setLoginBehavior(SessionLoginBehavior sessionLoginBehavior) {
            if (sessionLoginBehavior != null) {
                this.loginBehavior = sessionLoginBehavior;
            }
            return this;
        }

        AuthorizationRequest setPermissions(List<String> list) {
            if (list != null) {
                this.permissions = list;
            }
            return this;
        }

        AuthorizationRequest setPermissions(String... strArr) {
            return setPermissions(Arrays.asList(strArr));
        }

        AuthorizationRequest setRequestCode(int i) {
            if (i >= 0) {
                this.requestCode = i;
            }
            return this;
        }

        void setValidateSameFbidAsToken(String str) {
            this.validateSameFbidAsToken = str;
        }

        Object writeReplace() {
            return new AuthRequestSerializationProxyV1(this.loginBehavior, this.requestCode, this.permissions, this.defaultAudience.name(), this.isLegacy, this.applicationId, this.validateSameFbidAsToken);
        }
    }

    private class AutoPublishAsyncTask extends AsyncTask<Void, Void, Void> {
        private final Context mApplicationContext;
        private final String mApplicationId;

        public AutoPublishAsyncTask(String str, Context context) {
            this.mApplicationId = str;
            this.mApplicationContext = context.getApplicationContext();
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public Void doInBackground(Void... voidArr) {
            try {
                Settings.publishInstallAndWaitForResponse(this.mApplicationContext, this.mApplicationId, true);
                return null;
            } catch (Exception e) {
                Utility.logd("Facebook-publish", e);
                return null;
            }
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public void onPostExecute(Void r4) {
            synchronized (Session.this) {
                Session.this.autoPublishAsyncTask = null;
            }
        }
    }

    public static final class Builder {
        private String applicationId;
        private final Context context;
        private TokenCachingStrategy tokenCachingStrategy;

        public Builder(Context context) {
            this.context = context;
        }

        public Session build() {
            return new Session(this.context, this.applicationId, this.tokenCachingStrategy);
        }

        public Builder setApplicationId(String str) {
            this.applicationId = str;
            return this;
        }

        public Builder setTokenCachingStrategy(TokenCachingStrategy tokenCachingStrategy) {
            this.tokenCachingStrategy = tokenCachingStrategy;
            return this;
        }
    }

    public static final class NewPermissionsRequest extends AuthorizationRequest {
        private static final long serialVersionUID = 1;

        public NewPermissionsRequest(Activity activity, List<String> list) {
            super(activity);
            setPermissions(list);
        }

        public NewPermissionsRequest(Activity activity, String... strArr) {
            super(activity);
            setPermissions(strArr);
        }

        public NewPermissionsRequest(Fragment fragment, List<String> list) {
            super(fragment);
            setPermissions(list);
        }

        public NewPermissionsRequest(Fragment fragment, String... strArr) {
            super(fragment);
            setPermissions(strArr);
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final NewPermissionsRequest setCallback(StatusCallback statusCallback) {
            super.setCallback(statusCallback);
            return this;
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final NewPermissionsRequest setDefaultAudience(SessionDefaultAudience sessionDefaultAudience) {
            super.setDefaultAudience(sessionDefaultAudience);
            return this;
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final NewPermissionsRequest setLoginBehavior(SessionLoginBehavior sessionLoginBehavior) {
            super.setLoginBehavior(sessionLoginBehavior);
            return this;
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final NewPermissionsRequest setRequestCode(int i) {
            super.setRequestCode(i);
            return this;
        }
    }

    public static final class OpenRequest extends AuthorizationRequest {
        private static final long serialVersionUID = 1;

        public OpenRequest(Activity activity) {
            super(activity);
        }

        public OpenRequest(Fragment fragment) {
            super(fragment);
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final OpenRequest setCallback(StatusCallback statusCallback) {
            super.setCallback(statusCallback);
            return this;
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final OpenRequest setDefaultAudience(SessionDefaultAudience sessionDefaultAudience) {
            super.setDefaultAudience(sessionDefaultAudience);
            return this;
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final OpenRequest setLoginBehavior(SessionLoginBehavior sessionLoginBehavior) {
            super.setLoginBehavior(sessionLoginBehavior);
            return this;
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public /* bridge */ /* synthetic */ AuthorizationRequest setPermissions(List list) {
            return setPermissions((List<String>) list);
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final OpenRequest setPermissions(List<String> list) {
            super.setPermissions(list);
            return this;
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final OpenRequest setPermissions(String... strArr) {
            super.setPermissions(strArr);
            return this;
        }

        @Override // com.facebook.Session.AuthorizationRequest
        public final OpenRequest setRequestCode(int i) {
            super.setRequestCode(i);
            return this;
        }
    }

    private static class SerializationProxyV1 implements Serializable {
        private static final long serialVersionUID = 7663436173185080063L;
        private final String applicationId;
        private final Date lastAttemptedTokenExtendDate;
        private final AuthorizationRequest pendingAuthorizationRequest;
        private final boolean shouldAutoPublish;
        private final SessionState state;
        private final AccessToken tokenInfo;

        SerializationProxyV1(String str, SessionState sessionState, AccessToken accessToken, Date date, boolean z, AuthorizationRequest authorizationRequest) {
            this.applicationId = str;
            this.state = sessionState;
            this.tokenInfo = accessToken;
            this.lastAttemptedTokenExtendDate = date;
            this.shouldAutoPublish = z;
            this.pendingAuthorizationRequest = authorizationRequest;
        }

        private Object readResolve() {
            return new Session(this.applicationId, this.state, this.tokenInfo, this.lastAttemptedTokenExtendDate, this.shouldAutoPublish, this.pendingAuthorizationRequest);
        }
    }

    interface StartActivityDelegate {
        Activity getActivityContext();

        void startActivityForResult(Intent intent, int i);
    }

    public interface StatusCallback {
        void call(Session session, SessionState sessionState, Exception exc);
    }

    class TokenRefreshRequest implements ServiceConnection {
        final Messenger messageReceiver;
        Messenger messageSender = null;

        TokenRefreshRequest() {
            this.messageReceiver = new Messenger(new TokenRefreshRequestHandler(Session.this, this));
        }

        /* JADX INFO: Access modifiers changed from: private */
        public void cleanup() {
            if (Session.this.currentTokenRefreshRequest == this) {
                Session.this.currentTokenRefreshRequest = null;
            }
        }

        private void refreshToken() throws RemoteException {
            Bundle bundle = new Bundle();
            bundle.putString("access_token", Session.this.getTokenInfo().getToken());
            Message messageObtain = Message.obtain();
            messageObtain.setData(bundle);
            messageObtain.replyTo = this.messageReceiver;
            try {
                this.messageSender.send(messageObtain);
            } catch (RemoteException e) {
                cleanup();
            }
        }

        public void bind() {
            Intent intentCreateTokenRefreshIntent = NativeProtocol.createTokenRefreshIntent(Session.getStaticContext());
            if (intentCreateTokenRefreshIntent == null || !Session.staticContext.bindService(intentCreateTokenRefreshIntent, this, 1)) {
                cleanup();
            } else {
                Session.this.setLastAttemptedTokenExtendDate(new Date());
            }
        }

        @Override // android.content.ServiceConnection
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) throws RemoteException {
            this.messageSender = new Messenger(iBinder);
            refreshToken();
        }

        @Override // android.content.ServiceConnection
        public void onServiceDisconnected(ComponentName componentName) {
            cleanup();
            Session.staticContext.unbindService(this);
        }
    }

    static class TokenRefreshRequestHandler extends Handler {
        private WeakReference<TokenRefreshRequest> refreshRequestWeakReference;
        private WeakReference<Session> sessionWeakReference;

        TokenRefreshRequestHandler(Session session, TokenRefreshRequest tokenRefreshRequest) {
            super(Looper.getMainLooper());
            this.sessionWeakReference = new WeakReference<>(session);
            this.refreshRequestWeakReference = new WeakReference<>(tokenRefreshRequest);
        }

        @Override // android.os.Handler
        public void handleMessage(Message message) {
            String string = message.getData().getString("access_token");
            Session session = this.sessionWeakReference.get();
            if (session != null && string != null) {
                session.extendTokenCompleted(message.getData());
            }
            TokenRefreshRequest tokenRefreshRequest = this.refreshRequestWeakReference.get();
            if (tokenRefreshRequest != null) {
                Session.staticContext.unbindService(tokenRefreshRequest);
                tokenRefreshRequest.cleanup();
            }
        }
    }

    public Session(Context context) {
        this(context, null, null, true);
    }

    Session(Context context, String str, TokenCachingStrategy tokenCachingStrategy) {
        this(context, str, tokenCachingStrategy, true);
    }

    Session(Context context, String str, TokenCachingStrategy tokenCachingStrategy, boolean z) {
        this.lastAttemptedTokenExtendDate = new Date(0L);
        this.lock = new Object();
        String metadataApplicationId = (context == null || str != null) ? str : Utility.getMetadataApplicationId(context);
        Validate.notNull(metadataApplicationId, "applicationId");
        initializeStaticContext(context);
        TokenCachingStrategy sharedPreferencesTokenCachingStrategy = tokenCachingStrategy == null ? new SharedPreferencesTokenCachingStrategy(staticContext) : tokenCachingStrategy;
        this.applicationId = metadataApplicationId;
        this.tokenCachingStrategy = sharedPreferencesTokenCachingStrategy;
        this.state = SessionState.CREATED;
        this.pendingAuthorizationRequest = null;
        this.callbacks = new ArrayList();
        this.handler = new Handler(Looper.getMainLooper());
        Bundle bundleLoad = z ? sharedPreferencesTokenCachingStrategy.load() : null;
        if (!TokenCachingStrategy.hasTokenInformation(bundleLoad)) {
            this.tokenInfo = AccessToken.createEmptyToken(Collections.emptyList());
            return;
        }
        Date date = TokenCachingStrategy.getDate(bundleLoad, TokenCachingStrategy.EXPIRATION_DATE_KEY);
        Date date2 = new Date();
        if (date == null || date.before(date2)) {
            sharedPreferencesTokenCachingStrategy.clear();
            this.tokenInfo = AccessToken.createEmptyToken(Collections.emptyList());
        } else {
            this.tokenInfo = AccessToken.createFromCache(bundleLoad);
            this.state = SessionState.CREATED_TOKEN_LOADED;
        }
    }

    private Session(String str, SessionState sessionState, AccessToken accessToken, Date date, boolean z, AuthorizationRequest authorizationRequest) {
        this.lastAttemptedTokenExtendDate = new Date(0L);
        this.lock = new Object();
        this.applicationId = str;
        this.state = sessionState;
        this.tokenInfo = accessToken;
        this.lastAttemptedTokenExtendDate = date;
        this.pendingAuthorizationRequest = authorizationRequest;
        this.handler = new Handler(Looper.getMainLooper());
        this.currentTokenRefreshRequest = null;
        this.tokenCachingStrategy = null;
        this.callbacks = new ArrayList();
    }

    private static boolean areEqual(Object obj, Object obj2) {
        return obj == null ? obj2 == null : obj.equals(obj2);
    }

    private void autoPublishAsync() {
        String str;
        AutoPublishAsyncTask autoPublishAsyncTask = null;
        synchronized (this) {
            if (this.autoPublishAsyncTask == null && Settings.getShouldAutoPublishInstall() && (str = this.applicationId) != null) {
                autoPublishAsyncTask = new AutoPublishAsyncTask(str, staticContext);
                this.autoPublishAsyncTask = autoPublishAsyncTask;
            }
        }
        if (autoPublishAsyncTask != null) {
            autoPublishAsyncTask.execute(new Void[0]);
        }
    }

    private void finishAuthorization(AccessToken accessToken, Exception exc) {
        SessionState sessionState = this.state;
        if (accessToken != null) {
            this.tokenInfo = accessToken;
            saveTokenToCache(accessToken);
            this.state = SessionState.OPENED;
        } else if (exc != null) {
            this.state = SessionState.CLOSED_LOGIN_FAILED;
        }
        this.pendingAuthorizationRequest = null;
        postStateChange(sessionState, this.state, exc);
    }

    private void finishReauthorization(AccessToken accessToken, Exception exc) {
        SessionState sessionState = this.state;
        if (accessToken != null) {
            this.tokenInfo = accessToken;
            saveTokenToCache(accessToken);
            this.state = SessionState.OPENED_TOKEN_UPDATED;
        }
        this.pendingAuthorizationRequest = null;
        postStateChange(sessionState, this.state, exc);
    }

    public static final Session getActiveSession() {
        Session session;
        synchronized (STATIC_LOCK) {
            session = activeSession;
        }
        return session;
    }

    private AppEventsLogger getAppEventsLogger() {
        AppEventsLogger appEventsLogger;
        synchronized (this.lock) {
            if (this.appEventsLogger == null) {
                this.appEventsLogger = AppEventsLogger.newLogger(staticContext, this.applicationId);
            }
            appEventsLogger = this.appEventsLogger;
        }
        return appEventsLogger;
    }

    private Intent getLoginActivityIntent(AuthorizationRequest authorizationRequest) {
        Intent intent = new Intent();
        intent.setClass(getStaticContext(), LoginActivity.class);
        intent.setAction(authorizationRequest.getLoginBehavior().toString());
        intent.putExtras(LoginActivity.populateIntentExtras(authorizationRequest.getAuthorizationClientRequest()));
        return intent;
    }

    static Context getStaticContext() {
        return staticContext;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void handleAuthorizationResult(int i, AuthorizationClient.Result result) throws JSONException {
        Exception facebookOperationCanceledException;
        AccessToken accessToken;
        if (i == -1) {
            if (result.code == AuthorizationClient.Result.Code.SUCCESS) {
                accessToken = result.token;
                facebookOperationCanceledException = null;
            } else {
                facebookOperationCanceledException = new FacebookAuthorizationException(result.errorMessage);
                accessToken = null;
            }
        } else if (i == 0) {
            facebookOperationCanceledException = new FacebookOperationCanceledException(result.errorMessage);
            accessToken = null;
        } else {
            facebookOperationCanceledException = null;
            accessToken = null;
        }
        logAuthorizationComplete(result.code, result.loggingExtras, facebookOperationCanceledException);
        this.authorizationClient = null;
        finishAuthOrReauth(accessToken, facebookOperationCanceledException);
    }

    static void initializeStaticContext(Context context) {
        if (context == null || staticContext != null) {
            return;
        }
        Context applicationContext = context.getApplicationContext();
        if (applicationContext == null) {
            applicationContext = context;
        }
        staticContext = applicationContext;
    }

    public static boolean isPublishPermission(String str) {
        return str != null && (str.startsWith(PUBLISH_PERMISSION_PREFIX) || str.startsWith(MANAGE_PERMISSION_PREFIX) || OTHER_PUBLISH_PERMISSIONS.contains(str));
    }

    private void logAuthorizationComplete(AuthorizationClient.Result.Code code, Map<String, String> map, Exception exc) throws JSONException {
        Bundle bundleNewAuthorizationLoggingBundle;
        if (this.pendingAuthorizationRequest == null) {
            bundleNewAuthorizationLoggingBundle = AuthorizationClient.newAuthorizationLoggingBundle("");
            bundleNewAuthorizationLoggingBundle.putString("2_result", AuthorizationClient.Result.Code.ERROR.getLoggingValue());
            bundleNewAuthorizationLoggingBundle.putString("5_error_message", "Unexpected call to logAuthorizationComplete with null pendingAuthorizationRequest.");
        } else {
            Bundle bundleNewAuthorizationLoggingBundle2 = AuthorizationClient.newAuthorizationLoggingBundle(this.pendingAuthorizationRequest.getAuthId());
            if (code != null) {
                bundleNewAuthorizationLoggingBundle2.putString("2_result", code.getLoggingValue());
            }
            if (exc != null && exc.getMessage() != null) {
                bundleNewAuthorizationLoggingBundle2.putString("5_error_message", exc.getMessage());
            }
            JSONObject jSONObject = !this.pendingAuthorizationRequest.loggingExtras.isEmpty() ? new JSONObject(this.pendingAuthorizationRequest.loggingExtras) : null;
            if (map != null) {
                JSONObject jSONObject2 = jSONObject == null ? new JSONObject() : jSONObject;
                try {
                    for (Map.Entry<String, String> entry : map.entrySet()) {
                        jSONObject2.put(entry.getKey(), entry.getValue());
                    }
                    jSONObject = jSONObject2;
                } catch (JSONException e) {
                    jSONObject = jSONObject2;
                }
            }
            if (jSONObject != null) {
                bundleNewAuthorizationLoggingBundle2.putString("6_extras", jSONObject.toString());
            }
            bundleNewAuthorizationLoggingBundle = bundleNewAuthorizationLoggingBundle2;
        }
        bundleNewAuthorizationLoggingBundle.putLong("1_timestamp_ms", System.currentTimeMillis());
        getAppEventsLogger().logSdkEvent("fb_mobile_login_complete", null, bundleNewAuthorizationLoggingBundle);
    }

    private void logAuthorizationStart() throws JSONException {
        Bundle bundleNewAuthorizationLoggingBundle = AuthorizationClient.newAuthorizationLoggingBundle(this.pendingAuthorizationRequest.getAuthId());
        bundleNewAuthorizationLoggingBundle.putLong("1_timestamp_ms", System.currentTimeMillis());
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("login_behavior", this.pendingAuthorizationRequest.loginBehavior.toString());
            jSONObject.put("request_code", this.pendingAuthorizationRequest.requestCode);
            jSONObject.put("is_legacy", this.pendingAuthorizationRequest.isLegacy);
            jSONObject.put("permissions", TextUtils.join(",", this.pendingAuthorizationRequest.permissions));
            jSONObject.put("default_audience", this.pendingAuthorizationRequest.defaultAudience.toString());
            bundleNewAuthorizationLoggingBundle.putString("6_extras", jSONObject.toString());
        } catch (JSONException e) {
        }
        getAppEventsLogger().logSdkEvent("fb_mobile_login_start", null, bundleNewAuthorizationLoggingBundle);
    }

    private void open(OpenRequest openRequest, SessionAuthorizationType sessionAuthorizationType) throws JSONException {
        SessionState sessionState;
        validatePermissions(openRequest, sessionAuthorizationType);
        validateLoginBehavior(openRequest);
        synchronized (this.lock) {
            if (this.pendingAuthorizationRequest != null) {
                postStateChange(this.state, this.state, new UnsupportedOperationException("Session: an attempt was made to open a session that has a pending request."));
                return;
            }
            SessionState sessionState2 = this.state;
            switch (this.state) {
                case CREATED:
                    sessionState = SessionState.OPENING;
                    this.state = sessionState;
                    if (openRequest != null) {
                        this.pendingAuthorizationRequest = openRequest;
                        break;
                    } else {
                        throw new IllegalArgumentException("openRequest cannot be null when opening a new Session");
                    }
                case OPENING:
                default:
                    throw new UnsupportedOperationException("Session: an attempt was made to open an already opened session.");
                case CREATED_TOKEN_LOADED:
                    if (openRequest != null && !Utility.isNullOrEmpty(openRequest.getPermissions()) && !Utility.isSubset(openRequest.getPermissions(), getPermissions())) {
                        this.pendingAuthorizationRequest = openRequest;
                    }
                    if (this.pendingAuthorizationRequest != null) {
                        sessionState = SessionState.OPENING;
                        this.state = sessionState;
                        break;
                    } else {
                        sessionState = SessionState.OPENED;
                        this.state = sessionState;
                        break;
                    }
            }
            if (openRequest != null) {
                addCallback(openRequest.getCallback());
            }
            postStateChange(sessionState2, sessionState, null);
            if (sessionState == SessionState.OPENING) {
                authorize(openRequest);
            }
        }
    }

    public static Session openActiveSession(Activity activity, boolean z, StatusCallback statusCallback) {
        return openActiveSession(activity, z, new OpenRequest(activity).setCallback(statusCallback));
    }

    public static Session openActiveSession(Context context, Fragment fragment, boolean z, StatusCallback statusCallback) {
        return openActiveSession(context, z, new OpenRequest(fragment).setCallback(statusCallback));
    }

    private static Session openActiveSession(Context context, boolean z, OpenRequest openRequest) throws JSONException {
        Session sessionBuild = new Builder(context).build();
        if (!SessionState.CREATED_TOKEN_LOADED.equals(sessionBuild.getState()) && !z) {
            return null;
        }
        setActiveSession(sessionBuild);
        sessionBuild.openForRead(openRequest);
        return sessionBuild;
    }

    public static Session openActiveSessionFromCache(Context context) {
        return openActiveSession(context, false, (OpenRequest) null);
    }

    public static Session openActiveSessionWithAccessToken(Context context, AccessToken accessToken, StatusCallback statusCallback) {
        Session session = new Session(context, null, null, false);
        setActiveSession(session);
        session.open(accessToken, statusCallback);
        return session;
    }

    static void postActiveSessionAction(String str) {
        LocalBroadcastManager.getInstance(getStaticContext()).sendBroadcast(new Intent(str));
    }

    private void readObject(ObjectInputStream objectInputStream) throws InvalidObjectException {
        throw new InvalidObjectException("Cannot readObject, serialization proxy required");
    }

    private void requestNewPermissions(NewPermissionsRequest newPermissionsRequest, SessionAuthorizationType sessionAuthorizationType) throws JSONException {
        validatePermissions(newPermissionsRequest, sessionAuthorizationType);
        validateLoginBehavior(newPermissionsRequest);
        if (newPermissionsRequest != null) {
            synchronized (this.lock) {
                if (this.pendingAuthorizationRequest != null) {
                    throw new UnsupportedOperationException("Session: an attempt was made to request new permissions for a session that has a pending request.");
                }
                if (!this.state.isOpened()) {
                    if (!this.state.isClosed()) {
                        throw new UnsupportedOperationException("Session: an attempt was made to request new permissions for a session that is not currently open.");
                    }
                    throw new UnsupportedOperationException("Session: an attempt was made to request new permissions for a session that has been closed.");
                }
                this.pendingAuthorizationRequest = newPermissionsRequest;
            }
            newPermissionsRequest.setValidateSameFbidAsToken(getAccessToken());
            addCallback(newPermissionsRequest.getCallback());
            authorize(newPermissionsRequest);
        }
    }

    private boolean resolveIntent(Intent intent) {
        return getStaticContext().getPackageManager().resolveActivity(intent, 0) != null;
    }

    public static final Session restoreSession(Context context, TokenCachingStrategy tokenCachingStrategy, StatusCallback statusCallback, Bundle bundle) {
        if (bundle == null) {
            return null;
        }
        byte[] byteArray = bundle.getByteArray(SESSION_BUNDLE_SAVE_KEY);
        if (byteArray != null) {
            try {
                Session session = (Session) new ObjectInputStream(new ByteArrayInputStream(byteArray)).readObject();
                initializeStaticContext(context);
                if (tokenCachingStrategy != null) {
                    session.tokenCachingStrategy = tokenCachingStrategy;
                } else {
                    session.tokenCachingStrategy = new SharedPreferencesTokenCachingStrategy(context);
                }
                if (statusCallback != null) {
                    session.addCallback(statusCallback);
                }
                session.authorizationBundle = bundle.getBundle(AUTH_BUNDLE_SAVE_KEY);
                return session;
            } catch (IOException e) {
                Log.w(TAG, "Unable to restore session.", e);
            } catch (ClassNotFoundException e2) {
                Log.w(TAG, "Unable to restore session", e2);
            }
        }
        return null;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static void runWithHandlerOrExecutor(Handler handler, Runnable runnable) {
        if (handler != null) {
            handler.post(runnable);
        } else {
            Settings.getExecutor().execute(runnable);
        }
    }

    public static final void saveSession(Session session, Bundle bundle) throws IOException {
        if (bundle == null || session == null || bundle.containsKey(SESSION_BUNDLE_SAVE_KEY)) {
            return;
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        try {
            new ObjectOutputStream(byteArrayOutputStream).writeObject(session);
            bundle.putByteArray(SESSION_BUNDLE_SAVE_KEY, byteArrayOutputStream.toByteArray());
            bundle.putBundle(AUTH_BUNDLE_SAVE_KEY, session.authorizationBundle);
        } catch (IOException e) {
            throw new FacebookException("Unable to save session.", e);
        }
    }

    private void saveTokenToCache(AccessToken accessToken) {
        if (accessToken == null || this.tokenCachingStrategy == null) {
            return;
        }
        this.tokenCachingStrategy.save(accessToken.toCacheBundle());
    }

    public static final void setActiveSession(Session session) {
        synchronized (STATIC_LOCK) {
            if (session != activeSession) {
                Session session2 = activeSession;
                if (session2 != null) {
                    session2.close();
                }
                activeSession = session;
                if (session2 != null) {
                    postActiveSessionAction(ACTION_ACTIVE_SESSION_UNSET);
                }
                if (session != null) {
                    postActiveSessionAction(ACTION_ACTIVE_SESSION_SET);
                    if (session.isOpened()) {
                        postActiveSessionAction(ACTION_ACTIVE_SESSION_OPENED);
                    }
                }
            }
        }
    }

    private void tryLegacyAuth(AuthorizationRequest authorizationRequest) {
        this.authorizationClient = new AuthorizationClient();
        this.authorizationClient.setOnCompletedListener(new AuthorizationClient.OnCompletedListener() { // from class: com.facebook.Session.2
            @Override // com.facebook.AuthorizationClient.OnCompletedListener
            public void onCompleted(AuthorizationClient.Result result) throws JSONException {
                Session.this.handleAuthorizationResult(result.code == AuthorizationClient.Result.Code.CANCEL ? 0 : -1, result);
            }
        });
        this.authorizationClient.setContext(getStaticContext());
        this.authorizationClient.startOrContinueAuth(authorizationRequest.getAuthorizationClientRequest());
    }

    private boolean tryLoginActivity(AuthorizationRequest authorizationRequest) {
        Intent loginActivityIntent = getLoginActivityIntent(authorizationRequest);
        if (!resolveIntent(loginActivityIntent)) {
            return false;
        }
        try {
            authorizationRequest.getStartActivityDelegate().startActivityForResult(loginActivityIntent, authorizationRequest.getRequestCode());
            return true;
        } catch (ActivityNotFoundException e) {
            return false;
        }
    }

    private void validateLoginBehavior(AuthorizationRequest authorizationRequest) {
        if (authorizationRequest == null || authorizationRequest.isLegacy) {
            return;
        }
        Intent intent = new Intent();
        intent.setClass(getStaticContext(), LoginActivity.class);
        if (!resolveIntent(intent)) {
            throw new FacebookException(String.format("Cannot use SessionLoginBehavior %s when %s is not declared as an activity in AndroidManifest.xml", authorizationRequest.getLoginBehavior(), LoginActivity.class.getName()));
        }
    }

    private void validatePermissions(AuthorizationRequest authorizationRequest, SessionAuthorizationType sessionAuthorizationType) {
        if (authorizationRequest == null || Utility.isNullOrEmpty(authorizationRequest.getPermissions())) {
            if (SessionAuthorizationType.PUBLISH.equals(sessionAuthorizationType)) {
                throw new FacebookException("Cannot request publish or manage authorization with no permissions.");
            }
            return;
        }
        for (String str : authorizationRequest.getPermissions()) {
            if (isPublishPermission(str)) {
                if (SessionAuthorizationType.READ.equals(sessionAuthorizationType)) {
                    throw new FacebookException(String.format("Cannot pass a publish or manage permission (%s) to a request for read authorization", str));
                }
            } else if (SessionAuthorizationType.PUBLISH.equals(sessionAuthorizationType)) {
                Log.w(TAG, String.format("Should not pass a read permission (%s) to a request for publish or manage authorization", str));
            }
        }
    }

    private Object writeReplace() {
        return new SerializationProxyV1(this.applicationId, this.state, this.tokenInfo, this.lastAttemptedTokenExtendDate, false, this.pendingAuthorizationRequest);
    }

    public final void addCallback(StatusCallback statusCallback) {
        synchronized (this.callbacks) {
            if (statusCallback != null) {
                if (!this.callbacks.contains(statusCallback)) {
                    this.callbacks.add(statusCallback);
                }
            }
        }
    }

    void authorize(AuthorizationRequest authorizationRequest) throws JSONException {
        authorizationRequest.setApplicationId(this.applicationId);
        autoPublishAsync();
        logAuthorizationStart();
        boolean zTryLoginActivity = tryLoginActivity(authorizationRequest);
        this.pendingAuthorizationRequest.loggingExtras.put("try_login_activity", zTryLoginActivity ? AppEventsConstants.EVENT_PARAM_VALUE_YES : AppEventsConstants.EVENT_PARAM_VALUE_NO);
        if (!zTryLoginActivity && authorizationRequest.isLegacy) {
            this.pendingAuthorizationRequest.loggingExtras.put("try_legacy", AppEventsConstants.EVENT_PARAM_VALUE_YES);
            tryLegacyAuth(authorizationRequest);
            zTryLoginActivity = true;
        }
        if (zTryLoginActivity) {
            return;
        }
        synchronized (this.lock) {
            SessionState sessionState = this.state;
            switch (this.state) {
                case CLOSED:
                case CLOSED_LOGIN_FAILED:
                    break;
                default:
                    this.state = SessionState.CLOSED_LOGIN_FAILED;
                    FacebookException facebookException = new FacebookException("Log in attempt failed: LoginActivity could not be started, and not legacy request");
                    logAuthorizationComplete(AuthorizationClient.Result.Code.ERROR, null, facebookException);
                    postStateChange(sessionState, this.state, facebookException);
                    break;
            }
        }
    }

    public final void close() {
        synchronized (this.lock) {
            SessionState sessionState = this.state;
            switch (this.state) {
                case CREATED:
                case OPENING:
                    this.state = SessionState.CLOSED_LOGIN_FAILED;
                    postStateChange(sessionState, this.state, new FacebookException("Log in attempt aborted."));
                    break;
                case CREATED_TOKEN_LOADED:
                case OPENED:
                case OPENED_TOKEN_UPDATED:
                    this.state = SessionState.CLOSED;
                    postStateChange(sessionState, this.state, null);
                    break;
            }
        }
    }

    public final void closeAndClearTokenInformation() {
        if (this.tokenCachingStrategy != null) {
            this.tokenCachingStrategy.clear();
        }
        Utility.clearFacebookCookies(staticContext);
        Utility.clearCaches(staticContext);
        close();
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof Session)) {
            return false;
        }
        Session session = (Session) obj;
        return areEqual(session.applicationId, this.applicationId) && areEqual(session.authorizationBundle, this.authorizationBundle) && areEqual(session.state, this.state) && areEqual(session.getExpirationDate(), getExpirationDate());
    }

    void extendAccessToken() {
        TokenRefreshRequest tokenRefreshRequest = null;
        synchronized (this.lock) {
            if (this.currentTokenRefreshRequest == null) {
                tokenRefreshRequest = new TokenRefreshRequest();
                this.currentTokenRefreshRequest = tokenRefreshRequest;
            }
        }
        if (tokenRefreshRequest != null) {
            tokenRefreshRequest.bind();
        }
    }

    void extendAccessTokenIfNeeded() {
        if (shouldExtendAccessToken()) {
            extendAccessToken();
        }
    }

    void extendTokenCompleted(Bundle bundle) {
        synchronized (this.lock) {
            SessionState sessionState = this.state;
            switch (this.state) {
                case OPENED:
                    this.state = SessionState.OPENED_TOKEN_UPDATED;
                    postStateChange(sessionState, this.state, null);
                    break;
                case OPENED_TOKEN_UPDATED:
                    break;
                default:
                    Log.d(TAG, "refreshToken ignored in state " + this.state);
                    return;
            }
            this.tokenInfo = AccessToken.createFromRefresh(this.tokenInfo, bundle);
            if (this.tokenCachingStrategy != null) {
                this.tokenCachingStrategy.save(this.tokenInfo.toCacheBundle());
            }
        }
    }

    void finishAuthOrReauth(AccessToken accessToken, Exception exc) {
        Exception facebookException;
        AccessToken accessToken2;
        if (accessToken == null || !accessToken.isInvalid()) {
            facebookException = exc;
            accessToken2 = accessToken;
        } else {
            accessToken2 = null;
            facebookException = new FacebookException("Invalid access token.");
        }
        synchronized (this.lock) {
            switch (this.state) {
                case CREATED:
                case CREATED_TOKEN_LOADED:
                case CLOSED:
                case CLOSED_LOGIN_FAILED:
                    Log.d(TAG, "Unexpected call to finishAuthOrReauth in state " + this.state);
                    break;
                case OPENING:
                    finishAuthorization(accessToken2, facebookException);
                    break;
                case OPENED:
                case OPENED_TOKEN_UPDATED:
                    finishReauthorization(accessToken2, facebookException);
                    break;
            }
        }
    }

    public final String getAccessToken() {
        String token;
        synchronized (this.lock) {
            token = this.tokenInfo == null ? null : this.tokenInfo.getToken();
        }
        return token;
    }

    public final String getApplicationId() {
        return this.applicationId;
    }

    public final Bundle getAuthorizationBundle() {
        Bundle bundle;
        synchronized (this.lock) {
            bundle = this.authorizationBundle;
        }
        return bundle;
    }

    public final Date getExpirationDate() {
        Date expires;
        synchronized (this.lock) {
            expires = this.tokenInfo == null ? null : this.tokenInfo.getExpires();
        }
        return expires;
    }

    Date getLastAttemptedTokenExtendDate() {
        return this.lastAttemptedTokenExtendDate;
    }

    public final List<String> getPermissions() {
        List<String> permissions;
        synchronized (this.lock) {
            permissions = this.tokenInfo == null ? null : this.tokenInfo.getPermissions();
        }
        return permissions;
    }

    public final SessionState getState() {
        SessionState sessionState;
        synchronized (this.lock) {
            sessionState = this.state;
        }
        return sessionState;
    }

    AccessToken getTokenInfo() {
        return this.tokenInfo;
    }

    public int hashCode() {
        return 0;
    }

    public final boolean isClosed() {
        boolean zIsClosed;
        synchronized (this.lock) {
            zIsClosed = this.state.isClosed();
        }
        return zIsClosed;
    }

    public final boolean isOpened() {
        boolean zIsOpened;
        synchronized (this.lock) {
            zIsOpened = this.state.isOpened();
        }
        return zIsOpened;
    }

    public final boolean onActivityResult(Activity activity, int i, int i2, Intent intent) throws JSONException {
        AuthorizationClient.Result.Code code;
        FacebookException facebookOperationCanceledException;
        Validate.notNull(activity, "currentActivity");
        initializeStaticContext(activity);
        synchronized (this.lock) {
            if (this.pendingAuthorizationRequest == null || i != this.pendingAuthorizationRequest.getRequestCode()) {
                return false;
            }
            AuthorizationClient.Result.Code code2 = AuthorizationClient.Result.Code.ERROR;
            if (intent != null) {
                AuthorizationClient.Result result = (AuthorizationClient.Result) intent.getSerializableExtra("com.facebook.LoginActivity:Result");
                if (result != null) {
                    handleAuthorizationResult(i2, result);
                    return true;
                }
                if (this.authorizationClient != null) {
                    this.authorizationClient.onActivityResult(i, i2, intent);
                    return true;
                }
                code = code2;
                facebookOperationCanceledException = null;
            } else if (i2 == 0) {
                facebookOperationCanceledException = new FacebookOperationCanceledException("User canceled operation.");
                code = AuthorizationClient.Result.Code.CANCEL;
            } else {
                code = code2;
                facebookOperationCanceledException = null;
            }
            if (facebookOperationCanceledException == null) {
                facebookOperationCanceledException = new FacebookException("Unexpected call to Session.onActivityResult");
            }
            logAuthorizationComplete(code, null, facebookOperationCanceledException);
            finishAuthOrReauth(null, facebookOperationCanceledException);
            return true;
        }
    }

    public final void open(AccessToken accessToken, StatusCallback statusCallback) {
        synchronized (this.lock) {
            if (this.pendingAuthorizationRequest != null) {
                throw new UnsupportedOperationException("Session: an attempt was made to open a session that has a pending request.");
            }
            if (this.state.isClosed()) {
                throw new UnsupportedOperationException("Session: an attempt was made to open a previously-closed session.");
            }
            if (this.state != SessionState.CREATED && this.state != SessionState.CREATED_TOKEN_LOADED) {
                throw new UnsupportedOperationException("Session: an attempt was made to open an already opened session.");
            }
            if (statusCallback != null) {
                addCallback(statusCallback);
            }
            this.tokenInfo = accessToken;
            if (this.tokenCachingStrategy != null) {
                this.tokenCachingStrategy.save(accessToken.toCacheBundle());
            }
            SessionState sessionState = this.state;
            this.state = SessionState.OPENED;
            postStateChange(sessionState, this.state, null);
        }
        autoPublishAsync();
    }

    public final void openForPublish(OpenRequest openRequest) throws JSONException {
        open(openRequest, SessionAuthorizationType.PUBLISH);
    }

    public final void openForRead(OpenRequest openRequest) throws JSONException {
        open(openRequest, SessionAuthorizationType.READ);
    }

    void postStateChange(SessionState sessionState, final SessionState sessionState2, final Exception exc) {
        if (sessionState == sessionState2 && sessionState != SessionState.OPENED_TOKEN_UPDATED && exc == null) {
            return;
        }
        if (sessionState2.isClosed()) {
            this.tokenInfo = AccessToken.createEmptyToken(Collections.emptyList());
        }
        synchronized (this.callbacks) {
            runWithHandlerOrExecutor(this.handler, new Runnable() { // from class: com.facebook.Session.3
                @Override // java.lang.Runnable
                public void run() {
                    for (final StatusCallback statusCallback : Session.this.callbacks) {
                        Session.runWithHandlerOrExecutor(Session.this.handler, new Runnable() { // from class: com.facebook.Session.3.1
                            @Override // java.lang.Runnable
                            public void run() {
                                statusCallback.call(Session.this, sessionState2, exc);
                            }
                        });
                    }
                }
            });
        }
        if (this != activeSession || sessionState.isOpened() == sessionState2.isOpened()) {
            return;
        }
        if (sessionState2.isOpened()) {
            postActiveSessionAction(ACTION_ACTIVE_SESSION_OPENED);
        } else {
            postActiveSessionAction(ACTION_ACTIVE_SESSION_CLOSED);
        }
    }

    public final void removeCallback(StatusCallback statusCallback) {
        synchronized (this.callbacks) {
            this.callbacks.remove(statusCallback);
        }
    }

    public final void requestNewPublishPermissions(NewPermissionsRequest newPermissionsRequest) throws JSONException {
        requestNewPermissions(newPermissionsRequest, SessionAuthorizationType.PUBLISH);
    }

    public final void requestNewReadPermissions(NewPermissionsRequest newPermissionsRequest) throws JSONException {
        requestNewPermissions(newPermissionsRequest, SessionAuthorizationType.READ);
    }

    void setCurrentTokenRefreshRequest(TokenRefreshRequest tokenRefreshRequest) {
        this.currentTokenRefreshRequest = tokenRefreshRequest;
    }

    void setLastAttemptedTokenExtendDate(Date date) {
        this.lastAttemptedTokenExtendDate = date;
    }

    void setTokenInfo(AccessToken accessToken) {
        this.tokenInfo = accessToken;
    }

    boolean shouldExtendAccessToken() {
        if (this.currentTokenRefreshRequest != null) {
            return false;
        }
        Date date = new Date();
        return this.state.isOpened() && this.tokenInfo.getSource().canExtendToken() && date.getTime() - this.lastAttemptedTokenExtendDate.getTime() > 3600000 && date.getTime() - this.tokenInfo.getLastRefresh().getTime() > 86400000;
    }

    public String toString() {
        return "{Session state:" + this.state + ", token:" + (this.tokenInfo == null ? "null" : this.tokenInfo) + ", appId:" + (this.applicationId == null ? "null" : this.applicationId) + "}";
    }
}
