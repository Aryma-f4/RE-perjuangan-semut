package com.facebook;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;
import com.facebook.Request;
import com.facebook.internal.Logger;
import com.facebook.internal.Utility;
import com.facebook.internal.Validate;
import com.facebook.model.GraphObject;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Currency;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentHashMap;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/* loaded from: classes.dex */
public class AppEventsLogger {
    public static final String ACTION_APP_EVENTS_FLUSHED = "com.facebook.sdk.APP_EVENTS_FLUSHED";
    private static final int APP_ACTIVATE_SUPPRESSION_PERIOD_IN_SECONDS = 300;
    public static final String APP_EVENTS_EXTRA_FLUSH_RESULT = "com.facebook.sdk.APP_EVENTS_FLUSH_RESULT";
    public static final String APP_EVENTS_EXTRA_NUM_EVENTS_FLUSHED = "com.facebook.sdk.APP_EVENTS_NUM_EVENTS_FLUSHED";
    private static final int APP_SUPPORTS_ATTRIBUTION_ID_RECHECK_PERIOD_IN_SECONDS = 86400;
    private static final int FLUSH_PERIOD_IN_SECONDS = 60;
    private static final int NUM_LOG_EVENTS_TO_TRY_TO_FLUSH_AFTER = 100;
    private static Context applicationContext;
    private static Timer flushTimer;
    private static String hashedDeviceAndAppId;
    private static boolean requestInFlight;
    private static Timer supportsAttributionRecheckTimer;
    private final AccessTokenAppIdPair accessTokenAppId;
    private final Context context;
    private static final String TAG = AppEventsLogger.class.getCanonicalName();
    private static Map<AccessTokenAppIdPair, SessionEventsState> stateMap = new ConcurrentHashMap();
    private static FlushBehavior flushBehavior = FlushBehavior.AUTO;
    private static Object staticLock = new Object();
    private static Map<String, Date> mapEventsToSuppressionTime = new HashMap();
    private static Map<String, EventSuppression> mapEventNameToSuppress = new HashMap<String, EventSuppression>() { // from class: com.facebook.AppEventsLogger.1
        {
            put(AppEventsConstants.EVENT_NAME_ACTIVATED_APP, new EventSuppression(AppEventsLogger.APP_ACTIVATE_SUPPRESSION_PERIOD_IN_SECONDS, SuppressionTimeoutBehavior.RESET_TIMEOUT_WHEN_LOG_ATTEMPTED));
        }
    };

    private static class AccessTokenAppIdPair implements Serializable {
        private static final long serialVersionUID = 1;
        private final String accessToken;
        private final String applicationId;

        private static class SerializationProxyV1 implements Serializable {
            private static final long serialVersionUID = -2488473066578201069L;
            private final String accessToken;
            private final String appId;

            private SerializationProxyV1(String str, String str2) {
                this.accessToken = str;
                this.appId = str2;
            }

            private Object readResolve() {
                return new AccessTokenAppIdPair(this.accessToken, this.appId);
            }
        }

        AccessTokenAppIdPair(Session session) {
            this(session.getAccessToken(), session.getApplicationId());
        }

        AccessTokenAppIdPair(String str, String str2) {
            this.accessToken = Utility.isNullOrEmpty(str) ? null : str;
            this.applicationId = str2;
        }

        private Object writeReplace() {
            return new SerializationProxyV1(this.accessToken, this.applicationId);
        }

        public boolean equals(Object obj) {
            if (!(obj instanceof AccessTokenAppIdPair)) {
                return false;
            }
            AccessTokenAppIdPair accessTokenAppIdPair = (AccessTokenAppIdPair) obj;
            return Utility.areObjectsEqual(accessTokenAppIdPair.accessToken, this.accessToken) && Utility.areObjectsEqual(accessTokenAppIdPair.applicationId, this.applicationId);
        }

        String getAccessToken() {
            return this.accessToken;
        }

        String getApplicationId() {
            return this.applicationId;
        }

        public int hashCode() {
            return (this.accessToken == null ? 0 : this.accessToken.hashCode()) ^ (this.applicationId == null ? 0 : this.applicationId.hashCode());
        }
    }

