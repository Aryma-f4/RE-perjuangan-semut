package com.adobe.air;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.provider.Settings;
import com.adobe.air.AndroidGcmResultReceiver;
import com.adobe.air.utils.Utils;
import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders;
import com.google.android.gms.analytics.Tracker;
import com.google.android.gms.common.GooglePlayServicesUtil;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

/* loaded from: classes.dex */
public class AdobeAIRMainActivity extends Activity implements AndroidGcmResultReceiver.Receiver {
    private static final String AIR_PROPERTIES_URL = "airPropertiesUrl";
    public static final String ENABLE_MY_GAMES = "EnableMyGames";
    public static final String ENABLE_PARTNER_ADS = "EnablePartnerAds";
    private static final String MSG_ID = "msgId";
    private static final String NEW_UI_ANALYTICS_URL = "http://www.adobe.com/airgames/3/";
    private static final String NOTIFICATION_ANALYTICS_URL = "https://www.adobe.com/gamepreview/?game=notification/notificationClicked.html_";
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    public static final String PROPERTY_DEFAULT_ACTIVITY = "AIRDefaultActivity";
    private static final String PROPERTY_ENABLE_MY_GAMES_PERCENTAGE = "MyGamesPercentage";
    private static final String PROPERTY_ENABLE_PARTNER_ADS_PERCENTAGE = "PartnerAdsPercentage";
    private static final String PROPERTY_FIRST_LAUNCH = "firstLaunch";
    private static final String PROPERTY_ID = "UA-54849355-1";
    private static final String PROPERTY_NEW_UI_PERCENTAGE = "NewUIPercentage";
    private static final String PROPERTY_RANDOM_NO = "AirRandomNumber";
    public static long RATE_LIMIT = 86400000;
    public static final String RESULT_RECEIVER = "resultReceiver";
    private static final String TAG = "AdobeAIRMainActivity";
    private int mRandomNumber;
    private Context mCtx = null;
    private int mNewUIThreshold = 75;
    private int mEnableMyGamesThreshold = 75;
    private int mEnablePartnerAdsThreshold = 75;
    private String mAirPropsFileUrl = "http://s3-us-west-1.amazonaws.com/gamepreview/prod/airandroid/air.properties";
    private boolean mIsNewUISupported = false;
    private boolean mIsGameListDefaultActivity = true;
    private AndroidGcmResultReceiver mReceiver = null;
    private AdobeAIRWebView mNotificationWebView = null;
    private AdobeAIRWebView mAnalyticsWebView = null;
    private Tracker mTracker = null;

