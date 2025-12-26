package com.adobe.air;

import android.app.IntentService;
import android.content.ComponentName;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.ResultReceiver;
import android.preference.PreferenceManager;
import android.support.v4.widget.ExploreByTouchHelper;
import android.util.Log;
import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.sns.AmazonSNS;
import com.amazonaws.services.sns.AmazonSNSClient;
import com.amazonaws.services.sns.model.CreatePlatformEndpointRequest;
import com.amazonaws.services.sns.model.CreatePlatformEndpointResult;
import com.amazonaws.services.sns.model.InternalErrorException;
import com.amazonaws.services.sns.model.InvalidParameterException;
import com.amazonaws.services.sns.model.SetEndpointAttributesRequest;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import java.security.cert.CertificateException;
import java.util.HashMap;

/* loaded from: classes.dex */
public class AndroidGcmRegistrationService extends IntentService {
    private static final String CUSTOM_USER_DATA = "CustomUserData";
    private static final String ENABLED = "Enabled";
    private static final String ENABLE_LOGGING = "enableLogging";
    private static final int MAX_RETRIES = 10;
    private static final String PROPERTY_APP_VERSION = "appVersion";
    private static final String PROPERTY_ENDPOINT_ARN = "endpointArn";
    private static final String RATE_LIMIT = "rateLimit";
    private static final int RETRY_TIME = 300000;
    private static final String TAG = "AndroidGcmRegistrationService";
    private static final String TEST_ACCESS_KEY = "";
    private static final String TEST_APPLICATION_ARN = "arn:aws:sns:us-west-2:413177889857:app/GCM/airruntimetestapp";
    private static final String TEST_ENV = "testEnv";
    private static final String TEST_SECRET_KEY = "";
    private static final String TEST_SENDER_ID = "1078258869814";
    private static final String TOKEN = "Token";
    private AmazonSNS mClient;
    private boolean mEnableLogging;
    private String mEndpointArn;
    private GoogleCloudMessaging mGcm;
    private String mRegId;
    private ResultReceiver mResultReceiver;
    private int mRetryCount;
    private boolean mTestEnv;
    private static String SENDER_ID = "233437466354";
    private static String APPLICATION_ARN = "arn:aws:sns:us-west-2:502492504188:app/GCM/AdobeAIRGCM";
    private static String ACCESS_KEY = "";
    private static String SECRET_KEY = "";

    public AndroidGcmRegistrationService() {
        super(TAG);
        this.mRetryCount = 0;
        this.mRegId = null;
        this.mEndpointArn = null;
        this.mClient = null;
        this.mGcm = null;
        this.mResultReceiver = null;
        this.mEnableLogging = false;
        this.mTestEnv = false;
    }

    @Override // android.app.IntentService
    protected void onHandleIntent(Intent intent) {
        this.mResultReceiver = (ResultReceiver) intent.getParcelableExtra(AdobeAIRMainActivity.RESULT_RECEIVER);
        registerForNotifications();
    }

    private void registerForNotifications() {
        if (!isAppRegistered() && checkPlayServices()) {
            configureTestEnv();
            registerInBackground(0);
        }
    }

    private boolean checkPlayServices() throws PackageManager.NameNotFoundException, CertificateException {
        int iIsGooglePlayServicesAvailable = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
        if (iIsGooglePlayServicesAvailable == 0) {
            return true;
        }
        if (GooglePlayServicesUtil.isUserRecoverableError(iIsGooglePlayServicesAvailable) && this.mResultReceiver != null) {
            this.mResultReceiver.send(iIsGooglePlayServicesAvailable, null);
        }
        return false;
    }

    private boolean isAppRegistered() {
        int i = PreferenceManager.getDefaultSharedPreferences(getApplicationContext()).getInt(PROPERTY_APP_VERSION, ExploreByTouchHelper.INVALID_ID);
        return i != Integer.MIN_VALUE && i == getAppVersion();
    }