    static class AppEvent implements Serializable {
        private static final long serialVersionUID = 1;
        private static final HashSet<String> validatedIdentifiers = new HashSet<>();
        private boolean isImplicit;
        private JSONObject jsonObject;
        private String name;

        private static class SerializationProxyV1 implements Serializable {
            private static final long serialVersionUID = -2488473066578201069L;
            private final boolean isImplicit;
            private final String jsonString;

            private SerializationProxyV1(String str, boolean z) {
                this.jsonString = str;
                this.isImplicit = z;
            }

            private Object readResolve() throws JSONException {
                return new AppEvent(this.jsonString, this.isImplicit);
            }
        }

        public AppEvent(String str, Double d, Bundle bundle, boolean z) throws JSONException {
            validateIdentifier(str);
            this.name = str;
            this.isImplicit = z;
            this.jsonObject = new JSONObject();
            try {
                this.jsonObject.put("_eventName", str);
                this.jsonObject.put("_logTime", System.currentTimeMillis() / 1000);
                if (d != null) {
                    this.jsonObject.put("_valueToSum", d.doubleValue());
                }
                if (this.isImplicit) {
                    this.jsonObject.put("_implicitlyLogged", AppEventsConstants.EVENT_PARAM_VALUE_YES);
                }
                String appVersion = Settings.getAppVersion();
                if (appVersion != null) {
                    this.jsonObject.put("_appVersion", appVersion);
                }
                if (bundle != null) {
                    for (String str2 : bundle.keySet()) {
                        validateIdentifier(str2);
                        Object obj = bundle.get(str2);
                        if (!(obj instanceof String) && !(obj instanceof Number)) {
                            throw new FacebookException(String.format("Parameter value '%s' for key '%s' should be a string or a numeric type.", obj, str2));
                        }
                        this.jsonObject.put(str2, obj.toString());
                    }
                }
                if (this.isImplicit) {
                    return;
                }
                Logger.log(LoggingBehavior.APP_EVENTS, "AppEvents", "Created app event '%s'", this.jsonObject.toString());
            } catch (JSONException e) {
                Logger.log(LoggingBehavior.APP_EVENTS, "AppEvents", "JSON encoding for app event failed: '%s'", e.toString());
                this.jsonObject = null;
            }
        }

        private AppEvent(String str, boolean z) throws JSONException {
            this.jsonObject = new JSONObject(str);
            this.isImplicit = z;
        }

        private void validateIdentifier(String str) {
            boolean zContains;
            if (str == null || str.length() == 0 || str.length() > 40) {
                throw new FacebookException(String.format("Identifier '%s' must be less than %d characters", str == null ? "<None Provided>" : str, 40));
            }
            synchronized (validatedIdentifiers) {
                zContains = validatedIdentifiers.contains(str);
            }
            if (zContains) {
                return;
            }
            if (!str.matches("^[0-9a-zA-Z_]+[0-9a-zA-Z _-]*$")) {
                throw new FacebookException(String.format("Skipping event named '%s' due to illegal name - must be under 40 chars and alphanumeric, _, - or space, and not start with a space or hyphen.", str));
            }
            synchronized (validatedIdentifiers) {
                validatedIdentifiers.add(str);
            }
        }

        private Object writeReplace() {
            return new SerializationProxyV1(this.jsonObject.toString(), this.isImplicit);
        }

        public boolean getIsImplicit() {
            return this.isImplicit;
        }

        public JSONObject getJSONObject() {
            return this.jsonObject;
        }

        public String getName() {
            return this.name;
        }

        public String toString() {
            return String.format("\"%s\", implicit: %b, json: %s", this.jsonObject.optString("_eventName"), Boolean.valueOf(this.isImplicit), this.jsonObject.toString());
        }
    }

    private static class EventSuppression {
        private SuppressionTimeoutBehavior behavior;
        private int timeoutPeriod;

        EventSuppression(int i, SuppressionTimeoutBehavior suppressionTimeoutBehavior) {
            this.timeoutPeriod = i;
            this.behavior = suppressionTimeoutBehavior;
        }

        SuppressionTimeoutBehavior getBehavior() {
            return this.behavior;
        }