    @Override // android.app.Activity
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        this.mCtx = this;
        copyActivityLevelPrefsToApplicationLevel();
        verifyNewUISupport();
        if (isFirstLaunch()) {
            updateSharedPrefForInitialLaunch();
            decideDefaultActivity();
            updateSharedPrefForDefaultActivity();
        } else {
            SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(this.mCtx);
            this.mIsGameListDefaultActivity = defaultSharedPreferences.getBoolean(PROPERTY_DEFAULT_ACTIVITY, true);
            if (isWidgetShown()) {
                this.mRandomNumber = 0;
                this.mIsGameListDefaultActivity = false;
                SharedPreferences.Editor editorEdit = defaultSharedPreferences.edit();
                editorEdit.putBoolean(PROPERTY_DEFAULT_ACTIVITY, this.mIsGameListDefaultActivity);
                editorEdit.commit();
            } else {
                this.mRandomNumber = defaultSharedPreferences.getInt(PROPERTY_RANDOM_NO, 100);
            }
            this.mNewUIThreshold = defaultSharedPreferences.getInt(PROPERTY_NEW_UI_PERCENTAGE, this.mNewUIThreshold);
            this.mEnableMyGamesThreshold = defaultSharedPreferences.getInt(PROPERTY_ENABLE_MY_GAMES_PERCENTAGE, this.mEnableMyGamesThreshold);
            this.mEnablePartnerAdsThreshold = defaultSharedPreferences.getInt(PROPERTY_ENABLE_PARTNER_ADS_PERCENTAGE, this.mEnablePartnerAdsThreshold);
        }
        onNewIntent(getIntent());
        Tracker tracker = getTracker();
        tracker.setScreenName(TAG);
        tracker.send(new HitBuilders.AppViewBuilder().build());
        startService(new Intent(this, (Class<?>) ShakeListenerService.class));
    }

    private void copyActivityLevelPrefsToApplicationLevel() {
        SharedPreferences.Editor editorEdit = PreferenceManager.getDefaultSharedPreferences(this.mCtx).edit();
        SharedPreferences sharedPreferences = getSharedPreferences(AdobeAIR.class.getSimpleName(), 0);
        for (Map.Entry<String, ?> entry : sharedPreferences.getAll().entrySet()) {
            Object value = entry.getValue();
            if (value instanceof String) {
                editorEdit.putString(entry.getKey(), value.toString());
            } else if (value instanceof Long) {
                editorEdit.putLong(entry.getKey(), ((Long) value).longValue());
            } else if (value instanceof Integer) {
                editorEdit.putInt(entry.getKey(), ((Integer) value).intValue());
            } else if (value instanceof Boolean) {
                editorEdit.putBoolean(entry.getKey(), ((Boolean) value).booleanValue());
            }
        }
        editorEdit.commit();
        SharedPreferences.Editor editorEdit2 = sharedPreferences.edit();
        editorEdit2.clear();
        editorEdit2.commit();
    }

    @Override // android.app.Activity
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        Bundle extras = intent.getExtras();
        if (extras != null && extras.containsKey("gameUrl")) {
            String string = extras.getString("gameUrl");
            this.mNotificationWebView = new AdobeAIRWebView(this.mCtx);
            this.mNotificationWebView.create();
            this.mNotificationWebView.loadUrl(string);
            if (extras.containsKey(MSG_ID)) {
                this.mNotificationWebView.loadAnalyticsUrl(NOTIFICATION_ANALYTICS_URL + extras.getString(MSG_ID));
            }
        } else {
            launchDefaultActivity();
        }
        decideDefaultActivityForNextLaunch();
    }

    @Override // android.app.Activity
    public void onBackPressed() {
        launchDefaultActivity();
    }

    private void launchDefaultActivity() {
        Intent intent = new Intent();
        if (this.mIsGameListDefaultActivity) {
            intent.setClassName(this, "com.adobe.air.AdobeAIR");
        } else {
            intent.setClassName(this, "com.adobe.mobile_playpanel.LeadingPageActivity");
            intent.putExtra(ENABLE_MY_GAMES, this.mRandomNumber <= this.mEnableMyGamesThreshold);
            intent.putExtra(ENABLE_PARTNER_ADS, this.mRandomNumber <= this.mEnablePartnerAdsThreshold);
            this.mAnalyticsWebView = new AdobeAIRWebView(this.mCtx);
            this.mAnalyticsWebView.createAnalyticsWebView();
            this.mAnalyticsWebView.loadAnalyticsUrl(NEW_UI_ANALYTICS_URL);
        }
        startActivity(intent);
    }

    private boolean isFirstLaunch() {
        return PreferenceManager.getDefaultSharedPreferences(this.mCtx).getBoolean(PROPERTY_FIRST_LAUNCH, true);
    }

    private void updateSharedPrefForInitialLaunch() {
        SharedPreferences.Editor editorEdit = PreferenceManager.getDefaultSharedPreferences(this.mCtx).edit();
        editorEdit.putBoolean(PROPERTY_FIRST_LAUNCH, false);
        editorEdit.commit();
    }

    /* JADX INFO: Access modifiers changed from: private */
    public void updateSharedPrefForDefaultActivity() {
        SharedPreferences.Editor editorEdit = PreferenceManager.getDefaultSharedPreferences(this.mCtx).edit();
        editorEdit.putBoolean(PROPERTY_DEFAULT_ACTIVITY, this.mIsGameListDefaultActivity);
        if (this.mIsNewUISupported) {
            editorEdit.putInt(PROPERTY_RANDOM_NO, this.mRandomNumber);
            editorEdit.putInt(PROPERTY_NEW_UI_PERCENTAGE, this.mNewUIThreshold);
            editorEdit.putInt(PROPERTY_ENABLE_MY_GAMES_PERCENTAGE, this.mEnableMyGamesThreshold);
            editorEdit.putInt(PROPERTY_ENABLE_PARTNER_ADS_PERCENTAGE, this.mEnablePartnerAdsThreshold);
        }
        editorEdit.commit();
    }

    private void decideDefaultActivity() {
        if (this.mIsNewUISupported) {
            try {
                if (isWidgetShown()) {
                    this.mRandomNumber = 0;
                } else {
                    this.mRandomNumber = generateRandomNumber();
                }
            } catch (NumberFormatException e) {
                this.mRandomNumber = 100;
            }
            this.mIsGameListDefaultActivity = this.mRandomNumber > this.mNewUIThreshold;
            return;
        }
        this.mIsGameListDefaultActivity = true;
    }

    private void verifyNewUISupport() {
        if (Build.VERSION.SDK_INT >= 10 && !Locale.getDefault().getLanguage().equalsIgnoreCase("zh")) {
            this.mIsNewUISupported = true;
        }
    }

    private int generateRandomNumber() throws NumberFormatException {
        Random random;
        if (Settings.Secure.getString(getApplicationContext().getContentResolver(), "android_id") == null) {
            random = new Random();
        } else {
            random = new Random(new Date().getTime() + r0.hashCode());
        }
        return random.nextInt(100);
    }

    private void decideDefaultActivityForNextLaunch() {
        if (this.mIsNewUISupported && Utils.isNetworkAvailable(getApplicationContext())) {
            configureTestEnv();
            new Thread(new Runnable() { // from class: com.adobe.air.AdobeAIRMainActivity.1
                @Override // java.lang.Runnable
                public void run() throws IllegalStateException, IOException {
                    try {
                        InputStream content = new DefaultHttpClient().execute(new HttpGet(AdobeAIRMainActivity.this.mAirPropsFileUrl)).getEntity().getContent();
                        Properties properties = new Properties();
                        properties.load(content);
                        if (properties != null) {
                            String property = properties.getProperty(AdobeAIRMainActivity.PROPERTY_NEW_UI_PERCENTAGE);
                            if (property != null) {
                                try {
                                    AdobeAIRMainActivity.this.mNewUIThreshold = Integer.parseInt(property);
                                    AdobeAIRMainActivity.this.mIsGameListDefaultActivity = AdobeAIRMainActivity.this.mRandomNumber > AdobeAIRMainActivity.this.mNewUIThreshold;
                                } catch (Exception e) {
                                }
                            }
                            try {
                                String property2 = properties.getProperty(AdobeAIRMainActivity.PROPERTY_ENABLE_MY_GAMES_PERCENTAGE);
                                if (property2 != null) {
                                    AdobeAIRMainActivity.this.mEnableMyGamesThreshold = Integer.parseInt(property2);
                                }
                            } catch (Exception e2) {
                            }
                            try {
                                String property3 = properties.getProperty(AdobeAIRMainActivity.PROPERTY_ENABLE_PARTNER_ADS_PERCENTAGE);
                                if (property3 != null) {
                                    AdobeAIRMainActivity.this.mEnablePartnerAdsThreshold = Integer.parseInt(property3);
                                }
                            } catch (Exception e3) {
                            }
                            AdobeAIRMainActivity.this.updateSharedPrefForDefaultActivity();
                        }
                    } catch (Exception e4) {
                    }
                }
            }).start();
        }
    }

    private void registerForNotifications() {
        this.mReceiver = new AndroidGcmResultReceiver(new Handler());
        this.mReceiver.setReceiver(this);
        Intent intent = new Intent(this.mCtx, (Class<?>) AndroidGcmRegistrationService.class);
        intent.putExtra(RESULT_RECEIVER, this.mReceiver);
        this.mCtx.startService(intent);
    }

    @Override // com.adobe.air.AndroidGcmResultReceiver.Receiver
    public void onReceiveResult(int i, Bundle bundle) {
        GooglePlayServicesUtil.getErrorDialog(i, (Activity) this.mCtx, PLAY_SERVICES_RESOLUTION_REQUEST).show();
    }

    private void configureTestEnv() {
        String string;
        try {
            Bundle bundle = getPackageManager().getActivityInfo(getComponentName(), 128).metaData;
            if (bundle != null && (string = bundle.getString(AIR_PROPERTIES_URL)) != null && !string.isEmpty()) {
                this.mAirPropsFileUrl = string;
            }
        } catch (PackageManager.NameNotFoundException e) {
        } catch (NullPointerException e2) {
        }
    }

    private boolean isWidgetShown() {
        SharedPreferences defaultSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        return defaultSharedPreferences.getBoolean("widgetShown", false) || defaultSharedPreferences.getBoolean("featuredWidgetShown", false);
    }

    private synchronized Tracker getTracker() {
        if (this.mTracker == null) {
            GoogleAnalytics googleAnalytics = GoogleAnalytics.getInstance(this);
            googleAnalytics.enableAutoActivityReports(getApplication());
            this.mTracker = googleAnalytics.newTracker(PROPERTY_ID);
        }
        return this.mTracker;
    }

    @Override // android.app.Activity
    protected void onStart() {
        super.onStart();
        GoogleAnalytics.getInstance(this).reportActivityStart(this);
    }

    @Override // android.app.Activity
    protected void onStop() {
        super.onStop();
        GoogleAnalytics.getInstance(this).reportActivityStop(this);
    }
}