    private void configureTestEnv() {
        try {
            Bundle bundle = getPackageManager().getServiceInfo(new ComponentName(this, getClass()), 128).metaData;
            if (bundle != null) {
                this.mEnableLogging = bundle.getBoolean(ENABLE_LOGGING);
                this.mTestEnv = bundle.getBoolean(TEST_ENV);
                if (this.mTestEnv) {
                    SENDER_ID = TEST_SENDER_ID;
                    APPLICATION_ARN = TEST_APPLICATION_ARN;
                    ACCESS_KEY = "";
                    SECRET_KEY = "";
                    int i = bundle.getInt(RATE_LIMIT, ExploreByTouchHelper.INVALID_ID);
                    if (i != Integer.MIN_VALUE) {
                        AdobeAIRMainActivity.RATE_LIMIT = i;
                    }
                }
            }
        } catch (PackageManager.NameNotFoundException e) {
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void registerInBackground(int i) {
        if (this.mRetryCount < 10) {
            if (i != 0) {
                this.mRetryCount++;
            }
            if (this.mGcm == null) {
                this.mGcm = GoogleCloudMessaging.getInstance(this);
            }
            new AsyncTaskRunner().execute(Integer.valueOf(i));
        }
    }

    private class AsyncTaskRunner extends AsyncTask<Integer, Void, Void> {
        private AsyncTaskRunner() {
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // android.os.AsyncTask
        public Void doInBackground(Integer... numArr) throws InterruptedException {
            try {
                Thread.sleep(numArr[0].intValue());
                AndroidGcmRegistrationService.this.mRegId = AndroidGcmRegistrationService.this.mGcm.register(AndroidGcmRegistrationService.SENDER_ID);
                if (AndroidGcmRegistrationService.this.mRegId == null) {
                    AndroidGcmRegistrationService.this.registerInBackground(AndroidGcmRegistrationService.RETRY_TIME);
                } else {
                    AndroidGcmRegistrationService.this.sendRegistrationIdToAws();
                }
                return null;
            } catch (Exception e) {
                AndroidGcmRegistrationService.this.registerInBackground(AndroidGcmRegistrationService.RETRY_TIME);
                return null;
            }
        }
    }

    private int getAppVersion() {
        try {
            return getPackageManager().getPackageInfo(getPackageName(), 0).versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            return 0;
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void sendRegistrationIdToAws() {
        try {
            BasicAWSCredentials basicAWSCredentials = new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY);
            Region region = Region.getRegion(Regions.US_WEST_2);
            this.mClient = new AmazonSNSClient(basicAWSCredentials);
            this.mClient.setRegion(region);
            try {
                try {
                    CreatePlatformEndpointRequest createPlatformEndpointRequest = new CreatePlatformEndpointRequest();
                    createPlatformEndpointRequest.setPlatformApplicationArn(APPLICATION_ARN);
                    createPlatformEndpointRequest.setToken(this.mRegId);
                    createPlatformEndpointRequest.setCustomUserData(getCustomData());
                    CreatePlatformEndpointResult createPlatformEndpointResultCreatePlatformEndpoint = this.mClient.createPlatformEndpoint(createPlatformEndpointRequest);
                    if (createPlatformEndpointResultCreatePlatformEndpoint != null && createPlatformEndpointResultCreatePlatformEndpoint.getEndpointArn() != null) {
                        this.mEndpointArn = createPlatformEndpointResultCreatePlatformEndpoint.getEndpointArn();
                        if (this.mEnableLogging) {
                            Log.i(TAG, "Creation EndpointArn = " + this.mEndpointArn);
                        }
                        updateSharedPref();
                    }
                } catch (InternalErrorException e) {
                    registerInBackground(RETRY_TIME);
                } catch (AmazonClientException e2) {
                } catch (AmazonServiceException e3) {
                }
            } catch (InvalidParameterException e4) {
                updateEndpointAttributes();
            }
        } catch (Exception e5) {
        }
    }

    private void updateEndpointAttributes() {
        try {
            SetEndpointAttributesRequest setEndpointAttributesRequest = new SetEndpointAttributesRequest();
            if (this.mEndpointArn == null) {
                this.mEndpointArn = PreferenceManager.getDefaultSharedPreferences(getApplicationContext()).getString(PROPERTY_ENDPOINT_ARN, "");
                if (this.mEnableLogging) {
                    Log.i(TAG, "Update EndpointArn = " + this.mEndpointArn);
                }
            }
            setEndpointAttributesRequest.setEndpointArn(this.mEndpointArn);
            HashMap map = new HashMap();
            map.put(CUSTOM_USER_DATA, getCustomData());
            map.put(ENABLED, "true");
            map.put(TOKEN, this.mRegId);
            setEndpointAttributesRequest.setAttributes(map);
            this.mClient.setEndpointAttributes(setEndpointAttributesRequest);
            updateSharedPref();
        } catch (AmazonClientException e) {
        } catch (AmazonServiceException e2) {
        }
    }

    /* JADX WARN: Removed duplicated region for block: B:23:0x010c  */
    /*
        Code decompiled incorrectly, please refer to instructions dump.
        To view partially-correct code enable 'Show inconsistent code' option in preferences
    */
    private java.lang.String getCustomData() throws org.json.JSONException {
        /*
            r8 = this;
            java.lang.String r0 = "network"
            java.lang.String r0 = "AIRDefaultActivity"
            java.lang.String r0 = "&"
            org.json.JSONObject r6 = new org.json.JSONObject     // Catch: java.lang.Exception -> L108
            r6.<init>()     // Catch: java.lang.Exception -> L108
            java.lang.String r0 = "osVersion"
            java.lang.String r1 = android.os.Build.VERSION.RELEASE     // Catch: java.lang.Exception -> L108
            r6.put(r0, r1)     // Catch: java.lang.Exception -> L108
            android.content.pm.PackageManager r0 = r8.getPackageManager()     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = r8.getPackageName()     // Catch: java.lang.Exception -> L108
            r2 = 0
            android.content.pm.PackageInfo r0 = r0.getPackageInfo(r1, r2)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "airVersion"
            java.lang.String r0 = r0.versionName     // Catch: java.lang.Exception -> L108
            r6.put(r1, r0)     // Catch: java.lang.Exception -> L108
            java.lang.StringBuilder r0 = new java.lang.StringBuilder     // Catch: java.lang.Exception -> L108
            r0.<init>()     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = android.os.Build.MODEL     // Catch: java.lang.Exception -> L108
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "&"
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = android.os.Build.MANUFACTURER     // Catch: java.lang.Exception -> L108
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "&"
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            int r1 = com.adobe.air.SystemCapabilities.GetScreenHRes(r8)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = java.lang.Integer.toString(r1)     // Catch: java.lang.Exception -> L108
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "&"
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            int r1 = com.adobe.air.SystemCapabilities.GetScreenVRes(r8)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = java.lang.Integer.toString(r1)     // Catch: java.lang.Exception -> L108
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "&"
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            int r1 = com.adobe.air.SystemCapabilities.GetScreenDPI(r8)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = java.lang.Integer.toString(r1)     // Catch: java.lang.Exception -> L108
            java.lang.StringBuilder r0 = r0.append(r1)     // Catch: java.lang.Exception -> L108
            java.lang.String r0 = r0.toString()     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "deviceInfo"
            r6.put(r1, r0)     // Catch: java.lang.Exception -> L108
            java.util.Locale r0 = java.util.Locale.getDefault()     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "locale"
            java.lang.String r2 = r0.toString()     // Catch: java.lang.Exception -> L108
            r6.put(r1, r2)     // Catch: java.lang.Exception -> L108
            java.util.Locale r1 = java.util.Locale.ENGLISH     // Catch: java.lang.Exception -> L108
            java.lang.String r7 = r0.getDisplayCountry(r1)     // Catch: java.lang.Exception -> L108
            java.lang.String r0 = "location"
            java.lang.Object r0 = r8.getSystemService(r0)     // Catch: java.lang.Exception -> Lfd
            android.location.LocationManager r0 = (android.location.LocationManager) r0     // Catch: java.lang.Exception -> Lfd
            java.lang.String r1 = "network"
            boolean r1 = r0.isProviderEnabled(r1)     // Catch: java.lang.Exception -> Lfd
            if (r1 == 0) goto L10c
            java.lang.String r1 = "network"
            android.location.Location r3 = r0.getLastKnownLocation(r1)     // Catch: java.lang.Exception -> Lfd
            android.location.Geocoder r0 = new android.location.Geocoder     // Catch: java.lang.Exception -> Lfd
            java.util.Locale r1 = java.util.Locale.ENGLISH     // Catch: java.lang.Exception -> Lfd
            r0.<init>(r8, r1)     // Catch: java.lang.Exception -> Lfd
            if (r3 == 0) goto L10c
            if (r0 == 0) goto L10c
            boolean r1 = android.location.Geocoder.isPresent()     // Catch: java.lang.Exception -> Lfd
            if (r1 == 0) goto L10c
            double r1 = r3.getLatitude()     // Catch: java.lang.Exception -> Lfd
            double r3 = r3.getLongitude()     // Catch: java.lang.Exception -> Lfd
            r5 = 1
            java.util.List r0 = r0.getFromLocation(r1, r3, r5)     // Catch: java.lang.Exception -> Lfd
            r1 = 0
            java.lang.Object r0 = r0.get(r1)     // Catch: java.lang.Exception -> Lfd
            android.location.Address r0 = (android.location.Address) r0     // Catch: java.lang.Exception -> Lfd
            java.lang.String r0 = r0.getCountryName()     // Catch: java.lang.Exception -> Lfd
        Lce:
            java.lang.String r1 = "geo"
            r6.put(r1, r0)     // Catch: java.lang.Exception -> L108
            long r0 = java.lang.System.currentTimeMillis()     // Catch: java.lang.Exception -> L108
            java.lang.String r0 = java.lang.String.valueOf(r0)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "timestamp"
            r6.put(r1, r0)     // Catch: java.lang.Exception -> L108
            android.content.Context r0 = r8.getApplicationContext()     // Catch: java.lang.Exception -> L108
            android.content.SharedPreferences r0 = android.preference.PreferenceManager.getDefaultSharedPreferences(r0)     // Catch: java.lang.Exception -> L108
            java.lang.String r1 = "AIRDefaultActivity"
            r2 = 1
            boolean r0 = r0.getBoolean(r1, r2)     // Catch: java.lang.Exception -> L108
            if (r0 == 0) goto L100
            java.lang.String r0 = "AIRDefaultActivity"
            java.lang.String r1 = "GL"
            r6.put(r0, r1)     // Catch: java.lang.Exception -> L108
        Lf8:
            java.lang.String r0 = r6.toString()     // Catch: java.lang.Exception -> L108
        Lfc:
            return r0
        Lfd:
            r0 = move-exception
            r0 = r7
            goto Lce
        L100:
            java.lang.String r0 = "AIRDefaultActivity"
            java.lang.String r1 = "PP"
            r6.put(r0, r1)     // Catch: java.lang.Exception -> L108
            goto Lf8
        L108:
            r0 = move-exception
            java.lang.String r0 = ""
            goto Lfc
        L10c:
            r0 = r7
            goto Lce
        */
        throw new UnsupportedOperationException("Method not decompiled: com.adobe.air.AndroidGcmRegistrationService.getCustomData():java.lang.String");
    }

    private void updateSharedPref() {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        int appVersion = getAppVersion();
        SharedPreferences.Editor editorEdit = defaultSharedPreferences.edit();
        editorEdit.putInt(PROPERTY_APP_VERSION, appVersion);
        editorEdit.putString(PROPERTY_ENDPOINT_ARN, this.mEndpointArn);
        editorEdit.commit();
    }
}