        int getTimeoutPeriod() {
            return this.timeoutPeriod;
        }
    }

    public enum FlushBehavior {
        AUTO,
        EXPLICIT_ONLY
    }

    private enum FlushReason {
        EXPLICIT,
        TIMER,
        SESSION_CHANGE,
        PERSISTED_EVENTS,
        EVENT_THRESHOLD,
        EAGER_FLUSHING_EVENT
    }

    private enum FlushResult {
        SUCCESS,
        SERVER_ERROR,
        NO_CONNECTIVITY,
        UNKNOWN_ERROR
    }

    private static class FlushStatistics {
        public int numEvents;
        public FlushResult result;

        private FlushStatistics() {
            this.numEvents = 0;
            this.result = FlushResult.SUCCESS;
        }
    }

    static class PersistedEvents {
        static final String PERSISTED_EVENTS_FILENAME = "AppEventsLogger.persistedevents";
        private static Object staticLock = new Object();
        private Context context;
        private HashMap<AccessTokenAppIdPair, List<AppEvent>> persistedEvents = new HashMap<>();

        private PersistedEvents(Context context) {
            this.context = context;
        }

        public static void persistEvents(Context context, AccessTokenAppIdPair accessTokenAppIdPair, SessionEventsState sessionEventsState) {
            HashMap map = new HashMap();
            map.put(accessTokenAppIdPair, sessionEventsState);
            persistEvents(context, map);
        }

        public static void persistEvents(Context context, Map<AccessTokenAppIdPair, SessionEventsState> map) {
            synchronized (staticLock) {
                PersistedEvents andClearStore = readAndClearStore(context);
                for (Map.Entry<AccessTokenAppIdPair, SessionEventsState> entry : map.entrySet()) {
                    List<AppEvent> eventsToPersist = entry.getValue().getEventsToPersist();
                    if (eventsToPersist.size() != 0) {
                        andClearStore.addEvents(entry.getKey(), eventsToPersist);
                    }
                }
                andClearStore.write();
            }
        }

        public static PersistedEvents readAndClearStore(Context context) {
            PersistedEvents persistedEvents;
            synchronized (staticLock) {
                persistedEvents = new PersistedEvents(context);
                persistedEvents.readAndClearStore();
            }
            return persistedEvents;
        }

        private void readAndClearStore() throws Throwable {
            ObjectInputStream objectInputStream;
            Throwable th;
            Exception e;
            ObjectInputStream objectInputStream2 = null;
            try {
                try {
                    objectInputStream = new ObjectInputStream(new BufferedInputStream(this.context.openFileInput(PERSISTED_EVENTS_FILENAME)));
                } catch (FileNotFoundException e2) {
                } catch (Exception e3) {
                    objectInputStream = null;
                    e = e3;
                } catch (Throwable th2) {
                    objectInputStream = null;
                    th = th2;
                    Utility.closeQuietly(objectInputStream);
                    throw th;
                }
                try {
                    HashMap<AccessTokenAppIdPair, List<AppEvent>> map = (HashMap) objectInputStream.readObject();
                    this.context.getFileStreamPath(PERSISTED_EVENTS_FILENAME).delete();
                    this.persistedEvents = map;
                    Utility.closeQuietly(objectInputStream);
                } catch (FileNotFoundException e4) {
                    objectInputStream2 = objectInputStream;
                    Utility.closeQuietly(objectInputStream2);
                } catch (Exception e5) {
                    e = e5;
                    Log.d(AppEventsLogger.TAG, "Got unexpected exception: " + e.toString());
                    Utility.closeQuietly(objectInputStream);
                }
            } catch (Throwable th3) {
                th = th3;
                Utility.closeQuietly(objectInputStream);
                throw th;
            }
        }

        private void write() throws Throwable {
            ObjectOutputStream objectOutputStream;
            Throwable th;
            Exception e;
            try {
                objectOutputStream = new ObjectOutputStream(new BufferedOutputStream(this.context.openFileOutput(PERSISTED_EVENTS_FILENAME, 0)));
            } catch (Exception e2) {
                objectOutputStream = null;
                e = e2;
            } catch (Throwable th2) {
                objectOutputStream = null;
                th = th2;
                Utility.closeQuietly(objectOutputStream);
                throw th;
            }
            try {
                try {
                    objectOutputStream.writeObject(this.persistedEvents);
                    Utility.closeQuietly(objectOutputStream);
                } catch (Throwable th3) {
                    th = th3;
                    Utility.closeQuietly(objectOutputStream);
                    throw th;
                }
            } catch (Exception e3) {
                e = e3;
                Log.d(AppEventsLogger.TAG, "Got unexpected exception: " + e.toString());
                Utility.closeQuietly(objectOutputStream);
            }
        }

        public void addEvents(AccessTokenAppIdPair accessTokenAppIdPair, List<AppEvent> list) {
            if (!this.persistedEvents.containsKey(accessTokenAppIdPair)) {
                this.persistedEvents.put(accessTokenAppIdPair, new ArrayList());
            }
            this.persistedEvents.get(accessTokenAppIdPair).addAll(list);
        }

        public List<AppEvent> getEvents(AccessTokenAppIdPair accessTokenAppIdPair) {
            return this.persistedEvents.get(accessTokenAppIdPair);
        }

        public Set<AccessTokenAppIdPair> keySet() {
            return this.persistedEvents.keySet();
        }
    }

    static class SessionEventsState {
        public static final String ENCODED_EVENTS_KEY = "encoded_events";
        public static final String EVENT_COUNT_KEY = "event_count";
        public static final String NUM_SKIPPED_KEY = "num_skipped";
        private String attributionId;
        private String hashedDeviceAndAppId;
        private int numSkippedEventsDueToFullBuffer;
        private String packageName;
        private List<AppEvent> accumulatedEvents = new ArrayList();
        private List<AppEvent> inFlightEvents = new ArrayList();
        private final int MAX_ACCUMULATED_LOG_EVENTS = 1000;

        public SessionEventsState(String str, String str2, String str3) {
            this.attributionId = str;
            this.packageName = str2;
            this.hashedDeviceAndAppId = str3;
        }

        private byte[] getStringAsByteArray(String str) {
            try {
                return str.getBytes("UTF-8");
            } catch (UnsupportedEncodingException e) {
                Utility.logd("Encoding exception: ", e);
                return null;
            }
        }

        private void populateRequest(Request request, int i, JSONArray jSONArray, boolean z, boolean z2) {
            GraphObject graphObjectCreate = GraphObject.Factory.create();
            graphObjectCreate.setProperty("event", "CUSTOM_APP_EVENTS");
            if (this.numSkippedEventsDueToFullBuffer > 0) {
                graphObjectCreate.setProperty("num_skipped_events", Integer.valueOf(i));
            }
            if (z) {
                Utility.setAppEventAttributionParameters(graphObjectCreate, this.attributionId, this.hashedDeviceAndAppId, z2);
            }
            graphObjectCreate.setProperty("application_package_name", this.packageName);
            request.setGraphObject(graphObjectCreate);
            Bundle parameters = request.getParameters();
            if (parameters == null) {
                parameters = new Bundle();
            }
            String string = jSONArray.toString();
            if (string != null) {
                parameters.putByteArray("custom_events_file", getStringAsByteArray(string));
                request.setTag(string);
            }
            request.setParameters(parameters);
        }

        public synchronized void accumulatePersistedEvents(List<AppEvent> list) {
            this.accumulatedEvents.addAll(list);
        }

        public synchronized void addEvent(AppEvent appEvent) {
            if (this.accumulatedEvents.size() + this.inFlightEvents.size() >= 1000) {
                this.numSkippedEventsDueToFullBuffer++;
            } else {
                this.accumulatedEvents.add(appEvent);
            }
        }

        public synchronized void clearInFlightAndStats(boolean z) {
            if (z) {
                this.accumulatedEvents.addAll(this.inFlightEvents);
                this.inFlightEvents.clear();
                this.numSkippedEventsDueToFullBuffer = 0;
            } else {
                this.inFlightEvents.clear();
                this.numSkippedEventsDueToFullBuffer = 0;
            }
        }

        public synchronized int getAccumulatedEventCount() {
            return this.accumulatedEvents.size();
        }

        public synchronized List<AppEvent> getEventsToPersist() {
            List<AppEvent> list;
            list = this.accumulatedEvents;
            this.accumulatedEvents = new ArrayList();
            return list;
        }

        public int populateRequest(Request request, boolean z, boolean z2, boolean z3) {
            synchronized (this) {
                int i = this.numSkippedEventsDueToFullBuffer;
                this.inFlightEvents.addAll(this.accumulatedEvents);
                this.accumulatedEvents.clear();
                JSONArray jSONArray = new JSONArray();
                for (AppEvent appEvent : this.inFlightEvents) {
                    if (z || !appEvent.getIsImplicit()) {
                        jSONArray.put(appEvent.getJSONObject());
                    }
                }
                if (jSONArray.length() == 0) {
                    return 0;
                }
                populateRequest(request, i, jSONArray, z2, z3);
                return jSONArray.length();
            }
        }
    }

    private enum SuppressionTimeoutBehavior {
        RESET_TIMEOUT_WHEN_LOG_SUCCESSFUL,
        RESET_TIMEOUT_WHEN_LOG_ATTEMPTED
    }

    private AppEventsLogger(Context context, String str, Session session) {
        String metadataApplicationId;
        Validate.notNull(context, "context");
        this.context = context;
        Session activeSession = session == null ? Session.getActiveSession() : session;
        if (activeSession != null) {
            this.accessTokenAppId = new AccessTokenAppIdPair(activeSession);
            metadataApplicationId = str;
        } else {
            metadataApplicationId = str == null ? Utility.getMetadataApplicationId(context) : str;
            this.accessTokenAppId = new AccessTokenAppIdPair(null, metadataApplicationId);
        }
        synchronized (staticLock) {
            if (hashedDeviceAndAppId == null) {
                hashedDeviceAndAppId = Utility.getHashedDeviceAndAppID(context, metadataApplicationId);
            }
            if (applicationContext == null) {
                applicationContext = context.getApplicationContext();
            }
        }
        initializeTimersIfNeeded();
    }

    private static int accumulatePersistedEvents() {
        PersistedEvents andClearStore = PersistedEvents.readAndClearStore(applicationContext);
        int size = 0;
        Iterator<AccessTokenAppIdPair> it = andClearStore.keySet().iterator();
        while (true) {
            int i = size;
            if (!it.hasNext()) {
                return i;
            }
            AccessTokenAppIdPair next = it.next();
            SessionEventsState sessionEventsState = getSessionEventsState(applicationContext, next);
            List<AppEvent> events = andClearStore.getEvents(next);
            sessionEventsState.accumulatePersistedEvents(events);
            size = events.size() + i;
        }
    }

    public static void activateApp(Context context) {
        activateApp(context, Utility.getMetadataApplicationId(context));
    }

    public static void activateApp(Context context, String str) {
        if (context == null || str == null) {
            throw new IllegalArgumentException("Both context and applicationId must be non-null");
        }
        Settings.publishInstallAsync(context, str);
        new AppEventsLogger(context, str, null).logEvent(AppEventsConstants.EVENT_NAME_ACTIVATED_APP);
    }

    private static FlushStatistics buildAndExecuteRequests(FlushReason flushReason, Set<AccessTokenAppIdPair> set) {
        Request requestBuildRequestForSession;
        FlushStatistics flushStatistics = new FlushStatistics();
        boolean limitEventAndDataUsage = Settings.getLimitEventAndDataUsage(applicationContext);
        ArrayList arrayList = new ArrayList();
        for (AccessTokenAppIdPair accessTokenAppIdPair : set) {
            SessionEventsState sessionEventsState = getSessionEventsState(accessTokenAppIdPair);
            if (sessionEventsState != null && (requestBuildRequestForSession = buildRequestForSession(accessTokenAppIdPair, sessionEventsState, limitEventAndDataUsage, flushStatistics)) != null) {
                arrayList.add(requestBuildRequestForSession);
            }
        }
        if (arrayList.size() <= 0) {
            return null;
        }
        Logger.log(LoggingBehavior.APP_EVENTS, TAG, "Flushing %d events due to %s.", Integer.valueOf(flushStatistics.numEvents), flushReason.toString());
        Iterator it = arrayList.iterator();
        while (it.hasNext()) {
            ((Request) it.next()).executeAndWait();
        }
        return flushStatistics;
    }

    private static Request buildRequestForSession(final AccessTokenAppIdPair accessTokenAppIdPair, final SessionEventsState sessionEventsState, boolean z, final FlushStatistics flushStatistics) {
        String applicationId = accessTokenAppIdPair.getApplicationId();
        Utility.FetchedAppSettings fetchedAppSettingsQueryAppSettings = Utility.queryAppSettings(applicationId, false);
        final Request requestNewPostRequest = Request.newPostRequest(null, String.format("%s/activities", applicationId), null, null);
        Bundle parameters = requestNewPostRequest.getParameters();
        if (parameters == null) {
            parameters = new Bundle();
        }
        parameters.putString("access_token", accessTokenAppIdPair.getAccessToken());
        requestNewPostRequest.setParameters(parameters);
        int iPopulateRequest = sessionEventsState.populateRequest(requestNewPostRequest, fetchedAppSettingsQueryAppSettings.supportsImplicitLogging(), fetchedAppSettingsQueryAppSettings.supportsAttribution(), z);
        if (iPopulateRequest == 0) {
            return null;
        }
        flushStatistics.numEvents = iPopulateRequest + flushStatistics.numEvents;
        requestNewPostRequest.setCallback(new Request.Callback() { // from class: com.facebook.AppEventsLogger.5
            @Override // com.facebook.Request.Callback
            public void onCompleted(Response response) throws JSONException {
                AppEventsLogger.handleResponse(accessTokenAppIdPair, requestNewPostRequest, response, sessionEventsState, flushStatistics);
            }
        });
        return requestNewPostRequest;
    }

    static void eagerFlush() {
        if (getFlushBehavior() != FlushBehavior.EXPLICIT_ONLY) {
            flush(FlushReason.EAGER_FLUSHING_EVENT);
        }
    }

    private static void flush(final FlushReason flushReason) {
        Settings.getExecutor().execute(new Runnable() { // from class: com.facebook.AppEventsLogger.4
            @Override // java.lang.Runnable
            public void run() {
                AppEventsLogger.flushAndWait(flushReason);
            }
        });
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static void flushAndWait(FlushReason flushReason) {
        synchronized (staticLock) {
            if (requestInFlight) {
                return;
            }
            requestInFlight = true;
            HashSet hashSet = new HashSet(stateMap.keySet());
            accumulatePersistedEvents();
            FlushStatistics flushStatisticsBuildAndExecuteRequests = null;
            try {
                flushStatisticsBuildAndExecuteRequests = buildAndExecuteRequests(flushReason, hashSet);
            } catch (Exception e) {
                Log.d(TAG, "Caught unexpected exception while flushing: " + e.toString());
            }
            synchronized (staticLock) {
                requestInFlight = false;
            }
            if (flushStatisticsBuildAndExecuteRequests != null) {
                Intent intent = new Intent(ACTION_APP_EVENTS_FLUSHED);
                intent.putExtra(APP_EVENTS_EXTRA_NUM_EVENTS_FLUSHED, flushStatisticsBuildAndExecuteRequests.numEvents);
                intent.putExtra(APP_EVENTS_EXTRA_FLUSH_RESULT, flushStatisticsBuildAndExecuteRequests.result);
                LocalBroadcastManager.getInstance(applicationContext).sendBroadcast(intent);
            }
        }
    }

    private static void flushIfNecessary() {
        synchronized (staticLock) {
            if (getFlushBehavior() != FlushBehavior.EXPLICIT_ONLY && getAccumulatedEventCount() > 100) {
                flush(FlushReason.EVENT_THRESHOLD);
            }
        }
    }

    private static int getAccumulatedEventCount() {
        int accumulatedEventCount;
        synchronized (staticLock) {
            Iterator<SessionEventsState> it = stateMap.values().iterator();
            accumulatedEventCount = 0;
            while (it.hasNext()) {
                accumulatedEventCount = it.next().getAccumulatedEventCount() + accumulatedEventCount;
            }
        }
        return accumulatedEventCount;
    }

    public static FlushBehavior getFlushBehavior() {
        FlushBehavior flushBehavior2;
        synchronized (staticLock) {
            flushBehavior2 = flushBehavior;
        }
        return flushBehavior2;
    }

    @Deprecated
    public static boolean getLimitEventUsage(Context context) {
        return Settings.getLimitEventAndDataUsage(context);
    }

    private static SessionEventsState getSessionEventsState(Context context, AccessTokenAppIdPair accessTokenAppIdPair) {
        SessionEventsState sessionEventsState;
        synchronized (staticLock) {
            sessionEventsState = stateMap.get(accessTokenAppIdPair);
            if (sessionEventsState == null) {
                SessionEventsState sessionEventsState2 = new SessionEventsState(Settings.getAttributionId(context.getContentResolver()), context.getPackageName(), hashedDeviceAndAppId);
                stateMap.put(accessTokenAppIdPair, sessionEventsState2);
                sessionEventsState = sessionEventsState2;
            }
        }
        return sessionEventsState;
    }

    private static SessionEventsState getSessionEventsState(AccessTokenAppIdPair accessTokenAppIdPair) {
        SessionEventsState sessionEventsState;
        synchronized (staticLock) {
            sessionEventsState = stateMap.get(accessTokenAppIdPair);
        }
        return sessionEventsState;
    }

    /* JADX INFO: Access modifiers changed from: private */
    public static void handleResponse(AccessTokenAppIdPair accessTokenAppIdPair, Request request, Response response, SessionEventsState sessionEventsState, FlushStatistics flushStatistics) throws JSONException {
        String str;
        FlushResult flushResult;
        String string;
        FacebookRequestError error = response.getError();
        FlushResult flushResult2 = FlushResult.SUCCESS;
        if (error == null) {
            str = "Success";
            flushResult = flushResult2;
        } else if (error.getErrorCode() == -1) {
            flushResult = FlushResult.NO_CONNECTIVITY;
            str = "Failed: No Connectivity";
        } else {
            String str2 = String.format("Failed:\n  Response: %s\n  Error %s", response.toString(), error.toString());
            flushResult = FlushResult.SERVER_ERROR;
            str = str2;
        }
        if (Settings.isLoggingBehaviorEnabled(LoggingBehavior.APP_EVENTS)) {
            try {
                string = new JSONArray((String) request.getTag()).toString(2);
            } catch (JSONException e) {
                string = "<Can't encode events for debug logging>";
            }
            Logger.log(LoggingBehavior.APP_EVENTS, TAG, "Flush completed\nParams: %s\n  Result: %s\n  Events JSON: %s", request.getGraphObject().toString(), str, string);
        }
        sessionEventsState.clearInFlightAndStats(error != null);
        if (flushResult == FlushResult.NO_CONNECTIVITY) {
            PersistedEvents.persistEvents(applicationContext, accessTokenAppIdPair, sessionEventsState);
        }
        if (flushResult == FlushResult.SUCCESS || flushStatistics.result == FlushResult.NO_CONNECTIVITY) {
            return;
        }
        flushStatistics.result = flushResult;
    }

    private static void initializeTimersIfNeeded() {
        synchronized (staticLock) {
            if (flushTimer != null) {
                return;
            }
            flushTimer = new Timer();
            supportsAttributionRecheckTimer = new Timer();
            flushTimer.schedule(new TimerTask() { // from class: com.facebook.AppEventsLogger.2
                @Override // java.util.TimerTask, java.lang.Runnable
                public void run() {
                    if (AppEventsLogger.getFlushBehavior() != FlushBehavior.EXPLICIT_ONLY) {
                        AppEventsLogger.flushAndWait(FlushReason.TIMER);
                    }
                }
            }, 0L, 60000L);
            supportsAttributionRecheckTimer.schedule(new TimerTask() { // from class: com.facebook.AppEventsLogger.3
                @Override // java.util.TimerTask, java.lang.Runnable
                public void run() {
                    HashSet hashSet = new HashSet();
                    synchronized (AppEventsLogger.staticLock) {
                        Iterator it = AppEventsLogger.stateMap.keySet().iterator();
                        while (it.hasNext()) {
                            hashSet.add(((AccessTokenAppIdPair) it.next()).getApplicationId());
                        }
                    }
                    Iterator it2 = hashSet.iterator();
                    while (it2.hasNext()) {
                        Utility.queryAppSettings((String) it2.next(), true);
                    }
                }
            }, 0L, 86400000L);
        }
    }

    private static void logEvent(Context context, AppEvent appEvent, AccessTokenAppIdPair accessTokenAppIdPair) {
        if (shouldSuppressEvent(appEvent)) {
            return;
        }
        getSessionEventsState(context, accessTokenAppIdPair).addEvent(appEvent);
        flushIfNecessary();
    }

    private void logEvent(String str, Double d, Bundle bundle, boolean z) {
        logEvent(this.context, new AppEvent(str, d, bundle, z), this.accessTokenAppId);
    }

    public static AppEventsLogger newLogger(Context context) {
        return new AppEventsLogger(context, null, null);
    }

    public static AppEventsLogger newLogger(Context context, Session session) {
        return new AppEventsLogger(context, null, session);
    }

    public static AppEventsLogger newLogger(Context context, String str) {
        return new AppEventsLogger(context, str, null);
    }

    public static AppEventsLogger newLogger(Context context, String str, Session session) {
        return new AppEventsLogger(context, str, session);
    }

    private static void notifyDeveloperError(String str) {
        Logger.log(LoggingBehavior.DEVELOPER_ERRORS, "AppEvents", str);
    }

    public static void onContextStop() {
        PersistedEvents.persistEvents(applicationContext, stateMap);
    }

    public static void setFlushBehavior(FlushBehavior flushBehavior2) {
        synchronized (staticLock) {
            flushBehavior = flushBehavior2;
        }
    }

    @Deprecated
    public static void setLimitEventUsage(Context context, boolean z) {
        Settings.setLimitEventAndDataUsage(context, z);
    }

    private static boolean shouldSuppressEvent(AppEvent appEvent) {
        EventSuppression eventSuppression = mapEventNameToSuppress.get(appEvent.getName());
        if (eventSuppression == null) {
            return false;
        }
        Date date = mapEventsToSuppressionTime.get(appEvent.getName());
        boolean z = date != null && new Date().getTime() - date.getTime() < ((long) (eventSuppression.getTimeoutPeriod() * 1000));
        if (!z || eventSuppression.getBehavior() == SuppressionTimeoutBehavior.RESET_TIMEOUT_WHEN_LOG_ATTEMPTED) {
            mapEventsToSuppressionTime.put(appEvent.getName(), new Date());
        }
        return z;
    }

    public void flush() {
        flush(FlushReason.EXPLICIT);
    }

    public String getApplicationId() {
        return this.accessTokenAppId.getApplicationId();
    }

    boolean isValidForSession(Session session) {
        return this.accessTokenAppId.equals(new AccessTokenAppIdPair(session));
    }

    public void logEvent(String str) {
        logEvent(str, (Bundle) null);
    }

    public void logEvent(String str, double d) {
        logEvent(str, d, (Bundle) null);
    }

    public void logEvent(String str, double d, Bundle bundle) {
        logEvent(str, Double.valueOf(d), bundle, false);
    }

    public void logEvent(String str, Bundle bundle) {
        logEvent(str, null, bundle, false);
    }

    public void logPurchase(BigDecimal bigDecimal, Currency currency) {
        logPurchase(bigDecimal, currency, null);
    }

    public void logPurchase(BigDecimal bigDecimal, Currency currency, Bundle bundle) {
        if (bigDecimal == null) {
            notifyDeveloperError("purchaseAmount cannot be null");
            return;
        }
        if (currency == null) {
            notifyDeveloperError("currency cannot be null");
            return;
        }
        Bundle bundle2 = bundle == null ? new Bundle() : bundle;
        bundle2.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, currency.getCurrencyCode());
        logEvent(AppEventsConstants.EVENT_NAME_PURCHASED, bigDecimal.doubleValue(), bundle2);
        eagerFlush();
    }

    public void logSdkEvent(String str, Double d, Bundle bundle) {
        logEvent(str, d, bundle, true);
    }
}
